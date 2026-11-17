using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureDCRRFModule
{
    public class PolicyAndProcedureDCRRFDto : BaseDto<PolicyAndProcedureDCRRF, long>
    {
        public long PolicyAndProcedureId { get; set; }
        public string? InitiatorUserId { get; set; }
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
        public string? ApprovedByUserId { get; set; }
        public DateTime? DocumentAmendedDate { get; set; }
        public DateTime? RevisionHistoryLogUpdatedDate { get; set; }
        public DateTime? MasterLisUpdatedtDate { get; set; }
        public DateTime? DocumentIssuedtDate { get; set; }
        public DateTime? PostingDate { get; set; }

        public PolicyAndProcedureDCRRFDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureDCRRFDto(PolicyAndProcedureDCRRF entity)
        {
            Id = entity.Id;
            PolicyAndProcedureId = entity.PolicyAndProcedureId;
            InitiatorUserId = entity.InitiatorUserId;
            Date = entity.Date;
            ReferenceNo = entity.ReferenceNo;
            ManualTitle = entity.ManualTitle;
            IsNew = entity.IsNew;
            IsRevision = entity.IsRevision;
            IsDeletion = entity.IsDeletion;
            RevisionNo = entity.RevisionNo;
            Justification = entity. Justification;
            IsRequestDenied = entity.IsRequestDenied;
            IsRequestApproved = entity.IsRequestApproved;
            SuggestionForRevision = entity.SuggestionForRevision;
            ApprovedByUserId = entity.ApprovedByUserId;
            DocumentAmendedDate = entity.DocumentAmendedDate;
            RevisionHistoryLogUpdatedDate = entity.RevisionHistoryLogUpdatedDate;
            MasterLisUpdatedtDate = entity.MasterLisUpdatedtDate;
            DocumentIssuedtDate = entity.DocumentIssuedtDate;
            PostingDate = entity.PostingDate;
            
        }

        public override PolicyAndProcedureDCRRF ToEntity()
        {
            return new PolicyAndProcedureDCRRF
            {
                Id = Id,
                PolicyAndProcedureId = PolicyAndProcedureId,
                InitiatorUserId = InitiatorUserId,
                Date = Date,
                ReferenceNo = ReferenceNo,
                ManualTitle = ManualTitle,
                IsNew = IsNew,
                IsRevision = IsRevision,
                IsDeletion = IsDeletion,
                RevisionNo = RevisionNo,
                Justification = Justification,
                IsRequestDenied = IsRequestDenied,
                IsRequestApproved = IsRequestApproved,
                SuggestionForRevision = SuggestionForRevision,
                ApprovedByUserId = ApprovedByUserId,
                DocumentAmendedDate = DocumentAmendedDate,
                RevisionHistoryLogUpdatedDate = RevisionHistoryLogUpdatedDate,
                MasterLisUpdatedtDate = MasterLisUpdatedtDate,
                DocumentIssuedtDate = DocumentIssuedtDate,
                PostingDate = PostingDate,             
            };
        }
    }
}
