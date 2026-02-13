using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;

namespace IMIS.Application.TeamModule
{
    public class TeamDto : BaseDto<Team, int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
        public List<AuditorDto>? Auditors { get; set; }
        public OrganizationImprovementType ImprovementType { get; set; }
        public TeamDto() { }     
        [SetsRequiredMembers]
        public TeamDto(Team team)
        {
            this.Id = team.Id;
            this.Name = team.Name;
            this.IsActive = team.IsActive;
            this.ImprovementType = team.ImprovementType;
            this.Auditors = team.AuditorTeams?.Select(a => new AuditorDto()
            {
                Id = a.AuditorId ?? 0,
                IsActive = a.Auditor!.IsActive,
                UserId = a.Auditor!.UserId
                
                
            }).ToList();
        }
        public override Team ToEntity()
        {
            return new Team()
            {
                Id = Id,
                IsActive = IsActive,
                Name  = Name,
                ImprovementType = ImprovementType
            };
        }
    }
}
