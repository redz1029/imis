using System.Text.Json.Serialization;
using Base.Primitives;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {

        [JsonPropertyName("StartDate")]
        public required DateTime StartDate { get; set; }

        [JsonPropertyName("EndDate")]
        public required DateTime EndDate { get; set; }

        [JsonPropertyName("auditTitle")]
        public required string AuditTitle { get; set; }

        [JsonPropertyName("isActive")]
        public required bool IsActive { get; set; }

        [JsonPropertyName("auditableOffices")]
        public IEnumerable<AuditableOffices>? AuditableOffices { get; set; }

        [JsonPropertyName("auditScheduleDetails")]
        public IEnumerable<AuditScheduleDetails>? AuditScheduleDetails { get; set; }
    }
}
