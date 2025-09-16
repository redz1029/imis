using Base.Auths;
using Base.Utilities;
using DotNetEnv;
using IMIS.Infrastructure.Auths;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;
using TokenUtils = IMIS.Infrastructure.Auths.TokenUtils;

namespace IMIS.Infrastructure
{
    public static class EnvironmentBuilder
    {
        public const string _sqlServerConn = "SQL_SERVER_CONN";
        public const string _jwtIssuer = "JWT_ISSUER";
        public const string _jwtAudience = "JWT_AUDIENCE";
        public const string _jwtSecret = "JWT_SECRET_KEY";
        public const string _jwtExpMinutes = "JWT_EXP_IN_MINUTES";
        public const string _jwtExpDays = "JWT_EXP_IN_DAYS";

        public const string _ftpServerUrl = "FTP_SERVER_URL";
        public const string _ftpRootFolderPath = "FTP_ROOT_FOLDER_PATH";
        public const string _ftpServerUsername = "FTP_SERVER_USERNAME";
        public const string _ftpServerPassword = "FTP_SERVER_PASSWORD";

        public static void SetupEnvironment(this WebApplicationBuilder builder)
        {
            

            if (builder.Environment.IsDevelopment())
            {
                Env.Load();

                DatabaseCredentials.SqlServerConnectionString = Environment.GetEnvironmentVariable(_sqlServerConn);

                TokenUtils.Issuer = Environment.GetEnvironmentVariable(_jwtIssuer);
                TokenUtils.Audience = Environment.GetEnvironmentVariable(_jwtAudience);
                TokenUtils.SecretKey = Environment.GetEnvironmentVariable(_jwtSecret);
                TokenUtils.ExpInMinutes = Environment.GetEnvironmentVariable(_jwtExpMinutes);
                TokenUtils.ExpInDays = Environment.GetEnvironmentVariable(_jwtExpDays);

                FTPCredentials.FTPServerURL = Environment.GetEnvironmentVariable(_ftpServerUrl)!;
                FTPCredentials.FTPRootFolderPath = Environment.GetEnvironmentVariable(_ftpRootFolderPath)!;
                FTPCredentials.FTPServerUsername = Environment.GetEnvironmentVariable(_ftpServerUsername)!;
                FTPCredentials.FTPServerPassword = Environment.GetEnvironmentVariable(_ftpServerPassword)!;
            }
            else
            {
                string tokenPath = "path-of-vault-token-in-server";
                string vaultUrl = "http://vault-url-here";
                VaultService vaultService = new(tokenPath, vaultUrl);

                string mounthPath = "imis-demo";
                var secretDbCreds = vaultService.GetSecret(mounthPath, "db-credentials");
                DatabaseCredentials.SqlServerConnectionString = vaultService.GetSecretValue(secretDbCreds, _sqlServerConn);

                var secretJwtCreds = vaultService.GetSecret(mounthPath, "jwt-config");
                TokenUtils.Issuer = vaultService.GetSecretValue(secretJwtCreds, _jwtIssuer);
                TokenUtils.Audience = vaultService.GetSecretValue(secretJwtCreds, _jwtAudience);
                TokenUtils.SecretKey = vaultService.GetSecretValue(secretJwtCreds, _jwtSecret);
                TokenUtils.ExpInMinutes = vaultService.GetSecretValue(secretJwtCreds, _jwtExpMinutes);
                TokenUtils.ExpInDays = vaultService.GetSecretValue(secretJwtCreds, _jwtExpDays);
            }
        }
    }
}
