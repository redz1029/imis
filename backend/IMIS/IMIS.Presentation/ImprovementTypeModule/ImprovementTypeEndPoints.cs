using Base.Auths.Permissions;
using Carter;
using IMIS.Application.ImprovementTypeModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.ImprovementTypeModule
{
    public class ImprovementTypeEndPoints : CarterModule
    {
        private const string _improvementType = "Improvement Type";

        public ImprovementTypeEndPoints() : base("/improvementtype")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] ImprovementTypeDTO improvementTypeDto, IImprovementTypeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(improvementTypeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_improvementType, cancellationToken);
                return Results.Ok(improvementTypeDto);
            })
            .WithTags(_improvementType);

            app.MapPut("/", async ([FromBody] ImprovementTypeDTO improvementTypeDto, IImprovementTypeService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                await service.SaveOrUpdateAsync(improvementTypeDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_improvementType, cancellationToken);
                return Results.Ok(improvementTypeDto);
            })
            .WithTags(_improvementType);

            app.MapGet("/", async (IImprovementTypeService service, CancellationToken cancellationToken) =>
            {
                var improvementTypeDto = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(improvementTypeDto);
            })
            .WithTags(_improvementType);

            app.MapGet("/page", async (int page, int pageSize, IImprovementTypeService service, CancellationToken cancellationToken) =>
            {
                var improvementTypeDtos = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(improvementTypeDtos);
            })
            .WithTags(_improvementType);
        }
    }
}
