namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class AuditorPendingAuditDto
    {   
        public long AuditorId { get; set; }

        public string AuditorName { get; set; } = string.Empty;

        public long TeamId { get; set; }

        public string TeamName { get; set; } = string.Empty;

        public long OfficeId { get; set; }

        public string OfficeName { get; set; } = string.Empty;
   
        public int TotalAuditCount { get; set; }
       
        public int CompletedAuditCount { get; set; }
   
        public int PendingAuditCount { get; set; }
      
        public string AuditProgress { get; set; } = string.Empty;
    }
}
