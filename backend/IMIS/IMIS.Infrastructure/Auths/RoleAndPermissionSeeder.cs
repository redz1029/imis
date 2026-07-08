using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.AnnouncementModule;
using IMIS.Application.AuditorModule;
using IMIS.Application.AuditorOfficesModule;
using IMIS.Application.AuditorTeamsModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using IMIS.Application.KraRoadmapKpiAccomplishmentModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PerformanceValidationToolModule;
using IMIS.Application.PerformanceValidationToolPeriodModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.StrategyReviewModule;
using IMIS.Application.SWOTAnalysisModule;
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
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceGovernanceSystemPermission());         

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
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceGovernanceSystemPermission());

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
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceValidationToolPeriodPermission());   

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
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceValidationToolPeriodPermission());

            await PermissionSeeder.SeedPermissionForRole<ServiceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(),
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPeriodPermission(),   
                new PerformanceValidationToolPermission());

            await PermissionSeeder.SeedPermissionForRole<ResearchOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission());
                
            await PermissionSeeder.SeedPermissionForRole<TrainingOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(),
                new PerformanceValidationToolPeriodPermission());

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
                new PerformanceValidationToolPeriodPermission());

            await PermissionSeeder.SeedPermissionForRole<FacilitiesOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission());

            await PermissionSeeder.SeedPermissionForRole<FinanceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission());

            await PermissionSeeder.SeedPermissionForRole<InformationOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission());

            await PermissionSeeder.SeedPermissionForRole<HROfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(), 
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission());

            await PermissionSeeder.SeedPermissionForRole<SafetyOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission(),
                new KraRoadMapPeriodPermission(),
                new KeyResultAreaPermission(),
                new KraRoadMapAccomplishmentPermission(),
                new KraRoadMapKpiAccomplishmentPermission(), 
                new OperationReviewProtocolPermission(),
                new StrategyReviewPermission(), 
                new PerformanceValidationToolPermission(), 
                new PerformanceValidationToolPeriodPermission());

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
                 new PerformanceValidationToolPeriodPermission());

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
                new PerformanceValidationToolPeriodPermission());

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg");
                
        }
    }
}
