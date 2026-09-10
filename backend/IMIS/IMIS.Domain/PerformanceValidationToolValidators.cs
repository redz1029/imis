using Base.Primitives;

namespace IMIS.Domain
{
    public class PerformanceValidationToolValidators : Entity<long>
    {
        public long PerformanceValidationToolId { get; set; }
        public int EvaluatorId { get; set; }
        public EvaluatorOffices? Evaluator { get; set; }
        public DateTime PostingDate { get; set; }
    }
}
