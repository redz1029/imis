using Base.Primitives;

namespace IMIS.Domain
{
    public class KeyResultArea : Entity<int>
    {
        public required string Name { get; set; }     
        public required string Remarks { get; set; }
        public  string? StrategicObjective { get; set; }
    }
}
