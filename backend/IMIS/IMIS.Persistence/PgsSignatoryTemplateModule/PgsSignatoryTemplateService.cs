using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplateService : IPgsSignatoryTemplateService
    {
        private readonly IPgsSignatoryTemplateRepository _repository;
      
        public PgsSignatoryTemplateService(IPgsSignatoryTemplateRepository repository)
        {
            _repository = repository;          
          
        }

        private static PgsSignatoryTemplateDto ConvSignatoryTemplateToDTO(PgsSignatoryTemplate signatoryTemplate)
        {
            return new PgsSignatoryTemplateDto()
            {
                Id = signatoryTemplate.Id,
                Status = signatoryTemplate.Status,
                SignatoryLabel = signatoryTemplate.SignatoryLabel,
                OrderLevel = signatoryTemplate.OrderLevel,
                DefaultSignatoryId = signatoryTemplate.DefaultSignatoryId,
                IsActive = signatoryTemplate.IsActive,
                OfficeId = signatoryTemplate.OfficeId,
                Position = signatoryTemplate.Position,
                
            };
        }
        public async Task<DtoPageList<PgsSignatoryTemplateDto, PgsSignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var pgsSignatoryTemplateDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (pgsSignatoryTemplateDto.TotalCount == 0)
                return null;
            return DtoPageList<PgsSignatoryTemplateDto, PgsSignatoryTemplate, int>.Create(pgsSignatoryTemplateDto.Items, page, pageSize, pgsSignatoryTemplateDto.TotalCount);
        }
        public async Task<PgsSignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var pgsSignatoryTemplateDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return pgsSignatoryTemplateDto != null ? ConvSignatoryTemplateToDTO(pgsSignatoryTemplateDto) : null;
        }
        public async Task<List<PgsSignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var pgsSignatoryTemplateDto = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return pgsSignatoryTemplateDto?.Select(t => ConvSignatoryTemplateToDTO(t)).ToList();
        }

        public async Task<List<PgsSignatoryTemplateDto>> SaveOrUpdateAsync(List<PgsSignatoryTemplateDto> dtoList, CancellationToken cancellationToken)
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
                   
                    var existing = existingSignatories.FirstOrDefault(x => x.Id == entity.Id);
                    if (existing != null)
                    {                       
                        existing.Status = entity.Status;
                        existing.SignatoryLabel = entity.SignatoryLabel;
                        existing.OrderLevel = entity.OrderLevel;
                        existing.DefaultSignatoryId = entity.DefaultSignatoryId;
                        existing.IsActive = entity.IsActive;
                        existing.OfficeId = entity.OfficeId;
                        existing.Position = entity.Position;    
                        
                        await _repository.UpdateAsync(existing, existing.Id, cancellationToken).ConfigureAwait(false); ;
                    }
                }
            }
           
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken).ConfigureAwait(false); ;
         
            var updatedEntities = await _repository.GetSignatoryTemplateByOfficeIdAsync(officeId, cancellationToken);

            return updatedEntities.Select(x => new PgsSignatoryTemplateDto
            {
                Id = x.Id,
                Status = x.Status,
                SignatoryLabel = x.SignatoryLabel,
                OrderLevel = x.OrderLevel,
                DefaultSignatoryId = x.DefaultSignatoryId,
                IsActive = x.IsActive,
                OfficeId = x.OfficeId,
                Position = x.Position,
            }).ToList();
        }   

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
          
            var ODto = dto as PgsSignatoryTemplateDto;
            var pgsSignatoryTemplateDto = ODto!.ToEntity();

            if (pgsSignatoryTemplateDto.Id == 0)
                _repository.Add(pgsSignatoryTemplateDto);
            else
                await _repository.UpdateAsync(pgsSignatoryTemplateDto, pgsSignatoryTemplateDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(pgsSignatoryTemplateDto, cancellationToken).ConfigureAwait(false);
        }

        public async Task<List<PgsSignatoryTemplateDto>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            var signatoryTemplate = await _repository.GetSignatoryTemplateByOfficeIdAsync(officeId, cancellationToken).ConfigureAwait(false);
            return [.. signatoryTemplate.Select(e => new PgsSignatoryTemplateDto(e))];
        }
    }
}
