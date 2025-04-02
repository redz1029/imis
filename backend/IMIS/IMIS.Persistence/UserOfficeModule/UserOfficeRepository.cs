using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.UserOfficeModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.UserOfficeModule
{
    public class UserOfficeRepository : BaseRepository<UserOffices, int, ImisDbContext>, IUserOfficeRepository
    {
        public UserOfficeRepository(ImisDbContext dbContext) : base(dbContext)
        {
        }
        public async Task<EntityPageList<UserOffices, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken)
        {
            var query = _dbContext.UserOffices.Where(k => !k.IsDeleted).AsNoTracking();
            
            var userOffice = await EntityPageList<UserOffices, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
           
            return userOffice;
        }
        public async Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.UserOffices
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public new async Task<UserOffices> SaveOrUpdateAsync(UserOffices userOffice, CancellationToken cancellationToken)
        {
            if (userOffice == null) throw new ArgumentNullException(nameof(userOffice));

            var existingUserOffice = await _dbContext.UserOffices
                .FirstOrDefaultAsync(d => d.Id == userOffice.Id, cancellationToken)
                .ConfigureAwait(false);

            if (existingUserOffice != null)
            {
                // Update the existing record's values
                _dbContext.Entry(existingUserOffice).CurrentValues.SetValues(userOffice);
            }
            else
            {
                // Add a new PgsAuditDetails if not found
                await _dbContext.UserOffices.AddAsync(userOffice, cancellationToken).ConfigureAwait(false);
            }

            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return userOffice;
        }

    }
}
