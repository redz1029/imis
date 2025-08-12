using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.OfficeModule;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsKeyResultAreaModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PgsSignatoryTemplateModule;
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
                new PgsPeriodPermission());
            await PermissionSeeder.SeedPermissionForRole<PgsAuditorRole, IdentityRole>(_roleManager,
                new PgsDeliverableScoreHistoryPermission(),
                new PgsDeliverableAuditorPermission(),
                new KeyResultAreaPermission(), 
                new PgsPeriodPermission(), 
                new OfficePermission());
            await PermissionSeeder.SeedPermissionForRole<PgsManagerRole, IdentityRole>(_roleManager,
                new KeyResultAreaPermission(), 
                new PgsPeriodPermission(), 
                new PerformanceGovernanceSystemPermission(), 
                new PgsSignatoryTemplatePermission());

            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                 _roleManager, _userManager, "castillano.mrb", "rama.emg", "pimentel.wb");
        }
    }
}
