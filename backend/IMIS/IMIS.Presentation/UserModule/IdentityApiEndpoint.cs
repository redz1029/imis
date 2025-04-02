using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Security.Claims;
using IMIS.Domain;
using IMIS.Infrastructure.Auths;
using IMIS.Persistence;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.UserModule
{
    public static class IdentityApiEndpoint
    {
        private static readonly EmailAddressAttribute EmailValidator = new();
        private const string IdentityGroup = "Create Users";
        private const string RoleGroup = "Roles";
        private const string UserRoleGroup = "User Roles";
        
        public static IEndpointConventionBuilder MapCustomIdentityApi<TUser>(this IEndpointRouteBuilder endpoints)
        where TUser : User, new()
        {
            // Authentication Endpoints
            var authGroup = endpoints.MapGroup("").WithTags(IdentityGroup);
            authGroup.MapPost("/register", (UserRegistrationDto registration, IServiceProvider sp) => RegisterUser(registration, sp));
            authGroup.MapPost("/login", LoginUser<TUser>);
            authGroup.MapPut("/changePassword", ChangePassword<TUser>);
            authGroup.MapPost("/refresh", RefreshToken<TUser>);
            authGroup.MapDelete("/revokeRefreshToken", RevokeRefreshToken<TUser>);

            // Role Management Endpoints
            var roleGroup = endpoints.MapGroup("").WithTags(RoleGroup);
            roleGroup.MapGet("/roles", GetRoles).RequireAuthorization();
            roleGroup.MapPost("/roles", CreateRole);
            roleGroup.MapPut("/roles/{roleId}", EditRole);
            roleGroup.MapDelete("/roles/{roleId}", DeleteRole);
         
            // User Role Management Endpoints
            var userRoleGroup = endpoints.MapGroup("").WithTags(UserRoleGroup);
            userRoleGroup.MapGet("/userRoles", GetUserRoles); 
            userRoleGroup.MapPost("/userRoles", AssignUserRole);
            userRoleGroup.MapPut("/UpdateUserRole", UpdateUserRole);
            userRoleGroup.MapDelete("/DeleteUserRole", DeleteUserRole);

            return authGroup;
        }
        private const string _userRegister = "User's Registration";
        private static async Task<IResult> RegisterUser(UserRegistrationDto registration, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var cache = sp.GetRequiredService<IOutputCacheStore>(); 

            if (!EmailValidator.IsValid(registration.Email))
                return Results.ValidationProblem(new Dictionary<string, string[]> { { "Email", new[] { "Invalid email format." } } });
            var user = new User
            {
                UserName = registration.Username,
                Email = registration.Email,
                FirstName = registration.FirstName,
                MiddleName = registration.MiddleName,
                LastName = registration.LastName,
                Prefix = registration.Prefix,
                Suffix = registration.Suffix,
                Position = registration.Position
            };
            var result = await userManager.CreateAsync(user, registration.Password);         
            await cache.EvictByTagAsync(_userRegister,default);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("User registered successfully.");
        }       
        private static async Task<IResult> LoginUser<TUser>([FromBody] UserLoginDto login, IServiceProvider sp) where TUser : User
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;
            var dbContext = sp.GetRequiredService<ImisDbContext>();

            var user = await userManager.FindByNameAsync(login.Username);
            if (user == null || !await userManager.CheckPasswordAsync(user, login.Password))
            {
                return Results.Json(new { message = "Invalid credentials." }, statusCode: StatusCodes.Status401Unauthorized);
            }

            var roles = await userManager.GetRolesAsync(user);
           
             var offices = dbContext.UserOffices
             .Where(uo => uo.UserId == user.Id)
             .Join(dbContext.Offices, uo => uo.OfficeId, o => o.Id, (uo, o) => new { o.Id, o.Name }
             )
             .Distinct()
             .ToList();

            // Generate tokens
            var accessToken = TokenUtils.GenerateAccessToken(user, roles);
            var refreshToken = TokenUtils.GenerateRefreshToken();
            return Results.Ok(new
            {
                user.Id,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Position,              
                roles,
                offices,
                accessToken,
                refreshToken,
            });
        }
        private static async Task<IResult> ChangePassword<TUser>([FromBody] ChangePasswordRequest request,[FromServices] UserManager<TUser> userManager,
        HttpContext httpContext) where TUser : User
        {          
            var username = request.Username;
            var user = await userManager.FindByNameAsync(username);
            if (user == null)
            {              
                return Results.NotFound("User not found.");
            }            
            var result = await userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
            if (!result.Succeeded)
            {               
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));
            }         
            return Results.Ok("Password changed successfully.");
        }
        // Refresh Token method
        private static async Task<IResult> RefreshToken<TUser>([FromBody] UserRefreshDto refresh,IServiceProvider sp)where TUser : User
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;

            var user = await userManager.FindByIdAsync(refresh.Id);
            if (user == null)
            {              
                return Results.NotFound("Token not found.");
            }
            var roles = await userManager.GetRolesAsync(user);
            var accessToken = TokenUtils.GenerateAccessToken(user, roles);
            var newRefreshToken = TokenUtils.GenerateRefreshToken();
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "access_token", accessToken);
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "refresh_token", newRefreshToken);            
            return Results.Ok(new { user.Id, accessToken, refreshToken = newRefreshToken });
        }
        // Revoke Refresh Token method
        private static async Task<IResult> RevokeRefreshToken<TUser>([FromBody] UserRefreshDto refresh,IServiceProvider sp)where TUser : User
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var user = await signInManager.UserManager.FindByIdAsync(refresh.Id);
            if (user == null)
            {              
                return Results.NotFound("Token not found.");
            }
            await signInManager.UserManager.RemoveAuthenticationTokenAsync(user, "IMIS_API", "refresh_token");          
            return Results.Ok("Refresh token revoked successfully.");
        }
        private static async Task<IResult> CreateRole([FromBody] string roleName, IServiceProvider sp)
        {
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            if (await roleManager.RoleExistsAsync(roleName))
                return Results.Conflict("Role already exists.");

            var role = new IdentityRole(roleName)
            {
                ConcurrencyStamp = Guid.NewGuid().ToString()
            };

            var result = await roleManager.CreateAsync(role);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("Role created successfully.");
        }     
        private static async Task<IResult> GetRoles(HttpContext httpContext, IServiceProvider sp)
        {
            var identity = (ClaimsIdentity)httpContext.User.Identity!;
            identity.AddClaim(new Claim(ClaimTypes.Role, "Administrator"));

            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var roles = await roleManager.Roles.ToListAsync();
            return Results.Ok(roles);
        }
        private static async Task<IResult> EditRole(RoleManager<IdentityRole> roleManager, string roleId, string newRoleName)
        {
            var role = await roleManager.FindByIdAsync(roleId);
            if (role == null)
            {
                return Results.NotFound($"Role with ID {roleId} not found.");
            }
            
            if (await roleManager.RoleExistsAsync(newRoleName))
            {
                return Results.BadRequest($"Role name '{newRoleName}' already exists.");
            }

            role.Name = newRoleName;
            var result = await roleManager.UpdateAsync(role);

            if (!result.Succeeded)
            {
                return Results.BadRequest(result.Errors);
            }
            return Results.Ok($"Role updated successfully to '{newRoleName}'.");
        }

        private static async Task<IResult> DeleteRole(string roleId, IServiceProvider sp)
        {
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var role = await roleManager.FindByIdAsync(roleId);
            if (role == null)
                return Results.NotFound("Role not found.");

            var result = await roleManager.DeleteAsync(role);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("Role deleted successfully.");
        }



        private static async Task<IResult> GetUserRoles(IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();

            var users = userManager.Users.ToList();
            var userRolesList = new List<object>();

            foreach (var user in users)
            {
                var roleNames = await userManager.GetRolesAsync(user);
                var rolesWithIds = new List<object>();

                foreach (var roleName in roleNames)
                {
                    var role = await roleManager.FindByNameAsync(roleName);
                    if (role != null)
                    {
                        rolesWithIds.Add(new
                        {
                            RoleId = role.Id, 
                            RoleName = role.Name
                        });
                    }
                }
                userRolesList.Add(new
                {
                    UserId = user.Id,
                    UserName = user.UserName,  
                    FirstName = user.FirstName, 
                    MiddleName = user.MiddleName,
                    LastName = user.LastName,
                    Roles = rolesWithIds

                });
            }
            return Results.Ok(userRolesList);
        }

     
        private static async Task<IResult> AssignUserRole([FromBody] IdentityUserRole<string> userRole, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();

            var user = await userManager.FindByIdAsync(userRole.UserId);
            if (user == null)
                return Results.NotFound("User not found.");

            var role = await roleManager.FindByIdAsync(userRole.RoleId);
            if (role == null)
                return Results.NotFound("Role not found.");

            var result = await userManager.AddToRoleAsync(user, role.Name);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("User assigned to role successfully.");
        }
        private static async Task<IResult> UpdateUserRole(string userId, string newRoleId, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();

            var user = await userManager.FindByIdAsync(userId);
            if (user == null)
                return Results.NotFound("User not found.");

            var currentRoles = await userManager.GetRolesAsync(user);
            if (currentRoles.Any())
            {
                var removeResult = await userManager.RemoveFromRolesAsync(user, currentRoles);
                if (!removeResult.Succeeded)
                    return Results.ValidationProblem(removeResult.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));
            }

            var newRole = await roleManager.FindByIdAsync(newRoleId);
            if (newRole == null)
                return Results.NotFound("New role not found.");

            var addResult = await userManager.AddToRoleAsync(user, newRole.Name);
            if (!addResult.Succeeded)
                return Results.ValidationProblem(addResult.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok($"User role updated to: {newRole.Name}");
        }
        private static async Task<IResult> DeleteUserRole(string userId, string roleId, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();

            var user = await userManager.FindByIdAsync(userId);
            if (user == null)
                return Results.NotFound("User not found.");

            var role = await roleManager.FindByIdAsync(roleId);
            if (role == null)
                return Results.NotFound("Role not found.");

            if (!await userManager.IsInRoleAsync(user, role.Name))
                return Results.BadRequest("User is not assigned to this role.");

            var result = await userManager.RemoveFromRoleAsync(user, role.Name);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("Role removed from user successfully.");
        }
    }
}