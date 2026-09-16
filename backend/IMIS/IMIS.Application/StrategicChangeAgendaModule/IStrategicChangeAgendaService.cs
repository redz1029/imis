using Base.Abstractions;
using Base.Pagination;
using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public interface IStrategicChangeAgendaService : IService
    {
        Task<StrategicChangeAgendaDto?> GetByIdAsync(long id, CancellationToken cancellationToken);
        Task<ReportStrategicChangeAgendaDto?> ReportGetByIdAsync(long id, CancellationToken cancellationToken);
        public Task<DtoPageList<StrategicChangeAgendaDto, StrategicChangeAgenda, long>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
    }
}
