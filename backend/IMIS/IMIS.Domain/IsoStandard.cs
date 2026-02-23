using Base.Primitives;
using FastReport.Utils;


namespace IMIS.Domain
{
    public class IsoStandard : Entity<long>
    {
        public long? ParentID { get; set; }
        public required int VersionID { get; set; }
        public StandardVersion? Version { get; set; }
        public required string Particulars { get; set; }
        public required string ClauseRef { get; set; }

        public string? Description { get; set; }
        public required bool isActive { get; set; }
    }?
}
