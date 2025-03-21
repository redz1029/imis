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
            
            var useroffice = await EntityPageList<UserOffices, int>.CreateAsync(query, page, pageSize, cancellationToken).ConfigureAwait(false);
           
            return useroffice;
        }
        public async Task<IEnumerable<UserOffices>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.UserOffices
                .Where(o => !o.IsDeleted)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public new async Task<UserOffices> SaveOrUpdateAsync(UserOffices useroffice, CancellationToken cancellationToken)
        {
            if (useroffice == null) throw new ArgumentNullException(nameof(useroffice));

            var existinguseroffice = await _dbContext.UserOffices
                .FirstOrDefaultAsync(d => d.Id == useroffice.Id, cancellationToken)
                .ConfigureAwait(false);

            if (existinguseroffice != null)
            {
                // Update the existing record's values
                _dbContext.Entry(existinguseroffice).CurrentValues.SetValues(useroffice);
            }
            else
            {
                // Add a new PgsAuditDetails if not found
                await _dbContext.UserOffices.AddAsync(useroffice, cancellationToken).ConfigureAwait(false);
            }

            // Save changes to the database
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return useroffice;
        }

    }
}
