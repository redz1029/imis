using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditChecklistQNAModule;
using IMIS.Application.AuditComFindingsModule;
using IMIS.Application.AuditNcarStatusModule;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditReportModule;
using IMIS.Application.AuditPlanPersonResponsibleModule;
using IMIS.Application.AuditPlanProcessModule;
using IMIS.Application.AuditPlanStatusModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.AuditScopeModule;
using IMIS.Application.AuditSummaryFindingsModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.ImprovementTypeModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Application.IsoAuditProcessModule;
using IMIS.Application.IsoStandardAuditPlanModule;
using IMIS.Application.IsoStandardModule;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.KraRoadmapProcessKraAssignmentModule;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OfficeTypeModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.StandardVersionModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.TeamModule;
using IMIS.Application.UserOfficeModule;
using IMIS.Persistence.AnnouncementModule;
using IMIS.Persistence.AuditChecklistModule;
using IMIS.Persistence.AuditChecklistQNAModule;
using IMIS.Persistence.AuditComFindingsModule;
using IMIS.Persistence.AuditNcarStatusModule;
using IMIS.Persistence.AuditorModule;
using IMIS.Persistence.AuditorOfficesModule;
using IMIS.Persistence.AuditorTeamsModule;
using IMIS.Persistence.AuditPlanApprovalModule;
using IMIS.Persistence.AuditPlanEntryModule;
using IMIS.Persistence.AuditPlanModule;
using IMIS.Persistence.AuditReportModule;
using IMIS.Persistence.AuditPlanPersonResponsibleModule;
using IMIS.Persistence.AuditPlanProcessModule;
using IMIS.Persistence.AuditPlanStatusModule;
using IMIS.Persistence.AuditProgrammeModule;
using IMIS.Persistence.AuditScheduleModule;
using IMIS.Persistence.AuditScopeModule;
using IMIS.Persistence.AuditSummaryFindingsModule;
using IMIS.Persistence.BreakThroughScoringModule;
using IMIS.Persistence.ImprovementTypeModule;
using IMIS.Persistence.IsoAuditorModule;
using IMIS.Persistence.IsoAuditProcessModule;
using IMIS.Persistence.IsoStandardAuditPlanModule;
using IMIS.Persistence.IsoStandardModule;
using IMIS.Persistence.KraModule;
using IMIS.Persistence.KraRoadMapAccomplishmentModule;
using IMIS.Persistence.KraRoadmapCoreSupportProcessModule;
using IMIS.Persistence.KraRoadMapDeliverableModule;
using IMIS.Persistence.KraRoadMapKpiAccomplishmentModule;
using IMIS.Persistence.KraRoadMapKpiModule;
using IMIS.Persistence.KraRoadMapModule;
using IMIS.Persistence.KraRoadMapPeriodModule;
using IMIS.Persistence.KraRoadmapProcessKraAssignmentModule;
using IMIS.Persistence.KraRoadMapRoleModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.OfficeTypeModule;
using IMIS.Persistence.OperationReviewProtocolModule;
using IMIS.Persistence.PgsDeliverableAccomplishmentModule;
using IMIS.Persistence.PgsModule;
using IMIS.Persistence.PGSModules;
using IMIS.Persistence.PgsPeriodModule;
using IMIS.Persistence.PGSReadinessRatingCancerCareModule;
using IMIS.Persistence.PgsSignatoryTemplateModule;
using IMIS.Persistence.PgsSummaryNarrativeModule;
using IMIS.Persistence.StandardVersionModule;
using IMIS.Persistence.StrategyReviewModule;
using IMIS.Persistence.SWOTAnalysisModule;
using IMIS.Persistence.TeamModule;
using IMIS.Persistence.UserOfficeModule;
using Microsoft.Extensions.DependencyInjection;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Application.KraRoadmapCoreSupportProcessModule;

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

            services.AddScoped<IAuditScheduleDetailsRepository, AuditScheduleDetailsRepository>();
            services.AddScoped<IAuditScheduleDetailsService, AuditScheduleDetailsService>();

            services.AddScoped<IAuditorTeamsRepository, AuditorTeamsRepository>();
            services.AddScoped<IAuditorTeamsService, AuditorTeamsService>();

            services.AddScoped<IPgsSignatoryTemplateRepository, PgsSignatoryTemplateRepository>();
            services.AddScoped<IPgsSignatoryTemplateService, PgsSignatoryTemplateService>();
        
            services.AddScoped<IOfficeTypeRepository, OfficeTypeRepository>();
            services.AddScoped<IOfficeTypeService, OfficeTypeService>();

            services.AddScoped<IImprovementTypeRepository, ImprovementTypeRepository>();
            services.AddScoped<IImprovementTypeService, ImprovementTypeService>();

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

            services.AddScoped<IKraRoadmapCoreSupportProcessRepository, KraRoadmapCoreSupportProcessRepository>();
            services.AddScoped<IKraRoadmapCoreSupportProcessService, KraRoadmapCoreSupportProcessService>();

            services.AddScoped<IKraRoadmapProcessKraAssignmentRepository, KraRoadmapProcessKraAssignmentRepository>();
            services.AddScoped<IKraRoadmapProcessKraAssignmentService, KraRoadmapProcessKraAssignmentService>();

            services.AddScoped<IOperationReviewProtocolRepository, OperationReviewProtocolRepository>();
            services.AddScoped<IOperationReviewProtocolService, OperationReviewProtocolService>();

            services.AddScoped<IStrategyReviewRepository, StrategyReviewRepository>();
            services.AddScoped<IStrategyReviewService, StrategyReviewService>();

            // ISO Standard module registrations
            services.AddScoped<IStandardVersionRepository, StandardVersionRepository>();
            services.AddScoped<IStandardVersionService, StandardVersionService>();

            services.AddScoped<IIsoStandardRepository, IsoStandardRepository>();
            services.AddScoped<IIsoStandardService, IsoStandardService>();


            services.AddScoped<IAuditPlanRepository, AuditPlanRepository>();
            services.AddScoped<IAuditPlanService, AuditPlanService>();

            services.AddScoped<IAuditPlanApprovalRepository, AuditPlanApprovalRepository>();
            services.AddScoped<IAuditPlanApprovalService, AuditPlanApprovalService>();

            services.AddScoped<IAuditPlanEntryRepository, AuditPlanEntryRepository>();
            services.AddScoped<IAuditPlanEntryService, AuditPlanEntryService>();

            services.AddScoped<IAuditScheduleDetailsRepository, AuditScheduleDetailsRepository>();
            services.AddScoped<IAuditScheduleDetailsService, AuditScheduleDetailsService>();

            services.AddScoped<IAuditPlanPersonResponsibleRepository, AuditPlanPersonResponsibleRepository>();
            services.AddScoped<IAuditPlanPersonResponsibleService, AuditPlanPersonResponsibleService>();

            services.AddScoped<IAuditPlanProcessRepository, AuditPlanProcessRepository>();
            services.AddScoped<IAuditPlanProcessService, AuditPlanProcessService>();
            services.AddScoped<IIsoAuditProcessRepository,IsoAuditProcessRepository>();
            services.AddScoped<IIsoAuditProcessService, IsoAuditProcessService>();
            // Inside your Program.cs or Service registration method
            // You MUST add these registrations
            services.AddScoped<IIsoAuditorService, IsoAuditorService>();
            services.AddScoped<IIsoAuditorRepository, IsoAuditorRepository>();

            services.AddScoped<IIsoStandardAuditPlanService, IsoStandardAuditPlanService>();
            services.AddScoped<IIsoStandardAuditPlanRepository, IsoStandardAuditPlanRepository>();

            services.AddScoped<IAuditPlanStatusService, AuditPlanStatusService>();
            services.AddScoped<IAuditPlanStatusRepository, AuditPlanStatusRepository>();

            services.AddScoped<IAuditProgrammeService, AuditProgrammeService>();
            services.AddScoped<IAuditProgrammeRepository, AuditProgrammeRepository>();

            //checklist module registrations

            services.AddScoped<IAuditChecklistService, AuditChecklistService>();
            services.AddScoped<IAuditChecklistRepository, AuditChecklistRepository>();

            services.AddScoped<IAuditChecklistQNAService, AuditChecklistQNAService>();
            services.AddScoped<IAuditChecklistQNARepository, AuditChecklistQNARepository>();

            //audit report module registrations
            services.AddScoped<IAuditReportService, AuditReportService>();
            services.AddScoped<IAuditReportRepository, AuditReportRepository>();

            services.AddScoped<IAuditScopeService, AuditScopeService>();
            services.AddScoped<IAuditScopeRepository, AuditScopeRepository>();

            services.AddScoped<IAuditComFindingsService, AuditComFindingsService>();
            services.AddScoped<IAuditComFindingsRepository, AuditComFindingsRepository>();

            services.AddScoped<IAuditSummaryFindingsService, AuditSummaryFindingsService>();
            services.AddScoped<IAuditSummaryFindingsRepository, AuditSummaryFindingsRepository>();

            services.AddScoped<IAuditNcarStatusService, AuditNcarStatusService>();
            services.AddScoped<IAuditNcarStatusRepository, AuditNcarStatusRepository>();




            return services;
        }
    }
}
