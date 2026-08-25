using Base.Abstractions;

namespace IMIS.Application.PgsSignatoryModule
{
    public interface IPgsSignatoryService : IService
    {
        Task<List<PgsSignatoryDto>?> GetAllPgsSignatoryId(long? pgsSignatoryId, CancellationToken cancellationToken);
        Task<bool> SoftDeleteSignatoryAsync(int pgsid, CancellationToken cancellationToken);
    }
}
