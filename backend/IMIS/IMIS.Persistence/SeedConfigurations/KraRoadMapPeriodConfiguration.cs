using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class KraRoadMapPeriodConfiguration : IEntityTypeConfiguration<KraRoadMapPeriod>
    {
        public void Configure(EntityTypeBuilder<KraRoadMapPeriod> builder)
        {
            builder.HasData(
                new KraRoadMapPeriod
                {
                    Id = 1,
                    StartYear = new DateOnly(2026, 1, 1),
                    EndYear = new DateOnly(2030, 12, 31),
                    IsDeleted = false
                }
            );
        }
    }
}
