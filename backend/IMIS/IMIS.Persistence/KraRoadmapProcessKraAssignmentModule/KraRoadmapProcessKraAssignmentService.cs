using Base.Primitives;
using IMIS.Application.KraRoadmapProcessKraAssignmentModule;

namespace IMIS.Persistence.KraRoadmapProcessKraAssignmentModule
{
    public class KraRoadmapProcessKraAssignmentService : IKraRoadmapProcessKraAssignmentService
    {
        private readonly IKraRoadmapProcessKraAssignmentRepository _repository;
        public KraRoadmapProcessKraAssignmentService(IKraRoadmapProcessKraAssignmentRepository repository)
        {
            _repository = repository;
        }
     
        public async Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            var ODto = dto as KraRoadmapProcessKraAssignmentDto;
            var kraRoadmapProcessKraAssignmentDto = ODto!.ToEntity();

            if (kraRoadmapProcessKraAssignmentDto.Id == 0)
                _repository.Add(kraRoadmapProcessKraAssignmentDto);
            else
                await _repository.UpdateAsync(kraRoadmapProcessKraAssignmentDto, kraRoadmapProcessKraAssignmentDto.Id, cancellationToken).ConfigureAwait(false);

            await _repository.SaveOrUpdateAsync(kraRoadmapProcessKraAssignmentDto, cancellationToken).ConfigureAwait(false);
        }
    }
}
