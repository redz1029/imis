using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PGSReadinessRatingCancerCareModule
{
    public class PgsReadinessRatingDto : BaseDto<PgsReadinessRating, long>
    {
        public double CompetenceToDeliver { get; set; }
        public double ResourceAvailability { get; set; }
        public double ConfidenceToDeliver { get; set; }
        public double TotalScore { get; set; }      
        public override PgsReadinessRating ToEntity()
        {
            return new PgsReadinessRating()
            {
                Id = Id,
                CompetenceToDeliver = CompetenceToDeliver,
                ResourceAvailability = ResourceAvailability,
                ConfidenceToDeliver = ConfidenceToDeliver
            };
        }
    }
}
