using System.ComponentModel.DataAnnotations.Schema;
using Base.Primitives;

namespace IMIS.Domain
{
    public class SWOTAnalysis : Entity<long>
    {
        public int? DepartmentId { get; set; }
        [ForeignKey(nameof(DepartmentId))]
        public virtual Office? Department { get; set; }
        public string? ObjectiveStatement { get; set; }
       
        public List<SWOTAnalysisSWDeliverables>? SWOTAnalysisSWDeliverables { get; set; }
        public List<SWOTAnalysisOTDeliverables>? SWOTAnalysisOTDeliverables { get; set; }

        public  string? DepartmentChairUserId { get; set; }
        [ForeignKey(nameof(DepartmentChairUserId))]
        public virtual User? DepartmentUser { get; set; }
        public string? QMRUserId { get; set; }
        [ForeignKey(nameof(QMRUserId))]
        public virtual User? QMRUser { get; set; }
        public string? ServiceHeadUserId { get; set; }
        [ForeignKey(nameof(ServiceHeadUserId))]
        public virtual User? ServiceHeadUser { get; set; }  
        public DateTime? PostingDate { get; set; }
    }
}
