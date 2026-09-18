namespace IMIS.Presentation.UserModule
{
    public class UserLockoutDto
    {
        public bool LockoutEnabled { get; set; }
        public DateTimeOffset? LockoutEnd { get; set; }
    }
}
