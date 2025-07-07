using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;

namespace IMIS.Application.OfficeModule
{
    public class OfficeDto : BaseDto<Office, int>
    {
        public string? Name { get; set; }
        public bool IsActive { get; set; }
        public int OfficeTypeId { get; set; }       
        public int? ParentOfficeId { get; set; }
        public List<AuditorDto>? Auditors { get; set; }

        public OfficeDto() { }

        [SetsRequiredMembers]
        public OfficeDto(Office office)
        {
            this.Id = office.Id;
            this.Name = office.Name;
            this.IsActive = office.IsActive;
            this.OfficeTypeId = office.OfficeTypeId;          
            this.ParentOfficeId = office.ParentOfficeId;
            this.IsDeleted = office.IsDeleted;
            this.RowVersion = office.RowVersion;
        }

        public override Office ToEntity()
        {
            return new Office()
            {
                Id = this.Id,
                Name = this.Name!,
                IsActive = this.IsActive,
                OfficeTypeId = this.OfficeTypeId,
                ParentOfficeId = this.ParentOfficeId
            };
        }
    }
}
