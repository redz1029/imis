using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.SWOTAnalysisModule
{
    public class SWOTAnalysisDto : BaseDto<SWOTAnalysis, int>
    {
        public required string UserId { get; set; }
        public string? Strengths { get; set; }
        public string? Weaknesses { get; set; }
        public string? Opportunities { get; set; }
        public string? Threats { get; set; }
        public string? LongTermDepartmentStrategicPlan { get; set; }
        public string? ImmediateNeedsToAchieveVision { get; set; }
        public string? DepartmentAchievementsAndBestPractices { get; set; }
        public DateTime? PostingDate { get; set; }

        public SWOTAnalysisDto() { }

        [SetsRequiredMembers]
        public SWOTAnalysisDto(SWOTAnalysis SWOTAnalysisDto)
        {
            this.Id = SWOTAnalysisDto.Id;
            this.UserId = SWOTAnalysisDto.UserId;
            this.Strengths = SWOTAnalysisDto.Strengths;
            this.Weaknesses = SWOTAnalysisDto.Weaknesses;
            this.Opportunities = SWOTAnalysisDto.Opportunities;
            this.Threats = SWOTAnalysisDto.Threats;
            this.LongTermDepartmentStrategicPlan = SWOTAnalysisDto.LongTermDepartmentStrategicPlan;
            this.ImmediateNeedsToAchieveVision = SWOTAnalysisDto.ImmediateNeedsToAchieveVision;
            this.DepartmentAchievementsAndBestPractices = SWOTAnalysisDto.DepartmentAchievementsAndBestPractices;
            this.PostingDate = SWOTAnalysisDto.PostingDate;
        }

        public override SWOTAnalysis ToEntity()
        {
            return new SWOTAnalysis() 
            {
                Id = Id,
                UserId = UserId,
                Strengths = Strengths,
                Weaknesses = Weaknesses,
                Opportunities = Opportunities,
                Threats = Threats,
                PostingDate = PostingDate,
                LongTermDepartmentStrategicPlan = LongTermDepartmentStrategicPlan,
                ImmediateNeedsToAchieveVision = ImmediateNeedsToAchieveVision,
                DepartmentAchievementsAndBestPractices = DepartmentAchievementsAndBestPractices 
            };
        }
    }
}
