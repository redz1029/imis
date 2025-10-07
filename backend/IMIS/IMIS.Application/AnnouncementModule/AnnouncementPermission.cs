using Base.Auths.Permissions;

namespace IMIS.Application.AnnouncementModule
{
    public class AnnouncementPermission : BaseOperationPermission
    {
        public override string ModuleName => "Announcement";
        public override string PermissionGroup => PermissionGrouper.Setting;
    }
}
