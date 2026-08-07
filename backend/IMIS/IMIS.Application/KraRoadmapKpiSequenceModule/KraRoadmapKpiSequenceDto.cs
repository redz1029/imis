using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapKpiSequenceModule
{
    public class KraRoadmapKpiSequenceDto : BaseDto<KraRoadmapKpiSequence, int>
    {
        public string? SequenceCode { get; set; }

        public KraRoadmapKpiSequenceDto() { }

        [SetsRequiredMembers]
        public KraRoadmapKpiSequenceDto(KraRoadmapKpiSequence kraRoadmapKpiSequence)
        {
            this.Id = kraRoadmapKpiSequence.Id;
            this.SequenceCode = kraRoadmapKpiSequence.SequenceCode;
        }
        public override KraRoadmapKpiSequence ToEntity()
        {
            return new KraRoadmapKpiSequence() { Id = Id, SequenceCode = SequenceCode };
        }
     
    }
}
