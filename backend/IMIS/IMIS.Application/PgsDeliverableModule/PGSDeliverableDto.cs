using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public class PGSDeliverableDto : BaseDto<PgsDeliverable, long>
    {
        public KeyResultAreaDto? Kra { get; set; }
        public required bool IsDirect { get; set; }
        public required string DeliverableName { get; set; }
        public required DateTime ByWhen { get; set; }
        public required double PercentDeliverables { get; set; }
        public required PgsStatus Status { get; set; }
        public string? Remarks { get; set; }
        public override PgsDeliverable ToEntity()
        {
            return new PgsDeliverable()
            {
                Id = Id,
                IsDirect = IsDirect,
                DeliverableName = DeliverableName,
                ByWhen = ByWhen,
                PercentDeliverables = PercentDeliverables,
                Status = Status,
                Kra = Kra?.ToEntity(),
                Remarks = Remarks
            };
        }
    }
}
