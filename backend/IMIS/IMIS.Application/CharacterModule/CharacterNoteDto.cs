using Base.Primitives;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.CharacterModule
{
    public class CharacterNoteDto : BaseDto<CharacterNote, long>
    {
        public required string Note { get; set; }
        public required long CharacterId { get; set; }

        public CharacterNoteDto() { }
        [SetsRequiredMembers]
        public CharacterNoteDto(CharacterNote entity)
        {
            Id = entity.Id;
            Note = entity.Note;
            CharacterId = entity.CharacterId;
        }

        public override CharacterNote ToEntity()
        {
            return new CharacterNote
            {
                Id = Id,
                Note = Note,
                CharacterId = CharacterId
            };
        }
    }
}
