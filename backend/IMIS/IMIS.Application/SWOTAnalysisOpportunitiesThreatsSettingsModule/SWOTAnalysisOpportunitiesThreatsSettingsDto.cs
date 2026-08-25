using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisOpportunitiesThreatsModule
{
    public class SWOTAnalysisOpportunitiesThreatsSettingsDto : BaseDto<SWOTAnalysisOpportunitiesThreatsSettings, int>
    {

        public string? ExternalContext { get; set; }


        public SWOTAnalysisOpportunitiesThreatsSettingsDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisOpportunitiesThreatsSettingsDto(SWOTAnalysisOpportunitiesThreatsSettings entity)
        {
            this.Id = entity.Id;
            this.ExternalContext = entity.ExternalContext;       
        }
        public override SWOTAnalysisOpportunitiesThreatsSettings ToEntity()
        {
            return new SWOTAnalysisOpportunitiesThreatsSettings() { Id = Id, ExternalContext = ExternalContext };
        }
    }
}
