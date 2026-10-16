using Base.Primitives;


namespace IMIS.Domain
{
    public class IsoStandard : Entity<long>
    {
        public required int VersionID { get; set; }
        public StandardVersion? Version { get; set; }

        public required string ClauseRef { get; set; }

        public string? Description { get; set; }
        public required bool isActive { get; set; }
    }
}
