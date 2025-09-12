
using IMIS.Domain;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SeedConfigurations
{
    public class UserOfficeConfiguration : IEntityTypeConfiguration<UserOffices>
    {
        public void Configure(EntityTypeBuilder<UserOffices> builder)
        {
            builder.HasData(
                new UserOffices { Id = 1, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 1, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 2, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 1, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 3, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 1, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 4, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 2, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 5, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 2, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 6, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 2, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 7, UserId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", OfficeId = 3, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 8, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 3, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 9, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 3, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 10, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 3, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 11, UserId = "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", OfficeId = 4, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 12, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 4, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 13, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 4, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 14, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 4, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 15, UserId = "e9bcc340-e63f-40e6-8326-8fe86cbef923", OfficeId = 5, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 16, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 5, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 17, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 5, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 18, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 5, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 19, UserId = "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", OfficeId = 7, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 20, UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada", OfficeId = 7, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 21, UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", OfficeId = 7, IsActive = true, IsDeleted = false, IsOfficeHead = false },
                new UserOffices { Id = 22, UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7", OfficeId = 7, IsActive = true, IsDeleted = false, IsOfficeHead = false },

                new UserOffices { Id = 23, UserId = "537d9fcd-b505-4f93-afc6-17eb8eddff83", OfficeId = 125, IsActive = true, IsDeleted = false, IsOfficeHead = true }
            );
        }
    }
}
