using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableGroupDto : BaseDto<KraRoadMapDeliverable, long>
    {
        public string? KraDescription { get; set; }
        public List<KraRoadMapDeliverable>? Items { get; set; }

        public KraRoadMapDeliverableGroupDto() { }

        public KraRoadMapDeliverableGroupDto(KraRoadMapDeliverable deliverable)
        {
            Id = deliverable.Id;
            KraDescription = deliverable.KraDescription;
            Items = new List<KraRoadMapDeliverable> { deliverable };
        }
        public override KraRoadMapDeliverable ToEntity()
        {
            if (Items == null || Items.Count == 0)
                throw new InvalidOperationException("Cannot convert to entity because Items list is empty.");
        
            return Items[0];
        }

    }
}
