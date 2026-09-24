using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ISATSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Persistence.ISATSignatoryTemplateModule
{
    public class ISATSignatoryTemplateService : IISATSignatoryTemplateService
    {
        private readonly IISATSignatoryTemplateRepository _repository;

        public ISATSignatoryTemplateService(IISATSignatoryTemplateRepository repository)
        {
            _repository = repository;

        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var signatoryTemplate = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (signatoryTemplate == null)
                return false;

            signatoryTemplate.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<ISATSignatoryTemplateDto, ISATSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var isatSignatoryTemplateDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (isatSignatoryTemplateDto.TotalCount == 0)
                return null;
            return DtoPageList<ISATSignatoryTemplateDto, ISATSignatoryTemplate, int>.Create(isatSignatoryTemplateDto.Items, page, pageSize, isatSignatoryTemplateDto.TotalCount);
        }
        public async Task<ISATSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var isatSignatoryTemplateDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return isatSignatoryTemplateDto != null ? new ISATSignatoryTemplateDto(isatSignatoryTemplateDto) : null;
        }
        public async Task<List<ISATSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var isatSignatoryTemplateDto = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            if (isatSignatoryTemplateDto == null)
                return null;

            return isatSignatoryTemplateDto.Select(d => new ISATSignatoryTemplateDto(d)).ToList();
        }
        public async Task<List<ISATSignatoryTemplateDto>> SaveOrUpdateAsync(List<ISATSignatoryTemplateDto> dtoList, CancellationToken cancellationToken)
        {
            if (dtoList == null || dtoList.Count == 0)
                throw new ArgumentNullException(nameof(dtoList));

            var officeId = dtoList.First().OfficeId;

            var existingSignatories = await _repository.GetSignatoryTemplateByOfficeIdAsync(officeId, cancellationToken);

            var incomingIds = dtoList.Where(d => d.Id != 0).Select(d => d.Id).ToHashSet();

            var toRemove = existingSignatories.Where(x => !incomingIds.Contains(x.Id)).ToList();

            if (toRemove.Any())
            {
                await _repository.DeleteRangeAsync(toRemove, cancellationToken);
            }

            foreach (var dto in dtoList)
            {
                var entity = dto.ToEntity();

                if (entity.Id == 0)
                {
                    await _repository.GetDbContext().AddAsync(entity, cancellationToken);
                }
                else
                {
                    var existing = await _repository.GetDbContext()
                        .Set<ISATSignatoryTemplate>()
                        .FindAsync(new object[] { entity.Id }, cancellationToken);

                    if (existing != null)
                    {
                        existing.Status = entity.Status;
                        existing.SignatoryLabel = entity.SignatoryLabel;
                        existing.OrderLevel = entity.OrderLevel;
                        existing.DefaultSignatoryId = entity.DefaultSignatoryId;
                        existing.IsActive = entity.IsActive;
                        existing.OfficeId = entity.OfficeId;
                        existing.Position = entity.Position;

                        await _repository.UpdateAsync(existing, existing.Id, cancellationToken).ConfigureAwait(false);
                    }
                }
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            var updatedOfficeId = dtoList.First().OfficeId;
            var updatedEntities = await _repository.GetSignatoryTemplateByOfficeIdAsync(updatedOfficeId, cancellationToken);
            return updatedEntities.Select(x => new ISATSignatoryTemplateDto
            {
                Id = x.Id,
                Status = x.Status,
                SignatoryLabel = x.SignatoryLabel,
                OrderLevel = x.OrderLevel,
                DefaultSignatoryId = x.DefaultSignatoryId,
                IsActive = x.IsActive,
                OfficeId = x.OfficeId,
                Position = x.Position
            }).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {

            var ODto = dto as ISATSignatoryTemplateDto;
            var isatSignatoryTemplateDto = ODto!.ToEntity();

            if (isatSignatoryTemplateDto.Id == 0)
                _repository.Add(isatSignatoryTemplateDto);
            else
                await _repository.UpdateAsync(isatSignatoryTemplateDto, isatSignatoryTemplateDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(isatSignatoryTemplateDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
