using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Persistence.SWOTAnalysisModule
{
    public class SWOTAnalysisService : ISWOTAnalysisService
    {
        private readonly ISWOTAnalysisRepository _repository;
        private readonly UserManager<User> _userManager;
        public SWOTAnalysisService(ISWOTAnalysisRepository repository, UserManager<User> userManager)
        {
            _repository = repository;
            _userManager = userManager;
        }       
        public async Task<List<SWOTAnalysisDto>?> FilterByYearAsync(int year, int noOfResults, CancellationToken cancellationToken)
        {
            if (year <= 0) year = DateTime.Now.Year;

            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return null;

            var userRoles = await _userManager.GetRolesAsync(currentUser);

            bool isElevatedUser = userRoles.Any(r =>
                 r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                 r.Equals(new PgsServiceHead().Name, StringComparison.OrdinalIgnoreCase) ||
                 r.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
                 r.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase));

            if (isElevatedUser)
            {
                return await _repository.FilterByYearAsync(year, noOfResults, cancellationToken);
            }
            else
            {
                return await _repository.FilterByYearByUserAsync(currentUser.Id, year, noOfResults, cancellationToken);
            }
        }
        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var swotAnalysisDto = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (swotAnalysisDto == null)
                return false;

            swotAnalysisDto.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<SWOTAnalysisDto, SWOTAnalysis, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var swotAnalysisDto = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (swotAnalysisDto.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<SWOTAnalysisDto, SWOTAnalysis, int>.Create(swotAnalysisDto.Items, page, pageSize, swotAnalysisDto.TotalCount);
        }
        public async Task<SWOTAnalysisDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var swotAnalysis = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return swotAnalysis != null ? new SWOTAnalysisDto(swotAnalysis) : null;
        }
        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return currentUserService != null
                ? await currentUserService.GetCurrentUserAsync()
                : null;
        }
        public async Task<List<SWOTAnalysisDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var currentUser = await GetCurrentUserAsync();
            if (currentUser == null)
                return null;

            var userRoles = await _userManager.GetRolesAsync(currentUser);

            List<SWOTAnalysis> swotEntities;

            if (userRoles.Any(r =>
                    r.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                    r.Equals(new PgsServiceHead().Name, StringComparison.OrdinalIgnoreCase) ||
                    r.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
                    r.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase)))
            {
                swotEntities = await _repository.GetAllAsync(cancellationToken);
            }
            else
            {
                swotEntities = await _repository.GetByUserIdAsync(currentUser.Id, cancellationToken) ?? new List<SWOTAnalysis>();
            }

            return swotEntities.Select(e => new SWOTAnalysisDto(e)).ToList();
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as SWOTAnalysisDto;
            var swotAnalysisDto = ODto!.ToEntity();

            if (swotAnalysisDto.Id == 0)
                _repository.Add(swotAnalysisDto);
            else
                await _repository.UpdateAsync(swotAnalysisDto, swotAnalysisDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(swotAnalysisDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
