using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Domain;

namespace IMIS.Persistence.AuditorOfficesModule
{
    public class AuditorOfficesService : IAuditorOfficesService
    {
        private readonly IAuditorOfficesRepository _auditorOfficeRepository;
        public AuditorOfficesService(IAuditorOfficesRepository auditorOfficeRepository)
        {
            _auditorOfficeRepository = auditorOfficeRepository;
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var auditorOffices = await _auditorOfficeRepository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (auditorOffices == null)
                return false;

            auditorOffices.IsDeleted = true;

            var context = _auditorOfficeRepository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<List<AuditorOfficesDto>?> GetAll(CancellationToken cancellationToken)
        {
            var auditorOffices = await _auditorOfficeRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return auditorOffices?.Select(a => new AuditorOfficesDto(a)).ToList();
        }
        public async Task<AuditorOfficesDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var auditorOffices = await _auditorOfficeRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return auditorOffices != null ? new AuditorOfficesDto(auditorOffices) : null;
        }
        public async Task<DtoPageList<AuditorOfficesDto, AuditorOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var auditorOffices = await _auditorOfficeRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (auditorOffices.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<AuditorOfficesDto, AuditorOffices, int>.Create(auditorOffices.Items, page, pageSize, auditorOffices.TotalCount);
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditorOfficeDto = dto as AuditorOfficesDto;
            var auditorOffices = auditorOfficeDto!.ToEntity();
            if (auditorOffices.Id == 0)
                _auditorOfficeRepository.Add(auditorOffices);
            else
            {
                await _auditorOfficeRepository.UpdateAsync(auditorOffices, auditorOffices.Id, cancellationToken).ConfigureAwait(false);
            }
            await _auditorOfficeRepository.SaveOrUpdateAsync(auditorOffices, cancellationToken).ConfigureAwait(false);
        }
    }
}
