using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOTDeliverablesServiceHeadModule
{
    public class SWOTAnalysisOTDeliverablesServiceHeadDto : BaseDto<SWOTAnalysisOTDeliverablesServiceHead, long>
    {   
        public int? ExternalContextId { get; set; }
        public string? ExternalContext { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

        public SWOTAnalysisOTDeliverablesServiceHeadDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOTDeliverablesServiceHeadDto(SWOTAnalysisOTDeliverablesServiceHead entity)
        {
            this.Id = entity.Id;
            this.ExternalContextId = entity.ExternalContextId;
            this.ExternalContext = entity.ExternalContext?.ExternalContext;
            this.Opportunities = entity.Opportunities;
            this.Threats = entity.Threats;
        }

        public override SWOTAnalysisOTDeliverablesServiceHead ToEntity()
        {
            return new SWOTAnalysisOTDeliverablesServiceHead()
            {
                Id = Id,
                ExternalContextId = ExternalContextId,
                Opportunities = Opportunities,
                Threats = Threats,
            };
        }
    }
}
