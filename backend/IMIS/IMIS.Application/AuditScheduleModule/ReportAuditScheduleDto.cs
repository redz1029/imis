//using System;
//using System.Collections.Generic;
//using System.Diagnostics.CodeAnalysis;
//using System.Linq;
//using Base.Primitives;
//using IMIS.Domain;

//namespace IMIS.Application.AuditScheduleModule
//{
//    public class ReportAuditScheduleDto : BaseDto<AuditSchedule, int>
//    {
//        public string AuditTitle { get; set; } = string.Empty;
//        public string Purpose { get; set; } = string.Empty;
//        public bool IsActive { get; set; }

//        public DateTime StartDate { get; set; }
//        public DateTime EndDate { get; set; }
//        public string BatchFormattedDates { get; set; } = string.Empty;

//        // Assigned Auditor Team
//        public string AuditorTeamName { get; set; } = string.Empty;

//        // Aggregated summary of offices being audited for report headers
//        public string FormattedAuditableOffices { get; set; } = string.Empty;

//        // Inherited fields from parent AuditPlan (if navigation is loaded)
//        public int AuditPlanId { get; set; }
//        public string PlanStatus { get; set; } = string.Empty;
//        public string AuditPlanObjective { get; set; } = string.Empty;
//        public string ScopeOfAudit { get; set; } = string.Empty;

//        // Signature block for printable report output
//        public string PreparedByName { get; set; } = string.Empty;
//        public string PreparedByDate { get; set; } = string.Empty;
//        public string ApprovedByName { get; set; } = string.Empty;
//        public string ApprovedByDate { get; set; } = string.Empty;

//        // FLAT list — formatted for FastReport DataBand binding
//        public List<ReportScheduleDetailEntryDto> FlatEntries { get; set; } = new();

//        public ReportAuditScheduleDto() { }

//        [SetsRequiredMembers]
//        public ReportAuditScheduleDto(AuditSchedule entity)
//        {
//            Id = entity.Id;
//            AuditTitle = entity.AuditTitle ?? string.Empty;
//            Purpose = entity.Purpose ?? string.Empty;
//            IsActive = entity.IsActive;

//            StartDate = entity.StartDate;
//            EndDate = entity.EndDate;
//            BatchFormattedDates = FormatDateRange(entity.StartDate, entity.EndDate);

//            IsDeleted = entity.IsDeleted;
//            RowVersion = entity.RowVersion;

//            // Map Team details
//            if (entity.AuditorTeams != null)
//            {
//                AuditorTeamName = entity.AuditorTeams.Name ?? string.Empty;
//            }

//            // Aggregate Auditable Offices into a printable string
//            if (entity.AuditableOffices != null && entity.AuditableOffices.Any())
//            {
//                var officeNames = entity.AuditableOffices
//                    .Select(o => o.Office != null ? o.Office.Name : $"Office {o.OfficeId}")
//                    .Where(n => !string.IsNullOrWhiteSpace(n));

//                FormattedAuditableOffices = string.Join(", ", officeNames);
//            }
//            else
//            {
//                FormattedAuditableOffices = "N/A";
//            }

//            // Map Parent AuditPlan details if loaded
//            if (entity.AuditPlan != null)
//            {
//                AuditPlanId = entity.AuditPlanId;
//                PlanStatus = entity.AuditPlan.PlanStatus ?? "Draft";

//                // Pull Objective/Scope from Programme via AuditPlan parent
//                AuditPlanObjective = entity.AuditPlan.AuditProgramme?.AuditPlanObjective ?? string.Empty;
//                ScopeOfAudit = entity.AuditPlan.AuditProgramme?.ScopeOfAudit ?? string.Empty;

//                // Signature details resolved through parent AuditPlan
//                PreparedByName = ResolvePreparerName(entity.AuditPlan.Preparer);
//                PreparedByDate = entity.AuditPlan.CreatedDate.ToString("MMMM dd, yyyy");

//                var latestApproval = entity.AuditPlan.Approvals?
//                    .Where(a => string.Equals(a.Action, "Approved", StringComparison.OrdinalIgnoreCase))
//                    .OrderByDescending(a => a.Timestamp)
//                    .FirstOrDefault();

//                if (latestApproval != null)
//                {
//                    ApprovedByName = ResolveUserName(latestApproval.Approver);
//                    ApprovedByDate = latestApproval.Timestamp.ToString("MMMM dd, yyyy");
//                }
//            }

//            // Flatten schedule details into print-ready entries
//            if (entity.AuditSchduleDetails != null)
//            {
//                foreach (var detail in entity.AuditSchduleDetails.OrderBy(d => d.StartTime))
//                {
//                    string auditorName = ResolveAuditorName(detail.Auditor);
//                    if (string.IsNullOrWhiteSpace(auditorName))
//                    {
//                        auditorName = !string.IsNullOrWhiteSpace(AuditorTeamName) ? AuditorTeamName : "Unassigned";
//                    }

//                    FlatEntries.Add(new ReportScheduleDetailEntryDto
//                    {
//                        Id = detail.Id,
//                        Activity = detail.Activity ?? string.Empty,
//                        FormattedDate = detail.StartTime.ToString("MMMM dd, yyyy"),
//                        FormattedTimeRange = $"{detail.StartTime:hh:mm tt} - {detail.EndTime:hh:mm tt}",
//                        FormattedAuditor = auditorName
//                    });
//                }
//            }
//        }

//        public override AuditSchedule ToEntity()
//        {
//            return new AuditSchedule
//            {
//                Id = Id,
//                AuditTitle = AuditTitle,
//                Purpose = Purpose,
//                IsActive = IsActive,
//                StartDate = StartDate,
//                EndDate = EndDate,
//                AuditPlanId = AuditPlanId,
//                IsDeleted = IsDeleted,
//                RowVersion = RowVersion
//            };
//        }

//        private static string ResolvePreparerName(IsoAuditor? preparer)
//        {
//            return ResolveAuditorName(preparer?.IsoAuditors);
//        }

//        private static string ResolveAuditorName(Auditor? auditor)
//        {
//            return ResolveUserName(auditor?.User);
//        }

//        private static string ResolveUserName(User? user)
//        {
//            if (user == null) return string.Empty;

//            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
//                .Where(p => !string.IsNullOrWhiteSpace(p));

//            return string.Join(" ", parts);
//        }

//        private static string FormatDateRange(DateTime start, DateTime end)
//        {
//            if (start.Month == end.Month && start.Year == end.Year)
//            {
//                if (start.Day == end.Day) return $"{start:MMMM dd, yyyy}";
//                return $"{start:MMMM d} – {end:d, yyyy}";
//            }
//            return $"{start:MMMM dd, yyyy} - {end:MMMM dd, yyyy}";
//        }
//    }

//    /// <summary>
//    /// Flat entry item used by FastReport DataBands.
//    /// </summary>
//    public class ReportScheduleDetailEntryDto
//    {
//        public int Id { get; set; }
//        public string Activity { get; set; } = string.Empty;
//        public string FormattedDate { get; set; } = string.Empty;
//        public string FormattedTimeRange { get; set; } = string.Empty;
//        public string FormattedAuditor { get; set; } = string.Empty;
//    }
//}