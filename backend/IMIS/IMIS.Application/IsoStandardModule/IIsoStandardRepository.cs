using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardModule
{
    public interface IIsoStandardRepository : IRepository<Domain.IsoStandard, long>
    {
        Task<IEnumerable<Domain.IsoStandard>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Domain.IsoStandard>?> FilterByVersionId(int versionId, CancellationToken cancellationToken);
        Task<IEnumerable<Domain.IsoStandard>?> FilterByClauseRef(string clauseRef, int noOfResults, CancellationToken cancellationToken);
        Task<EntityPageList<Domain.IsoStandard, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<EntityPageList<Domain.IsoStandard, long>> GetPaginatedByVersionAsync(int versionId, int page, int pageSize, CancellationToken cancellationToken);
        Task<Domain.IsoStandard?> GetByIdWithVersionAsync(long id, CancellationToken cancellationToken);
    }
}
