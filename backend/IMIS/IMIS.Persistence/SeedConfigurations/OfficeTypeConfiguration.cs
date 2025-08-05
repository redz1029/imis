using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class OfficeTypeConfiguration : IEntityTypeConfiguration<OfficeType>
    {
        public void Configure(EntityTypeBuilder<OfficeType> builder)
        {
            builder.HasData(
                new OfficeType { Id = 1, Name = "Service", IsActive = true, IsDeleted = false },
                new OfficeType { Id = 2, Name = "Department", IsActive = true, IsDeleted = false },
                new OfficeType { Id = 3, Name = "Unit", IsActive = true, IsDeleted = false },
                new OfficeType { Id = 4, Name = "Section", IsActive = true, IsDeleted = false }
            );
        }
    }
}
