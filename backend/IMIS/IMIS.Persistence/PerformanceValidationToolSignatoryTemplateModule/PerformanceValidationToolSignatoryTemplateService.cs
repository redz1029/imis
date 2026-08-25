using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Domain;

namespace IMIS.Persistence.PerformanceValidationToolSignatoryTemplateModule
{
    public class PerformanceValidationToolSignatoryTemplateService : IPerformanceValidationToolSignatoryTemplateService
    {
        private readonly IPerformanceValidationToolSignatoryTemplateRepository _repository;

        public PerformanceValidationToolSignatoryTemplateService(IPerformanceValidationToolSignatoryTemplateRepository repository)
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
        public async Task<DtoPageList<PerformanceValidationToolSignatoryTemplateDto, PerformanceValidationToolSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsSignatoryTemplateDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsSignatoryTemplateDto.TotalCount == 0)
                return null;
            return DtoPageList<PerformanceValidationToolSignatoryTemplateDto, PerformanceValidationToolSignatoryTemplate, int>.Create(pgsSignatoryTemplateDto.Items, page, pageSize, pgsSignatoryTemplateDto.TotalCount);
        }
        public async Task<PerformanceValidationToolSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pvtSignatoryTemplateDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pvtSignatoryTemplateDto != null ? new PerformanceValidationToolSignatoryTemplateDto(pvtSignatoryTemplateDto) : null;
        }
        public async Task<List<PerformanceValidationToolSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pvtSignatoryTemplateDto = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            if (pvtSignatoryTemplateDto == null)
                return null;

            return pvtSignatoryTemplateDto.Select(d => new PerformanceValidationToolSignatoryTemplateDto(d)).ToList();
        }
       
        public async Task<List<PerformanceValidationToolSignatoryTemplateDto>> SaveOrUpdateAsync(List<PerformanceValidationToolSignatoryTemplateDto> dtoList, CancellationToken cancellationToken)
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
                        .Set<PerformanceValidationToolSignatoryTemplate>()
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
            return updatedEntities.Select(x => new PerformanceValidationToolSignatoryTemplateDto
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
                
            var ODto = dto as PerformanceValidationToolSignatoryTemplateDto;
            var pvtSignatoryTemplateDto = ODto!.ToEntity();

            if (pvtSignatoryTemplateDto.Id == 0)
                _repository.Add(pvtSignatoryTemplateDto);
            else
                await _repository.UpdateAsync(pvtSignatoryTemplateDto, pvtSignatoryTemplateDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pvtSignatoryTemplateDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
