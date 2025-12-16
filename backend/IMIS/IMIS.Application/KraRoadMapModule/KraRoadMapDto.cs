using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapModule
{
    public class KraRoadMapDto : BaseDto<KraRoadMap, long>
    {
        public int? KraId { get; set; }
        public KeyResultAreaDto? Kra { get; set; }

        public int KraRoadMapPeriodId { get; set; }
        public KraRoadMapPeriodDto? KraRoadMapPeriod { get; set; }

        public List<KraRoadMapDeliverableDto>? Deliverables { get; set; }
        public List<KraRoadMapKpiDto>? Kpis { get; set; }

        public KraRoadMapDto() { }

        [SetsRequiredMembers]
        public KraRoadMapDto(KraRoadMap entity)
        {
            this.Id = entity.Id;
            this.KraId = entity.KraId;
            this.KraRoadMapPeriodId = entity.KraRoadMapPeriodId;         
            this.Kra = entity.Kra != null ? new KeyResultAreaDto(entity.Kra) : null;
            this.KraRoadMapPeriod = entity.KraRoadMapPeriod != null ? new KraRoadMapPeriodDto(entity.KraRoadMapPeriod) : null;
            this.Deliverables = entity.Deliverables?.Select(d => new KraRoadMapDeliverableDto(d)).ToList();
            this.Kpis = entity.Kpis?.Select(k => new KraRoadMapKpiDto(k)).ToList();
        }

        public override KraRoadMap ToEntity()
        {
            return new KraRoadMap()
            {
                Id = Id,
                KraId = KraId,
                KraRoadMapPeriodId = KraRoadMapPeriodId,            
                Deliverables = Deliverables?.Select(d => d.ToEntity()).ToList(),
                Kpis = Kpis?.Select(k => k.ToEntity()).ToList(),
            };

        }      
    }
}



