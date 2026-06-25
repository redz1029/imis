using Base.Auths.Permissions;

namespace IMIS.Application.PerformanceValidationToolSignatoryTemplateModule
{
    public class PerformanceValidationToolSignatoryTemplatePermission : BaseOperationPermission
    {
        public override string ModuleName => "PerformanceValidationToolSignatoryTemplate";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }    
}
