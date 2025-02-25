using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;


namespace IMIS.Persistence.PgsModule
{   
    public class PgsAuditDetailsService(IPgsAuditDetailsRepository repository) : IPgsAuditDetailsService
    {
        private readonly IPgsAuditDetailsRepository _repository = repository;
        public async Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto PGSDto, CancellationToken cancellationToken)
        {
            if (PGSDto == null) throw new ArgumentNullException(nameof(PGSDto));
            // Convert DTO to entity
            var pgsEntity = PGSDto.ToEntity();
            // Handle Save or Update
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);            
            return new PgsAuditDetailsDto
            {
                Id = createdPgs.Id,
                Status = createdPgs.Status,
                Remarks = createdPgs.Remarks,
                PgsPeriod = createdPgs.PgsPeriod != null ? new PgsPeriodDto
                {
                    Id = createdPgs.PgsPeriod.Id,
                    StartDate = createdPgs.PgsPeriod.StartDate,
                    EndDate = createdPgs.PgsPeriod.EndDate
                } : null,
                Office = createdPgs.Office != null ? new OfficeDto
                {
                    Id = createdPgs.Office.Id,
                    Name = createdPgs.Office.Name,
                    IsActive = createdPgs.Office.IsActive
                } : null,

                PgsDeliverables = createdPgs.PgsDeliverables?
                .Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion ?? Array.Empty<byte>(),

                    Kra = deliverable.Kra != null ? new KraDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,  
                        Remarks = deliverable.Kra.Remarks 
                    } : null,
                    PGSReadinessRatingCancerCare = deliverable.PgsReadinessRatingCancerCare != null
                    ? new PGSReadinessRatingCancerCareDto
                    {
                        Id = deliverable.PgsReadinessRatingCancerCare.Id,
                        Score1 = deliverable.PgsReadinessRatingCancerCare.Score1,
                        Score2 = deliverable.PgsReadinessRatingCancerCare.Score2,
                        Score3 = deliverable.PgsReadinessRatingCancerCare.Score3,
                        TotalScore = deliverable.PgsReadinessRatingCancerCare.TotalScore
                    }
                    : null,
                    Remarks = deliverable.Remarks
                }).ToList()
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsAuditDetailsDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
