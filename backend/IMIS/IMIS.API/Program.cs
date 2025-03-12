using Carter;
using DotNetEnv;
using IMIS.Infrastructure.Auths;
using IMIS.Persistence;
using IMIS.Persistence.DependencyInjection;
using IMIS.Presentation.UserModule;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
 
var builder = WebApplication.CreateBuilder(args);
Env.Load();

var allowedOrigins = "_allowedOrigins";

builder.Services.AddCors(opts => opts.AddPolicy(allowedOrigins, policy =>
{
    policy.AllowAnyOrigin()
        .AllowAnyHeader()
        .AllowAnyMethod();
}));

builder.Services.AddCarter();

var sqlServerConnectionString = Environment.GetEnvironmentVariable("SQL_SERVER_CONN")
    ?? throw new InvalidOperationException("SQL_SERVER_CONN environment variable is not set or empty.");

TokenUtils.Issuer = Environment.GetEnvironmentVariable("JWT_ISSUER")
    ?? throw new InvalidOperationException("JWT_ISSUER environment variable is not set or empty.");

TokenUtils.Audience = Environment.GetEnvironmentVariable("JWT_AUDIENCE")
    ?? throw new InvalidOperationException("JWT_AUDIENCE environment variable is not set or empty.");

TokenUtils.SecretKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY")
    ?? throw new InvalidOperationException("JWT_SECRET_KEY environment variable is not set or empty.");

Console.WriteLine($"Issuer: {TokenUtils.Issuer}, Audience: {TokenUtils.Audience}, SecretKey Length: {TokenUtils.SecretKey.Length}");


builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddCookie(IdentityConstants.BearerScheme)
.AddJwtBearer(options => {
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero,
        ValidateIssuerSigningKey = true,
        ValidIssuer = TokenUtils.Issuer,
        ValidAudience = TokenUtils.Audience,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(TokenUtils.SecretKey!)),       
    };

    options.Events = new JwtBearerEvents
    {
        OnAuthenticationFailed = context =>
        {
            Console.WriteLine($"Authentication Failed: {context.Exception.Message}");

            if (context.Exception is SecurityTokenExpiredException)
            {
                Console.WriteLine("Token has expired.");
            }
            else if (context.Exception is SecurityTokenInvalidSignatureException)
            {
                Console.WriteLine("Invalid token signature.");
            }
            else if (context.Exception is SecurityTokenInvalidIssuerException)
            {
                Console.WriteLine("Invalid issuer.");
            }
            else if (context.Exception is SecurityTokenInvalidAudienceException)
            {
                Console.WriteLine("Invalid audience.");
            }
            else if (context.Exception is SecurityTokenNotYetValidException)
            {
                Console.WriteLine("Token is not yet valid.");
            }
            else
            {
                Console.WriteLine("Other authentication error: " + context.Exception);
            }

            return Task.CompletedTask;
        }
    };
});

builder.Services.AddAuthorizationBuilder()
    .AddPolicy(RoleTypes.Administrator, policy => policy.RequireRole(RoleTypes.Administrator))
    .AddPolicy(RoleTypes.LdnaManager, policy => policy.RequireRole(RoleTypes.LdnaManager))
    .AddPolicy(RoleTypes.LdnaUser, policy => policy.RequireRole(RoleTypes.LdnaUser));

// Register Output Caching
builder.Services.AddOutputCache(options =>
{
    options.AddBasePolicy(c =>
        c.AddPolicy<CustomOutputCachePolicy>()
         .SetCacheKeyPrefix("IMIS-CACHE"),
    true);
});

builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<ImisDbContext>()
    .AddDefaultTokenProviders()
    .AddApiEndpoints();

builder.Services.AddDbContext<ImisDbContext>(options => options.UseSqlServer(sqlServerConnectionString));

builder.Services.AddPersistence();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Identity API", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter a valid token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors(allowedOrigins);

app.MapCustomIdentityApi<IdentityUser>();
app.MapCarter();

if (app.Environment.IsProduction())
    app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseOutputCache();
app.Run();
