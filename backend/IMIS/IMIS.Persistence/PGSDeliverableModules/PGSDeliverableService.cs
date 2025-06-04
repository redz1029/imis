using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
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
            var pgsDeliverable = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken);
            if(pgsDeliverable.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PGSDeliverableDto, PgsDeliverable, long>.Create(pgsDeliverable.Items, page, pageSize, pgsDeliverable.TotalCount);
        }
        public async Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDeliverableDto, CancellationToken cancellationToken)
        {
            if (pgsDeliverableDto == null) throw new ArgumentNullException(nameof(pgsDeliverableDto));

            var pgsDeliverableEntity = pgsDeliverableDto.ToEntity();
         
            if (pgsDeliverableEntity!.Kra == null || pgsDeliverableEntity.Kra.Id == 0)
            {
                throw new InvalidOperationException("Invalid kra ID");
            }
            var keyResultArea = await _kraRepository.GetByIdAsync(pgsDeliverableEntity!.Kra!.Id, cancellationToken).ConfigureAwait(false);

            if (keyResultArea == null)
            {
                throw new InvalidOperationException("KRA ID not found");
            }

            pgsDeliverableEntity.Kra = keyResultArea;
            var createdPgsDeliverable = await _repository.SaveOrUpdateAsync(pgsDeliverableEntity, cancellationToken).ConfigureAwait(false);

            return ConvertToDto(createdPgsDeliverable);
        }
        public async Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsDeliverables = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return pgsDeliverables?.Select(o => ConvertToDto(o)).ToList();
        }
        public async Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsDeliverables = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsDeliverables != null ? ConvertToDto(pgsDeliverables) : null;
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
                KraDescription = deliverable.KraDescription ?? string.Empty,
                
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
