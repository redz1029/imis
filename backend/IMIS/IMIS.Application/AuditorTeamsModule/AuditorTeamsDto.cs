using IMIS.Application.AuditorModule;

namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamsDto
    {
        public required int TeamId { get; set; }
        public List<AuditorDto>? Auditors { get; set; }       
        public bool IsActive { get; set; }       
    }
}
