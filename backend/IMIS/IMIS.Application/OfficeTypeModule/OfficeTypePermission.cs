using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Base.Auths.Permissions;

namespace IMIS.Application.OfficeTypeModule
{
    public class OfficeTypePermission : BaseOperationPermission
    {
        public override string ModuleName => "OfficeType";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
