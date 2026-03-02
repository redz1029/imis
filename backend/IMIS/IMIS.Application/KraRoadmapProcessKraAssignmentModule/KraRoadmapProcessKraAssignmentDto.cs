using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadmapProcessKraAssignmentModule
{
    public class KraRoadmapProcessKraAssignmentDto : BaseDto<KraRoadmapProcessKraAssignment, int>
    {
        public required int KraId { get; set; }
        public required int ProcessId { get; set; }

        public KraRoadmapProcessKraAssignmentDto() { }
        [SetsRequiredMembers]
        public KraRoadmapProcessKraAssignmentDto(KraRoadmapProcessKraAssignment kraRoadmapProcessKraAssignment)
        {
            this.Id = kraRoadmapProcessKraAssignment.Id;
            this.KraId = kraRoadmapProcessKraAssignment.KraId;
            this.ProcessId = kraRoadmapProcessKraAssignment.ProcessId;
        }
        public override KraRoadmapProcessKraAssignment ToEntity()
        {
            return new KraRoadmapProcessKraAssignment()
            {
                Id = Id,
                KraId  = KraId,
                ProcessId = ProcessId
            };
        }
    }
}
