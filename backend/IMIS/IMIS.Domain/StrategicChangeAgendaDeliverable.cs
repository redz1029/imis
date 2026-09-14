using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategicChangeAgendaDeliverable : Entity<long>
    {      
        public string? Area { get; set; }
        public int? Year { get; set; }
        public string? Description { get; set; }
    }
}
