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

        public async Task<DtoPageList<IsoStandardDto, Domain.IsoStandard, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var standards = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);
            if (standards.TotalCount == 0)
                return null;
            return DtoPageList<IsoStandardDto, Domain.IsoStandard, long>.Create(standards.Items, page, pageSize, standards.TotalCount);
        }

        public async Task<DtoPageList<IsoStandardDto, Domain.IsoStandard, long>> GetPaginatedByVersionAsync(int versionId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var standards = await _repository.GetPaginatedByVersionAsync(versionId, page, pageSize, cancellationToken).ConfigureAwait(false);
            if (standards.TotalCount == 0)
                return null;
            return DtoPageList<IsoStandardDto, Domain.IsoStandard, long>.Create(standards.Items, page, pageSize, standards.TotalCount);
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



        //public async Task<bool> SoftDeleteAsync(long id, CancellationToken cancellationToken)
        //{
        //    var context = _repository.GetDbContext();

        //    var entity = await context.Set<Domain.IsoStandard>()
        //        .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

        //    if (entity == null)
        //        return false;

        //    // SOFT DELETE
        //    //entity.isActive = false;
        //    var context = _repository.GetDbContext();
        //    await context.SaveChangesAsync(cancellationToken);
        //    return true;
        //}
       

    }
}
