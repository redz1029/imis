namespace IMIS.Domain
{
    public class AuditorOffices
    {
        public required int AuditorId { get; set; }
        public required Auditor Auditor { get; set; }

        public required int OfficeId { get; set; }
        public required Office Office { get; set; }

        public bool IsOfficeHead { get; set; }
    }
}
