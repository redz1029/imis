using Microsoft.AspNetCore.Http;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public class PgsDeliverableAccomplishmentForm
    {
        public long PgsDeliverableId { get; set; }
        public DateTime PostingDate { get; set; }
        public string UserId { get; set; } = null!;
        public double PercentAccomplished { get; set; }
        public string? Remarks { get; set; }
        public string? AuditorRemarks { get; set; }
        public IFormFile? File { get; set; }
    }
}
