namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class ServiceGroupedAuditDto
    {
        public string ServiceName { get; set; } = string.Empty;
        public List<AuditorPendingAuditDto> Offices { get; set; } = new();
    }
}
