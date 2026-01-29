using Base.Primitives;
using Microsoft.AspNetCore.Identity;

namespace IMIS.Domain
{
    public class KraRoadMap : Entity<long>
    {
        public required int? KraId { get; set; }
        public KeyResultArea? Kra { get; set; }        
        public required int KraRoadMapPeriodId { get; set; }
        public KraRoadMapPeriod? KraRoadMapPeriod { get; set; }    
        public List<KraRoadMapDeliverable>? Deliverables { get; set; }
        public List<KraRoadMapKpi>? Kpis { get; set; }      
        public string? RoleId { get; set; }
        public IdentityRole? Role { get; set; }
    }
}
