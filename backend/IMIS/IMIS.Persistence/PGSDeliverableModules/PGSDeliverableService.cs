using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;

namespace IMIS.Persistence.PGSModules
{
    public class PGSDeliverableService(IPGSDeliverableRepository repository) : IPGSDeliverableService
    {
        private readonly IPGSDeliverableRepository _repository = repository;

        public async Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDto, CancellationToken cancellationToken)
        {
            if (pgsDto == null) throw new ArgumentNullException(nameof(pgsDto));

            var pgsEntity = pgsDto.ToEntity();
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);

            return new PGSDeliverableDto
            {
                Id = createdPgs.Id,
                IsDirect = createdPgs.IsDirect,
                DeliverableName = createdPgs.DeliverableName,
                ByWhen = createdPgs.ByWhen,
                PercentDeliverables = createdPgs.PercentDeliverables,
                Status = createdPgs.Status,
                RowVersion = createdPgs.RowVersion ?? Array.Empty<byte>(),
                Remarks = createdPgs.Remarks ?? string.Empty,

                Kra = createdPgs.Kra != null ? new KraDto
                {
                    Id = createdPgs.Kra.Id,
                    Name = createdPgs.Kra.Name,
                    Remarks = createdPgs.Kra.Remarks ?? string.Empty
                } : null,

                PgsAuditDetails = createdPgs.PgsAuditDetails != null ? new PgsAuditDetailsDto
                {
                    Id = createdPgs.PgsAuditDetails.Id,
                    Status = createdPgs.PgsAuditDetails.Status,
                    Remarks = createdPgs.PgsAuditDetails.Remarks ?? string.Empty,
                    Office = new OfficeDto
                    {
                        Id = createdPgs.PgsAuditDetails.Office.Id,
                        Name = createdPgs.PgsAuditDetails.Office.Name,
                        IsActive = createdPgs.PgsAuditDetails.Office.IsActive
                    }
                } : null,

                PGSReadinessRatingCancerCare = createdPgs.PgsReadinessRatingCancerCare != null
                ? new PGSReadinessRatingCancerCareDto
                {
                    Id = createdPgs.PgsReadinessRatingCancerCare.Id,
                    Score1 = createdPgs.PgsReadinessRatingCancerCare.Score1,
                    Score2 = createdPgs.PgsReadinessRatingCancerCare.Score2,
                    Score3 = createdPgs.PgsReadinessRatingCancerCare.Score3,
                    TotalScore = createdPgs.PgsReadinessRatingCancerCare.TotalScore
                }
                : null

            };
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PGSDeliverableDto pgsDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
