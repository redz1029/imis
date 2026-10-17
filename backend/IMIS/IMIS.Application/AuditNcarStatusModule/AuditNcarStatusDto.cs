using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditNcarStatusModule
{
    public class AuditNcarStatusDto : BaseDto<AuditNcarStatus, int>
    {
        public required string NcarStatus { get; set; }

        public AuditNcarStatusDto() { }

        [SetsRequiredMembers]
        public AuditNcarStatusDto(AuditNcarStatus entity)
        {
            Id = entity.Id;
            NcarStatus = entity.ncarStatus;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditNcarStatus ToEntity()
        {
            return new AuditNcarStatus
            {
                Id = Id,
                ncarStatus = NcarStatus,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}