using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategicChangeAgenda : Entity<long>
    {
        public string? From { get; set; }
        public string? To { get; set; }
        public List<StrategicChangeAgendaDeliverable>? StrategicChangeAgendaDeliverable { get; set; }
    }
}
