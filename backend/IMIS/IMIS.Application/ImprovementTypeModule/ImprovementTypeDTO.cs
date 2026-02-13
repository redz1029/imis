using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;


namespace IMIS.Application.ImprovementTypeModule
{
    public class ImprovementTypeDTO : BaseDto<ImprovementType, int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }

        public ImprovementTypeDTO() { }
        [SetsRequiredMembers]
        public ImprovementTypeDTO(ImprovementType improvementType)
        {
            this.Id = improvementType.Id;
            this.Name = improvementType.Name;
            this.IsActive = improvementType.IsActive;
        }
        public override ImprovementType ToEntity()
        {
            return new ImprovementType() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}

