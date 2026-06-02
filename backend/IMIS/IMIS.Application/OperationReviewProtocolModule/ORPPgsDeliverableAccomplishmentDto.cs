namespace IMIS.Application.OperationReviewProtocolModule
{
    using System.Diagnostics.CodeAnalysis;
    using Base.Primitives;
    using IMIS.Domain;

    public class ORPPgsDeliverableAccomplishmentDto : BaseDto<PgsDeliverableAccomplishment, long>
    {

        public required long PgsDeliverableId { get; set; }
        public required PgsStatus Status { get; set; }
        public DateTime PostingDate { get; set; }
        public required string UserId { get; set; }
        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AuditorRemarks { get; set; }
        public string? AttachmentPath { get; set; }

        public string? DeliverableName { get; set; }
        public string? PgsStatus { get; set; }
        public DateTime? ByWhen { get; set; }
        public ORPPgsDeliverableAccomplishmentDto() { }
        [SetsRequiredMembers]
        public ORPPgsDeliverableAccomplishmentDto(PgsDeliverableAccomplishment pgsDeliverableAccomplishment)
        {
            this.Id = pgsDeliverableAccomplishment.Id;
            this.PgsDeliverableId = pgsDeliverableAccomplishment.PgsDeliverableId;
            this.Status = pgsDeliverableAccomplishment.Status;
            this.PostingDate = pgsDeliverableAccomplishment.PostingDate;
            this.UserId = pgsDeliverableAccomplishment.UserId;
            this.PercentAccomplished = pgsDeliverableAccomplishment.PercentAccomplished;
            this.Remarks = pgsDeliverableAccomplishment?.Remarks;
            this.AuditorRemarks = pgsDeliverableAccomplishment?.AuditorRemarks;
            this.AttachmentPath = pgsDeliverableAccomplishment!.AttachmentPath;
            this.DeliverableName = pgsDeliverableAccomplishment.PgsDeliverable?.DeliverableName;
            this.PgsStatus = pgsDeliverableAccomplishment.Status.ToString();
            this.ByWhen = pgsDeliverableAccomplishment.PgsDeliverable?.ByWhen;
        }

        public override PgsDeliverableAccomplishment ToEntity()
        {
            return new PgsDeliverableAccomplishment
            {
                Id = Id,
                PgsDeliverableId = PgsDeliverableId,
                Status = Status,
                PostingDate = PostingDate,
                UserId = UserId,
                PercentAccomplished = PercentAccomplished,
                Remarks = Remarks,
                AuditorRemarks = AuditorRemarks,
                AttachmentPath = AttachmentPath,
            };
        }
    }
}
