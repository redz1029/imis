using Base.Abstractions;
using Base.Primitives;
using IMIS.Application.CharacterModule;
using IMIS.Application.PgsKraModule;
using IMIS.Domain;

namespace IMIS.Persistence.CharacterModule
{
    public class CharacterService : ICharacterService
    {
        private readonly ICharacterRepository _characterRepository;
        private readonly ICharacterNoteRepository _noteRepository;
        private readonly IStrategicObjectiveRepository _objectiveRepository;

        public CharacterService(
            ICharacterRepository characterRepository,
            ICharacterNoteRepository noteRepository,
            IStrategicObjectiveRepository objectiveRepository)
        {
            _characterRepository = characterRepository ?? throw new ArgumentNullException(nameof(characterRepository));
            _noteRepository = noteRepository ?? throw new ArgumentNullException(nameof(noteRepository));
            _objectiveRepository = objectiveRepository ?? throw new ArgumentNullException(nameof(objectiveRepository));
        }

        public async Task<List<CharacterDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var keyResultAreaDto = await _characterRepository.GetAll(cancellationToken).ConfigureAwait(false);
            if (keyResultAreaDto == null)
                return null;

            return keyResultAreaDto.Select(o => new CharacterDto(o)).ToList();
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            // Character
            if (dto is CharacterDto characterDto)
            {
                var entity = characterDto.ToEntity();

                if (entity.Id == 0)
                    _characterRepository.Add(entity);
                else
                    await _characterRepository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);

                await _characterRepository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
                return;
            }

            // CharacterNote
            if (dto is CharacterNoteDto noteDto)
            {
                var note = noteDto.ToEntity();

                // Validate parent Character exists
                var parent = await _characterRepository.GetByIdAsync(note.CharacterId, cancellationToken).ConfigureAwait(false);
                if (parent == null)
                    throw new InvalidOperationException("Character not found");

                if (note.Id == 0)
                    _noteRepository.Add(note);
                else
                    await _noteRepository.UpdateAsync(note, note.Id, cancellationToken).ConfigureAwait(false);

                await _noteRepository.SaveOrUpdateAsync(note, cancellationToken).ConfigureAwait(false);
                return;
            }

            // StrategicObjective
            if (dto is StrategicObjectiveDto soDto)
            {
                var so = soDto.ToEntity();

                // Validate parent Character exists
                var parent = await _characterRepository.GetByIdAsync(so.CharacterId, cancellationToken).ConfigureAwait(false);
                if (parent == null)
                    throw new InvalidOperationException("Character not found");

                if (so.Id == 0)
                    _objectiveRepository.Add(so);
                else
                    await _objectiveRepository.UpdateAsync(so, so.Id, cancellationToken).ConfigureAwait(false);

                await _objectiveRepository.SaveOrUpdateAsync(so, cancellationToken).ConfigureAwait(false);
                return;
            }

            throw new InvalidOperationException("Unsupported DTO type for CharacterService");
        }
    }
}
