using Base.Primitives;
using System.ComponentModel.DataAnnotations.Schema;

namespace IMIS.Domain
{
    public class PgsDeliverable : Entity<long>
    {
        public int? KraId { get; set; }
        public  KeyResultArea? Kra { get; set; }
        public string? KraDescription { get; set; }
        public required bool IsDirect { get; set; }       
        public required string DeliverableName { get; set; } 
        public required DateTime ByWhen { get; set; }  
        public required double PercentDeliverables { get; set; } // This should be set as the current/lates score of the deliverable
        public required PgsStatus Status { get; set; }                         
        public string? Remarks { get; set; }    
        public ICollection<PgsDeliverableScoreHistory>? PgsDeliverableScoreHistory { get; set; }
        public long PerfomanceGovernanceSystemId { get; set; }

        [ForeignKey("PerfomanceGovernanceSystemId")]
        [InverseProperty("PgsDeliverables")]
        public virtual PerfomanceGovernanceSystem? PerfomanceGovernanceSystem { get; set; }
    }
}

