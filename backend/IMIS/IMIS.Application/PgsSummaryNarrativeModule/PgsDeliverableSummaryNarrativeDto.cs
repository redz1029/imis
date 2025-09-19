namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public class PgsDeliverableSummaryNarrativeDto
    {
        public required long PgsDeliverableId { get; set; }
        public required string PgsPeriod { get; set; }
        public required string Office { get; set; }
        public required string KeyResultArea { get; set; }
        public string? KraDescription { get; set; }
        public required bool IsDirect { get; set; }
        public required string Deliverable { get; set; }
        public required double Score { get; set; }
        public required string Status { get; set; }
        public string? Remarks { get; set; }
        public DateTime ByWhen { get; set; }
        public PgsDeliverableSummaryNarrativeDto() { }
    }
}
