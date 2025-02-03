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
            DateTime startDate = new DateTime(2025, 1, 29) + new TimeSpan(13, 0, 0);
            DateTime endDate = new DateTime(2025, 1, 31) + new TimeSpan(17, 0, 0);

            int noOfHoursPerAudit = 2;

            await GenerateAuditors(100).ConfigureAwait(false);
            await GenerateTeams(14).ConfigureAwait(false);
            var offices = await GenerateAndGetOffices(77).ConfigureAwait(false);
            var auditScheduleFaker = new Faker<AuditScheduleDto>()
                .RuleFor(a => a.AuditTitle, f => f.Lorem.Text())
                .RuleFor(a => a.StartDate, startDate)
                .RuleFor(a => a.EndDate, endDate)
                .RuleFor(a => a.Offices, offices);

            var auditSchedule = auditScheduleFaker.Generate();

            await _auditScheduleService.SaveOrUpdateAsync(auditSchedule, CancellationToken.None).ConfigureAwait(false);
        }

        private async Task<List<OfficeDto>> GenerateAndGetOffices(int noOfOffices)
        {
            var offices = await _officeService.GetAllAsync(CancellationToken.None);

            if (offices == null || noOfOffices > offices?.Count)
            {
                var noOfOfficesToGenerate = noOfOffices - offices?.Count;
                var officeFaker = new Faker<OfficeDto>()
                    .RuleFor(o => o.Name, f => f.Commerce.Department())
                    .RuleFor(o => o.IsActive, true);

                while(noOfOfficesToGenerate > 0)
                {
                    var office = officeFaker.Generate();
                    await _officeService.SaveOrUpdateAsync(office, CancellationToken.None).ConfigureAwait(false);

                    var savedOffice = await _context.Offices.FirstOrDefaultAsync(o => o.Name == office.Name).ConfigureAwait(false);
                    offices!.Add(new OfficeDto() { Id = savedOffice!.Id, Name = savedOffice.Name, IsActive = savedOffice.IsActive});
                    noOfOfficesToGenerate--;
                }
            }

            return offices!;
        }

        private async Task GenerateTeams(int noOfTeams)
        {
            var teams = await _teamService.GetAllActiveAsync(CancellationToken.None).ConfigureAwait(false);
            if(teams == null || noOfTeams > teams?.Count)
            {
                var noOfTeamsToGenerate = noOfTeams - teams?.Count;
                var teamFaker = new Faker<TeamDto>()
                .RuleFor(t => t.Name, f => f.Lorem.Word())
                .RuleFor(t => t.IsActive, true);

                while(noOfTeamsToGenerate > 0)
                {
                    var team = teamFaker.Generate();

                    await _teamService.SaveOrUpdateAsync(team, CancellationToken.None).ConfigureAwait(false);

                    noOfTeamsToGenerate--;
                }
            }
        }

        private async Task GenerateAuditors(int noOfAuditors)
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
                    noOfAuditorsToGenerate--;
                }
            }
        }
    }
}
