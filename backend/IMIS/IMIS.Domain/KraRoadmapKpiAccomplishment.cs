using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadmapKpiAccomplishment : Entity<long>
    {
        public required int KraRoadMapKpiId { get; set; }

        [ForeignKey(nameof(KraRoadMapKpiId))]
        public virtual KraRoadMapKpi? KraRoadmapKpi { get; set; }
        public DateTime PostingDate { get; set; }

        public required string UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }

        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AttachmentPath { get; set; }
    }
}
