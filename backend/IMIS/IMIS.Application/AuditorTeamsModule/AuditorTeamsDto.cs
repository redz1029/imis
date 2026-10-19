using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;

namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamsDto : BaseDto<AuditorTeams, int>
    {
        public required int TeamId { get; set; }
        public List<AuditorDto>? Auditors { get; set; }       
        public bool IsActive { get; set; }
        public OrganizationImprovementType ImprovementType { get; set; }

        public AuditorTeamsDto() { }
        [SetsRequiredMembers]
        public AuditorTeamsDto(AuditorTeams auditorteam)
        {
            this.Id = auditorteam.Id;
            this.TeamId = auditorteam.TeamId;         
            this.IsActive = auditorteam.IsActive;          
            if (auditorteam.Auditor != null)
            {
                Auditors = new List<AuditorDto>
                {
                    new AuditorDto(auditorteam.Auditor)
                };
            }
        }
        public override AuditorTeams ToEntity()
        {
            return new AuditorTeams()
            {
                Id = Id,
                TeamId = TeamId,              
                IsActive = IsActive,
                ImprovementType = ImprovementType,
                Auditor = Auditors?.FirstOrDefault()?.ToEntity()
            };
        }
    }
}
