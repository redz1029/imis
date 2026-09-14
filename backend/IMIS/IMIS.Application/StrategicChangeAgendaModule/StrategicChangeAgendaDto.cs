using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaDto : BaseDto<StrategicChangeAgenda, long>
    {
        public string? From { get; set; }
        public string? To { get; set; }

        public List<StrategicChangeAgendaDeliverableGroupDto>? StrategicChangeAgendaDeliverable { get; set; }

        public StrategicChangeAgendaDto()
        {
        }

        [SetsRequiredMembers]
        public StrategicChangeAgendaDto(StrategicChangeAgenda entity)
        {
            Id = entity.Id;
            From = entity.From;
            To = entity.To;

            StrategicChangeAgendaDeliverable =  entity.StrategicChangeAgendaDeliverable?
            .Where(x => !x.IsDeleted)
            .GroupBy(x => x.Area)
            .Select(g => new StrategicChangeAgendaDeliverableGroupDto
            {
                Id = g.First().Id,
                Area = g.Key,
                Items = g.ToList()
            })
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
                .SelectMany(g =>
                    g.Items ?? new List<StrategicChangeAgendaDeliverable>())
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