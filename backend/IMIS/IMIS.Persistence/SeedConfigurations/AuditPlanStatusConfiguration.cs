using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class AuditPlanStatusConfiguration : IEntityTypeConfiguration<AuditPlanStatus>
    {
        public void Configure(EntityTypeBuilder<AuditPlanStatus> builder)
        {
            builder.HasData(
                new AuditPlanStatus { Id = 1, Code = AuditStatusCodes.Draft, Name = "Draft", SortOrder = 1, IsActive = true, IsDeleted = false },
                new AuditPlanStatus { Id = 2, Code = AuditStatusCodes.Pending, Name = "Pending", SortOrder = 2, IsActive = true, IsDeleted = false },
                new AuditPlanStatus { Id = 3, Code = AuditStatusCodes.Approved, Name = "Approved", SortOrder = 3, IsActive = true, IsDeleted = false },
                new AuditPlanStatus { Id = 4, Code = AuditStatusCodes.Disapproved, Name = "Disapproved", SortOrder = 4, IsActive = true, IsDeleted = false }
            );
        }
    }
}
