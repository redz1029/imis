using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ISATAnnualPerformanceCommitmentsModule;
using IMIS.Application.ISATSignatoryModule;
using IMIS.Application.ISATStrategicObjectiveSupportedModule;
using IMIS.Application.ISATStrategyContributionModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.ISATModule
{
    public class ReportISATDto : BaseDto<ISAT, long>
    {
        public int ISATPeriodId { get; set; }
        public PgsPeriodDto? ISATPeriod { get; set; }
        public string? PeriodCovered => ISATPeriod == null ? null : $"{ISATPeriod.StartDate:MMMM} to {ISATPeriod.EndDate:MMMM yyyy}";

        public required string EmployeeUserId { get; set; }
        public string? EmployeeName { get; set; }

        public int? OfficeId { get; set; }
        public OfficeDto? Office { get; set; }
        public string? OfficeName => Office?.Name;

        public required string ImmediateSupervisorUserId { get; set; }
        public string? ImmediateSupervisorName { get; set; }

        public string? Position { get; set; }

        public int? ServiceId { get; set; }
        public OfficeDto? Service { get; set; }
        public string? ServiceName => Service?.Name;

        public List<ISATStrategicObjectiveSupportedDto>? ISATStrategicObjectiveSupported { get; set; }
        public List<ISATStrategyContributionDto>? ISATStrategyContribution { get; set; }
        public List<ISATAnnualPerformanceCommitmentsDto>? ISATAnnualPerformanceCommitments { get; set; }

        public DateTime? PostingDate { get; set; }
        public List<ISATSignatoryDto>? ISATSignatories { get; set; }
        public bool IsDraft { get; set; }
        public ISATEmployeeProfileDto? EmployeeProfile { get; set; }

        // ---------------- Signatories ----------------

        private IEnumerable<ISATSignatoryDto> NonApprovedSignatories => ISATSignatories?.Where(s => s.Label != PerfomanceGovernanceSystemModule.PgsStatus.ApprovedBy) ?? Enumerable.Empty<ISATSignatoryDto>();
        private ISATSignatoryDto? ApprovedSignatory => ISATSignatories?.FirstOrDefault(s => s.Label == PerfomanceGovernanceSystemModule.PgsStatus.ApprovedBy);
        private ISATSignatoryDto? GetSignatory(int index) => NonApprovedSignatories.ElementAtOrDefault(index);

        // Labels
        public string? ISATSignatoryLabel1 => GetSignatory(0)?.Label;
        public string? ISATSignatoryLabel2 => GetSignatory(1)?.Label;
        public string? ISATSignatoryLabel3 => GetSignatory(2)?.Label;
        public string? ISATSignatoryLabel4 => GetSignatory(3)?.Label;
        // Approved By: always last
        public string? ISATSignatoryLabel5 => ApprovedSignatory?.Label;

        // Full names
        public string? ISATSignatoryName1 => GetSignatory(0)?.SignatoryName;
        public string? ISATSignatoryName2 => GetSignatory(1)?.SignatoryName;
        public string? ISATSignatoryName3 => GetSignatory(2)?.SignatoryName;
        public string? ISATSignatoryName4 => GetSignatory(3)?.SignatoryName;
        public string? ISATSignatoryName5 => ApprovedSignatory?.SignatoryName;

        private static string? FormatDateSigned(ISATSignatoryDto? s) => (s == null || s.DateSigned == default) ? null : s.DateSigned.ToString("MMMM dd, yyyy");  

        public string? ISATSignatoryDateSigned1 => FormatDateSigned(GetSignatory(0));
        public string? ISATSignatoryDateSigned2 => FormatDateSigned(GetSignatory(1));
        public string? ISATSignatoryDateSigned3 => FormatDateSigned(GetSignatory(2));
        public string? ISATSignatoryDateSigned4 => FormatDateSigned(GetSignatory(3));
        public string? ISATSignatoryDateSigned5 => FormatDateSigned(ApprovedSignatory);

        public ReportISATDto()
        {
        }

        [SetsRequiredMembers]
        public ReportISATDto(ISAT entity)
        {
            Id = entity.Id;
            ISATPeriodId = entity.ISATPeriodId;
            ISATPeriod = entity.ISATPeriod == null ? null : new PgsPeriodDto(entity.ISATPeriod);
            OfficeId = entity.OfficeId;
            Office = entity.Office == null ? null : new OfficeDto(entity.Office);
            EmployeeUserId = entity.EmployeeUserId;
            EmployeeName = FormatName(entity.EmployeeUser);
            ImmediateSupervisorUserId = entity.ImmediateSupervisorUserId;
            ImmediateSupervisorName = FormatName(entity.ImmediateSupervisorUser);
            Position = entity.Position;
            ServiceId = entity.ServiceId;
            Service = entity.Service == null ? null : new OfficeDto(entity.Service);
            PostingDate = entity.PostingDate;
            ISATStrategicObjectiveSupported = entity.ISATStrategicObjectiveSupported?.Select(x => new ISATStrategicObjectiveSupportedDto(x)).ToList();
            ISATStrategyContribution = entity.ISATStrategyContribution?.Select(x => new ISATStrategyContributionDto(x)).ToList();
            ISATAnnualPerformanceCommitments = entity.ISATAnnualPerformanceCommitments?.Select(x => new ISATAnnualPerformanceCommitmentsDto(x)).ToList();
            ISATSignatories = entity.ISATSignatories?.Select(x => new ISATSignatoryDto(x)).ToList();

            if (ISATSignatories != null)
            {
                var approved = ISATSignatories.FirstOrDefault(s => s.Label == PerfomanceGovernanceSystemModule.PgsStatus.ApprovedBy);
                if (approved != null)
                {
                    ISATSignatories.Remove(approved);
                    ISATSignatories.Add(approved);
                }
            }
        }

        public override ISAT ToEntity()
        {
            return new ISAT
            {
                Id = Id,
                ISATPeriodId = ISATPeriodId,
                OfficeId = OfficeId,
                EmployeeUserId = EmployeeUserId,
                ImmediateSupervisorUserId = ImmediateSupervisorUserId,
                Position = Position,
                ServiceId = ServiceId,
                PostingDate = PostingDate,
                ISATStrategicObjectiveSupported = ISATStrategicObjectiveSupported?.Select(x => x.ToEntity()).ToList(),
                ISATStrategyContribution = ISATStrategyContribution?.Select(x => x.ToEntity()).ToList(),
                ISATAnnualPerformanceCommitments = ISATAnnualPerformanceCommitments?.Select(x => x.ToEntity()).ToList(),
            };
        }

        private static string? FormatName(User? user) => ISATSignatoryDto.FormatFullName(user);
    }
}