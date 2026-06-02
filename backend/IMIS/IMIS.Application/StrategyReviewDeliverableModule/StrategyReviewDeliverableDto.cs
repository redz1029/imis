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
                ActualDate = ActualDate,
                Status = Status,
            };
        }
    }
}