using System.Diagnostics.CodeAnalysis;
using IMIS.Application.ImpactScoreCardIndicatorModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactScoreCardModule
{
    public class ReportNonDuplicateImpactScoreCardDto : ReportImpactScoreCardDto
    {      
        public List<ReportImpactScoreCardIndicatorDto>? NonDuplicateImpactScoreCardIndicator
        {
            get => ImpactScoreCardIndicator;
            set => ImpactScoreCardIndicator = value;
        }

        public ReportNonDuplicateImpactScoreCardDto() { }

        [SetsRequiredMembers]
        public ReportNonDuplicateImpactScoreCardDto(ImpactScoreCard entity) : base(entity) { }
    }
}
