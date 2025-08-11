using Base.Primitives;
using IMIS.Application.PgsDeliverableScoreHistoryModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.PgsModule
{
    public class PGSDeliverableDto : BaseDto<PgsDeliverable, long>
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

        public string? DisapprovalRemarks { get; set; }
        public bool IsDisapproved { get; set; }

        public long PerfomanceGovernanceSystemId { get; set; }

        public List<PgsDeliverableScoreHistoryDto>? PgsDeliverableScoreHistory { get; set; }
        public PGSDeliverableDto() {}

        [SetsRequiredMembers]
        public PGSDeliverableDto(PgsDeliverable pgsDeliverable)
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
        
            this.PgsDeliverableScoreHistory = pgsDeliverable.PgsDeliverableScoreHistory?.Select(s => new PgsDeliverableScoreHistoryDto
            {
                Id = s.Id,
                PgsDeliverableId = s.PgsDeliverableId,
                Date = s.Date,
                Score = s.Score,              
            }).ToList();

            this.IsDeleted = pgsDeliverable.IsDeleted;
            this.RowVersion = pgsDeliverable.RowVersion;

            this.DisapprovalRemarks = pgsDeliverable.DisapprovalRemarks;
            this.IsDisapproved = pgsDeliverable.IsDisapproved;

            this.PerfomanceGovernanceSystemId = pgsDeliverable.PerfomanceGovernanceSystemId;
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
                PgsDeliverableScoreHistory = PgsDeliverableScoreHistory?.Select(d => d.ToEntity()).ToList(),
                Remarks = Remarks,
                DisapprovalRemarks = DisapprovalRemarks,
                IsDisapproved = IsDisapproved,
                PerfomanceGovernanceSystemId = PerfomanceGovernanceSystemId

            };
        }
    }
}
