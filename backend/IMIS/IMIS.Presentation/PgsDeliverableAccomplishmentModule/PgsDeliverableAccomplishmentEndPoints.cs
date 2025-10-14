using Base.Auths.Permissions;
using Base.Utilities;
using Carter;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentEndPoints : CarterModule
    {

        private const string _pgsDeliverableAccomplishmentTag = "PgsDeliverableAccomplishment";        
        private readonly string _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";
        public readonly PgsDeliverableAccomplishmentPermission _pgsDeliverableAccomplishmentPermission = new();
     
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
           
            app.MapPost("/pgsDeliverableAccomplishment", async ([FromForm] PgsDeliverableAccomplishmentForm form,
            IPgsDeliverableAcomplishmentService service,
            IOutputCacheStore cache,
            CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                string? uploadedFilePath = null;

                if (form.File != null)
                {
                    if (string.IsNullOrWhiteSpace(_ftpBasePath))
                        return Results.BadRequest("FTP base path is missing.");

                    var tempPath = Path.GetTempFileName();
                    await using (var stream = System.IO.File.Create(tempPath))
                        await form.File.CopyToAsync(stream, cancellationToken);

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.File.FileName}";
                    var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, cancellationToken);

                    System.IO.File.Delete(tempPath);

                    if (!result.isSuccess)
                        return Results.BadRequest(result.responseMsg);
                    if (result.hasBeenCancelled)
                        return Results.StatusCode(499);

                    uploadedFilePath = result.uploadedFilePath;
                }

                var dto = new PgsDeliverableAccomplishmentDto
                {
                    Id = 0,
                    PgsDeliverableId = form.PgsDeliverableId,
                    PostingDate = form.PostingDate,
                    UserId = form.UserId,
                    PercentAccomplished = form.PercentAccomplished,
                    Remarks = form.Remarks,
                    AttachmentPath = uploadedFilePath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_pgsDeliverableAccomplishmentTag, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.Add));

            app.MapGet("/{deliverableId:long}",
            async (long deliverableId, IPgsDeliverableAcomplishmentService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByDeliverableIdAsync(deliverableId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsDeliverableAccomplishmentTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.View));
            
            app.MapPut("/pgsDeliverableAccomplishment/{id:int}", async (int id, [FromForm] PgsDeliverableAccomplishmentForm form,
            IPgsDeliverableAcomplishmentService service,
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
                    if (string.IsNullOrWhiteSpace(_ftpBasePath))
                        return Results.BadRequest("FTP base path is missing.");

                    var tempPath = Path.GetTempFileName();
                    await using (var stream = System.IO.File.Create(tempPath))
                        await form.File.CopyToAsync(stream, cancellationToken);

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.File.FileName}";
                    var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, cancellationToken);

                    System.IO.File.Delete(tempPath);

                    if (!result.isSuccess)
                        return Results.BadRequest(result.responseMsg);
                    if (result.hasBeenCancelled)
                        return Results.StatusCode(499);

                    uploadedFilePath = result.uploadedFilePath;
                }

                var dto = new PgsDeliverableAccomplishmentDto
                {
                    Id = id,
                    PgsDeliverableId = form.PgsDeliverableId,
                    PostingDate = form.PostingDate,
                    UserId = form.UserId,
                    PercentAccomplished = form.PercentAccomplished,
                    Remarks = form.Remarks,
                    AttachmentPath = uploadedFilePath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_pgsDeliverableAccomplishmentTag, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.Edit));

            app.MapGet("/{id:long}/download", async (long id, IPgsDeliverableAcomplishmentService service, CancellationToken token) =>
            {
                var accomplishment = await service.GetByIdAsync(id, token);
                if (accomplishment == null || string.IsNullOrWhiteSpace(accomplishment.AttachmentPath))
                    return Results.NotFound("File not found.");

                var fileName = Path.GetFileName(accomplishment.AttachmentPath);

                byte[] fileBytes;
                try
                {
                    fileBytes = await FTPHelper.DownloadAsync(_ftpBasePath, fileName, token).ConfigureAwait(false);
                }
                catch (Exception ex)
                {
                    return Results.NotFound(ex.Message);
                }

                var contentType = FTPHelper.GetContentType(fileName);
                return Results.File(fileBytes, contentType, fileName);
            })
           .WithTags(_pgsDeliverableAccomplishmentTag);


            app.MapGet("/page", async (int page, int pageSize, IPgsDeliverableAcomplishmentService service, CancellationToken cancellationToken) =>
            {
                var paginatedAccomplishment = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedAccomplishment);
            })
           .WithTags(_pgsDeliverableAccomplishmentTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsDeliverableAccomplishmentTag), true)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.View));
        }
    }
}



