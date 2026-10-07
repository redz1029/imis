namespace IMIS.Application.ISATModule
{
    public class ISATEmployeeProfileDto 
    {
        public required string UserId { get; set; }
        public string? EmployeeName { get; set; }
        public string? Position { get; set; } 
        public string? SupervisorUserId { get; set; }
        public string? SupervisorName { get; set; }
      
    }
}
