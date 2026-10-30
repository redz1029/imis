using Base.Auths;
using Base.Auths.Permissions;
using Base.Utilities;
using Carter;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PolicyAndProcedureModule;
using IMIS.Domain;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PolicyAndProcedureModule
{
    public class PolicyAndProcedureEndPoint : CarterModule
    {
        private const string _policyAndProcedureEndPoint = "Policy And Procedure";
        public readonly PolicyAndProcedurePermission _policyAndProcedurePermission = new();
        private readonly string _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";

        public PolicyAndProcedureEndPoint() : base("/PolicyAndProcedure")
        {
        }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromForm] PolicyAndProcedureForm form, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                var (path, error) = await HandleAttachmentAsync(form, null, cancellationToken);
                if (error != null) return error;

                var dto = MapToDto(form, 0, path);

                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_policyAndProcedureEndPoint)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Add));

            app.MapGet("/{id:long}", async (long id, IPolicyAndProcedureService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
            .WithTags(_policyAndProcedureEndPoint)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureEndPoint), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.View));

            app.MapPut("/{id:long}", async (long id, [FromForm] PolicyAndProcedureForm form, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                var existing = await service.GetByIdAsync(id, cancellationToken);
                if (existing == null)
                    return Results.NotFound($"Policy and Procedure with Id {id} not found.");

                var (path, error) = await HandleAttachmentAsync(form, existing.MinutesAttachmentPath, cancellationToken);
                if (error != null) return error;

                var dto = MapToDto(form, id, path);

                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_policyAndProcedureEndPoint)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Edit));

            app.MapPut("/submit", async ([FromBody] PolicyAndProcedureDto policyAndProcedureDto, string userId, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
             await RunWorkflowAsync(policyAndProcedureDto, userId, service, cache, submit: true, cancellationToken))
            .WithTags(_policyAndProcedureEndPoint)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Submit, _policyAndProcedurePermission.Confirm));

            app.MapPost("/draft", async ([FromBody] PolicyAndProcedureDto policyAndProcedureDto, string userId, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
             await RunWorkflowAsync(policyAndProcedureDto, userId, service, cache, submit: false, cancellationToken))
            .WithTags(_policyAndProcedureEndPoint)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Draft));

            app.MapDelete("/{id:int}", async (int id, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);
                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return result ? Results.Ok(new { message = " Deleted successfully." })
                              : Results.NotFound(new { message = "Template not found." });
            })
            .WithTags(_policyAndProcedureEndPoint)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Delete));

            app.MapGet("/page", async (int page, int pageSize, IPolicyAndProcedureService service, CancellationToken cancellationToken) =>
            {
                var paginatedPAP = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPAP);
            })
            .WithTags(_policyAndProcedureEndPoint)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureEndPoint), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.View));

            app.MapGet("/filter", async ([AsParameters] PolicyAndProcedureFilter filter, string roleId,
                IPolicyAndProcedureService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetFilteredAsync(filter, roleId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_policyAndProcedureEndPoint)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.View));         

            app.MapDelete("pgssignatory/{papid:long}", async (long papid, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteSignatoryAsync(papid, cancellationToken);

                if (!result)
                    return Results.NotFound(new
                    {
                        message = "No active signatories found."
                    });

                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return Results.Ok(new
                {
                    message = "PGS signatories deleted successfully."
                });
            })
           .WithTags(_policyAndProcedureEndPoint)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _policyAndProcedurePermission.Delete));
        }
       
        private async Task<IResult> RunWorkflowAsync(PolicyAndProcedureDto dto, string userId, IPolicyAndProcedureService service, IOutputCacheStore cache, bool submit, CancellationToken cancellationToken)
        {
            if (dto == null)
                return Results.BadRequest("Data is required.");

            if (string.IsNullOrWhiteSpace(userId))
                return Results.BadRequest("userId is required.");

            var currentUser = await CurrentUserHelper<User>.GetCurrentUserService()
                .GetCurrentUserAsync().ConfigureAwait(false);
            if (currentUser == null)
                return Results.Unauthorized();

            if (!string.Equals(currentUser.Id, userId, StringComparison.OrdinalIgnoreCase))
                return Results.Json(new { message = "Hindi tugma ang userId sa naka-login na user." },
                    statusCode: StatusCodes.Status403Forbidden);

            if (dto.Id > 0)
            {
                var existing = await service.GetByIdAsync(dto.Id, cancellationToken);
                if (existing == null)
                    return Results.NotFound($"Policy and Procedure with Id {dto.Id} not found.");

                dto.MinutesAttachmentPath ??= existing.MinutesAttachmentPath;
            }

            try
            {
                var saved = submit
                    ? await service.SubmitAsync(dto, userId, cancellationToken)
                    : await service.DraftAsync(dto, userId, cancellationToken);

                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);
                return Results.Created($"/PolicyAndProcedure/{saved.Id}", saved);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Results.Json(new { message = ex.Message }, statusCode: StatusCodes.Status403Forbidden);
            }
            catch (InvalidOperationException ex)
            {
                return Results.BadRequest(new { message = ex.Message });
            }
        }

        private async Task<(string? Path, IResult? Error)> HandleAttachmentAsync(PolicyAndProcedureForm form, string? currentPath, CancellationToken cancellationToken)
        {
            if (form.MinutesAttachmentPath != null && form.MinutesAttachmentPath.Length > 0)
            {
                if (string.IsNullOrWhiteSpace(_ftpBasePath))
                    return (null, Results.BadRequest("FTP base path is missing."));

                var tempPath = Path.GetTempFileName();

                try
                {
                    await using (var stream = System.IO.File.Create(tempPath))
                    {
                        await form.MinutesAttachmentPath.CopyToAsync(stream, cancellationToken);
                    }

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.MinutesAttachmentPath.FileName}";
                    var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, cancellationToken);

                    if (!result.isSuccess)
                        return (null, Results.BadRequest(result.responseMsg));

                    if (result.hasBeenCancelled)
                        return (null, Results.StatusCode(499));

                    return (result.uploadedFilePath, null);
                }
                finally
                {
                    System.IO.File.Delete(tempPath);
                }
            }

            if (form.RemoveAttachment)
            {
                if (!string.IsNullOrWhiteSpace(currentPath))
                {
                    var fullPath = currentPath.Replace("\\", "/");
                    var directory = Path.GetDirectoryName(fullPath)?.Replace("\\", "/");
                    var fileName = Path.GetFileName(fullPath);

                    if (!string.IsNullOrWhiteSpace(directory) && !string.IsNullOrWhiteSpace(fileName))
                        await FTPHelper.DeleteAsync(directory, fileName, cancellationToken);
                }

                return (null, null);
            }

            return (currentPath, null);
        }

        private static PolicyAndProcedureDto MapToDto(PolicyAndProcedureForm form, long id, string? attachmentPath) => new()
        {
            Id = id,
            Title = form.Title,
            ProcessOwner = form.ProcessOwner,
            RegulatoryStandard = form.RegulatoryStandard,
            EffectiveDate = form.EffectiveDate,
            SectionId = form.SectionId,
            DocumentCode = form.DocumentCode,
            Revision = form.Revision,
            Content = form.Content,
            IsMasterCopy = form.IsMasterCopy,
            IsControlledCopy = form.IsControlledCopy,
            MinutesAttachmentPath = attachmentPath
        };
    }
}