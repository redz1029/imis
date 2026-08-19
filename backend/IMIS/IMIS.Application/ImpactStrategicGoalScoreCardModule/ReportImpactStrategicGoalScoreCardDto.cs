using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardModule;
using IMIS.Application.ImpactStrategicGoalScoreCardPeriodModule;
using IMIS.Application.ImpactStrategicScoreCardModule;
using IMIS.Domain;

namespace IMIS.Application.ImpactStrategicGoalScoreCardModule
{
    public class ReportImpactStrategicGoalScoreCardDto : BaseDto<ImpactStrategicGoalScoreCard, long>
    {
        public int? ImpactStrategicGoalScoreCardPeriodId { get; set; }
        public ImpactStrategicGoalScoreCardPeriodDto? ImpactStrategicGoalScoreCardPeriod { get; set; }

        public List<ReportImpactScoreCardDto>? ImpactScoreCard { get; set; }

        public List<ReportImpactScoreCardDto>? DuplicateImpactScoreCard { get; set; }
      
        public List<ReportNonDuplicateImpactScoreCardDto>? NonDuplicateImpactScoreCard { get; set; }

        public List<int?>? ImpactScoreCardYears { get; set; }
        public int? Year1 => ImpactScoreCardYears?.ElementAtOrDefault(0);
        public int? Year2 => ImpactScoreCardYears?.ElementAtOrDefault(1);
        public int? Year3 => ImpactScoreCardYears?.ElementAtOrDefault(2);
        public int? Year4 => ImpactScoreCardYears?.ElementAtOrDefault(3);
        public int? Year5 => ImpactScoreCardYears?.ElementAtOrDefault(4);
        public int? Year6 => ImpactScoreCardYears?.ElementAtOrDefault(5);

        public List<ReportImpactStrategicScoreCardDto>? ImpactStrategicScoreCard { get; set; }

        public List<int?>? ImpactStrategicScoreCardYears { get; set; }
        public int? StrategicYear1 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(0);
        public int? StrategicYear2 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(1);
        public int? StrategicYear3 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(2);
        public int? StrategicYear4 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(3);
        public int? StrategicYear5 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(4);
        public int? StrategicYear6 => ImpactStrategicScoreCardYears?.ElementAtOrDefault(5);

        public ReportImpactStrategicGoalScoreCardDto() { }

        [SetsRequiredMembers]
        public ReportImpactStrategicGoalScoreCardDto(ImpactStrategicGoalScoreCard entity)
        {
            Id = entity.Id;
            ImpactStrategicGoalScoreCardPeriodId = entity.ImpactStrategicGoalScoreCardPeriodId;
            ImpactStrategicGoalScoreCardPeriod = entity.ImpactStrategicGoalScoreCardPeriod != null
                ? new ImpactStrategicGoalScoreCardPeriodDto(entity.ImpactStrategicGoalScoreCardPeriod)
                : null;

            ImpactScoreCardYears = entity.ImpactScoreCard?
                .Where(d => !d.IsDeleted)
                .SelectMany(d => d.ImpactScoreCardIndicator ?? new List<ImpactScoreCardIndicator>())
                .Where(i => !i.IsDeleted)
                .SelectMany(i => i.ImpactScoreCardTarget ?? new List<ImpactScoreCardTarget>())
                .Where(t => !t.IsDeleted)
                .Select(t => (int?)t.Year)
                .Distinct()
                .OrderBy(y => y)
                .ToList();

            ImpactScoreCard = entity.ImpactScoreCard?
                .Where(d => !d.IsDeleted)
                .Select(d =>
                {
                    var dto = new ReportImpactScoreCardDto(d);
                    if (dto.ImpactScoreCardIndicator != null)
                    {
                        foreach (var indicator in dto.ImpactScoreCardIndicator)
                        {
                            indicator.AllYears = ImpactScoreCardYears;
                        }
                    }
                    return dto;
                })
                .ToList();
      
            if (entity.ImpactScoreCard != null)
            {
                var sourceScoreCards = entity.ImpactScoreCard.Where(d => !d.IsDeleted).ToList();

                DuplicateImpactScoreCard = sourceScoreCards
                    .Where(d => (d.ImpactScoreCardIndicator?.Where(i => !i.IsDeleted).Count() ?? 0) > 1)
                    .Select(d =>
                    {
                        var dto = new ReportImpactScoreCardDto(d);
                        if (dto.ImpactScoreCardIndicator != null)
                        {
                            foreach (var indicator in dto.ImpactScoreCardIndicator)
                            {
                                indicator.AllYears = ImpactScoreCardYears;
                            }
                        }
                        return dto;
                    })
                    .ToList();

                NonDuplicateImpactScoreCard = sourceScoreCards
                    .Where(d => (d.ImpactScoreCardIndicator?.Where(i => !i.IsDeleted).Count() ?? 0) <= 1)
                    .Select(d =>
                    {
                        var dto = new ReportNonDuplicateImpactScoreCardDto(d);
                        if (dto.ImpactScoreCardIndicator != null)
                        {
                            foreach (var indicator in dto.ImpactScoreCardIndicator)
                            {
                                indicator.AllYears = ImpactScoreCardYears;
                            }
                        }
                        return dto;
                    })
                    .ToList();
            }

            ImpactStrategicScoreCardYears = entity.ImpactStrategicScoreCard?
                .Where(k => !k.IsDeleted)
                .SelectMany(k => k.ImpactStrategicScoreCardMeasure ?? new List<ImpactStrategicScoreCardMeasure>())
                .Where(m => !m.IsDeleted)
                .SelectMany(m => m.ImpactStrategicScoreCardTarget ?? new List<ImpactStrategicScoreCardTarget>())
                .Where(t => !t.IsDeleted)
                .Select(t => (int?)t.Year)
                .Distinct()
                .OrderBy(y => y)
                .ToList();

            ImpactStrategicScoreCard = entity.ImpactStrategicScoreCard?
                .Where(k => !k.IsDeleted)
                .Select(k =>
                {
                    var dto = new ReportImpactStrategicScoreCardDto(k);
                    if (dto.ImpactStrategicScoreCardMeasure != null)
                    {
                        foreach (var measure in dto.ImpactStrategicScoreCardMeasure)
                        {
                            measure.AllYears = ImpactStrategicScoreCardYears;
                        }
                    }
                    return dto;
                })
                .ToList();
        }

        public override ImpactStrategicGoalScoreCard ToEntity()
        {
            return new ImpactStrategicGoalScoreCard()
            {
                Id = Id,
                ImpactStrategicGoalScoreCardPeriodId = ImpactStrategicGoalScoreCardPeriodId,
                ImpactScoreCard = ImpactScoreCard?
                .Select(d =>
                {
                    var entity = d.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
                ImpactStrategicScoreCard = ImpactStrategicScoreCard?
                .Select(k =>
                {
                    var entity = k.ToEntity();
                    entity.IsDeleted = false;
                    return entity;
                })
                .ToList(),
            };
        }
    }
}