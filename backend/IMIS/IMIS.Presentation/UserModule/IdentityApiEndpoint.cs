using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Base.Auths.Permissions;
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
using Sprache;

namespace IMIS.Presentation.UserModule
{
    public static class IdentityApiEndpoint
    {
        private static readonly EmailAddressAttribute EmailValidator = new();
        private const string IdentityGroup = "Users";
        private const string RoleGroup = "Roles";
        private const string UserRoleGroup = "User Roles";
       
        public static IEndpointConventionBuilder MapCustomIdentityApi<TUser>(this IEndpointRouteBuilder endpoints)
        where TUser : User, new()
        {
            // User Endpoints
            var authGroup = endpoints.MapGroup("").WithTags(IdentityGroup);
            authGroup.MapPost("/register", (UserRegistrationDto registration, IServiceProvider sp) => RegisterUser(registration, sp));
            authGroup.MapGet("/getUser", (IServiceProvider sp) => GetRegisteredUsers(sp)).CacheOutput(options => options.Expire(TimeSpan.FromMinutes(2)).Tag("roles"));
            authGroup.MapPut("/updateUser", async (UserRegistrationDto dto, IServiceProvider sp) => await UpdateUser(dto, sp));
            authGroup.MapPost("/login", LoginUser<TUser>);
            authGroup.MapPut("/changePassword", ChangePassword<TUser>);
            authGroup.MapPost("/refresh", RefreshToken<TUser>);
            authGroup.MapDelete("/revokeRefreshToken", RevokeRefreshToken<TUser>);
            authGroup.MapGet("/users", (HttpContext httpContext, IServiceProvider sp) => GetUsers(httpContext, sp));
            authGroup.MapDelete("/deleteUser/{id}", async (string id, IServiceProvider sp) => await DeleteUser(id, sp));

            // Role Management Endpoints
            var roleGroup = endpoints.MapGroup("").WithTags(RoleGroup);
            roleGroup.MapGet("/roles", GetRoles).CacheOutput(options => options.Expire(TimeSpan.FromMinutes(2)).Tag(RoleGroup));
            roleGroup.MapPost("/roles", CreateRole);          
            roleGroup.MapPut("/roles/{roleId}", EditRole);
            roleGroup.MapDelete("/roles/{roleId}", DeleteRole);
            roleGroup.MapGet("/roles/permissions", async
            ([FromServices] IServiceProvider sp) =>
            {
                var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
                var roles = await roleManager.Roles.ToListAsync();
                var rolePermissions = new List<object>();
                foreach (var role in roles)
                {
                    var claims = await roleManager.GetClaimsAsync(role);
                    var permissions = claims.Where(c => c.Type == PermissionClaimType.Claim).Select(c => c.Value).ToList();
                    rolePermissions.Add(new
                    {
                        role.Id,
                        role.Name,
                        Permissions = permissions
                    });
                }
                return roles == null ? Results.NoContent() : Results.Ok(rolePermissions);
            }).WithTags(RoleGroup)
            .RequireAuthorization()
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(RoleGroup), true);
         
            roleGroup.MapGet("/users/{userId}/permissions", async (
            string userId,
            string roleId, 
            UserManager<User> userManager,
            ImisDbContext db
            ) =>
            {
                var user = await userManager.FindByIdAsync(userId);
                if (user == null) return Results.NotFound(new { message = "User not found." });

                var roleClaims = await db.Set<IdentityRoleClaim<string>>()
                    .Where(rc => rc.RoleId == roleId && rc.ClaimType == PermissionClaimType.Claim)
                    .Select(rc => rc.ClaimValue!)
                    .ToListAsync();

                var userClaims = await db.Set<IdentityUserClaim<string>>()
                    .Where(c => c.UserId == userId && c.ClaimType == PermissionClaimType.Claim)
                    .Select(c => c.ClaimValue!)
                    .ToListAsync();

                var finalPermissions = roleClaims
                    .Select(p => new
                    {
                        permission = System.Text.RegularExpressions.Regex
                            .Replace(p, "(\\B[A-Z])", " $1"),
                        isAssigned = userClaims.Contains(p)
                    })
                    .OrderBy(p => p.permission)
                    .ToList();

                return Results.Ok(new
                {
                    user.Id,
                    user.UserName,
                    permissions = finalPermissions
                });
            })
           .RequireAuthorization()
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(RoleGroup), true);

            roleGroup.MapPut("/users/{userId}/permissions", async (
            string userId,
            RolePermissionUpdateModel request,
            UserManager<User> userManager,
            ImisDbContext db
             ) =>
            {
                var user = await userManager.FindByIdAsync(userId);
                if (user == null)
                    return Results.NotFound(new { message = "User not found." });

                // Get current user claims
                var currentClaims = await db.Set<IdentityUserClaim<string>>()
                    .Where(c => c.UserId == userId && c.ClaimType == PermissionClaimType.Claim)
                    .ToListAsync();

                foreach (var permission in request.Permissions)
                {
                    var normalized = permission.Permission.Replace(" ", "");

                    var existingClaim = currentClaims.FirstOrDefault(c => c.ClaimValue!.Equals(normalized, StringComparison.OrdinalIgnoreCase));

                    if (permission.IsAssigned)
                    {
                        if (existingClaim == null)
                        {
                            var claim = new IdentityUserClaim<string>
                            {
                                UserId = userId,
                                ClaimType = PermissionClaimType.Claim,
                                ClaimValue = normalized
                            };
                            db.Set<IdentityUserClaim<string>>().Add(claim);
                        }
                    }
                    else
                    {
                        if (existingClaim != null)
                        {
                            db.Set<IdentityUserClaim<string>>().Remove(existingClaim);
                        }
                    }
                }

                await db.SaveChangesAsync();

                return Results.Ok(new
                {
                    message = "User permissions updated successfully. Please re-login for changes to take effect."
                });
            })
            .RequireAuthorization();
         
            // User Role Management Endpoints
            var userRoleGroup = endpoints.MapGroup("").WithTags(UserRoleGroup);
            userRoleGroup.MapGet("/userRoles", GetUserRoles).CacheOutput(options => options.Expire(TimeSpan.FromMinutes(2)).Tag(RoleGroup)); 
            userRoleGroup.MapPost("/userRoles", AssignUserRoles);           
            userRoleGroup.MapPut("/updateUserRole", UpdateUserRoles);
            userRoleGroup.MapDelete("/deleteUserRole", DeleteUserRole);

            return authGroup;
        }
        private const string _userRegister = "User's Registration";
        private static IResult GetUsers(HttpContext httpContext, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();

            var users = userManager.Users.ToList();
         
            var userList = users.Select(u => new
            {               
                u.Id,
                FullName = $"{u.Prefix} {u.FirstName} {u.MiddleName} {u.LastName} {u.Suffix}".Trim(),
                Position = u.Position,
                

            });

            return Results.Ok(userList);
        }
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

            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();
            await outputCacheStore.EvictByTagAsync("roles", default);

            return Results.Ok("User registered successfully.");
        }

        private static IResult GetRegisteredUsers(IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var users = userManager.Users.ToList();

            var result = users.Select(u => new
            {
                u.Id,
                u.UserName,
                u.Email,
                u.FirstName,
                u.MiddleName,
                u.LastName,
                u.Prefix,
                u.Suffix,
                u.Position
            });

            return Results.Ok(result);
        }
        private static async Task<IResult> UpdateUser(UserRegistrationDto registration, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var cache = sp.GetRequiredService<IOutputCacheStore>();

            if (string.IsNullOrWhiteSpace(registration.Id))
                return Results.BadRequest("User ID is required for update.");

            var user = await userManager.FindByIdAsync(registration.Id);
            if (user == null)
                return Results.NotFound("User not found.");

            if (!EmailValidator.IsValid(registration.Email))
            {
                return Results.ValidationProblem(new Dictionary<string, string[]>
                {
                    { "Email", new[] { "Invalid email format." } }
                });
            }
            // Update properties
            user.UserName = registration.Username;
            user.Email = registration.Email;
            user.FirstName = registration.FirstName;
            user.MiddleName = registration.MiddleName;
            user.LastName = registration.LastName;
            user.Prefix = registration.Prefix;
            user.Suffix = registration.Suffix;
            user.Position = registration.Position;

            var updateResult = await userManager.UpdateAsync(user);
            if (!updateResult.Succeeded)
            {
                return Results.ValidationProblem(updateResult.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));
            }
            
            if (!string.IsNullOrWhiteSpace(registration.Password))
            {
                var token = await userManager.GeneratePasswordResetTokenAsync(user);
                var pwResetResult = await userManager.ResetPasswordAsync(user, token, registration.Password);
                if (!pwResetResult.Succeeded)
                {
                    return Results.ValidationProblem(pwResetResult.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));
                }
            }
            await cache.EvictByTagAsync(_userRegister, default);
            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();
            await outputCacheStore.EvictByTagAsync("roles", default);

            return Results.Ok("User updated successfully.");
        }
        private static async Task<IResult> LoginUser<TUser>([FromBody] UserLoginDto login, IServiceProvider sp)
        where TUser : User
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var dbContext = sp.GetRequiredService<ImisDbContext>();

            var user = await userManager.FindByNameAsync(login.Username);
            if (user == null || !await userManager.CheckPasswordAsync(user, login.Password))
            {
                return Results.Json(new { message = "Invalid credentials." }, statusCode: StatusCodes.Status401Unauthorized);
            }

            var roles = await userManager.GetRolesAsync(user);

            var roleList = new List<object>();
            foreach (var roleName in roles)
            {
                var role = await roleManager.FindByNameAsync(roleName);
                if (role != null)
                {
                    roleList.Add(new
                    {
                        name = roleName,
                        id = role.Id
                    });
                }
            }

            var offices = dbContext.UserOffices
                .Where(uo => uo.UserId == user.Id)
                .Join(dbContext.Offices, uo => uo.OfficeId, o => o.Id, (uo, o) => new { o.Id, o.Name })
                .Distinct()
                .ToList();

            var roleIds = roleList.Select(r => (string)r.GetType().GetProperty("id")!.GetValue(r)!).ToList();

            var roleClaims = await dbContext.Set<IdentityRoleClaim<string>>()
                .Where(rc => roleIds.Contains(rc.RoleId) && rc.ClaimType == PermissionClaimType.Claim)
                .Select(rc => rc.ClaimValue!)
                .ToListAsync();

            var userClaims = await dbContext.Set<IdentityUserClaim<string>>()
                .Where(c => c.UserId == user.Id && c.ClaimType == PermissionClaimType.Claim)
                .Select(c => c.ClaimValue!)
                .ToListAsync();

            var effectivePermissions = userClaims.Any() ? userClaims : roleClaims;

            var accessToken = await TokenUtils.GenerateAccessTokenAsync(user, roles, userManager, roleManager, effectivePermissions);
            var refreshToken = TokenUtils.GenerateRefreshToken();

            var hashedAccessToken = TokenUtils.HashToken(accessToken);
            var hashedRefreshToken = TokenUtils.HashToken(refreshToken);

            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "AccessTokenHash", hashedAccessToken);
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "RefreshTokenHash", hashedRefreshToken);

            return Results.Ok(new
            {
                user.Id,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Position,
                roles = roleList,
                offices,
                accessToken,
                refreshToken
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
        private static async Task<IResult> RefreshToken<TUser>(
        [FromBody] UserRefreshDto refresh,
        IServiceProvider sp)
        where TUser : User
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var dbContext = sp.GetRequiredService<ImisDbContext>();

            var user = await userManager.FindByIdAsync(refresh.Id);
            if (user == null)
            {
                return Results.NotFound("User not found.");
            }

            var providedHashedToken = TokenUtils.HashToken(refresh.RefreshToken);
            var storedHashedToken = await userManager.GetAuthenticationTokenAsync(user, "IMIS_API", "RefreshTokenHash");
            if (string.IsNullOrEmpty(storedHashedToken) || storedHashedToken != providedHashedToken)
            {
                return Results.Unauthorized();
            }

            var roles = await userManager.GetRolesAsync(user);

            var roleClaims = await dbContext.Set<IdentityRoleClaim<string>>()
                .Where(rc => roles.Contains(rc.RoleId) && rc.ClaimType == PermissionClaimType.Claim)
                .Select(rc => rc.ClaimValue!)
                .ToListAsync();

            var userClaims = await dbContext.Set<IdentityUserClaim<string>>()
                .Where(c => c.UserId == user.Id && c.ClaimType == PermissionClaimType.Claim)
                .Select(c => c.ClaimValue!)
                .ToListAsync();

            var effectivePermissions = userClaims.Any() ? userClaims : roleClaims;

            var accessToken = await TokenUtils.GenerateAccessTokenAsync(
                user,
                roles,
                userManager,
                roleManager,
                effectivePermissions 
            );

            var newRefreshToken = TokenUtils.GenerateRefreshToken();

            var hashedAccessToken = TokenUtils.HashToken(accessToken);
            var hashedRefreshToken = TokenUtils.HashToken(newRefreshToken);

            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "AccessTokenHash", hashedAccessToken);
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "RefreshTokenHash", hashedRefreshToken);

            return Results.Ok(new
            {
                user.Id,
                accessToken,
                refreshToken = newRefreshToken
            });
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

            // Create the role
            var result = await roleManager.CreateAsync(role);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            // Invalidate cache after creation
            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();
            await outputCacheStore.EvictByTagAsync("roles", default);

            return Results.Ok(role);
        }
        private static async Task<IResult> DeleteUser(string id, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();

            var user = await userManager.FindByIdAsync(id);
            if (user == null)
            {
                return Results.NotFound(new
                {                 
                    message = "User not found."
                });
            }

            var result = await userManager.DeleteAsync(user);
            if (result.Succeeded)
            {
                return Results.Ok(new
                {                  
                    message = "User deleted successfully."
                });
            }

            return Results.BadRequest(new
            {
                success = false,
                message = "Failed to delete user.",
                errors = result.Errors.Select(e => e.Description)
            });
        }
        private static async Task<IResult> GetRoles(HttpContext httpContext, IServiceProvider sp)
        {
            var identity = (ClaimsIdentity)httpContext.User.Identity!;
            identity.AddClaim(new Claim(ClaimTypes.Role, "Administrator"));

            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var roles = roleManager.Roles.ToList();
            return Results.Ok(roles);
        }      
        private static async Task<IResult> EditRole(RoleManager<IdentityRole> roleManager, string roleId, [FromBody] string newRoleName,
        IServiceProvider sp)
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
            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();
            await outputCacheStore.EvictByTagAsync("roles", default);
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
     
        private static async Task<IResult> AssignUserRoles([FromBody] List<AssignUserRolesRequest> requests, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();

            if (requests == null || !requests.Any())
                return Results.BadRequest("No user-role data provided.");

            var response = new List<object>();

            foreach (var req in requests)
            {
                var user = await userManager.FindByIdAsync(req.UserId!);
                if (user == null)
                    return Results.NotFound($"User with ID {req.UserId} not found.");

                var assignedRoles = new List<object>();

                foreach (var roleDto in req.Roles!)
                {
                    var role = await roleManager.FindByIdAsync(roleDto.RoleId!);
                    if (role == null)
                        return Results.NotFound($"Role with ID {roleDto.RoleId} not found.");

                    var alreadyInRole = await userManager.IsInRoleAsync(user, role.Name!);
                    if (!alreadyInRole)
                    {
                        var result = await userManager.AddToRoleAsync(user, role.Name!);
                        if (!result.Succeeded)
                            return Results.ValidationProblem(result.Errors.ToDictionary(
                                e => e.Code,
                                e => new[] { e.Description }
                            ));
                    }

                    assignedRoles.Add(new { roleId = roleDto.RoleId });
                }

                response.Add(new
                {
                    userId = user.Id,
                    roles = assignedRoles
                });
            }

            await outputCacheStore.EvictByTagAsync("roles", default);

            return Results.Ok(response);
        }      

        private static async Task<IResult> UpdateUserRoles([FromBody] UpdateUserRolesRequest request, IServiceProvider sp)
        {
            var userManager = sp.GetRequiredService<UserManager<User>>();
            var roleManager = sp.GetRequiredService<RoleManager<IdentityRole>>();
            var outputCacheStore = sp.GetRequiredService<IOutputCacheStore>();

            var user = await userManager.FindByIdAsync(request.UserId!);
            if (user == null)
                return Results.NotFound("User not found.");
           
            var currentRoles = await userManager.GetRolesAsync(user);
         
            if (currentRoles.Any())
            {
                var removeResult = await userManager.RemoveFromRolesAsync(user, currentRoles);
                if (!removeResult.Succeeded)
                    return Results.ValidationProblem(removeResult.Errors.ToDictionary(
                        e => e.Code, e => new[] { e.Description }));
            }
         
            var newRoles = new List<string>();
            foreach (var roleDto in request.Roles!)
            {
                var role = await roleManager.FindByIdAsync(roleDto.RoleId!);
                if (role == null)
                    return Results.NotFound($"Role with ID {roleDto.RoleId} not found.");
                newRoles.Add(role.Name!);
            }
           
            if (newRoles.Any())
            {
                var addResult = await userManager.AddToRolesAsync(user, newRoles);
                if (!addResult.Succeeded)
                    return Results.ValidationProblem(addResult.Errors.ToDictionary(
                        e => e.Code, e => new[] { e.Description }));
            }

            await outputCacheStore.EvictByTagAsync("roles", default);

            return Results.Ok(new
            {
                userId = user.Id,
                roles = request.Roles
            });
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

            if (!await userManager.IsInRoleAsync(user, role.Name!))
                return Results.BadRequest("User is not assigned to this role.");

            var result = await userManager.RemoveFromRoleAsync(user, role.Name!);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            return Results.Ok("Role removed from user successfully.");
        }
    }
}