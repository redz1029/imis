using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class AuditNcarStatusConfiguration : IEntityTypeConfiguration<AuditNcarStatus>
    {
        public void Configure(EntityTypeBuilder<AuditNcarStatus> builder)
        {
            builder.HasData(
                new AuditNcarStatus { Id = 1, ncarStatus = "NC", IsDeleted = false },
                new AuditNcarStatus { Id = 2, ncarStatus = "OFI", IsDeleted = false }
            );
        }
    }
}
