using Base.Abstractions;

namespace IMIS.Application.PgsDeliverableAccomplishmentModule
{
    public interface IPgsDeliverableAcomplishmentService : IService
    {
        Task<List<PgsDeliverableAccomplishmentDto>> GetByDeliverableIdAsync(long deliverableId, CancellationToken cancellationToken);
        Task<PgsDeliverableAccomplishmentDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task UpdateAsync(PgsDeliverableAccomplishmentDto accomplishment, CancellationToken cancellationToken);
        Task UpdateAttachmentPathAsync(long id, string attachmentPath, CancellationToken cancellationToken);
    }
}
