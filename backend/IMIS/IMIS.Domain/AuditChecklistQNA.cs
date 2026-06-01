using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditChecklistQNA : Entity<int>
    {
        public required string Question { get; set; }
        public required long? IsoStandardId { get; set; }

        public IsoStandard? IsoStandard { get; set; }
    }
}
