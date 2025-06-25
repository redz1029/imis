using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.OfficeTypeModule
{
    public class OfficeTypeDto : BaseDto<OfficeType, int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }

        public OfficeTypeDto() { }
        [SetsRequiredMembers]
        public OfficeTypeDto(OfficeType officeType)
        {
            this.Id = officeType.Id;
            this.Name = officeType.Name;
            this.IsActive = officeType.IsActive;
        }
        public override OfficeType ToEntity()
        {
            return new OfficeType() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
