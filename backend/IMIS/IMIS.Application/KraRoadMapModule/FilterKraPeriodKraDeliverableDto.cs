namespace IMIS.Application.KraRoadMapModule
{
    public class FilterKraPeriodKraDeliverableDto
    {
        public required int Id { get; set; }
        public string? KraDescription { get; set; }
        public string? DeliverableDescription { get; set; }
        public required int Year { get; set; }
        public string? KraPeriod { get; set; }

    }
}
