using Bogus;
using IMIS.Application.OfficeModule;
using IMIS.Persistence.OfficeModule;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ImisTest
{
    [TestFixture]
    public class OfficeTests : BaseTests
    {
        private IOfficeService _officeService;

        [SetUp]
        public override void Setup()
        {
            base.Setup();

            _services.AddScoped<IOfficeRepository, OfficeRepository>();
            _services.AddScoped<IOfficeService, OfficeService>();

            BuildServiceProvider();

            _officeService = _serviceProvider.GetRequiredService<IOfficeService>();
        }

        [Test]
        public async Task TestSaveOffice()
        {
            var officeFaker = new Faker<OfficeDto>()
                .RuleFor(o => o.Name, f => f.Commerce.Department())
                .RuleFor(o => o.IsActive, true);

            var fakeOffice = officeFaker.Generate();
            string officeName = fakeOffice.Name;
            await _officeService.SaveOrUpdateAsync(fakeOffice, CancellationToken.None).ConfigureAwait(false);

            var savedOffice = await _context.Offices.FirstOrDefaultAsync(o => o.Name == officeName).ConfigureAwait(false);
            Assert.IsNotNull(savedOffice);
            Assert.That(savedOffice.Name, Is.EqualTo(officeName));
        }
    }
}