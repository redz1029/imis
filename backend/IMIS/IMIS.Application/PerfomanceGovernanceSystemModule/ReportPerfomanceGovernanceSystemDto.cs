using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsDeliverableModule;
using IMIS.Application.PgsModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Application.PGSReadinessRatingCancerCareModule;
using IMIS.Application.PgsSignatoryModule;
using IMIS.Application.PgsSignatoryTemplateModule;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public class ReportPerfomanceGovernanceSystemDto : BaseDto<PerfomanceGovernanceSystem, long>
    {
        public required PgsPeriodDto PgsPeriod { get; set; }
        public DateOnly StartDate => PgsPeriod.StartDate; 
        public DateOnly EndDate => PgsPeriod.EndDate; 
        public required OfficeDto Office { get; set; }
        public string? OfficeName => Office?.Name; 
        public string? Remarks { get; set; }   
        public List<ReportPGSDeliverableDto>? PgsDeliverables { get; set; }
        public PgsReadinessRatingDto? PgsReadinessRating { get; set; }
        public double CompetenceToDeliver => PgsReadinessRating!.CompetenceToDeliver;
        public double ResourceAvailability => PgsReadinessRating!.ResourceAvailability;
        public double ConfidenceToDeliver => PgsReadinessRating!.ConfidenceToDeliver;     
        public required double PercentDeliverables { get; set; }     
        public List<ReportPgsSignatoryDto>? PgsSignatories { get; set; }

        public string? PgsSignatoryLabel1 =>
            PgsSignatories != null && PgsSignatories.Count >= 1 && PgsSignatories[0].PgsSignatoryTemplate != null // -- Map Signatories: SignatoryLabel
            ? PgsSignatories[0].PgsSignatoryTemplate!.SignatoryLabel
            : null;

        public string? PgsSignatoryLabel2 =>
            PgsSignatories != null && PgsSignatories.Count >= 2 && PgsSignatories[1].PgsSignatoryTemplate != null // -- Map Signatories: SignatoryLabel
            ? PgsSignatories[1].PgsSignatoryTemplate!.SignatoryLabel
            : null;

        public string? PgsSignatoryLabel3 =>
            PgsSignatories != null && PgsSignatories.Count >= 3 && PgsSignatories[2].PgsSignatoryTemplate != null // -- Map Signatories: SignatoryLabel
            ? PgsSignatories[2].PgsSignatoryTemplate!.SignatoryLabel
            : null;

        public string? PgsSignatoryId1 =>
            PgsSignatories != null && PgsSignatories.Count >= 1 && PgsSignatories[0].User != null // -- Map Signatories: User FirstName, MiddleName, LastName
            ? PgsSignatories[0].User!.FirstName +' '+ PgsSignatories[0].User!.MiddleName +' '+ PgsSignatories[0].User!.LastName
            : null;

        public string? PgsSignatoryId2 =>
            PgsSignatories != null && PgsSignatories.Count >= 2 && PgsSignatories[1].User != null // -- Map Signatories: User FirstName, MiddleName, LastName
            ? PgsSignatories[1].User!.FirstName + ' ' + PgsSignatories[1].User!.MiddleName + ' ' + PgsSignatories[1].User!.LastName
            : null;

        public string? PgsSignatoryId3 =>
            PgsSignatories != null && PgsSignatories.Count >= 3 && PgsSignatories[2].User != null // -- Map Signatories: User FirstName, MiddleName, LastName
            ? PgsSignatories[2].User!.FirstName + ' ' + PgsSignatories[2].User!.MiddleName + ' ' + PgsSignatories[2].User!.LastName
            : null;

        public ReportPerfomanceGovernanceSystemDto() { }
        [SetsRequiredMembers]
        public ReportPerfomanceGovernanceSystemDto(PerfomanceGovernanceSystem perfomanceGovernanceSystem, List<User> users)
        {
            this.Id = perfomanceGovernanceSystem.Id;
            this.Remarks = perfomanceGovernanceSystem.Remarks;
            this.PgsPeriod = perfomanceGovernanceSystem.PgsPeriod != null ? new PgsPeriodDto(perfomanceGovernanceSystem.PgsPeriod) : null;
            this.Office = perfomanceGovernanceSystem.Office != null ? new OfficeDto(perfomanceGovernanceSystem.Office) : null;          
            this.PgsDeliverables = perfomanceGovernanceSystem.PgsDeliverables?.Select(d => new ReportPGSDeliverableDto(d)).ToList();
            this.PgsReadinessRating = perfomanceGovernanceSystem.PgsReadinessRating != null ? new PgsReadinessRatingDto(perfomanceGovernanceSystem.PgsReadinessRating) : null;
            this.PgsSignatories = perfomanceGovernanceSystem.PgsSignatories?
            .Select(s =>
            {
                var user = users.FirstOrDefault(u => u.Id == s.SignatoryId); 
                return new ReportPgsSignatoryDto
                {
                    Id = s.Id,
                    PgsId = s.PgsId,
                    PgsSignatoryTemplateId = s.PgsSignatoryTemplateId,
                    SignatoryId = s.SignatoryId,
                    DateSigned = s.DateSigned,
                    PgsSignatoryTemplate = s.PgsSignatoryTemplate != null
                        ? new PgsSignatoryTemplateDto
                        {
                            Id = s.PgsSignatoryTemplate.Id,
                            SignatoryLabel = s.PgsSignatoryTemplate.SignatoryLabel,
                        }
                        : null,
                        User = user != null
                        ? new User
                        {
                            Id = user.Id,
                            FirstName = user.FirstName,
                            MiddleName = user.MiddleName,
                            LastName = user.LastName,
                            Prefix = user.Prefix,
                            Suffix = user.Suffix,
                            Position = user.Position,                            
                        }
                        : null
                };
            }).ToList();
        }
        public override PerfomanceGovernanceSystem ToEntity()
        {
            return new PerfomanceGovernanceSystem()
            {
                Id = Id,
                PgsPeriod = PgsPeriod.ToEntity(),
                Office = Office.ToEntity(),
                Remarks = Remarks,
                PgsDeliverables = PgsDeliverables?.Select(d => d.ToEntity()).ToList(),
                PgsReadinessRating = PgsReadinessRating!.ToEntity(),
                PercentDeliverables = PercentDeliverables,               
                PgsSignatories = PgsSignatories?.Select(s => s.ToEntity()).ToList()
            };
        }
    }
}
