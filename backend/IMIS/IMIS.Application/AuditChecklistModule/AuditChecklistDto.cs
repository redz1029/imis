using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditChecklistModule
{
    public class AuditChecklistDto : BaseDto<AuditChecklist, int>
    {
        public required string AuditScope { get; set; }
        public required int Conforming { get; set; }
        public required string FindingAndRemarks { get; set; }
        public required string ItemsAndQuestions { get; set; }
        public required string Auditees { get; set; }

        public AuditChecklistQNA? QnA { get; }

        // Foreign Key IDs
        public required int IsoStandardAuditPlan { get; set; }
        public required int AuditPlanProcess { get; set; }
        public int? AuditorId { get; set; }

        public AuditChecklistDto() { }

        [SetsRequiredMembers]
        public AuditChecklistDto(AuditChecklist entity)
        {
            Id = entity.Id;
            AuditScope = entity.AuditScope;
            Conforming = entity.conforming; // Maps to domain 'conforming'
            FindingAndRemarks = entity.FindingAndRemarks;
            ItemsAndQuestions = entity.ItemsAndQuestions;
            Auditees = entity.Auditees;
            QnA = entity.AuditChecklistQNA;
            AuditorId = entity.Auditor?.Id;

            // Standard BaseDto properties
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditChecklist ToEntity()
        {
            return new AuditChecklist
            {
                Id = Id,
                AuditScope = AuditScope,
                conforming = Conforming,
                FindingAndRemarks = FindingAndRemarks,
                ItemsAndQuestions = ItemsAndQuestions,
                Auditees = Auditees,
                QnA = QnA,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: Navigation properties (Auditor, IdAuditPlanProcess, etc.) 
                // are typically handled by the Repository/Service during persistence
            };
        }
    }
}