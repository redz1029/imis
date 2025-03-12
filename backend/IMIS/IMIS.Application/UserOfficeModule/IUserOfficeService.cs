using Base.Abstractions;
using IMIS.Application.PgsKraModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;

namespace IMIS.Application.UserOfficeModule
{
    public interface IUserOfficeService : IService
    {
        Task<UserOfficeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<UserOfficeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<UserOfficeDto> SaveOrUpdateAsync(UserOfficeDto user, CancellationToken cancellationToken);
    }
}
