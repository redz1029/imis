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


        public TeamDto() { }
     
        [SetsRequiredMembers]
        public TeamDto(Team team)
        {
            this.Id = team.Id;
            this.Name = team.Name;
            this.IsActive = team.IsActive;
        }
        public override Team ToEntity()
        {
            return new Team() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
