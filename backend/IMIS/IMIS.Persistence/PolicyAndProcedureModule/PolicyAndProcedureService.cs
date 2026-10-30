using Base.Auths;
using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Application.PolicyAndProcedureSignatoryModule;
using IMIS.Application.PolicyAndProcedureSignatoryTemplateModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureModule
{
    public class PolicyAndProcedureService : IPolicyAndProcedureService
    {
        private readonly IPolicyAndProcedureRepository _repository;
        private readonly IPolicyAndProcedureSignatoryTemplateRepository _templateRepository;
        private readonly IOfficeRepository _officeRepository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public PolicyAndProcedureService(IPolicyAndProcedureRepository repository, IPolicyAndProcedureSignatoryTemplateRepository templateRepository, IOfficeRepository officeRepository, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _templateRepository = templateRepository;
            _officeRepository = officeRepository;
            _userManager = userManager;
            _roleManager = roleManager;
        }
        public async Task<bool> SoftDeleteSignatoryAsync(long papId, CancellationToken cancellationToken)
        {
            var signatories = await _repository.GetByPgsIdForSoftDeleteAsync(papId, cancellationToken);

            var activeSignatories = signatories
                .Where(x => !x.IsDeleted)
                .ToList();

            if (!activeSignatories.Any())
                return false;

            foreach (var signatory in activeSignatories)
            {
                signatory.IsDeleted = true;
            }

            await _repository.GetDbContext()
                .SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>> GetFilteredAsync(PolicyAndProcedureFilter filter, string roleId, CancellationToken cancellationToken)
        {
            DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long> Empty() =>
                DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>.Create(new List<PolicyAndProcedure>(), filter.Page, filter.PageSize, 0);

            var currentUser = await GetCurrentUserAsync();

            if (currentUser == null)
                return Empty();

            var role = await _roleManager.FindByIdAsync(roleId);

            if (role == null || string.IsNullOrWhiteSpace(role.Name))
                return Empty();

            if (!await _userManager.IsInRoleAsync(currentUser, role.Name))
                return Empty();

            cancellationToken.ThrowIfCancellationRequested();

            var uid = currentUser.Id;
            var roleName = role.Name;

            bool Is(string name) =>  roleName.Equals(name, StringComparison.OrdinalIgnoreCase);

            var isAdmin = Is(new AdministratorRole().Name);
            var isPgsManager = Is(new PgsManagerRole().Name);
            var isTWG = Is(new TWG().Name);
            var isOSM = Is(new OSM().Name);
            var isMSGC = Is(new MSGC().Name);
            var isPgsAuditorHead = Is(new PgsAuditorHead().Name);
            var isPgsServiceHead = Is(new PgsServiceHead().Name);

            var viewAll = isAdmin || isPgsManager || isTWG || isOSM || isMSGC || isPgsAuditorHead;

            var candidates = await _repository.GetFilteredCandidatesAsync(filter, uid, viewAll, includeChildOffices: isPgsServiceHead, cancellationToken).ConfigureAwait(false);

            var visible = new List<PolicyAndProcedure>();
            var nextForMe = new HashSet<long>();

            foreach (var pap in candidates)
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (viewAll)
                {
                    visible.Add(pap);
                    continue;
                }

                var (all, isDraft) = await ResolveAsync(
                    pap,
                    cancellationToken);

                var activeSignatories = pap.PAPSignatories?
                    .Where(s => !s.IsDeleted)
                    .ToList()
                    ?? new List<PolicyAndProcedureSignatory>();

                var mine = all.Where(s => s.SignatoryId == uid).ToList();

                var hasSignatoryRecord = activeSignatories.Any(s => s.SignatoryId == uid);

                var isSignatory = mine.Count > 0 || hasSignatoryRecord;

                var firstSignatory = all.OrderBy(s => s.OrderLevel).ThenBy(s => s.Id).FirstOrDefault();

                var isFirstSignatory = firstSignatory != null && firstSignatory.SignatoryId == uid;

                var isNext = mine.Any(s => s.IsNextStatus && s.Status == PolicyAndProcedureStatus.Pending);

                var allSignatoriesCompleted = all.Count > 0 &&  all.All(s => s.Status == PolicyAndProcedureStatus.Prepared);

                var canViewCompletedAsSignatory = isSignatory && allSignatoriesCompleted;

                var canViewAsParent = isPgsServiceHead && (pap.Section?.ParentOffice?.UserOffices?.Any(u =>  u.UserId == uid &&  u.IsActive && !u.IsDeleted) ?? false);

                var isAssignedToSection = pap.Section?.UserOffices?.Any(u => u.UserId == uid && u.IsActive && !u.IsDeleted) ?? false;

                var canViewAsSectionUser = isAssignedToSection && !isSignatory;

                var canView = isFirstSignatory ||  isNext || canViewCompletedAsSignatory || canViewAsParent || canViewAsSectionUser;

                if (!canView)
                    continue;

                visible.Add(pap);

                if (isNext)
                    nextForMe.Add(pap.Id);
            }

            var ordered = visible.OrderByDescending(p => nextForMe.Contains(p.Id)).ThenByDescending(p => p.Id).ToList();

            var totalCount = ordered.Count;

            var pageEntities = ordered.Skip((filter.Page - 1) * filter.PageSize).Take(filter.PageSize).ToList();

            var result = DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>.Create(pageEntities, filter.Page,  filter.PageSize, totalCount);

            var byId = pageEntities.ToDictionary(e => e.Id);

            foreach (var item in result.Items)
            {
                cancellationToken.ThrowIfCancellationRequested();

                if (!byId.TryGetValue(item.Id, out var entity))
                    continue;

                await ApplySignatoriesAsync(item, entity, cancellationToken);
             
                item.ForSignature = item.PAPSignatories?.Any(s =>
                        s.SignatoryId == uid &&
                        s.IsNextStatus &&
                        s.Status == PolicyAndProcedureStatus.Pending) ?? false;
            }

            return result;
        }

        private async Task<User?> GetCurrentUserAsync()
        {
            var currentUserService = CurrentUserHelper<User>.GetCurrentUserService();
            return await currentUserService!.GetCurrentUserAsync();
        }


        public async Task<DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var paged = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            var result = DtoPageList<PolicyAndProcedureDto, PolicyAndProcedure, long>.Create(paged.Items, page, pageSize, paged.TotalCount);

            var entities = paged.Items.ToDictionary(e => e.Id);
            foreach (var item in result.Items)
            {
                if (entities.TryGetValue(item.Id, out var entity))
                    await ApplySignatoriesAsync(item, entity, cancellationToken);
            }

            return result;
        }

        public async Task<PolicyAndProcedureDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? await BuildDtoAsync(entity, cancellationToken) : null;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (entity == null)
                return false;

            entity.IsDeleted = true;
            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);
            return true;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is PolicyAndProcedureDto papDto)
            {
                var protocol = papDto.ToEntity();

                if (protocol.Id == 0)
                    _repository.Add(protocol);
                else
                    await _repository.UpdateAsync(protocol, protocol.Id, cancellationToken).ConfigureAwait(false);

                await _repository.SaveOrUpdateAsync(protocol, cancellationToken).ConfigureAwait(false);
            }
        }

        public async Task<PolicyAndProcedureDto> DraftAsync(PolicyAndProcedureDto dto, string userId, CancellationToken cancellationToken)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var pap = await SaveFieldsAsync(dto, cancellationToken);

            foreach (var s in pap.PAPSignatories.Where(s => !s.IsDeleted))
                s.IsDeleted = true;

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);

            return await BuildDtoAsync(await ReloadAsync(pap.Id, cancellationToken), cancellationToken);
        }

        // ================= SUBMIT =================
       
        public async Task<PolicyAndProcedureDto> SubmitAsync(PolicyAndProcedureDto dto, string userId, CancellationToken cancellationToken)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var pap = await SaveFieldsAsync(dto, cancellationToken);

            var (all, isDraft) = await ResolveAsync(pap, cancellationToken);

            var current = all.FirstOrDefault(s => s.IsNextStatus)
                ?? throw new InvalidOperationException("No signatory. Fully signed document.");

            var isAssignedToSection = pap.Section?.UserOffices?.Any(u => u.UserId == userId && !u.IsDeleted) == true;
            if (current.SignatoryId != userId && !(isDraft && isAssignedToSection))
                throw new UnauthorizedAccessException("No signatory next.");

            var now = DateTime.UtcNow;

            var row = current.Id > 0
                ? pap.PAPSignatories.FirstOrDefault(r => r.Id == current.Id && !r.IsDeleted)
                : null;

            if (row != null)
            {
                row.SignatoryId = userId;
                row.DateSigned = now;
            }
            else
            {
                pap.PAPSignatories.Add(new PolicyAndProcedureSignatory
                {
                    Id = 0,
                    PAPId = pap.Id,
                    PAPSignatoryTemplateId = current.PAPSignatoryTemplateId,
                    SignatoryId = userId,
                    DateSigned = now
                });
            }
           
            var hasRemainingSignatory = all.Any(s =>
                !ReferenceEquals(s, current) &&
                s.Status == PolicyAndProcedureStatus.Pending);

            var isLastTemplateSignatory = current.PAPSignatoryTemplateId.HasValue && !hasRemainingSignatory;

            if (isLastTemplateSignatory)
            {
                pap.IsMasterCopy = true;
                pap.IsControlledCopy = true;
            }

            await _repository.GetDbContext().SaveChangesAsync(cancellationToken);

            return await BuildDtoAsync(await ReloadAsync(pap.Id, cancellationToken), cancellationToken);
        }

        // ================= HELPERS =================

        private async Task<PolicyAndProcedure> ReloadAsync(long id, CancellationToken ct)
            => await _repository.GetWithIncludesAsync(id, ct)
               ?? throw new InvalidOperationException("Policy and Procedure record not found.");

        private async Task<PolicyAndProcedure> SaveFieldsAsync(PolicyAndProcedureDto dto, CancellationToken ct)
        {
            var context = _repository.GetDbContext();
            PolicyAndProcedure pap;

            if (dto.Id == 0)
            {
                pap = dto.ToEntity();
                pap.PAPSignatories = new List<PolicyAndProcedureSignatory>();
                context.Set<PolicyAndProcedure>().Add(pap);
            }
            else
            {
                pap = await _repository.GetWithIncludesAsync(dto.Id, ct)
                    ?? throw new InvalidOperationException($"Policy and Procedure with Id {dto.Id} not found.");

                pap.Title = dto.Title;
                pap.ProcessOwner = dto.ProcessOwner;
                pap.RegulatoryStandard = dto.RegulatoryStandard;
                pap.EffectiveDate = dto.EffectiveDate;
                pap.SectionId = dto.SectionId;
                pap.DocumentCode = dto.DocumentCode;
                pap.Revision = dto.Revision;
                pap.Content = dto.Content;
                pap.IsMasterCopy = dto.IsMasterCopy;
                pap.IsControlledCopy = dto.IsControlledCopy;
                pap.MinutesAttachmentPath = dto.MinutesAttachmentPath;
            }

            await context.SaveChangesAsync(ct);

            return await ReloadAsync(pap.Id, ct);
        }

        private async Task<PolicyAndProcedureDto> BuildDtoAsync(PolicyAndProcedure entity, CancellationToken ct)
        {
            var dto = new PolicyAndProcedureDto(entity);
            await ApplySignatoriesAsync(dto, entity, ct);
            return dto;
        }
       

        private async Task ApplySignatoriesAsync(PolicyAndProcedureDto dto, PolicyAndProcedure entity, CancellationToken ct)
        {
            var (all, isDraft) = await ResolveAsync(entity, ct);

            dto.PAPSignatories = all
                .Where(s =>
                    s.Status == PolicyAndProcedureStatus.Prepared ||
                    s.IsNextStatus)
                .OrderBy(s => s.OrderLevel)
                .ToList();

            dto.IsDraft = isDraft;
        }
     
        private async Task<(List<PolicyAndProcedureSignatoryDto> All, bool IsDraft)> ResolveAsync(PolicyAndProcedure pap, CancellationToken ct)
        {
            var saved = pap.PAPSignatories?                
                .Where(s => !s.IsDeleted)
                .OrderBy(s => s.Id)
                .ToList()
                ?? new List<PolicyAndProcedureSignatory>();

            var isDraft = saved.Count == 0;

            var section = pap.Section;

            var templates = section == null ? new List<PolicyAndProcedureSignatoryTemplate>() : await GetInheritedTemplatesAsync(section, ct);

            var ownTemplates = section == null ? null : await _templateRepository.GetSignatoryTemplateByOfficeIdAsync(section.Id, ct);

            var hasOwnTemplates = ownTemplates?.Any() == true;

            var templateById = templates.GroupBy(t => t.Id).ToDictionary(g => g.Key, g => g.First());

            var officeHeadId = section?.UserOffices?.FirstOrDefault(u =>
                    u.IsOfficeHead &&
                    u.IsActive &&
                    !u.IsDeleted)?.UserId;

            var userIds = new List<string>();

            if (!string.IsNullOrWhiteSpace(officeHeadId))
                userIds.Add(officeHeadId);

            userIds.AddRange(saved.Select(s => s.SignatoryId));

            userIds.AddRange(
                templates
                    .Where(t => !string.IsNullOrWhiteSpace(t.DefaultSignatoryId))
                    .Select(t => t.DefaultSignatoryId!));

            userIds = userIds
                .Where(id => !string.IsNullOrWhiteSpace(id))
                .Distinct()
                .ToList();

            var users = await _userManager.Users
                .Where(u => userIds.Contains(u.Id))
                .ToDictionaryAsync(u => u.Id, ct);

            string FullName(string? id)
            {
                if (string.IsNullOrWhiteSpace(id) ||
                    !users.TryGetValue(id, out var user))
                {
                    return string.Empty;
                }

                return string.Join(
                    " ",
                    new[]
                    {
                user.Prefix,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
                    }.Where(x => !string.IsNullOrWhiteSpace(x)));
            }

            var list = new List<PolicyAndProcedureSignatoryDto>();

            foreach (var s in saved)
            {
                ct.ThrowIfCancellationRequested();

                var order = 0;
                var label = PolicyAndProcedureStatus.OfficeHead;

                if (s.PAPSignatoryTemplateId.HasValue)
                {
                    if (!templateById.TryGetValue(s.PAPSignatoryTemplateId.Value, out var template))
                    {
                        template = await _templateRepository.GetByIdAsync(s.PAPSignatoryTemplateId.Value, ct);
                    }

                    if (template != null)
                    {
                        order = template.OrderLevel;
                        label = template.SignatoryLabel;
                    }
                }

                list.Add(new PolicyAndProcedureSignatoryDto
                {
                    Id = s.Id,
                    PAPId = pap.Id,
                    PAPSignatoryTemplateId = s.PAPSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    SignatoryName = FullName(s.SignatoryId),
                    Label = label,
                    OrderLevel = order,
                    Status = s.DateSigned != default ? PolicyAndProcedureStatus.Prepared : PolicyAndProcedureStatus.Pending,
                    DateSigned = s.DateSigned,
                    IsNextStatus = false
                });
            }

            if (isDraft && !hasOwnTemplates && !string.IsNullOrWhiteSpace(officeHeadId))
            {
                list.Add(new PolicyAndProcedureSignatoryDto
                {
                    Id = 0,
                    PAPId = pap.Id,
                    PAPSignatoryTemplateId = null,
                    SignatoryId = officeHeadId,
                    SignatoryName = FullName(officeHeadId),
                    Label = PolicyAndProcedureStatus.OfficeHead,
                    OrderLevel = 0,
                    Status = PolicyAndProcedureStatus.Pending,
                    IsNextStatus = false
                });
            }

            foreach (var template in templates.OrderBy(t => t.OrderLevel))
            {
                ct.ThrowIfCancellationRequested();

                if (string.IsNullOrWhiteSpace(template.DefaultSignatoryId))
                    continue;

                var exists = list.Any(s =>
                    s.PAPSignatoryTemplateId == template.Id ||
                    s.SignatoryId == template.DefaultSignatoryId);

                if (exists)
                    continue;

                list.Add(new PolicyAndProcedureSignatoryDto
                {
                    Id = 0,
                    PAPId = pap.Id,
                    PAPSignatoryTemplateId = template.Id > 0 ? template.Id : null,
                    SignatoryId = template.DefaultSignatoryId!,
                    SignatoryName = FullName(template.DefaultSignatoryId),
                    Label = template.SignatoryLabel,
                    OrderLevel = template.OrderLevel,
                    Status = PolicyAndProcedureStatus.Pending,
                    IsNextStatus = false
                });
            }

            foreach (var signatory in list)
                signatory.IsNextStatus = false;

            var next = list
                .Where(s => s.Status == PolicyAndProcedureStatus.Pending)
                .OrderBy(s => s.OrderLevel)
                .ThenBy(s => s.Id)
                .FirstOrDefault();

            if (next != null)
                next.IsNextStatus = true;

            return (
                list
                    .OrderBy(s => s.OrderLevel)
                    .ThenBy(s => s.Id)
                    .ToList(),
                isDraft);
        }

        private async Task<List<PolicyAndProcedureSignatoryTemplate>> GetInheritedTemplatesAsync(Office office, CancellationToken ct, int depth = 0)
        {
            if (depth > 10) return new();

            var templates = (await _templateRepository.GetSignatoryTemplateByOfficeIdAsync(office.Id, ct))?.ToList();
            if (templates is { Count: > 0 })
                return templates.OrderBy(t => t.OrderLevel).ToList();

            var parent = office.ParentOffice ?? await _officeRepository.GetRootParentOffice(office, ct);
            if (parent == null || parent.Id == office.Id)
                return new();

            return await GetInheritedTemplatesAsync(parent, ct, depth + 1);
        }
    }
}