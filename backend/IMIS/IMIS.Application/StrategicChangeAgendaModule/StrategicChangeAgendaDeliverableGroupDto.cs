using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaDeliverableGroupDto
    {
        public long Id { get; set; }

        public string? Area { get; set; }

        public List<StrategicChangeAgendaDeliverable>? Items { get; set; }
    }
}