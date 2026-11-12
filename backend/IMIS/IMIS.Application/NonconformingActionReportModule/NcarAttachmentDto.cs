using System;
using IMIS.Domain;

namespace IMIS.Application.NonconformingActionReportModule
{
    /// <summary>
    /// A picture attached to an NCAR. The bytes travel as base64 so the client
    /// can show the thumbnail and print it on page 2 from a single request.
    /// </summary>
    public class NcarAttachmentDto
    {
        public long Id { get; set; }
        public long NonconformingActionReportId { get; set; }
        public string FileName { get; set; } = string.Empty;
        public string ContentType { get; set; } = string.Empty;
        public string? Caption { get; set; }
        public int OrderNumber { get; set; }
        public string ContentBase64 { get; set; } = string.Empty;

        public NcarAttachmentDto() { }

        public NcarAttachmentDto(NcarAttachment entity)
        {
            Id = entity.Id;
            NonconformingActionReportId = entity.NonconformingActionReportId;
            FileName = entity.FileName;
            ContentType = entity.ContentType;
            Caption = entity.Caption;
            OrderNumber = entity.OrderNumber;
            ContentBase64 = Convert.ToBase64String(entity.Content);
        }
    }

    public static class NcarAttachmentRules
    {
        public const int MaxBytes = 5 * 1024 * 1024;
        public const int MaxPerNcar = 10;

        /// <summary>
        /// The print preview embeds PNG and JPEG only, so the type is decided from
        /// the file's own signature rather than the client's claimed content type.
        /// </summary>
        public static string? DetectImageType(byte[] bytes)
        {
            if (bytes.Length >= 8 &&
                bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47)
                return "image/png";

            if (bytes.Length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
                return "image/jpeg";

            return null;
        }
    }
}
