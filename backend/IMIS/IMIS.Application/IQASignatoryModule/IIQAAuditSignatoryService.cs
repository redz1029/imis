using Base.Abstractions;
using Base.Pagination;
using Base.Primitives;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.IQASignatoryModule
{
    /// <summary>
    /// Service interface for managing ISO audit (IQA) signatory workflows.
    /// Handles approval workflows for AuditProgramme, AuditPlan, and AuditSchedule entities.
    /// Mirrors PerfomanceGovernanceSystemService pattern but adapted for multi-entity audit approvals.
    /// </summary>
    public interface IIQAAuditSignatoryService : IService
    {
        /// <summary>
        /// Get all signatory records for a specific audit entity type (Programme, Plan, or Schedule).
        /// </summary>
        Task<List<IQASignatoryDto>?> GetAllByAuditEntityTypeAsync(string auditEntityType, CancellationToken cancellationToken);

        /// <summary>
        /// Get signatory records by audit entity ID and type.
        /// </summary>
        Task<List<IQASignatoryDto>?> GetByAuditEntityIdAsync(string auditEntityType, int auditEntityId, CancellationToken cancellationToken);

        /// <summary>
        /// Get paginated signatory records with role-based filtering.
        /// </summary>
        Task<DtoPageList<IQASignatoryDto, IQASignatory, long>> GetPaginatedAsync(
            string auditEntityType,
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        /// <summary>
        /// Get signatory templates for an office, with inheritance from parent offices.
        /// </summary>
        Task<List<IQASignatoryTemplate>> GetInheritedTemplatesAsync(
            int officeId,
            string auditEntityType,
            CancellationToken cancellationToken);

        /// <summary>
        /// Process signatories for an audit entity and return DTO with workflow state.
        /// Handles draft detection, next-signatory identification, and role-based visibility.
        /// </summary>
        Task<IQASignatoryDto?> ProcessSignatoriesAsync(
            string auditEntityType,
            int auditEntityId,
            string userId,
            CancellationToken cancellationToken);

        /// <summary>
        /// Save or update signatory records for an audit entity.
        /// </summary>
        Task<IQASignatoryDto> SaveOrUpdateAsync(IQASignatoryDto dto, CancellationToken cancellationToken);

        /// <summary>
        /// Save or update from base DTO interface.
        /// </summary>
        Task SaveOrUpdateAsync<TEntity, TId>(BaseDto<TEntity, TId> dto, CancellationToken cancellationToken)
            where TEntity : Entity<TId>;

        /// <summary>
        /// Submit an audit entity for approval (move from Draft to Pending).
        /// Initializes the approval chain with first signatories.
        /// </summary>
        Task<bool> SubmitForApprovalAsync(
            string auditEntityType,
            int auditEntityId,
            string userId,
            CancellationToken cancellationToken);

        /// <summary>
        /// Approve/disapprove an audit entity at current signatory level.
        /// Advances to next signatory or completes workflow.
        /// </summary>
        Task<bool> ApproveOrDisapproveAsync(
            string auditEntityType,
            int auditEntityId,
            string signatoryId,
            bool approve,
            string? remarks,
            CancellationToken cancellationToken);

        /// <summary>
        /// Get the next pending signatory for an audit entity.
        /// </summary>
        Task<IQASignatoryDto?> GetNextSignatoryAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken);

        /// <summary>
        /// Reset approval chain on disapproval (remove all signatories and return to draft).
        /// </summary>
        Task<bool> ResetOnDisapprovalAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken);

        /// <summary>
        /// Get all audit entities pending approval for the current user based on their role.
        /// </summary>
        Task<List<dynamic>> GetPendingForCurrentUserAsync(
            string roleId,
            int page,
            int pageSize,
            CancellationToken cancellationToken);

        /// <summary>
        /// Check if an audit entity is in draft state (no signed signatories).
        /// </summary>
        Task<bool> IsDraftAsync(
            string auditEntityType,
            int auditEntityId,
            CancellationToken cancellationToken);
    }
}
