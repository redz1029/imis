
using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeRepository : IRepository<OfficeType, int>
    {
      new Task<OfficeType> SaveOrUpdateAsync(OfficeType officetype, CancellationToken cancellationToken);
    }
}
