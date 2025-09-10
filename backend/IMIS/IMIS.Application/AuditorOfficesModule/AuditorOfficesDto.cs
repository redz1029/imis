using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditorOfficesModule
{
    public class AuditorOfficesDto : BaseDto<AuditorOffices, int>
    {
        public int AuditorId { get; set; }       
        public int OfficeId { get; set; }      
        public int PgsPeriodId { get; set; }      
        public bool IsOfficeHead { get; set; }
        public AuditorOfficesDto() { }
        [SetsRequiredMembers]
        public AuditorOfficesDto(AuditorOffices auditoroffice)
        {
            if (auditoroffice != null)
            {
                Id = auditoroffice.Id;
                AuditorId = auditoroffice.AuditorId;
                OfficeId = auditoroffice.OfficeId;
                PgsPeriodId = auditoroffice.PgsPeriodId;
                IsOfficeHead = auditoroffice.IsOfficeHead;
            }
        }
        public override AuditorOffices ToEntity()
        {
            return new AuditorOffices() 
            {
                Id = Id, AuditorId = AuditorId, 
                OfficeId = OfficeId, 
                PgsPeriodId = PgsPeriodId, 
                IsOfficeHead = IsOfficeHead
            };
        }
    }
}
