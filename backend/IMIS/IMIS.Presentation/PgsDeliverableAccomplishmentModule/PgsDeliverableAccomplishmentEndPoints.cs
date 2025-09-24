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

            app.MapPost("/pgsDeliverableAccomplishment", async ([FromBody] List<PgsDeliverableAccomplishmentDto> dtos, IPgsDeliverableAcomplishmentService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (dtos == null || !dtos.Any())
                    return Results.BadRequest("No accomplishments provided.");

                foreach (var dto in dtos)
                {
                    await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                }

                await cache.EvictByTagAsync(_pgsDeliverableAccomplishmentTag, cancellationToken);

                return Results.Ok(dtos);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .RequireAuthorization(e =>
             e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.Add));

            app.MapGet("/{deliverableId:long}",
            async (long deliverableId, IPgsDeliverableAcomplishmentService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByDeliverableIdAsync(deliverableId, cancellationToken);
                return Results.Ok(result);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsDeliverableAccomplishmentTag), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.View));

            app.MapPut("/id", async ([FromBody] List<PgsDeliverableAccomplishmentDto> dtos, IPgsDeliverableAcomplishmentService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (dtos == null || !dtos.Any())
                    return Results.BadRequest("No data provided for update.");

                foreach (var dto in dtos)
                {
                    await service.SaveOrUpdateAsync(dto, cancellationToken).ConfigureAwait(false);
                }
                await cache.EvictByTagAsync(_pgsDeliverableAccomplishmentTag, cancellationToken);

                return Results.Ok(dtos);
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.Edit));


            app.MapPost("/{id:long}/upload", async (long id, IFormFile file, IPgsDeliverableAcomplishmentService service, CancellationToken token) =>
            {
                if (file == null || string.IsNullOrWhiteSpace(_ftpBasePath))
                    return Results.BadRequest("File and directory are required.");

                var accomplishment = await service.GetByIdAsync(id, token);
                if (accomplishment == null)
                    return Results.NotFound("Accomplishment not found.");

                var tempPath = Path.GetTempFileName();
                await using (var stream = File.Create(tempPath))
                {
                    await file.CopyToAsync(stream, token).ConfigureAwait(false);
                }

                var uniqueFileName = $"{Guid.NewGuid()}_{file.FileName}";
                var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, token).ConfigureAwait(false);

                File.Delete(tempPath);

                if (!result.isSuccess)
                    return Results.BadRequest(result.responseMsg);
                if (result.hasBeenCancelled)
                    return Results.StatusCode(499);

                accomplishment.AttachmentPath = result.uploadedFilePath;
                await service.UpdateAttachmentPathAsync(accomplishment.Id, result.uploadedFilePath, token);

                return Results.Ok(new { result.uploadedFilePath, result.responseMsg });
            })
            .WithTags(_pgsDeliverableAccomplishmentTag)
            .DisableAntiforgery();

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

            app.MapDelete("/{id:long}/delete", async (long id, IPgsDeliverableAcomplishmentService service, CancellationToken token) =>
            {
                var accomplishment = await service.GetByIdAsync(id, token);
                if (accomplishment == null || string.IsNullOrWhiteSpace(accomplishment.AttachmentPath))
                    return Results.NotFound("File not found.");

                var fileName = Path.GetFileName(accomplishment.AttachmentPath);

                try
                {
                    await FTPHelper.DeleteAsync(_ftpBasePath, fileName, token).ConfigureAwait(false);

                    accomplishment.AttachmentPath = null;
                    await service.UpdateAsync(accomplishment, token);

                    return Results.Ok("File deleted successfully.");
                }
                catch (Exception ex)
                {
                    return Results.NotFound(ex.Message);
                }
            })
            .WithTags(_pgsDeliverableAccomplishmentTag);

            app.MapGet("/page", async (int page, int pageSize, IPgsDeliverableAcomplishmentService service, CancellationToken cancellationToken) =>
            {
                var paginatedAccomplishment = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedAccomplishment);
            })
           .WithTags(_pgsDeliverableAccomplishmentTag)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(2)).Tag(_pgsDeliverableAccomplishmentTag), true)
           .RequireAuthorization(e => e.RequireClaim(
            PermissionClaimType.Claim, _pgsDeliverableAccomplishmentPermission.View));
        }
    }
}



