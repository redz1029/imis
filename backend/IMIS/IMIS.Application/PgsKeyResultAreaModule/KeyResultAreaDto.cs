using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public class KeyResultAreaDto : BaseDto<KeyResultArea, int>
    {
        public string Name { get; set; }
        public string? Remarks { get; set; }

        public override KeyResultArea ToEntity()
        {            
            return new KeyResultArea() { Id = Id, Name = Name, Remarks = Remarks };
        }
    }
}
