using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisSWDeliverablesServiceHeadModule
{
    public class SWOTAnalysisSWDeliverablesServiceHeadDto : BaseDto<SWOTAnalysisSWDeliverablesServiceHead, long>
    {
        public int? InternalContextId { get; set; }
        public string? InternalContext { get; set; }
        public string? Strength { get; set; }
        public string? Weaknesses { get; set; }

        public SWOTAnalysisSWDeliverablesServiceHeadDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisSWDeliverablesServiceHeadDto(SWOTAnalysisSWDeliverablesServiceHead entity)
        {
            this.Id = entity.Id;          
            this.InternalContextId = entity.InternalContextId;
            this.InternalContext = entity.InternalContext?.InternalContext;
            this.Strength = entity.Strength;
            this.Weaknesses = entity.Weaknesses;
        }

        public override SWOTAnalysisSWDeliverablesServiceHead ToEntity()
        {
            return new SWOTAnalysisSWDeliverablesServiceHead()
            {
                Id = Id,            
                InternalContextId = InternalContextId,
                Strength = Strength,
                Weaknesses = Weaknesses,
            };
        }
    }
}
