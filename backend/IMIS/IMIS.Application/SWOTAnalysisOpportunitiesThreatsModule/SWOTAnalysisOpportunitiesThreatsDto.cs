using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsDto : BaseDto<SWOTAnalysisOpportunitiesThreats, int>
    {

        public string? InternalContext { get; set; }


        public SWOTAnalysisOpportunitiesThreatsDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOpportunitiesThreatsDto(SWOTAnalysisOpportunitiesThreats entity)
        {
            this.Id = entity.Id;
            this.InternalContext = entity.InternalContext;       
        }
        public override SWOTAnalysisOpportunitiesThreats ToEntity()
        {
            return new SWOTAnalysisOpportunitiesThreats() { Id = Id, InternalContext = InternalContext};
        }
    }
}
