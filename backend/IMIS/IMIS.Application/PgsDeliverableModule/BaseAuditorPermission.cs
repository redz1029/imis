using Base.Auths.Permissions;

namespace IMIS.Application.PgsDeliverableModule
{
    public abstract class BaseAuditorPermission : BasePermission
    {
        // Permissions dynamically generated based on the module name    
        public string View => $"View{ModuleName}";
        public string Score => $"Score{ModuleName}";
    }
}