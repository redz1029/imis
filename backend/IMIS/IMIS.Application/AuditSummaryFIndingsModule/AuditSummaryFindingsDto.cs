using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditSummaryFindingsModule
{
    public class AuditSummaryFindingsDto : BaseDto<AuditSummaryFIndings, int>
    {
        public required int No { get; set; }
        public required string Findings { get; set; }

        public AuditSummaryFindingsDto() { }

        [SetsRequiredMembers]
        public AuditSummaryFindingsDto(AuditSummaryFIndings entity)
        {
            Id = entity.Id;
            No = entity.No;
            Findings = entity.Findings;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditSummaryFIndings ToEntity()
        {
            return new AuditSummaryFIndings
            {
                Id = Id,
                No = No,
                Findings = Findings,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: Navigation properties (Criteria, NcarStatus) 
                // are attached/managed within the service/repository layer.
            };
        }
    }
}