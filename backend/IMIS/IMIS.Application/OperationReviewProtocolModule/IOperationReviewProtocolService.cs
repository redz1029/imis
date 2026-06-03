using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public interface IOperationReviewProtocolService : IService
    {
        Task<OperationReviewProtocolDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        public Task<DtoPageList<OperationReviewProtocolDto, OperationReviewProtocol, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<List<OperationReviewProtocolDto>?> GetAll(long? performanceGovernanceSystemId, CancellationToken cancellationToken);      
        Task<ReportOperationReviewProtocolDto?> ReportGetByIdAsync(long operationReviewProtocolId, long pgsId, int month, int year, CancellationToken cancellationToken);
        Task<List<ORPPgsDeliverableAccomplishmentDto>> GetDeliverableByIdAsync(long id, int month, int year, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
