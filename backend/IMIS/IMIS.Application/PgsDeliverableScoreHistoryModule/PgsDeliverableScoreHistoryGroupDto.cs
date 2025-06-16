
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableScoreHistoryModule
{
    public class PgsDeliverableScoreHistoryGroupDto
    {
        public long PgsDeliverableId { get; set; }
        public List<PgsDeliverableScoreHistoryDto>? ScoreHistory { get; set; }     
    }
}
