using IMIS.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class UserRoleConfiguration : IEntityTypeConfiguration<IdentityUserRole<string>>
{
    public void Configure(EntityTypeBuilder<IdentityUserRole<string>> builder)
    {     
        builder.HasData(
         
            new IdentityUserRole<string>
            {
                UserId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
            },
            new IdentityUserRole<string>
            {
                UserId = "176bcfeb-f12a-4d42-b790-5d2312660801",
                RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
            },
            new IdentityUserRole<string>
            {
                UserId = "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                RoleId = "56996e97-9e8a-4d22-a693-c865144e9b96"
            },          
            new IdentityUserRole<string>
            {
                UserId = "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            }, 
            new IdentityUserRole<string>
            {
                UserId = "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "e1a3ac20-1d20-4f37-8826-242657a746c7",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string> 
            {
                UserId = "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                RoleId = "95f224dd-3973-42ef-b350-7af30f67c2ca"
            },
            new IdentityUserRole<string>
            {
                UserId = "18b4151f-bff9-4525-b787-7a7e009757c3",
                RoleId = "18b4151f-bff9-4525-b787-7a7e009757c3"
            },
            new IdentityUserRole<string>
            {
                UserId = "18b4151f-bff9-4525-b787-7a7e009757c3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },           
            new IdentityUserRole<string>
            {
                UserId = "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1f6d353-df11-4a17-b2be-49371b8c223d",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "2489fce0-858f-43af-b82a-65ee42cb2e33",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },           
            new IdentityUserRole<string>
            {
                UserId = "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "33a13c76-041f-4d68-8f67-41b7dd60c408",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "5d8a2197-b38b-40b2-940a-845e2a44b622",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c79c6433-d1ad-46a3-ae87-84edb44476de",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c79c6433-d1ad-46a3-ae87-84edb44476de",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "827e71e5-479c-47a7-8f91-16327825a02d",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "827e71e5-479c-47a7-8f91-16327825a02d",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "12183b62-26ee-459b-a859-88a94e86c117",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "12183b62-26ee-459b-a859-88a94e86c117",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "ef529a6b-b381-4db1-a204-913ba73a6721",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "50e3ff41-8195-4d52-805a-d55efb68f08a",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "39987409-6b12-4a73-a9a3-61c7f117dcab",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "56731842-6b12-9a46-k9h2-61c7f212hyex",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "db7fba3d-88fc-47cf-b119-f868d9196f02",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                RoleId = "af7b586c7ee6490bbd878f46f6a47831"
            },
            new IdentityUserRole<string>
            {
                UserId = "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "4e21fe59-4f5e-46b3-82b7-28df270038da",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "b582fc78-cd33-46d4-a994-8c43789600ff",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "eeadfae2-544f-4a5d-9027-808537e694b1",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "aa704a60-ad3d-4148-90c0-316803202de6",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "35035c73-8072-4005-85bb-0a91cd97741b",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "31298867-e329-4dbf-8c68-2e557d98e864",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "86e65501-a4a6-438c-abe7-5ec802032bd4",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "a452e452-d791-439e-b390-d80dba5ffbc0",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "6517b46b-eade-4618-984b-525a31aec14f",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {   
                UserId = "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                RoleId = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17"
            },
            new IdentityUserRole<string>
            {
                UserId = "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                RoleId = "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17"
            },

            // ----------New User Roles 01/09/2026-----------
            new IdentityUserRole<string>
            {
                UserId = "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },
            new IdentityUserRole<string>
            {
                UserId = "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                RoleId = "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd"
            },

            // Point Person RoadMap 
            new IdentityUserRole<string>
            {
                UserId = "a6866933-92a9-41e7-9100-8bee51ed0ada",
                RoleId = "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01"
            },
            new IdentityUserRole<string>
            {
                UserId = "b582fc78-cd33-46d4-a994-8c43789600ff",
                RoleId = "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2"
            },
            new IdentityUserRole<string>
            {
                UserId = "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                RoleId = "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4"
            },
            new IdentityUserRole<string>
            {
                UserId = "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                RoleId = "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7"
            },
            new IdentityUserRole<string>
            {
                UserId = "6517b46b-eade-4618-984b-525a31aec14f",
                RoleId = "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f"
            },
            new IdentityUserRole<string>
            {
                UserId = "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                RoleId = "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50"
            },
            new IdentityUserRole<string>
            {
                UserId = "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                RoleId = "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3"
            },
            new IdentityUserRole<string>
            {
                UserId = "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                RoleId = "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30"
            },
            new IdentityUserRole<string>
            {
                UserId = "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                RoleId = "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52"
            }           
       );
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               