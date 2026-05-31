using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Domain;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public class OperationReviewProtocolDto : BaseDto<OperationReviewProtocol, long>
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

        public string? MinutesAttachmentPath { get; set; }
        public DateTime PostingDate { get; set; }

        public OperationReviewProtocolDto()
        {
        }

        [SetsRequiredMembers]
        public OperationReviewProtocolDto(OperationReviewProtocol operationReviewProtocol)
        {
            Id = operationReviewProtocol.Id;
            DepartmentId = operationReviewProtocol.DepartmentId;
            if (operationReviewProtocol.Department != null)
                Department = new OfficeDto(operationReviewProtocol.Department);
            DivisionId = operationReviewProtocol.DivisionId;
            if (operationReviewProtocol.Division != null)
                Division = new OfficeDto(operationReviewProtocol.Division);
            UserId = operationReviewProtocol.UserId;
            User = operationReviewProtocol.User;
            Deputy = operationReviewProtocol.Deputy;
            Documenter = operationReviewProtocol.Documenter;
            PerformanceGovernanceSystemId = operationReviewProtocol.PerformanceGovernanceSystemId;
            Venue = operationReviewProtocol.Venue;
            ScoreboardLocation = operationReviewProtocol.ScoreboardLocation;
            ScoreboardOIC = operationReviewProtocol.ScoreboardOIC;
            ActionPlan = operationReviewProtocol.ActionPlan;
            Form1 = operationReviewProtocol.Form1;
            Form2 = operationReviewProtocol.Form2;
            Form3 = operationReviewProtocol.Form3;
            FrequencySchedule = operationReviewProtocol.FrequencySchedule;
            FrequencyUpdate = operationReviewProtocol.FrequencyUpdate;
            Frequency = operationReviewProtocol.Frequency;
            MinutesAttachmentPath = operationReviewProtocol.MinutesAttachmentPath;
            PostingDate = operationReviewProtocol.PostingDate;  
        }

        public override OperationReviewProtocol ToEntity()
        {
            return new OperationReviewProtocol
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
                PostingDate = PostingDate,
                
            };
        }
    }
}