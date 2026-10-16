using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsDeliverableModule;
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
        public string? PgsPeriodRemarks => PgsPeriod?.Remarks;
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

           
        private IEnumerable<ReportPgsSignatoryDto> NonApprovedSignatories => PgsSignatories?.Where(s => s.PgsSignatoryTemplate?.SignatoryLabel != PgsStatus.ApprovedBy) ?? Enumerable.Empty<ReportPgsSignatoryDto>();
        
        //Sigantory Label      
        public string? PgsSignatoryLabel1 =>
            NonApprovedSignatories.ElementAtOrDefault(0)?.PgsSignatoryTemplate?.SignatoryLabel;

        public string? PgsSignatoryLabel2 =>
            NonApprovedSignatories.ElementAtOrDefault(1)?.PgsSignatoryTemplate?.SignatoryLabel;

        public string? PgsSignatoryLabel3 =>
            NonApprovedSignatories.ElementAtOrDefault(2)?.PgsSignatoryTemplate?.SignatoryLabel;

        public string? PgsSignatoryLabel4 =>
            NonApprovedSignatories.ElementAtOrDefault(3)?.PgsSignatoryTemplate?.SignatoryLabel;

        // Approved By: always last
        public string? PgsSignatoryLabel5 =>
            PgsSignatories?.FirstOrDefault(s => s.PgsSignatoryTemplate?.SignatoryLabel == PgsStatus.ApprovedBy)
                ?.PgsSignatoryTemplate?.SignatoryLabel;

        
        // Get Full Names       
        public string? PgsSignatoryId1 =>
            FormatUserFullName(NonApprovedSignatories.ElementAtOrDefault(0)?.User);

        public string? PgsSignatoryId2 =>
            FormatUserFullName(NonApprovedSignatories.ElementAtOrDefault(1)?.User);

        public string? PgsSignatoryId3 =>
            FormatUserFullName(NonApprovedSignatories.ElementAtOrDefault(2)?.User);

        public string? PgsSignatoryId4 =>
            FormatUserFullName(NonApprovedSignatories.ElementAtOrDefault(3)?.User);

        // Approved By: always last
        public string? PgsSignatoryId5 =>
            FormatUserFullName(
                PgsSignatories?.FirstOrDefault(s => s.PgsSignatoryTemplate?.SignatoryLabel == PgsStatus.ApprovedBy)?.User
            );
      
        // Signatory Positions       
        public string? PgsSignatoryPosition1 =>
            NonApprovedSignatories.ElementAtOrDefault(0)?.PgsSignatoryTemplate?.Position
            ?? NonApprovedSignatories.ElementAtOrDefault(0)?.User?.Position;

        public string? PgsSignatoryPosition2 =>
            NonApprovedSignatories.ElementAtOrDefault(1)?.PgsSignatoryTemplate?.Position
            ?? NonApprovedSignatories.ElementAtOrDefault(1)?.User?.Position;

        public string? PgsSignatoryPosition3 =>
            NonApprovedSignatories.ElementAtOrDefault(2)?.PgsSignatoryTemplate?.Position
            ?? NonApprovedSignatories.ElementAtOrDefault(2)?.User?.Position;

        public string? PgsSignatoryPosition4 =>
            NonApprovedSignatories.ElementAtOrDefault(3)?.PgsSignatoryTemplate?.Position
            ?? NonApprovedSignatories.ElementAtOrDefault(3)?.User?.Position;

        // Approved By: always last
        public string? PgsSignatoryPosition5 =>
            PgsSignatories?.FirstOrDefault(s => s.PgsSignatoryTemplate?.SignatoryLabel == PgsStatus.ApprovedBy)?.PgsSignatoryTemplate?.Position
            ?? PgsSignatories?.FirstOrDefault(s => s.PgsSignatoryTemplate?.SignatoryLabel == PgsStatus.ApprovedBy)?.User?.Position;


        // Helper for name format
        private static string? FormatUserFullName(User? user)
        {
            if (user == null) return null;
            return $"{user.Prefix} {user.FirstName} {user.MiddleName} {user.LastName}".Trim();
        }

        public ReportPerfomanceGovernanceSystemDto() { }
        [SetsRequiredMembers]
        public ReportPerfomanceGovernanceSystemDto(PerfomanceGovernanceSystem perfomanceGovernanceSystem, List<User> users)
        {
            this.Id = perfomanceGovernanceSystem.Id;
            this.Remarks = perfomanceGovernanceSystem.Remarks;
            this.PgsPeriod = new PgsPeriodDto(perfomanceGovernanceSystem.PgsPeriod);
            this.PercentDeliverables = perfomanceGovernanceSystem.PercentDeliverables;
            this.Office = new OfficeDto(perfomanceGovernanceSystem.Office);
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
                            Position = s.PgsSignatoryTemplate.Position
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
            })
            .ToList();

            if (this.PgsSignatories != null)
            {
                var approved = this.PgsSignatories
                    .FirstOrDefault(s => s.PgsSignatoryTemplate?.SignatoryLabel == PgsStatus.ApprovedBy);

                if (approved != null)
                {
                    this.PgsSignatories.Remove(approved);
                    this.PgsSignatories.Add(approved); 
                }
            }

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


