using Base.Abstractions;
using IMIS.Domain;

namespace IMIS.Application.UserOfficeModule
{
    public interface IUserOfficeRepository : IRepository<UserOffices, int>
    {
        Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken);
        new Task<UserOffices> SaveOrUpdateAsync(UserOffices useroffice, CancellationToken cancellationToken);
    }
}
