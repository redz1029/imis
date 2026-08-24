using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOTDeliverablesModule
{
    public class SWOTAnalysisOTDeliverablesDto : BaseDto<SWOTAnalysisOTDeliverables, long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? ExternalContextId { get; set; }
        public string? ExternalContext { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

        public SWOTAnalysisOTDeliverablesDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOTDeliverablesDto(SWOTAnalysisOTDeliverables entity)
        {
            this.Id = entity.Id;
            this.SWOTAnalysisId = entity.SWOTAnalysisId;
            this.ExternalContextId = entity.ExternalContextId;
            this.ExternalContext = entity.ExternalContext?.ExternalContext;
            this.Opportunities = entity.Opportunities;
            this.Threats = entity.Threats;
        }

        public override SWOTAnalysisOTDeliverables ToEntity()
        {
            return new SWOTAnalysisOTDeliverables()
            {
                Id = Id,
                SWOTAnalysisId = SWOTAnalysisId,
                ExternalContextId = ExternalContextId,
                Opportunities = Opportunities,
                Threats = Threats,
            };
        }
    }
}