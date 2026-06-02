using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapKpiAccomplishmentModule
{
    public class KraRoadmapKpiAccomplishmentDto : BaseDto<KraRoadmapKpiAccomplishment, long>
    {
        public required int KraRoadMapKpiId { get; set; }
        public DateTime PostingDate { get; set; }
        public required string UserId { get; set; }
        public required double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AttachmentPath { get; set; }

        public KraRoadmapKpiAccomplishmentDto() { }
        [SetsRequiredMembers]
        public KraRoadmapKpiAccomplishmentDto(KraRoadmapKpiAccomplishment kraRoadmapKpiAccomplishment)
        {
            this.Id = kraRoadmapKpiAccomplishment.Id;
            this.KraRoadMapKpiId = kraRoadmapKpiAccomplishment.KraRoadMapKpiId;
            this.PostingDate = kraRoadmapKpiAccomplishment.PostingDate;
            this.UserId = kraRoadmapKpiAccomplishment.UserId;
            this.PercentAccomplished = kraRoadmapKpiAccomplishment.PercentAccomplished;
            this.Remarks = kraRoadmapKpiAccomplishment?.Remarks;
            this.AttachmentPath = kraRoadmapKpiAccomplishment!.AttachmentPath;
        }

        public override KraRoadmapKpiAccomplishment ToEntity()
        {
            return new KraRoadmapKpiAccomplishment
            {
                Id = Id,
                KraRoadMapKpiId = KraRoadMapKpiId,
                PostingDate = PostingDate,
                UserId = UserId,
                PercentAccomplished = PercentAccomplished,
                Remarks = Remarks,
                AttachmentPath = AttachmentPath,
            };
        }
    }
}
