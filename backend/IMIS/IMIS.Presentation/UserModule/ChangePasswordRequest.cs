namespace IMIS.Presentation.UserModule
{
   public class ChangePasswordRequest()
   {   
        public required string Username { get; set; }
        public required string CurrentPassword { get; set; }
        public required string NewPassword { get; set; }
   }
}
