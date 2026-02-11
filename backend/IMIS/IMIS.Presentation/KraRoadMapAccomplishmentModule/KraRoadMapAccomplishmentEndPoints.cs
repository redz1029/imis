using Base.Auths.Permissions;
using Base.Utilities;
using Carter;
using IMIS.Application.KraRoadmapAccomplishmentModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.KraRoadMapAccomplishmentModule
{
    public class KraRoadMapAccomplishmentEndPoints : CarterModule
    {
        private const string _kraRoadMapAccomplishmentTag = "KraRoadMapAccomplishment"; 
        private string GetFtpBasePath() => $"{FTPCredentials.FTPRootFolderPath}/sample";

        public readonly KraRoadMapAccomplishmentPermission _kraRoadMapAccomplishmentPermission = new();

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/kraroadmapAccomplishment", async (
                [FromForm] KraRoadMapAccomplishmentForm form,
                IKraRoadmapAccomplishmentService service,
                IOutputCacheStore cache,
                CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                string? uploadedFilePath = null;

                if (form.File != null)
                {
                    var ftpBasePath = GetFtpBasePath();
                    if (string.IsNullOrWhiteSpace(ftpBasePath))
                        return Results.BadRequest("FTP base path is missing.");

                    var tempPath = Path.GetTempFileName();
                    await using (var stream = System.IO.File.Create(tempPath))
                        await form.File.CopyToAsync(stream, cancellationToken);

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.File.FileName}";
                    var result = await FTPHelper.UploadAsync(tempPath, ftpBasePath, uniqueFileName, cancellationToken);

                    System.IO.File.Delete(tempPath);

                    if (!result.isSuccess)
                        return Results.BadRequest(result.responseMsg);

                    uploadedFilePath = result.uploadedFilePath;
                }

                var dto = new KraRoadmapAccomplishmentDto
                {
                    Id = 0,
                    KraRoadMapDeliverableId = form.KraRoadMapDeliverableId,
                    PostingDate = form.PostingDate,
                    UserId = form.UserId,
                    PercentAccomplished = form.PercentAccomplished,
                    Remarks = form.Remarks,
                    AttachmentPath = uploadedFilePath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_kraRoadMapAccomplishmentTag, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_kraRoadMapAccomplishmentTag)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapAccomplishmentPermission.Add));

            app.MapGet("/kraroadmapAccomplishment/{kradeliverableId:long}",
            async (long kradeliverableId, IKraRoadmapAccomplishmentService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByDeliverableIdAsync(kradeliverableId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_kraRoadMapAccomplishmentTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_kraRoadMapAccomplishmentTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapAccomplishmentPermission.View));


            app.MapPut("/kraroadmapAccomplishment/{id:int}", async (int id, [FromForm] KraRoadMapAccomplishmentForm form,
            IKraRoadmapAccomplishmentService service,
            IOutputCacheStore cache,
            CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                var existing = await service.GetByIdAsync(id, cancellationToken);
                if (existing == null)
                    return Results.NotFound($"Accomplishment with Id {id} not found.");

                string? uploadedFilePath = existing.AttachmentPath;

                if (form.File != null)
                {
                    if (string.IsNullOrWhiteSpace(GetFtpBasePath()))
                        return Results.BadRequest("FTP base path is missing.");

                    var tempPath = Path.GetTempFileName();
                    await using (var stream = System.IO.File.Create(tempPath))
                        await form.File.CopyToAsync(stream, cancellationToken);

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.File.FileName}";
                    var result = await FTPHelper.UploadAsync(tempPath, GetFtpBasePath(), uniqueFileName, cancellationToken);

                    System.IO.File.Delete(tempPath);

                    if (!result.isSuccess)
                        return Results.BadRequest(result.responseMsg);
                    if (result.hasBeenCancelled)
                        return Results.StatusCode(499);

                    uploadedFilePath = result.uploadedFilePath;
                }
                
                var dto = new KraRoadmapAccomplishmentDto
                {
                    Id = id,
                    KraRoadMapDeliverableId = form.KraRoadMapDeliverableId,
                    PostingDate = form.PostingDate,
                    UserId = form.UserId,
                    PercentAccomplished = form.PercentAccomplished,
                    Remarks = form.Remarks,
                    AttachmentPath = uploadedFilePath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_kraRoadMapAccomplishmentTag, cancellationToken);

                return Results.Ok(dto);
            })
           .WithTags(_kraRoadMapAccomplishmentTag)
           .DisableAntiforgery()
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _kraRoadMapAccomplishmentPermission.Edit));

            app.MapGet("/kraroadmap-accomplishment/{id:long}/download", async (long id, IKraRoadmapAccomplishmentService service, CancellationToken token) =>
            {
                var accomplishment = await service.GetByIdAsync(id, token);
                if (accomplishment == null || string.IsNullOrWhiteSpace(accomplishment.AttachmentPath))
                    return Results.NotFound("File not found.");

                var fileName = Path.GetFileName(accomplishment.AttachmentPath);

                byte[] fileBytes;
                try
                {
                    fileBytes = await FTPHelper.DownloadAsync(GetFtpBasePath(), fileName, token);
                }
                catch (Exception ex)
                {
                    return Results.NotFound(ex.Message);
                }

                var contentType = FTPHelper.GetContentType(fileName);
                return Results.File(fileBytes, contentType, fileName);
            })
            .WithTags(_kraRoadMapAccomplishmentTag);

        }
    }
}
