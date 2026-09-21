using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IndividualStrategicAlignmentTreePeriodModule;
using IMIS.Domain;

namespace IMIS.Persistence.ISATPeriodModule
{
    public class ISATPeriodService : IISATPeriodService
    {
        private readonly IISATPeriodRepository _repository;

        public ISATPeriodService(IISATPeriodRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var iSATPeriodDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (iSATPeriodDto == null)
                return false;

            iSATPeriodDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<ISATPeriodDto, ISATPeriod, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var iSATPeriodDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (iSATPeriodDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<ISATPeriodDto, ISATPeriod, int>.Create(iSATPeriodDto.Items, page, pageSize, iSATPeriodDto.TotalCount);
        }
        public async Task<List<ISATPeriodDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var iSATPeriodDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (iSATPeriodDto == null)
                return null;

            return iSATPeriodDto.Select(d => new ISATPeriodDto(d)).ToList();
        }
        public async Task<ISATPeriodDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var iSATPeriodDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return iSATPeriodDto != null ? new ISATPeriodDto(iSATPeriodDto) : null;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as ISATPeriodDto;
            var iSATPeriodDto = ODto!.ToEntity();

            if (iSATPeriodDto.Id == 0)
                _repository.Add(iSATPeriodDto);
            else
                await _repository.UpdateAsync(iSATPeriodDto, iSATPeriodDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(iSATPeriodDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
