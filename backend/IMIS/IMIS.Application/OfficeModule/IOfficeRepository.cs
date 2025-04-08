﻿using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.OfficeModule
{
    public interface IOfficeRepository : IRepository<Office, int>
    {
        Task<EntityPageList<Office, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> GetAll(CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> GetAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> GetNonAuditableOffices(int? auditScheduleId, CancellationToken cancellationToken);
        Task<IEnumerable<Office>?> FilterByName(string name, int noOfResults, CancellationToken cancellationToken);
    }
}
