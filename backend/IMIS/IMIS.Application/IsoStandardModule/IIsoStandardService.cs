using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.IsoStandardModule
{
    public interface IIsoStandardService : IService
    {
        // READ
        Task<List<IsoStandardDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<IsoStandardDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<IsoStandardDto?> GetByIdWithVersionAsync(long id, CancellationToken cancellationToken);
        Task<List<IsoStandardDto>?> GetByVersionIdAsync(int versionId, CancellationToken cancellationToken);
        Task<List<IsoStandardDto>?> FilterByClauseRef(string clauseRef, int noOfResults, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }

}
