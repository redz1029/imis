using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public class PGSReadinessRatingCancerCareDto : BaseDto<PGSReadinessRatingCancerCare, long>
    {
        public double Score1 { get; set; }
        public double Score2 { get; set; }
        public double Score3 { get; set; }
        public double TotalScore { get; set; }
      
        public override PGSReadinessRatingCancerCare ToEntity()
        {
            return new PGSReadinessRatingCancerCare()
            {
                Id = Id,
                Score1 = Score1,
                Score2 = Score2,
                Score3 = Score3
            };
        }
    }
}
