using Base.Pagination;
using Base.Primitives;
using IMIS.Application.ImpactScoreCardModule;
using IMIS.Application.ImpactScoreCardIndicatorModule;
using IMIS.Application.ImpactScoreCardTargetModule;
using IMIS.Application.ImpactStrategicGoalScoreCardModule;
using IMIS.Application.ImpactStrategicScoreCardModule;
using IMIS.Application.ImpactStrategicScoreCardMeasureModule;
using IMIS.Application.ImpactStrategicScoreCardTargetModule;
using IMIS.Domain;

namespace IMIS.Persistence.ImpactStrategicGoalScoreCardModule
{
    public class ImpactStrategicGoalScoreCardService : IImpactStrategicGoalScoreCardService
    {
        private readonly IImpactStrategicGoalScoreCardRepository _repository;

        public ImpactStrategicGoalScoreCardService(IImpactStrategicGoalScoreCardRepository repository)
        {
            _repository = repository;
        }

        public async Task<DtoPageList<ImpactStrategicGoalScoreCardDto, ImpactStrategicGoalScoreCard, long>> GetPaginatedAsync(
            long? pgsPeriodId, int page, int pageSize, CancellationToken cancellationToken)
        {
            var result = await _repository.GetPaginatedAsync(pgsPeriodId, page, pageSize, cancellationToken).ConfigureAwait(false);
            if (result.TotalCount == 0)
            {
                return null;
            }
            return DtoPageList<ImpactStrategicGoalScoreCardDto, ImpactStrategicGoalScoreCard, long>.Create(result.Items, page, pageSize, result.TotalCount);
        }

        public async Task<ImpactStrategicGoalScoreCardDto?> GetByIdAsync(int id, CancellationToken cancellationToken)
        {
            var entity = await _repository.GetByIdWithChildrenAsync(id, cancellationToken).ConfigureAwait(false);
            return entity == null ? null : new ImpactStrategicGoalScoreCardDto(entity);
        }
        
        private static ImpactStrategicGoalScoreCard BuildNewEntity(ImpactStrategicGoalScoreCardDto dto) => new()
        {
            Id = 0,
            ImpactStrategicGoalScoreCardPeriodId = dto.ImpactStrategicGoalScoreCardPeriodId,
            ImpactScoreCard = dto.ImpactScoreCard?.Select(BuildNewImpactScoreCard).ToList() ?? new(),
            ImpactStrategicScoreCard = dto.ImpactStrategicScoreCard?.Select(BuildNewImpactStrategicScoreCard).ToList() ?? new()
        };

        private static ImpactScoreCard BuildNewImpactScoreCard(ImpactScoreCardDto dto) => new()
        {
            Id = 0,
            ImpactDescription = dto.ImpactDescription,
            ImpactScoreCardIndicator = dto.ImpactScoreCardIndicator?.Select(BuildNewIndicator).ToList() ?? new()
        };

        private static ImpactScoreCardIndicator BuildNewIndicator(ImpactScoreCardIndicatorDto dto) => new()
        {
            Id = 0,
            IndicatorDescription = dto.IndicatorDescription,
            ImpactScoreCardTarget = dto.ImpactScoreCardTarget?.Select(BuildNewTarget).ToList() ?? new()
        };

        private static ImpactScoreCardTarget BuildNewTarget(ImpactScoreCardTargetDto dto) => new()
        {
            Id = 0,
            Year = dto.Year,
            Target = dto.Target
        };

        private static ImpactStrategicScoreCard BuildNewImpactStrategicScoreCard(ImpactStrategicScoreCardDto dto) => new()
        {
            Id = 0,
            GoalDescription = dto.GoalDescription,
            ImpactStrategicScoreCardMeasure = dto.ImpactStrategicScoreCardMeasure?.Select(BuildNewMeasure).ToList() ?? new()
        };

        private static ImpactStrategicScoreCardMeasure BuildNewMeasure(ImpactStrategicScoreCardMeasureDto dto) => new()
        {
            Id = 0,
            MeasureDescription = dto.MeasureDescription,
            ImpactStrategicScoreCardTarget = dto.ImpactStrategicScoreCardTarget?.Select(BuildNewStrategicTarget).ToList() ?? new()
        };

        private static ImpactStrategicScoreCardTarget BuildNewStrategicTarget(ImpactStrategicScoreCardTargetDto dto) => new()
        {
            Id = 0,
            Year = dto.Year,
            Target = dto.Target
        };
       
        private void UpdateImpactScoreCards(ImpactStrategicGoalScoreCard existing, List<ImpactScoreCardDto>? incoming)
        {
            existing.ImpactScoreCard ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactScoreCard.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewImpactScoreCard(itemDto);
                    newItem.ImpactStrategicGoalScoreCardId = existing.Id;
                    existing.ImpactScoreCard.Add(newItem);
                    continue;
                }

                var match = existing.ImpactScoreCard.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.ImpactDescription = itemDto.ImpactDescription;
                match.IsDeleted = false;

                UpdateIndicators(match, itemDto.ImpactScoreCardIndicator);
            }
        }

        private void UpdateIndicators(ImpactScoreCard existing, List<ImpactScoreCardIndicatorDto>? incoming)
        {
            existing.ImpactScoreCardIndicator ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactScoreCardIndicator.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewIndicator(itemDto);
                    newItem.ImpactScoreCardId = existing.Id;
                    existing.ImpactScoreCardIndicator.Add(newItem);
                    continue;
                }

                var match = existing.ImpactScoreCardIndicator.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.IndicatorDescription = itemDto.IndicatorDescription;
                match.IsDeleted = false;

                UpdateTargets(match, itemDto.ImpactScoreCardTarget);
            }
        }

        private void UpdateTargets(ImpactScoreCardIndicator existing, List<ImpactScoreCardTargetDto>? incoming)
        {
            existing.ImpactScoreCardTarget ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactScoreCardTarget.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewTarget(itemDto);
                    newItem.ImpactScoreCardIndicatorId = existing.Id;
                    existing.ImpactScoreCardTarget.Add(newItem);
                    continue;
                }

                var match = existing.ImpactScoreCardTarget.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.Year = itemDto.Year;
                match.Target = itemDto.Target;
                match.IsDeleted = false;
            }
        }

        private void UpdateImpactStrategicScoreCards(ImpactStrategicGoalScoreCard existing, List<ImpactStrategicScoreCardDto>? incoming)
        {
            existing.ImpactStrategicScoreCard ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactStrategicScoreCard.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewImpactStrategicScoreCard(itemDto);
                    newItem.ImpactStrategicGoalScoreCardId = existing.Id;
                    existing.ImpactStrategicScoreCard.Add(newItem);
                    continue;
                }

                var match = existing.ImpactStrategicScoreCard.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.GoalDescription = itemDto.GoalDescription;
                match.IsDeleted = false;

                UpdateMeasures(match, itemDto.ImpactStrategicScoreCardMeasure);
            }
        }

        private void UpdateMeasures(ImpactStrategicScoreCard existing, List<ImpactStrategicScoreCardMeasureDto>? incoming)
        {
            existing.ImpactStrategicScoreCardMeasure ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactStrategicScoreCardMeasure.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewMeasure(itemDto);
                    newItem.ImpactStrategicScoreCardId = existing.Id;
                    existing.ImpactStrategicScoreCardMeasure.Add(newItem);
                    continue;
                }

                var match = existing.ImpactStrategicScoreCardMeasure.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.MeasureDescription = itemDto.MeasureDescription;
                match.IsDeleted = false;

                UpdateStrategicTargets(match, itemDto.ImpactStrategicScoreCardTarget);
            }
        }

        private void UpdateStrategicTargets(ImpactStrategicScoreCardMeasure existing, List<ImpactStrategicScoreCardTargetDto>? incoming)
        {
            existing.ImpactStrategicScoreCardTarget ??= new();
            var incomingIds = incoming?.Where(x => x.Id != 0).Select(x => x.Id).ToList() ?? new();

            foreach (var item in existing.ImpactStrategicScoreCardTarget.Where(x => !incomingIds.Contains(x.Id) && !x.IsDeleted))
            {
                item.IsDeleted = true;
            }

            foreach (var itemDto in incoming ?? new())
            {
                if (itemDto.Id == 0)
                {
                    var newItem = BuildNewStrategicTarget(itemDto);
                    newItem.ImpactStrategicScoreCardMeasureId = existing.Id;
                    existing.ImpactStrategicScoreCardTarget.Add(newItem);
                    continue;
                }

                var match = existing.ImpactStrategicScoreCardTarget.FirstOrDefault(x => x.Id == itemDto.Id);
                if (match == null) continue;

                match.Year = itemDto.Year;
                match.Target = itemDto.Target;
                match.IsDeleted = false;
            }
        }

        public async Task<ImpactStrategicGoalScoreCardDto> SaveOrUpdateAsync(ImpactStrategicGoalScoreCardDto dto, CancellationToken cancellationToken)
        {
            ImpactStrategicGoalScoreCard entity;

            if (dto.Id == 0)
            {

                entity = BuildNewEntity(dto);
                _repository.GetDbContext().Add(entity);
            }
            else
            {
                entity = await _repository.GetByIdWithChildrenAsync(dto.Id, cancellationToken) ?? throw new InvalidOperationException("Record not found.");

                entity.ImpactStrategicGoalScoreCardPeriodId = dto.ImpactStrategicGoalScoreCardPeriodId;

                UpdateImpactScoreCards(entity, dto.ImpactScoreCard);
                UpdateImpactStrategicScoreCards(entity, dto.ImpactStrategicScoreCard);
            }

            await _repository.SaveOrUpdateAsync(entity, cancellationToken);

            return new ImpactStrategicGoalScoreCardDto(entity);
        }

        public Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken) where TEntity : Entity<TId>
        {
            if (dto is ImpactStrategicGoalScoreCardDto impactDto)
            {
                return SaveOrUpdateAsync(impactDto, cancellationToken);
            }

            throw new NotImplementedException($"SaveOrUpdateAsync is not implemented for DTO: {dto.GetType().Name}");
        }
    }
}