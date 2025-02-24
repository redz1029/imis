using Base.Primitives;

namespace IMIS.Domain
{
    public class PGSReadinessRatingCancerCare : Entity<long>
    {
        public double Score1 { get; set; }
        public double Score2 { get; set; }
        public double Score3 { get; set; }

        public double TotalScore => Score1 + Score2 + Score3;

        public PGSReadinessRatingCancerCare() { }

        public PGSReadinessRatingCancerCare(double score1, double score2, double score3)
        {
            Score1 = score1;
            Score2 = score2;
            Score3 = score3;
        }       
    }
}
