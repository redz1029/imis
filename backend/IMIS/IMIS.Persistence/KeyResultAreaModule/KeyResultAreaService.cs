using Base.Pagination;
using Base.Primitives;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.KraModule
{
    public class KeyResultAreaService : IKeyResultAreaService
    {
        private readonly IKeyResultAreaRepository _repository;
        private readonly ImisDbContext _dbContext;
        public KeyResultAreaService(IKeyResultAreaRepository repository, ImisDbContext dbContext)
        {
            _repository = repository;
            _dbContext = dbContext;
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
                Remarks = keyResultArea.Remarks,
                IsDeleted = keyResultArea.IsDeleted
                
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
            var keyResultAreas = await _repository.GetAll(cancellationToken).ConfigureAwait(false);       
            return keyResultAreas
                .Where(x => !x.IsDeleted) 
                .Select(x => new KeyResultAreaDto(x))
                .ToList();
        }

        public async Task<List<KeyResultAreaDto>?> GetAllFilteredAsync(KeyResultAreaFilter filter, CancellationToken cancellationToken)
        {
            var result = await _repository.GetAllFilteredAsync(filter, cancellationToken);
            return result.Select(x => new KeyResultAreaDto(x)).ToList();
        }


        public async Task<KeyResultAreaDto> SaveOrUpdateAsync(KeyResultAreaDto keyResultAreaDto, CancellationToken cancellationToken)
        {
            if (keyResultAreaDto == null)
                throw new ArgumentNullException(nameof(keyResultAreaDto));

            var existingEntity = await _repository.GetByIdAsync(keyResultAreaDto.Id, cancellationToken);

            if (existingEntity == null && keyResultAreaDto.Id != 0)
                throw new InvalidOperationException("KeyResultArea not found.");

            if (existingEntity != null)
            {
             
                existingEntity.Name = keyResultAreaDto.Name;
                existingEntity.Remarks = keyResultAreaDto.Remarks!;
                existingEntity.IsDeleted = keyResultAreaDto.IsDeleted;
            }
            else
            {                
                existingEntity = keyResultAreaDto.ToEntity();
            }

            var savedEntity = await _repository.SaveOrUpdateAsync(existingEntity, cancellationToken).ConfigureAwait(false);

            return new KeyResultAreaDto(savedEntity);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)where TEntity : Entity<TId>
        {
            if (dto is not KeyResultAreaDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }      
    }
}

