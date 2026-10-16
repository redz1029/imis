using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class AuditorTeamsConfiguration : IEntityTypeConfiguration<AuditorTeams>
    {
        public void Configure(EntityTypeBuilder<AuditorTeams> builder)
        {
            builder.HasData(

                // Team 1 - Department of Surgery
                new AuditorTeams
                {
                    Id = 1,
                    TeamId = 1,
                    AuditorId = 19,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 2,
                    TeamId = 1,
                    AuditorId = 34,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 3,
                    TeamId = 1,
                    AuditorId = 26,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 4,
                    TeamId = 1,
                    AuditorId = 54,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 5,
                    TeamId = 1,
                    AuditorId = 15,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 6,
                    TeamId = 1,
                    AuditorId = 31,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 2 - EFMD - Mechanical Works and Section
                new AuditorTeams
                {
                    Id = 7,
                    TeamId = 2,
                    AuditorId = 14,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 8,
                    TeamId = 2,
                    AuditorId = 61,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 9,
                    TeamId = 2,
                    AuditorId = 41,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 10,
                    TeamId = 2,
                    AuditorId = 58,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 11,
                    TeamId = 2,
                    AuditorId = 16,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 12,
                    TeamId = 2,
                    AuditorId = 8,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 3 - Peritoneal Dialysis Clinic
                new AuditorTeams
                {
                    Id = 13,
                    TeamId = 3,
                    AuditorId = 17,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 14,
                    TeamId = 3,
                    AuditorId = 28,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 15,
                    TeamId = 3,
                    AuditorId = 60,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 16,
                    TeamId = 3,
                    AuditorId = 11,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 17,
                    TeamId = 3,
                    AuditorId = 78,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 18,
                    TeamId = 3,
                    AuditorId = 39,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 4 - Health Emergency Management Staff
                new AuditorTeams
                {
                    Id = 19,
                    TeamId = 4,
                    AuditorId = 27,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 20,
                    TeamId = 4,
                    AuditorId = 49,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 21,
                    TeamId = 4,
                    AuditorId = 69,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 22,
                    TeamId = 4,
                    AuditorId = 74,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 23,
                    TeamId = 4,
                    AuditorId = 29,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 24,
                    TeamId = 4,
                    AuditorId = 57,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 5 - Health Information Management Department
                new AuditorTeams
                {
                    Id = 25,
                    TeamId = 5,
                    AuditorId = 9,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 26,
                    TeamId = 5,
                    AuditorId = 53,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 27,
                    TeamId = 5,
                    AuditorId = 84,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 28,
                    TeamId = 5,
                    AuditorId = 82,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 29,
                    TeamId = 5,
                    AuditorId = 40,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 30,
                    TeamId = 5,
                    AuditorId = 33,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 6 - Mechanical Works Department - Elevator Unit
                new AuditorTeams
                {
                    Id = 31,
                    TeamId = 6,
                    AuditorId = 20,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 32,
                    TeamId = 6,
                    AuditorId = 66,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 33,
                    TeamId = 6,
                    AuditorId = 71,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 34,
                    TeamId = 6,
                    AuditorId = 75,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 35,
                    TeamId = 6,
                    AuditorId = 18,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 36,
                    TeamId = 6,
                    AuditorId = 79,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 7 - Department of Internal Medicine
                new AuditorTeams
                {
                    Id = 37,
                    TeamId = 7,
                    AuditorId = 30,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 38,
                    TeamId = 7,
                    AuditorId = 48,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 39,
                    TeamId = 7,
                    AuditorId = 46,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 40,
                    TeamId = 7,
                    AuditorId = 47,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 41,
                    TeamId = 7,
                    AuditorId = 38,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 42,
                    TeamId = 7,
                    AuditorId = 42,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 8 - Health Information Management Department - Out-Patient Department
                new AuditorTeams
                {
                    Id = 43,
                    TeamId = 8,
                    AuditorId = 24,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 44,
                    TeamId = 8,
                    AuditorId = 62,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 45,
                    TeamId = 8,
                    AuditorId = 76,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 46,
                    TeamId = 8,
                    AuditorId = 36,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 47,
                    TeamId = 8,
                    AuditorId = 3,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 48,
                    TeamId = 8,
                    AuditorId = 72,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 9 - Pay Admitting Unit
                new AuditorTeams
                {
                    Id = 49,
                    TeamId = 9,
                    AuditorId = 55,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 50,
                    TeamId = 9,
                    AuditorId = 59,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 51,
                    TeamId = 9,
                    AuditorId = 37,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 52,
                    TeamId = 9,
                    AuditorId = 12,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 53,
                    TeamId = 9,
                    AuditorId = 10,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 54,
                    TeamId = 9,
                    AuditorId = 68,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 10 - Dental Department
                new AuditorTeams
                {
                    Id = 55,
                    TeamId = 10,
                    AuditorId = 52,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 56,
                    TeamId = 10,
                    AuditorId = 65,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 57,
                    TeamId = 10,
                    AuditorId = 80,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 58,
                    TeamId = 10,
                    AuditorId = 21,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 59,
                    TeamId = 10,
                    AuditorId = 43,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 60,
                    TeamId = 10,
                    AuditorId = 77,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 11 - Emergency Department - Medical/Nursing
                new AuditorTeams
                {
                    Id = 61,
                    TeamId = 11,
                    AuditorId = 63,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 62,
                    TeamId = 11,
                    AuditorId = 73,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 63,
                    TeamId = 11,
                    AuditorId = 6,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 64,
                    TeamId = 11,
                    AuditorId = 64,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 65,
                    TeamId = 11,
                    AuditorId = 44,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 12 - Department of Obstetics-Gynecology
                new AuditorTeams
                {
                    Id = 66,
                    TeamId = 12,
                    AuditorId = 7,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 67,
                    TeamId = 12,
                    AuditorId = 45,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 68,
                    TeamId = 12,
                    AuditorId = 56,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 69,
                    TeamId = 12,
                    AuditorId = 13,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 70,
                    TeamId = 12,
                    AuditorId = 25,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 71,
                    TeamId = 12,
                    AuditorId = 23,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 13 - Budget Department
                new AuditorTeams
                {
                    Id = 72,
                    TeamId = 13,
                    AuditorId = 51,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 73,
                    TeamId = 13,
                    AuditorId = 50,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 74,
                    TeamId = 13,
                    AuditorId = 81,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 75,
                    TeamId = 13,
                    AuditorId = 22,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 76,
                    TeamId = 13,
                    AuditorId = 70,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 77,
                    TeamId = 13,
                    AuditorId = 32,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },

                // Team 14 - Audit Teams
                new AuditorTeams
                {
                    Id = 78,
                    TeamId = 14,
                    AuditorId = 2,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 79,
                    TeamId = 14,
                    AuditorId = 35,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 80,
                    TeamId = 14,
                    AuditorId = 67,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 81,
                    TeamId = 14,
                    AuditorId = 83,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 82,
                    TeamId = 14,
                    AuditorId = 5,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                },
                new AuditorTeams
                {
                    Id = 83,
                    TeamId = 14,
                    AuditorId = 4,
                    IsTeamLeader = true,
                    IsActive = true,
                    IsDeleted = false
                }
            );
        }
    }
}
