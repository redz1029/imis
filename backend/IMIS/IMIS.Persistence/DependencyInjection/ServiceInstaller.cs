using IMIS.Application.AuditorModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsModule;
using IMIS.Application.TeamModule;
using IMIS.Persistence.AuditorModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.PGSModules;
using IMIS.Persistence.TeamModule;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Persistence.DependencyInjection
{
    public static class ServiceInstaller
    {
        public static IServiceCollection AddPersistence(this IServiceCollection services)
        {
            services.AddScoped<IAuditorRepository, AuditorRepository>();
            services.AddScoped<IAuditorService, AuditorService>();

            services.AddScoped<IOfficeRepository, OfficeRepository>();
            services.AddScoped<IOfficeService, OfficeService>();

            services.AddScoped<ITeamRepository, TeamRepository>();
            services.AddScoped<ITeamService, TeamService>();

            services.AddScoped<IPGSRepository, PGSRepository>();
            services.AddScoped<IPGSService, PGSService>();

            return services;
        }
    }
}
