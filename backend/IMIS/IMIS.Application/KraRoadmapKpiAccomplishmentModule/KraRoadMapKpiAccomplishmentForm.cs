using Microsoft.AspNetCore.Http;

namespace IMIS.Application.KraRoadmapKpiAccomplishmentModule
{
    public class KraRoadMapKpiAccomplishmentForm
    {
        public int KraRoadMapKpiId { get; set; }
        public DateTime PostingDate { get; set; }
        public string UserId { get; set; } = null!;
        public double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public IFormFile? File { get; set; }
    }
}
