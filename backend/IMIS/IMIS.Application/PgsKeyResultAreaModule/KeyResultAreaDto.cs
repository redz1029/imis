using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public class KeyResultAreaDto : BaseDto<KeyResultArea, int>
    {
        public string Name { get; set; }
        public string? Remarks { get; set; }

        public KeyResultAreaDto() { }

        // Entity to Dto
        //(TDto) Activator.CreateInstance(typeof(TDto), e)
        [SetsRequiredMembers]
        public KeyResultAreaDto(KeyResultArea keyResultArea)
        {
            this.Name = keyResultArea.Name;
            this.Remarks = keyResultArea.Remarks;
        }

        public override KeyResultArea ToEntity()
        {
            return new KeyResultArea() { Id = Id, Name = Name, Remarks = Remarks };
        }
    }
}
