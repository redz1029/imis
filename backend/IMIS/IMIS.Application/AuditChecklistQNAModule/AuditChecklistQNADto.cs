using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditChecklistQNAModule
{
    public class AuditChecklistQNADto : BaseDto<AuditChecklistQNA, int>
    {
        public required string Question { get; set; }

        // This likely represents the Foreign Key ID for a parent or related checklist
        public required long IsoStandardId { get; set; }

        public AuditChecklistQNADto() { }

        [SetsRequiredMembers]
        public AuditChecklistQNADto(AuditChecklistQNA entity)
        {
            Id = entity.Id;
            Question = entity.Question;
            IsoStandardId = (long)entity.IsoStandardId;

            // Standard BaseDto properties for concurrency and soft-delete
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditChecklistQNA ToEntity()
        {
            return new AuditChecklistQNA
            {
                Id = Id,
                Question = Question,
                IsoStandardId = IsoStandardId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
                // Note: The ICollection<AuditChecklist> is typically managed 
                // via navigation properties in the Service/Repository layer.
            };
        }
    }
}