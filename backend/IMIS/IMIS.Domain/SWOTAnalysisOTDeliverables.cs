using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysisOTDeliverables :  Entity<long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? ExternalContextId { get; set; }  
        public SWOTAnalysisOpportunitiesThreatsSettings? ExternalContext { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

    }
}
