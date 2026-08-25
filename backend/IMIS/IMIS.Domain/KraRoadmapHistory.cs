using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadmapHistory : Entity<long>
    {
        public string? KraDescription { get; set; }
        public int? Year { get; set; }
        public string? DeliverableDescription { get; set; }

        public long KraRoadMapId { get; set; }

        [ForeignKey(nameof(KraRoadMapId))]
        public KraRoadMap? KraRoadMap { get; set; }

        public DateTime PostingDate { get; set; }

        public required string UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public User? User { get; set; }
    }
}
