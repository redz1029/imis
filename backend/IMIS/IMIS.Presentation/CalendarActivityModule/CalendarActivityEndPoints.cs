using Base.Utilities;
using Carter;
using IMIS.Application.CalendarActivityModule;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OutputCaching;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;

namespace IMIS.Presentation.CalendarActivityModule
{
    public class CalendarActivityEndPoints : CarterModule
    {
        private const string _calendarTag = "Calendar Activity";
        private readonly string _ftpBasePath = $"{FTPCredentials.FTPRootFolderPath}/sample";

        public CalendarActivityEndPoints() : base("/calendarActivity")
        {
        }
        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            app.MapPost("/", async ([FromForm] CalendarActivityForm form, ICalendarActivityService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                string? uploadedFilePath = null;

                if (form.Attachment != null)
                {
                    var tempFile = Path.GetTempFileName();

                    await using (var stream = File.Create(tempFile))
                    {
                        await form.Attachment.CopyToAsync(stream, cancellationToken);
                    }

                    var uniqueFile = $"{Guid.NewGuid()}_{form.Attachment.FileName}";

                    var uploadResult = await FTPHelper.UploadAsync(tempFile, _ftpBasePath, uniqueFile, cancellationToken);

                    File.Delete(tempFile);

                    if (!uploadResult.isSuccess)
                    {
                        return Results.BadRequest(uploadResult.responseMsg);
                    }

                    uploadedFilePath = uploadResult.uploadedFilePath;
                }

                var dto = new CalendarActivityDto
                {
                    Id = form.Id,
                    Title = form.Title,
                    Description = form.Description,
                    StartDate = form.StartDate,
                    EndDate = form.EndDate,
                    StartTime = form.StartTime,
                    EndTime = form.EndTime,
                    IsAllDay = form.IsAllDay,
                    Color = form.Color,
                    Category = form.Category,
                    Location = form.Location,
                    Status = form.Status,
                    UserId = form.UserId,
                    OfficeId = form.OfficeId,                 
                    ReminderMinutes = form.ReminderMinutes,
                    MeetingLink = form.MeetingLink,
                    AttachmentPath = uploadedFilePath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_calendarTag, cancellationToken);
                return Results.Ok(dto);

            })
             .DisableAntiforgery()
             .WithTags(_calendarTag);


            app.MapPut("/{id:long}", async (long id, [FromForm] CalendarActivityForm form, ICalendarActivityService service, IOutputCacheStore cache, CancellationToken cancellationToken) =>
            {
                var existing = await service.GetByIdAsync(id, cancellationToken);
                if (existing == null)
                    return Results.NotFound("Calendar Activity not found.");

                string? attachmentPath = existing.AttachmentPath;
                
                async Task SafeDeleteAttachmentAsync(string? path)
                {
                    if (string.IsNullOrWhiteSpace(path))
                        return;

                    var directory = Path.GetDirectoryName(path)?.Replace("\\", "/");
                    var fileName = Path.GetFileName(path);

                    if (string.IsNullOrWhiteSpace(directory) || string.IsNullOrWhiteSpace(fileName))
                        return;

                    try
                    {
                        await FTPHelper.DeleteAsync(directory, fileName, cancellationToken);
                    }
                    catch (FluentFTP.Exceptions.FtpCommandException ex) when (ex.CompletionCode == "550")
                    {
                       
                    }
                }

                if (form.RemoveAttachment)
                {
                    await SafeDeleteAttachmentAsync(existing.AttachmentPath);
                    attachmentPath = null;
                }

                if (form.Attachment != null)
                {
                    await SafeDeleteAttachmentAsync(existing.AttachmentPath);

                    var tempFile = Path.GetTempFileName();
                    try
                    {
                        await using (var stream = File.Create(tempFile))
                        {
                            await form.Attachment.CopyToAsync(stream, cancellationToken);
                        }

                        var uniqueFile = $"{Guid.NewGuid()}_{form.Attachment.FileName}";
                        var uploadResult = await FTPHelper.UploadAsync(tempFile, _ftpBasePath, uniqueFile, cancellationToken);

                        if (!uploadResult.isSuccess)
                            return Results.BadRequest(uploadResult.responseMsg);

                        attachmentPath = uploadResult.uploadedFilePath;
                    }
                    finally
                    {
                        if (File.Exists(tempFile))
                            File.Delete(tempFile);
                    }
                }

                var dto = new CalendarActivityDto
                {
                    Id = id,
                    Title = form.Title,
                    Description = form.Description,
                    StartDate = form.StartDate,
                    EndDate = form.EndDate,
                    StartTime = form.StartTime,
                    EndTime = form.EndTime,
                    IsAllDay = form.IsAllDay,
                    Color = form.Color,
                    Category = form.Category,
                    Location = form.Location,
                    Status = form.Status,
                    UserId = form.UserId,
                    OfficeId = form.OfficeId,
                    ReminderMinutes = form.ReminderMinutes,
                    MeetingLink = form.MeetingLink,
                    AttachmentPath = attachmentPath
                };

                await service.SaveOrUpdateAsync(dto, cancellationToken);
                await cache.EvictByTagAsync(_calendarTag, cancellationToken);

                return Results.Ok(dto);
            })
            .DisableAntiforgery()
            .WithTags(_calendarTag);

            app.MapGet("/", async (ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetAllAsync(cancellationToken);
                return Results.Ok(result);

            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);
          
            app.MapGet("/{id:long}", async (long id, ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByIdAsync(id, cancellationToken);

                return result == null ? Results.NotFound() : Results.Ok(result);

            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);
           
            app.MapGet("/month", async (int month, int year, ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByMonthAsync(month, year, cancellationToken);
                return Results.Ok(result);

            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);

            app.MapGet("/date", async (DateTime date, ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetByDateAsync(date, cancellationToken);
                return Results.Ok(result);

            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);
           
            app.MapGet("/search", async (string keyword, ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.SearchAsync(keyword, cancellationToken);
                return Results.Ok(result);

            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);
          
            app.MapGet("/filter", async ([AsParameters] CalendarActivityFilter filter, ICalendarActivityService service, CancellationToken cancellationToken) =>
            {
                var result = await service.GetFilteredAsync(filter, cancellationToken);

                if (result == null)
                    return Results.Ok(new { items = Array.Empty<CalendarActivityDto>(), totalCount = 0 });

                return Results.Ok(result);
            })
            .WithTags(_calendarTag)
            .CacheOutput(builder => builder.Expire(TimeSpan.FromMinutes(0)).Tag(_calendarTag), true);
        }
    }
}
