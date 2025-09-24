using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public interface IPgsDeliverableAcomplishmentService : IService
    {
        Task<List<PgsDeliverableAccomplishmentDto>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
        Task<PgsDeliverableAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task UpdateAsync(PgsDeliverableAccomplishmentDto accomplishment, CancellationToken cancellationToken);
        Task UpdateAttachmentPathAsync(long id, string attachmentPath, CancellationToken cancellationToken);
        public Task<DtoPageList<PgsDeliverableAccomplishmentDto, PgsDeliverableAccomplishment, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
    }
}
