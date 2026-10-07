using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.ISATAnnualPerformanceCommitmentsModule
{
    public class ISATAnnualPerformanceCommitmentsDto : BaseDto<ISATAnnualPerformanceCommitments, long>
    {
        public long ISATId { get; set; }
        public long? PgsDeliverableId { get; set; }
        public string? DeliverableMName { get; set; }
        public int? KraId { get; set; }
        public string? KraMName { get; set; }
        public string? Deliverable { get; set; }
        public string? Target { get; set; }
        public string? Accomplishment { get; set; }

        public ISATAnnualPerformanceCommitmentsDto()
        {
        }

        [SetsRequiredMembers]
        public ISATAnnualPerformanceCommitmentsDto(ISATAnnualPerformanceCommitments entity)
        {
            Id = entity.Id;
            ISATId = entity.ISATId;
            Deliverable = entity.Deliverable;
            Target = entity.Target;
            Accomplishment = entity.Accomplishment;
            PgsDeliverableId = entity.PgsDeliverableId;
            KraId = entity.KraId;

            if (entity.PgsDeliverable != null)
            {
                DeliverableMName = entity.PgsDeliverable.DeliverableName;

                KraId = entity.PgsDeliverable.KraId;

                if (entity.PgsDeliverable.Kra != null)
                {
                    KraMName = entity.PgsDeliverable.Kra.Name;
                }
            }
        }

        public override ISATAnnualPerformanceCommitments ToEntity()
        {
            return new ISATAnnualPerformanceCommitments
            {
                Id = Id,
                ISATId = ISATId,
                PgsDeliverableId = PgsDeliverableId,
                KraId = KraId,
                Deliverable = Deliverable,
                Target = Target,
                Accomplishment = Accomplishment
            };
        }
    }
}