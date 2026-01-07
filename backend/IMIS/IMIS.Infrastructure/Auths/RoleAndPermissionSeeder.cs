using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.AnnouncementModule;
using IMIS.Application.BreakThroughScoringModule;
using IMIS.Application.KraRoadMapModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Application.PgsSummaryNarrativeModule;
using IMIS.Application.SWOTAnalysisModule;
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
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new PgsSummaryNarrativePermissions(),
                new SWOTAnalysisPermission());


            await PermissionSeeder.SeedPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),              
                new KeyResultAreaPermission(), 
                new PgsPeriodPermission(), 
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new BreakThroughScoringPermission());        

            await PermissionSeeder.SeedPermissionForRole<PgsManagerRole, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(),
                new PgsDeliverableAuditorPermission(),
                new PgsPeriodPermission(),                 
                new PgsSignatoryTemplatePermission(),
                new PgsSummaryNarrativePermissions(),
                new PerformanceGovernanceSystemPermission(),              
                new KeyResultAreaPermission(),                
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission());

            await PermissionSeeder.SeedPermissionForRole<PgsServiceHead, IdentityRole>(_roleManager,
                new PerformanceGovernanceSystemPermission(),
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new SWOTAnalysisPermission());

            await PermissionSeeder.SeedPermissionForRole<PgsHead, IdentityRole>(_roleManager, 
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new PerformanceGovernanceSystemPermission(),               
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission());

            await PermissionSeeder.SeedPermissionForRole<MCC, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),
                new PerformanceGovernanceSystemPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission(),
                new AnnouncementPermission(),
                new SWOTAnalysisPermission());

            await PermissionSeeder.SeedPermissionForRole<OSM, IdentityRole>(_roleManager,
                new PgsDeliverableAuditorPermission(),
                new PerformanceGovernanceSystemPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAccomplishmentPermission());

            await PermissionSeeder.SeedPermissionForRole<PgsAuditorHead, IdentityRole>(_roleManager,
                new PgsSummaryNarrativePermissions(),
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(),
                new PgsPeriodPermission(),
                new OfficePermission(),
                new PgsDeliverableAccomplishmentPermission());

            await PermissionSeeder.SeedPermissionForRole<ServiceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<ResearchOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<TrainingOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<LinkagesOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<FacilitiesOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<FinanceOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<InformationOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<HROfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            await PermissionSeeder.SeedPermissionForRole<SafetyOfficer, IdentityRole>(_roleManager,
                new KraRoadMapPermission());

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg");
                
        }
    }
}
