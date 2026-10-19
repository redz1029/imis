using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IsoStandardModule;
using IMIS.Domain;
using IMIS.Infrastructure.Auths.Roles;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.IsoStandardModule
{
    public class IsoStandardService : IIsoStandardService
    {
        private readonly IIsoStandardRepository _repository;
        private readonly ImisDbContext _dbContext;


        public IsoStandardService(IIsoStandardRepository repository, ImisDbContext dbContext)
        {
            _repository = repository;
            _dbContext = dbContext;
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var standard = await _repository.GetByIdForSoftDeleteAsync(id, cancellationToken);
            if (standard == null)
                return false;

            standard.IsDeleted = true;

            var context = _repository.GetDbContext();
            await context.SaveChangesAsync(cancellationToken);

            return true;
        }
        public async Task<List<IsoStandardDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var standard = await _repository.GetAll(cancellationToken).ConfigureAwait(false);
            if (standard == null || !standard.Any())
                return null;

            return standard.Select(s =>  new IsoStandardDto(s)).ToList();
        }

        public async Task<IsoStandardDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var standard = await _repository.GetByIdAsync(id, cancellationToken).ConfigureAwait(false);
            return standard != null ? new IsoStandardDto(standard) : null;
        }

        public async Task<IsoStandardDto?> GetByIdWithVersionAsync(long id, CancellationToken cancellationToken)
        {
            var standard = await _repository.GetByIdWithVersionAsync(id, cancellationToken).ConfigureAwait(false);
            return standard != null ? new IsoStandardDto(standard) : null;
        }

        public async Task<List<IsoStandardDto>?> GetByVersionIdAsync(int versionId, CancellationToken cancellationToken)
        {
            var standards = await _repository.FilterByVersionId(versionId, cancellationToken).ConfigureAwait(false);
            return standards != null && standards.Any() ? standards.Select(s => new IsoStandardDto(s)).ToList() : null;
        }

        public async Task<List<IsoStandardDto>?> FilterByClauseRef(string clauseRef, int noOfResults, CancellationToken cancellationToken)
        {
            var standards = await _repository.FilterByClauseRef(clauseRef, noOfResults, cancellationToken).ConfigureAwait(false);
            return standards != null && standards.Any() ? standards.Select(s => new IsoStandardDto(s)).ToList() : null;
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as IsoStandardDto;
            var IsoStandardDto = ODto!.ToEntity();

            if (IsoStandardDto.Id == 0)
                _repository.Add(IsoStandardDto);
            else
                await _repository.UpdateAsync(IsoStandardDto, IsoStandardDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(IsoStandardDto, cancellationToken).ConfigureAwait(false);
        }
        public async Task<List<IsoStandardDto>> GetTreeAsync(int versionId, CancellationToken cancellationToken)
        {
            var flat = (await _repository.GetAllForTreeAsync(versionId, cancellationToken).ConfigureAwait(false)).ToList();

            // Build every node as a DTO first, keyed by Id, so children can be
            // attached to their parent's Children list regardless of load order.
            var byId = flat.ToDictionary(s => s.Id, s => new IsoStandardDto(s));

            var roots = new List<IsoStandardDto>();
            foreach (var standard in flat)
            {
                var node = byId[standard.Id];
                if (standard.ParentID.HasValue && byId.TryGetValue(standard.ParentID.Value, out var parent))
                {
                    parent.Children.Add(node);
                }
                else
                {
                    roots.Add(node);
                }
            }

            return roots;
        }




    }
}
