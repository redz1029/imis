using Base.Primitives;
using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditorModule;

namespace IMIS.Persistence.AnnouncementModule
{
    public class AnnouncementService : IAnnouncementService
    {
        private readonly IAnnouncementRepository _repository;

        public AnnouncementService(IAnnouncementRepository repository)
        {
            _repository = repository;
        }
        public async Task<List<AnnouncementDto>?> GetAll(CancellationToken cancellationToken)
        {
            var announcementDto = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return announcementDto?.Select(a => new AnnouncementDto(a)).ToList();
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var announce = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (announce == null)
                return false;

            announce.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<List<AnnouncementDto>?> GetAllActive(CancellationToken cancellationToken)
        {
            var announcementDto = await _repository.GetAllActive(cancellationToken).ConfigureAwait(false);
            return announcementDto?.Select(a => new AnnouncementDto(a)).ToList();
        }
        public async Task<AnnouncementDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var announcementDto = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return announcementDto != null ? new AnnouncementDto(announcementDto) : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as AnnouncementDto;
            var announcementDto = ODto!.ToEntity();

            if (announcementDto.Id == 0)
                _repository.Add(announcementDto);
            else
                await _repository.UpdateAsync(announcementDto, announcementDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(announcementDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
