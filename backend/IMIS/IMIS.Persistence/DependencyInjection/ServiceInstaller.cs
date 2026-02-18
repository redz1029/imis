using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OfficeTypeModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.TeamModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Application.IsoStandardModule;
using IMIS.Persistence.AnnouncementModule;
using IMIS.Persistence.AuditorModule;
using IMIS.Persistence.AuditorOfficesModule;
using IMIS.Persistence.AuditorTeamsModule;
using IMIS.Persistence.AuditScheduleModule;
using IMIS.Persistence.BreakThroughScoringModule;
using IMIS.Persistence.KraModule;
using IMIS.Persistence.KraRoadMapDeliverableModule;
using IMIS.Persistence.KraRoadMapKpiModule;
using IMIS.Persistence.KraRoadMapModule;
using IMIS.Persistence.KraRoadMapPeriodModule;
using IMIS.Persistence.KraRoadMapRoleModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.OfficeTypeModule;
using IMIS.Persistence.PgsDeliverableAccomplishmentModule;
using IMIS.Persistence.PgsModule;
using IMIS.Persistence.PGSModules;
using IMIS.Persistence.PgsPeriodModule;
using IMIS.Persistence.PGSReadinessRatingCancerCareModule;
using IMIS.Persistence.PgsSignatoryTemplateModule;
using IMIS.Persistence.PgsSummaryNarrativeModule;
using IMIS.Persistence.SWOTAnalysisModule;
using IMIS.Persistence.TeamModule;
using IMIS.Persistence.UserOfficeModule;
using IMIS.Persistence.IsoStandardModule;
using Microsoft.Extensions.DependencyInjection;
using IMIS.Application.StandardVersionModule;
using IMIS.Persistence.StandardVersionModule;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Persistence.KraRoadMapAccomplishmentModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Persistence.KraRoadMapKpiAccomplishmentModule;

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

            services.AddScoped<IPerfomanceGovernanceSystemRepository, PerfomanceGovernanceSystemRepository>();
            services.AddScoped<IPerfomanceGovernanceSystemService, PerfomanceGovernanceSystemService>();

            services.AddScoped<IPgsPeriodRepository, PgsPeriodRepository>();
            services.AddScoped<IPgsPeriodService, PgsPeriodService>();

            services.AddScoped<IPgsReadinessRatingRepository, PgsReadinessRatingRepository>();
            services.AddScoped<IPgsReadinessRatingService, PgsReadinessRatingService>();

            services.AddScoped<IUserOfficeRepository, UserOfficeRepository>();
            services.AddScoped<IUserOfficeService, UserOfficeService>();

            services.AddScoped<IAuditScheduleRepository, AuditScheduleRepository>();
            services.AddScoped<IAuditScheduleService, AuditScheduleService>();

            services.AddScoped<IAuditScheduleDetailRepository, AuditScheduleDetailRepository>();
            services.AddScoped<IAuditScheduleDetailService, AuditScheduleDetailService>();

            services.AddScoped<IAuditorTeamsRepository, AuditorTeamsRepository>();
            services.AddScoped<IAuditorTeamsService, AuditorTeamsService>();

            services.AddScoped<IPgsSignatoryTemplateRepository, PgsSignatoryTemplateRepository>();
            services.AddScoped<IPgsSignatoryTemplateService, PgsSignatoryTemplateService>();
        
            services.AddScoped<IOfficeTypeRepository, OfficeTypeRepository>();
            services.AddScoped<IOfficeTypeService, OfficeTypeService>();

            services.AddScoped<IAuditorOfficesRepository, AuditorOfficesRepository>();
            services.AddScoped<IAuditorOfficesService, AuditorOfficesService>();

            services.AddScoped<IPGSSummaryNarrativeRepository, PgsSummaryNarrativeRepository>();
            services.AddScoped<IPGSSummaryNarrativeService, PgsSummaryNarrativeService>();

            services.AddScoped<IPgsDeliverableAccomplishmentRepository, PgsDeliverableAccomplishmentRepository>();
            services.AddScoped<IPgsDeliverableAcomplishmentService, PgsDeliverableAccomplishmentService>();

            services.AddScoped<IAnnouncementRepository, AnnouncementRepository>();
            services.AddScoped<IAnnouncementService, AnnouncementService>();

            services.AddScoped<IBreakThroughScoringRepository, BreakThroughScoringRepository>();
            services.AddScoped<IBreakThroughScoringService, BreakThroughScoringService>();

            services.AddScoped<ISWOTAnalysisRepository, SWOTAnalysisRepository>();
            services.AddScoped<ISWOTAnalysisService, SWOTAnalysisService>();

            services.AddScoped<IKraRoadMapPeriodRepository, KraRoadMapPeriodRepository>();
            services.AddScoped<IKraRoadMapPeriodService, KraRoadMapPeriodService>();

            services.AddScoped<IKraRoadMapKpiRepository, KraRoadMapKpiRepository>();
            services.AddScoped<IKraRoadMapKpiService, KraRoadMapKpiService>();

            services.AddScoped<IKraRoadMapDeliverableRepository, KraRoadMapDeliverableRepository>();
            services.AddScoped<IKraRoadMapDeliverableService, KraRoadMapDeliverableService>();

            services.AddScoped<IkraRoadMapRepository, KraRoadMapRepository>();
            services.AddScoped<IKraRoadMapService, KraRoadMapService>();

            services.AddScoped<IKraRoadMapRoleRepository, KraRoadMapRoleRepository>();
            services.AddScoped<IKraRoadMapRoleService, KraRoadMapRoleService>();

            services.AddScoped<IKraRoadmapAccomplishmentRepository, KraRoadMapAccomplishmentRepository>();
            services.AddScoped<IKraRoadmapAccomplishmentService, KraRoadMapAccomplishmentService>();

            services.AddScoped<IKraRoadmapKpiAccomplishmentRepository, KraRoadMapKpiAccomplishmentRepository>();
            services.AddScoped<IKraRoadmapKpiAccomplishmentService, KraRoadMapKpiAccomplishmentService>();

            // ISO Standard module registrations
            services.AddScoped<IStandardVersionRepository, StandardVersionRepository>();
            services.AddScoped<IStandardVersionService, StandardVersionService>();
            services.AddScoped<IIsoStandardRepository, IsoStandardRepository>();
            services.AddScoped<IIsoStandardService, IsoStandardService>();

            return services;
        }
    }
}
