using Base.Primitives;
using System;
using System.Collections.Generic;

namespace IMIS.Domain
{
    public class AuditSchedule : Entity<int>
    {
        public required string Purpose { get; set; }
        public required string Activity { get; set; }

        public required bool IsActive { get; set; }

        // Fix: dates now sourced from the parent AuditPlan
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        // Fix: Explicit FK back to the parent AuditPlan
        public int AuditPlanId { get; set; }
        public AuditPlan? AuditPlan { get; set; }

        public ICollection<AuditableOffices>? AuditableOffices { get; set; }
        public ICollection<AuditScheduleDetails>? AuditSchduleDetails { get; set; }
        public required int AuditPlanEntryId { get; set; }
        public AuditPlanEntry? AuditPlanEntry { get; set; }

        public int? TeamId { get; set; }
        public Team? Team { get; set; }

        /// <summary>
        /// IQA Signatory records for this audit schedule (approval workflow)
        /// </summary>
        public ICollection<IQASignatory> IQASignatories { get; set; } = new List<IQASignatory>();
    }
}