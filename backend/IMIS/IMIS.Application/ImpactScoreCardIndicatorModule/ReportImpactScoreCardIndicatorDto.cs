using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardTargetModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactScoreCardIndicatorModule
{
    public class ReportImpactScoreCardIndicatorDto : BaseDto<ImpactScoreCardIndicator, long>
    {
        public long? ImpactScoreCardId { get; set; }
        public string? IndicatorDescription { get; set; }
        public List<ImpactScoreCardTargetDto>? ImpactScoreCardTarget { get; set; }

        public string? ImpactDescription { get; set; }

        public List<int?>? AllYears { get; set; }

        public int? Year1 => AllYears?.ElementAtOrDefault(0);
        public int? Year2 => AllYears?.ElementAtOrDefault(1);
        public int? Year3 => AllYears?.ElementAtOrDefault(2);
        public int? Year4 => AllYears?.ElementAtOrDefault(3);
        public int? Year5 => AllYears?.ElementAtOrDefault(4);
        public int? Year6 => AllYears?.ElementAtOrDefault(5);

        public string? Year1Target => GetTargetByYear(Year1);
        public string? Year2Target => GetTargetByYear(Year2);
        public string? Year3Target => GetTargetByYear(Year3);
        public string? Year4Target => GetTargetByYear(Year4);
        public string? Year5Target => GetTargetByYear(Year5);
        public string? Year6Target => GetTargetByYear(Year6);

        private string? GetTargetByYear(int? year)
        {
            if (year == null) return null;
            return ImpactScoreCardTarget?.FirstOrDefault(t => t.Year == year)?.Target;
        }

        public ReportImpactScoreCardIndicatorDto() { }

        [SetsRequiredMembers]
        public ReportImpactScoreCardIndicatorDto(ImpactScoreCardIndicator entity)
        {
            Id = entity.Id;
            ImpactScoreCardId = entity.ImpactScoreCardId;
            IndicatorDescription = entity.IndicatorDescription;
            ImpactScoreCardTarget = entity.ImpactScoreCardTarget?
                .Where(t => !t.IsDeleted)
                .Select(d => new ImpactScoreCardTargetDto
                {
                    Id = d.Id,
                    ImpactScoreCardIndicatorId = d.ImpactScoreCardIndicatorId,
                    Year = d.Year,
                    Target = d.Target,
                })
                .ToList();
        }

        public override ImpactScoreCardIndicator ToEntity()
        {
            return new ImpactScoreCardIndicator()
            {
                Id = Id,
                ImpactScoreCardId = ImpactScoreCardId,
                ImpactScoreCardTarget = ImpactScoreCardTarget?
                .Select(d =>
                {
                    var entity = d.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
            };
        }
    }
}