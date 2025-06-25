using Base.Abstractions;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeService : IService
    {
        Task<List<OfficeTypeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<OfficeTypeDto> SaveOrUpdateAsync(OfficeTypeDto officeTypeDto, CancellationToken cancellationToken);
    }
}
