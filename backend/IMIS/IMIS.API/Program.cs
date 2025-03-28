using Carter;
using DotNetEnv;
using IMIS.Domain;
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

TokenUtils.ExpInMinutes = Environment.GetEnvironmentVariable("JWT_EXP_IN_MINUTES")
    ?? throw new InvalidOperationException("JWT_EXP_IN_MINUTES environment variable is not set or empty.");

TokenUtils.ExpInDays = Environment.GetEnvironmentVariable("JWT_EXP_IN_DAYS")
    ?? throw new InvalidOperationException("JWT_EXP_IN_DAYS environment variable is not set or empty.");

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
});

builder.Services.AddAuthorizationBuilder()
    .AddPolicy(RoleTypes.Administrator, policy => policy.RequireRole(RoleTypes.Administrator))
    .AddPolicy(RoleTypes.PgsManager, policy => policy.RequireRole(RoleTypes.PgsManager))
    .AddPolicy(RoleTypes.PgsUser, policy => policy.RequireRole(RoleTypes.PgsUser));

// Register Output Caching
builder.Services.AddOutputCache(options =>
{
    options.AddBasePolicy(c =>
        c.AddPolicy<CustomOutputCachePolicy>()
         .SetCacheKeyPrefix("IMIS-CACHE"),
    true);
});
builder.Services.AddIdentityCore<User>()
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



if (app.Environment.IsProduction())
    app.UseHttpsRedirection();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapCustomIdentityApi<User>();
app.MapCarter();

app.UseOutputCache();
app.Run();
