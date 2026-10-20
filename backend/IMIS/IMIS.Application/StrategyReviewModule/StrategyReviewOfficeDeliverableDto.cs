using IMIS.Domain;

namespace IMIS.Application.StrategyReviewModule
{

    public class StrategyReviewOfficeDeliverableDto
    {
        public string RoadmapName { get; set; } = string.Empty;
        public List<StrategyReviewOfficeDeliverableItemDto> Deliverables { get; set; } = new();
    }

    public class StrategyReviewOfficeDeliverableItemDto
    {
        public string OfficeName { get; set; } = string.Empty;
        public List<StrategyReviewDeliverableItemDto> Deliverables { get; set; } = new();
    }

    public class StrategyReviewDeliverableItemDto
    {
        public long PgsDeliverableId { get; set; }
        public string DeliverableName { get; set; } = string.Empty;
        public StrategyReviewLatestAccomplishmentDto? Accomplishment { get; set; }
    }

    public class StrategyReviewLatestAccomplishmentDto
    {
        public DateTime PostingDate { get; set; }
        public string PostingMonth { get; set; } = string.Empty;  
        public double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AuditorRemarks { get; set; }
        public PgsStatus Status { get; set; }
    }
}
