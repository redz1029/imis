using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysisServiceHead : Entity<long>
    {
        public int? DepartmentId { get; set; }
        [ForeignKey(nameof(DepartmentId))]
        public virtual Office? Department { get; set; }
        public string? ObjectiveStatement { get; set; }

        public List<SWOTAnalysisSWDeliverablesServiceHead>? SWOTAnalysisSWDeliverablesServiceHead { get; set; }
        public List<SWOTAnalysisOTDeliverablesServiceHead>? SWOTAnalysisOTDeliverablesServiceHead { get; set; }

        public string? DepartmentChairUserId { get; set; }
        [ForeignKey(nameof(DepartmentChairUserId))]
        public virtual User? DepartmentUser { get; set; }
     
        public string? ServiceHeadUserId { get; set; }
        [ForeignKey(nameof(ServiceHeadUserId))]
        public virtual User? ServiceHeadUser { get; set; }
        public DateTime? PostingDate { get; set; }
    }
}
