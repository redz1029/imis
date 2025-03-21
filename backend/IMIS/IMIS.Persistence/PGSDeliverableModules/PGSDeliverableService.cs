﻿using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;

namespace IMIS.Persistence.PGSModules
{
    public class PGSDeliverableService : IPGSDeliverableService
    {
        private readonly IPGSDeliverableRepository _repository;
        private readonly IKeyResultAreaRepository _kraRepository;

        public PGSDeliverableService(IPGSDeliverableRepository repository, IKeyResultAreaRepository kraRepository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _kraRepository = kraRepository ?? throw new ArgumentNullException(nameof(kraRepository));
        }

        public async Task<DtoPageList<PGSDeliverableDto, PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var PgsDeliverable = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if(PgsDeliverable.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PGSDeliverableDto, PgsDeliverable, long>.Create(PgsDeliverable.Items, page, pageSize, PgsDeliverable.TotalCount);
        }

        public async Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDto, CancellationToken cancellationToken)
        {
            if (pgsDto == null) throw new ArgumentNullException(nameof(pgsDto));

            var pgsEntity = pgsDto.ToEntity();
         
            if (pgsEntity!.Kra == null || pgsEntity.Kra.Id == 0)
            {
                throw new InvalidOperationException("Invalid kra ID");
            }
            var kra = await _kraRepository.GetByIdAsync(pgsEntity!.Kra!.Id, cancellationToken).ConfigureAwait(false);

            if (kra == null)
            {
                throw new InvalidOperationException("KRA ID not found");
            }

            pgsEntity.Kra = kra;
            var createdPgs = await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);

            return ConvertToDto(createdPgs);
        }
        public async Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsdeliverables = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsdeliverables?.Select(o => ConvertToDto(o)).ToList();
        }
        public async Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsdeliverables = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsdeliverables != null ? ConvertToDto(pgsdeliverables) : null;
        }
        private static PGSDeliverableDto ConvertToDto(PgsDeliverable deliverable)
        {
            return new PGSDeliverableDto
            {
                Id = deliverable.Id,                
                IsDirect = deliverable.IsDirect,
                DeliverableName = deliverable.DeliverableName,
                ByWhen = deliverable.ByWhen,
                PercentDeliverables = deliverable.PercentDeliverables,
                Status = deliverable.Status,
                RowVersion = deliverable.RowVersion ?? Array.Empty<byte>(),
                Remarks = deliverable.Remarks ?? string.Empty,
                KraId = deliverable.KraId,
                
                Kra = deliverable.Kra != null ? new KeyResultAreaDto
                {
                    Id = deliverable.Kra.Id,
                    Name = deliverable.Kra.Name,
                    Remarks = deliverable.Kra.Remarks ?? string.Empty
                } : null
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not PGSDeliverableDto pgsDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
