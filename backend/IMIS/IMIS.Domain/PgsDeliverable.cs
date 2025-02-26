using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsDeliverable : Entity<long>
    {      
        public  KeyResultArea? Kra { get; set; } 
        public required bool IsDirect { get; set; }       
        public required string DeliverableName { get; set; } 
        public required DateTime ByWhen { get; set; }  
        public required double PercentDeliverables { get; set; } 
        public required PgsStatus Status { get; set; }                   
        public PGSReadinessRatingCancerCare? PgsReadinessRatingCancerCare { get; set; }      
        public string? Remarks { get; set; }         
    }
}

