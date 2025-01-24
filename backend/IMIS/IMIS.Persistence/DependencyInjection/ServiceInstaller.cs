using IMIS.Application.AuditorModule;
using IMIS.Persistence.AuditorModule;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Persistence.DependencyInjection
{
    public static class ServiceInstaller
    {
        public static IServiceCollection AddPersistence(this IServiceCollection services)
        {
            services.AddScoped<IAuditorRepository, AuditorRepository>();
            services.AddScoped<IAuditorService, AuditorService>();
            return services;
        }
    }
}
