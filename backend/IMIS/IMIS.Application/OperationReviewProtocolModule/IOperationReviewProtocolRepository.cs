
using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.OperationReviewProtocolModule
{
    public interface IOperationReviewProtocolRepository
        : IRepository<OperationReviewProtocol, long>
    {
        Task<EntityPageList<OperationReviewProtocol, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<OperationReviewProtocol>?> GetAll(long? performanceGovernanceSystemId, CancellationToken cancellationToken);    
        Task<OperationReviewProtocol?> ReportGetByIdAsync(long operationReviewProtocolId, CancellationToken cancellationToken);      
        Task<OperationReviewProtocol?> GetByIdAsync(long id, CancellationToken cancellationToken);      
        Task<List<PgsDeliverableAccomplishment>> GetDeliverableByIdAsync(long performanceGovernanceSystemId, int month, int year, CancellationToken cancellationToken);
    }
}