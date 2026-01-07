using Base.Primitives;

namespace IMIS.Domain
{
    public class StrategicObjective : Entity<long>
    {
        public required string Objective { get; set; }

        // FOREIGN KEY (One-to-One)
        public long CharacterId { get; set; }

        // NAVIGATION (optional)
        public Character? Character { get; set; }
    }
}
