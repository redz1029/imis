using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public class PGSSummaryNarrativeDto : BaseDto<PgsSummaryNarrative, int>
    {
        public required string Findings { get; set; }
        public required string Recommendation { get; set; }
        public required string Conclusion { get; set; }
        public int? PgsPeriodId { get; set; }
       
        public PGSSummaryNarrativeDto()
        {
        }

        [SetsRequiredMembers]
        public PGSSummaryNarrativeDto(PgsSummaryNarrative pgsSummaryNarrative)
        {
            this.Id = pgsSummaryNarrative.Id;
            this.Findings = pgsSummaryNarrative.Findings;
            this.Recommendation = pgsSummaryNarrative.Recommendation;
            this.Conclusion = pgsSummaryNarrative.Conclusion;
            this.PgsPeriodId = pgsSummaryNarrative.PgsPeriodId;
        }

        public override PgsSummaryNarrative ToEntity()
        {
            return new PgsSummaryNarrative()
            {
                Id = Id,
                Findings = Findings,
                Recommendation = Recommendation,
                Conclusion = Conclusion,
                PgsPeriodId = PgsPeriodId,
            };
        }
    }
}
