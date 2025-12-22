using Base.Primitives;


namespace IMIS.Domain
{
    public class Character : Entity<long>
    {
         public required string Name { get; set; }
         public required string Remarks { get; set; }

        
         public StrategicObjective? StrategicObjective { get; set; }
         public List<CharacterNote>? Notes { get; set; }


    }
}
