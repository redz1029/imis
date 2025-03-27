namespace IMIS.Domain
{
    public class AuditorOffices
    {
        public int AuditorId { get; set; }
        public Auditor? Auditor { get; set; }
        public int OfficeId { get; set; }
        public Office? Office { get; set; }
        public bool IsOfficeHead { get; set; }
    }
}
