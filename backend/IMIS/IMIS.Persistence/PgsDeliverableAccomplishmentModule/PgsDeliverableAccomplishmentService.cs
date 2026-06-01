using Base.Pagination;
using Base.Primitives;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentService : IPgsDeliverableAcomplishmentService
    {
        private readonly IPgsDeliverableAccomplishmentRepository _repository;
        private readonly IPGSDeliverableRepository _deliverablerepository;
        private readonly IBreakThroughScoringRepository _breakThroughrepository;
        private readonly UserManager<User> _userManager;       

        public PgsDeliverableAccomplishmentService(IPgsDeliverableAccomplishmentRepository repository, UserManager<User> userManager, IBreakThroughScoringRepository breakThrough, IPGSDeliverableRepository deliverablerepository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _breakThroughrepository = breakThrough ?? throw new ArgumentNullException(nameof(breakThrough));
            _deliverablerepository = deliverablerepository ?? throw new ArgumentNullException(nameof(deliverablerepository));
        }

        public async Task<bool> UpdateAccomplishmentsAsync(List<ORPPgsDeliverableAccomplishmentDto> request, CancellationToken cancellationToken)
        {
            foreach (var item in request)
            {
                var entity = await _repository.GetByIdAsync(item.Id, cancellationToken);

                if (entity == null)
                    continue;

                entity.Status = item.Status;
                entity.PercentAccomplished = item.PercentAccomplished;
                entity.Remarks = item.Remarks;
                entity.AuditorRemarks = item.AuditorRemarks;
                entity.AttachmentPath = item.AttachmentPath;
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);

            return true;
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
                {
                    _repository.Add(accomplishment);
                }
                else
                {
                    await _repository.UpdateAsync(accomplishment, accomplishment.Id, cancellationToken).ConfigureAwait(false);
                }

                await _repository.SaveOrUpdateAsync(accomplishment, cancellationToken).ConfigureAwait(false);

                // UPDATE BREAKTHROUGH SCORING
                if (accomplishment.PercentAccomplished > 0)
                {
                    var existingBreakThrough = await _breakThroughrepository
                        .GetByDeliverableIdAsync(accomplishment.PgsDeliverableId,cancellationToken).ConfigureAwait(false);

                    if (existingBreakThrough == null)
                    {
                        existingBreakThrough = new BreakThroughScoring
                        {
                            Id = 0,
                            PgsDeliverableId = accomplishment.PgsDeliverableId,
                            PercentAccomplishment = accomplishment.PercentAccomplished
                        };

                        _breakThroughrepository.Add(existingBreakThrough);
                    }
                    else
                    {
                        existingBreakThrough.PercentAccomplishment = accomplishment.PercentAccomplished;
                    }

                    await _breakThroughrepository.SaveOrUpdateAsync(existingBreakThrough, cancellationToken).ConfigureAwait(false);
                }

                // UPDATE DELIVERABLE STATUS
                var deliverable = await _deliverablerepository.GetByIdAsync(accomplishment.PgsDeliverableId, cancellationToken).ConfigureAwait(false);

                if (deliverable != null)
                {
                    deliverable.Status = accomplishment.Status;
                
                    await _deliverablerepository.UpdateAsync(deliverable, deliverable.Id, cancellationToken).ConfigureAwait(false);

                    await _deliverablerepository.SaveOrUpdateAsync(deliverable, cancellationToken).ConfigureAwait(false);
                }
            }
        }

    }
}
