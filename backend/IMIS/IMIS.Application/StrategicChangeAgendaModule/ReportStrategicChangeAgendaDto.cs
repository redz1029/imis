using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class ReportStrategicChangeAgendaDto : BaseDto<StrategicChangeAgenda, long>
    {
        public string? From { get; set; }
        public string? To { get; set; }

        public List<StrategicChangeAgendaDeliverableGroupDto>? StrategicChangeAgendaDeliverable { get; set; }

        public List<int?>? DeliverableYears { get; set; }

        public int? Year1 => DeliverableYears?.ElementAtOrDefault(0);
        public int? Year2 => DeliverableYears?.ElementAtOrDefault(1);
        public int? Year3 => DeliverableYears?.ElementAtOrDefault(2);
        public int? Year4 => DeliverableYears?.ElementAtOrDefault(3);
        public int? Year5 => DeliverableYears?.ElementAtOrDefault(4);

        public ReportStrategicChangeAgendaDto()
        {
        }

        [SetsRequiredMembers]
        public ReportStrategicChangeAgendaDto(StrategicChangeAgenda entity)
        {
            Id = entity.Id;
            From = entity.From;
            To = entity.To;

            DeliverableYears = entity.StrategicChangeAgendaDeliverable?
                .Where(x => !x.IsDeleted)
                .Select(x => x.Year)
                .Distinct()
                .OrderBy(y => y)
                .ToList();

            StrategicChangeAgendaDeliverable = entity.StrategicChangeAgendaDeliverable?
                .Where(x => !x.IsDeleted)
                .GroupBy(x => x.Area)
                .Select(g => new StrategicChangeAgendaDeliverableGroupDto(
                    items: g.ToList(),
                    allYears: DeliverableYears
                ))
                .ToList();
        }

        public override StrategicChangeAgenda ToEntity()
        {
            return new StrategicChangeAgenda
            {
                Id = Id,
                From = From,
                To = To,
                StrategicChangeAgendaDeliverable = StrategicChangeAgendaDeliverable?
                    .SelectMany(g => g.Items ?? new List<StrategicChangeAgendaDeliverable>())
                    .Select(d =>
                    {
                        d.IsDeleted = false;
                        return d;
                    })
                    .ToList()
            };
        }
    }
}