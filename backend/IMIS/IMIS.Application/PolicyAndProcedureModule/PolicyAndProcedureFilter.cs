namespace IMIS.Application.PolicyAndProcedureModule
{
    public class PolicyAndProcedureFilter
    {
        public int page { get; set; } = 1;
        public int pageSize { get; set; } = 10;
        public int? sectionId { get; set; }
        public DateTime? fromDate { get; set; }  
        public DateTime? toDate { get; set; }
        public string? search { get; set; }       
    }
}
