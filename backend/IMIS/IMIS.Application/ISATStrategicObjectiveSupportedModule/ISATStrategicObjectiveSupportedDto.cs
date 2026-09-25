using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATStrategicObjectiveSupportedModule
{
    public class ISATStrategicObjectiveSupportedDto : BaseDto<ISATStrategicObjectiveSupported, long>
    {
        public long ISATId { get; set; }
        public long? KraRoadMapId { get; set; }
        public string? KraName { get; set; }
        public long? KraRoadMapDeliverableId { get; set; }
        public string? KraRoadMapDeliverableName { get; set; }
        public string? StrategicObjective { get; set; }
        public DateTime? PostingDate { get; set; }
        public ISATStrategicObjectiveSupportedDto()
        {
        }

        [SetsRequiredMembers]
        public ISATStrategicObjectiveSupportedDto(ISATStrategicObjectiveSupported ISATStrategicObjectiveSupported)
        {
            this.Id = ISATStrategicObjectiveSupported.Id;
            this.ISATId = ISATStrategicObjectiveSupported.ISATId;
            this.KraRoadMapId = ISATStrategicObjectiveSupported.KraRoadMapId;
            this.KraRoadMapDeliverableId = ISATStrategicObjectiveSupported.KraRoadMapDeliverableId;
            this.PostingDate = ISATStrategicObjectiveSupported.PostingDate;
            this.KraName = ISATStrategicObjectiveSupported.KraRoadMap?.Kra?.Name;
            this.KraRoadMapDeliverableName = ISATStrategicObjectiveSupported.KraRoadMapDeliverable?.DeliverableDescription;
            this.StrategicObjective = ISATStrategicObjectiveSupported.KraRoadMap?.Kra?.StrategicObjective;

        }
        public override ISATStrategicObjectiveSupported ToEntity()
        {
            return new ISATStrategicObjectiveSupported()
            {
                Id = Id,
                ISATId = ISATId,
                KraRoadMapId = KraRoadMapId,
                KraRoadMapDeliverableId = KraRoadMapDeliverableId,
                PostingDate = PostingDate,            
            };
        }
    }
}
