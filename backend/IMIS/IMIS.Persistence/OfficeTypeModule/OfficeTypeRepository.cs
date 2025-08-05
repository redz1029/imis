using Base.Abstractions;
using IMIS.Application.OfficeTypeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.OfficeTypeModule
{
    public class OfficeTypeRepository : BaseRepository<OfficeType, int, ImisDbContext>, IOfficeTypeRepository
    {
        public OfficeTypeRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<IEnumerable<OfficeType>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.OfficeType
                .Where(o => !o.IsDeleted)               
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }
        public new async Task<OfficeType> SaveOrUpdateAsync(OfficeType officeType, CancellationToken cancellationToken)
        {
            if (officeType == null) throw new ArgumentNullException(nameof(officeType));

            try
            {
                var existing = await _dbContext.OfficeType
                    .AsNoTracking()
                    .FirstOrDefaultAsync(d => d.Id == officeType.Id, cancellationToken);

                if (existing != null)
                {
                    _dbContext.OfficeType.Update(officeType);
                }
                else
                {
                    await _dbContext.OfficeType.AddAsync(officeType, cancellationToken);
                }

                await _dbContext.SaveChangesAsync(cancellationToken);
                return officeType;
            }
            catch (DbUpdateConcurrencyException ex)
            {
                throw new InvalidOperationException("Concurrency conflict: The record was updated by another user.", ex);
            }
        }

    }
}
