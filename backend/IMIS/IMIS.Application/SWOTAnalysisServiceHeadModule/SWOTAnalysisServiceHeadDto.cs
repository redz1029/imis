using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.SWOTAnalysisOTDeliverablesServiceHeadModule;
using IMIS.Application.SWOTAnalysisSWDeliverablesServiceHeadModule;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisServiceHeadModule
{
    public class SWOTAnalysisServiceHeadDto : BaseDto<SWOTAnalysisServiceHead, long>
    {
        public int? DepartmentId { get; set; }
        public string? DepartmentName { get; set; }

        public string? ObjectiveStatement { get; set; }

        public string? DepartmentChairUserId { get; set; }
        public string? DepartmentChairUserFullName { get; set; }
    
        public string? ServiceHeadUserId { get; set; }
        public string? ServiceHeadUserFullName { get; set; }

        public DateTime? PostingDate { get; set; }

        public List<SWOTAnalysisSWDeliverablesServiceHeadDto>? SWOTAnalysisSWDeliverablesServiceHead { get; set; }
        public List<SWOTAnalysisOTDeliverablesServiceHeadDto>? SWOTAnalysisOTDeliverablesServiceHead { get; set; }

        public SWOTAnalysisServiceHeadDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisServiceHeadDto(SWOTAnalysisServiceHead swotAnalysis)
        {
            this.Id = swotAnalysis.Id;

            this.DepartmentId = swotAnalysis.DepartmentId;
            this.DepartmentName = swotAnalysis.Department?.Name;

            this.ObjectiveStatement = swotAnalysis.ObjectiveStatement;

            this.DepartmentChairUserId = swotAnalysis.DepartmentChairUserId;
            this.DepartmentChairUserFullName = BuildFullName(swotAnalysis.DepartmentUser);       

            this.ServiceHeadUserId = swotAnalysis.ServiceHeadUserId;
            this.ServiceHeadUserFullName = BuildFullName(swotAnalysis.ServiceHeadUser);

            this.PostingDate = swotAnalysis.PostingDate;

            this.SWOTAnalysisSWDeliverablesServiceHead = swotAnalysis.SWOTAnalysisSWDeliverablesServiceHead?
                .Select(d => new SWOTAnalysisSWDeliverablesServiceHeadDto(d)).ToList();
            this.SWOTAnalysisOTDeliverablesServiceHead = swotAnalysis.SWOTAnalysisOTDeliverablesServiceHead?
                .Select(d => new SWOTAnalysisOTDeliverablesServiceHeadDto(d)).ToList();
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

        public override SWOTAnalysisServiceHead ToEntity()
        {
            return new SWOTAnalysisServiceHead()
            {
                Id = Id,
                DepartmentId = DepartmentId,
                ObjectiveStatement = ObjectiveStatement,
                DepartmentChairUserId = DepartmentChairUserId,              
                ServiceHeadUserId = ServiceHeadUserId,
                PostingDate = PostingDate,
                SWOTAnalysisSWDeliverablesServiceHead = SWOTAnalysisSWDeliverablesServiceHead?
                    .Select(d => d.ToEntity())
                    .ToList(),
                SWOTAnalysisOTDeliverablesServiceHead = SWOTAnalysisOTDeliverablesServiceHead?
                    .Select(d => d.ToEntity())
                    .ToList()
            };
        }
    }
}
