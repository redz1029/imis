using Carter;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
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
        private const string _useroffice = "Create User Office";
        public UserOfficeEndPoints() : base("/UserOffice") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] UserOfficeDto userOfficeDto, IUserOfficeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                
                var createdPgsReadiness = await service.SaveOrUpdateAsync(userOfficeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_useroffice, cancellationToken);               
                return Results.Ok("Record has been successfully saved.");
            })
            .WithTags(_useroffice);

            app.MapGet("/", async (IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(Kradto);
            })
            .WithTags(_useroffice)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_useroffice), true);

            app.MapGet("/{id}", async (int id, IUserOfficeService service, CancellationToken cancellationToken) =>
            {
                var Kradto = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return Kradto != null ? Results.Ok(Kradto) : Results.NotFound();
            })
           .WithTags(_useroffice)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_useroffice), true);

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
                await cache.EvictByTagAsync(_useroffice, cancellationToken);
                return Results.Ok(updatedUserOffice);
            })
          .WithTags(_useroffice);
        }
    }
}
