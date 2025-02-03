using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using IMIS.Infrastructure.Auths;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Authorization;

namespace IMIS.Presentation.UserModule
{
    public static class IdentityApiEndpoint
    {
        private static readonly EmailAddressAttribute EmailValidator = new();
        private const string IdentityGroup = "Identity";

        public static IEndpointConventionBuilder MapCustomIdentityApi<TUser>(this IEndpointRouteBuilder endpoints)
        where TUser : IdentityUser, new()
        {
            var routeGroup = endpoints.MapGroup("").WithTags(IdentityGroup);

            // Register endpoints
            routeGroup.MapPost("/register", (UserRegistrationDto registration, IServiceProvider sp) => RegisterUser<TUser>(registration, sp));
            routeGroup.MapPost("/login", LoginUser<TUser>);
            routeGroup.MapPut("/changePassword", ChangePassword<TUser>);
            routeGroup.MapPost("/refresh", RefreshToken<TUser>);
            routeGroup.MapDelete("/revokeRefreshToken", RevokeRefreshToken<TUser>);

            return routeGroup;
        }

        // User Registration method
        private static async Task<IResult> RegisterUser<TUser>(UserRegistrationDto registration, IServiceProvider sp)
            where TUser : IdentityUser, new()
        {
            var userManager = sp.GetRequiredService<UserManager<TUser>>();

            if (!EmailValidator.IsValid(registration.Email))
                return Results.ValidationProblem(new Dictionary<string, string[]> { { "Email", new[] { "Invalid email format." } } });

            var user = new TUser
            {
                UserName = registration.Username,
                Email = registration.Email
            };

            var result = await userManager.CreateAsync(user, registration.Password);
            if (!result.Succeeded)
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));

            Console.WriteLine($"User registered successfully: {registration.Username}");
            return Results.Ok("User registered successfully.");
        }

        // User Login method - Returns JWT token
        private static async Task<IResult> LoginUser<TUser>(
            [FromBody] UserLoginDto login,
            IServiceProvider sp) where TUser : IdentityUser
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;

            var user = await userManager.FindByNameAsync(login.Username).ConfigureAwait(false);
            if (user == null || !await userManager.CheckPasswordAsync(user, login.Password))
            {
                Console.WriteLine($"Login failed for username: {login.Username}");
                return Results.Json(new { message = "Invalid username or password." }, statusCode: StatusCodes.Status401Unauthorized);
            }

            var roles = await userManager.GetRolesAsync(user).ConfigureAwait(false);

            var accessToken = TokenUtils.GenerateAccessToken(user, roles);
            var refreshToken = TokenUtils.GenerateRefreshToken();

            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "access_token", accessToken).ConfigureAwait(false);
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "refresh_token", refreshToken).ConfigureAwait(false);

            Console.WriteLine($"User logged in successfully: {login.Username}");
            return Results.Ok(new
            {
                user.Id,
                accessToken,
                refreshToken,
            });
        }

       
        private static async Task<IResult> ChangePassword<TUser>(
            [FromBody] ChangePasswordRequest request,
            [FromServices] UserManager<TUser> userManager,
            HttpContext httpContext) where TUser : IdentityUser
        {
           

            var username = request.Username;

            Console.WriteLine($"ChangePassword called for username: {username}");

            var user = await userManager.FindByNameAsync(username);  // Find user by username

            if (user == null)
            {
                Console.WriteLine("User not found.");
                return Results.NotFound("User not found.");
            }

            // Extract current password and new password
            var result = await userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);

            if (!result.Succeeded)
            {
                Console.WriteLine("Password change failed.");
                return Results.ValidationProblem(result.Errors.ToDictionary(e => e.Code, e => new[] { e.Description }));
            }

            Console.WriteLine("Password changed successfully.");
            return Results.Ok("Password changed successfully.");
        }


        // Refresh Token method
        private static async Task<IResult> RefreshToken<TUser>(
            [FromBody] UserRefreshDto refresh,
            IServiceProvider sp)
            where TUser : IdentityUser
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var userManager = signInManager.UserManager;

            var user = await userManager.FindByIdAsync(refresh.Id);
            if (user == null)
            {
                Console.WriteLine("User not found for token refresh.");
                return Results.NotFound("User not found.");
            }

            var roles = await userManager.GetRolesAsync(user);
            var accessToken = TokenUtils.GenerateAccessToken(user, roles);
            var newRefreshToken = TokenUtils.GenerateRefreshToken();

            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "access_token", accessToken);
            await userManager.SetAuthenticationTokenAsync(user, "IMIS_API", "refresh_token", newRefreshToken);

            Console.WriteLine("Token refreshed successfully.");
            return Results.Ok(new { user.Id, accessToken, refreshToken = newRefreshToken });
        }

        // Revoke Refresh Token method
        private static async Task<IResult> RevokeRefreshToken<TUser>(
            [FromBody] UserRefreshDto refresh,
            IServiceProvider sp)
            where TUser : IdentityUser
        {
            var signInManager = sp.GetRequiredService<SignInManager<TUser>>();
            var user = await signInManager.UserManager.FindByIdAsync(refresh.Id);

            if (user == null)
            {
                Console.WriteLine("User not found for revoking refresh token.");
                return Results.NotFound("User not found.");
            }

            await signInManager.UserManager.RemoveAuthenticationTokenAsync(user, "IMIS_API", "refresh_token");
            Console.WriteLine("Refresh token revoked successfully.");
            return Results.Ok("Refresh token revoked successfully.");
        }
    }
}