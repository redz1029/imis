using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.AuditorModule
{
    public class AuditorDto : BaseDto<Auditor, int>
    {
        public required string Name {  get; set; }
        public required bool IsActive { get; set; }
        public bool IsTeamLeader { get; set; }
        public bool IsOfficeHead { get; set; }

        public AuditorDto() { }

        [SetsRequiredMembers]
        public AuditorDto(Auditor auditor)
        {
            if(auditor != null)
            {
                Id = auditor.Id;
                Name = auditor.Name;
                IsActive = auditor.IsActive;
            }
        }

        public override Auditor ToEntity()
        {
            return new Auditor() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
