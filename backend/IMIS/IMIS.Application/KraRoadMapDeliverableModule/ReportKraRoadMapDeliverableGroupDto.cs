using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.KraRoadMapDeliverableModule
{
    public class ReportKraRoadMapDeliverableGroupDto : BaseDto<KraRoadMapDeliverable, long>
    {
        public string? KraDescription { get; set; }
        public List<KraRoadMapDeliverable> Items { get; set; } = new();
        public bool IsEnabler { get; set; }
        public int? Year1 { get; set; }
        public int? Year2 { get; set; }
        public int? Year3 { get; set; }
        public int? Year4 { get; set; }
        public int? Year5 { get; set; }

        public string? Year1Deliverable { get; set; }
        public string? Year2Deliverable { get; set; }
        public string? Year3Deliverable { get; set; }
        public string? Year4Deliverable { get; set; }
        public string? Year5Deliverable { get; set; }

        [SetsRequiredMembers]
        public ReportKraRoadMapDeliverableGroupDto(List<KraRoadMapDeliverable> items, List<int>? allYears)
        {
            if (items == null || items.Count == 0)
                return;

            Items = items.OrderBy(x => x.Year).ToList();
            KraDescription = items[0].KraDescription;
            Id = items[0].Id;

            IsEnabler = Items.Any(x => x.IsEnabler);         

            Year1 = allYears?.ElementAtOrDefault(0);
            Year2 = allYears?.ElementAtOrDefault(1);
            Year3 = allYears?.ElementAtOrDefault(2);
            Year4 = allYears?.ElementAtOrDefault(3);
            Year5 = allYears?.ElementAtOrDefault(4);

            Year1Deliverable = Items.FirstOrDefault(x => x.Year == Year1)?.DeliverableDescription;
            Year2Deliverable = Items.FirstOrDefault(x => x.Year == Year2)?.DeliverableDescription;
            Year3Deliverable = Items.FirstOrDefault(x => x.Year == Year3)?.DeliverableDescription;
            Year4Deliverable = Items.FirstOrDefault(x => x.Year == Year4)?.DeliverableDescription;
            Year5Deliverable = Items.FirstOrDefault(x => x.Year == Year5)?.DeliverableDescription;
        }

        public override KraRoadMapDeliverable ToEntity() => Items.First();
    }
}
