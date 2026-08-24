using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisSWDeliverablesModule
{
    public class SWOTAnalysisSWDeliverablesDto : BaseDto<SWOTAnalysisSWDeliverables, long>
    {
        public long? SWOTAnalysisId { get; set; }
        public int? InternalContextId { get; set; }
        public string? InternalContext { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }

        public SWOTAnalysisSWDeliverablesDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisSWDeliverablesDto(SWOTAnalysisSWDeliverables entity)
        {
            this.Id = entity.Id;
            this.SWOTAnalysisId = entity.SWOTAnalysisId;
            this.InternalContextId = entity.InternalContextId;
            this.InternalContext = entity.InternalContext?.InternalContext;
            this.Opportunities = entity.Opportunities;
            this.Threats = entity.Threats;
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