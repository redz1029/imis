using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureHistoryLog : Entity<long>
    {
        public long PolicyAndProcedureId { get; set; }
        public PolicyAndProcedure? PolicyAndProcedure { get; set; }
        public DateTime? Date { get; set; }
        public virtual ICollection<PolicyAndProcedureHistoryLogList> HistoryLogLists { get; set; } = new List<PolicyAndProcedureHistoryLogList>();
    }
}
