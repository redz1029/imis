namespace IMIS.Presentation.UserModule
{
    public class RolePermissionUpdateModel
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public List<PermissionUpdateModel> Permissions { get; set; } = new();
    }
}
