namespace IMIS.Application.AuditableOfficesModule
{
    public interface IAuditableOfficesService
    {
        Task<AuditableOfficesDto> SaveOrUpdateAsync(AuditableOfficesDto auditableOfficesDto, CancellationToken cancellationToken);
    }
}
