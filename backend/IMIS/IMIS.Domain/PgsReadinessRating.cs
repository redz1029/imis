using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsReadinessRating : Entity<long>
    {
        public double CompetenceToDeliver { get; set; }
        public double ResourceAvailability { get; set; }
        public double ConfidenceToDeliver { get; set; }

        public double TotalScore => CompetenceToDeliver + ResourceAvailability + ConfidenceToDeliver;

        public PgsReadinessRating() { }

        public PgsReadinessRating(double score1, double score2, double score3)
        {
            CompetenceToDeliver = score1;
            ResourceAvailability = score2;
            ConfidenceToDeliver = score3;
        }       
    }
}
