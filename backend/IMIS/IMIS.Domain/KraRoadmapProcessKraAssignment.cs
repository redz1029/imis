using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadmapProcessKraAssignment : Entity<int>
    {
        public required int KraId { get; set; }
        public KeyResultArea? Kra { get; set; }        
        public required int ProcessId { get; set; }
        public KraRoadmapCoreSupportProcess? Process { get; set; }
    }
}
