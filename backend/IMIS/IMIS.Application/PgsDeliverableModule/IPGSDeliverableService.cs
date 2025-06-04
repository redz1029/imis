using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPGSDeliverableService : IService
    {

        public Task<DtoPageList<PGSDeliverableDto, PgsDeliverable, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PGSDeliverableDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PGSDeliverableDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PGSDeliverableDto> SaveOrUpdateAsync(PGSDeliverableDto pgsDeliverableDto, CancellationToken cancellationToken);       
    }
}






