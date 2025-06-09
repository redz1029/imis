namespace IMIS.Application.PgsDeliverableModule
{
    public class PgsDeliverableMonitorFilter
    {
        public int? PgsPeriodId { get; set; }
        public int? OfficeId { get; set; }
        public bool? IsDirect { get; set; }
        public int? KraId { get; set; }
        public int? ScoreRangeFrom { get; set; }
        public int? ScoreRangeTo { get; set; }
        public int Page { get; set; } = 1;
        public int PageSize { get; set; } = 25;

        public PgsDeliverableMonitorFilter() { }
    }
}
