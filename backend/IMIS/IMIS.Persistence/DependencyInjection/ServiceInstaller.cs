using IMIS.Application.AuditorModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.TeamModule;
using IMIS.Persistence.AuditorModule;
using IMIS.Persistence.KraModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.PgsModule;
using IMIS.Persistence.PGSModules;
using IMIS.Persistence.PgsPeriodModule;
using IMIS.Persistence.PGSReadinessRatingCancerCareModule;
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

            services.AddScoped<IPGSDeliverableRepository, PGSDeliverableRepository>();
            services.AddScoped<IPGSDeliverableService, PGSDeliverableService>();

            services.AddScoped<IKeyResultAreaRepository, KeyResultAreaRepository>();
            services.AddScoped<IKeyResultAreaService, KeyResultAreaService>();

            services.AddScoped<IPgsAuditDetailsRepository, PgsAuditDetailsRepository>();
            services.AddScoped<IPgsAuditDetailsService, PgsAuditDetailsService>();

            services.AddScoped<IPgsPeriodRepository, PgsPeriodRepository>();
            services.AddScoped<IPgsPeriodService, PgsPeriodService>();

            services.AddScoped<IPGSReadinessRatingCancerCareRepository, PGSReadinessRatingCancerCareRepository>();
            services.AddScoped<IPgsReadinessRatingCancerCareService, PgsReadinessRatingCancerCareService>();


            return services;
        }
    }
}
