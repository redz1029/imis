using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.NonconformingActionReportModule
{
    public class NcarRootCauseDto : BaseDto<NcarRootCause, long>
    {
        public required long NonconformingActionReportId { get; set; }
        public required string CauseDescription { get; set; }
        public int OrderNumber { get; set; }

        public NcarRootCauseDto() { }

        [SetsRequiredMembers]
        public NcarRootCauseDto(NcarRootCause entity)
        {
            Id = entity.Id;
            NonconformingActionReportId = entity.NonconformingActionReportId;
            CauseDescription = entity.CauseDescription;
            OrderNumber = entity.OrderNumber;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override NcarRootCause ToEntity()
        {
            return new NcarRootCause
            {
                Id = Id,
                NonconformingActionReportId = NonconformingActionReportId,
                CauseDescription = CauseDescription,
                OrderNumber = OrderNumber,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}
