using Bogus;
using IMIS.Application.AuditorModule;
using IMIS.Persistence.AuditorModule;

//using IMIS.Persistence.AuditorModule;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ImisTest
{
    [TestFixture]
    public class AuditorTests : BaseTests
    {
        private IAuditorService _auditorService;

        [SetUp]
        public override void Setup()
        {
            base.Setup();

            _services.AddScoped<IAuditorRepository, AuditorRepository>();
            _services.AddScoped<IAuditorService, AuditorService>();

            base.BuildServiceProvider();

            _auditorService = _serviceProvider.GetRequiredService<IAuditorService>();
        }

        [Test]
        public async Task TestSaveAuditor()
        {
            var auditorFaker = new Faker<AuditorDto>()
                //.RuleFor(a => a.Name, f => f.Person.FullName)
                .RuleFor(a => a.IsActive, true);

            var auditor = auditorFaker.Generate();


            await _auditorService.SaveOrUpdateAsync(auditor, CancellationToken.None).ConfigureAwait(false);

            //var savedAuditor = await _context.Auditors.FirstOrDefaultAsync(a => a.UserId == auditorName).ConfigureAwait(false);
            //Assert.IsNotNull(savedAuditor);
            //Assert.That(savedAuditor.UserId, Is.EqualTo(auditorName));
        }
    }
}
