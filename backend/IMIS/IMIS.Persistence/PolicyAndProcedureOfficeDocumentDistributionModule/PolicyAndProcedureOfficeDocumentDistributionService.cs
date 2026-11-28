using Base.Primitives;
using IMIS.Application.PolicyAndProcedureOfficeDocumentDistributionModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.PolicyAndProcedureOfficeDocumentDistributionModule
{
    public class PolicyAndProcedureOfficeDocumentDistributionService : IPolicyAndProcedureOfficeDocumentDistributionService
    {
        private readonly IPolicyAndProcedureOfficeDocumentDistributionRepository _repository;

        public PolicyAndProcedureOfficeDocumentDistributionService(IPolicyAndProcedureOfficeDocumentDistributionRepository repository)
        {
            _repository = repository;
        }

        public async Task<PolicyAndProcedureOfficeDocumentDistributionDto?> GetByIdAsync(long id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithListAsync(id, cancellationToken).ConfigureAwait(false);
            return entity != null ? new PolicyAndProcedureOfficeDocumentDistributionDto(entity) : null;
        }

        public async Task<PolicyAndProcedureOfficeDocumentDistributionDto> SaveOrUpdateAsync(PolicyAndProcedureOfficeDocumentDistributionDto dto, CancellationToken cancellationToken)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var context = _repository.GetDbContext();
            var set = context.Set<PolicyAndProcedureOfficeDocumentDistribution>();
         
            var entity = await set
                .Include(x => x.OfficeDocumentDistributionList)
                .FirstOrDefaultAsync(x => !x.IsDeleted &&
                    (dto.Id != 0
                        ? x.Id == dto.Id
                        : x.PolicyAndProcedureId == dto.PolicyAndProcedureId),
                    cancellationToken)
                .ConfigureAwait(false);

            if (dto.Id != 0 && entity == null)
                throw new InvalidOperationException("Office Document Distribution not found.");

            if (entity == null)
            {
                entity = new PolicyAndProcedureOfficeDocumentDistribution
                {
                    Id = 0,
                    PolicyAndProcedureId = dto.PolicyAndProcedureId
                };

                set.Add(entity);
            }

            entity.PolicyAndProcedureId = dto.PolicyAndProcedureId;
            entity.PostingDate = dto.PostingDate;
            entity.IsControlledCopy = dto.IsControlledCopy;
            entity.IsMasterCopy = dto.IsMasterCopy;

            var incoming = dto.OfficeDocumentDistributionList ?? new();

            var incomingIds = incoming
                .Where(x => x.Id != 0)
                .Select(x => x.Id)
                .ToHashSet();

            foreach (var existingItem in entity.OfficeDocumentDistributionList
                .Where(x => !x.IsDeleted && !incomingIds.Contains(x.Id))
                .ToList())
            {
                existingItem.IsDeleted = true;
            }

            foreach (var item in incoming)
            {
                if (item.Id == 0)
                {
                    var newItem = item.ToEntity();
                    newItem.PolicyAndProcedureOfficeDocumentDistributionId = entity.Id;
                    entity.OfficeDocumentDistributionList.Add(newItem);
                    continue;
                }

                var match = entity.OfficeDocumentDistributionList.FirstOrDefault(x => x.Id == item.Id && !x.IsDeleted);
                if (match != null)
                {
                    match.CopyHolderUserId = item.CopyHolderUserId;
                    match.OfficeId = item.OfficeId;
                    match.IssuanceDate = item.IssuanceDate;
                    match.IssuanceRevision = item.IssuanceRevision;
                    match.RetrievalDate = item.RetrievalDate;
                    match.RetrievalRevision = item.RetrievalRevision;
                }
            }

            await context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            var saved = await set
                .AsNoTracking()
                .Include(x => x.OfficeDocumentDistributionList.Where(l => !l.IsDeleted))
                .FirstAsync(x => x.Id == entity.Id, cancellationToken)
                .ConfigureAwait(false);

            return new PolicyAndProcedureOfficeDocumentDistributionDto(saved);
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is PolicyAndProcedureOfficeDocumentDistributionDto distributionDto)
            {
                await SaveOrUpdateAsync(distributionDto, cancellationToken).ConfigureAwait(false);
                return;
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}