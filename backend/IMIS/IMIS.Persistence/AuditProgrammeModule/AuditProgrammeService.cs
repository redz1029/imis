using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeService : IAuditProgrammeService
    {
        private readonly IAuditProgrammeRepository _repository;

        public AuditProgrammeService(IAuditProgrammeRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditProgrammeAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;

            var errors = await GetConflictValidationsAsync(dto, cancellationToken);
            if (errors.Any())
                throw new InvalidOperationException(string.Join(" ", errors));

            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
             where TEntity : Entity<TId>
        {
            if (dto is not AuditProgrammeDto pDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = pDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                // BRAND NEW AUDIT PROGRAMME
                // Let EF handle the natural auto-assignment of identities recursively down to grandchildren
                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);
            }
            else
            {
                // EXISTING AUDIT PROGRAMME UPDATE
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Programme not found.");

                // Update root primitive fields
                dbContext.Entry(existing).CurrentValues.SetValues(entity);

                // --- Sync Objectives Collection ---
                if (existing.Objectives?.Any() == true)
                {
                    _repository.RemoveObjectives(existing.Objectives.ToList());
                }
                existing.Objectives = entity.Objectives;

                // --- Sync Audit Plans & Deep Sub-Collections Safely ---
                existing.AuditPlans ??= new List<AuditPlan>();
                entity.AuditPlans ??= new List<AuditPlan>();

                var plansToRemove = existing.AuditPlans
                    .Where(ep => !entity.AuditPlans.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();

                foreach (var plan in plansToRemove)
                {
                    existing.AuditPlans.Remove(plan);
                    dbContext.Set<AuditPlan>().Remove(plan);
                }

                foreach (var incomingPlan in entity.AuditPlans)
                {
                    var existingPlan = existing.AuditPlans.FirstOrDefault(ep => ep.Id == incomingPlan.Id && ep.Id != 0);

                    if (existingPlan == null)
                    {
                        // Explicitly bind relationship link so child entries know their root scope
                        incomingPlan.AuditProgrammeId = existing.Id;
                        existing.AuditPlans.Add(incomingPlan);
                    }
                    else
                    {
                        // Update existing plan row data cells
                        dbContext.Entry(existingPlan).CurrentValues.SetValues(incomingPlan);

                        // Synchronize child entries and grandchildren
                        SyncAuditPlanEntries(dbContext, existingPlan, incomingPlan);
                    }
                }

                // Unified save pipeline commit execution
                await dbContext.SaveChangesAsync(cancellationToken);
            }
        }

        private void SyncAuditPlanEntries(DbContext dbContext, AuditPlan existingPlan, AuditPlan incomingPlan)
        {
            existingPlan.Entries ??= new List<AuditPlanEntry>();
            incomingPlan.Entries ??= new List<AuditPlanEntry>();

            var entriesToRemove = existingPlan.Entries
                .Where(ee => !incomingPlan.Entries.Any(ie => ie.Id == ee.Id && ee.Id != 0)).ToList();

            foreach (var entry in entriesToRemove)
            {
                existingPlan.Entries.Remove(entry);
                dbContext.Set<AuditPlanEntry>().Remove(entry);
            }

            foreach (var incomingEntry in incomingPlan.Entries)
            {
                var existingEntry = existingPlan.Entries.FirstOrDefault(ee => ee.Id == incomingEntry.Id && ee.Id != 0);

                if (existingEntry == null)
                {
                    incomingEntry.AuditPlanId = existingPlan.Id;
                    existingPlan.Entries.Add(incomingEntry);
                }
                else
                {
                    dbContext.Entry(existingEntry).CurrentValues.SetValues(incomingEntry);

                    // Synchronize deep arrays (Grandchildren Leaf collections)
                    SyncEntryGrandchildCollections(dbContext, existingEntry, incomingEntry);
                }
            }
        }

        private void SyncEntryGrandchildCollections(DbContext dbContext, AuditPlanEntry existingEntry, AuditPlanEntry incomingEntry)
        {
            existingEntry.IsoAuditProcesses ??= new List<IsoAuditProcess>();
            incomingEntry.IsoAuditProcesses ??= new List<IsoAuditProcess>();

            existingEntry.ResponsiblePersons ??= new List<AuditPlanPersonResponsible>();
            incomingEntry.ResponsiblePersons ??= new List<AuditPlanPersonResponsible>();

            existingEntry.IsoAuditors ??= new List<IsoAuditor>();
            incomingEntry.IsoAuditors ??= new List<IsoAuditor>();

            existingEntry.IsoStandardAuditPlans ??= new List<IsoStandardAuditPlan>();
            incomingEntry.IsoStandardAuditPlans ??= new List<IsoStandardAuditPlan>();

            existingEntry.AuditPlanProcesses ??= new List<AuditPlanProcess>();
            incomingEntry.AuditPlanProcesses ??= new List<AuditPlanProcess>();

            // 1. IsoAuditProcesses
            var processesToRemove = existingEntry.IsoAuditProcesses.Where(ep => !incomingEntry.IsoAuditProcesses.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();
            foreach (var p in processesToRemove) { existingEntry.IsoAuditProcesses.Remove(p); dbContext.Set<IsoAuditProcess>().Remove(p); }
            foreach (var incomingP in incomingEntry.IsoAuditProcesses)
            {
                var existingP = existingEntry.IsoAuditProcesses.FirstOrDefault(ep => ep.Id == incomingP.Id && ep.Id != 0);
                if (existingP == null) { incomingP.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditProcesses.Add(incomingP); }
                else dbContext.Entry(existingP).CurrentValues.SetValues(incomingP);
            }

            // 2. ResponsiblePersons
            var personsToRemove = existingEntry.ResponsiblePersons.Where(er => !incomingEntry.ResponsiblePersons.Any(ir => ir.Id == er.Id && er.Id != 0)).ToList();
            foreach (var p in personsToRemove) { existingEntry.ResponsiblePersons.Remove(p); dbContext.Set<AuditPlanPersonResponsible>().Remove(p); }
            foreach (var incomingRp in incomingEntry.ResponsiblePersons)
            {
                var existingRp = existingEntry.ResponsiblePersons.FirstOrDefault(er => er.Id == incomingRp.Id && er.Id != 0);
                if (existingRp == null) { incomingRp.AuditPlanEntryId = existingEntry.Id; existingEntry.ResponsiblePersons.Add(incomingRp); }
                else dbContext.Entry(existingRp).CurrentValues.SetValues(incomingRp);
            }

            // 3. IsoAuditors
            var auditorsToRemove = existingEntry.IsoAuditors.Where(ea => !incomingEntry.IsoAuditors.Any(ia => ia.Id == ea.Id && ea.Id != 0)).ToList();
            foreach (var a in auditorsToRemove) { existingEntry.IsoAuditors.Remove(a); dbContext.Set<IsoAuditor>().Remove(a); }
            foreach (var incomingA in incomingEntry.IsoAuditors)
            {
                var existingA = existingEntry.IsoAuditors.FirstOrDefault(ea => ea.Id == incomingA.Id && ea.Id != 0);
                if (existingA == null) { incomingA.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditors.Add(incomingA); }
                else dbContext.Entry(existingA).CurrentValues.SetValues(incomingA);
            }

            // 4. IsoStandardAuditPlans (Handles long identity keys safely)
            var standardsToRemove = existingEntry.IsoStandardAuditPlans.Where(es => !incomingEntry.IsoStandardAuditPlans.Any(isPlan => isPlan.Id == es.Id && es.Id != 0)).ToList();
            foreach (var s in standardsToRemove) { existingEntry.IsoStandardAuditPlans.Remove(s); dbContext.Set<IsoStandardAuditPlan>().Remove(s); }
            foreach (var incomingS in incomingEntry.IsoStandardAuditPlans)
            {
                var existingS = existingEntry.IsoStandardAuditPlans.FirstOrDefault(es => es.Id == incomingS.Id && es.Id != 0);
                if (existingS == null) { incomingS.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoStandardAuditPlans.Add(incomingS); }
                else dbContext.Entry(existingS).CurrentValues.SetValues(incomingS);
            }

            // 5. AuditPlanProcesses
            var appToRemove = existingEntry.AuditPlanProcesses.Where(eap => !incomingEntry.AuditPlanProcesses.Any(iap => iap.Id == eap.Id && iap.Id != 0)).ToList();
            foreach (var ap in appToRemove) { existingEntry.AuditPlanProcesses.Remove(ap); dbContext.Set<AuditPlanProcess>().Remove(ap); }
            foreach (var incomingAp in incomingEntry.AuditPlanProcesses)
            {
                var existingAp = existingEntry.AuditPlanProcesses.FirstOrDefault(eap => eap.Id == incomingAp.Id && eap.Id != 0);
                if (existingAp == null) { incomingAp.AuditPlanEntryId = existingEntry.Id; existingEntry.AuditPlanProcesses.Add(incomingAp); }
                else dbContext.Entry(existingAp).CurrentValues.SetValues(incomingAp);
            }
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditProgrammeDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();

            if (dto.Year < 2000 || dto.Year > 2100)
                errors.Add("Please provide a valid audit year.");

            if (dto.Objectives == null || !dto.Objectives.Any())
                errors.Add("An audit programme must have at least one objective.");

            return await Task.FromResult(errors);
        }

        public async Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if (result == null || result.TotalCount == 0) return null!;

            return DtoPageList<AuditProgrammeDto, AuditProgramme, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken);
            return entity != null ? new AuditProgrammeDto(entity) : null;
        }

        public async Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditProgrammeDto(e)).ToList() ?? new List<AuditProgrammeDto>();
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}