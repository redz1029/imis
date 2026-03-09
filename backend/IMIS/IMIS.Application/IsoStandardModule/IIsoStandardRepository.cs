using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardModule
{
    public interface IIsoStandardRepository : IRepository<IsoStandard, long>
    {
        Task<IEnumerable<IsoStandard>> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<IsoStandard>?> FilterByVersionId(int versionId, CancellationToken cancellationToken);
        Task<IEnumerable<IsoStandard>?> FilterByClauseRef(string clauseRef, int noOfResults, CancellationToken cancellationToken);
      
        Task<IsoStandard?> GetByIdWithVersionAsync(long id, CancellationToken cancellationToken);
        Task<IsoStandard?> GetByIdForSoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
