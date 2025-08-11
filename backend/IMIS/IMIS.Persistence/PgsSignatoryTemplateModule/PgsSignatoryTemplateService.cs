using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Application.PgsSignatoryTemplateModule
{
    public class PgsSignatoryTemplateService : IPgsSignatoryTemplateService
    {
        private readonly IPgsSignatoryTemplateRepository _repository;    
        private readonly ImisDbContext _dbContext;

        public PgsSignatoryTemplateService(IPgsSignatoryTemplateRepository repository, ImisDbContext dbContext)
        {
            _repository = repository;          
            _dbContext = dbContext;
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
                OfficeId = signatoryTemplate.OfficeId 
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

            // Get all existing signatories for the office
            var existingSignatories = await _dbContext.PgsSignatoryTemplate
                .Where(x => x.OfficeId == officeId)
                .ToListAsync(cancellationToken);

            var incomingIds = dtoList
                .Where(d => d.Id != 0)
                .Select(d => d.Id)
                .ToHashSet();

            // Remove records not included in the new dtoList
            var toRemove = existingSignatories
                .Where(x => !incomingIds.Contains(x.Id))
                .ToList();

            if (toRemove.Any())
            {
                _dbContext.PgsSignatoryTemplate.RemoveRange(toRemove);
            }

            foreach (var dto in dtoList)
            {
                var entity = dto.ToEntity();

                if (entity.Id == 0)
                {
                    // New record
                    await _dbContext.PgsSignatoryTemplate.AddAsync(entity, cancellationToken);
                }
                else
                {
                    // Update existing record
                    var existing = existingSignatories.FirstOrDefault(x => x.Id == entity.Id);
                    if (existing != null)
                    {
                        _dbContext.Entry(existing).CurrentValues.SetValues(entity);
                    }
                }
            }

            // Save changes add/update
            await _dbContext.SaveChangesAsync(cancellationToken);

            // Return updated DTO list
            var updated = await _dbContext.PgsSignatoryTemplate
                .Where(x => x.OfficeId == officeId)
                .Select(x => new PgsSignatoryTemplateDto
                {
                    Id = x.Id,
                    Status = x.Status,
                    SignatoryLabel = x.SignatoryLabel,
                    OrderLevel = x.OrderLevel,
                    DefaultSignatoryId = x.DefaultSignatoryId,
                    IsActive = x.IsActive,
                    OfficeId = x.OfficeId
                })
                .ToListAsync(cancellationToken);

            return updated;
        }


        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsSignatoryTemplateDto pgsSignatoryTemplateDto)
                throw new ArgumentException("Invalid Pgs Signatory Template Dto type", nameof(dto));

            var pgsSignatoryTemplateEntity = pgsSignatoryTemplateDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsSignatoryTemplateEntity, cancellationToken);
        }

        public async Task<List<PgsSignatoryTemplateDto>> GetSignatoryTemplateByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            var signatoryTemplate = await _repository.GetSignatoryTemplateByOfficeIdAsync(officeId, cancellationToken).ConfigureAwait(false);
            return [.. signatoryTemplate.Select(e => new PgsSignatoryTemplateDto(e))];
        }
    }
}
