using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public class ReportOperationReviewProtocolDto : BaseDto<OperationReviewProtocol, long>
    {
        public int? DepartmentId { get; set; }
        public OfficeDto? Department { get; set; }
        public string? DepartmentName => Department?.Name;
        public int? DivisionId { get; set; }
        public OfficeDto? Division { get; set; }
        public string? DivisionName => Division?.Name;
        public required string UserId { get; set; }
        public User? User { get; set; }
        public string? FullName => User != null ? $"{User.FirstName} {User.MiddleName} {User.LastName}".Trim() : null;
        public string? Position => User?.Position;
        public long? PerformanceGovernanceSystemId { get; set; }   
        public List<ORPPgsDeliverableAccomplishmentDto>? PgsDeliverables { get; set; }
        public string? Deputy { get; set; }
        public string? Documenter { get; set; }
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
        public string? MinutesAttachmentPath { get; set; }
        public byte[]? MinutesImageBytes { get; set; }
        public DateTime PostingDate { get; set; }

        public ReportOperationReviewProtocolDto() { }

        [SetsRequiredMembers]
        public ReportOperationReviewProtocolDto(OperationReviewProtocol orp, List<PgsDeliverableAccomplishment> accomplishments)
        {
            Id = orp.Id;
            DepartmentId = orp.DepartmentId;
            if (orp.Department != null)
                Department = new OfficeDto(orp.Department);

            DivisionId = orp.DivisionId;
            if (orp.Division != null)
                Division = new OfficeDto(orp.Division);

            UserId = orp.UserId;
            User = orp.User;
            PerformanceGovernanceSystemId = orp.PerformanceGovernanceSystemId;
            PgsDeliverables = accomplishments.Select(x => new ORPPgsDeliverableAccomplishmentDto(x)).ToList();
            Deputy = orp.Deputy;
            Documenter = orp.Documenter;
            Venue = orp.Venue;
            ScoreboardLocation = orp.ScoreboardLocation;
            ScoreboardOIC = orp.ScoreboardOIC;
            ActionPlan = orp.ActionPlan;
            Form1 = orp.Form1;
            Form2 = orp.Form2;
            Form3 = orp.Form3;
            FrequencySchedule = orp.FrequencySchedule;
            FrequencyUpdate = orp.FrequencyUpdate;
            Frequency = orp.Frequency;
            MinutesAttachmentPath = orp.MinutesAttachmentPath;
            PostingDate = orp.PostingDate;
        }

        public override OperationReviewProtocol ToEntity() => new OperationReviewProtocol
        {
            Id = Id,
            DepartmentId = DepartmentId,
            DivisionId = DivisionId,
            UserId = UserId,
            Deputy = Deputy,
            Documenter = Documenter,
            PerformanceGovernanceSystemId = PerformanceGovernanceSystemId,
            Venue = Venue,
            ScoreboardLocation = ScoreboardLocation,
            ScoreboardOIC = ScoreboardOIC,
            ActionPlan = ActionPlan,
            Form1 = Form1,
            Form2 = Form2,
            Form3 = Form3,
            FrequencySchedule = FrequencySchedule,
            FrequencyUpdate = FrequencyUpdate,
            Frequency = Frequency,
            MinutesAttachmentPath = MinutesAttachmentPath,
            PostingDate = PostingDate
        };
    }
}