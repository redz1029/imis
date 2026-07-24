using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapHistoryModule
{
    public class KraRoadmapHistoryDto : BaseDto<KraRoadmapHistory, long>
    {
        public string? KraDescription { get; set; }
        public int? Year { get; set; }
        public string? DeliverableDescription { get; set; }
        public long KraRoadMapId { get; set; }
        public string? KraRoadmapName { get; set; }
        public DateTime PostingDate { get; set; }
        public required string UserId { get; set; }
        public string? UserFullName { get; set; }

        public KraRoadmapHistoryDto() { }
        [SetsRequiredMembers]
        public KraRoadmapHistoryDto(KraRoadmapHistory KraRoadmapHistoryDto)
        {
            this.Id = KraRoadmapHistoryDto.Id;
            this.KraDescription = KraRoadmapHistoryDto.KraDescription;
            this.Year = KraRoadmapHistoryDto.Year;
            this.DeliverableDescription = KraRoadmapHistoryDto.DeliverableDescription;
            this.KraRoadMapId = KraRoadmapHistoryDto.KraRoadMapId;
            this.KraRoadmapName = KraRoadmapHistoryDto.KraRoadMap?.Kra?.Name;
            this.PostingDate = KraRoadmapHistoryDto!.PostingDate;
            this.UserId  = KraRoadmapHistoryDto.UserId;
            this.UserFullName = KraRoadmapHistoryDto.User == null ? null : $"{KraRoadmapHistoryDto.User.Prefix} {KraRoadmapHistoryDto.User.FirstName} {KraRoadmapHistoryDto.User.MiddleName} {KraRoadmapHistoryDto.User.LastName}".Replace("  ", " ").Trim();
        }
        public override KraRoadmapHistory ToEntity()
        {
            return new KraRoadmapHistory()
            {
                Id = Id,
                KraDescription = KraDescription,
                Year = Year,
                DeliverableDescription = DeliverableDescription,
                KraRoadMapId = KraRoadMapId,
                PostingDate = PostingDate,
                UserId = UserId,    
            };
        }     
    }
}
