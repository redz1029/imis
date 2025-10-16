using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.BreakThroughScoringModule
{
    public class BreakThroughScoringDto : BaseDto<BreakThroughScoring, int>
    {
        public required long PgsDeliverableId { get; set; }    
        public double? PercentAccomplishment { get; set; }
        public double? Target { get; set; }
        public double? Strategic { get; set; }
        public double? BreakThrough { get; set; }
        public double? FinalScore { get; set; }

        public BreakThroughScoringDto() { }

        [SetsRequiredMembers]
        public BreakThroughScoringDto(BreakThroughScoring office)
        {
            this.Id = office.Id;
            this.PgsDeliverableId = office.PgsDeliverableId;
            this.PercentAccomplishment = office.PercentAccomplishment;
            this.Target = office.Target;
            this.Strategic = office.Strategic;
            this.BreakThrough = office.BreakThrough;
            this.FinalScore = office.FinalScore;
        }

        public override BreakThroughScoring ToEntity()
        {
            return new BreakThroughScoring()
            {
                Id = this.Id,
                PgsDeliverableId = this.PgsDeliverableId,
                PercentAccomplishment = this.PercentAccomplishment,
                Target = this.Target,
                Strategic = this.Strategic,
                BreakThrough = this.BreakThrough,
                FinalScore = this.FinalScore
            };
        }
    }
}
