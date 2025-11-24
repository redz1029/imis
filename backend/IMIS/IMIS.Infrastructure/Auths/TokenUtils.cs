using Base.Auths.Permissions;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace IMIS.Infrastructure.Auths
{
    public static class TokenUtils
    {
        public static string? ExpInMinutes { get; set; }
        public static string? ExpInDays { get; set; }
        public static string? SecretKey { get; set; }
        public static string? Issuer { get; set; }
        public static string? Audience { get; set; }

        public static async Task<string> GenerateAccessTokenAsync<TUser, TRole>(
            TUser user,
            IList<string> roles,
            UserManager<TUser> userManager,
            RoleManager<TRole> roleManager,
            List<string> effectivePermissions) 
            where TUser : IdentityUser
            where TRole : IdentityRole
        {
            var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.Sub, user.UserName!),
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new("UserId", user.Id)
            };

            // Add role names
            foreach (var roleName in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, roleName));
            }

            // Add effective permissions (overrides role claims)
            if (effectivePermissions != null && effectivePermissions.Any())
            {
                claims.AddRange(effectivePermissions.Select(p => new Claim(PermissionClaimType.Claim, p)));
            }

            var expiration = DateTime.UtcNow.AddMinutes(Convert.ToInt32(ExpInMinutes));
            return GenerateToken(expiration, claims.ToArray());
        }

        private static string GenerateToken(DateTime expiration, params Claim[] claims)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: Issuer,
                audience: Audience,
                claims: claims,
                expires: expiration,
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public static string GenerateRefreshToken()
        {
            var expiration = DateTime.UtcNow.AddDays(Convert.ToInt32(ExpInDays));
            return GenerateToken(expiration, new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
        }

        public static string HashToken(string token)
        {
            using var sha256 = SHA256.Create();
            var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(token));
            return Convert.ToBase64String(bytes);
        }
    }
}
