using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.CharacterModule
{
    public class StrategicObjectiveDto : BaseDto<StrategicObjective, long>
    {
        public required string Objective { get; set; }
        public required long CharacterId { get; set; }

        public StrategicObjectiveDto() { }
        [SetsRequiredMembers]
        public StrategicObjectiveDto(StrategicObjective entity)
        {
            Id = entity.Id;
            Objective = entity.Objective;
            CharacterId = entity.CharacterId;
        }

        public override StrategicObjective ToEntity()
        {
            return new StrategicObjective
            {
                Id = Id,
                Objective = Objective,
                CharacterId = CharacterId
            };
        }
    }
}
