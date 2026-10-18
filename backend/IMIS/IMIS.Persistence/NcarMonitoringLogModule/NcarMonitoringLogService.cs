using Base.Pagination;
using Base.Primitives;
using IMIS.Application.NcarMonitoringLogModule;
using IMIS.Domain;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.NcarMonitoringLogModule
{
    public class NcarMonitoringLogService : INcarMonitoringLogService
    {
        private readonly INcarMonitoringLogRepository _repository;

        public NcarMonitoringLogService(INcarMonitoringLogRepository repository)
        {
            _repository = repository;
        }

        public async Task<NcarMonitoringLogDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new NcarMonitoringLogDto(entity);
        }

        public async Task<DtoPageList<NcarMonitoringLogDto, NcarMonitoringLog, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedSortedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (result.TotalCount == 0) return null!;

            return DtoPageList<NcarMonitoringLogDto, NcarMonitoringLog, long>.Create(
                result.Items,
                page,
                pageSize,
                result.TotalCount);
        }

        public async Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<NcarMonitoringLogDto> SyncFromNcarAsync(long nonconformingActionReportId, string deptSectionUnit, DateTime dateIssued,
            string issuedByName, string itemNoRelevantStandard, string auditeeName, CancellationToken cancellationToken)
        {
            var dbContext = _repository.GetDbContext();
            var existing = await _repository.GetByNonconformingActionReportIdAsync(nonconformingActionReportId, cancellationToken).ConfigureAwait(false);

            if (existing != null)
            {
                existing.DeptSectionUnit = deptSectionUnit;
                existing.DateIssued = dateIssued;
                existing.IssuedByName = issuedByName;
                existing.ItemNoRelevantStandard = itemNoRelevantStandard;
                existing.AuditeeName = auditeeName;

                await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
                return new NcarMonitoringLogDto(existing);
            }

            var issuedYear = dateIssued.Year % 100;
            var sequence = await _repository.GetNextSequenceAsync(issuedYear, cancellationToken).ConfigureAwait(false);
            var ncarNo = $"{issuedYear:D2}-{sequence:D3}";

            var entity = new NcarMonitoringLog
            {
                Id = 0,
                NcarNo = ncarNo,
                IssuedYear = issuedYear,
                SequenceNo = sequence,
                NonconformingActionReportId = nonconformingActionReportId,
                DeptSectionUnit = deptSectionUnit,
                DateIssued = dateIssued,
                IssuedByName = issuedByName,
                ItemNoRelevantStandard = itemNoRelevantStandard,
                AuditeeName = auditeeName,
                Remarks = "Active"
            };

            dbContext.Add(entity);
            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return new NcarMonitoringLogDto(entity);
        }

        public async Task<bool> UpdateVerificationAsync(long id, DateTime dateVerified, string verifiedByAuditorName, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.DateVerified = dateVerified;
            entity.VerifiedByAuditorName = verifiedByAuditorName;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task<bool> UpdateValidationAsync(long id, DateTime dateValidated, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.DateValidated = dateValidated;
            entity.Remarks = "Closed";

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not NcarMonitoringLogDto mDto)
                throw new InvalidOperationException("Invalid DTO type.");

            var entity = mDto.ToEntity();
            var dbContext = _repository.GetDbContext();

            if (entity.Id == 0)
            {
                dbContext.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            mDto.Id = entity.Id;
        }
    }
}
