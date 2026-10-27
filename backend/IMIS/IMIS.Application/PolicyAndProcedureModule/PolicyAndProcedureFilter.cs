namespace IMIS.Application.PolicyAndProcedureModule
{
    public class PolicyAndProcedureFilter
    {
        public int Page { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public int? SectionId { get; set; }
        public DateTime? FromDate { get; set; }  
        public DateTime? ToDate { get; set; }
        public string? Search { get; set; }       
    }
}
