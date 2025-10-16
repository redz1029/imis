using Base.Pagination;
using Base.Primitives;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentService : IPgsDeliverableAcomplishmentService
    {
        private readonly IPgsDeliverableAccomplishmentRepository _repository;
        private readonly IBreakThroughScoringRepository _breakThroughrepository;
        private readonly UserManager<User> _userManager;       

        public PgsDeliverableAccomplishmentService(IPgsDeliverableAccomplishmentRepository repository, UserManager<User> userManager, IBreakThroughScoringRepository breakThrough)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _breakThroughrepository = breakThrough ?? throw new ArgumentNullException(nameof(breakThrough));
        }
        public async Task<DtoPageList<PgsDeliverableAccomplishmentDto, PgsDeliverableAccomplishment, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsDeliverableAccomplishmentDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsDeliverableAccomplishmentDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<PgsDeliverableAccomplishmentDto, PgsDeliverableAccomplishment, long>.Create(pgsDeliverableAccomplishmentDto.Items, page, pageSize, pgsDeliverableAccomplishmentDto.TotalCount);
        }
        public async Task<List<PgsDeliverableAccomplishmentDto>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken)
        {
            var accomplishments = await _repository.GetByDeliverableIdAsync(deliverableId, cancellationToken).ConfigureAwait(false);
            
            return accomplishments.Select(a => new PgsDeliverableAccomplishmentDto(a)).ToList();
        }
        public async Task<PgsDeliverableAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            return entity == null ? null : new PgsDeliverableAccomplishmentDto(entity);
        }
        public async Task UpdateAsync(PgsDeliverableAccomplishmentDto accomplishment, CancellationToken cancellationToken)
        {
            var entity = accomplishment.ToEntity();
            await _repository.UpdateAsync(entity, entity.Id, cancellationToken);
        }
        public async Task UpdateAttachmentPathAsync(long id, string attachmentPath, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken);
            if (entity == null)
                throw new KeyNotFoundException($"Accomplishment with Id {id} not found.");

            entity.AttachmentPath = attachmentPath;
            await _repository.UpdateAsync(entity, id, cancellationToken);
            await _repository.SaveOrUpdateAsync(entity, cancellationToken);
        }         
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is PgsDeliverableAccomplishmentDto accomplishmentDto)
            {
                var accomplishment = accomplishmentDto.ToEntity();

                if (accomplishment.Id == 0)
                    _repository.Add(accomplishment);
                else
                    await _repository.UpdateAsync(accomplishment, accomplishment.Id, cancellationToken)
                        .ConfigureAwait(false);

                await _repository.SaveOrUpdateAsync(accomplishment, cancellationToken).ConfigureAwait(false);

                var existing = await _breakThroughrepository
                    .GetByDeliverableIdAsync(accomplishment.PgsDeliverableId, cancellationToken);

                if (existing == null)
                {
                    existing = new BreakThroughScoring
                    {
                        Id = 0,
                        PgsDeliverableId = accomplishment.PgsDeliverableId
                    };
                    _breakThroughrepository.Add(existing);
                }

                existing.PercentAccomplishment = accomplishment.PercentAccomplished;              

                await _breakThroughrepository.SaveOrUpdateAsync(existing, cancellationToken);
            }
        }
    }
}
