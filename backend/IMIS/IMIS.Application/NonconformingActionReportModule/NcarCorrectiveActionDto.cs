using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.NonconformingActionReportModule
{
    public class NcarCorrectiveActionDto : BaseDto<NcarCorrectiveAction, long>
    {
        public required long NonconformingActionReportId { get; set; }
        public required string ActionDescription { get; set; }
        public int OrderNumber { get; set; }

        public NcarCorrectiveActionDto() { }

        [SetsRequiredMembers]
        public NcarCorrectiveActionDto(NcarCorrectiveAction entity)
        {
            Id = entity.Id;
            NonconformingActionReportId = entity.NonconformingActionReportId;
            ActionDescription = entity.ActionDescription;
            OrderNumber = entity.OrderNumber;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override NcarCorrectiveAction ToEntity()
        {
            return new NcarCorrectiveAction
            {
                Id = Id,
                NonconformingActionReportId = NonconformingActionReportId,
                ActionDescription = ActionDescription,
                OrderNumber = OrderNumber,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}
