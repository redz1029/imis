using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.PgsKraModule
{
    public class KraDto : BaseDto<Kra, int>
    {
        public string Name { get; set; }
        public string? Remarks { get; set; }

        public override Kra ToEntity()
        {            
            return new Kra() { Id = Id, Name = Name, Remarks = Remarks };
        }
    }
}
