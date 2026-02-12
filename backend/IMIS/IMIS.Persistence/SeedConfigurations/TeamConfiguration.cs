using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class TeamConfiguration : IEntityTypeConfiguration<Team>
    {
        public void Configure(EntityTypeBuilder<Team> builder)
        {
            builder.HasData(
            new Team { Id = 1, Name = "Team 1", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 2, Name = "Team 2", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 3, Name = "Team 3", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 4, Name = "Team 4", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 5, Name = "Team 5", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 6, Name = "Team 6", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 7, Name = "Team 7", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 8, Name = "Team 8", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 9, Name = "Team 9", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 10, Name = "Team 10", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 11, Name = "Team 11", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 12, Name = "Team 12", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 13, Name = "Team 13", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS },
            new Team { Id = 14, Name = "Team 14", IsActive = true, IsDeleted = false, ImprovementType = OrganizationImprovementType.PGS });
        }
    }
}
