using IMIS.Domain;

namespace IMIS.Application.AuditableOfficesModule
{
    public interface IAuditableOfficesRepository
    {
        Task<AuditableOffices> SaveOrUpdateAsync(AuditableOffices period, CancellationToken cancellationToken);
    }
}
