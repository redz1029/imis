using Bogus;
using IMIS.Application.TeamModule;
using IMIS.Persistence.TeamModule;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ImisTest
{
    [TestFixture]
    public class TeamTests : BaseTests
    {
        private ITeamService _teamService;

        [SetUp]
        public override void Setup()
        {
            base.Setup();

            _services.AddScoped<ITeamRepository, TeamRepository>();
            _services.AddScoped<ITeamService, TeamService>();

            BuildServiceProvider();

            _teamService = _serviceProvider.GetRequiredService<ITeamService>();
        }

        [Test]
        public async Task TestSaveOffice()
        {
            var teamFaker = new Faker<TeamDto>()
                .RuleFor(t => t.Name, f => f.Lorem.Word())
                .RuleFor(t => t.IsActive, true);

            var team = teamFaker.Generate();
            var teamName = team.Name;

            await _teamService.SaveOrUpdateAsync(team, CancellationToken.None).ConfigureAwait(false);

            var savedTeam = await _context.Teams.FirstOrDefaultAsync(t => t.Name == teamName).ConfigureAwait(false);
            Assert.IsNotNull(savedTeam);
            Assert.That(savedTeam.Name, Is.EqualTo(teamName));
        }
    }
}
