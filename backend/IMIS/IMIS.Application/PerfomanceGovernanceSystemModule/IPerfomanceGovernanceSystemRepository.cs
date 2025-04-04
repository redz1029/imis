﻿using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemRepository : IRepository<PerfomanceGovernanceSystem, long>
    {
        Task<IEnumerable<PerfomanceGovernanceSystem>> GetAll(CancellationToken cancellationToken);
        Task<EntityPageList<PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        new Task<PerfomanceGovernanceSystem> SaveOrUpdateAsync(PerfomanceGovernanceSystem perfomanceGovernanceSystem, CancellationToken cancellationToken);
    }
}
