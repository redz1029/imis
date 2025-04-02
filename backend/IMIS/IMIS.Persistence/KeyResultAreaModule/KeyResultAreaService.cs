using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraModule
{
    public class KeyResultAreaService : IKeyResultAreaService
    {
        private readonly IKeyResultAreaRepository _repository;      
        public KeyResultAreaService(IKeyResultAreaRepository repository)
        {
            _repository = repository;
        }
        public async Task<List<KeyResultAreaDto>?> FilterByName(string name, int keyResultAreaNoOfResults, CancellationToken cancellationToken)
        {
            var keyResultArea = await _repository.FilterByName(name, keyResultAreaNoOfResults, cancellationToken).ConfigureAwait(false);
            return keyResultArea != null && keyResultArea.Count() > 0 ? keyResultArea.Select(a => ConvOfficeToDTO(a)).ToList() : null;
        }
        private KeyResultAreaDto ConvOfficeToDTO(KeyResultArea keyResultArea)
        {
            if (keyResultArea == null) return null;

            return new KeyResultAreaDto
            {
                Id = keyResultArea.Id,
                Name = keyResultArea.Name,
                Remarks = keyResultArea.Remarks
            };
        }
        public async Task<DtoPageList<KeyResultAreaDto, KeyResultArea, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var keyResultArea = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (keyResultArea.TotalCount == 0)
                return null;
            return DtoPageList<KeyResultAreaDto, KeyResultArea, int>.Create(keyResultArea.Items, page, pageSize, keyResultArea.TotalCount);
        }

        public async Task<KeyResultAreaDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var keyResultAreaDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return keyResultAreaDto != null ? ConvOfficeToDTO(keyResultAreaDto) : null;
        }
        public async Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken)
        {          
            var keyResultAreaDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return keyResultAreaDto?.Select(o => ConvOfficeToDTO(o)).ToList();
        }            
        public async Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto keyResultAreaDto, CancellationToken cancellationToken)
        {
            if (keyResultAreaDto == null) throw new ArgumentNullException(nameof(keyResultAreaDto));
            var keyResultAreaEntity = keyResultAreaDto.ToEntity();
            var createdKeyResultArea = await _repository.SaveOrUpdateAsync(keyResultAreaEntity, cancellationToken).ConfigureAwait(false);
            return new KeyResultAreaDto
            {
                Id = createdKeyResultArea.Id,
                Name = createdKeyResultArea.Name,
                Remarks = createdKeyResultArea.Remarks
            };
        }     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)where TEntity : Entity<TId>
        {
            if (dto is not KeyResultAreaDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }      
    }
}

