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
        Task<DtoPageList<IsoStandardDto, IsoStandard, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<DtoPageList<IsoStandardDto, IsoStandard, long>> GetPaginatedByVersionAsync(int versionId, int page, int pageSize, CancellationToken cancellationToken);

        // WRITE
        Task CreateAsync(IsoStandardDto dto, CancellationToken cancellationToken);
        Task UpdateAsync(long id, IsoStandardDto dto, CancellationToken cancellationToken);
        Task<bool> DeleteAsync(long id, CancellationToken cancellationToken);
    }

}
