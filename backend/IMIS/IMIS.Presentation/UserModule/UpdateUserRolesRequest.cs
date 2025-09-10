namespace IMIS.Presentation.UserModule
{
    public class UpdateUserRolesRequest
    {
        public string? UserId { get; set; }
        public List<RoleDto>? Roles { get; set; }
    }
}
