using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using Base.Auths.Roles;
using IMIS.Infrastructure.Auths.Roles;

public class RoleConfiguration : IEntityTypeConfiguration<IdentityRole>
{
    public void Configure(EntityTypeBuilder<IdentityRole> builder)
    {
        // NOTE: the ConcurrencyStamps are pinned to fixed values. Using
        // Guid.NewGuid() here makes every scaffolded migration rewrite all
        // seeded rows, which produces thousands of pointless UpdateData
        // statements on each run. Keep them stable.
        builder.HasData(


                new IdentityRole
                {
                    Id = "56996e97-9e8a-4d22-a693-c865144e9b96",
                    Name = new AdministratorRole().Name,
                    NormalizedName = "ADMINISTRATOR",
                    ConcurrencyStamp = "d8be45ed-d98f-4ad6-b30a-86283e52cf5e",
                },


                new IdentityRole
                {
                    Id = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                    Name = new PgsManagerRole().Name,
                    NormalizedName = "PGS CORE TEAM",
                    ConcurrencyStamp = "5a2d3d27-f240-4a2a-9e17-3af00aa3d587",
                },
                new IdentityRole
                {
                    Id = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                    Name = new StandardUserRole().Name,
                    NormalizedName = "STANDARD USER",
                    ConcurrencyStamp = "cb2683b0-ea31-45f2-afac-0c40a1b8577d",
                },
                 new IdentityRole
                 {
                     Id = "af7b586c7ee6490bbd878f46f6a47831",
                     Name = new PgsAuditorRole().Name,
                     NormalizedName = "AUDITOR",
                     ConcurrencyStamp = "a8d3e57d-cf6c-4e25-bbc8-2c034d4c8585",
                 },
                 new IdentityRole
                 {
                     Id = "95f224dd-3973-42ef-b350-7af30f67c2ca",
                     Name = new PgsServiceHead().Name,
                     NormalizedName = "SERVICE HEAD",
                     ConcurrencyStamp = "db859c0e-9789-48d5-9221-a6f0cc56ebe9",
                 },
                 new IdentityRole
                 {
                     Id = "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                     Name = new PgsHead().Name,
                     NormalizedName = "PGS HEAD",
                     ConcurrencyStamp = "2d5c06dd-1d2c-4561-8214-f8bf18ce3ac2",
                 },
                new IdentityRole
                {
                    Id = "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                    Name = new MCC().Name,
                    NormalizedName = "MCC",
                    ConcurrencyStamp = "066c76ba-1534-4561-bb10-986b23fec062",
                },
                new IdentityRole
                {
                    Id = "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                    Name = new OSM().Name,
                    NormalizedName = "OSM",
                    ConcurrencyStamp = "85606fac-84a5-492a-9676-a831b36b74a9",
                },
                new IdentityRole
                {
                    Id = "18b4151f-bff9-4525-b787-7a7e009757c3",
                    Name = new PgsAuditorHead().Name,
                    NormalizedName = "PGS AUDITOR HEAD",
                    ConcurrencyStamp = "ee14ad63-b2c2-42b2-9889-285f8221203f",
                },
                new IdentityRole
                {
                    Id = "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                    Name = new ServiceOfficer().Name,
                    NormalizedName = "SERVICE OFFICER",
                    ConcurrencyStamp = "e01ee795-1f5a-44ee-88a8-b5619777a870",
                },
                new IdentityRole
                {
                    Id = "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                    Name = new ResearchOfficer().Name,
                    NormalizedName = "RESEARCH OFFICER",
                    ConcurrencyStamp = "a0881530-b255-4762-b91e-8d004163ee9f",
                },
                new IdentityRole
                {
                    Id = "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                    Name = new TrainingOfficer().Name,
                    NormalizedName = "TRAINING OFFICER",
                    ConcurrencyStamp = "627faef2-7b61-4423-888e-6df51f9d944c",
                },
                new IdentityRole
                {
                    Id = "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                    Name = new LinkagesOfficer().Name,
                    NormalizedName = "LINKAGES OFFICER",
                    ConcurrencyStamp = "066911b6-cec6-4c8c-8288-2c943b9af703",
                },
                new IdentityRole
                {
                    Id = "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                    Name = new FacilitiesOfficer().Name,
                    NormalizedName = "FACILITIES OFFICER",
                    ConcurrencyStamp = "b0755b41-8bfe-4f53-bd3d-6d5296931454",
                },
                new IdentityRole
                {
                    Id = "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                    Name = new FinanceOfficer().Name,
                    NormalizedName = "FINANCE OFFICER",
                    ConcurrencyStamp = "3e569de6-c80e-49fc-a94c-78186dfbd0af",
                },
                new IdentityRole
                {
                    Id = "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                    Name = new InformationOfficer().Name,
                    NormalizedName = "INFORMATION OFFICER",
                    ConcurrencyStamp = "75efe748-4985-424a-bea3-9f8541dfbc30",
                },
                new IdentityRole
                {
                    Id = "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                    Name = new HROfficer().Name,
                    NormalizedName = "HR OFFICER",
                    ConcurrencyStamp = "1b673c3c-8242-4e54-8416-d57ca0803ed5",
                },
                new IdentityRole
                {
                    Id = "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                    Name = new SafetyOfficer().Name,
                    NormalizedName = "SAFETY OFFICER",
                    ConcurrencyStamp = "45eb58ca-29bf-471b-83d2-c555ae0fc509",
                },
                new IdentityRole
                {
                    Id = "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                    Name = new MSGC().Name,
                    NormalizedName = "MULTI-SECTOR GOVERNANCE COUNCIL OFFICER",
                    ConcurrencyStamp = "efa35293-6605-4b94-afd4-316cc3fdecfc",
                },
                new IdentityRole
                {
                    Id = "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                    Name = new TWG().Name,
                    NormalizedName = "TWG",
                    ConcurrencyStamp = "7947a626-5ce9-4016-8e13-0c9f80e59727",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                    Name = new PgsEvaluatorRole().Name,
                    NormalizedName = "EVALUATOR",
                    ConcurrencyStamp = "97571b29-2ac1-4dfc-89a2-bda77acaee89",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e604ff",
                    Name = new QMR().Name,
                    NormalizedName = "QMR",
                    ConcurrencyStamp = "48924822-4a7f-4ec4-9712-ad6f147e1c6a",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e634eg",
                    Name = new QMS().Name,
                    NormalizedName = "QMS",
                    ConcurrencyStamp = "6f2b8c31-4d5a-4f7e-9c81-2a7b3d6e9f04",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e634ff",
                    Name = new LeadAuditor().Name  ,
                    NormalizedName = "LEAD AUDITOR",
                    ConcurrencyStamp = "300d1177-8fe8-4c79-bd64-413fb7fbd09e",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e634hh",
                    Name = new AuditorTeamLeader().Name,
                    NormalizedName = "AUDITOR TEAM LEADER",
                    ConcurrencyStamp = "f2d2caa6-6655-44d2-883b-86de61d153a8",
                },
                new IdentityRole
                {
                    Id = "7f3c91a2-6e45-4b8d-a127-93d5c8e634ii",
                    Name = new DepartmentHead().Name,
                    NormalizedName = "DEPARTMENT HEAD",
                    ConcurrencyStamp = "4545b62f-3bf3-4c8e-b5c2-15ee782f678d",
                }

        );
    }
}
