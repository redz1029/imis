using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditReportModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditReportModule
{
    public class AuditReportService : IAuditReportService
    {
        private readonly IAuditReportRepository _repository;

        public AuditReportService(IAuditReportRepository repository)
        {
            _repository = repository;
        }

        public async Task<bool> SaveAuditReportAsync(AuditReportDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) return false;
            await SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
    where TEntity : Entity<TId>
        {
            if (dto is not AuditReportDto aDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = aDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                dbContext.Add(entity);

                var addedEntry = dbContext.Entry(entity);
                addedEntry.Property<int?>("AuditeeId").CurrentValue = aDto.AuditeeId;
                addedEntry.Property<int?>("OfficeAuditedId").CurrentValue = aDto.OfficeAuditedId;
                addedEntry.Property<long?>("AuditStandardISOId").CurrentValue = aDto.AuditStandardISOId;
                addedEntry.Property<int?>("AuditPlanEntryId").CurrentValue = aDto.AuditPlanEntryId;
            }
            else
            {
                var existing = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken).ConfigureAwait(false);
                if (existing != null)
                {
                    if (existing.AuditComFindings?.Any() == true)
                        dbContext.Set<AuditComFindings>().RemoveRange(existing.AuditComFindings);

                    if (existing.AuditScope?.Any() == true)
                        dbContext.Set<AuditScope>().RemoveRange(existing.AuditScope);

                    if (existing.AuditSummaryFIndings?.Any() == true)
                        dbContext.Set<AuditSummaryFIndings>().RemoveRange(existing.AuditSummaryFIndings);

                    dbContext.Entry(existing).CurrentValues.SetValues(entity);

                    var existingEntry = dbContext.Entry(existing);
                    existingEntry.Property<int?>("AuditeeId").CurrentValue = aDto.AuditeeId;
                    existingEntry.Property<int?>("OfficeAuditedId").CurrentValue = aDto.OfficeAuditedId;
                    existingEntry.Property<long?>("AuditStandardISOId").CurrentValue = aDto.AuditStandardISOId;
                    existingEntry.Property<int?>("AuditPlanEntryId").CurrentValue = aDto.AuditPlanEntryId;
                }
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            aDto.Id = entity.Id;
        }

        public async Task<AuditReportDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new AuditReportDto(entity) : null;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<DtoPageList<AuditReportDto, AuditReport, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (result.TotalCount == 0) return null!;

            // Uses explicit raw database collection arrays to perfectly satisfy base signatures
            return DtoPageList<AuditReportDto, AuditReport, int>.Create(
                result.Items,
                page,
                pageSize,
                result.TotalCount);
        }
    }
}