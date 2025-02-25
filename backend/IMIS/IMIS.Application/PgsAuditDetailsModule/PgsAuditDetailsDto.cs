using Base.Primitives;
using IMIS.Application.OfficeModule;
using IMIS.Application.PgsPeriodModule;
using IMIS.Domain;

namespace IMIS.Application.PgsModule
{
    public class PgsAuditDetailsDto : BaseDto<PgsAuditDetails, long>
    {
        public PgsPeriodDto? PgsPeriod { get; set; }  
        public required OfficeDto Office { get; set; } 
        public PgsStatus Status { get; set; }
        public required string Remarks { get; set; }
        public List<PGSDeliverableDto>? PgsDeliverables { get; set; }

        public override PgsAuditDetails ToEntity()
        {
            return new PgsAuditDetails()
            {
                Id = Id,
                Status = Status,
                Remarks = Remarks,
                PgsPeriod = PgsPeriod?.ToEntity(),
                Office = Office.ToEntity(),
                PgsDeliverables = PgsDeliverables?.Select(d => d.ToEntity()).ToList()
            };
        }
    }
}


