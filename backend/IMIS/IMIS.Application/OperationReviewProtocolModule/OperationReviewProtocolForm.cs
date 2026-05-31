using Microsoft.AspNetCore.Http;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public class OperationReviewProtocolForm
    {
        public int? DepartmentId { get; set; }
        public int? DivisionId { get; set; }
        public required string UserId { get; set; }
        public string? Deputy { get; set; }
        public string? Documenter { get; set; }
        public long? PerformanceGovernanceSystemId { get; set; }
        public string? Venue { get; set; }
        public string? ScoreboardLocation { get; set; }
        public string? ScoreboardOIC { get; set; }
        public string? ActionPlan { get; set; }
        public string? Form1 { get; set; }
        public string? Form2 { get; set; }
        public string? Form3 { get; set; }
        public string? FrequencySchedule { get; set; }
        public string? FrequencyUpdate { get; set; }
        public string? Frequency { get; set; }
        public IFormFile? MinutesAttachmentPath { get; set; }
        public DateTime PostingDate { get; set; }
        public bool RemoveAttachment { get; set; }

    }
}
