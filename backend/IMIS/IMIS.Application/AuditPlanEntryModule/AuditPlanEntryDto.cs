using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditPlanEntryModule
{
    public class AuditPlanEntryDto : BaseDto<AuditPlanEntry, int>
    {
        public required int AuditPlanId { get; set; }
        public required int DayNumber { get; set; }
        public required DateTime Time { get; set; }
        public int? OfficeId { get; set; }
        public string? OfficeName { get; set; }
        public string? TeamName { get; set; }

        // Corrected naming to match standard casing and fixed the 'Responsible' typo
        public List<AuditPlanProcess> AuditPlanProcesses { get; set; } = new();
        public List<User> Auditors { get; set; } = new();
        public List<AuditPlanPersonResponsible> ResponsiblePersons { get; set; } = new();
        public List<IsoStandard> IsoStandards { get; set; } = new();

        public AuditPlanEntryDto() { }

        [SetsRequiredMembers]
        public AuditPlanEntryDto(AuditPlanEntry entity)
        {
            this.Id = entity.Id;
            this.AuditPlanId = entity.AuditPlanId;
            this.DayNumber = entity.DayNumber;
            this.Time = entity.Time;
            this.OfficeId = entity.OfficeId;
            this.OfficeName = entity.Office?.Name;
            this.TeamName = entity.Team?.Name;
            this.IsDeleted = entity.IsDeleted;
            this.RowVersion = entity.RowVersion;

            // Map collections
            this.AuditPlanProcesses = entity.AuditPlanProcesses ?? new();
            this.Auditors = entity.Auditors ?? new();
            this.ResponsiblePersons = entity.ResposiblePersons ?? new(); // Mapping typo from domain to fixed DTO name
            this.IsoStandards = entity.IsoStandards ?? new();
        }

        public override AuditPlanEntry ToEntity()
        {
            return new AuditPlanEntry()
            {
                Id = this.Id,
                AuditPlanId = this.AuditPlanId,
                DayNumber = this.DayNumber,
                Time = this.Time,
                OfficeId = this.OfficeId,
                IsDeleted = this.IsDeleted,
                RowVersion = this.RowVersion,

                // Navigation collections mapping
                AuditPlanProcesses = this.AuditPlanProcesses,
                Auditors = this.Auditors,
                ResposiblePersons = this.ResponsiblePersons,
                IsoStandards = this.IsoStandards,

                // Satisfying required domain property
                Team = null
            };
        }
    }
}