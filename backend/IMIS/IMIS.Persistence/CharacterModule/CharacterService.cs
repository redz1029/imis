using Base.Abstractions;
using Base.Pagination;
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
            var CharacterDto = await _characterRepository.GetAll(cancellationToken).ConfigureAwait(false);
            if (CharacterDto == null)
                return null;

            return CharacterDto.Select(o => new CharacterDto(o)).ToList();
        }

        public async Task<CharacterDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var CharacterDto = await _characterRepository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return CharacterDto != null ? new CharacterDto(CharacterDto) : null;
        }

        public async Task<List<CharacterDto>?> FilterByName(string name, int CharacterNoOfResults, CancellationToken cancellationToken)
        {
            var Character = await _characterRepository.FilterByName(name, CharacterNoOfResults, cancellationToken).ConfigureAwait(false);
            return Character != null && Character.Count() > 0 ? Character.Select(a => new CharacterDto(a)).ToList() : null;
        }
        public async Task<DtoPageList<CharacterDto, Character, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var Character = await _characterRepository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (Character.TotalCount == 0)
                return null;
            return DtoPageList<CharacterDto, Character, long>.Create(Character.Items, page, pageSize, Character.TotalCount);
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
