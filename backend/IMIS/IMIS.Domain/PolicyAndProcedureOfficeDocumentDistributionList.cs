using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureOfficeDocumentDistributionList : Entity<long>
    {
        public long PolicyAndProcedureOfficeDocumentDistributionId { get; set; }
        public PolicyAndProcedureOfficeDocumentDistribution? PolicyAndProcedureOfficeDocumentDistribution { get; set; }

        public string? CopyHolderUserId { get; set; }
        public User? CopyHolderUser { get; set; }

        public int? OfficeId { get; set; }
        public Office? Office { get; set; }

        public DateTime? IssuanceDate { get; set; }
        public string? IssuanceRevision { get; set; }

        public DateTime? RetrievalDate { get; set; }
        public string? RetrievalRevision { get; set; }

    }
}
