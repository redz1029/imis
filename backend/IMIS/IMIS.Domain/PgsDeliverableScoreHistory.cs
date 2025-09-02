using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsDeliverableScoreHistory : Entity<long>
    {
        public long PgsDeliverableId { get; set; }
        public DateTime Date { get; set; }
        public required PgsStatus Status { get; set; }
        public string? Remarks { get; set; }
        public double Score { get; set; }
    }
}
