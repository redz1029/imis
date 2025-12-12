using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public class KraRoadMapDeliverableDto : BaseDto<KraRoadMapDeliverable, long>
    {
       
        public string? Description { get; set; }
        public required int Year { get; set; }

        public KraRoadMapDeliverableDto() { }
        [SetsRequiredMembers]
        public KraRoadMapDeliverableDto(KraRoadMapDeliverable kraRoadMapDeliverableDto)
        {
            this.Id = kraRoadMapDeliverableDto.Id;
            this.Description = kraRoadMapDeliverableDto.Description;
            this.Year = kraRoadMapDeliverableDto.Year;
        }
        public override KraRoadMapDeliverable ToEntity()
        {
            return new KraRoadMapDeliverable()
            {
                Id = Id,             
                Description = Description,
                Year = Year
            };
        }
    }
}
