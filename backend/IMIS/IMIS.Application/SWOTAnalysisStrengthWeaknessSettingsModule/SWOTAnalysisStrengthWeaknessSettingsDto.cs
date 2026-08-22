using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisStrengthWeaknessModule
{
    public class SWOTAnalysisStrengthWeaknessSettingsDto : BaseDto<SWOTAnalysisStrengthWeakness, int>
    {

        public string? InternalContext { get; set; }


        public SWOTAnalysisStrengthWeaknessSettingsDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisStrengthWeaknessSettingsDto(SWOTAnalysisStrengthWeakness entity)
        {
            this.Id = entity.Id;
            this.InternalContext = entity.InternalContext;
        }
        public override SWOTAnalysisStrengthWeakness ToEntity()
        {
            return new SWOTAnalysisStrengthWeakness() { Id = Id, InternalContext = InternalContext };
        
        }
    }
}
