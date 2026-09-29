using Base.Pagination;
using Base.Primitives;
using IMIS.Application.IQASignatoryTemplateModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.IQASignatoryTemplateModule
{
    public class IQASignatoryTemplateService : IIQASignatoryTemplateService
    {
        private readonly IIQASignatoryTemplateRepository _repository;

        public IQASignatoryTemplateService(IIQASignatoryTemplateRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }

        public async Task<IQASignatoryTemplateDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithDetailsAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new IQASignatoryTemplateDto(entity) : null;
        }

        public async Task<List<IQASignatoryTemplateDto>?> GetAllAsync(CancellationToken cancellationToken)
        {
            var entities = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return entities?.Select(e => new IQASignatoryTemplateDto(e)).ToList();
        }

        public async Task<List<IQASignatoryTemplateDto>?> GetByAuditEntityTypeAsync(string auditEntityType, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(auditEntityType))
                return new List<IQASignatoryTemplateDto>();

            var entities = await _repository.GetByAuditEntityTypeAsync(auditEntityType, cancellationToken).ConfigureAwait(false);
            return entities.Select(e => new IQASignatoryTemplateDto(e)).ToList();
        }

        public async Task<List<IQASignatoryTemplateDto>?> GetByOfficeIdAsync(int officeId, CancellationToken cancellationToken)
        {
            if (officeId <= 0)
                return new List<IQASignatoryTemplateDto>();

            var entities = await _repository.GetByOfficeIdAsync(officeId, cancellationToken).ConfigureAwait(false);
            return entities.Select(e => new IQASignatoryTemplateDto(e)).ToList();
        }

        public async Task<List<IQASignatoryTemplateDto>?> GetByStatusAsync(string status, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(status))
                return new List<IQASignatoryTemplateDto>();

            var entities = await _repository.GetByStatusAsync(status, cancellationToken).ConfigureAwait(false);
            return entities.Select(e => new IQASignatoryTemplateDto(e)).ToList();
        }

        public async Task<DtoPageList<IQASignatoryTemplateDto, IQASignatoryTemplate, int>> GetPaginatedAsync(
            int page, int pageSize, CancellationToken cancellationToken)
        {
            var pagedEntities = await _repository.GetPaginatedAsync(page, pageSize, cancellationToken).ConfigureAwait(false);

            return DtoPageList<IQASignatoryTemplateDto, IQASignatoryTemplate, int>.Create(
                pagedEntities.Items,
                page,
                pageSize,
                pagedEntities.TotalCount);
        }

        public async Task<IQASignatoryTemplateDto> SaveOrUpdateAsync(IQASignatoryTemplateDto dto, CancellationToken cancellationToken)
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            var entity = dto.ToEntity();

            if (entity.Id == 0)
            {
                _repository.Add(entity);
            }
            else
            {
                await _repository.UpdateAsync(entity, entity.Id, cancellationToken).ConfigureAwait(false);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);

            var saved = await _repository.GetByIdWithDetailsAsync(entity.Id, cancellationToken).ConfigureAwait(false);
            return new IQASignatoryTemplateDto(saved!);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>
        {
            if (dto is not IQASignatoryTemplateDto templateDto)
                throw new ArgumentException("Invalid DTO type", nameof(dto));

            await SaveOrUpdateAsync(templateDto, cancellationToken).ConfigureAwait(false);
        }

        public async Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdForDeleteAsync(id, cancellationToken).ConfigureAwait(false);
            if (entity == null) return false;

            entity.IsDeleted = true;
            await _repository.SaveOrUpdateAsync(entity, cancellationToken).ConfigureAwait(false);
            return true;
        }
    }
}