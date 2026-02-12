using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapModule;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableDto : BaseDto<KraRoadMapDeliverable, long>
    {
        public string? KraDescription { get; set; }
        public string? DeliverableDescription { get; set; }
        public required int Year { get; set; }
        public bool IsEnabler { get; set; }
        public long KraRoadMapId { get; set; }   

        public KraRoadMapDeliverableDto() { }

        [SetsRequiredMembers]
        public KraRoadMapDeliverableDto(KraRoadMapDeliverable entity)
        {
            Id = entity.Id;
            KraDescription = entity.KraDescription;
            DeliverableDescription = entity.DeliverableDescription;
            Year = entity.Year;
            IsEnabler = entity.IsEnabler;
            KraRoadMapId = entity.KraRoadMapId;

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
                KraRoadMapId = KraRoadMapId
            };
        }
    }
}
