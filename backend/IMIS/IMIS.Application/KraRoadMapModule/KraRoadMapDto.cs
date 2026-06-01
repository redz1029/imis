using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.KraRoadMapDeliverableModule;
using IMIS.Application.KraRoadMapKpiModule;
using IMIS.Application.KraRoadMapPeriodModule;
using IMIS.Application.PgsKraModule;
using IMIS.Application.RoadmapGutCheckModule;
using IMIS.Domain;

public class KraRoadMapDto : BaseDto<KraRoadMap, long>
{
    public int? KraId { get; set; }
    public KeyResultAreaDto? Kra { get; set; }

    public int KraRoadMapPeriodId { get; set; }
    public KraRoadMapPeriodDto? KraRoadMapPeriod { get; set; }

    public List<KraRoadMapDeliverableGroupDto>? Deliverables { get; set; }
    public List<KraRoadMapKpiDto>? Kpis { get; set; }

    public required string RoleId { get; set; }

    public RoadmapGutCheckDto? RoadmapGutCheck { get; set; }

    public KraRoadMapDto() { }

    [SetsRequiredMembers]
    public KraRoadMapDto(KraRoadMap entity)
    {
        Id = entity.Id;
        KraId = entity.KraId;
        KraRoadMapPeriodId = entity.KraRoadMapPeriodId;

        Kra = entity.Kra != null
            ? new KeyResultAreaDto(entity.Kra)
            : null;

        KraRoadMapPeriod = entity.KraRoadMapPeriod != null
            ? new KraRoadMapPeriodDto(entity.KraRoadMapPeriod)
            : null;

        Deliverables = entity.Deliverables?
            .Select(d => new KraRoadMapDeliverableGroupDto
            {
                Id = d.Id,
                KraDescription = d.KraDescription,
                Items = new List<KraRoadMapDeliverable> { d }
            })
            .ToList();

        Kpis = entity.Kpis?
            .Select(k => new KraRoadMapKpiDto(k))
            .ToList();

        RoleId = entity.RoleId!;

        RoadmapGutCheck = entity.RoadmapGutCheck != null
            ? new RoadmapGutCheckDto(entity.RoadmapGutCheck)
            : null;
    }

    public override KraRoadMap ToEntity()
    {
        return new KraRoadMap()
        {
            Id = Id,
            KraId = KraId,
            KraRoadMapPeriodId = KraRoadMapPeriodId,

            Deliverables = Deliverables?
                .SelectMany(g => g.Items ?? new List<KraRoadMapDeliverable>())
                .Select(d =>
                {
                    d.IsDeleted = false;
                    return d;
                })
                .ToList(),

            Kpis = Kpis?.Select(k => k.ToEntity()).ToList(),

            RoleId = RoleId,

            RoadmapGutCheck = RoadmapGutCheck?.ToEntity()
        };
    }
}