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
        public async Task<PgsSignatoryTemplateDto> SaveOrUpdateAsync(PgsSignatoryTemplateDto pgsSignatoryTemplateDto, CancellationToken cancellationToken)
        {
            if (pgsSignatoryTemplateDto == null) throw new ArgumentNullException(nameof(pgsSignatoryTemplateDto));

            var pgsSignatoryTemplateEntity = pgsSignatoryTemplateDto.ToEntity();
            // Handle Save or Update
            var createdPgsSignatoryTemplate = await _repository.SaveOrUpdateAsync(pgsSignatoryTemplateEntity, cancellationToken);

            return new PgsSignatoryTemplateDto
            {
                Id = createdPgsSignatoryTemplate.Id,
                Status = createdPgsSignatoryTemplate.Status,
                SignatoryLabel = createdPgsSignatoryTemplate.SignatoryLabel,
                OrderLevel = createdPgsSignatoryTemplate.OrderLevel,
                DefaultSignatoryId = createdPgsSignatoryTemplate.DefaultSignatoryId,
                IsActive = createdPgsSignatoryTemplate.IsActive,
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsSignatoryTemplateDto pgsSignatoryTemplateDto)
                throw new ArgumentException("Invalid Pgs Signatory Template Dto type", nameof(dto));

            var pgsSignatoryTemplateEntity = pgsSignatoryTemplateDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsSignatoryTemplateEntity, cancellationToken);
        }
    }
}
