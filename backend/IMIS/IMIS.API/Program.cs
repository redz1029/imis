using Base.Auths;
using Base.Auths.Permissions;
using Base.Auths.Roles;
using Base.Utilities;
using Carter;
using IMIS.Domain;
using IMIS.Infrastructure;
using IMIS.Infrastructure.Auths;
using IMIS.Infrastructure.Auths.Roles;
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
builder.SetupEnvironment();

var allowedOrigins = "_allowedOrigins";

builder.Services.AddCors(opts => opts.AddPolicy(allowedOrigins, policy =>
{
    if (builder.Environment.IsDevelopment())
    {
        // Allow all origins in development
        policy.AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
        return;
    }
    else
    {
        // In production, restrict to specific origins
        policy.WithOrigins(
                "http://192.168.0.89:8085",  // LAN Origin
                "https://demo.imis.crmc.ph", // Demo domain
                "https://cpems.crmc.ph"  // Production domain
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();
    }
}));

builder.Services.AddCarter();

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
        ValidIssuer = IMIS.Infrastructure.Auths.TokenUtils.Issuer,
        ValidAudience = IMIS.Infrastructure.Auths.TokenUtils.Audience,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(IMIS.Infrastructure.Auths.TokenUtils.SecretKey!)),
    };
});

builder.Services.AddAuthorizationBuilder()
    .AddPolicy(new AdministratorRole().Name, policy => policy.RequireRole(new AdministratorRole().Name))
    .AddPolicy(new PgsManagerRole().Name, policy => policy.RequireRole(new PgsManagerRole().Name))
    .AddPolicy(new StandardUserRole().Name, policy => policy.RequireRole(new StandardUserRole().Name));

builder.Services.AddAntiforgery();
builder.Services.AddScoped<IRoleAndPermissionSeeder, RoleAndPermissionSeeder>();
builder.Services.AddAuthorization(options =>
{
    options.AddPermissionPolicies();
});

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

builder.Services.AddDbContext<ImisDbContext>(options =>
    options.UseSqlServer(DatabaseCredentials.SqlServerConnectionString));
builder.Services.AddPersistence();

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped(typeof(CurrentUserService<>));

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

AppContext.SetSwitch("System.Drawing.EnableUnixSupport", true);

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors(allowedOrigins);

if (app.Environment.IsProduction())
    app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseAntiforgery();
app.MapCustomIdentityApi<User>();
app.MapCarter();
app.MapPermissionEndpoints();

app.UseOutputCache();
using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<IRoleAndPermissionSeeder>();
    await seeder.SeedAsync();
}

ServiceResolver.Init(app.Services);
app.Run();
