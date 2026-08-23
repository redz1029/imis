using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisSWDeliverablesModule
{
    public class SWOTAnalysisSWDeliverablesDto : BaseDto<SWOTAnalysisSWDeliverables, long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? InternalContextId { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

        public SWOTAnalysisSWDeliverablesDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisSWDeliverablesDto(SWOTAnalysisSWDeliverables SWOTAnalysisDto)
        {
            this.Id = SWOTAnalysisDto.Id;
            this.SWOTAnalysisId = SWOTAnalysisDto.SWOTAnalysisId;
            this.InternalContextId = SWOTAnalysisDto.InternalContextId;
            this.Opportunities = SWOTAnalysisDto.Opportunities;
            this.Threats = SWOTAnalysisDto.Threats;
            this.Threats = SWOTAnalysisDto.Threats;
        }

        public override SWOTAnalysisSWDeliverables ToEntity()
        {
            return new SWOTAnalysisSWDeliverables()
            {
                Id = Id,
                SWOTAnalysisId = SWOTAnalysisId,
                InternalContextId = InternalContextId,
                Opportunities = Opportunities,
                Threats = Threats,
            };
        }
    }
}
