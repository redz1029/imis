namespace IMIS.Application.ISATModule
{
    public class ISATEmployeeProfileDto 
    {
        public required string UserId { get; set; }
        public string? EmployeeName { get; set; }
        public string? Position { get; set; }

        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }

        public string? SupervisorUserId { get; set; }
        public string? SupervisorName { get; set; }

        public int? ParentOfficeId { get; set; }
        public string? ParentOfficeName { get; set; }
    }
}
