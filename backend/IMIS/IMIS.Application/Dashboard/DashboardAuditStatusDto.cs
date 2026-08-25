namespace IMIS.Application.Dashboard
{
    public class DashboardAuditStatusDto
    {       
        public int TotalDeliverables { get; set; }
        public int CountNotStarted { get; set; }
        public int CountInProgress { get; set; }
        public int CountCompleted { get; set; }
        public int CountAudited { get; set; }
        public decimal PercentNotStarted { get; set; }
        public decimal PercentInProgress { get; set; }
        public decimal PercentCompleted { get; set; }
    }
}
