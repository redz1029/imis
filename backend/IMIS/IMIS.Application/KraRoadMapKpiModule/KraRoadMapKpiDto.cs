using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapKpiModule
{
    public class KraRoadMapKpiDto : BaseDto<KraRoadMapKpi, int>
    {     
        public string? KpiDescription { get; set; }

        public KraRoadMapKpiDto() { }
        [SetsRequiredMembers]
        public KraRoadMapKpiDto(KraRoadMapKpi kraRoadMapKpiDto)
        {
            this.Id = kraRoadMapKpiDto.Id;
            this.KpiDescription = kraRoadMapKpiDto.KpiDescription;         
        }
        public override KraRoadMapKpi ToEntity()
        {
            return new KraRoadMapKpi()
            {
                Id = Id,
                KpiDescription = KpiDescription,
            };
        }
    }
}
