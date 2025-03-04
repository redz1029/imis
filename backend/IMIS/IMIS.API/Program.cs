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
using System.Text;

var builder = WebApplication.CreateBuilder(args);
Env.Load();

var sqlServerConnectionString = Environment.GetEnvironmentVariable("SQL_SERVER_CONN")
    ?? throw new InvalidOperationException("SQL_SERVER_CONN environment variable is not set or empty.");

TokenUtils.Issuer = Environment.GetEnvironmentVariable("JWT_ISSUER")
    ?? throw new InvalidOperationException("JWT_ISSUER environment variable is not set or empty.");

TokenUtils.Audience = Environment.GetEnvironmentVariable("JWT_AUDIENCE")
    ?? throw new InvalidOperationException("JWT_AUDIENCE environment variable is not set or empty.");

TokenUtils.SecretKey = Environment.GetEnvironmentVariable("JWT_SECRET_KEY")
    ?? throw new InvalidOperationException("JWT_SECRET_KEY environment variable is not set or empty.");

builder.Services.AddDbContext<ImisDbContext>(options => options.UseSqlServer(sqlServerConnectionString));

// Identity Configuration
builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<ImisDbContext>()
    .AddDefaultTokenProviders();

builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.AllowTrailingCommas = true;
    options.SerializerOptions.PropertyNameCaseInsensitive = true;
});

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = TokenUtils.Issuer,
            ValidAudience = TokenUtils.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(TokenUtils.SecretKey))
        };
    });

builder.Services.AddAuthorization();

// CORS Configuration
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins", builder =>
    {
        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

// Register Output Caching
builder.Services.AddOutputCache(options =>
{
    options.AddBasePolicy(c =>
        c.AddPolicy<CustomOutputCachePolicy>()
         .SetCacheKeyPrefix("IMIS-CACHE"),
    true);
});

// Register other services
builder.Services.AddCarter();
builder.Services.AddPersistence();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "API V1"));
}

// Middleware setup
app.UseCors("AllowAllOrigins");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.UseOutputCache(); // Enable output caching middleware

// Map routes
app.MapCustomIdentityApi<IdentityUser>();
app.MapCarter();

app.Run();
