using System.Reflection;
using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.AuditReportModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.CalendarActivityModule;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Application.ISATModule;
using IMIS.Application.IsoStandardModule;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;    
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Application.PermissionSettings;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsPermissionSettings;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.PolicyAndProcedureHistoryLogModule;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Application.StrategicChangeAgendaModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.SWOTAnalysisServiceHeadModule;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Infrastructure.Auths
{
    public class RoleAndPermissionSeeder : IRoleAndPermissionSeeder
    {
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<User> _userManager;

        private readonly Base.Abstractions.AuditableDbContext<User> _db;

        public RoleAndPermissionSeeder(
            RoleManager<IdentityRole> roleManager,
            UserManager<User> userManager,
            Base.Abstractions.AuditableDbContext<User> db)
        {
            _db = db;
            _roleManager = roleManager;
            _userManager = userManager;
        }

        public async Task SeedAsync()
        {
            // This will seed all roles and Permissions for AdministratorRole
            await PermissionSeeder.SeedAllPermissionsForAdministrator(_roleManager);


            await PermissionSeeder.SeedPermissionForRole<DCO, IdentityRole>(_roleManager,
               new PerformanceGovernanceSystemPermission(),
               new PgsSignatoryTemplatePermission(),
               new PgsDeliverableAccomplishmentPermission(),
               new SWOTAnalysisPermission(),
               new KeyResultAreaPermission(),
               new OperationReviewProtocolPermission(),
               new StrategyReviewPermission(),
               new PerformanceValidationToolPermission(),
               new PerformanceValidationToolPeriodPermission(),
               new CalendarActivityPermission(),
               new ImpactStrategicGoalScoreCardPermission(),
               new ImpactStrategicGoalScoreCardPeriodPermission(),
               new SWOTAnalysisServiceHeadPermission(),
               new CreateViewDeliverablePermission(),
               new CreateViewOperationReviewProtocolPermission(),
               new CreateViewRoadmapPermission(),
               new CreateViewStrategyReviewReportPermission(),
               new CreateViewSwotPermission(),
               new DeliverableStatusMonitoringPermission(),
               new PerformanceValidationToolPermission(),
               new PgsAuditorReportPermission(),
               new PGSReportPermission(),
               new PgsSettingsPermission(),
               new ScoreCardPermission(),
               new StrategicChangeAgendaPermissionSetting(),
               new StrategicChangeAgendaPermission(),
               new AuditSchedulePermission(),
               new NonconformingActionReportPermission(),
               new ISATPermission(),
               new PolicyAndProcedurePermission(),
               new PolicyAndProcedureHistoryLogPermission());

            // This will specific permissions for a role
            await PermissionSeeder.SeedPermissionForRole<StandardUserRole, IdentityRole>(_roleManager,
                new PerformanceGovernanceSystemPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KeyResultAreaPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new AuditSchedulePermission(),
                new NonconformingActionReportPermission(),
                new ISATPermission(),
                new PolicyAndProcedurePermission(),
                new PolicyAndProcedureHistoryLogPermission());

            // This will seed view only permissions for a role
            await PermissionSeeder.SeedViewOnlyPermissionForRole<StandardUserRole, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new PgsSummaryNarrativePermissions(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new NonconformingActionReportPermission());

            // This will seed specific permission to disapprove for MCC role
            // This is only a sample implementation, @Wilbur please adjust as needed.
            await PermissionSeeder.SeedSpecificPermssionsToRole<MCC, IdentityRole>(_roleManager,
                new PerformanceGovernanceSystemPermission().Disapprove,
                new PerformanceGovernanceSystemPermission().Confirm);

            await PermissionSeeder.SeedSpecificPermssionsToRole<PgsServiceHead, IdentityRole>(_roleManager,
              new PerformanceGovernanceSystemPermission().Disapprove,
              new PerformanceGovernanceSystemPermission().Confirm);

            await PermissionSeeder.SeedPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),              
                new KeyResultAreaPermission(), 
                new PgsPeriodPermission(), 
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new BreakThroughScoringPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapPeriodPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new AuditorTeamPermission(),
                new AuditorPermission(),
                new AuditorOfficesPermission(),
                new TeamPermission(),
                new PerformanceGovernanceSystemPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedurePermission(),
                new PolicyAndProcedureHistoryLogPermission());


            await PermissionSeeder.SeedPermissionForRole<PgsManagerRole, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<PgsServiceHead, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new BreakThroughScoringPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapPeriodPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new AuditorTeamPermission(),
                new AuditorPermission(),
                new AuditorOfficesPermission(),
                new TeamPermission(),
                new PerformanceGovernanceSystemPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new ISATPermission(),
                new PolicyAndProcedurePermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<PgsHead, IdentityRole>(_roleManager, 
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new PerformanceGovernanceSystemPermission(),               
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<MCC, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),
                new PerformanceGovernanceSystemPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new AnnouncementPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedurePermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<OSM, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),
                new PerformanceGovernanceSystemPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(),
                new SWOTAnalysisPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<PgsAuditorHead, IdentityRole>(_roleManager,              
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<ServiceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPeriodPermission(),   
                new PerformanceValidationToolPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<ResearchOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<TrainingOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<LinkagesOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<FacilitiesOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<FinanceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<InformationOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<HROfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new StrategyReviewPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<SafetyOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<TWG, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<MSGC, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedPermissionForRole<PgsEvaluatorRole, IdentityRole>(_roleManager,                
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission(),
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission(),
                new CalendarActivityPermission(),
                new ImpactStrategicGoalScoreCardPermission(),
                new ImpactStrategicGoalScoreCardPeriodPermission(),
                new BreakThroughScoringPermission(),
                new SWOTAnalysisServiceHeadPermission(),
                new CreateViewDeliverablePermission(),
                new CreateViewOperationReviewProtocolPermission(),
                new CreateViewRoadmapPermission(),
                new CreateViewStrategyReviewReportPermission(),
                new CreateViewSwotPermission(),
                new DeliverableStatusMonitoringPermission(),
                new PerformanceValidationToolPermission(),
                new PgsAuditorReportPermission(),
                new PGSReportPermission(),
                new PgsSettingsPermission(),
                new ScoreCardPermission(),
                new StrategicChangeAgendaPermissionSetting(),
                new StrategicChangeAgendaPermission(),
                new PolicyAndProcedureHistoryLogPermission(),
                new PolicyAndProcedurePermission());

            // -----------------------------------------------------------------
            // IQA (ISO) roles. Each role gets the permission classes of the
            // modules it works on; a module it only looks at is view-only.
            // Administrator keeps all of them (SeedAllPermissionsForAdministrator).
            // -----------------------------------------------------------------

            // QMR: approves or rejects the Audit Programme and the Audit Plan.
            await PermissionSeeder.SeedPermissionForRole<QMR, IdentityRole>(_roleManager,
                new AuditProgrammeWorkflowPermission(),
                new AuditPlanWorkflowPermission(),
                new PolicyAndProcedurePermission());
            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMR, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            // QMS: notes the Audit Programme, Plan, Schedule, Checklist and Report.
            await PermissionSeeder.SeedPermissionForRole<QMS, IdentityRole>(_roleManager,
                new AuditProgrammeWorkflowPermission(),
                new AuditPlanWorkflowPermission(),
                new AuditScheduleWorkflowPermission(),
                new AuditChecklistWorkflowPermission(),
                new AuditReportWorkflowPermission());
            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMS, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            // Lead Auditor: prepares the Audit Programme and Audit Plan, and is
            // the last approver of an NCAR.
            await PermissionSeeder.SeedPermissionForRole<LeadAuditor, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditProgrammeWorkflowPermission(),
                new AuditPlanPermission(),
                new AuditPlanWorkflowPermission(),
                new NonconformingActionReportWorkflowPermission());
            await PermissionSeeder.SeedViewOnlyPermissionForRole<LeadAuditor, IdentityRole>(_roleManager,
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            // Auditor Team Leader: prepares the Audit Schedule, assigns the
            // clauses of the Audit Checklist, makes the Audit Report and raises
            // its NCARs.
            var teamLeaderPermissions = new BasePermission[]
            {
                new AuditSchedulePermission(),
                new AuditScheduleWorkflowPermission(),
                new AuditChecklistPermission(),
                new AuditChecklistWorkflowPermission(),
                new AuditReportPermission(),
                new AuditReportWorkflowPermission(),
                new NonconformingActionReportPermission()
            };
            await PermissionSeeder.SeedPermissionForRole<AuditorTeamLeader, IdentityRole>(_roleManager,
                teamLeaderPermissions);
            await PermissionSeeder.SeedViewOnlyPermissionForRole<AuditorTeamLeader, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission());

            // Department Head (auditee): confirms or reschedules the Audit
            // Schedule and answers the NCARs raised against the office.
            await PermissionSeeder.SeedPermissionForRole<DepartmentHead, IdentityRole>(_roleManager,
                new AuditScheduleWorkflowPermission(),
                new NonconformingActionReportPermission(),
                new NonconformingActionReportWorkflowPermission());
            await PermissionSeeder.SeedViewOnlyPermissionForRole<DepartmentHead, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditReportPermission());
            // ...and acknowledges the Audit Report of the office (the
            // "Acknowledged by: Auditee/Head of Office" signature). Only the
            // Approve step is given: the head cannot submit, reject or edit it.
            await PermissionSeeder.SeedSpecificPermssionsToRole<DepartmentHead, IdentityRole>(_roleManager,
                new AuditReportWorkflowPermission().CanApprove);

            // Auditor: works on checklists, reports and NCARs.
            await PermissionSeeder.SeedPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new AuditChecklistPermission(),
                new AuditChecklistWorkflowPermission(),
                new AuditReportPermission(),
                new AuditReportWorkflowPermission(),
                new NonconformingActionReportPermission(),
                new NonconformingActionReportWorkflowPermission());
            await PermissionSeeder.SeedViewOnlyPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission());

            // The Audit Programme, Plan and Schedule forms fill their dropdowns
            // (audit team, office, ISO clause) from these lookup lists. Without
            // View access the lists come back 403 and the dropdowns are empty,
            // so every IQA role that opens those forms gets view-only access.
            var iqaLookups = new BaseOperationPermission[]
            {
                new TeamPermission(),
                new AuditorTeamPermission(),
                new OfficePermission(),
                new IsoStandardPermission()
            };
            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMR, IdentityRole>(_roleManager, iqaLookups);
            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMS, IdentityRole>(_roleManager, iqaLookups);
            await PermissionSeeder.SeedViewOnlyPermissionForRole<LeadAuditor, IdentityRole>(_roleManager, iqaLookups);
            await PermissionSeeder.SeedViewOnlyPermissionForRole<AuditorTeamLeader, IdentityRole>(_roleManager, iqaLookups);
            await PermissionSeeder.SeedViewOnlyPermissionForRole<DepartmentHead, IdentityRole>(_roleManager, iqaLookups);

            // The menu reads each user's own claims, not the role's pool. Give
            // every Auditor Team Leader the permissions of the role so the ISO
            // menu (Audit Schedule, Checklist, Report, NCAR ...) shows up.
            await GrantRoleUserClaimsAsync(
                new AuditorTeamLeader().Name,
                PermissionValues(teamLeaderPermissions)
                    .Append(new AuditProgrammePermission().View)
                    .Append(new AuditPlanPermission().View)
                    .Concat(iqaLookups.Select(p => p.View))
                    .ToArray());

            // Administrators must see and do everything in IQA, so every user in
            // the Administrator role holds all of the role's permissions.
            await GrantAdministratorUserClaimsAsync();

            // Plans approved before schedules were created automatically get
            // theirs now. Never blocks startup.
            await CreateMissingSchedulesForApprovedPlansAsync();

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg");
                
        }

        /// <summary>The permission values (Add, View, CanSubmit ...) of the given permission classes.</summary>
        private static string[] PermissionValues(params BasePermission[] permissions) =>
            permissions
                .SelectMany(permission => permission.GetType()
                    .GetProperties(BindingFlags.Public | BindingFlags.Instance)
                    .Where(p => p.PropertyType == typeof(string) &&
                                p.CanRead &&
                                !(p.GetMethod?.IsAbstract ?? false) &&
                                !(p.GetMethod?.IsVirtual ?? false))
                    .Select(p => p.GetValue(permission)?.ToString()))
                .Where(v => !string.IsNullOrWhiteSpace(v))
                .Select(v => v!)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToArray();

        /// <summary>
        /// The app reads a user's permissions from per-user claims tied to the
        /// role. Permissions added to the Administrator role after an admin was
        /// set up (e.g. View Audit Programme) were never assigned to that admin,
        /// so the menu hid those modules. Assign every missing one.
        /// </summary>
        /// <summary>
        /// Adds the per-user claim for each permission in <paramref name="permissions"/>
        /// that the role holds and a user in the role is still missing. It only
        /// ever adds, and only permissions the role itself has.
        /// </summary>
        private async Task GrantRoleUserClaimsAsync(string roleName, string[] permissions)
        {
            var role = await _roleManager.FindByNameAsync(roleName);
            if (role == null)
                return;

            var rolePool = (await _roleManager.GetClaimsAsync(role))
                .Where(c => c.Type == PermissionClaimType.Claim)
                .Select(c => c.Value)
                .ToHashSet(StringComparer.OrdinalIgnoreCase);
            var toGrant = permissions
                .Where(p => rolePool.Contains(p))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();

            var users = await _userManager.GetUsersInRoleAsync(role.Name!);
            foreach (var user in users)
            {
                var assigned = _db.Set<UserClaim<string>>()
                    .Where(c => c.UserId == user.Id &&
                                c.RoleId == role.Id &&
                                c.ClaimType == PermissionClaimType.Claim)
                    .Select(c => c.ClaimValue)
                    .ToList()
                    .ToHashSet(StringComparer.OrdinalIgnoreCase);

                foreach (var permission in toGrant.Where(p => !assigned.Contains(p)))
                {
                    _db.Set<UserClaim<string>>().Add(new UserClaim<string>
                    {
                        UserId = user.Id,
                        RoleId = role.Id,
                        ClaimType = PermissionClaimType.Claim,
                        ClaimValue = permission
                    });
                }
            }

            await _db.SaveChangesAsync();
        }

        /// <summary>
        /// Creates the audit schedules of every approved audit plan that has none
        /// yet (offices that already have a schedule are skipped).
        /// </summary>
        private async Task CreateMissingSchedulesForApprovedPlansAsync()
        {
            try
            {
                var planIds = await Microsoft.EntityFrameworkCore.EntityFrameworkQueryableExtensions.ToListAsync(
                    _db.Set<AuditPlan>().Where(p => !p.IsDeleted).Select(p => p.Id));
                foreach (var planId in planIds)
                    await AuditScheduleGenerator.EnsureForPlanAsync(_db, planId, CancellationToken.None);

                await _db.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Drop whatever was half-added so it cannot leak into later saves.
                _db.ChangeTracker.Clear();
                Console.WriteLine($"Could not create the missing audit schedules: {ex.Message}");
            }
        }

        private async Task GrantAdministratorUserClaimsAsync()
        {
            var role = await _roleManager.FindByNameAsync(new AdministratorRole().Name!);
            if (role == null)
                return;

            var rolePermissions = (await _roleManager.GetClaimsAsync(role))
                .Where(c => c.Type == PermissionClaimType.Claim)
                .Select(c => c.Value)
                .Distinct()
                .ToList();

            var administrators = await _userManager.GetUsersInRoleAsync(role.Name!);
            foreach (var administrator in administrators)
            {
                var assigned = _db.Set<UserClaim<string>>()
                    .Where(c => c.UserId == administrator.Id &&
                                c.RoleId == role.Id &&
                                c.ClaimType == PermissionClaimType.Claim)
                    .Select(c => c.ClaimValue)
                    .ToList()
                    .ToHashSet(StringComparer.OrdinalIgnoreCase);

                foreach (var permission in rolePermissions.Where(p => !assigned.Contains(p)))
                {
                    _db.Set<UserClaim<string>>().Add(new UserClaim<string>
                    {
                        UserId = administrator.Id,
                        RoleId = role.Id,
                        ClaimType = PermissionClaimType.Claim,
                        ClaimValue = permission
                    });
                }
            }

            await _db.SaveChangesAsync();
        }
    }
}
