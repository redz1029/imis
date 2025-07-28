using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryDto :  BaseDto<PgsDeliverableHistory, long>
    {
        public long PgsId { get; set; }
        public long DeliverableId { get; set; }
        public string? DeliverableTitle { get; set; }
        public string? Description { get; set; }
        public long? KraId { get; set; }
        public string? KraName { get; set; }
        public string? RemovedBy { get; set; }
        public DateTime RemovedAt { get; set; } = DateTime.UtcNow;

        public PgsDeliverableHistoryDto() { }


        public PgsDeliverableHistoryDto(PgsDeliverableHistory entity)
        {
            Id = entity.Id; 
            PgsId = entity.PgsId;
            DeliverableId = entity.DeliverableId;
            DeliverableTitle = entity.DeliverableTitle;
            Description = entity.Description;
            KraId = entity.KraId;
            KraName = entity.KraName;
            RemovedBy = entity.RemovedBy;
            RemovedAt = entity.RemovedAt;
        }

        public override PgsDeliverableHistory ToEntity()
        {

            return new PgsDeliverableHistory
            {
                Id = Id,
                PgsId = PgsId,
                DeliverableId = DeliverableId,
                DeliverableTitle = DeliverableTitle,
                Description = Description,
                KraId = KraId,
                KraName = KraName,
                RemovedBy = RemovedBy,
                RemovedAt = RemovedAt,
            };
        }
    }
}
