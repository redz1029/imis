using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedure : Entity<long>
    {
        public string? Title { get; set; }
        public string? ProcessOwner { get; set; }
        public string? RegulatoryStandard { get; set; }
        public DateTime EffectiveDate { get; set; }
        public int? SectionId { get; set; }
        public Office? Section { get; set; }
        public string? DocumentCode { get; set; }
        public string? Revision { get; set; }
        public string? Content { get; set; }
        public bool? IsMasterCopy { get; set; }
        public bool? IsControlledCopy { get; set; }
        public string? MinutesAttachmentPath { get; set; }
        public virtual ICollection<PolicyAndProcedureSignatory> PAPSignatories { get; set; } = new List<PolicyAndProcedureSignatory>();
    }
}
