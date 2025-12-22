using Base.Primitives;

namespace IMIS.Domain
{
    public class CharacterNote : Entity<long>
    {
        public required string Note { get; set; }

        // Foreign key to Character (many notes to one Character)
        public long CharacterId { get; set; }

        // Navigation
        public required Character Character { get; set; }
    }
}
