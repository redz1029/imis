using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureOfficeDocumentDistribution : Entity<long>
    {
        public long PolicyAndProcedureId { get; set; }
        public PolicyAndProcedure? PolicyAndProcedure { get; set; }
        public DateTime? PostingDate { get; set; }
        public bool? IsControlledCopy { get; set; }
        public bool? IsMasterCopy { get; set; }
        public virtual ICollection<PolicyAndProcedureOfficeDocumentDistributionList> OfficeDocumentDistributionList { get; set; } = new List<PolicyAndProcedureOfficeDocumentDistributionList>();
    }
}
