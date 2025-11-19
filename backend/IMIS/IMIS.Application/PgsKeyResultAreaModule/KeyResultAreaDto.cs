using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public class KeyResultAreaDto : BaseDto<KeyResultArea, int>
    {
        public string Name { get; set; }
        public string? Remarks { get; set; }
        public string? StrategicObjective { get; set; }
        public KeyResultAreaDto() { }
        [SetsRequiredMembers]
        public KeyResultAreaDto(KeyResultArea keyResultArea)
        {
            this.Id = keyResultArea.Id;
            this.Name = keyResultArea.Name;
            this.Remarks = keyResultArea.Remarks;
            this.IsDeleted = keyResultArea.IsDeleted;
            this.RowVersion = keyResultArea.RowVersion;
            this.StrategicObjective = keyResultArea?.StrategicObjective;
        }

        public override KeyResultArea ToEntity()
        {
            return new KeyResultArea() { Id = Id, Name = Name, Remarks = Remarks!, StrategicObjective = StrategicObjective};
        }
    }
}
