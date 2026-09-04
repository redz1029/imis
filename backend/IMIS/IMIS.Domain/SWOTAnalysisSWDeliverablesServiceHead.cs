using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysisSWDeliverablesServiceHead : Entity<long>
    {      
        public int? InternalContextId { get; set; }
        public SWOTAnalysisStrengthWeaknessSettings? InternalContext { get; set; }
        public string? Strength { get; set; }
        public string? Weaknesses { get; set; }
    }
}
