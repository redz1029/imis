using Azure;
using Base.Auths.Permissions;
using Base.Utilities;
using Carter;
using IMIS.Application.OfficeModule;
using IMIS.Application.OperationReviewProtocolModule;
using IMIS.Application.PgsDeliverableAccomplishmentModule;
using IMIS.Application.PgsModule;
using IMIS.Infrastructure.Reports;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.OperationReviewProtocolModule
{
    public class OperationReviewProtocolEndPoints : CarterModule
    {
        private const string _operationReviewProtocol = "OperationReviewProtocol";
        public readonly OperationReviewProtocolPermission _operationReviewProtocolPermission = new();

        private readonly string _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/operationReviewProtocol",
                async ([FromForm] OperationReviewProtocolForm form, IOperationReviewProtocolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
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
                            await form.MinutesAttachmentPath
                                .CopyToAsync(stream, cancellationToken);
                        }

                        var uniqueFileName =
                            $"{Guid.NewGuid()}_{form.MinutesAttachmentPath.FileName}";

                        var result = await FTPHelper.UploadAsync(
                            tempPath,
                            _ftpBasePath,
                            uniqueFileName,
                            cancellationToken);

                        System.IO.File.Delete(tempPath);

                        if (!result.isSuccess)
                            return Results.BadRequest(result.responseMsg);

                        if (result.hasBeenCancelled)
                            return Results.StatusCode(499);

                        uploadedFilePath = result.uploadedFilePath;
                    }

                    var dto = new OperationReviewProtocolDto
                    {
                        Id = 0,
                        DepartmentId = form.DepartmentId,
                        DivisionId = form.DivisionId,
                        UserId = form.UserId,
                        Deputy = form.Deputy,
                        Documenter = form.Documenter,
                        PerformanceGovernanceSystemId = form.PerformanceGovernanceSystemId,
                        Venue = form.Venue,
                        ScoreboardLocation = form.ScoreboardLocation,
                        ScoreboardOIC = form.ScoreboardOIC,
                        ActionPlan = form.ActionPlan,
                        Form1 = form.Form1,
                        Form2 = form.Form2,
                        Form3 = form.Form3,
                        FrequencySchedule = form.FrequencySchedule,
                        FrequencyUpdate = form.FrequencyUpdate,
                        Frequency = form.Frequency,
                        MinutesAttachmentPath = uploadedFilePath,
                        PostingDate = form.PostingDate
                    };

                    await service.SaveOrUpdateAsync(dto, cancellationToken);

                    await cache.EvictByTagAsync(_operationReviewProtocol, cancellationToken);

                    return Results.Ok(dto);
                })
                .WithTags(_operationReviewProtocol)
                .DisableAntiforgery()
                .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.Add));


            app.MapGet("/{long}", async (long id, IOperationReviewProtocolService service, CancellationToken cancellationToken) =>
            {
                var operationReviewProtocol = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return operationReviewProtocol != null ? Results.Ok(operationReviewProtocol) : Results.NotFound();
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));

            app.MapGet("/pgsidlist", async (long? performanceGovernanceSystemId, IOperationReviewProtocolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAll(performanceGovernanceSystemId, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol))
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));

            app.MapGet("/pgsiddiverable/{id}", async (int id, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var performanceGovernanceSystem = await service.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
                return performanceGovernanceSystem != null ? Results.Ok(performanceGovernanceSystem) : Results.NotFound();
            })
            .WithTags(_operationReviewProtocol)          
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));

            app.MapGet("/pgs/{id:long}/accomplishments", async (long id, int month, int year,  IOperationReviewProtocolService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetDeliverableByIdAsync(id, month, year, cancellationToken);

                return result.Any()
                    ? Results.Ok(result)
                    : Results.NotFound();
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));

            app.MapPut("/pgs/accomplishments", async (
            List<ORPPgsDeliverableAccomplishmentDto> request,
            IPgsDeliverableAcomplishmentService service,
            CancellationToken cancellationToken) =>
            {
                var result = await service.UpdateAccomplishmentsAsync(request, cancellationToken);

                return result
                    ? Results.Ok("Updated successfully")
                    : Results.BadRequest("Update failed");
            })
            .WithTags(_operationReviewProtocol)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.Edit));

            app.MapPut("/operationReviewProtocol/{id:long}", async (
            long id,
            [FromForm] OperationReviewProtocolForm form,
            IOperationReviewProtocolService service,
            IOutputCacheStore cache,
            CancellationToken cancellationToken) =>
            {
                if (form == null)
                    return Results.BadRequest("Form data is required.");

                var existing = await service.GetByIdAsync(id, cancellationToken);

                if (existing == null)
                {
                    return Results.NotFound(
                        $"Operation Review Protocol with Id {id} not found.");
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
                        await form.MinutesAttachmentPath
                            .CopyToAsync(stream, cancellationToken);
                    }

                    var uniqueFileName =
                        $"{Guid.NewGuid()}_{form.MinutesAttachmentPath.FileName}";

                    var result = await FTPHelper.UploadAsync(
                        tempPath,
                        _ftpBasePath,
                        uniqueFileName,
                        cancellationToken);

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
                        var fullPath =
                            existing.MinutesAttachmentPath?.Replace("\\", "/");

                        var directory = Path.GetDirectoryName(fullPath ?? string.Empty)?.Replace("\\", "/");

                        var fileName = Path.GetFileName(fullPath);

                        if (!string.IsNullOrWhiteSpace(directory) &&
                            !string.IsNullOrWhiteSpace(fileName))
                        {
                            await FTPHelper.DeleteAsync(
                                directory,
                                fileName,
                                cancellationToken);
                        }
                    }

                    uploadedFilePath = null;
                }

                var dto = new OperationReviewProtocolDto
                {
                    Id = id,
                    DepartmentId = form.DepartmentId,
                    DivisionId = form.DivisionId,
                    UserId = form.UserId,
                    Deputy = form.Deputy,
                    Documenter = form.Documenter,
                    PerformanceGovernanceSystemId = form.PerformanceGovernanceSystemId,
                    Venue = form.Venue,
                    ScoreboardLocation = form.ScoreboardLocation,
                    ScoreboardOIC = form.ScoreboardOIC,
                    ActionPlan = form.ActionPlan,
                    Form1 = form.Form1,
                    Form2 = form.Form2,
                    Form3 = form.Form3,
                    FrequencySchedule = form.FrequencySchedule,
                    FrequencyUpdate = form.FrequencyUpdate,
                    Frequency = form.Frequency,
                    MinutesAttachmentPath = uploadedFilePath,
                    PostingDate = form.PostingDate
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);

                await cache.EvictByTagAsync(_operationReviewProtocol, cancellationToken);

                return Results.Ok(dto);
            })
            .WithTags(_operationReviewProtocol)
            .DisableAntiforgery()
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));


            app.MapGet("/{id:long}/download-preview", async (long id, IOperationReviewProtocolService service, HttpResponse response, CancellationToken token) =>
            {
                var accomplishment = await service.GetByIdAsync(id, token);

                if (accomplishment == null ||
                    string.IsNullOrWhiteSpace(accomplishment.MinutesAttachmentPath))
                {
                    return Results.NotFound("File not found.");
                }

                var fileName =
                    Path.GetFileName(accomplishment.MinutesAttachmentPath);

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

                response.Headers["Content-Disposition"] = $"inline; filename={fileName}";

                return Results.File(fileBytes, contentType);
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true);         

            app.MapGet("/pagelist", async (int page, int pageSize, IOperationReviewProtocolService service, CancellationToken cancellationToken) =>
            {
                var paginatedProtocol = await service.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
                return Results.Ok(paginatedProtocol);
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View));

            app.MapGet("/report/pdf/{id}", async (HttpResponse response, long id, long pgsId, int month, int year, IOperationReviewProtocolService service, CancellationToken cancellationToken) =>
            {
                var operationReviewProtocolReport = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);

                if (operationReviewProtocolReport == null)
                    return Results.NotFound();

                var file = await ReportUtil.GeneratePdfReport<ReportOperationReviewProtocolDto>("OperationReviewProtocalReport",
                    new List<ReportOperationReviewProtocolDto>
                    {
                        operationReviewProtocolReport
                    },
                    "OperationReviewProtocol", cancellationToken).ConfigureAwait(false);

                // FORCE INLINE PDF VIEW IN BROWSER
                var fileName = $"ReportPerfomanceGovernanceSystem_{DateTime.Now:yyyyMMddHHmmss}.pdf";
                response.Headers.ContentDisposition = $"inline; filename={fileName}";
                return Results.File(file, "application/pdf");

                //return Results.File(file, "application/pdf", $"OperationReviewProtocol_{DateTime.Now:yyyyMMddHHmmss}.pdf");

                //var result = await service.ReportGetByIdAsync(id, pgsId, month, year, cancellationToken).ConfigureAwait(false);
                //return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithTags(_operationReviewProtocol)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true);

            app.MapDelete("/{id:int}", async (int id, IOperationReviewProtocolService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var result = await service.SoftDeleteAsync(id, cancellationToken);

                await cache.EvictByTagAsync(_operationReviewProtocol, cancellationToken);

                return result ? Results.Ok(new { message = "Successfully deleted." })
                              : Results.NotFound(new { message = "Template not found." });
            })
           .WithTags(_operationReviewProtocol)
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.Delete));
            
            app.MapGet("/pgsAuditor/operationReview/{roleId}", async (string roleId, long? officeId, long? pgsPeriodId, int page, int pageSize, IPerfomanceGovernanceSystemService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAuditorPgsDeliverableAsync(roleId, officeId, pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);

                return Results.Ok(result);
            })
            .WithTags(_operationReviewProtocol)
            .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View))
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true);

            app.MapGet("office/{id}/parent", async (int id, IOfficeService service, CancellationToken cancellationToken) =>
            {
                var parentOfficeName = await service.GetParentOfficeNameAsync(id, cancellationToken).ConfigureAwait(false);

                return parentOfficeName != null
                    ? Results.Ok(parentOfficeName)
                    : Results.NotFound();
            })
           .RequireAuthorization(e => e.RequireClaim(PermissionClaimType.Claim, _operationReviewProtocolPermission.View))
           .WithTags(_operationReviewProtocol).CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_operationReviewProtocol), true);
        }
    }
}   