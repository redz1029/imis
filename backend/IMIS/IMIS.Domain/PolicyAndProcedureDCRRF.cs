using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureDCRRF : Entity<long>
    {
        public long PolicyAndProcedureId { get; set; }
        public PolicyAndProcedure? PolicyAndProcedure { get; set; }
        public string? InitiatorUserId { get; set; }
        public User? InitiatorUser { get; set; }
        public DateTime? Date { get; set; }
        public string? ReferenceNo { get; set; }
        public string? ManualTitle { get; set; }
        public bool? IsNew { get; set; }
        public bool? IsRevision { get; set; }
        public bool? IsDeletion { get; set; }
        public string? RevisionNo { get; set; }
        public string? Justification { get; set; }
        public bool? IsRequestDenied { get; set; }
        public bool? IsRequestApproved { get; set; }
        public string? SuggestionForRevision { get; set; }
        public  string? ApprovedByUserId { get; set; }
        public User? ApprovedByUser { get; set; }
        public DateTime? DocumentAmendedDate { get; set; }
        public DateTime? RevisionHistoryLogUpdatedDate { get; set; }
        public DateTime? MasterLisUpdatedtDate { get; set; }
        public DateTime? DocumentIssuedtDate { get; set; }
        public DateTime? PostingDate { get; set; }

    }
}
