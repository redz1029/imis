using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactStrategicScoreCardTargetModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicScoreCardMeasureModule
{
    public class ReportImpactStrategicScoreCardMeasureDto : BaseDto<ImpactStrategicScoreCardMeasure, long>
    {
        public long? ImpactStrategicScoreCardId { get; set; }
        public string? MeasureDescription { get; set; }
        public List<ImpactStrategicScoreCardTargetDto>? ImpactStrategicScoreCardTarget { get; set; }

        public string? GoalDescription { get; set; }

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
            return ImpactStrategicScoreCardTarget?.FirstOrDefault(t => t.Year == year)?.Target;
        }

        public ReportImpactStrategicScoreCardMeasureDto() { }

        [SetsRequiredMembers]
        public ReportImpactStrategicScoreCardMeasureDto(ImpactStrategicScoreCardMeasure entity)
        {
            Id = entity.Id;
            ImpactStrategicScoreCardId = entity.ImpactStrategicScoreCardId;
            MeasureDescription = entity.MeasureDescription;
            ImpactStrategicScoreCardTarget = entity.ImpactStrategicScoreCardTarget?
                .Where(t => !t.IsDeleted)
                .Select(d => new ImpactStrategicScoreCardTargetDto
                {
                    Id = d.Id,
                    ImpactStrategicScoreCardMeasureId = d.ImpactStrategicScoreCardMeasureId,
                    Year = d.Year,
                    Target = d.Target,
                })
                .ToList();
        }

        public override ImpactStrategicScoreCardMeasure ToEntity()
        {
            return new ImpactStrategicScoreCardMeasure()
            {
                Id = Id,
                ImpactStrategicScoreCardId = ImpactStrategicScoreCardId,
                ImpactStrategicScoreCardTarget = ImpactStrategicScoreCardTarget?
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