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
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var kra = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (kra == null)
                return false;

            kra.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<List<KeyResultAreaDto>?> FilterByName(string name, int keyResultAreaNoOfResults, CancellationToken cancellationToken)
        {
            var keyResultArea = await _repository.FilterByName(name, keyResultAreaNoOfResults, cancellationToken).ConfigureAwait(false);     
            return keyResultArea != null && keyResultArea.Count() > 0 ? keyResultArea.Select(a => new KeyResultAreaDto(a)).ToList() : null;
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
            return keyResultAreaDto != null ? new KeyResultAreaDto(keyResultAreaDto) : null;
        }
        public async Task<List<KeyResultAreaDto>?> GetAllAsync(CancellationToken cancellationToken)
        {          
            var keyResultAreaDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (keyResultAreaDto == null)
                return null;

            return keyResultAreaDto.Select(o => new KeyResultAreaDto(o)).ToList();
        }                   
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)where TEntity : Entity<TId>
        {
          
            var ODto = dto as KeyResultAreaDto;
            var keyResultAreaDto = ODto!.ToEntity();

            if (keyResultAreaDto.Id == 0)
                _repository.Add(keyResultAreaDto);
            else
                await _repository.UpdateAsync(keyResultAreaDto, keyResultAreaDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(keyResultAreaDto, cancellationToken).ConfigureAwait(false);
        }      
    }
}

