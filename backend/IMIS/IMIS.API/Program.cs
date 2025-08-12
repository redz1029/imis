using Base.Auths;
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
using Base.Auths.Permissions;
using Base.Auths.Roles;
using IMIS.Infrastructure.Auths.Roles;
using IMIS.Infrastructure;


var builder = WebApplication.CreateBuilder(args);
builder.SetupEnvironment();

var allowedOrigins = "_allowedOrigins";

builder.Services.AddCors(opts => opts.AddPolicy(allowedOrigins, policy =>
{
    policy.AllowAnyOrigin()
        .AllowAnyHeader()
        .AllowAnyMethod();
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
        ValidIssuer = TokenUtils.Issuer,
        ValidAudience = TokenUtils.Audience,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(TokenUtils.SecretKey!)),       
    };
});

builder.Services.AddAuthorizationBuilder()
    .AddPolicy(new AdministratorRole().Name, policy => policy.RequireRole(new AdministratorRole().Name))
    .AddPolicy(new PgsManagerRole().Name, policy => policy.RequireRole(new PgsManagerRole().Name))
    .AddPolicy(new StandardUserRole().Name, policy => policy.RequireRole(new StandardUserRole().Name));


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

builder.Services.AddDbContext<ImisDbContext>(options => options.UseSqlServer(sqlServerConnectionString));
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
CurrentUserHelper<User>.Configure(app.Services.GetRequiredService<IHttpContextAccessor>());

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
using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<IRoleAndPermissionSeeder>();
    await seeder.SeedAsync();
}
app.Run();
