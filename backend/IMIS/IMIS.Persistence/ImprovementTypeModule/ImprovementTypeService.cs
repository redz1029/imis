using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ImprovementTypeModule;
using IMIS.Domain;

namespace IMIS.Persistence.ImprovementTypeModule
{
    public class ImprovementTypeService : IImprovementTypeService
    {
        private readonly IImprovementTypeRepository _repository;

        public ImprovementTypeService(IImprovementTypeRepository repository)
        {
            _repository = repository;
        }

        public async Task<List<ImprovementTypeDTO>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var improvementTypes = await _repository.GetAll(cancellationToken).ConfigureAwait(false);

            if (improvementTypes == null)
                return null;

            return improvementTypes.Select(x => new ImprovementTypeDTO(x)).ToList();
        }

        public async Task<DtoPageList<ImprovementTypeDTO, ImprovementType, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var improvementTypes = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (improvementTypes.TotalCount == 0)
            {
                return null;
            }

            return DtoPageList<ImprovementTypeDTO, ImprovementType, int>.Create(improvementTypes.Items, page, pageSize, improvementTypes.TotalCount);
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var oDto = dto as ImprovementTypeDTO;
            if (oDto == null)
                throw new ArgumentException("Invalid DTO type. Expected ImprovementTypeDTO.");

            var improvementType = oDto.ToEntity();

            if (improvementType.Id == 0)
                _repository.Add(improvementType);
            else
                return UpdateAndSaveAsync(improvementType, cancellationToken);

            return _repository.SaveOrUpdateAsync(improvementType, cancellationToken);
        }

        private async Task UpdateAndSaveAsync(ImprovementType improvementType, CancellationToken cancellationToken)
        {
            await _repository.UpdateAsync(improvementType, improvementType.Id, cancellationToken).ConfigureAwait(false);
            await _repository.SaveOrUpdateAsync(improvementType, cancellationToken).ConfigureAwait(false);
        }
    }
}
