
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

                new UserOffices { Id = 23, UserId = "537d9fcd-b505-4f93-afc6-17eb8eddff83", OfficeId = 125, IsActive = true, IsDeleted = false, IsOfficeHead = true },





                new UserOffices { Id = 24, UserId = "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e", OfficeId = 126, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 25, UserId = "9821dbf5-0f70-4630-8c68-f2077a3abf08", OfficeId = 13, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 26, UserId = "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1", OfficeId = 50, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 27, UserId = "4e21fe59-4f5e-46b3-82b7-28df270038da", OfficeId = 140, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 28, UserId = "b582fc78-cd33-46d4-a994-8c43789600ff", OfficeId = 75, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 29, UserId = "0301f6de-6d6d-448f-a46c-2bb32ba97a28", OfficeId = 127, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 30, UserId = "eeadfae2-544f-4a5d-9027-808537e694b1", OfficeId = 9, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 31, UserId = "49180f4a-cbe7-489b-8fd1-901e79dfe2f5", OfficeId = 68, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 32, UserId = "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420", OfficeId = 179, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 33, UserId = "562a00d1-f6de-4c44-bfc2-b55e99074bcf", OfficeId = 156, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 34, UserId = "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f", OfficeId = 19, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 35, UserId = "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917", OfficeId = 20, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 36, UserId = "bacdfd11-acd7-40fe-9fb3-b8831f94d7de", OfficeId = 21, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 37, UserId = "75228ef1-9a3f-4a55-8181-b1794ec72e8d", OfficeId = 22, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 38, UserId = "0c0e6892-41a4-4536-bda7-757dd5aeb4ee", OfficeId = 37, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 39, UserId = "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8", OfficeId = 39, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 40, UserId = "cc505df2-3586-41a1-9d44-b5fc8f28e3a9", OfficeId = 38, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 41, UserId = "576fc42f-b0f9-433b-907a-29d98ebf7af6", OfficeId = 40, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 42, UserId = "aa704a60-ad3d-4148-90c0-316803202de6", OfficeId = 42, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 43, UserId = "08a7ead1-5c61-4207-8ea5-aec3d6b691d0", OfficeId = 43, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 44, UserId = "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c", OfficeId = 122, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 45, UserId = "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83", OfficeId = 164, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 46, UserId = "f2b28c8e-58cf-47b2-8245-33a7a98a7344", OfficeId = 123, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 47, UserId = "d55b7093-1298-42fb-96b2-b12edb1cf49f", OfficeId = 14, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 48, UserId = "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71", OfficeId = 15, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 49, UserId = "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55", OfficeId = 27, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 50, UserId = "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a", OfficeId = 28, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 51, UserId = "35035c73-8072-4005-85bb-0a91cd97741b", OfficeId = 35, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 52, UserId = "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b", OfficeId = 33, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 53, UserId = "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24", OfficeId = 180, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 54, UserId = "c79c6433-d1ad-46a3-ae87-84edb44476de", OfficeId = 23, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 55, UserId = "12183b62-26ee-459b-a859-88a94e86c117", OfficeId = 84, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 56, UserId = "b1ec6cc6-9920-4df6-bce0-b22b107a476d", OfficeId = 24, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 57, UserId = "827e71e5-479c-47a7-8f91-16327825a02d", OfficeId = 26, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 58, UserId = "31298867-e329-4dbf-8c68-2e557d98e864", OfficeId = 174, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 59, UserId = "86e65501-a4a6-438c-abe7-5ec802032bd4", OfficeId = 34, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 60, UserId = "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3", OfficeId = 58, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 61, UserId = "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074", OfficeId = 159, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 62, UserId = "1a9d8654-1c19-4b60-9491-4e33c176cc64", OfficeId = 181, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 63, UserId = "3db6b5af-4b42-4747-a3f0-3a60b3e36a56", OfficeId = 149, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 64, UserId = "60cbc60f-8572-47ba-b70c-cc328c363bd7", OfficeId = 8, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 65, UserId = "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e", OfficeId = 10, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 66, UserId = "18b4151f-bff9-4525-b787-7a7e009757c3", OfficeId = 11, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 67, UserId = "2902eb0b-328f-4c82-a37b-e6b67c1e7770", OfficeId = 12, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 68, UserId = "756c27c7-7637-4525-9b85-c1f41c0c5a8f", OfficeId = 176, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 69, UserId = "32074da3-f8f8-4755-8cd5-f2aabba599e2", OfficeId = 17, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 70, UserId = "a452e452-d791-439e-b390-d80dba5ffbc0", OfficeId = 16, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 71, UserId = "f23ac0c6-68ac-41c8-94ff-383acbfc3e41", OfficeId = 18, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 72, UserId = "6517b46b-eade-4618-984b-525a31aec14f", OfficeId = 15, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 73, UserId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", OfficeId = 14, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 74, UserId = "3cfa9401-553a-4ac5-ab8d-3d65899090b3", OfficeId = 36, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 75, UserId = "60cbc60f-8572-47ba-b70c-cc328c363bd7", OfficeId = 79, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 76, UserId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", OfficeId = 182, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 77, UserId = "756c27c7-7637-4525-9b85-c1f41c0c5a8f", OfficeId = 184, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 78, UserId = "4e21fe59-4f5e-46b3-82b7-28df270038da", OfficeId = 185, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 79, UserId = "6517b46b-eade-4618-984b-525a31aec14f", OfficeId = 77, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 80, UserId = "45fm8462-553a-4ac5-ap8i-3d65879641h8", OfficeId = 154, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 81, UserId = "21ag1234-884k-0ak8-ap8i-2y54768532d2", OfficeId = 154, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 82, UserId = "66fg1385-86sd-8aw9-vm5g-1s87643521j5", OfficeId = 78, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 83, UserId = "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9", OfficeId = 79, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 84, UserId = "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4", OfficeId = 70, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 85, UserId = "b7f4e831-25ad-48a9-91d3-7e26f53a4db2", OfficeId = 183, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 86, UserId = "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3", OfficeId = 184, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 87, UserId = "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17", OfficeId = 186, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 88, UserId = "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8", OfficeId = 106, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 89, UserId = "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42", OfficeId = 90, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 90, UserId = "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27", OfficeId = 80, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 91, UserId = "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1", OfficeId = 80, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 92, UserId = "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61", OfficeId = 80, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 93, UserId = "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94", OfficeId = 161, IsActive = true, IsDeleted = false, IsOfficeHead = true },
                new UserOffices { Id = 94, UserId = "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85", OfficeId = 161, IsActive = true, IsDeleted = false, IsOfficeHead = true }
            );
        }
    }
}
