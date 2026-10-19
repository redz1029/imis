namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentFilterDto
    {
        public string? PeriodName { get; set; }
        public string? OfficeName { get; set; }

        public List<PgsDeliverableAccomplishmenItemDto> PgsDeliverableAccomplishmenItem { get; set; } = new();
    }

    public class PgsDeliverableAccomplishmenItemDto
    {
        public long PgsDeliverableId { get; set; }
        public string? DeliverableName { get; set; }

        public List<AccomplishmentItemDto> Accomplishments { get; set; } = new();
    }

    public class AccomplishmentItemDto
    {
        public long Id { get; set; }
        public string? Status { get; set; }
        public string? DeliverableName { get; set; }
        public double PercentAccomplished { get; set; }
        public string? PostingMonth { get; set; }
    }
}