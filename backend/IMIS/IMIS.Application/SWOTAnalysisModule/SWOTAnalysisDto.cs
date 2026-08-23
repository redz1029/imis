using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;
using IMIS.Application.SWOTAnalysisSWDeliverablesModule;
using IMIS.Application.SWOTAnalysisOTDeliverablesModule;

namespace IMIS.Application.SWOTAnalysisModule
{
    public class SWOTAnalysisDto : BaseDto<SWOTAnalysis, long>
    {
        public int? DepartmentId { get; set; }
        public string? ObjectiveStatement { get; set; }
        public required string DepartmentChairUserId { get; set; }
        public required string QMRUserId { get; set; }
        public required string ServiceHeadUserId { get; set; }
        public DateTime? PostingDate { get; set; }

        public List<SWOTAnalysisSWDeliverablesDto>? SWOTAnalysisSWDeliverables { get; set; }
        public List<SWOTAnalysisOTDeliverablesDto>? SWOTAnalysisOTDeliverables { get; set; }

        public SWOTAnalysisDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisDto(SWOTAnalysis swotAnalysis)
        {
            this.Id = swotAnalysis.Id;
            this.DepartmentId = swotAnalysis.DepartmentId;
            this.ObjectiveStatement = swotAnalysis.ObjectiveStatement;
            this.DepartmentChairUserId = swotAnalysis.DepartmentChairUserId;
            this.QMRUserId = swotAnalysis.QMRUserId;
            this.ServiceHeadUserId = swotAnalysis.ServiceHeadUserId;
            this.PostingDate = swotAnalysis.PostingDate;

            this.SWOTAnalysisSWDeliverables = swotAnalysis.SWOTAnalysisSWDeliverables?.Select(d => new SWOTAnalysisSWDeliverablesDto(d)).ToList();
            this.SWOTAnalysisOTDeliverables = swotAnalysis.SWOTAnalysisOTDeliverables?.Select(d => new SWOTAnalysisOTDeliverablesDto(d)).ToList();
        }

        public override SWOTAnalysis ToEntity()
        {
            return new SWOTAnalysis()
            {
                Id = Id,
                DepartmentId = DepartmentId,
                ObjectiveStatement = ObjectiveStatement,
                DepartmentChairUserId = DepartmentChairUserId,
                QMRUserId = QMRUserId,
                ServiceHeadUserId = ServiceHeadUserId,
                PostingDate = PostingDate,
                SWOTAnalysisSWDeliverables = SWOTAnalysisSWDeliverables?
                    .Select(d => d.ToEntity())
                    .ToList(),
                SWOTAnalysisOTDeliverables = SWOTAnalysisOTDeliverables?
                    .Select(d => d.ToEntity())
                    .ToList()
            };
        }
    }
}