using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaDeliverableDto : BaseDto<StrategicChangeAgendaDeliverable, long>
    {
        public string? Area { get; set; }
        public int? Year { get; set; }

        public StrategicChangeAgendaDeliverableDto() { }

        [SetsRequiredMembers]
        public StrategicChangeAgendaDeliverableDto(StrategicChangeAgendaDeliverable entity)
        {
            this.Id = entity.Id;
            this.Year  = entity.Year;
            this.Area = entity.Area;
        }
    
        public override StrategicChangeAgendaDeliverable ToEntity()
        { 
            return new StrategicChangeAgendaDeliverable()
            {
                Id = Id,
                Year = Year,
                Area = Area,
            };
        }
    }
}
