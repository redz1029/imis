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
    public class ISATDto : BaseDto<ISAT, long>
    {
        public int ISATPeriodId { get; set; }
        public PgsPeriodDto? ISATPeriod { get; set; }

        public required string EmployeeUserId { get; set; }
        public int? OfficeId { get; set; }
        public OfficeDto? Office { get; set; }

        public List<ISATStrategicObjectiveSupportedDto>? ISATStrategicObjectiveSupported { get; set; }

        public List<ISATStrategyContributionDto>? ISATStrategyContribution { get; set; }

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
            PostingDate = entity.PostingDate;
            ISATStrategicObjectiveSupported = entity.ISATStrategicObjectiveSupported?.Select(x => new ISATStrategicObjectiveSupportedDto(x)).ToList();
            ISATStrategyContribution = entity.ISATStrategyContribution?.Select(x => new ISATStrategyContributionDto(x)).ToList();
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
                PostingDate = PostingDate,
                ISATStrategicObjectiveSupported = ISATStrategicObjectiveSupported?.Select(x => x.ToEntity()).ToList(),
                ISATStrategyContribution = ISATStrategyContribution?.Select(x => x.ToEntity()).ToList(),
                ISATAnnualPerformanceCommitments = ISATAnnualPerformanceCommitments?.Select(x => x.ToEntity()).ToList(),
            };
        }
    }
}

