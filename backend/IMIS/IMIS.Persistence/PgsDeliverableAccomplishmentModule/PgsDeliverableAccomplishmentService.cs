using Base.Pagination;
using Base.Primitives;
using Base.Utilities;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentService : IPgsDeliverableAcomplishmentService
    {
        private readonly IPgsDeliverableAccomplishmentRepository _repository;
        private readonly UserManager<User> _userManager;
        private readonly string _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";

        public PgsDeliverableAccomplishmentService(IPgsDeliverableAccomplishmentRepository repository, UserManager<User> userManager)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
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

        
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
        where TEntity : Entity<TId>
        {
            var ODto = dto as PgsDeliverableAccomplishmentDto;
            var accomplishment = ODto!.ToEntity();

            var user = await _userManager.FindByIdAsync(accomplishment.UserId);
            if (user == null)
                throw new InvalidOperationException("User not found.");

            var roles = await _userManager.GetRolesAsync(user);
            if (!roles.Any(r => r.Equals(new PgsAuditorRole().Name, StringComparison.OrdinalIgnoreCase)))
                throw new UnauthorizedAccessException("Only PGS Auditors are allowed to submit accomplishments.");

            if (accomplishment.Id == 0)
                _repository.Add(accomplishment);
            else
                await _repository.UpdateAsync(accomplishment, accomplishment.Id, cancellationToken);

            await _repository.SaveOrUpdateAsync(accomplishment, cancellationToken);
        }       
    }
}
