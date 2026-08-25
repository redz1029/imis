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
using IMIS.Application.CalendarActivityModule;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Application.IsoStandardModule;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadmapHistoryModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadmapKpiSequenceModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.KraRoadmapProcessKraAssignmentModule;
using IMIS.Application.KraRoadMapRoleAssignmentModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OfficeTypeModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PerformanceValidationToolConclusionModule;
using IMIS.Application.PerformanceValidationToolDeliverableFindingsModule;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PerformanceValidationToolObjectivesModule;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Application.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Application.PerformanceValidationToolValidatorsModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.StandardVersionModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Application.StrategyReviewPeriodModule;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule;
using IMIS.Application.SWOTAnalysisStrengthWeaknessModule;
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
using IMIS.Persistence.CalendarActivityModule;
using IMIS.Persistence.ImpactStrategicGoalScoreCardModule;
using IMIS.Persistence.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Persistence.IsoStandardModule;
using IMIS.Persistence.KraModule;
using IMIS.Persistence.KraRoadMapAccomplishmentModule;
using IMIS.Persistence.KraRoadmapCoreSupportProcessModule;
using IMIS.Persistence.KraRoadMapDeliverableModule;
using IMIS.Persistence.KraRoadmapHistoryModule;
using IMIS.Persistence.KraRoadMapKpiAccomplishmentModule;
using IMIS.Persistence.KraRoadMapKpiModule;
using IMIS.Persistence.KraRoadmapKpiSequenceModule;
using IMIS.Persistence.KraRoadMapModule;
using IMIS.Persistence.KraRoadMapPeriodModule;
using IMIS.Persistence.KraRoadmapProcessKraAssignmentModule;
using IMIS.Persistence.KraRoadMapRoleModule;
using IMIS.Persistence.OfficeModule;
using IMIS.Persistence.OfficeTypeModule;
using IMIS.Persistence.OperationReviewProtocolModule;
using IMIS.Persistence.PerformanceValidationToolConclusionModule;
using IMIS.Persistence.PerformanceValidationToolDeliverableFindingsModule;
using IMIS.Persistence.PerformanceValidationToolModule;
using IMIS.Persistence.PerformanceValidationToolObjectivesModule;
using IMIS.Persistence.PerformanceValidationToolPeriodModule;
using IMIS.Persistence.PerformanceValidationToolSignatoryTemplateModule;
using IMIS.Persistence.PerformanceValidationToolValidatorsModule;
using IMIS.Persistence.PgsDeliverableAccomplishmentModule;
using IMIS.Persistence.PgsModule;
using IMIS.Persistence.PGSModules;
using IMIS.Persistence.PgsPeriodModule;
using IMIS.Persistence.PGSReadinessRatingCancerCareModule;
using IMIS.Persistence.PgsSignatoryModule;
using IMIS.Persistence.PgsSignatoryTemplateModule;
using IMIS.Persistence.PgsSummaryNarrativeModule;
using IMIS.Persistence.StandardVersionModule;
using IMIS.Persistence.StrategyReviewModule;
using IMIS.Persistence.StrategyReviewPeriodModule;
using IMIS.Persistence.SWOTAnalysisModule;
using IMIS.Persistence.SWOTAnalysisOpportunitiesThreatsModule;
using IMIS.Persistence.SWOTAnalysisStrengthWeaknessModule;
using IMIS.Persistence.TeamModule;
using IMIS.Persistence.UserOfficeModule;
using Microsoft.EntityFrameworkCore.ChangeTracking.Internal;
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

            services.AddScoped<IStrategyReviewPeriodRepository, StrategyReviewPeriodRepository>();
            services.AddScoped<IStrategyReviewPeriodService, StrategyReviewPeriodService>();

            services.AddScoped<IPerformanceValidationToolPeriodRepository, PerformanceValidationToolPeriodRepository>();
            services.AddScoped<IPerformanceValidationToolPeriodService, PerformanceValidationToolPeriodService>();

            services.AddScoped<IPerformanceValidationToolSignatoryTemplateRepository, PerformanceValidationToolSignatoryTemplateRepository>();
            services.AddScoped<IPerformanceValidationToolSignatoryTemplateService, PerformanceValidationToolSignatoryTemplateService>();

            services.AddScoped<IPerformanceValidationToolObjectivesRepository, PerformanceValidationToolObjectivesRepository>();
            services.AddScoped<IPerformanceValidationToolObjectivesService, PerformanceValidationToolObjectivesService>();

            services.AddScoped<IPerformanceValidationToolConclusionRepository, PerformanceValidationToolConclusionRepository>();
            services.AddScoped<IPerformanceValidationToolConclusionService, PerformanceValidationToolConclusionService>();

            services.AddScoped<IPerformanceValidationToolValidatorsRepository, PerformanceValidationToolValidatorsRepository>();
            services.AddScoped<IPerformanceValidationToolValidatorsService, PerformanceValidationToolValidatorsService>();

            services.AddScoped<IPerformanceValidationToolDeliverableFindingsRepository, PerformanceValidationToolDeliverableFindingsRepository>();
            services.AddScoped<IPerformanceValidationToolDeliverableFindingsService, PerformanceValidationToolDeliverableFindingsService>();

            services.AddScoped<IPerformanceValidationToolRepository, PerformanceValidationToolRepository>();
            services.AddScoped<IPerformanceValidationToolService, PerformanceValidationToolService>();

            services.AddScoped<IPgsSignatoryRepository, PgsSignatoryRepository>();
            services.AddScoped<IPgsSignatoryService, PgsSignatoryService>();
            
            services.AddScoped<ICalendarActivityRepository, CalendarActivityRepository>();
            services.AddScoped<ICalendarActivityService, CalendarActivityService>();

            services.AddScoped<IKraRoadmapHistoryRepository, KraRoadmapHistoryRepository>();
            services.AddScoped<IKraRoadmapHistoryService, KraRoadmapHistoryService>();

            services.AddScoped<IImpactStrategicGoalScoreCardRepository, ImpactStrategicGoalScoreCardRepository>();
            services.AddScoped<IImpactStrategicGoalScoreCardService, ImpactStrategicGoalScoreCardService>();

            services.AddScoped<IImpactStrategicGoalScoreCardPeriodRepository, ImpactStrategicGoalScoreCardPeriodRepository>();
            services.AddScoped<IImpactStrategicGoalScoreCardPeriodService, ImpactStrategicGoalScoreCardPeriodService>();

            services.AddScoped<IKraRoadmapKpiSequenceRepository, KraRoadmapKpiSequenceRepository>();
            services.AddScoped<IKraRoadmapKpiSequenceService, KraRoadmapKpiSequenceService>();

            services.AddScoped<ISWOTAnalysisOpportunitiesThreatsSettingsRepository, SWOTAnalysisOpportunitiesThreatsSettingsRepository>();
            services.AddScoped<ISWOTAnalysisOpportunitiesThreatsSettingsService, SWOTAnalysisOpportunitiesThreatsSettingsService>();

            services.AddScoped<ISWOTAnalysisStrengthWeaknessSettingsRepository, SWOTAnalysisStrengthWeaknessSettingsRepository>();
            services.AddScoped<ISWOTAnalysisStrengthWeaknessSettingsService, SWOTAnalysisStrengthWeaknessSettingsService>();

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
