using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapAccomplishmentModule
{
    public class KraRoadmapAccomplishmentDto : BaseDto<KraRoadmapAccomplishment, long>
    {
        public required long KraRoadMapDeliverableId { get; set; }
        public DateTime PostingDate { get; set; }
        public required string UserId { get; set; }    
        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AttachmentPath { get; set; }      

        public KraRoadmapAccomplishmentDto() { }
        [SetsRequiredMembers]
        public KraRoadmapAccomplishmentDto(KraRoadmapAccomplishment kraRoadmapAccomplishment)
        {
            this.Id = kraRoadmapAccomplishment.Id;
            this.KraRoadMapDeliverableId = kraRoadmapAccomplishment.KraRoadMapDeliverableId;
            this.PostingDate = kraRoadmapAccomplishment.PostingDate;
            this.UserId = kraRoadmapAccomplishment.UserId;
            this.PercentAccomplished = kraRoadmapAccomplishment.PercentAccomplished;
            this.Remarks = kraRoadmapAccomplishment?.Remarks;         
            this.AttachmentPath = kraRoadmapAccomplishment!.AttachmentPath;
        }

        public override KraRoadmapAccomplishment ToEntity()
        {
            return new KraRoadmapAccomplishment
            {
                Id = Id,
                KraRoadMapDeliverableId = KraRoadMapDeliverableId,
                PostingDate = PostingDate,
                UserId = UserId,
                PercentAccomplished = PercentAccomplished,
                Remarks = Remarks,           
                AttachmentPath = AttachmentPath,
            };
        }
    }
}
