using Base.Primitives;


namespace IMIS.Domain
{
    public class AuditComFindings : Entity<int>
    {
        public required string CommendableFindings { get; set; }
        public required string Area { get; set; }
    }
}
