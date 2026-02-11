using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.AuditorModule
{
    public class AuditorDto : BaseDto<Auditor, int>
    {
              
        public required bool IsActive { get; set; }
        public bool IsTeamLeader { get; set; }
        public bool IsOfficeHead { get; set; }
        public required string UserId { get; set; }
        public OrganizationImprovementType ImprovementType { get; set; }

        public AuditorDto() { }
        [SetsRequiredMembers]
        public AuditorDto(Auditor auditor)
        {
            if (auditor != null)
            {
                Id = auditor.Id;
                IsActive = auditor.IsActive;
                UserId = auditor.UserId;
                
                
            }
        }
        public override Auditor ToEntity()
        {
            return new Auditor() { Id = Id, IsActive = IsActive, UserId = UserId,  };
        }
    }
}
