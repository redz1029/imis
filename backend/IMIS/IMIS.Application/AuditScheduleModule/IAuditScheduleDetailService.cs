﻿using Base.Abstractions;


namespace IMIS.Application.AuditScheduleModule
{
    public interface IAuditScheduleDetailService : IService
    {
        Task<AuditScheduleDetailDto> SaveOrUpdateAsync(AuditScheduleDetailDto auditScheduleDetail, CancellationToken cancellationToken);
    }
}

