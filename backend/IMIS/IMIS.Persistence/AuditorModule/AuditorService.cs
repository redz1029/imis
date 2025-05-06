using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditorModule
{
    public class AuditorService : IAuditorService
    {
        private readonly IAuditorRepository _auditorRepository;
        public AuditorService(IAuditorRepository auditorRepository)
        {
            _auditorRepository = auditorRepository;
        }   
        public async Task<DtoPageList<AuditorDto, Auditor, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditor = await _auditorRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if(auditor.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<AuditorDto, Auditor, int>.Create(auditor.Items, page, pageSize, auditor.TotalCount);
        }
        public async Task<List<AuditorDto>?> FilteByName(string name, int auditorNoOfResults, CancellationToken cancellationToken)
        {
            var auditors = await _auditorRepository.FilteByName(name, auditorNoOfResults, cancellationToken).ConfigureAwait(false);
            return auditors != null && auditors.Count() > 0 ? auditors.Select(a => new AuditorDto(a)).ToList() : null;
        }
        public async Task<List<AuditorDto>?> GetAll(CancellationToken cancellationToken)
        {
            var auditors = await _auditorRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return auditors?.Select(a => new AuditorDto(a)).ToList();
        }
        public async Task<AuditorDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var auditor = await _auditorRepository
                .GetByIdAsync(id, cancellationToken)
                .ConfigureAwait(false);
            return auditor != null ? new AuditorDto(auditor) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditorDto = dto as AuditorDto;
            var auditor = auditorDto!.ToEntity();
            if(auditor.Id == 0)
                _auditorRepository.Add(auditor);
            else
            {
                await _auditorRepository.UpdateAsync(auditor, auditor.Id, cancellationToken).ConfigureAwait(false);
            }
            await _auditorRepository.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
        }
    }
}
