namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class AuditorPendingAuditDto
    {
        //public long AuditorId { get; set; }

        //public string AuditorName { get; set; } = string.Empty;

        //public long TeamId { get; set; }

        //public string TeamName { get; set; } = string.Empty;

        //public long OfficeId { get; set; }

        //public string OfficeName { get; set; } = string.Empty;

        //public int PendingAuditCount { get; set; }


        public long AuditorId { get; set; }

        public string AuditorName { get; set; } = string.Empty;

        public long TeamId { get; set; }

        public string TeamName { get; set; } = string.Empty;

        public long OfficeId { get; set; }

        public string OfficeName { get; set; } = string.Empty;

        // Total accomplishments
        public int TotalAuditCount { get; set; }

        // May AuditorRemarks
        public int CompletedAuditCount { get; set; }

        // Wala pang AuditorRemarks
        public int PendingAuditCount { get; set; }

        // Example: "3 out of 10"
        public string AuditProgress { get; set; } = string.Empty;
    }
}
