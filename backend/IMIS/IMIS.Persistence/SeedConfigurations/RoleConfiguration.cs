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
                    NormalizedName = "STANDARD USER",
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
                },
                new IdentityRole
                {
                    Id = "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                    Name = new ServiceOfficer().Name,
                    NormalizedName = "SERVICE OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                    Name = new ResearchOfficer().Name,
                    NormalizedName = "RESEARCH OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                    Name = new TrainingOfficer().Name,
                    NormalizedName = "TRAINING OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                    Name = new LinkagesOfficer().Name,
                    NormalizedName = "LINKAGES OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                    Name = new FacilitiesOfficer().Name,
                    NormalizedName = "FACILITIES OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },               
                new IdentityRole
                {
                    Id = "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                    Name = new FinanceOfficer().Name,
                    NormalizedName = "FINANCE OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                    Name = new InformationOfficer().Name,
                    NormalizedName = "INFORMATION OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },
                new IdentityRole
                {
                    Id = "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                    Name = new HROfficer().Name,
                    NormalizedName = "HR OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                },               
                new IdentityRole
                {
                    Id = "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                    Name = new SafetyOfficer().Name,
                    NormalizedName = "SAFETY OFFICER",
                    ConcurrencyStamp = Guid.NewGuid().ToString(),
                }
        );
    }
}
