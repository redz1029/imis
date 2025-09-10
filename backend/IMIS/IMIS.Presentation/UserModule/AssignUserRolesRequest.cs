namespace IMIS.Presentation.UserModule
{
    public class AssignUserRolesRequest
    {
        public string? UserId { get; set; }
        public List<RoleDto>? Roles { get; set; }
    }
}
