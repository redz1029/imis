namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public record PgsFilter
    {
        public int Page { get; set; }
        public int PageSize { get; set; }
        public int? OfficeId { get; set; }
        public int? PeriodId { get; set; }
        public DateOnly? FromDate { get; set; }
        public DateOnly? ToDate { get; set; }
        
    }
}
