//using Base.Primitives;
//using IMIS.Domain;

//namespace IMIS.Application.OfficeModule
//{
//    public class OfficeDto : BaseDto<Office, int>
//    {

//        public required string Name { get; set; }
//        public required bool IsActive { get; set; }
//        public override Office ToEntity()
//        {
//            return new Office() { Id = Id, Name = Name, IsActive = IsActive };
//        }
//    }
//}


using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;
using Microsoft.AspNetCore.Components.Forms;

namespace IMIS.Application.OfficeModule
{
    public class OfficeDto : BaseDto<Office, int>
    {
        public required string Name { get; set; }
        public required bool IsActive { get; set; }
    
 

        public override Office ToEntity()
        {
            return new Office() { Id = Id, Name = Name, IsActive = IsActive };
        }
    }
}
