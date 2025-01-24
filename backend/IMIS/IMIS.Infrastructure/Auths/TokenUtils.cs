using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;

namespace IMIS.Infrastructure.Auths
{
    public static class TokenUtils
    {
        // Static properties for configuration
        public static string? ExpInMinutes { get; set; }
        public static string? ExpInDays { get; set; }
        public static string? SecretKey { get; set; }
        public static string? Issuer { get; set; }
        public static string? Audience { get; set; }

    
        public static string GenerateAccessToken(IdentityUser user, IList<string> roles)
        {
            if (string.IsNullOrWhiteSpace(SecretKey) || string.IsNullOrWhiteSpace(Issuer) || string.IsNullOrWhiteSpace(Audience))
                throw new InvalidOperationException("Token configuration values (SecretKey, Issuer, Audience) must not be null or empty.");

            var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.Sub, user.UserName!),
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            // Add roles to claims
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            return GenerateToken(DateTime.UtcNow.AddMinutes(GetExpirationInMinutes()), claims);
        }

        public static string GenerateRefreshToken()
        {
            if (string.IsNullOrWhiteSpace(SecretKey) || string.IsNullOrWhiteSpace(Issuer) || string.IsNullOrWhiteSpace(Audience))
                throw new InvalidOperationException("Token configuration values (SecretKey, Issuer, Audience) must not be null or empty.");

            return GenerateToken(DateTime.UtcNow.AddDays(GetExpirationInDays()), new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            });
        }

          
        private static string GenerateToken(DateTime expiration, IEnumerable<Claim> claims)
        {
            if (string.IsNullOrWhiteSpace(SecretKey))
                throw new InvalidOperationException("SecretKey cannot be null or empty.");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: Issuer,
                audience: Audience,
                claims: claims,
                expires: expiration,
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

      
        private static int GetExpirationInMinutes()
        {
            return int.TryParse(ExpInMinutes, out var minutes) ? minutes : 30;
        }

        
        private static int GetExpirationInDays()
        {
            return int.TryParse(ExpInDays, out var days) ? days : 7;
        }
    }
}

