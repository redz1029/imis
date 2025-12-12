using Base.Primitives;

namespace IMIS.Domain
{
    public class KraRoadMapDeliverable : Entity<long>
    {
       
        public string? Description { get; set; }
        public required int Year { get; set; }
    }
}
