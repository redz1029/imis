using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Domain;

namespace IMIS.Application.StrategyReviewDeliverableModule
{
    public class StrategyReviewDeliverableDto : BaseDto<StrategyReviewDeliverable, long>
    {
        public long StrategyReviewId { get; set; }
        public long KraRoadmapid { get; set; }        
        public string? KeyResultArea { get; set; }
        public string? Deliverable { get; set; }
        public string? ActualDate { get; set; }
        public required PgsStatus Status { get; set; }
        public KraRoadMapDeliverableDto? KraRoadMapDeliverableDetails { get; set; }
        public StrategyReviewDeliverableDto() { }
        [SetsRequiredMembers]
        public StrategyReviewDeliverableDto(StrategyReviewDeliverable entity)
        {
            Id = entity.Id;
            StrategyReviewId = entity.StrategyReviewId;
            KraRoadmapid = entity.KraRoadmapid;
            KeyResultArea = entity.KeyResultArea;
            Deliverable = entity.Deliverable;
            ActualDate = entity.ActualDate;
            Status = entity.Status;
        }

        public override StrategyReviewDeliverable ToEntity()
        {
            return new StrategyReviewDeliverable()
            {
                Id = Id,
                StrategyReviewId = StrategyReviewId,
                KraRoadmapid = KraRoadmapid,
                KeyResultArea = KeyResultArea,
                Deliverable = Deliverable,
                ActualDate = ActualDate,
                Status = Status,
            };
        }
    }
}