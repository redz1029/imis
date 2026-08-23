using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysisSWDeliverables : Entity<long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? InternalContextId { get; set; }         
        public SWOTAnalysisStrengthWeaknessSettings? InternalContext { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }
    }
}
