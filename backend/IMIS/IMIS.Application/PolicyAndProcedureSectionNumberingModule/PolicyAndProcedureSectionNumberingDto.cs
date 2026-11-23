using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PolicyAndProcedureSectionNumberingModule
{
    public class PolicyAndProcedureSectionNumberingDto : BaseDto<PolicyAndProcedureSectionNumbering, int>
    {
        public int? Numbering { get; set; }
        public string? Sequence { get; set; }
        public bool? IsFlowChart { get; set; }
       

        public PolicyAndProcedureSectionNumberingDto() { }

        [SetsRequiredMembers]
        public PolicyAndProcedureSectionNumberingDto(PolicyAndProcedureSectionNumbering policyAndProcedure)
        {
            this.Id = policyAndProcedure.Id;
            this.Numbering = policyAndProcedure.Numbering;
            this.Sequence = policyAndProcedure.Sequence;
            this.IsFlowChart = policyAndProcedure.IsFlowChart;
            
        }

        public override PolicyAndProcedureSectionNumbering ToEntity()
        {
            return new PolicyAndProcedureSectionNumbering()
            {
                Id = Id,
                Numbering = Numbering,
                Sequence = Sequence,
                IsFlowChart = IsFlowChart,
              
            };
        }
    }
}
