using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Application.JobPostModule;
using IMIS.Application.PositionQualificationStandardModule;
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
            await PermissionSeeder.SeedPermissionForRole<StandardUserRole, IdentityRole>(_roleManager);
            await PermissionSeeder.SeedPermissionForRole<PgsManagerRole, IdentityRole>(_roleManager,
                new PositionQualificationStandardPermission(),
                new JobPostPermission());


            // This will seed all roles and permissions for the default users
            await PermissionSeeder.SeedAdminRolesAndPermissionsForDefaultUsers<IdentityRole, User>(
                _roleManager, _userManager, "wilbur1907@", "beerus", "wiz");
        }
    }
}
