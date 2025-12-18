namespace IMIS.Application.KraRoadMapModule
{
    public class KraRoadMapFilter
    {
        public long Id { get; set; }
        public int KraId { get; set; }
        public long KraRoadMapId { get; set; }
        public string? KraDescription { get; set; }
        public int Year { get; set; }
        public string? DeliverableDescription { get; set; }      
    }
}
