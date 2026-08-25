using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditPlanModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanService : IAuditPlanService
    {
        private readonly IAuditPlanRepository _repository;

        public AuditPlanService(IAuditPlanRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditPlanAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not AuditPlanDto aDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = aDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                // 1. BRAND NEW AUDIT PLAN
                // Fix: push StartDate/EndDate onto any schedules that came in on the same payload
                // before EF assigns identities, so the insert already carries correct dates.
                entity.SyncScheduleDates();

                dbContext.Add(entity);
                await dbContext.SaveChangesAsync(cancellationToken);
            }
            else
            {
                // 2. EXISTING AUDIT PLAN UPDATE
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken);
                if (existing == null) throw new KeyNotFoundException("Audit Plan not found.");

                dbContext.Entry(existing).CurrentValues.SetValues(entity);

                // --- Sync Approvals Collection ---
                existing.Approvals ??= new List<AuditPlanApproval>();
                entity.Approvals ??= new List<AuditPlanApproval>();

                var approvalsToRemove = existing.Approvals
                    .Where(ea => !entity.Approvals.Any(ia => ia.Id == ea.Id && ea.Id != 0)).ToList();
                foreach (var approval in approvalsToRemove)
                {
                    existing.Approvals.Remove(approval);
                    dbContext.Set<AuditPlanApproval>().Remove(approval);
                }
                foreach (var incomingApproval in entity.Approvals)
                {
                    var existingApproval = existing.Approvals.FirstOrDefault(ea => ea.Id == incomingApproval.Id && ea.Id != 0);
                    if (existingApproval == null)
                        existing.Approvals.Add(incomingApproval);
                    else
                        dbContext.Entry(existingApproval).CurrentValues.SetValues(incomingApproval);
                }

                // --- Sync AuditSchedules Collection ---
                // Fix: same add/update/remove pattern as Approvals, so schedules linked to this
                // plan on the incoming payload are kept in sync with the DB.
                existing.AuditSchedules ??= new List<AuditSchedule>();
                entity.AuditSchedules ??= new List<AuditSchedule>();

                var schedulesToRemove = existing.AuditSchedules
                    .Where(es => !entity.AuditSchedules.Any(is_ => is_.Id == es.Id && es.Id != 0)).ToList();
                foreach (var schedule in schedulesToRemove)
                {
                    existing.AuditSchedules.Remove(schedule);
                    dbContext.Set<AuditSchedule>().Remove(schedule);
                }
                foreach (var incomingSchedule in entity.AuditSchedules)
                {
                    var existingSchedule = existing.AuditSchedules.FirstOrDefault(es => es.Id == incomingSchedule.Id && es.Id != 0);
                    if (existingSchedule == null)
                    {
                        incomingSchedule.AuditPlanId = existing.Id;
                        existing.AuditSchedules.Add(incomingSchedule);
                    }
                    else
                    {
                        dbContext.Entry(existingSchedule).CurrentValues.SetValues(incomingSchedule);
                    }
                }

                // --- Sync Entries & Deep Sub-Collections ---
                existing.Entries ??= new List<AuditPlanEntry>();
                entity.Entries ??= new List<AuditPlanEntry>();

                var entriesToRemove = existing.Entries
                    .Where(ee => !entity.Entries.Any(ie => ie.Id == ee.Id && ee.Id != 0)).ToList();
                foreach (var entry in entriesToRemove)
                {
                    existing.Entries.Remove(entry);
                    dbContext.Set<AuditPlanEntry>().Remove(entry);
                }

                foreach (var incomingEntry in entity.Entries)
                {
                    var existingEntry = existing.Entries.FirstOrDefault(ee => ee.Id == incomingEntry.Id && ee.Id != 0);

                    if (existingEntry == null)
                    {
                        incomingEntry.AuditPlanId = existing.Id;
                        existing.Entries.Add(incomingEntry);
                    }
                    else
                    {
                        dbContext.Entry(existingEntry).CurrentValues.SetValues(incomingEntry);
                        SyncEntryGrandchildCollections(dbContext, existingEntry, incomingEntry);
                    }
                }

                // Fix: push the (possibly just-updated) StartDate/EndDate onto every linked
                // schedule right before the terminal save, so plan and schedule dates never drift.
                existing.SyncScheduleDates();

                await dbContext.SaveChangesAsync(cancellationToken);
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

            var processesToRemove = existingEntry.IsoAuditProcesses.Where(ep => !incomingEntry.IsoAuditProcesses.Any(ip => ip.Id == ep.Id && ep.Id != 0)).ToList();
            foreach (var p in processesToRemove) { existingEntry.IsoAuditProcesses.Remove(p); dbContext.Set<IsoAuditProcess>().Remove(p); }
            foreach (var incomingP in incomingEntry.IsoAuditProcesses)
            {
                var existingP = existingEntry.IsoAuditProcesses.FirstOrDefault(ep => ep.Id == incomingP.Id && ep.Id != 0);
                if (existingP == null) { incomingP.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditProcesses.Add(incomingP); }
                else dbContext.Entry(existingP).CurrentValues.SetValues(incomingP);
            }

            var personsToRemove = existingEntry.ResponsiblePersons.Where(er => !incomingEntry.ResponsiblePersons.Any(ir => ir.Id == er.Id && er.Id != 0)).ToList();
            foreach (var p in personsToRemove) { existingEntry.ResponsiblePersons.Remove(p); dbContext.Set<AuditPlanPersonResponsible>().Remove(p); }
            foreach (var incomingRp in incomingEntry.ResponsiblePersons)
            {
                var existingRp = existingEntry.ResponsiblePersons.FirstOrDefault(er => er.Id == incomingRp.Id && er.Id != 0);
                if (existingRp == null) { incomingRp.AuditPlanEntryId = existingEntry.Id; existingEntry.ResponsiblePersons.Add(incomingRp); }
                else dbContext.Entry(existingRp).CurrentValues.SetValues(incomingRp);
            }

            var auditorsToRemove = existingEntry.IsoAuditors.Where(ea => !incomingEntry.IsoAuditors.Any(ia => ia.Id == ea.Id && ea.Id != 0)).ToList();
            foreach (var a in auditorsToRemove) { existingEntry.IsoAuditors.Remove(a); dbContext.Set<IsoAuditor>().Remove(a); }
            foreach (var incomingA in incomingEntry.IsoAuditors)
            {
                var existingA = existingEntry.IsoAuditors.FirstOrDefault(ea => ea.Id == incomingA.Id && ea.Id != 0);
                if (existingA == null) { incomingA.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoAuditors.Add(incomingA); }
                else dbContext.Entry(existingA).CurrentValues.SetValues(incomingA);
            }

            var standardsToRemove = existingEntry.IsoStandardAuditPlans.Where(es => !incomingEntry.IsoStandardAuditPlans.Any(isPlan => isPlan.Id == es.Id && es.Id != 0)).ToList();
            foreach (var s in standardsToRemove) { existingEntry.IsoStandardAuditPlans.Remove(s); dbContext.Set<IsoStandardAuditPlan>().Remove(s); }
            foreach (var incomingS in incomingEntry.IsoStandardAuditPlans)
            {
                var existingS = existingEntry.IsoStandardAuditPlans.FirstOrDefault(es => es.Id == incomingS.Id && es.Id != 0);
                if (existingS == null) { incomingS.AuditPlanEntryId = existingEntry.Id; existingEntry.IsoStandardAuditPlans.Add(incomingS); }
                else dbContext.Entry(existingS).CurrentValues.SetValues(incomingS);
            }

            var appToRemove = existingEntry.AuditPlanProcesses.Where(eap => !incomingEntry.AuditPlanProcesses.Any(iap => iap.Id == eap.Id && iap.Id != 0)).ToList();
            foreach (var ap in appToRemove) { existingEntry.AuditPlanProcesses.Remove(ap); dbContext.Set<AuditPlanProcess>().Remove(ap); }
            foreach (var incomingAp in incomingEntry.AuditPlanProcesses)
            {
                var existingAp = existingEntry.AuditPlanProcesses.FirstOrDefault(eap => eap.Id == incomingAp.Id && eap.Id != 0);
                if (existingAp == null) { incomingAp.AuditPlanEntryId = existingEntry.Id; existingEntry.AuditPlanProcesses.Add(incomingAp); }
                else dbContext.Entry(existingAp).CurrentValues.SetValues(incomingAp);
            }
        }

        public async Task<List<AuditPlanDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken);
            return entities?.Select(e => new AuditPlanDto(e)).ToList();
        }

        public async Task<AuditPlanDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity != null ? new AuditPlanDto(entity) : null;
        }

        public async Task<List<string>> GetConflictValidationsAsync(AuditPlanDto dto, CancellationToken cancellationToken)
        {
            var errors = new List<string>();
            if (dto.StartDate > dto.EndDate)
                errors.Add("Start date cannot be greater than end date.");
            if (string.IsNullOrWhiteSpace(dto.PlanStatus))
                errors.Add("PlanStatus is required.");
            if (dto.Entries == null || !dto.Entries.Any())
                errors.Add("At least one Audit Plan Entry is required.");
            return errors;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null) return false;
            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }

        public async Task<DtoPageList<AuditPlanDto, AuditPlan, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if (result.TotalCount == 0) return null;
            return DtoPageList<AuditPlanDto, AuditPlan, int>.Create(result.Items, page, pageSize, result.TotalCount);
        }
    }
}