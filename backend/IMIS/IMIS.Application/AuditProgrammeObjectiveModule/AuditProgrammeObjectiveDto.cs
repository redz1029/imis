using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.AuditProgrammeModule
{
    public class AuditProgrammeObjectiveDto : BaseDto<AuditProgrammeObjective, int>
    {
        public required int SortOrder { get; set; }
        public required string Description { get; set; }
        public required int AuditProgrammeId { get; set; }

        public AuditProgrammeObjectiveDto() { }

        [SetsRequiredMembers]
        public AuditProgrammeObjectiveDto(AuditProgrammeObjective entity)
        {
            Id = entity.Id;
            SortOrder = entity.SortOrder;
            Description = entity.Description;
            AuditProgrammeId = entity.AuditProgrammeId;
            IsDeleted = entity.IsDeleted;
            RowVersion = entity.RowVersion;
        }

        public override AuditProgrammeObjective ToEntity()
        {
            return new AuditProgrammeObjective
            {
                Id = Id,
                SortOrder = SortOrder,
                Description = Description,
                AuditProgrammeId = AuditProgrammeId,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}