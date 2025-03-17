using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using IMIS.Infrastructure.Auths;

public class RoleConfiguration : IEntityTypeConfiguration<IdentityRole>
{
    public void Configure(EntityTypeBuilder<IdentityRole> builder)
    {
        builder.HasData(
                         
                new IdentityRole
                {
                    Id = "56996e97-9e8a-4d22-a693-c865144e9b96",
                    Name = RoleTypes.Administrator,
                    NormalizedName = "ADMINISTRATOR",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                    Name = RoleTypes.PgsManager,
                    NormalizedName = "LDNA MANAGER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                    Name = RoleTypes.PgsUser,
                    NormalizedName = "LDNA USER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                }            
        );
    }
}
