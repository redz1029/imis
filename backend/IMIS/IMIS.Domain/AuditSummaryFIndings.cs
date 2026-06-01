using Base.Primitives;



namespace IMIS.Domain
{
    public class AuditSummaryFIndings : Entity<int>
    {
        public required int No { get; set; }
        public IsoStandard? Criteria { get; set; }
        public required string Findings { get; set; }

        public AuditNcarStatus? NcarStatus { get; set; }    

    }
}
