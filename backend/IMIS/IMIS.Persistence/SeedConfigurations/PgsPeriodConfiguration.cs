using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class PgsPeriodConfiguration : IEntityTypeConfiguration<PgsPeriod>
    {
        public void Configure(EntityTypeBuilder<PgsPeriod> builder)
        {
            builder.HasData(
                new PgsPeriod
                {
                    Id = 1,
                    StartDate = DateOnly.FromDateTime(new DateTime(2025, 7, 1)),
                    EndDate = DateOnly.FromDateTime(new DateTime(2025, 12, 31)),
                    Remarks = "2nd Half of 2025",
                    IsDeleted = false
                }
            );
        }
    }

}
