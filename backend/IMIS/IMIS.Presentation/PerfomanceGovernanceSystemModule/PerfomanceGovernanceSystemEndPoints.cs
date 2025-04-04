﻿using Carter;
using IMIS.Application.PgsModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsModuleAPI
{
    public class PerfomanceGovernanceSystemEndPoints : CarterModule
    {
        private const string _pgsTag = "Create Performance Governance System";

        public PerfomanceGovernanceSystemEndPoints() : base("/PerformanceGovernanceSystem")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromBody] PerfomanceGovernanceSystemDto performanceGovernanceSystemDto, IPerfomanceGovernanceSystemService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {                
                var createdPerformanceGovernanceSystem = await service.SaveOrUpdateAsync(performanceGovernanceSystemDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Created($"/PerformanceGovernanceSystem/{createdPerformanceGovernanceSystem.Id}", createdPerformanceGovernanceSystem);

            })
            .WithTags(_pgsTag);

            app.MapGet("/", async (IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetAllAsync(cancellationToken).ConfigureAwait(false);
                return Results.Ok(performanceGovernanceSystem);
            })
           .WithTags(_pgsTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapGet("/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_pgsTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

            app.MapPut("/{id}", async (int id, [FromBody] PerfomanceGovernanceSystemDto performanceGovernanceSystemDto, IPerfomanceGovernanceSystemService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {              
                var existingPerformanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                if (existingPerformanceGovernanceSystem == null)
                {
                    return Results.NotFound($"Performance Governance System with ID {id} not found.");
                }

                var updatedexistingPgsAuditDetails = await service.SaveOrUpdateAsync(performanceGovernanceSystemDto, cancellationToken).ConfigureAwait(false);
                await cache.EvictByTagAsync(_pgsTag, cancellationToken);
                return Results.Ok(updatedexistingPgsAuditDetails);
            })
           .WithTags(_pgsTag);

            app.MapGet("/page", async (int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var paginatedPerformanceGovernanceSystem = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return paginatedPerformanceGovernanceSystem;
            })
            .WithTags(_pgsTag)
            .RequireAuthorization(a => a.RequireRole(RoleTypes.PgsManager))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsTag), true);

        }
    }
}
