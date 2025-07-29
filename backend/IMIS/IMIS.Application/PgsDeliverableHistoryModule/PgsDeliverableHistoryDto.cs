using System.Diagnostics;
using Base.Primitives;
using IMIS.Domain;
using VaultSharp.V1.SecretsEngines.Identity;

namespace IMIS.Application.PgsDeliverableHistoryModule
{
    public class PgsDeliverableHistoryDto :  BaseDto<PgsDeliverableHistory, long>
    {
        public long PgsId { get; set; }
        public long DeliverableId { get; set; }
        public string? DeliverableName { get; set; }
        public string? KraDescription { get; set; }
        public long? KraId { get; set; }
        public string? DisapprovalRemarks { get; set; }
        public bool IsDisapproved { get; set; }
        public  bool IsDirect { get; set; }
        public  double PercentDeliverables { get; set; }
        public  DateTime ByWhen { get; set; }
        public  PgsStatus Status { get; set; }
        public string? Remarks { get; set; }
        public string? RemovedBy { get; set; }
        public DateTime RemovedAt { get; set; } = DateTime.UtcNow;

        public PgsDeliverableHistoryDto() { }


        public PgsDeliverableHistoryDto(PgsDeliverableHistory entity)
        {
            Id = entity.Id; 
            PgsId = entity.PgsId;
            DeliverableId = entity.DeliverableId;
            DeliverableName = entity.DeliverableName;
            KraDescription = entity.KraDescription;
            KraId = entity.KraId;   
            DisapprovalRemarks = entity.DisapprovalRemarks;
            IsDisapproved = entity.IsDisapproved;
            IsDirect = entity.IsDirect;
            PercentDeliverables = entity.PercentDeliverables;
            ByWhen = entity.ByWhen;
            Status = entity.Status;
            Remarks = entity.Remarks;
            RemovedBy = entity.RemovedBy;
            RemovedAt = entity.RemovedAt;
        }

        public override PgsDeliverableHistory ToEntity()
        {
            return new PgsDeliverableHistory
            {
                Id = Id,
                PgsId = PgsId,
                DeliverableId = DeliverableId,
                DeliverableName = DeliverableName,
                KraDescription = KraDescription,
                KraId = KraId,     
                DisapprovalRemarks= DisapprovalRemarks,
                IsDisapproved= IsDisapproved,
                IsDirect = IsDirect,
                PercentDeliverables= PercentDeliverables,
                ByWhen = ByWhen,
                Status = Status,
                Remarks = Remarks,
                RemovedBy = RemovedBy,
                RemovedAt = RemovedAt,
            };
        }
    }
}
