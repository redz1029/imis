using Bogus;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.TeamModule;
using IMIS.Persistence.AuditorModule;
using IMIS.Persistence.AuditScheduleModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.TeamModule;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ImisTest
{
    [TestFixture]
    public class AuditScheduleTests : BaseTests
    {
        private IAuditScheduleService _auditScheduleService;
        private IOfficeService _officeService;
        private ITeamService _teamService;
        private IAuditorService _auditorService;

        [SetUp]
        public override void Setup()
        {
            base.Setup();

            _services.AddScoped<IAuditScheduleRepository, AuditScheduleRepository>();
            _services.AddScoped<IAuditScheduleService, AuditScheduleService>();

            _services.AddScoped<IOfficeRepository, OfficeRepository>();
            _services.AddScoped<IOfficeService, OfficeService>();

            _services.AddScoped<ITeamRepository, TeamRepository>();
            _services.AddScoped<ITeamService, TeamService>();

            _services.AddScoped<IAuditorRepository, AuditorRepository>();
            _services.AddScoped<IAuditorService, AuditorService>();

            BuildServiceProvider();

            _auditScheduleService = _serviceProvider.GetRequiredService<IAuditScheduleService>();
            _officeService = _serviceProvider.GetRequiredService<IOfficeService>();
            _teamService = _serviceProvider.GetRequiredService<ITeamService>();
            _auditorService = _serviceProvider.GetRequiredService<IAuditorService>();
        }

        [Test]
        public async Task TestAuditScheduleGeneration()
        {
            // Prepare Test Data

            int noOfAuditors = 84;
            var auditors = await GenerateAuditors(noOfAuditors).ConfigureAwait(false);

            int noOfAuditableOffices = 77;
            int noOfNonAuditableOffices = 33;

            int noOfMembersPerTeam = Math.Abs(noOfAuditors / noOfAuditableOffices);

            int noOfAuditorsToAssignOnNonAuditableOffices = Math.Abs(noOfAuditors / noOfNonAuditableOffices);
            int noOfAuditorsWithoutOffice = (noOfNonAuditableOffices * noOfAuditorsToAssignOnNonAuditableOffices);
            int noOfAuditorsToAssignOnAuditableOffices = (noOfAuditors - noOfAuditorsWithoutOffice) / noOfAuditableOffices > 1 
                ? Math.Abs((noOfAuditors - noOfAuditorsWithoutOffice) / noOfAuditableOffices) : 1;

            int noOfAuditorsAssignedInAnOffice = 0;
            List<OfficeDto> auditableOffices;
            await GenerateTeams(14, noOfMembersPerTeam, auditors).ConfigureAwait(false);

            (_, noOfAuditorsAssignedInAnOffice) = await GenerateAndGetOffices(noOfAuditorsAssignedInAnOffice, false, noOfNonAuditableOffices, noOfAuditorsToAssignOnNonAuditableOffices, auditors).ConfigureAwait(false);
            (auditableOffices, _) = await GenerateAndGetOffices(noOfAuditorsAssignedInAnOffice, true, noOfAuditableOffices, noOfAuditorsToAssignOnAuditableOffices, auditors).ConfigureAwait(false);

            DateTime startDate = new DateTime(2025, 1, 29) + new TimeSpan(13, 0, 0);
            DateTime endDate = new DateTime(2025, 1, 31) + new TimeSpan(17, 0, 0);
            int noOfHoursPerAudit = 2;

            var auditScheduleFaker = new Faker<AuditScheduleDto>()
                .RuleFor(a => a.AuditTitle, f => f.Lorem.Text())
                .RuleFor(a => a.StartDate, startDate)
                .RuleFor(a => a.EndDate, endDate)
                .RuleFor(a => a.IsActive, true)
                .RuleFor(a => a.Offices, auditableOffices);

            var auditSchedule = auditScheduleFaker.Generate();
            string auditTitle = auditSchedule.AuditTitle;
            await _auditScheduleService.SaveOrUpdateAsync(auditSchedule, CancellationToken.None).ConfigureAwait(false);

            var savedAuditSchedule = await _context.AuditSchedules.FirstOrDefaultAsync(a => a.AuditTitle == auditTitle).ConfigureAwait(false);
            Assert.NotNull(savedAuditSchedule);
            Assert.That(savedAuditSchedule.AuditTitle, Is.EqualTo(auditTitle));
        }

        private async Task<(List<OfficeDto>, int)> GenerateAndGetOffices(int noOfAuditorsAssignedInAnOffice, 
            bool isAuditableOffices, int noOfOffices, int noOfAuditorPerOffice, List<AuditorDto> auditors)
        {
            var offices = isAuditableOffices 
                ? await _officeService.GetAuditableOffices(null, CancellationToken.None).ConfigureAwait(false)
                : await _officeService.GetNonAuditableOffices(null, CancellationToken.None).ConfigureAwait(false);

            if (offices != null && offices.Count > 0 && noOfAuditorsAssignedInAnOffice <= auditors.Count)
            {
                foreach (var office in offices)
                {
                    office.Auditors = office.Auditors ?? [];
                    var noOfAuditorsToAssign = noOfAuditorPerOffice - office.Auditors?.Count;

                    bool hasOfficeHead = office.Auditors?.FirstOrDefault(a => a.IsOfficeHead) != null;
                    while (noOfAuditorsToAssign > 0)
                    {
                        if (noOfAuditorsAssignedInAnOffice > auditors.Count)
                        {
                            noOfAuditorsToAssign = 0;
                            continue;
                        }

                        var auditor = noOfAuditorsAssignedInAnOffice == auditors.Count 
                            ? auditors.Last() 
                            : auditors.Skip(noOfAuditorsAssignedInAnOffice).First();
                        if (!hasOfficeHead)
                        {
                            auditor.IsOfficeHead = true;
                            hasOfficeHead = true;
                        }
                        office.Auditors!.Add(auditor);

                        noOfAuditorsToAssign--;
                        noOfAuditorsAssignedInAnOffice++;
                    }

                    await _context.Offices.FirstOrDefaultAsync(o => o.Name == office.Name).ConfigureAwait(false);
                }
            }

            if (offices == null || noOfOffices > offices?.Count)
            {
                var noOfOfficesToGenerate = noOfOffices - offices?.Count;
                var officeFaker = new Faker<OfficeDto>()
                    .RuleFor(o => o.Name, f => f.Commerce.Department())
                    .RuleFor(o => o.IsActive, true);

                while(noOfOfficesToGenerate > 0 && noOfAuditorsAssignedInAnOffice <= auditors.Count)
                {
                    var office = officeFaker.Generate();
                    office.Auditors = office.Auditors ?? [];
                    var noOfAuditorsToAssign = noOfAuditorPerOffice;
                    bool hasOfficeHead = false;
                    while (noOfAuditorsToAssign > 0)
                    {
                        if (noOfAuditorsAssignedInAnOffice > auditors.Count)
                        {
                            noOfAuditorsToAssign = 0;
                            continue;
                        }
                            

                        var auditor = noOfAuditorsAssignedInAnOffice == auditors.Count
                            ? auditors.Last()
                            : auditors.Skip(noOfAuditorsAssignedInAnOffice).First();

                        if (!hasOfficeHead)
                        {
                            auditor.IsOfficeHead = true;
                            hasOfficeHead = true;
                        }
                        office.Auditors!.Add(auditor);

                        noOfAuditorsToAssign--;
                        noOfAuditorsAssignedInAnOffice++;
                    }

                    await _officeService.SaveOrUpdateAsync(office, CancellationToken.None).ConfigureAwait(false);

                    var savedOffice = await _context.Offices.FirstOrDefaultAsync(o => o.Name == office.Name).ConfigureAwait(false);
                    offices!.Add(new OfficeDto() 
                    { 
                        Id = savedOffice!.Id, 
                        Name = savedOffice.Name, 
                        IsActive = savedOffice.IsActive
                    });
                    noOfOfficesToGenerate--;
                }
            }

            return (offices!, noOfAuditorsAssignedInAnOffice);
        }

        private async Task GenerateTeams(int noOfTeams, int noOfMembersPerTeam, List<AuditorDto> auditors)
        {
            var teams = await _teamService.GetAllActiveAsync(CancellationToken.None).ConfigureAwait(false);
            int noOfAssignedAuditors = 0;
            int noOfAssignedTeamMembers = 0;
            if (teams != null && teams.Count > 0)
            {
                var teamsToAddAuditors = teams.Where(t => t.Auditors != null && t.Auditors.Count < noOfMembersPerTeam);
                foreach(var team in teamsToAddAuditors)
                {
                    noOfAssignedTeamMembers = noOfMembersPerTeam - team.Auditors!.Count();
                    bool hasTeamLeader = team.Auditors!.FirstOrDefault(a => a.IsTeamLeader) != null;
                    while (noOfAssignedTeamMembers > 0)
                    {
                        if (noOfAssignedAuditors > auditors.Count)
                        {
                            noOfAssignedTeamMembers = 0;
                            continue;
                        }
                        var auditor = noOfAssignedTeamMembers == auditors.Count
                            ? auditors.Last()
                            : auditors.Skip(noOfAssignedTeamMembers).First();
                        if (!hasTeamLeader)
                        {
                            auditor.IsTeamLeader = true;
                            hasTeamLeader = true;
                        }
                        auditor.IsTeamLeader = false;
                        team.Auditors!.Add(auditor);

                        noOfAssignedAuditors++;
                        noOfAssignedTeamMembers--;
                    }

                    await _teamService.SaveOrUpdateAsync(team, CancellationToken.None).ConfigureAwait(false);
                }
            }

            if(teams == null || noOfTeams > teams?.Count)
            {
                var noOfTeamsToGenerate = noOfTeams - teams?.Count;
                var teamFaker = new Faker<TeamDto>()
                    .RuleFor(t => t.Name, f => f.Lorem.Word())
                    .RuleFor(t => t.IsActive, true);

                while(noOfTeamsToGenerate > 0)
                {
                    var team = teamFaker.Generate();
                    noOfAssignedAuditors = 0;
                    noOfAssignedTeamMembers = 0;
                    bool hasTeamLeader = false;
                    team.Auditors = [];
                    while (noOfAssignedAuditors > 0)
                    {
                        if (noOfAssignedAuditors > auditors.Count)
                        {
                            noOfAssignedAuditors = 0;
                            continue;
                        }

                        var auditor = noOfAssignedTeamMembers == auditors.Count
                           ? auditors.Last()
                           : auditors.Skip(noOfAssignedTeamMembers).First();
                        if (!hasTeamLeader)
                        {
                            auditor.IsTeamLeader = true;
                            hasTeamLeader = true;
                        }
                        auditor.IsTeamLeader = false;
                        team.Auditors!.Add(auditor);

                        noOfAssignedAuditors++;
                        noOfAssignedTeamMembers--;
                    }

                    await _teamService.SaveOrUpdateAsync(team, CancellationToken.None).ConfigureAwait(false);

                    noOfTeamsToGenerate--;
                }
            }
        }

        private async Task<List<AuditorDto>> GenerateAuditors(int noOfAuditors)
        {
            var auditors = await _auditorService.GetAll(CancellationToken.None).ConfigureAwait(false);
            if(auditors == null || noOfAuditors > auditors?.Count)
            {
                var noOfAuditorsToGenerate = noOfAuditors - auditors?.Count;
                var auditorFaker = new Faker<AuditorDto>()
                    .RuleFor(a => a.Name, f => f.Person.FullName)
                    .RuleFor(a => a.IsActive, true);

                while(noOfAuditorsToGenerate > 0)
                {
                    var auditor = auditorFaker.Generate();

                    await _auditorService.SaveOrUpdateAsync(auditor, CancellationToken.None).ConfigureAwait(false);

                    auditors!.Add(new AuditorDto() 
                    { 
                        Id = auditor.Id, 
                        Name = auditor.Name, 
                        IsActive = auditor.IsActive 
                    });
                    noOfAuditorsToGenerate--;
                }
            }

            return auditors!;
        }
    }
}
