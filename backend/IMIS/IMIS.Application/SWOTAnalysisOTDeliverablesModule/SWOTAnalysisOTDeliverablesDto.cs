using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOTDeliverablesModule
{
    public class SWOTAnalysisOTDeliverablesDto : BaseDto<SWOTAnalysisOTDeliverables, long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? ExternalContextId { get; set; }   
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

        public SWOTAnalysisOTDeliverablesDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOTDeliverablesDto(SWOTAnalysisOTDeliverables SWOTAnalysisDto)
        {
            this.Id = SWOTAnalysisDto.Id;
            this.SWOTAnalysisId = SWOTAnalysisDto.SWOTAnalysisId;
            this.ExternalContextId = SWOTAnalysisDto.ExternalContextId;
            this.Opportunities = SWOTAnalysisDto.Opportunities;
            this.Threats = SWOTAnalysisDto.Threats;
            this.Threats = SWOTAnalysisDto.Threats;     
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
