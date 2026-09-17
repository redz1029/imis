using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.AuditProgrammeModule
{
    public interface IAuditProgrammeService : IService
    {
        Task<List<AuditProgrammeDto>?> GetAllAsync(CancellationToken cancellationToken);
        Task<AuditProgrammeDto?> GetByIdAsync(int id, CancellationToken cancellationToken);
        Task<ReportAuditProgrammeDto?> ReportGetByIdAsync(int id, CancellationToken cancellationToken);
        Task<bool> SaveAuditProgrammeAsync(AuditProgrammeDto dto, CancellationToken cancellationToken);
        Task<DtoPageList<AuditProgrammeDto, AuditProgramme, int>> GetPaginatedAsync(int page, int pageSize, CancellationToken cancellationToken);
        Task<bool> SoftDeleteAsync(int id, CancellationToken cancellationToken);
        Task<List<string>> GetConflictValidationsAsync(AuditProgrammeDto dto, CancellationToken cancellationToken);
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;

        // --- Status Transitions ---
        // These are the ONLY paths that may change AuditProgramme.AuditStatusId
        // or write an AuditProgrammeStatusHistory row — enforces the invariant
        // already documented on AuditProgrammeDto.AuditStatusId.

        /// <summary>Moves a Draft or Disapproved programme to Pending.</summary>
        Task<(bool Success, string? Error)> SubmitAsync(int id, CancellationToken cancellationToken);

        /// <summary>Approves or rejects a Pending programme.</summary>
        Task<(bool Success, string? Error)> DecideAsync(
            int id,
            string approverId,
            bool approve,
            string? comments,
            CancellationToken cancellationToken);


    }
}