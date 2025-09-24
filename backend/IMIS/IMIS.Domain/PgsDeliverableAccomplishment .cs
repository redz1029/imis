using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsDeliverableAccomplishment : Entity<long>
    {
        public required long PgsDeliverableId { get; set; }

        [ForeignKey(nameof(PgsDeliverableId))]
        public virtual PgsDeliverable? PgsDeliverable { get; set; }

        public DateTime PostingDate { get; set; }

        public required string UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public virtual User? User { get; set; }

        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
     
        public string? AttachmentPath { get; set; }
    }
}
