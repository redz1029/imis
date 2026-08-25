using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessSettingsDto : BaseDto<SWOTAnalysisStrengthWeaknessSettings, int>
    {

        public string? InternalContext { get; set; }


        public SWOTAnalysisStrengthWeaknessSettingsDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisStrengthWeaknessSettingsDto(SWOTAnalysisStrengthWeaknessSettings entity)
        {
            this.Id = entity.Id;
            this.InternalContext = entity.InternalContext;
        }
        public override SWOTAnalysisStrengthWeaknessSettings ToEntity()
        {
            return new SWOTAnalysisStrengthWeaknessSettings() { Id = Id, InternalContext = InternalContext };
        
        }
    }
}
