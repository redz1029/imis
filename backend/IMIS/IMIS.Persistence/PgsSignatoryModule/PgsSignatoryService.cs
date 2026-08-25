using Base.Primitives;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.PgsSignatoryModule
{
    public class PgsSignatoryService : IPgsSignatoryService
    {
        private readonly IPgsSignatoryRepository _repository;
        private readonly UserManager<User> _userManager;
        public PgsSignatoryService(IPgsSignatoryRepository repository, UserManager<User> userManager)
        {     
            _repository = repository;
            _userManager = userManager;
        }
        public async Task<bool> SoftDeleteSignatoryAsync(int pgsId,  CancellationToken cancellationToken)
        {
            var signatories = await _repository.GetByPgsIdForSoftDeleteAsync(pgsId, cancellationToken);

            if (!signatories.Any())
                return false;

            foreach (var signatory in signatories)
            {
                signatory.IsDeleted = true;
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<List<PgsSignatoryDto>?> GetAllPgsSignatoryId(long? pgsSignatoryId, CancellationToken cancellationToken)
        {
            var data = await _repository.GetAllPgsSignatoryId(pgsSignatoryId, cancellationToken).ConfigureAwait(false);

            if (data == null)
            {
                return null;
            }

            var result = new List<PgsSignatoryDto>();

            foreach (var item in data)
            {
                var user = await _userManager.FindByIdAsync(item.SignatoryId);

                result.Add(new PgsSignatoryDto
                {
                    Id = item.Id,
                    PgsId = item.PgsId,
                    PgsSignatoryTemplateId = item.PgsSignatoryTemplateId,
                    SignatoryId = item.SignatoryId,
                    SignatoryName = user == null ? null  : $"{user.Prefix} {user.FirstName} {user.MiddleName} {user.LastName} {user.Suffix}".Trim(),
                    DateSigned = item.DateSigned,
                });
            }

            return result;
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            throw new NotImplementedException();
        }
    }
}
