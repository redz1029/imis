﻿using Base.Primitives;
using IMIS.Application.AuditScheduleModule;

namespace IMIS.Persistence.AuditScheduleModule
{
    public class AuditScheduleDetailService : IAuditScheduleDetailService
    {

        private readonly IAuditScheduleDetailRepository _repository;
        public AuditScheduleDetailService(IAuditScheduleDetailRepository repository)
        {
            _repository = repository;
        }

     
        public async Task<AuditScheduleDetailDto> SaveOrUpdateAsync(AuditScheduleDetailDto AuditDetailDto, CancellationToken cancellationToken)
        {
            if (AuditDetailDto == null) throw new ArgumentNullException(nameof(AuditDetailDto));
            var AuditEntity = AuditDetailDto.ToEntity();
            var createdAuditDetailDto = await _repository.SaveOrUpdateAsync(AuditEntity, cancellationToken).ConfigureAwait(false);
            return new AuditScheduleDetailDto
            {
       
                Id = createdAuditDetailDto.Id,
                AuditScheduleId = createdAuditDetailDto.AuditScheduleId,
                TeamId = createdAuditDetailDto.TeamId,
                StartDateTime = createdAuditDetailDto.StartDateTime,
                EndDateTime = createdAuditDetailDto.EndDateTime,
                OfficeId = createdAuditDetailDto.OfficeId
            };
        }
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not AuditScheduleDetailDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));
            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}
