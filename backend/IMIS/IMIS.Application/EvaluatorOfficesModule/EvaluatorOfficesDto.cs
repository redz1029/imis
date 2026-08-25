using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.EvaluatorOfficesModule
{
    public class EvaluatorOfficesDto : BaseDto<EvaluatorOffices, int>
    {
        public string? UserId { get; set; }
        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }  

        public EvaluatorOfficesDto() { }

        [SetsRequiredMembers]
        public EvaluatorOfficesDto(EvaluatorOffices entity)
        {
            this.Id = entity.Id;
            this.UserId = entity.UserId;
            this.OfficeId = entity.OfficeId;
            this.OfficeName = entity.Office?.Name;  
        }

        public override EvaluatorOffices ToEntity()
        {
            return new EvaluatorOffices()
            {
                Id = Id,
                UserId = UserId,
                OfficeId = OfficeId,
            };
        }
    }
}
