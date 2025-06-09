using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableModule
{
    public class ReportPGSDeliverableDto : BaseDto<PgsDeliverable, long>
    {
        public int? KraId { get; set; }
        public KeyResultAreaDto? Kra { get; set; }
        public string? KraDescription { get; set; }
        public required bool IsDirect { get; set; }
        public required string DeliverableName { get; set; }
        public required DateTime ByWhen { get; set; }
        public required double PercentDeliverables { get; set; }
        public required PgsStatus Status { get; set; }
        public string? Remarks { get; set; }
        public string? KraName => Kra?.Name;

        public ReportPGSDeliverableDto() { }

        [SetsRequiredMembers]
        public ReportPGSDeliverableDto(PgsDeliverable pgsDeliverable)
        {
            this.Id = pgsDeliverable.Id;
            this.KraId = pgsDeliverable.KraId;
            this.KraDescription = pgsDeliverable.KraDescription;
            this.IsDirect = pgsDeliverable.IsDirect;
            this.DeliverableName = pgsDeliverable.DeliverableName;
            this.ByWhen = pgsDeliverable.ByWhen;
            this.PercentDeliverables = pgsDeliverable.PercentDeliverables;
            this.Status = pgsDeliverable.Status;
            this.Remarks = pgsDeliverable.Remarks;

            if (pgsDeliverable.Kra != null)
            {
                this.Kra = new KeyResultAreaDto(pgsDeliverable.Kra);
            }
        }

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
                KraId = KraId,
                KraDescription = KraDescription,
                Kra = Kra?.ToEntity(),
                Remarks = Remarks
            };
        }
    }
}
