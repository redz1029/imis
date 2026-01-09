using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class KraRoadMapRoleConfiguration : IEntityTypeConfiguration<KraRoadMapRole>
    {
        public void Configure(EntityTypeBuilder<KraRoadMapRole> builder)
        {
            builder.HasData(
           new KraRoadMapRole { Id = 1, KraId = 1, RoleId = "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01", IsDeleted = false },
           new KraRoadMapRole { Id = 2, KraId = 2, RoleId = "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4", IsDeleted = false },
           new KraRoadMapRole { Id = 3, KraId = 3, RoleId = "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2", IsDeleted = false },
           new KraRoadMapRole { Id = 4, KraId = 4, RoleId = "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7", IsDeleted = false },
           new KraRoadMapRole { Id = 5, KraId = 5, RoleId = "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3", IsDeleted = false },
           new KraRoadMapRole { Id = 6, KraId = 6, RoleId = "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52", IsDeleted = false },
           new KraRoadMapRole { Id = 7, KraId = 7, RoleId = "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30", IsDeleted = false },
           new KraRoadMapRole { Id = 8, KraId = 8, RoleId = "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50", IsDeleted = false },
           new KraRoadMapRole { Id = 9, KraId = 9, RoleId = "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f", IsDeleted = false }
           );
        }
    }
}
