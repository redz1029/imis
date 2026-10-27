using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.CalendarActivityModule;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Application.ISATModule;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
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
using IMIS.Application.StrategicChangeAgendaModule;
using IMIS.Application.AuditChecklistModule;
using IMIS.Application.AuditPlanModule;
using IMIS.Application.AuditProgrammeModule;
using IMIS.Application.AuditReportModule;
using IMIS.Application.AuditScheduleModule;
using IMIS.Application.NonconformingActionReportModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Application.SWOTAnalysisModule;
using IMIS.Application.SWOTAnalysisServiceHeadModule;
using IMIS.Application.TeamModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using IMIS.Application.PolicyAndProcedureModule;

namespace IMIS.Infrastructure.Auths
{
    public class RoleAndPermissionSeeder : IRoleAndPermissionSeeder
    {
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<User> _userManager;

        public RoleAndPermissionSeeder(RoleManager<IdentityRole> roleManager, UserManager<User> userManager)
        {
            _roleManager = roleManager;
            _userManager = userManager;
        }

        public async Task SeedAsync()
        {
            // This will seed all roles and Permissions for AdministratorRole
            await PermissionSeeder.SeedAllPermissionsForAdministrator(_roleManager);

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
                new PolicyAndProcedurePermission());

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
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission(),
                new PolicyAndProcedurePermission());


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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());                

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
                new StrategicChangeAgendaPermission());                

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategyReviewPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

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
                new StrategicChangeAgendaPermission());

            // -----------------------------------------------------------------
            // QMS Audit Module roles
            // QMR / QMS are read-only across the IQA module: QMR additionally
            // approves or rejects submissions, QMS only adds notes.
            // -----------------------------------------------------------------

            await PermissionSeeder.SeedPermissionForRole<QMR, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission(),
                new PolicyAndProcedurePermission());

            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMR, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<QMR, IdentityRole>(_roleManager,
                new AuditProgrammeWorkflowPermission().CanApprove,
                new AuditProgrammeWorkflowPermission().CanReject,
                new AuditPlanWorkflowPermission().CanApprove,
                new AuditPlanWorkflowPermission().CanReject,
                new AuditReportWorkflowPermission().CanApprove,
                new AuditReportWorkflowPermission().CanReject,
                new NonconformingActionReportWorkflowPermission().CanValidateAndClose);
         
            await PermissionSeeder.SeedViewOnlyPermissionForRole<QMS, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<QMS, IdentityRole>(_roleManager,
                new AuditProgrammeWorkflowPermission().CanNote,
                new AuditPlanWorkflowPermission().CanNote,
                new AuditScheduleWorkflowPermission().CanNote,
                new AuditChecklistWorkflowPermission().CanNote,
                new AuditReportWorkflowPermission().CanNote);

            // Lead Auditor owns the Programme/Plan and closes NCARs.
            await PermissionSeeder.SeedPermissionForRole<LeadAuditor, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission());

            await PermissionSeeder.SeedViewOnlyPermissionForRole<LeadAuditor, IdentityRole>(_roleManager,
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<LeadAuditor, IdentityRole>(_roleManager,
                new AuditProgrammeWorkflowPermission().CanSubmitForApproval,
                new AuditProgrammeWorkflowPermission().CanReject,
                new AuditProgrammeWorkflowPermission().CanNote,
                new AuditPlanWorkflowPermission().CanSubmitForApproval,
                new AuditPlanWorkflowPermission().CanApprove,
                new AuditPlanWorkflowPermission().CanReject,
                new AuditPlanWorkflowPermission().CanNote,
                new NonconformingActionReportWorkflowPermission().CanRespond,
                new NonconformingActionReportWorkflowPermission().CanVerify,
                new NonconformingActionReportWorkflowPermission().CanValidateAndClose);

            // Auditor Team Leader creates/submits schedules, checklists/reports
            // and verifies NCARs.
            await PermissionSeeder.SeedViewOnlyPermissionForRole<AuditorTeamLeader, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<AuditorTeamLeader, IdentityRole>(_roleManager,
                new AuditSchedulePermission().Add,
                new AuditSchedulePermission().Edit,
                new AuditScheduleWorkflowPermission().CanSubmit,
                new AuditChecklistPermission().Add,
                new AuditChecklistPermission().Edit,
                new AuditChecklistWorkflowPermission().CanSubmit,
                new AuditReportPermission().Add,
                new AuditReportPermission().Edit,
                new AuditReportWorkflowPermission().CanSubmit,
                new NonconformingActionReportPermission().Add,
                new NonconformingActionReportPermission().Edit,
                new NonconformingActionReportWorkflowPermission().CanAcknowledge,
                new NonconformingActionReportWorkflowPermission().CanVerify);

            // Department Head confirms or rejects the submitted schedule.
            await PermissionSeeder.SeedViewOnlyPermissionForRole<DepartmentHead, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<DepartmentHead, IdentityRole>(_roleManager,
                new AuditScheduleWorkflowPermission().CanConfirm,
                new AuditScheduleWorkflowPermission().CanReject,
                new AuditScheduleWorkflowPermission().CanNote,
                new NonconformingActionReportWorkflowPermission().CanAcknowledge,
                new NonconformingActionReportWorkflowPermission().CanValidateAndClose);

            // Auditor works on checklists/NCARs/report drafts.
            await PermissionSeeder.SeedViewOnlyPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new AuditProgrammePermission(),
                new AuditPlanPermission(),
                new AuditSchedulePermission(),
                new AuditChecklistPermission(),
                new AuditReportPermission(),
                new NonconformingActionReportPermission());

            await PermissionSeeder.SeedSpecificPermssionsToRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new AuditChecklistPermission().Add,
                new AuditChecklistPermission().Edit,
                new AuditChecklistWorkflowPermission().CanSubmit,
                new AuditReportPermission().Add,
                new AuditReportPermission().Edit,
                new AuditReportWorkflowPermission().CanSubmit,
                new NonconformingActionReportPermission().Add,
                new NonconformingActionReportPermission().Edit,
                new NonconformingActionReportWorkflowPermission().CanAcknowledge,
                new NonconformingActionReportWorkflowPermission().CanVerify);

            // The Auditor role only works on checklists, reports and NCARs.
            // Remove programme/plan/schedule write access that older seed runs
            // may have granted so the role matches its documented workflow.
            await RemovePermissionsFromRole(
                new PgsAuditorRole().Name,
                new AuditProgrammePermission().Add,
                new AuditProgrammePermission().Edit,
                new AuditPlanPermission().Add,
                new AuditPlanPermission().Edit,
                new AuditSchedulePermission().Add,
                new AuditSchedulePermission().Edit);

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg");
                
        }

        private async Task RemovePermissionsFromRole(string roleName, params string[] permissionValues)
        {
            var role = await _roleManager.FindByNameAsync(roleName);
            if (role == null)
                return;

            var existingClaims = await _roleManager.GetClaimsAsync(role);
            foreach (var claim in existingClaims.Where(c =>
                c.Type == PermissionClaimType.Claim &&
                permissionValues.Contains(c.Value, StringComparer.OrdinalIgnoreCase)))
            {
                await _roleManager.RemoveClaimAsync(role, claim);
            }
        }
    }
}
