using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsSummaryNarrativeModule
{
    public class PGSSummaryNarrativeDto : BaseDto<PgsSummaryNarrative, int>
    {
        public string? Findings { get; set; }
        public string? Recommendation { get; set; }
        public string? Conclusion { get; set; }
        public int? PgsPeriodId { get; set; }
        public int? OfficeId { get; set; }

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
            this.OfficeId = pgsSummaryNarrative.OfficeId;
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
                OfficeId = OfficeId
            };
        }
    }
}
