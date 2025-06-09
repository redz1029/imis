﻿using Base.Abstractions;
using Base.Pagination;
using IMIS.Application.PerfomanceGovernanceSystemModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public interface IPerfomanceGovernanceSystemService : IService
    {
        public Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto> SaveOrUpdateAsync(PerfomanceGovernanceSystemDto perfomanceGovernanceSystemDto, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<PerfomanceGovernanceSystemDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<ReportPerfomanceGovernanceSystemDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>?> GetByUserIdAsync(string userId, CancellationToken cancellationToken);
        Task<List<PerfomanceGovernanceSystemDto>> GetAllAsyncFilterByPgsPeriod(long? pgsPeriodId, CancellationToken cancellationToken);               
        public Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedPgsPeriodIdAsync(long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken);      
        Task<DtoPageList<PerfomanceGovernanceSystemDto, PerfomanceGovernanceSystem, long>> GetPaginatedFilteredDeliverablesAsync(PgsDeliverableMonitoringDto filter, CancellationToken cancellationToken);
    }
}
