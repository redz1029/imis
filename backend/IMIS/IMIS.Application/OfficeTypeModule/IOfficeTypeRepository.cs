
using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeRepository : IRepository<OfficeType, int>
    {
        Task<IEnumerable<OfficeType>?> GetAll(CancellationToken cancellationToken);
        new Task<OfficeType> SaveOrUpdateAsync(OfficeType officetype, CancellationToken cancellationToken);
    }
}
