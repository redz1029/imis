using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Application.ISATAnnualPerformanceCommitmentsModule;
using IMIS.Application.ISATSignatoryModule;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.ISATModule
{
    public class ISATDto : BaseDto<ISAT, long>
    {
        public int ISATPeriodId { get; set; }
        public PgsPeriodDto? ISATPeriod { get; set; }

        public required string EmployeeUserId { get; set; }
        public string? EmployeeName { get; set; }

        public int? OfficeId { get; set; }
        public OfficeDto? Office { get; set; }

        public required string ImmediateSupervisorUserId { get; set; }
        public string? ImmediateSupervisorName { get; set; }

        public string? Position { get; set; }

        public int? ServiceId { get; set; }
        public OfficeDto? Service { get; set; }
        
        public List<ISATAnnualPerformanceCommitmentsDto>? ISATAnnualPerformanceCommitments { get; set; }

        public DateTime? PostingDate { get; set; }
        public List<ISATSignatoryDto>? ISATSignatories { get; set; }
        public bool IsDraft { get; set; }


        public ISATDto()
        {
        }

        [SetsRequiredMembers]
        public ISATDto(ISAT entity)
        {
            Id = entity.Id;
            ISATPeriodId = entity.ISATPeriodId;
            ISATPeriod = entity.ISATPeriod == null ? null : new PgsPeriodDto(entity.ISATPeriod);
            OfficeId = entity.OfficeId;
            Office = entity.Office == null ? null : new OfficeDto(entity.Office);
            EmployeeUserId = entity.EmployeeUserId;
            EmployeeName = entity.EmployeeUser == null ? null : FormatName(entity.EmployeeUser);
            ImmediateSupervisorUserId = entity.ImmediateSupervisorUserId;
            ImmediateSupervisorName = entity.ImmediateSupervisorUser == null ? null : FormatName(entity.ImmediateSupervisorUser);
            Position = entity.Position;
            ServiceId = entity.ServiceId;
            Service = entity.Service == null ? null : new OfficeDto(entity.Service);
            PostingDate = entity.PostingDate;
            ISATAnnualPerformanceCommitments = entity.ISATAnnualPerformanceCommitments?.Select(x => new ISATAnnualPerformanceCommitmentsDto(x)).ToList();
            ISATSignatories = entity.ISATSignatories?.Select(x => new ISATSignatoryDto(x)).ToList();
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
                ISATAnnualPerformanceCommitments = ISATAnnualPerformanceCommitments?.Select(x => x.ToEntity()).ToList(),
            };
        }

        private static string FormatName(User user)
        {
            return string.Join(" ", new[]
            {
                user.FirstName,
                user.MiddleName,
                user.LastName,
                user.Suffix
            }.Where(s => !string.IsNullOrWhiteSpace(s)));
        }
    }
}