using Base.Utilities;
using Carter;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace IMIS.Presentation.SampleFileTransfer
{
    public class FTPSampleEndpoint : CarterModule
    {
        private const string _SampleFTP = "Sample FTP";
        private readonly string _samplePath = $"{FTPCredentials.FTPRootFolderPath}/sample";
        public FTPSampleEndpoint() : base("/sample/ftp") { }

        public override void AddRoutes(IEndpointRouteBuilder app)
        {
            // Upload file
            app.MapPost("/upload", async (IFormFile file, CancellationToken token) =>
            {
                if (file == null || string.IsNullOrWhiteSpace(_samplePath))
                    return Results.BadRequest("File and directory are required.");

                var tempPath = Path.GetTempFileName();
                await using (var stream = File.Create(tempPath))
                {
                    await file.CopyToAsync(stream, token).ConfigureAwait(false);
                }

                var result = await FTPHelper.UploadAsync(tempPath, _samplePath, file.FileName, token).ConfigureAwait(false);

                File.Delete(tempPath);

                if (result.isSuccess)
                    return Results.Ok(new { result.uploadedFilePath, result.responseMsg });
                if (result.hasBeenCancelled)
                    return Results.StatusCode(499);
                return Results.BadRequest(result.responseMsg);
            })
            .WithTags(_SampleFTP)
            .DisableAntiforgery();

            // Download file
            app.MapGet("/download", async (HttpResponse response, string fileName, CancellationToken token) =>
            {
                if (string.IsNullOrWhiteSpace(_samplePath) || string.IsNullOrWhiteSpace(fileName))
                    return Results.BadRequest("Directory and fileName are required.");

                byte[] fileBytes;
                try
                {
                    fileBytes = await FTPHelper.DownloadAsync(_samplePath, fileName, token).ConfigureAwait(false);
                }
                catch (Exception ex)
                {
                    return Results.NotFound(ex.Message);
                }

                var contentType = FTPHelper.GetContentType(fileName);
                return Results.File(fileBytes, contentType, fileName);
            }).WithTags(_SampleFTP);

            // Delete file
            app.MapDelete("/delete", async (string fileName, CancellationToken token) =>
            {
                if (string.IsNullOrWhiteSpace(_samplePath) || string.IsNullOrWhiteSpace(fileName))
                    return Results.BadRequest("Directory and fileName are required.");

                try
                {
                    await FTPHelper.DeleteAsync(_samplePath, fileName, token).ConfigureAwait(false);
                    return Results.Ok("File deleted successfully.");
                }
                catch (Exception ex)
                {
                    return Results.NotFound(ex.Message);
                }
            }).WithTags(_SampleFTP);
        }
    }
}
