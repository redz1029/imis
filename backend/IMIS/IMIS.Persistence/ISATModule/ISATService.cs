using Base.Auths.Roles;
using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ISATAnnualPerformanceCommitmentsModule;
using IMIS.Application.ISATModule;
using IMIS.Application.ISATSignatoryModule;
using IMIS.Application.ISATSignatoryTemplateModule;
using IMIS.Application.ISATStrategicObjectiveSupportedModule;
using IMIS.Application.ISATStrategyContributionModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.ISATModule
{
    public class ISATService : IISATService
    {
        private const string StatusPrepared = "Prepared";
        private const string StatusPending = "Pending";
        private const string StatusEmployee = "Employee";
        private const string StatusOfficeHead = "Office Head";

        private readonly IISATRepository _repository;
        private readonly IISATSignatoryTemplateRepository _signatoryTemplateRepository;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public ISATService(
            IISATRepository repository,
            IISATSignatoryTemplateRepository signatoryTemplateRepository,
            UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            _repository = repository;
            _signatoryTemplateRepository = signatoryTemplateRepository;
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public async Task<List<PgsDeliverableListDto>> GetPgsDeliverablesByOfficeAndPeriodAsync(int officeId, int periodId, CancellationToken cancellationToken)
        {
            return await _repository.GetPgsDeliverablesByOfficeAndPeriodAsync(officeId, periodId, cancellationToken);
        }

        public async Task<List<KraRoadMapDeliverableListDto>> GetDeliverablesByRoadMapIdAndYearAsync(long roadMapId, int year, CancellationToken cancellationToken)
        {
            return await _repository.GetDeliverablesByRoadMapIdAndYearAsync(roadMapId, year, cancellationToken);
        }

        public async Task<List<KraRoadMapListDto>> GetRoadMapListAsync(CancellationToken cancellationToken)
        {
            return await _repository.GetRoadMapListAsync(cancellationToken);
        }
     
        public async Task<DtoPageList<ISATDto, ISAT, long>?> GetPaginatedByUserIdAsync(string userId, string roleId, int? officeId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var role = await _roleManager.FindByIdAsync(roleId);

            if (role == null)
                return null;

            if (role.Name!.Equals(new AdministratorRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsManagerRole().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new TWG().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new OSM().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MCC().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new PgsAuditorHead().Name, StringComparison.OrdinalIgnoreCase) ||
                role.Name.Equals(new MSGC().Name, StringComparison.OrdinalIgnoreCase))
            {
                var all = await _repository.GetPaginatedAllAsync(officeId, page, pageSize, cancellationToken);

                if (all.TotalCount == 0)
                    return null;

                return DtoPageList<ISATDto, ISAT, long>.Create(all.Items, page, pageSize, all.TotalCount);
            }
       
            var candidates = await _repository.GetCandidatesForUserAsync(userId, officeId, cancellationToken);

            var visible = new List<(ISAT Entity, bool IsNext)>();

            foreach (var isat in candidates)
            {
                cancellationToken.ThrowIfCancellationRequested();

                var isOwner = string.Equals(isat.EmployeeUserId, userId, StringComparison.OrdinalIgnoreCase);

                var (signatories, _) = await ProcessSignatoriesAsync(isat, cancellationToken);

                var isNext = signatories.Any(s =>
                    s.IsNextStatus &&
                    string.Equals(s.SignatoryId, userId, StringComparison.OrdinalIgnoreCase));

                var hasSigned = signatories.Any(s =>
                    s.Status == StatusPrepared &&
                    string.Equals(s.SignatoryId, userId, StringComparison.OrdinalIgnoreCase));

                if (isOwner || isNext || hasSigned)
                {
                    visible.Add((isat, isNext));
                }
            }

            if (visible.Count == 0)
                return null;

            var ordered = visible
                .OrderByDescending(v => v.IsNext)
                .ThenByDescending(v => v.Entity.PostingDate)
                .Select(v => v.Entity)
                .ToList();

            var totalCount = ordered.Count;

            var paged = ordered
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return DtoPageList<ISATDto, ISAT, long>.Create(paged, page, pageSize, totalCount);
        }

        public async Task<ISATEmployeeProfileDto?> GetEmployeeProfileByUserIdAsync(string userId, CancellationToken cancellationToken)
        {
            var employee = await _userManager.FindByIdAsync(userId);
            if (employee == null)
                return null;

            var dto = new ISATEmployeeProfileDto
            {
                UserId = userId,
                EmployeeName = FormatName(employee),
                Position = employee.Position
            };

            var userOffice = await _repository.GetActiveUserOfficeAsync(userId, cancellationToken).ConfigureAwait(false);
            if (userOffice == null)
                return dto;

            var office = await _repository.GetOfficeWithParentAsync(userOffice.OfficeId, cancellationToken).ConfigureAwait(false);
            if (office == null)
                return dto;

            dto.OfficeId = office.Id;
            dto.OfficeName = office.Name;

            if (office.ParentOffice != null)
            {
                dto.ParentOfficeId = office.ParentOffice.Id;
                dto.ParentOfficeName = office.ParentOffice.Name;
            }

            var officeHead = await _repository.GetOfficeHeadAsync(office.Id, cancellationToken).ConfigureAwait(false);
            if (officeHead != null && !string.Equals(officeHead.UserId, userId, StringComparison.OrdinalIgnoreCase))
            {
                var supervisor = await _userManager.FindByIdAsync(officeHead.UserId);
                if (supervisor != null)
                {
                    dto.SupervisorUserId = supervisor.Id;
                    dto.SupervisorName = FormatName(supervisor);
                }
            }

            return dto;
        }

        private static string FormatName(User user)
        {
            return string.Join(" ", new[]
            {
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
            }.Where(s => !string.IsNullOrWhiteSpace(s)));
        }

        public async Task<ISATDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIsatIdAsync(id, cancellationToken).ConfigureAwait(false);

            if (entity == null)
            {
                return null;
            }

            var dto = new ISATDto(entity);

            var (signatories, isDraft) = await ProcessSignatoriesAsync(entity, cancellationToken);
            dto.ISATSignatories = signatories;
            dto.IsDraft = isDraft;

            return dto;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not ISATDto isatDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            var db = _repository.GetDbContext();

            ISAT isatEntity;

            if (isatDto.Id > 0)
            {
                // UPDATE
                isatEntity = await db.Set<ISAT>().FirstOrDefaultAsync(x => x.Id == isatDto.Id, cancellationToken)
                    ?? throw new Exception($"ISAT {isatDto.Id} not found.");

                isatEntity.ISATPeriodId = isatDto.ISATPeriodId;
                isatEntity.OfficeId = isatDto.OfficeId;
                isatEntity.EmployeeUserId = isatDto.EmployeeUserId;
                isatEntity.PostingDate = isatDto.PostingDate;

                await SyncStrategicObjectiveSupportedAsync(isatDto.ISATStrategicObjectiveSupported, isatEntity.Id, cancellationToken);
                await SyncStrategyContributionAsync(isatDto.ISATStrategyContribution, isatEntity.Id, cancellationToken);
                await SyncAnnualPerformanceCommitmentsAsync(isatDto.ISATAnnualPerformanceCommitments, isatEntity.Id, cancellationToken);
            }
            else
            {
                isatEntity = isatDto.ToEntity();
                isatEntity.ISATPeriod = null;
                isatEntity.EmployeeUser = null;
                isatEntity.ISATSignatories = null;

                db.Set<ISAT>().Add(isatEntity);
            }

            await db.SaveChangesAsync(cancellationToken);

            if (isatEntity.Id <= 0)
                throw new Exception("Parent record was not saved.");

            isatDto.Id = isatEntity.Id;
        }

        // ======================= SUBMIT / SIGNATORIES =======================

        public async Task<ISATDto> Submit(ISATDto dto, string userId, CancellationToken cancellationToken)
        {
            await SaveOrUpdateAsync(dto, cancellationToken);

            var existing = await _repository.GetWithIncludesAsync(dto.Id, cancellationToken)
                ?? throw new Exception($"ISAT {dto.Id} not found.");

            var (signatories, _) = await ProcessSignatoriesAsync(existing, cancellationToken);

            var current = signatories.FirstOrDefault(x => x.IsNextStatus)
                ?? throw new InvalidOperationException("Wala nang pending na signatory.");

            if (!string.IsNullOrWhiteSpace(current.SignatoryId) &&
                !string.Equals(current.SignatoryId, userId, StringComparison.OrdinalIgnoreCase))
            {
                throw new UnauthorizedAccessException("You are not the next signatory.");
            }

            current.SignatoryId = userId;
            current.DateSigned = DateTime.UtcNow;
            current.Status = StatusPrepared;
            current.IsNextStatus = false;

            await SaveSignatoriesAsync(signatories, dto.Id, cancellationToken);

            return (await GetByIdAsync(dto.Id, cancellationToken))!;
        }

        private async Task<(List<ISATSignatoryDto> Signatories, bool IsDraft)> ProcessSignatoriesAsync(ISAT isat, CancellationToken cancellationToken)
        {
            var result = new List<ISATSignatoryDto>();
            var saved = (isat.ISATSignatories ?? new List<ISATSignatory>()).Where(s => !s.IsDeleted).ToList();
            bool isDraft = !saved.Any(s => s.Id > 0);

            if (!isat.OfficeId.HasValue)
                return (result, isDraft);

            var officeId = isat.OfficeId.Value;
            var employeeId = isat.EmployeeUserId;

            var templates = (await GetInheritedSignatoryTemplatesAsync(officeId, cancellationToken)).ToList();
            var officeHead = await _repository.GetOfficeHeadAsync(officeId, cancellationToken).ConfigureAwait(false);

            bool officeHeadIsEmployee = officeHead != null && string.Equals(officeHead.UserId, employeeId, StringComparison.OrdinalIgnoreCase);

            var userIds = new List<string> { employeeId };
            userIds.AddRange(saved.Select(s => s.SignatoryId));
            userIds.AddRange(templates.Where(t => !string.IsNullOrWhiteSpace(t.DefaultSignatoryId)).Select(t => t.DefaultSignatoryId!));
            if (officeHead != null) userIds.Add(officeHead.UserId);
            userIds = userIds.Where(x => !string.IsNullOrWhiteSpace(x)).Distinct().ToList();

            var usersDict = await _userManager.Users
                .Where(u => userIds.Contains(u.Id))
                .ToDictionaryAsync(u => u.Id, cancellationToken);

            string GetFullName(string? id) =>  id != null && usersDict.TryGetValue(id, out var u) ? FormatName(u) : string.Empty;

            bool IsEmployeeRow(ISATSignatory s) => s.ISATSignatoryTemplateId == null && string.Equals(s.SignatoryId, employeeId, StringComparison.OrdinalIgnoreCase);

            bool IsOfficeHeadRow(ISATSignatory s) => s.ISATSignatoryTemplateId == null && !IsEmployeeRow(s);

            foreach (var s in saved)
            {
                string? label;
                int order;

                if (IsEmployeeRow(s))
                {
                    label = StatusEmployee;
                    order = 0;
                }
                else if (IsOfficeHeadRow(s))
                {
                    label = StatusOfficeHead;
                    order = 1;
                }
                else
                {
                    var template = templates.FirstOrDefault(t => t.Id == s.ISATSignatoryTemplateId);
                    label = template?.SignatoryLabel;
                    order = template?.OrderLevel ?? int.MaxValue;
                }

                result.Add(new ISATSignatoryDto
                {
                    Id = s.Id,
                    ISATId = isat.Id,
                    ISATSignatoryTemplateId = s.ISATSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    SignatoryName = GetFullName(s.SignatoryId),
                    DateSigned = s.DateSigned,
                    Label = label,
                    OrderLevel = order,
                    Status = s.DateSigned != default ? StatusPrepared : StatusPending
                });
            }

            if (!saved.Any(IsEmployeeRow))
            {
                result.Add(new ISATSignatoryDto
                {
                    Id = 0,
                    ISATId = isat.Id,
                    ISATSignatoryTemplateId = null,
                    SignatoryId = employeeId,
                    SignatoryName = GetFullName(employeeId),
                    Label = StatusEmployee,
                    OrderLevel = 0,
                    Status = StatusPending
                });
            }

            if (officeHead != null && !officeHeadIsEmployee && !saved.Any(IsOfficeHeadRow))
            {
                result.Add(new ISATSignatoryDto
                {
                    Id = 0,
                    ISATId = isat.Id,
                    ISATSignatoryTemplateId = null,
                    SignatoryId = officeHead.UserId,
                    SignatoryName = GetFullName(officeHead.UserId),
                    Label = StatusOfficeHead,
                    OrderLevel = 1,
                    Status = StatusPending
                });
            }

            foreach (var t in templates.OrderBy(x => x.OrderLevel))
            {
                if (result.Any(x => x.ISATSignatoryTemplateId == t.Id))
                    continue;

                result.Add(new ISATSignatoryDto
                {
                    Id = 0,
                    ISATId = isat.Id,
                    ISATSignatoryTemplateId = t.Id,
                    SignatoryId = t.DefaultSignatoryId ?? string.Empty,
                    SignatoryName = GetFullName(t.DefaultSignatoryId),
                    Label = t.SignatoryLabel,
                    OrderLevel = t.OrderLevel,
                    Status = StatusPending
                });
            }

            int Group(ISATSignatoryDto x) => x.ISATSignatoryTemplateId != null ? 2 : string.Equals(x.SignatoryId, employeeId, StringComparison.OrdinalIgnoreCase) ? 0 : 1;

            result = result
                .OrderBy(Group)
                .ThenBy(x => x.OrderLevel)
                .ToList();

            var next = result.FirstOrDefault(x => x.Status == StatusPending);
            if (next != null)
                next.IsNextStatus = true;

            return (result, isDraft);
        }

        private async Task SaveSignatoriesAsync(List<ISATSignatoryDto>? dtos, long isatId, CancellationToken cancellationToken)
        {
            if (dtos == null || !dtos.Any())
                return;

            var db = _repository.GetDbContext();

            var existing = await db.Set<ISATSignatory>()
                .Where(x => x.ISATId == isatId)
                .ToListAsync(cancellationToken);

            foreach (var dto in dtos)
            {
                dto.ISATId = isatId;

                var dbRow = dto.Id > 0 ? existing.FirstOrDefault(x => x.Id == dto.Id) : null;
                if (dbRow != null)
                {
                    dbRow.SignatoryId = dto.SignatoryId;
                    dbRow.DateSigned = dto.DateSigned;
                    dbRow.ISATSignatoryTemplateId = dto.ISATSignatoryTemplateId == 0 ? null : dto.ISATSignatoryTemplateId;
                    continue;
                }

                bool isSigned = dto.DateSigned != default && !string.IsNullOrWhiteSpace(dto.SignatoryId);
                if (!isSigned)
                    continue;

                db.Set<ISATSignatory>().Add(new ISATSignatory
                {
                    Id = 0,
                    ISATId = isatId,
                    ISATSignatoryTemplateId = dto.ISATSignatoryTemplateId == 0 ? null : dto.ISATSignatoryTemplateId,
                    SignatoryId = dto.SignatoryId,
                    DateSigned = dto.DateSigned
                });
            }

            await db.SaveChangesAsync(cancellationToken);
        }

        private async Task<IEnumerable<ISATSignatoryTemplate>> GetInheritedSignatoryTemplatesAsync(int officeId, CancellationToken cancellationToken)
        {
            int? currentOfficeId = officeId;

            while (currentOfficeId.HasValue)
            {
                var templates = await _signatoryTemplateRepository.GetSignatoryTemplateByOfficeIdAsync(currentOfficeId.Value, cancellationToken);

                if (templates != null && templates.Any())
                    return templates.OrderBy(t => t.OrderLevel).ToList();

                var office = await _repository.GetOfficeWithParentAsync(currentOfficeId.Value, cancellationToken);
                currentOfficeId = office?.ParentOfficeId;
            }

            return Enumerable.Empty<ISATSignatoryTemplate>();
        }

        // ======================= SYNC HELPERS =======================
        private async Task SyncStrategicObjectiveSupportedAsync(List<ISATStrategicObjectiveSupportedDto>? dtos, long isatId, CancellationToken cancellationToken)
        {
            if (dtos == null)
                return;

            var db = _repository.GetDbContext();

            var existingRecords = await db.Set<ISATStrategicObjectiveSupported>()
                .Where(x => x.ISATId == isatId && !x.IsDeleted)
                .ToListAsync(cancellationToken);

            var incomingIds = dtos.Where(x => x.Id > 0).Select(x => x.Id).ToHashSet();

            foreach (var record in existingRecords.Where(x => !incomingIds.Contains(x.Id)))
            {
                record.IsDeleted = true;
            }

            foreach (var dto in dtos)
            {
                dto.ISATId = isatId;

                if (dto.Id == 0)
                {
                    db.Set<ISATStrategicObjectiveSupported>().Add(dto.ToEntity());
                }
                else
                {
                    var existing = existingRecords.FirstOrDefault(x => x.Id == dto.Id);
                    if (existing != null)
                    {
                        existing.KraRoadMapId = dto.KraRoadMapId;
                        existing.KraRoadMapDeliverableId = dto.KraRoadMapDeliverableId;
                        existing.PostingDate = dto.PostingDate;
                    }
                }
            }
        }

        private async Task SyncStrategyContributionAsync(List<ISATStrategyContributionDto>? dtos, long isatId, CancellationToken cancellationToken)
        {
            if (dtos == null)
                return;

            var db = _repository.GetDbContext();

            var existingRecords = await db.Set<ISATStrategyContribution>()
                .Where(x => x.ISATId == isatId && !x.IsDeleted)
                .ToListAsync(cancellationToken);

            var incomingIds = dtos.Where(x => x.Id > 0).Select(x => x.Id).ToHashSet();

            foreach (var record in existingRecords.Where(x => !incomingIds.Contains(x.Id)))
            {
                record.IsDeleted = true;
            }

            foreach (var dto in dtos)
            {
                dto.ISATId = isatId;

                if (dto.Id == 0)
                {
                    db.Set<ISATStrategyContribution>().Add(dto.ToEntity());
                }
                else
                {
                    var existing = existingRecords.FirstOrDefault(x => x.Id == dto.Id);
                    if (existing != null)
                    {
                        existing.PgsDeliverableId = dto.PgsDeliverableId;
                        existing.PostingDate = dto.PostingDate;
                    }
                }
            }
        }

        private async Task SyncAnnualPerformanceCommitmentsAsync(List<ISATAnnualPerformanceCommitmentsDto>? dtos, long isatId, CancellationToken cancellationToken)
        {
            if (dtos == null)
                return;

            var db = _repository.GetDbContext();

            var existingRecords = await db.Set<ISATAnnualPerformanceCommitments>()
                .Where(x => x.ISATId == isatId && !x.IsDeleted)
                .ToListAsync(cancellationToken);

            var incomingIds = dtos.Where(x => x.Id > 0).Select(x => x.Id).ToHashSet();

            foreach (var record in existingRecords.Where(x => !incomingIds.Contains(x.Id)))
            {
                record.IsDeleted = true;
            }

            foreach (var dto in dtos)
            {
                dto.ISATId = isatId;

                if (dto.Id == 0)
                {
                    db.Set<ISATAnnualPerformanceCommitments>().Add(dto.ToEntity());
                }
                else
                {
                    var existing = existingRecords.FirstOrDefault(x => x.Id == dto.Id);
                    if (existing != null)
                    {
                        existing.Deliverable = dto.Deliverable;
                        existing.Target = dto.Target;
                        existing.TimeLine = dto.TimeLine;
                        existing.Status = dto.Status;
                        existing.Accomplishment = dto.Accomplishment;
                    }
                }
            }
        }
    }
}