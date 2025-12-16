using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableDto : BaseDto<KraRoadMapDeliverable, long>
    {
        public string? KraDescription { get; set; }
        public string? DeliverableDescription { get; set; }
        public required int Year { get; set; }
        public bool IsEnabler { get; set; }


        public KraRoadMapDeliverableDto() { }
        [SetsRequiredMembers]
        public KraRoadMapDeliverableDto(KraRoadMapDeliverable kraRoadMapDeliverableDto)
        {
            this.Id = kraRoadMapDeliverableDto.Id;
            this.KraDescription = kraRoadMapDeliverableDto.KraDescription;
            this.DeliverableDescription = kraRoadMapDeliverableDto.DeliverableDescription;
            this.Year = kraRoadMapDeliverableDto.Year;
            this.IsEnabler = kraRoadMapDeliverableDto.IsEnabler;
        }
        public override KraRoadMapDeliverable ToEntity()
        {
            return new KraRoadMapDeliverable()
            {
                Id = Id,
                KraDescription = KraDescription,
                DeliverableDescription = DeliverableDescription,
                Year = Year,
                IsEnabler = IsEnabler,
            };
        }
    }
}
