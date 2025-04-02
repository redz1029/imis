using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Persistence.OfficeModule
{
    public class OfficeService(IOfficeRepository repository) : IOfficeService
    {
        private readonly IOfficeRepository _repository = repository;
        public async Task<List<OfficeDto>?> FilterByName(string name, int officeNoOfResults, CancellationToken cancellationToken)
        {
            var offices = await _repository.FilterByName(name, officeNoOfResults, cancellationToken).ConfigureAwait(false);         
            return offices != null && offices.Count() > 0 ? offices.Select(a => ConvOfficeToDTO(a)).ToList() : null;
        }
        public async Task<DtoPageList<OfficeDto, Office, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var useroffice = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (useroffice.TotalCount == 0)
                return null;
            return DtoPageList<OfficeDto, Office, int>.Create(useroffice.Items, page, pageSize, useroffice.TotalCount);
        }

        private static OfficeDto ConvOfficeToDTO(Office office)
        {
            return new OfficeDto()
            {
                Id = office.Id,
                Name = office.Name,
                IsActive = office.IsActive,
                Auditors = office.AuditorOffices?.Select(a => new AuditorDto()
                {
                    Id = a.AuditorId,
                    Name = a.Auditor!.Name,
                    IsActive = a.Auditor.IsActive,
                    IsOfficeHead = a.IsOfficeHead,
                }).ToList(),
            };
        }
        public async Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }
        public async Task<List<OfficeDto>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken)
        {
            var offices = await _repository.GetAuditableOffices(auditScheduleId, cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }
        public async Task<OfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var office = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return office != null ? ConvOfficeToDTO(office) : null;
        }
        public async Task<List<OfficeDto>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken)
        {
            var offices = await _repository.GetNonAuditableOffices(auditScheduleId, cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }   
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as OfficeDto;
            var office = ODto!.ToEntity();

            if (office.Id == 0)
                _repository.Add(office);
            else
                await _repository.UpdateAsync(office, office.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(office, cancellationToken).ConfigureAwait(false);
        }
    }
}
