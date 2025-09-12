using IMIS.Domain;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;

namespace IMIS.Persistence.SeedConfigurations
{
    public class PgsSignatoryTemplateConfiguration : IEntityTypeConfiguration<PgsSignatoryTemplate>
    {
        public void Configure(EntityTypeBuilder<PgsSignatoryTemplate> builder)
        {
            builder.HasData(
                new PgsSignatoryTemplate { Id = 1, Status = "Recommended", SignatoryLabel = "Recommended By", OrderLevel = 1, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 1 },
                new PgsSignatoryTemplate { Id = 2, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 2, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 1 },
                new PgsSignatoryTemplate { Id = 3, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 3, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 1 },

                new PgsSignatoryTemplate { Id = 4, Status = "Reviewed / Recommmended", SignatoryLabel = "Reviewed / Recommmended By", OrderLevel = 1, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 2 },
                new PgsSignatoryTemplate { Id = 5, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 2, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 2 },
                new PgsSignatoryTemplate { Id = 6, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 3, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 2 },

                new PgsSignatoryTemplate { Id = 7, Status = "Reviewed", SignatoryLabel = "Reviewed By", OrderLevel = 1, DefaultSignatoryId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", IsActive = true, IsDeleted = false, OfficeId = 3 },
                new PgsSignatoryTemplate { Id = 8, Status = "Recommended", SignatoryLabel = "Recommended", OrderLevel = 2, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 3 },
                new PgsSignatoryTemplate { Id = 9, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 3, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 3 },
                new PgsSignatoryTemplate { Id = 10, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 4, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 3 },

                new PgsSignatoryTemplate { Id = 11, Status = "Reviewed", SignatoryLabel = "Reviewed By", OrderLevel = 1, DefaultSignatoryId = "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", IsActive = true, IsDeleted = false, OfficeId = 4 },
                new PgsSignatoryTemplate { Id = 12, Status = "Recommended", SignatoryLabel = "Recommended By", OrderLevel = 2, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 4 },
                new PgsSignatoryTemplate { Id = 13, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 3, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 4 },
                new PgsSignatoryTemplate { Id = 14, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 4, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 4 },

                new PgsSignatoryTemplate { Id = 15, Status = "Reviewed", SignatoryLabel = "Reviewed By", OrderLevel = 1, DefaultSignatoryId = "e9bcc340-e63f-40e6-8326-8fe86cbef923", IsActive = true, IsDeleted = false, OfficeId = 5 },
                new PgsSignatoryTemplate { Id = 16, Status = "Recommended", SignatoryLabel = "Recommended By", OrderLevel = 2, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 5 },
                new PgsSignatoryTemplate { Id = 17, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 3, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 5 },
                new PgsSignatoryTemplate { Id = 18, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 4, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 5 },

                new PgsSignatoryTemplate { Id = 19, Status = "Reviewed", SignatoryLabel = "Reviewed By", OrderLevel = 1, DefaultSignatoryId = "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", IsActive = true, IsDeleted = false, OfficeId = 7 },
                new PgsSignatoryTemplate { Id = 20, Status = "Recommended", SignatoryLabel = "Recommended By", OrderLevel = 2, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 7 },
                new PgsSignatoryTemplate { Id = 21, Status = "Noted", SignatoryLabel = "Noted By", OrderLevel = 3, DefaultSignatoryId = "743b9807-3441-47c1-9285-5ff8dfd7acb9", IsActive = true, IsDeleted = false, OfficeId = 7 },
                new PgsSignatoryTemplate { Id = 22, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 4, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 7 },

                new PgsSignatoryTemplate { Id = 23, Status = "Recommended", SignatoryLabel = "Recommended By", OrderLevel = 1, DefaultSignatoryId = "a6866933-92a9-41e7-9100-8bee51ed0ada", IsActive = true, IsDeleted = false, OfficeId = 135 },
                new PgsSignatoryTemplate { Id = 24, Status = "Approved", SignatoryLabel = "Approved By", OrderLevel = 2, DefaultSignatoryId = "e1a3ac20-1d20-4f37-8826-242657a746c7", IsActive = true, IsDeleted = false, OfficeId = 135 }
            );
        }
    }
}
