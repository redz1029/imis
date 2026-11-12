using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureHistoryLogList : Entity<long>
    {
        public long PolicyAndProcedureHistoryLogId { get; set; }
        public PolicyAndProcedureHistoryLog? PolicyAndProcedureHistoryLog { get; set; }
        public string? DocumentCode { get; set; }
        public string? PageNo { get; set; }
        public string? Revision { get; set; }
        public DateTime? Date { get; set; }
        public string? Reasons { get; set; }
    }
}
