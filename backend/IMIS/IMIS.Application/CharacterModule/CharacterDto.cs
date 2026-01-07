using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.CharacterModule
{
    public class CharacterDto : BaseDto<Character, long>
    {
        public required string Name { get; set; }
        public required string Remarks { get; set; }

        public CharacterDto() { }
        [SetsRequiredMembers]
        public CharacterDto(Character entity)
        {
            Id = entity.Id;
            Name = entity.Name;
            Remarks = entity.Remarks;
        }

        public override Character ToEntity()
        {
            return new Character
            {
                Id = Id,
                Name = Name,
                Remarks = Remarks
            };
        }
    }
}

