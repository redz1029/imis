using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Base.Auths.Roles;
using IMIS.Infrastructure.Auths.Roles;

public class RoleConfiguration : IEntityTypeConfiguration<IdentityRole>
{
    public void Configure(EntityTypeBuilder<IdentityRole> builder)
    {
        builder.HasData(
                         
                new IdentityRole
                {
                    Id = "56996e97-9e8a-4d22-a693-c865144e9b96",
                    Name = new AdministratorRole().Name,
                    NormalizedName = "ADMINISTRATOR",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                    Name = new PgsManagerRole().Name,
                    NormalizedName = "PGS CORE TEAM",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                   
                },
                new IdentityRole
                {
                    Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                    Name = new StandardUserRole().Name,
                    NormalizedName = "PGS USER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                 new IdentityRole
                 {
                     Id = "af7b586c7ee6490bbd878f46f6a47831",
                     Name = new PgsAuditorRole().Name,
                     NormalizedName = "AUDITOR",
                     ConcurrencyStamp = Guid.NewGuid().ToString(),
                 },
                 new IdentityRole
                 {
                     Id = "95f224dd-3973-42ef-b350-7af30f67c2ca",
                     Name = new PgsServiceHead().Name,
                     NormalizedName = "SERVICE HEAD",
                     ConcurrencyStamp = Guid.NewGuid().ToString(),
                 },
                 new IdentityRole
                 {
                     Id = "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                     Name = new PgsHead().Name,
                     NormalizedName = "PGS HEAD",
                     ConcurrencyStamp = Guid.NewGuid().ToString(),
                 },
                new IdentityRole
                {
                    Id = "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                    Name = new MCC().Name,
                    NormalizedName = "MCC",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                    Name = new OSM().Name,
                    NormalizedName = "OSM",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                 new IdentityRole
                 {
                     Id = "18b4151f-bff9-4525-b787-7a7e009757c3",
                     Name = new PgsAuditorHead().Name,
                     NormalizedName = "PGS AUDITOR HEAD",
                     ConcurrencyStamp = Guid.NewGuid().ToString(),
                 }

        );
    }
}
