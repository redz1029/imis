using System.Diagnostics.CodeAnalysis;
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
        public PgsReadinessRatingDto() { }
        [SetsRequiredMembers]
        public PgsReadinessRatingDto(PgsReadinessRating pgsReadinessRating)
        {
            this.Id = pgsReadinessRating.Id;
            this.CompetenceToDeliver = pgsReadinessRating.CompetenceToDeliver;
            this.ResourceAvailability = pgsReadinessRating.ResourceAvailability;
            this.ConfidenceToDeliver = pgsReadinessRating.ConfidenceToDeliver;
            this.TotalScore = pgsReadinessRating.TotalScore;
            this.IsDeleted = pgsReadinessRating.IsDeleted;
            this.RowVersion = pgsReadinessRating.RowVersion;
        }
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
