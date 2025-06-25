using Base.Abstractions;

namespace IMIS.Application.OfficeTypeModule
{
    public interface IOfficeTypeService : IService
    {
        Task<OfficeTypeDto> SaveOrUpdateAsync(OfficeTypeDto officeTypeDto, CancellationToken cancellationToken);
    }
}
