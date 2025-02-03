﻿using Base.Abstractions;
using IMIS.Application.AuditorModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.AuditorModule
{
    public class AuditorRepository(ImisDbContext dbContext) : BaseRepository<Auditor, int, ImisDbContext>(dbContext), IAuditorRepository
    {
        public async Task<IEnumerable<Auditor>> FilteByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            return await _dbContext.Auditors
                .Where(a => EF.Functions.Like(a.Name, $"{name}%"))
                .Take(noOfResults)
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<IEnumerable<Auditor>> GetAll(CancellationToken cancellationToken)
        {
            return await _dbContext.Auditors
                .AsNoTracking()
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
        }

        public async Task<Auditor> GetById(int id, CancellationToken cancellationToken)
        {
            return await _dbContext.Auditors.FindAsync(id, cancellationToken).ConfigureAwait(false);
        }
    }
}
