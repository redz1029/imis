using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.KraRoadMapRoleAssignmentModule
{
    public class KraRoadMapRoleDto : BaseDto<KraRoadMapRole, int>
    {
        public int? KraId { get; set; }      
        public string? RoleId { get; set; }
        public string? KraName { get; set; }
        public string? StrategicObjectives { get; set; }

        public KraRoadMapRoleDto() { }

        [SetsRequiredMembers]
        public KraRoadMapRoleDto(KraRoadMapRole kraRoadMapRole)
        {
            this.Id = kraRoadMapRole.Id;
            this.KraId = kraRoadMapRole.KraId;
            this.RoleId = kraRoadMapRole.RoleId;
            this.KraName = kraRoadMapRole.Kra?.Name;
            this.StrategicObjectives = kraRoadMapRole.Kra?.StrategicObjective;
        }

        public override KraRoadMapRole ToEntity()
        {
            return new KraRoadMapRole()
            {
                Id = this.Id,
                KraId = this.KraId!,
                RoleId = this.RoleId,              
            };
        }
    }
}
