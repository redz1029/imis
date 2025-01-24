using IMIS.Presentation.UserModule;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using DotNetEnv;
using Microsoft.AspNetCore.Routing.Patterns;
using IMIS.Infrastructure.Auths;


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


// Ni modify bago lang
builder.Services.AddDbContext<ImisDbContext>(options =>
    options.UseSqlServer(sqlServerConnectionString));

builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<ImisDbContext>()
    .AddDefaultTokenProviders();



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
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();


if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "API V1"));
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapCustomIdentityApi<IdentityUser>();
app.Run();

