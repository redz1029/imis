namespace IMIS.Application.PgsDeliverableModule
{
    public record PgsDeliverableMonitorFilter
    {
        public string? RoleId { get; set; }
        public int? PgsPeriodId { get; set; }
        public int? OfficeId { get; set; }    
        public bool? IsDirect { get; set; }
        public int? KraId { get; set; }
        public int? ScoreRangeFrom { get; set; }
        public int? ScoreRangeTo { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }               

        public PgsDeliverableMonitorFilter(string? roleId, int? pgsPeriodId, int? officeId, bool? isDirect, int? kraId, 
            int? scoreRangeFrom, int? scoreRangeTo, int page = 1, int pageSize = 25) 
        {
            this.RoleId = roleId;
            this.PgsPeriodId = pgsPeriodId;
            this.OfficeId = officeId;          
            this.IsDirect = isDirect;
            this.KraId = kraId;
            this.ScoreRangeFrom = scoreRangeFrom;
            this.ScoreRangeTo = scoreRangeTo;
            this.Page = page;
            this.PageSize = pageSize;
        }
    }
}
