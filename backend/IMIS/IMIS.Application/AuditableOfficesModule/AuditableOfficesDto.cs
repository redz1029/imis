﻿using IMIS.Domain;

namespace IMIS.Application.AuditableOfficesModule
{
    public class AuditableOfficesDto
    {
        public required int AuditScheduleId { get; set; }       
        public required int OfficeId { get; set; }
      
        public AuditableOffices ToEntity()
        {
            return new AuditableOffices
            {                
                AuditScheduleId = AuditScheduleId,
                OfficeId = OfficeId
            };
        }
    }
}
