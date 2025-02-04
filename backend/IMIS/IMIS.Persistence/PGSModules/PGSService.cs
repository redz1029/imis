

using Base.Primitives;
using IMIS.Application.PgsModule;


namespace IMIS.Persistence.PGSModules
{
    
    public class PGSService(IPGSRepository repository) : IPGSService
    {
        private readonly IPGSRepository _repository = repository;

      
        public async Task<List<PgsDto>> GetAllActiveAsync(CancellationToken cancellationToken)
        {
            var activePgs = await _repository.GetAllActiveAsync(cancellationToken).ConfigureAwait(false);
            return activePgs.Select(pgs => new PgsDto
            {
                Id = pgs.Id,
                Year = pgs.Year,
                KRA_1 = pgs.KRA_1,
                Direct_1 = pgs.Direct_1,
                Indirect_1 = pgs.Indirect_1,
                Delivarables_1 = pgs.Delivarables_1,
                ByWhen_1 = pgs.ByWhen_1,
                Percent_Deliverables = pgs.Percent_Deliverables,
                Status = pgs.Status
            }).ToList();
        }

       
        public async Task<List<PgsDto>> GetAllAsync(CancellationToken cancellationToken)
        {
            var allPgs = await _repository.GetAllAsync(cancellationToken).ConfigureAwait(false);
            return allPgs.Select(pgs => new PgsDto
            {
                Id = pgs.Id,
                Year = pgs.Year,
                KRA_1 = pgs.KRA_1,
                Direct_1 = pgs.Direct_1,
                Indirect_1 = pgs.Indirect_1,
                Delivarables_1 = pgs.Delivarables_1,
                ByWhen_1 = pgs.ByWhen_1,
                Percent_Deliverables = pgs.Percent_Deliverables,
                Status = pgs.Status
            }).ToList();
        }

        public async Task<PgsDto> CreateAsync(PgsDto pgsDto, CancellationToken cancellationToken)
        {
            if (pgsDto == null) throw new ArgumentNullException(nameof(pgsDto));

            var pgsEntity = pgsDto.ToEntity();
            var createdPgs = await _repository.CreateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);

            return new PgsDto
            {
                Id = createdPgs.Id,
                Year = createdPgs.Year,
                KRA_1 = createdPgs.KRA_1,
                Direct_1 = createdPgs.Direct_1,
                Indirect_1 = createdPgs.Indirect_1,
                Delivarables_1 = createdPgs.Delivarables_1,
                ByWhen_1 = createdPgs.ByWhen_1,
                Percent_Deliverables = createdPgs.Percent_Deliverables,
                Status = createdPgs.Status
            };
        }

      
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is not PgsDto pgsDto) throw new ArgumentException("Invalid DTO type", nameof(dto));

            var pgsEntity = pgsDto.ToEntity();
            await _repository.SaveOrUpdateAsync(pgsEntity, cancellationToken).ConfigureAwait(false);
        }
    }
}



