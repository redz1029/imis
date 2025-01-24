using Carter;
using DotNetEnv;
using IMIS.Persistence.DependencyInjection;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

Env.Load();

// Retrieve the SQL Server connection string from environment variables
var sqlServerConnectionString = Environment.GetEnvironmentVariable("SQL_SERVER_CONN");
if (string.IsNullOrWhiteSpace(sqlServerConnectionString))
{
    throw new InvalidOperationException("SQL_SERVER_CONN environment variable is not set or empty.");
}
builder.Services.AddCarter();
builder.Services.AddPersistence(); // Insject Persistence Layer
// Add services to the container
builder.Services.AddDbContext<ImisDbContext>(options => options.UseSqlServer(sqlServerConnectionString));

builder.Services.AddIdentity<IdentityUser, IdentityRole>().AddEntityFrameworkStores<ImisDbContext>()
    .AddDefaultTokenProviders()
    .AddApiEndpoints();  // Maps Identity API endpoints

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Enable Swagger in Development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();

app.MapCarter();
app.MapIdentityApi<IdentityUser>(); // Maps Identity API endpoints

app.Run();
