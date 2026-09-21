using Base.Primitives;


namespace IMIS.Domain
{
    public class AuditComFindings : Entity<int>
    {
        public required string CommendableFindings { get; set; }

        public AuditPlanProcess? Areas { get; set; }
        public required int Area { get; set; }
    }
}
