using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.IQASignatoryTemplateModule
{
    public interface IIQASignatoryTemplateService : IService
    {
        Task<IQASignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken);

        Task<List<IQASignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken);

        Task<List<IQASignatoryTemplateDto>?> GetByAuditEntityTypeAsync(string auditEntityType, CancellationToken cancellationToken);

        Task<List<IQASignatoryTemplateDto>?> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken);

        Task<List<IQASignatoryTemplateDto>?> GetByStatusAsync(string status, CancellationToken cancellationToken);

        Task<DtoPageList<IQASignatoryTemplateDto, IQASignatoryTemplate, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);

        Task<IQASignatoryTemplateDto> SaveOrUpdateAsync(IQASignatoryTemplateDto dto, CancellationToken cancellationToken);

        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;

        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}