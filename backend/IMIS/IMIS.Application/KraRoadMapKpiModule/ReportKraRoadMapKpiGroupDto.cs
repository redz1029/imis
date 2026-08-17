namespace IMIS.Application.KraRoadMapKpiModule
{
    public class ReportKraRoadMapKpiGroupDto
    {
        public string? KpiDescription { get; set; }
        public string? SequenceCode { get; set; }
        public List<KraRoadMapKpiDto> Items { get; set; } = new();

        public int? Year1 { get; set; }
        public int? Year2 { get; set; }
        public int? Year3 { get; set; }
        public int? Year4 { get; set; }
        public int? Year5 { get; set; }
        public int? Year6 { get; set; }

        // ---------------- Target per year ----------------
        public string? Year1Target => Items.FirstOrDefault(i => i.Year == Year1)?.Target;
        public string? Year2Target => Items.FirstOrDefault(i => i.Year == Year2)?.Target;
        public string? Year3Target => Items.FirstOrDefault(i => i.Year == Year3)?.Target;
        public string? Year4Target => Items.FirstOrDefault(i => i.Year == Year4)?.Target;
        public string? Year5Target => Items.FirstOrDefault(i => i.Year == Year5)?.Target;
        public string? Year6Target => Items.FirstOrDefault(i => i.Year == Year6)?.Target;
      
        public ReportKraRoadMapKpiGroupDto(List<KraRoadMapKpiDto> items, List<int?>? allYears)
        {
            Items = items;
            KpiDescription = items.FirstOrDefault()?.KpiDescription;
            SequenceCode = items.FirstOrDefault(i => !string.IsNullOrEmpty(i.SequenceCode))?.SequenceCode;

            Year1 = allYears?.ElementAtOrDefault(0);
            Year2 = allYears?.ElementAtOrDefault(1);
            Year3 = allYears?.ElementAtOrDefault(2);
            Year4 = allYears?.ElementAtOrDefault(3);
            Year5 = allYears?.ElementAtOrDefault(4);
            Year6 = allYears?.ElementAtOrDefault(5);
        }
    }
}