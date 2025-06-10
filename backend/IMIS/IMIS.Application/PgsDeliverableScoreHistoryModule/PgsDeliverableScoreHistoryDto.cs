using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryDto : BaseDto<PgsDeliverableScoreHistory, long>
    {
        public long PgsDeliverableId { get; set; }
        public DateTime Date { get; set; }
        public double Score { get; set; }

        public PgsDeliverableScoreHistoryDto() { }

        public PgsDeliverableScoreHistoryDto(PgsDeliverableScoreHistory entity)
        {
            Id = entity.Id;
            PgsDeliverableId = entity.PgsDeliverableId;
            Date = entity.Date;
            Score = entity.Score;
        }

        public override PgsDeliverableScoreHistory ToEntity()
        {
            return new PgsDeliverableScoreHistory
            {
                Id = Id,
                PgsDeliverableId = PgsDeliverableId,
                Date = Date,
                Score = Score
            };
        }
    }
}
