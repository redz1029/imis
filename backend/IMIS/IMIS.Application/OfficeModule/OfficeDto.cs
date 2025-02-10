using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;


namespace IMIS.Application.OfficeModule
{
    public class OfficeDto : BaseDto<Office, int>
    {
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public List<AuditorDto>? Auditors { get; set; }
        public override Office ToEntity()
        {
            return new Office() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
