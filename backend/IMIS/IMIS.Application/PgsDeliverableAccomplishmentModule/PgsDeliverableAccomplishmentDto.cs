using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentDto : BaseDto<PgsDeliverableAccomplishment, long>
    {
        public required long PgsDeliverableId { get; set; }
        public DateTime PostingDate { get; set; }
        public required string UserId { get; set; }
        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }       
        public string? AttachmentPath { get; set; }
       
        public PgsDeliverableAccomplishmentDto() { }
        [SetsRequiredMembers]
        public PgsDeliverableAccomplishmentDto(PgsDeliverableAccomplishment pgsDeliverableAccomplishment)
        {
            this.Id = pgsDeliverableAccomplishment.Id;
            this.PgsDeliverableId = pgsDeliverableAccomplishment.PgsDeliverableId;
            this.PostingDate = pgsDeliverableAccomplishment.PostingDate;
            this.UserId = pgsDeliverableAccomplishment.UserId;
            this.PercentAccomplished = pgsDeliverableAccomplishment.PercentAccomplished;
            this.Remarks = pgsDeliverableAccomplishment?.Remarks;
            this.AttachmentPath = pgsDeliverableAccomplishment!.AttachmentPath;
        }

        public override PgsDeliverableAccomplishment ToEntity()
        {
            return new PgsDeliverableAccomplishment
            {
                Id = Id,
                PgsDeliverableId = PgsDeliverableId,
                PostingDate = PostingDate,
                UserId = UserId,
                PercentAccomplished = PercentAccomplished,
                Remarks = Remarks,
                AttachmentPath = AttachmentPath,
               
            };

        }    
    }
}
