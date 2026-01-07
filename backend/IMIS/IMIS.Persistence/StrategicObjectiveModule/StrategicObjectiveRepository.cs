using Base.Abstractions;
using IMIS.Application.CharacterModule;
using IMIS.Domain;

namespace IMIS.Persistence.StrategicObjectiveModule
{
    public class StrategicObjectiveRepository(ImisDbContext dbContext) : BaseRepository<StrategicObjective, long, ImisDbContext>(dbContext), IStrategicObjectiveRepository
    {
    }
}
