using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
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

        public static string GenerateAccessToken(IdentityUser user, IList<string> roles)
        {
            var claims = new List<Claim>
            {
                new (JwtRegisteredClaimNames.Sub, user.UserName!),
                new (JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            foreach (var role in roles)
            {
                claims.Add(new(ClaimTypes.Role, role));
            }

            var expiration = DateTime.Now.AddMinutes(Convert.ToInt32(ExpInMinutes));
            return GenerateToken(expiration, [.. claims]);
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
            var expiration = DateTime.Now.AddDays(Convert.ToInt32(ExpInDays));
            return GenerateToken(expiration, new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
        }
    }
}