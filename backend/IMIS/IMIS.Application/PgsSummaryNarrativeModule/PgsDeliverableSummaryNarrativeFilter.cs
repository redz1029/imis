namespace IMIS.Application.PgsSummaryNarrativeModule
{  
    public record PgsDeliverableSummaryNarrativeFilter
    {
        public int? PgsPeriodId { get; set; }
        public string? OfficeId { get; set; }
        public string? Kra { get; set; }
        public double? MinScore { get; set; }
        public double? MaxScore { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
     
        public PgsDeliverableSummaryNarrativeFilter(
            int? PgsPeriodId,
            string? OfficeId = null,
            string? Kra = null,
            double? MinScore = null,
            double? MaxScore = null,
            int Page = 1,
            int PageSize = 25)
        {
            this.PgsPeriodId = PgsPeriodId;
            this.OfficeId = OfficeId;
            this.Kra = Kra;
            this.MinScore = MinScore;
            this.MaxScore = MaxScore;
            this.Page = Page;
            this.PageSize = PageSize;
        }
    }
}
