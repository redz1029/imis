using Base.Primitives;

namespace IMIS.Domain
{
    public class PolicyAndProcedureSectionNumbering : Entity<int>
    {
        public int? Numbering { get; set; }
        public string? Sequence { get; set; }
        public bool? IsFlowChart { get; set; }
    }
}
