using Carter;
using IMIS.Application.UserOfficeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.UserOfficeModule
{
    public class UserOfficeEndPoints : CarterModule
    {
        private const string _userOffice = "User Office";
        public UserOfficeEndPoints() : base("/userOffice") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] UserOfficeDto userOfficeDto, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                
                var createdUserOffice = await service.SaveOrUpdateAsync(userOfficeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_userOffice, cancellationToken);               
                return Results.Ok("Record has been successfully saved.");
            })
            .WithTags(_userOffice);

            app.MapGet("/", async (IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var userOffice = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(userOffice);
            })
            .WithTags(_userOffice)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true);

            app.MapGet("/{id}", async (int id, IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var userOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return userOffice != null ? Results.Ok(userOffice) : Results.NotFound();
            })
           .WithTags(_userOffice)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true);

            app.MapPut("/{id}", async (int id, [FromBody] UserOfficeDto useroffice, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (useroffice == null)
                {
                    return Results.BadRequest("User Office data is required.");
                }
                var existingUserOffice = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingUserOffice == null)
                {
                    return Results.NotFound($"User Office with ID {id} not found.");
                }

                var updatedUserOffice = await service.SaveOrUpdateAsync(useroffice, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_userOffice, cancellationToken);
                return Results.Ok(updatedUserOffice);
            })
           .WithTags(_userOffice);

            app.MapGet("/page", async (int page, int pageSize, IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var paginatedUserOffice = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedUserOffice;

            })
           .WithTags(_userOffice)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_userOffice), true);
        }
    }
}
