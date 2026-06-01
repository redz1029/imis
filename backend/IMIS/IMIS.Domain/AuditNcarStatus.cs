using Base.Primitives;


namespace IMIS.Domain
{
    public class AuditNcarStatus : Entity<int>
    {
        public required string ncarStatus { get; set; }
        
    }
}
