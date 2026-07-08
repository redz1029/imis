namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public class ReportPgsServiceOfficePeriodDto
    {
        public string ServiceName { get; set; } = string.Empty;
        public string OfficeName { get; set; } = string.Empty;
        public long? PeriodId { get; set; }
        public string PeriodName { get; set; } = string.Empty;
        public DateOnly? StartDate { get; set; }
        public DateOnly? EndDate { get; set; }
    }
}
