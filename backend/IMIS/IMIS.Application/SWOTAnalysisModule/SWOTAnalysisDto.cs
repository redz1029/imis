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
        public string? DepartmentName { get; set; }

        public string? ObjectiveStatement { get; set; }

        public string? DepartmentChairUserId { get; set; }
        public string? DepartmentChairUserFullName { get; set; }

        public string? QMRUserId { get; set; }
        public string? QMRUserFullName { get; set; }

        public string? ServiceHeadUserId { get; set; }
        public string? ServiceHeadUserFullName { get; set; }

        public DateTime? PostingDate { get; set; }

        public List<SWOTAnalysisSWDeliverablesDto>? SWOTAnalysisSWDeliverables { get; set; }
        public List<SWOTAnalysisOTDeliverablesDto>? SWOTAnalysisOTDeliverables { get; set; }

        public SWOTAnalysisDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisDto(SWOTAnalysis swotAnalysis)
        {
            this.Id = swotAnalysis.Id;

            this.DepartmentId = swotAnalysis.DepartmentId;
            this.DepartmentName = swotAnalysis.Department?.Name;

            this.ObjectiveStatement = swotAnalysis.ObjectiveStatement;

            this.DepartmentChairUserId = swotAnalysis.DepartmentChairUserId;
            this.DepartmentChairUserFullName = BuildFullName(swotAnalysis.DepartmentUser);

            this.QMRUserId = swotAnalysis.QMRUserId;
            this.QMRUserFullName = BuildFullName(swotAnalysis.QMRUser);

            this.ServiceHeadUserId = swotAnalysis.ServiceHeadUserId;
            this.ServiceHeadUserFullName = BuildFullName(swotAnalysis.ServiceHeadUser);

            this.PostingDate = swotAnalysis.PostingDate;

            this.SWOTAnalysisSWDeliverables = swotAnalysis.SWOTAnalysisSWDeliverables?
                .Select(d => new SWOTAnalysisSWDeliverablesDto(d)).ToList();
            this.SWOTAnalysisOTDeliverables = swotAnalysis.SWOTAnalysisOTDeliverables?
                .Select(d => new SWOTAnalysisOTDeliverablesDto(d)).ToList();
        }

        private static string? BuildFullName(User? user)
        {
            if (user == null) return null;

            return string.Join(" ", new[]
            {
                user.Prefix,
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
            }.Where(s => !string.IsNullOrWhiteSpace(s)));
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