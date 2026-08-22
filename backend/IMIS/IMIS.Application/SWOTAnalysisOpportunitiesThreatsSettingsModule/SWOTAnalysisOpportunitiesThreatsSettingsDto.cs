using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsSettingsDto : BaseDto<SWOTAnalysisOpportunitiesThreatsSettings, int>
    {

        public string? InternalContext { get; set; }


        public SWOTAnalysisOpportunitiesThreatsSettingsDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOpportunitiesThreatsSettingsDto(SWOTAnalysisOpportunitiesThreatsSettings entity)
        {
            this.Id = entity.Id;
            this.InternalContext = entity.InternalContext;       
        }
        public override SWOTAnalysisOpportunitiesThreatsSettings ToEntity()
        {
            return new SWOTAnalysisOpportunitiesThreatsSettings() { Id = Id, InternalContext = InternalContext};
        }
    }
}
