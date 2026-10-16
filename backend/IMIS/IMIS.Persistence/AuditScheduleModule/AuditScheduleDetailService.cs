using Base.Primitives;
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
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as AuditScheduleDetailDto;
            var auditScheduleDetailDto = ODto!.ToEntity();

            if (auditScheduleDetailDto.Id == 0)
                _repository.Add(auditScheduleDetailDto);
            else
                await _repository.UpdateAsync(auditScheduleDetailDto, auditScheduleDetailDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(auditScheduleDetailDto, cancellationToken).ConfigureAwait(false);
        }      
    }
}
