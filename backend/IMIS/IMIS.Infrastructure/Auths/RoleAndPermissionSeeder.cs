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
using IMIS.Application.IsoStandardModule;
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
using System.Reflection;
using IMIS.Application.PolicyAndProcedureModule;

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
            // IQA (ISO) roles
            // Seeding only ever ADDS claims, so after granting what a role may
            // do, SyncIqaPermissionsAsync strips every other IQA claim an older
            // seed run may have left on the role. Administrator keeps all of
            // them (SeedAllPermissionsForAdministrator above).
            // -----------------------------------------------------------------
            var programme = new AuditProgrammePermission();
            var programmeFlow = new AuditProgrammeWorkflowPermission();
            var plan = new AuditPlanPermission();
            var planFlow = new AuditPlanWorkflowPermission();
            var schedule = new AuditSchedulePermission();
            var scheduleFlow = new AuditScheduleWorkflowPermission();
            var checklist = new AuditChecklistPermission();
            var checklistFlow = new AuditChecklistWorkflowPermission();
            var report = new AuditReportPermission();
            var reportFlow = new AuditReportWorkflowPermission();
            var ncar = new NonconformingActionReportPermission();
            var ncarFlow = new NonconformingActionReportWorkflowPermission();

            // View access to every IQA module.
            var viewAllIqa = new[]
            {
                programme.View, plan.View, schedule.View,
                checklist.View, report.View, ncar.View
            };

            // QMR: views all of IQA; ONLY approves or rejects the Audit
            // Programme and the Audit Plan.
            var qmrPermissions = viewAllIqa.Concat(new[]
            {
                programmeFlow.CanApprove, programmeFlow.CanReject,
                planFlow.CanApprove, planFlow.CanReject
            }).ToArray();
            await PermissionSeeder.SeedPermissionForRole<QMR, IdentityRole>(_roleManager,
                new PolicyAndProcedurePermission());
            await PermissionSeeder.SeedSpecificPermssionsToRole<QMR, IdentityRole>(_roleManager, qmrPermissions);
            await SyncIqaPermissionsAsync(new QMR().Name, qmrPermissions);

            // QMS: views all of IQA; ONLY adds notes.
            var qmsPermissions = viewAllIqa.Concat(new[]
            {
                programmeFlow.CanNote, planFlow.CanNote, scheduleFlow.CanNote,
                checklistFlow.CanNote, reportFlow.CanNote
            }).ToArray();
            await PermissionSeeder.SeedSpecificPermssionsToRole<QMS, IdentityRole>(_roleManager, qmsPermissions);
            await SyncIqaPermissionsAsync(new QMS().Name, qmsPermissions);

            // Lead Auditor: prepares the Audit Programme and Audit Plan, views
            // everything else, and is the last approver of an NCAR.
            var leadAuditorPermissions = viewAllIqa.Concat(new[]
            {
                programme.Add, programme.Edit, programmeFlow.CanSubmitForApproval,
                plan.Add, plan.Edit, planFlow.CanSubmitForApproval,
                ncarFlow.CanVerify, ncarFlow.CanValidateAndClose
            }).ToArray();
            await PermissionSeeder.SeedSpecificPermssionsToRole<LeadAuditor, IdentityRole>(_roleManager, leadAuditorPermissions);
            await SyncIqaPermissionsAsync(new LeadAuditor().Name, leadAuditorPermissions);

            // Auditor Team Leader: prepares the Audit Schedule, assigns the
            // clauses of the Audit Checklist to the auditors, makes the Audit
            // Report (which issues its NCARs), and views everything else.
            var teamLeaderPermissions = viewAllIqa.Concat(new[]
            {
                schedule.Add, schedule.Edit, scheduleFlow.CanSubmit,
                checklist.Add, checklist.Edit, checklistFlow.CanSubmit,
                report.Add, report.Edit, reportFlow.CanSubmit,
                ncar.Add
            }).ToArray();
            await PermissionSeeder.SeedSpecificPermssionsToRole<AuditorTeamLeader, IdentityRole>(_roleManager, teamLeaderPermissions);
            await SyncIqaPermissionsAsync(new AuditorTeamLeader().Name, teamLeaderPermissions);

            // Department Head / auditee: confirms or reschedules the Audit
            // Schedule, views the Audit Programme and Audit Plan, and answers
            // and submits the NCARs raised against the office.
            var departmentHeadPermissions = new[]
            {
                programme.View, plan.View, schedule.View, ncar.View,
                scheduleFlow.CanConfirm, scheduleFlow.CanReject,
                ncar.Edit, ncarFlow.CanAcknowledge, ncarFlow.CanRespond
            };
            await PermissionSeeder.SeedSpecificPermssionsToRole<DepartmentHead, IdentityRole>(_roleManager, departmentHeadPermissions);
            await SyncIqaPermissionsAsync(new DepartmentHead().Name, departmentHeadPermissions);

            // The Audit Programme, Plan and Schedule forms fill their dropdowns
            // (audit team, office, ISO clause) from these lookup lists. Without
            // View access the lists come back 403 and the dropdowns are empty,
            // so every IQA role that opens those forms gets view-only access.
            // These are not IQA claims, so SyncIqaPermissionsAsync leaves them be.
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

            // Auditor works on checklists/NCARs/report drafts.
            await PermissionSeeder.SeedViewOnlyPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                programme,
                plan,
                schedule,
                checklist,
                report,
                ncar);

            await PermissionSeeder.SeedSpecificPermssionsToRole<PgsAuditorRole, IdentityRole>(_roleManager,
                checklist.Add,
                checklist.Edit,
                checklistFlow.CanSubmit,
                report.Add,
                report.Edit,
                reportFlow.CanSubmit,
                ncar.Add,
                ncar.Edit,
                ncarFlow.CanAcknowledge,
                ncarFlow.CanVerify);

            // The Auditor role only works on checklists, reports and NCARs.
            // Remove programme/plan/schedule write access that older seed runs
            // may have granted so the role matches its documented workflow.
            await RemovePermissionsFromRole(
                new PgsAuditorRole().Name,
                programme.Add,
                programme.Edit,
                plan.Add,
                plan.Edit,
                schedule.Add,
                schedule.Edit);

            // Administrators must see and do everything in IQA, so every user in
            // the Administrator role holds all of the role's permissions.
            await GrantAdministratorUserClaimsAsync();

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg");
                
        }

        private static readonly BasePermission[] IqaPermissionSet =
        {
            new AuditProgrammePermission(), new AuditProgrammeWorkflowPermission(),
            new AuditPlanPermission(), new AuditPlanWorkflowPermission(),
            new AuditSchedulePermission(), new AuditScheduleWorkflowPermission(),
            new AuditChecklistPermission(), new AuditChecklistWorkflowPermission(),
            new AuditReportPermission(), new AuditReportWorkflowPermission(),
            new NonconformingActionReportPermission(), new NonconformingActionReportWorkflowPermission()
        };

        /// <summary>
        /// Leaves a role with exactly the IQA permissions in <paramref name="allowed"/>:
        /// every other IQA claim (granted by an older seed run) is removed.
        /// Non-IQA claims are never touched.
        /// </summary>
        private async Task SyncIqaPermissionsAsync(string roleName, string[] allowed)
        {
            var iqaValues = IqaPermissionSet
                .SelectMany(permission => permission.GetType()
                    .GetProperties(BindingFlags.Public | BindingFlags.Instance)
                    .Where(p => p.PropertyType == typeof(string) &&
                                p.CanRead &&
                                !(p.GetMethod?.IsAbstract ?? false) &&
                                !(p.GetMethod?.IsVirtual ?? false))
                    .Select(p => p.GetValue(permission)?.ToString()))
                .Where(v => !string.IsNullOrWhiteSpace(v))
                .Select(v => v!)
                .Distinct(StringComparer.OrdinalIgnoreCase);

            var stale = iqaValues
                .Where(v => !allowed.Contains(v, StringComparer.OrdinalIgnoreCase))
                .ToArray();

            await RemovePermissionsFromRole(roleName, stale);

            // Users hold their effective permissions as per-user claims tied to
            // the role (assigned from the role's pool), so drop the stale ones
            // too; otherwise the users would keep the access the role lost.
            var role = await _roleManager.FindByNameAsync(roleName);
            if (role == null || stale.Length == 0)
                return;

            var staleUserClaims = _db.Set<UserClaim<string>>()
                .Where(c => c.RoleId == role.Id &&
                            c.ClaimType == PermissionClaimType.Claim &&
                            stale.Contains(c.ClaimValue!))
                .ToList();
            if (staleUserClaims.Count == 0)
                return;

            _db.Set<UserClaim<string>>().RemoveRange(staleUserClaims);
            await _db.SaveChangesAsync();
        }
        /// <summary>
        /// The app reads a user's permissions from per-user claims tied to the
        /// role. Permissions added to the Administrator role after an admin was
        /// set up (e.g. View Audit Programme) were never assigned to that admin,
        /// so the menu hid those modules. Assign every missing one.
        /// </summary>
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
