using Base.Auths;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Application.OfficeModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.OfficeModule 
{
  
    public class OfficeService : IOfficeService
    {
        private readonly IOfficeRepository _repository;
        private readonly ImisDbContext _dbContext;
        private readonly UserManager<User> _userManager;
  

        public OfficeService(IOfficeRepository repository, ImisDbContext dbContext, UserManager<User> userManager)
        {
            _repository = repository;
            _dbContext = dbContext;
            _userManager = userManager;
        }
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
                OfficeTypeId = office.OfficeTypeId,
                ParentOfficeId = office.ParentOfficeId,
                Auditors = office.AuditorOffices?
                    .Where(a => a.Auditor != null)
                    .Select(a => new AuditorDto()
                    {
                        Id = a.AuditorId,
                        Name = a.Auditor!.Name,
                        IsActive = a.Auditor.IsActive,
                        UserId = a.Auditor.UserId,
                        IsOfficeHead = a.IsOfficeHead
                    }).ToList()
            };
        }
        public async Task<List<OfficeDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var offices = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            return offices?.Select(o => ConvOfficeToDTO(o)).ToList();
        }


        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return currentUserService != null
                ? await currentUserService.GetCurrentUserAsync()
                : null;
        }
       
        public async Task<List<OfficeDto>> GetOfficesForPgsAuditorAsync(CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return new List<OfficeDto>();

            var userRoles = await _userManager.GetRolesAsync(currentUser);
       

            // Get all offices
            var offices = await _repository.GetAllForPgsAuditorAsync(cancellationToken);

            // Only admins see all offices, others are filtered by AuditorOffices
            if (!userRoles.Any(r => r.Equals("Administrator", StringComparison.OrdinalIgnoreCase)))
            {               
                // Get auditor-assigned offices
                var auditorOfficeIds = await _repository.GetAuditorOfficeIdsAsync(currentUser.Id, cancellationToken);

                if (auditorOfficeIds.Any())
                {
                    offices = offices.Where(o => auditorOfficeIds.Contains(o.Id)).ToList();
                }
                else
                {
                    offices = new List<Office>();
                }
            }

            return offices.Select(o => ConvOfficeToDTO(o)).ToList();
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
     
        public async Task<bool> HasCircularReferenceAsync(int? parentId, int childId, CancellationToken cancellationToken)
        {
            int depth = 0;
            const int maxDepth = 50;

            while (parentId != null)
            {
                if (++depth > maxDepth)
                    return true; 

                if (parentId == childId)
                    return true;

                var parent = await _dbContext.Offices.FindAsync(new object[] { parentId }, cancellationToken);
                if (parent == null)
                    break;

                parentId = parent.ParentOfficeId;
            }

            return false;
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

        public async Task<OfficeDto> GetRootParentOfficeAsync(int officeId, CancellationToken cancellationToken)
        {
            var childOffice = await _repository.GetByIdAsync(officeId, cancellationToken).ConfigureAwait(false);
            var parentOffice = await _repository.GetRootParentOffice(childOffice, cancellationToken).ConfigureAwait(false);
            return ConvOfficeToDTO(parentOffice);
        }
    }
}
