﻿using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Domain;
using static IMIS.Application.PgsModule.PgsAuditDetailsDto;

namespace IMIS.Persistence.PgsModule
{
    public class PgsAuditDetailsService : IPgsAuditDetailsService
    {
        private readonly IPgsAuditDetailsRepository _repository;
        private readonly IOfficeRepository _officeRepository;
        private readonly IPgsPeriodRepository _pgsPeriodRepository;
        private readonly IKeyResultAreaRepository _kraRepository;

        public PgsAuditDetailsService(IPgsAuditDetailsRepository repository, IOfficeRepository officeRepository, IPgsPeriodRepository pgsPeriodRepository, IKeyResultAreaRepository kraRepository)
        {
            _repository = repository;
            _officeRepository = officeRepository;
            _pgsPeriodRepository = pgsPeriodRepository;
            _kraRepository = kraRepository;
        }
        public async Task<DtoPageList<PgsAuditDetailsDto, PgsAuditDetails, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditdetails = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (auditdetails.TotalCount == 0)
                return null;
            return DtoPageList<PgsAuditDetailsDto, PgsAuditDetails, long>.Create(auditdetails.Items, page, pageSize, auditdetails.TotalCount);
        }
        // Save or Update PgsAuditDetails
        public async Task<PgsAuditDetailsDto> SaveOrUpdateAsync(PgsAuditDetailsDto PGSDto, CancellationToken cancellationToken)
        {
            if (PGSDto == null) throw new ArgumentNullException(nameof(PGSDto));

            // Convert DTO to entity
            var pgsEntity = PGSDto.ToEntity();
            pgsEntity.Office = await _officeRepository.GetByIdAsync(pgsEntity.Office.Id, cancellationToken).ConfigureAwait(false);
            pgsEntity.PgsPeriod = await _pgsPeriodRepository.GetByIdAsync(pgsEntity.PgsPeriod.Id, cancellationToken).ConfigureAwait(false);

            if (pgsEntity.PgsDeliverables != null)
            {
                foreach (var deliverable in pgsEntity.PgsDeliverables)
                {
                    deliverable.Kra = await _kraRepository.GetByIdAsync(deliverable!.Kra!.Id, cancellationToken).ConfigureAwait(false);
                }
            }
            // Handle Save or Update
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
            return new PgsAuditDetailsDto
            {
                Id = createdPgs.Id,
                Remarks = createdPgs.Remarks,
                PgsPeriod = new PgsPeriodDto
                {
                    Id = createdPgs.PgsPeriod.Id,
                    StartDate = createdPgs.PgsPeriod.StartDate,
                    EndDate = createdPgs.PgsPeriod.EndDate
                },
                Office = new OfficeDto
                {
                    Id = createdPgs.Office.Id,
                    Name = createdPgs.Office.Name,
                    IsActive = createdPgs.Office.IsActive
                },
                PgsReadinessRating = new PgsReadinessRatingDto
                {
                    Id = createdPgs.PgsReadinessRating!.Id,
                    CompetenceToDeliver = createdPgs.PgsReadinessRating.CompetenceToDeliver,
                    ResourceAvailability = createdPgs.PgsReadinessRating.ResourceAvailability,
                    ConfidenceToDeliver = createdPgs.PgsReadinessRating.ConfidenceToDeliver,
                },
                PgsDeliverables = createdPgs.PgsDeliverables?.Select(deliverable => new PGSDeliverableDto
                {
                    Id = deliverable.Id,
                    IsDirect = deliverable.IsDirect,
                    DeliverableName = deliverable.DeliverableName,
                    ByWhen = deliverable.ByWhen,
                    PercentDeliverables = deliverable.PercentDeliverables,
                    Status = deliverable.Status,
                    RowVersion = deliverable.RowVersion,
                    Kra = deliverable.Kra != null ? new KeyResultAreaDto
                    {
                        Id = deliverable.Kra.Id,
                        Name = deliverable.Kra.Name,
                        Remarks = deliverable.Kra.Remarks
                    } : null,
                    Remarks = deliverable.Remarks
                }).ToList()
            };
        }
        // Save or Update Generic Method
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsAuditDetailsDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
