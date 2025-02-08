using Base.Primitives;
using IMIS.Application.AuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditorModule
{
    public class AuditorService : IAuditorService
    {
        private readonly IAuditorRepository _auditorRepository;

        public AuditorService(IAuditorRepository auditorRepository)
        {
            _auditorRepository = auditorRepository;
        }   

        public async Task<List<AuditorDto>?> FilteByName(string name, int noOfResults, CancellationToken cancellationToken)
        {
            var auditors = await _auditorRepository.FilteByName(name, noOfResults, cancellationToken).ConfigureAwait(false);
            return auditors != null && auditors.Count() > 0 ? auditors.Select(a => new AuditorDto(a)).ToList() : null;
        }

        public async Task<List<AuditorDto>?> GetAll(CancellationToken cancellationToken)
        {
            var auditors = await _auditorRepository.GetAll(cancellationToken).ConfigureAwait(false);
            return auditors?.Select(a => new AuditorDto(a)).ToList();
        }

        public async Task<AuditorDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var auditor = await _auditorRepository
                .GetByIdAsync(id, cancellationToken)
                .ConfigureAwait(false);
            return auditor != null ? new AuditorDto(auditor) : null;
        }

        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var auditorDto = dto as AuditorDto;
            var auditor = auditorDto!.ToEntity();
            if(auditor.Id == 0)
                _auditorRepository.Add(auditor);
            await _auditorRepository.SaveOrUpdateAsync(auditor, cancellationToken).ConfigureAwait(false);
        }
    }
}
