using DotNetEnv;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace ImisTest
{
    public abstract class BaseTests
    {
        protected ServiceProvider _serviceProvider;
        protected ImisDbContext _context;
        protected ServiceCollection _services;

        [SetUp]
        public virtual void Setup()
        {
            Env.Load(AppDomain.CurrentDomain.BaseDirectory + "../../../.env");
            _services = new ServiceCollection();

            string connString = Environment.GetEnvironmentVariable("SQL_SERVER_CONN")!;
            _services.AddDbContext<ImisDbContext>(options => options.UseSqlServer(connString));
        }

        [TearDown]
        public void TearDown()
        {
            _context.Dispose();
            _serviceProvider.Dispose();
        }

        protected void BuildServiceProvider()
        {
            _serviceProvider = _services.BuildServiceProvider();
            _context = _serviceProvider.GetRequiredService<ImisDbContext>();
            _context.Database.EnsureCreated();
        }
    }
}
