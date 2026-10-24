using Base.Utilities;
using Carter;
using IMIS.Application.PolicyAndProcedureModule;
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

                    string? uploadedFilePath = null;

                    if (form.MinutesAttachmentPath != null)
                    {
                        if (string.IsNullOrWhiteSpace(_ftpBasePath))
                            return Results.BadRequest("FTP base path is missing.");

                        var tempPath = Path.GetTempFileName();

                        await using (var stream = System.IO.File.Create(tempPath))
                        {
                            await form.MinutesAttachmentPath.CopyToAsync(stream, cancellationToken);
                        }

                        var uniqueFileName = $"{Guid.NewGuid()}_{form.MinutesAttachmentPath.FileName}";

                        var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, cancellationToken);

                        System.IO.File.Delete(tempPath);

                        if (!result.isSuccess)
                            return Results.BadRequest(result.responseMsg);

                        if (result.hasBeenCancelled)
                            return Results.StatusCode(499);

                        uploadedFilePath = result.uploadedFilePath;
                    }

                    var dto = new PolicyAndProcedureDto
                    {
                        Id = 0,
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
                        MinutesAttachmentPath = uploadedFilePath,
                    };

                    await service.SaveOrUpdateAsync(dto, cancellationToken);

                    await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                    return Results.Ok(dto);
                })
                .WithTags(_policyAndProcedureEndPoint)
                .DisableAntiforgery();

            app.MapGet("/{id:long}", async (long id, IPolicyAndProcedureService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);
                return result is null ? Results.NotFound() : Results.Ok(result);
            })
           .WithTags(_policyAndProcedureEndPoint)
           .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureEndPoint), true);
          
            app.MapPut("/{id:long}", async (long id, [FromForm] PolicyAndProcedureForm form, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                var existing = await service.GetByIdAsync(id, cancellationToken);

                if (existing == null)
                {
                    return Results.NotFound($"Operation Review Protocol with Id {id} not found.");
                }

                string? uploadedFilePath = existing.MinutesAttachmentPath;

                if (form.MinutesAttachmentPath != null &&
                    form.MinutesAttachmentPath.Length > 0)
                {
                    if (string.IsNullOrWhiteSpace(_ftpBasePath))
                    {
                        return Results.BadRequest("FTP base path is missing.");
                    }

                    var tempPath = Path.GetTempFileName();

                    await using (var stream = System.IO.File.Create(tempPath))
                    {
                        await form.MinutesAttachmentPath.CopyToAsync(stream, cancellationToken);
                    }

                    var uniqueFileName = $"{Guid.NewGuid()}_{form.MinutesAttachmentPath.FileName}";

                    var result = await FTPHelper.UploadAsync(tempPath, _ftpBasePath, uniqueFileName, cancellationToken);

                    System.IO.File.Delete(tempPath);

                    if (!result.isSuccess)
                    {
                        return Results.BadRequest(result.responseMsg);
                    }

                    if (result.hasBeenCancelled)
                    {
                        return Results.StatusCode(499);
                    }

                    uploadedFilePath = result.uploadedFilePath;
                }
                else if (form.RemoveAttachment)
                {
                    if (!string.IsNullOrWhiteSpace(existing.MinutesAttachmentPath))
                    {
                        var fullPath = existing.MinutesAttachmentPath?.Replace("\\", "/");

                        var directory = Path.GetDirectoryName(fullPath ?? string.Empty)?.Replace("\\", "/");

                        var fileName = Path.GetFileName(fullPath);

                        if (!string.IsNullOrWhiteSpace(directory) &&
                            !string.IsNullOrWhiteSpace(fileName))
                        {
                            await FTPHelper.DeleteAsync(directory, fileName, cancellationToken);
                        }

                    }

                    uploadedFilePath = null;
                }

                var dto = new PolicyAndProcedureDto
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
                    MinutesAttachmentPath = uploadedFilePath,
                    RowVersion = existing.RowVersion
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return Results.Ok(dto);
            })
           .WithTags(_policyAndProcedureEndPoint)
           .DisableAntiforgery();

            app.MapDelete("/{id:int}", async (int id, IPolicyAndProcedureService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_policyAndProcedureEndPoint, cancellationToken);

                return result ? Results.Ok(new { message = " Deleted successfully." })
                              : Results.NotFound(new { message = "Template not found." });
            })
         .WithTags(_policyAndProcedureEndPoint);

            app.MapGet("/page", async (int page, int pageSize, IPolicyAndProcedureService service, CancellationToken cancellationToken) =>
            {
                var paginatedPAP = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedPAP);
            })
         .WithTags(_policyAndProcedureEndPoint)
         .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_policyAndProcedureEndPoint), true);
        }
    }
}
