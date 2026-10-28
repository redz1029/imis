using IMIS.Application.AuditChecklistModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.AuditChecklistModule
{
    /// <summary>
    /// Checklist -> NCAR: every non-conforming checklist row raises exactly one
    /// NCAR addressed to the audited office; conforming rows raise none. The
    /// NCAR is linked to its row (unique), so saving a checklist again never
    /// raises a second NCAR for the same clause.
    /// </summary>
    public partial class AuditChecklistService
    {
        public async Task<(bool Success, string? Error)> SaveChecklistForUserAsync(
            AuditChecklistDto dto, string? userId, CancellationToken cancellationToken)
        {
            // The row and its NCAR are written together: a blocked NCAR change
            // rolls the row change back with it.
            await using var transaction = await _dbContext.Database
                .BeginTransactionAsync(cancellationToken)
                .ConfigureAwait(false);

            var (success, error) = await SaveChecklistRowForUserAsync(dto, userId, cancellationToken).ConfigureAwait(false);
            if (!success) return (false, error);

            (success, error) = await SyncNcarAsync(dto, userId, cancellationToken).ConfigureAwait(false);
            if (!success) return (false, error);

            await AttachNcarsAsync(new[] { dto }, cancellationToken).ConfigureAwait(false);
            await transaction.CommitAsync(cancellationToken).ConfigureAwait(false);
            return (true, null);
        }

        /// <summary>Fills NcarId / NcarReferenceNumber on the rows that have a live NCAR.</summary>
        private async Task AttachNcarsAsync(IReadOnlyCollection<AuditChecklistDto> rows, CancellationToken cancellationToken)
        {
            var rowIds = rows.Select(r => r.Id).ToList();
            var ncars = await _dbContext.Set<NonconformingActionReport>()
                .AsNoTracking()
                .Where(n => n.AuditChecklistId != null && rowIds.Contains(n.AuditChecklistId.Value))
                .Select(n => new { ChecklistId = n.AuditChecklistId!.Value, n.Id, n.ReferenceNumber })
                .ToDictionaryAsync(n => n.ChecklistId, cancellationToken)
                .ConfigureAwait(false);

            foreach (var row in rows)
            {
                var found = ncars.TryGetValue(row.Id, out var ncar);
                row.NcarId = found ? ncar!.Id : null;
                row.NcarReferenceNumber = found ? ncar!.ReferenceNumber : null;
            }
        }

        private async Task<(bool Success, string? Error)> SyncNcarAsync(
            AuditChecklistDto dto, string? userId, CancellationToken cancellationToken)
        {
            // Includes a voided NCAR: its link is still taken, so it is revived
            // rather than a second one being raised.
            var ncar = await _dbContext.Set<NonconformingActionReport>()
                .IgnoreQueryFilters()
                .FirstOrDefaultAsync(n => n.AuditChecklistId == dto.Id, cancellationToken)
                .ConfigureAwait(false);
            var hasLiveNcar = ncar != null && !ncar.IsDeleted;

            if (dto.Conforming != false)
            {
                if (!hasLiveNcar) return (true, null);

                if (await IsNcarProcessedAsync(ncar!, cancellationToken).ConfigureAwait(false))
                    return (false, $"NCAR {ncar!.ReferenceNumber} for this clause was already acknowledged or answered by the office, so the clause can no longer be changed back from Non-Conforming.");

                ncar!.IsDeleted = true;
                await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
                return (true, null);
            }

            var source = await LoadNcarSourceAsync(dto.Id, cancellationToken).ConfigureAwait(false);
            if (source == null) return (false, "Checklist item not found.");

            // The finding is the auditor's remark; a row saved without one falls
            // back to the requirement that was not met.
            var findings = string.IsNullOrWhiteSpace(dto.FindingAndRemarks)
                ? source.Question
                : dto.FindingAndRemarks.Trim();

            if (ncar != null)
            {
                if (hasLiveNcar && ncar.AuditFindings != findings &&
                    await IsNcarProcessedAsync(ncar, cancellationToken).ConfigureAwait(false))
                    return (false, $"NCAR {ncar.ReferenceNumber} for this clause was already acknowledged or answered by the office, so its finding can no longer be edited.");

                ncar.IsDeleted = false;
                ncar.AuditFindings = findings;
                await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
                return (true, null);
            }

            if (string.IsNullOrWhiteSpace(userId))
                return (false, "Unable to identify the signed-in user to issue the NCAR.");

            // The office head acknowledges the NCAR; until one is set up for the
            // office the issuing auditor stands in (the office replaces it when
            // it acknowledges).
            var auditeeUserId = await FindOfficeHeadUserIdAsync(source.OfficeIds, cancellationToken).ConfigureAwait(false);

            _dbContext.Set<NonconformingActionReport>().Add(new NonconformingActionReport
            {
                Id = 0,
                ReferenceNumber = $"NCAR-{DateTime.UtcNow:yyyy}-{source.AuditScheduleId:D4}-{dto.Id:D5}",
                Office = source.OfficeName,
                RelevantStandard = source.ClauseRef,
                AuditDate = source.AuditDate,

                IsInternalAudit = true,
                IsNonconformity = true,

                StandardRequirement = source.Question,
                LegalOrPolicyReference = string.Empty,
                AuditFindings = findings,

                AuditChecklistId = dto.Id,

                IssuedByAuditorUserId = userId,
                IssuedDate = DateTime.UtcNow,
                AcknowledgedByAuditeeUserId = auditeeUserId ?? userId,

                IsActive = true,
                IsClosed = false
            });
            await _dbContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);
            return (true, null);
        }

        /// <summary>An NCAR the office has started working on is no longer the auditor's to change.</summary>
        private async Task<bool> IsNcarProcessedAsync(NonconformingActionReport ncar, CancellationToken cancellationToken)
        {
            if (ncar.IsClosed || ncar.AcknowledgedDate != null || ncar.ProposedDate != null ||
                ncar.ApprovedDate != null || ncar.VerifiedDate != null || ncar.ValidatedDate != null)
                return true;

            return await _dbContext.Set<NcarRootCause>().AnyAsync(r => r.NonconformingActionReportId == ncar.Id, cancellationToken).ConfigureAwait(false)
                || await _dbContext.Set<NcarCorrectionAction>().AnyAsync(c => c.NonconformingActionReportId == ncar.Id, cancellationToken).ConfigureAwait(false)
                || await _dbContext.Set<NcarCorrectiveAction>().AnyAsync(c => c.NonconformingActionReportId == ncar.Id, cancellationToken).ConfigureAwait(false);
        }

        private sealed class NcarSource
        {
            public int AuditScheduleId { get; init; }
            public string Question { get; init; } = string.Empty;
            public string ClauseRef { get; init; } = string.Empty;
            public DateTime AuditDate { get; init; }
            public string OfficeName { get; init; } = string.Empty;
            public List<int> OfficeIds { get; init; } = new();
        }

        private async Task<NcarSource?> LoadNcarSourceAsync(int checklistId, CancellationToken cancellationToken)
        {
            var row = await _dbContext.Set<AuditChecklist>()
                .AsNoTracking()
                .Where(c => c.Id == checklistId && !c.IsDeleted)
                .Select(c => new
                {
                    c.AuditScheduleId,
                    c.AuditPlanEntryId,
                    Question = c.AuditChecklistQNA!.Question,
                    ClauseRef = c.AuditChecklistQNA.IsoStandard!.ClauseRef,
                    AuditDate = c.AuditPlanEntry!.Time
                })
                .FirstOrDefaultAsync(cancellationToken)
                .ConfigureAwait(false);
            if (row == null) return null;

            // Audited office: the schedule's auditable offices first, otherwise
            // the audit plan entry's processes (same rule as the checklist list).
            var offices = await _dbContext.Set<AuditableOffices>()
                .AsNoTracking()
                .Where(o => o.AuditScheduleId == row.AuditScheduleId)
                .Select(o => new { OfficeId = (int?)o.OfficeId, o.Office!.Name })
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);
            if (offices.Count == 0)
            {
                offices = await _dbContext.Set<AuditPlanProcess>()
                    .AsNoTracking()
                    .Where(p => p.AuditPlanEntryId == row.AuditPlanEntryId)
                    .Select(p => new { p.OfficeId, Name = p.Office != null ? p.Office.Name : p.ProcessName! })
                    .ToListAsync(cancellationToken)
                    .ConfigureAwait(false);
            }

            return new NcarSource
            {
                AuditScheduleId = row.AuditScheduleId,
                Question = row.Question,
                ClauseRef = row.ClauseRef.Trim(),
                AuditDate = row.AuditDate,
                OfficeName = string.Join(", ", offices
                    .Select(o => o.Name)
                    .Where(n => !string.IsNullOrWhiteSpace(n))
                    .Distinct()),
                OfficeIds = offices
                    .Where(o => o.OfficeId.HasValue)
                    .Select(o => o.OfficeId!.Value)
                    .Distinct()
                    .ToList()
            };
        }

        private Task<string?> FindOfficeHeadUserIdAsync(List<int> officeIds, CancellationToken cancellationToken)
        {
            return (from uo in _dbContext.Set<UserOffices>()
                    join u in _dbContext.Set<User>() on uo.UserId equals u.Id
                    where officeIds.Contains(uo.OfficeId) && uo.IsOfficeHead && uo.IsActive
                    select uo.UserId)
                .FirstOrDefaultAsync(cancellationToken);
        }
    }
}
