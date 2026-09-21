using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ClauseLib : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 89L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 196L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 197L);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "c9242ef6-bb56-48b0-8a87-3bc2f33646d0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "36d055cd-e7da-4989-8e53-3a6471f1b8c8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "5973c499-de2a-490d-ae68-18d4303c8457");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "accc0a2c-c6f1-4810-84f6-cfe766c1d485");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d47b980c-9077-4076-a471-070e0d45e197");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "45880846-0962-4cab-ad2e-32c00bfdf1a3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "37bd6860-637b-4399-9bf9-05890af03736");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "c2dcdf9e-c50f-4df9-96b7-53558d0342ac");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "f787fc97-29d8-4663-b285-55afa2e8f3fa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                column: "ConcurrencyStamp",
                value: "1fd952cf-133a-4666-a239-9e290d4d5d3a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "0713f87f-b477-4bfc-b1ff-ad926d948c28");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "257bd7b4-e402-41da-9b22-c281dea2f83d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "d9face03-23f3-40d6-87a0-8135c76376f4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "c98da000-57f3-450b-88ea-2c95fc6002f9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "55b290f8-e74f-449e-bf25-3036c530d755");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "f1767495-6fc4-4b97-8f69-83acaa00869a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "9efefb29-b26a-4ccf-a2f9-b1dae8e5a251");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "a68b8bca-62df-4bec-a2f1-6899e4c0b553");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "5651a20d-d27a-4c1f-829f-2f19a025d064");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "4e6af7a8-bea8-4860-89ae-0e0847a150cc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "44ca45ea-45b2-437f-aa7e-22b74c76a320");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9063e72a-7e12-4946-89bd-8c8def31df3e", "AQAAAAIAAYagAAAAEG2xIZyOgaDEvCIIuRIOJzQ8lrfUVzBXOc05GwAQcRBX7dn0JjQrfHrl60C/rOrEtA==", "2ee9f34d-a297-4cb8-a616-5d5abefa57fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2baa1b95-cbd3-4499-b7ff-b6bd7b8e97a4", "AQAAAAIAAYagAAAAEHQVcV2AbAw5s/bvsyLlF09U8HL5Y+Au0MOWESg7qbiDpNZVRtmY7gc906cIFn60Yg==", "c3e1e914-cd69-4405-9a69-089087aad16c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e69877b8-058e-4e72-976d-f76d550e2114", "AQAAAAIAAYagAAAAEF2H9erARGKVE/YzJbxfQyTqrWnLzRhleIkV19oxTO9OGx0TpDbNxZ7C494iBLTGhA==", "21e483a5-4c79-439f-8c04-594546fbc6b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6ff97f1-c379-4704-a95c-387224015d0d", "AQAAAAIAAYagAAAAEBZkxdfCu3/7mxShMZMKOC12M7hNianbNSwP02F3CzwQaO03I9o4j/L3QZCncVvcpw==", "ae5a933c-cb3a-4c62-af7a-fc6f484ea4ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "227ddfd5-34b7-4d8e-a289-fd0a36a15c38", "AQAAAAIAAYagAAAAEIqOdpUlrWjFof6z2j76iokqMMkdD3sXLqgUvHiUEr+kMh4X/ttQGAAuBMcjeh3aag==", "266fd574-1277-41e2-96a0-ea1d5e285636" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad17227c-e44f-4aa1-8ae9-e111dc372838", "AQAAAAIAAYagAAAAEEC/DQ9/GWuCEX0uWv+9BgJwlnZDEgJDk/ZO3H92Asg7W7ifdt+1NXouOYfKkKb+tw==", "dba04cee-952d-43c4-b217-c43e427d57ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba16964a-c0ba-42b6-90c3-c5f8fd3e8ae8", "AQAAAAIAAYagAAAAEOLXvANSdM3zCJY/XxUC6HrXBfXO38mYct4oGx1NE17pj8iAaULym2Or6owvjucJyw==", "20f99deb-8b70-4a5b-bcac-8e39c942a7e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9930b6d3-97a4-489f-aaab-5ae5591fdb19", "AQAAAAIAAYagAAAAEMQBLAKDDaYH/2z2tki0CGG8104dRX5UrQHE26/VWqcGSP2M2B4vwHtV89uRVc8OkA==", "6333beb4-6a46-47e7-a014-d1de32f556c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f68a8ac-0b8a-4960-87c3-f7f0208dad8c", "AQAAAAIAAYagAAAAELwHiwDiBhi6uxxZUvzJedF7CrfJe6Escxl/rfZY1d+M8GJscJveUgGYUfxmTwZFlw==", "75f7646d-1df2-47a4-8355-a1bc9815ebf9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3f1a8bd-ccbf-4427-a42c-1348de27c3ea", "AQAAAAIAAYagAAAAENusMtGkQQOeJNo0dSg9s5jTW4EFjwrVkJ8LAwfvsMZ9l20CzLuSxWsHHdGXcPRKBA==", "ee2beb6f-1e17-43d6-a0dd-49b9d2f78d4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17d52874-3c78-4159-9b03-77bc15bba0fe", "AQAAAAIAAYagAAAAEKuz2gtSsFWjBuleCVOUo5p0fj4aj1phxAJzSFP5sTlR+U7XqWMTNoBxJ3fGhooR5A==", "cc637688-55ec-4c80-8aea-75476ca248db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1635783f-96f6-4db3-a48f-938b9cf8a4ca", "AQAAAAIAAYagAAAAENp+wbqXEgcnT48p3dUS/azlz9g1tU92dA7rAVf9AHo53qKTF3PFz5zlDhDNCcAgcA==", "5f4091c6-b285-4223-ad86-3c74a9b436da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e4d802e-e516-4cbb-b025-5bd8c7918dfe", "AQAAAAIAAYagAAAAEOLV0/JWdrX1jYqz5fXqhhuavG8XkyuzLsUKnByzKQdJoGQiK4FNbwQboAXnv+GJ3Q==", "9e1c05f6-5e09-477b-8836-a09512a8664c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "85128afa-3c8e-4fb2-9aee-a0bddcc34c26", "AQAAAAIAAYagAAAAELNJJ6DoLctcUKdzzVllnMg6td872VfiKmuzVHiqw28wEFAYJ7xYZoC7JMlkc+6l+Q==", "909e0134-9fa9-4078-94dc-4924adca5952" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f5aea6c-30a8-4075-97c3-ef01f4902893", "AQAAAAIAAYagAAAAEMJAG5+5CbzFkBKKYm0fhy7eMdVHilgPDK9ktITw2nzj+UEaCSN9rszSd2u03MFEuQ==", "d6478f18-6abc-40bf-a831-6ad37240a96d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec6a4ee6-def4-49ff-93d1-54015467f222", "AQAAAAIAAYagAAAAEPOHAq5xN+HtmJXDx8v0TOYD+EowARLme5m4hFTjrtcP5UbZhBobziplwcCNBmhwpQ==", "c1966364-7e68-4415-924c-b5d3f5775f9c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "641e83fc-5a7e-476d-bd86-c1f55d5efdba", "AQAAAAIAAYagAAAAEJYKvZzK9Z7FoX9e0zg1ls87JpePT+Hv32flJOrMitrh5tOpXLpwAIJk7Nbj44xXLw==", "03605361-5a80-43a0-883c-15707c9d405b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f5c7857-4f2f-48a7-a17d-fcaea0d056aa", "AQAAAAIAAYagAAAAEPQv3w2WgiTUpqLFzGrVTcWoOE89dh6kFuEcZEHnb/CCcqvlkuHOzBsNYs1tDGTqFA==", "5c57effe-4a1c-4241-a491-1b32d7efdb68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4975b90-0779-4e61-98c2-a8e0bc4dd0ac", "AQAAAAIAAYagAAAAEM4HJDnMjkRz4L2LQnfv1Qvw5MVAxCfM3vsSZj0R7QlNfagcMm69QMM7f2CG496CwQ==", "6975fce8-07a7-476e-9d8f-33f3343e74f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1da19f79-a28b-42ba-bf0b-390fa3b27f5a", "AQAAAAIAAYagAAAAEBt0rztRZL3pt2wjbf2pMSgjOaSPbXVY0lWmFvI+2n39QLzPCY/AZnvHlpY3UzLjcQ==", "60978220-a3f8-4e3d-b5ef-ec5c043c2fc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8035c0ba-ab00-4bd5-9633-3ca8f1dc7dfb", "AQAAAAIAAYagAAAAEPkACHsLT24oevaLBDIu3zdiOXcXRQfYg2gKStteg3wqQObzNO7sFgdx8XzNeJlTNQ==", "6bdf1ec2-07b5-45f0-a9a2-ddcd8e55dc68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6348923-92a0-403e-bb8d-cc1e60ec0511", "AQAAAAIAAYagAAAAEOr04cHwWefIjpdcHO/T4adJ37ScvTmsXTu1a7WKL59PahOVPIQSFUMnCCrSPBuSlQ==", "d768fb13-c628-495b-8d22-e26c9faad267" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c954343d-f114-458c-b00b-3500dbef0eb6", "AQAAAAIAAYagAAAAEEgm1MTBkcfx2Ixe5pndl3erVgtZeOqkoo/gMGq/AYSijyEet5eg0gAdp3+F8MOaFA==", "309e6d1b-2a7c-43bf-8a3c-9f22d1e680af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ca461a7-9851-4db9-9c5f-f685b2969dd0", "AQAAAAIAAYagAAAAEFIg0dVQ2M49Bl3QclqlYRHMdHr/bEIBl+zkoYy6pMP+20BNgORYNkeXqUvBiYvE+w==", "9854b32c-6447-494c-addd-b0e0b33127fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "657898d2-4f03-4f79-bfba-4705cd79f24f", "AQAAAAIAAYagAAAAEKIl9IZRKpsbAVjj0ZRJibJbp1vSl9m0ndbQ3vaUv1A9d+Gd4/tvw4TOcFev9bAa8A==", "44beda1a-7e0b-439e-abcc-a1c3beb5e635" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0fc4b8b-ca52-4020-bfcf-94d85e7435fb", "AQAAAAIAAYagAAAAEPBDC2SA9RIs+L+Ah6bGtz78rBMEAmAGy/O/MxwsNRAf2ZmhEtSwEku1YoIMkWOO2Q==", "90eab7c9-73a8-416d-a2d6-9d2df6f5127d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86e25105-4c1f-48b3-b2c3-bf42fa3d8de7", "AQAAAAIAAYagAAAAEPW9Slg+1CnQKl5b5aJHWEnLcR7fhPg13LVZI7oxXcG7FkV/ijc+kUv0Ws4aKz5E1g==", "508702b0-ef96-40a8-8a24-6be0c9e35e57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa6e80e8-904c-4b73-b7ce-2dce25bdf2a5", "AQAAAAIAAYagAAAAEPCNAYdIQrXWcF6YrLdwcrc1VnG4Jw57RXx/HM83B0gaPG9HWUHMnCZLBKbO5NvdYg==", "6f1aadf7-35af-4e1a-959d-aa85f0db6a9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40ac39e7-bc5c-4e01-bc4a-9fe55fb7b863", "AQAAAAIAAYagAAAAELtxoNVSynGcvf0x5dg7pqYxg7sfveGrh/3BdPH9gGHgy+9Wlmwse0fHdaH3O1ANPQ==", "6fcc9bdf-93b2-4077-81fb-fc378711e1f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "204f507e-33c5-4310-9950-a6de84bd0a15", "AQAAAAIAAYagAAAAEJ7+SkBjkUs16d3oSnTGCJWONCXz8uIWUyFEXR/DjM9fm023vCoMhfMwCzzD/H0rKw==", "d08d9087-70b5-4321-a286-b99f29421581" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec4c29d0-2951-4270-a444-14e109e91e29", "AQAAAAIAAYagAAAAEE0DueygFl1+8w8kdQVd+InTs1KpjGsXKeCfe4b84JDDUITShZEVSzbcKAW1Us6ruw==", "a7f2ce43-c9c6-45bc-811f-39e4086d0a50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e89fac42-98d5-4d81-b654-507d57e4f853", "AQAAAAIAAYagAAAAEPY7A4hNxJuKpc7NZ6dQmY5iVvdky4LvdLh/YjnMD1PE/iGd/bvGCaR8YSPaJTzn8A==", "7bf82e02-fd91-4f3e-b146-dc5ad543dd52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb1b209e-ee44-4d33-adaa-643c6c8f2301", "AQAAAAIAAYagAAAAEE6TsmFJRvzKsziNX9vBh1zzRU28pAwcsuCbn7sKTZTX/YkEkc+Xvbx4ppj69j7WBg==", "92f28303-c941-49b6-8a33-0dc660564c7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99db6db8-11ff-4542-94b2-d289b26953d4", "AQAAAAIAAYagAAAAEMpQoNfx7R8mi5mgpCSUxXl5TPn2lA/su8zYroUn3v5QDNiuAKHnR5+mYBLYXegr8A==", "22295469-0df9-44b7-af48-2b6103445488" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e573c046-adba-4e68-bb11-186c5e40cca1", "AQAAAAIAAYagAAAAEPD7nmdl29gCk5un+eSPG/0dpL1EMlc0kfeVMt7xpHLp9lni/HS0PEZg6EOVndgE6Q==", "9c358186-2b46-4bf1-a587-395288635d57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5f60fa1-f2a0-4b9f-a9c6-55d3ce4a9e31", "AQAAAAIAAYagAAAAEG36TBQBRxRZVGcK8ksRQqiXSioDiHk/TkdOxeTytg7Yto/vzDxwq9ke/07B3A/1bg==", "c06ae6eb-bdff-41dc-af4e-be33ec0f1074" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c087da5-5794-483c-8a85-0bd3608c1501", "AQAAAAIAAYagAAAAEGbxF4ZvKWcs67qs3DIzOr81vlTlMwB563SarYnCdKsM0t62VpvUPBOnyWYDPobrOg==", "45eb0da8-e99b-4b1a-ae24-d66b7d61305e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "662aa11b-31d9-48d2-a899-22e452c3038c", "AQAAAAIAAYagAAAAEF6GFOlxDX42NU8xEmqhu5x+RHLu1YLHOz0brspMOh8X6b7fYl0Ln/xCHoXw4AWtuA==", "f62e73d0-e45b-4fb2-8d31-e0d7edddfd7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74d9d9ca-0af4-4854-9ab1-f092e75343e8", "AQAAAAIAAYagAAAAEMOF9RdI7X8sD6GS3zeoXfaClv8uUQ1LA5xTVxU/E/NVvKLOJzSEAb1akL6CMZ+iYw==", "a6833b79-f1e6-46e8-9a42-99d5e747564b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fcca8534-93d4-4ec0-877e-38a18b060d0b", "AQAAAAIAAYagAAAAEHF9QuwtAp3gj7Y4Qd5O+0E4AKDcukXPKXupfRlyNJXOHbM5Yxm0PPNwYJ5CQs985A==", "0211871f-4b0d-4e04-9ac3-d7521d441633" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed070f2a-0b7d-4da1-9af3-a9a5923fd3c6", "AQAAAAIAAYagAAAAECFwzdVxdB/+6b+Lxu2aYkDvZmythKtiF8PI+LDS8ibrNEEIe00reaOurdU0Iyz0Xw==", "708a38b9-6fa3-4544-86f3-49b1303cb5b6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "624dc329-f5c0-4341-b173-843b3b124204", "AQAAAAIAAYagAAAAEPZWHshyt06yLLRRmd+YR7XOy0YNbw9vs+hKZ6u06D9vXW4cIjzQEWWjOygz3fKwqA==", "6bc63ca2-b767-44bc-b571-699521858aec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "781055db-1a4e-4709-bba1-8f49b7f507e8", "AQAAAAIAAYagAAAAEC0QksONCG12nxsi4OkAtw83ksZijWXTjUJIGcpZWbuXNCnwsx//YL729vO9gDgDgg==", "ab814178-a02b-46d5-aaea-20ea3d20ce96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be413419-ee0e-487b-9362-1a1e0ec2da4d", "AQAAAAIAAYagAAAAEOrjY5DgRe9I3Ql7kBNAAXBS7jw2R3QW6omn97wpRanwISo03TVDx05RdLOAFtTLcQ==", "37c0acae-a938-4ff3-8642-4097d52d59ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3b3b32c-af47-4fde-86d9-a6852e3cade0", "AQAAAAIAAYagAAAAEA9jXlOoXHAH4OOMMfOGYDOjWBZS/deF5PkicGuOwN6mrOT1Xy2IkOYWFwBTOeCJCw==", "85d9b91d-9634-4ac7-b697-9eee895c306e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cc9b309-3383-429f-826b-c2242713e5fe", "AQAAAAIAAYagAAAAEOTHKj9cxd4Bk9+UoiYGkNNlRh9g6FKluJ0U9MqYUYTt0PlspN2nqX7wFuXwf+n3eA==", "ade1e5bf-ac7a-4afb-95a2-ca330f5d8fd4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23aa89c5-3902-420f-bbed-e5dd6a213893", "AQAAAAIAAYagAAAAEGGwRmCrtXEQkB8rfX/pc2mkQySNEGpCyoIdBwpLOvjuu1XPm+5uk4LGb412Uk94rg==", "1a4ace7e-060b-4e43-a3ef-20e075ed1b80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e636e56e-7cf0-4f44-9c09-1c6f6f1fe48a", "AQAAAAIAAYagAAAAENf1gbgSa3WmBwewwlRLzgl4I+D5tZY23P9C5/zSLRhRu+fVqwapkIoWZv6auHlddw==", "4269ee26-8a1b-4ca7-9e9b-3b027212108e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e8cb6e4-8cf4-4276-b747-dd52073fc83c", "AQAAAAIAAYagAAAAEIYbjLdZRs0TY9UCtPDAX+c1wi8GKdM8zSMYWBAu1gMtNQcPHUR0KNAEaHplE3aKGg==", "91094a59-13dc-4317-a299-c25bf0ea3a22" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6929bfff-ee52-4293-a9a5-9c9b218ec45c", "AQAAAAIAAYagAAAAEAgTYFHt1fVapO0VHx+tKlmIHCtM2/HRQWqjd1y+xAkxRCjlAt8uRWhniK+mDE4omg==", "e4cd3c05-56e8-45de-a8f0-6d09b3b8110b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2206bfe3-3afc-4c01-83ad-1862c65a3bfa", "AQAAAAIAAYagAAAAEMt6D6gplapafBwtQQqXRrhDzTVAtu72ZdN2U4aMCwGXEoY2C7Vupy1Jd+rWLc8eRQ==", "62244823-d715-44e3-9501-29996135de8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14e64d23-b929-46b6-99ca-3a03f8da5259", "AQAAAAIAAYagAAAAEJ/r1EhG1qVjw6nw5V4IIP74a+zLfo6jO2aiv5Y5GYBVQ30QkXSPuL/Uq8pkQqMphg==", "d218a099-d540-4388-acac-e9a250211c05" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "afe6bc18-ba97-4188-a309-74d798979b9e", "AQAAAAIAAYagAAAAEC7l+eBu7I0EUjdDw7eqMV7eL5s5PzpsLF5gMEgh0+PJmK1T0w7GOvsc99HltNb+ng==", "832bb6d8-7d45-4715-a6b1-4f1c05a1a9a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dffae731-31a6-4703-ba49-d914a071d005", "AQAAAAIAAYagAAAAEFR5nkSedZyU09/Tq42k+wFMo3BTh1244KIyg8ZkzgOUnB0TFqx5rzLyS99sC+6GRg==", "f1fe58fb-e0e9-48a1-9a99-213b00da2783" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f8d010d-0b57-4eec-8e4d-55b2da49fda9", "AQAAAAIAAYagAAAAEDNC6S3S7X9FH2hQQ/4rWSaWApZf2aBhkRpk1SHIDAZC4oqujVbbbYIUfyAVj7C6+g==", "5f15b8be-d04c-4f0a-b948-606c023276c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "586e953e-7e6b-49e6-90b1-54b9e50330a7", "AQAAAAIAAYagAAAAELIuS975bPYB5ue5wjXm3HihbzLShrzSRWYu914UA6Diciagw2kR8zirZKC6lCNtUQ==", "065e8752-9eda-4801-bfd2-fa4596a57ac9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca7671f5-ece2-4a7b-a56a-f3476724739d", "AQAAAAIAAYagAAAAEDiWHWWLEzwjnzp2RSzspmYIPrBjlNG4297RgfnYPgxospsUC3J0Abal4U9eDFugJQ==", "718e0aa2-355c-4851-83c6-9e522cd77aa7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93b82302-b42e-4707-8062-cd2c63ef247c", "AQAAAAIAAYagAAAAEDogY4yrkiwmwAyGXkAh6rCWSIJQQzyXkPCczoZKR3rLwVjjXE7VbS4sTVUGB9MKxA==", "3893a67b-58b6-4ca9-95ae-7192d6d157f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdbc36df-e4da-4a39-825e-cda0845704f5", "AQAAAAIAAYagAAAAEPNa6tfe57bmQkPe25mqRGEpq82V+iJLZA4mB5ZjNSTacc/UyxYLVM4TNp2lHo0pIg==", "17afd207-4a08-4c1e-89e1-ceacf30b2eaa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b3810d5-5774-44fb-a93d-2a71e1e2ea8e", "AQAAAAIAAYagAAAAEDD8Ti+FOS5Szkfr/Dg7o+BkqmlTm3m4b5ZdQOm0hVJLt7NsMrknsko2MNiQc+4WTw==", "2c7a8302-216f-48d9-b1b4-5e2344891ecc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ede0e469-db0f-4b02-9fcf-c4e507077dd3", "AQAAAAIAAYagAAAAEDNBNuT3t7ufzrukizwDrA3bj6YEmCB1ZcLzsX3f6Tq1ZaeKCkSUAMlGYAdydckNXA==", "c3c90857-15c8-4242-b3ee-479801b3568e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac5ef75c-f443-4aef-9669-a04ee967bf41", "AQAAAAIAAYagAAAAEJcl3LnzK5RZNJI6PpdRZlJ00Ve7zdQlZvmGZTWIh3Khr84SjszhKmPGk/4tnC8hSA==", "00a316f3-856e-4307-a9db-24770ed9d65f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3932e901-edeb-43be-823c-15dcd9f47696", "AQAAAAIAAYagAAAAEEOy5+QJAjAvC0L0Om0wbLRZyj3Yw+DG977SQEXZ6gzwVQdEu3f1IxHIvO+P/jG+2w==", "60e94fcc-3d53-46c4-bcba-b42f73157828" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9bb8444b-c10d-4dc7-9e04-214c69fba3a7", "AQAAAAIAAYagAAAAEPw/rN52Oqm4NA4+wIZktPuSTAPEKbRj1Jfdjq/eT2XG/qhKI6LiNWniyZGI2fGwGQ==", "f03c8764-aa4e-4175-a9d9-669e198c69e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8eb5d9d-6320-4540-95c0-7a7090bf84f5", "AQAAAAIAAYagAAAAEGLOHSF/+gG6O13q7WHh2TjYiYayIaSkuiGAHfUTQe60bDiIj3OII+liYejnQVNuiQ==", "8b20239b-0d28-49d0-8c84-d62bd5ad6647" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea2b603f-0983-48a5-b735-9dd4695a92c9", "AQAAAAIAAYagAAAAEOLsw5mT8++0PQ30GR/HivBX3VgBCm3rl3V+WhZknqHXsboJRmJTaU0jKpaCBUVNTg==", "d3dc3538-a153-4d23-8f3d-83011442f4f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7abe8780-a9ba-4fe5-b76b-75894b9ed95a", "AQAAAAIAAYagAAAAEBs/fRqJEkKDHb47BOiKCR/LFhHrfG6/YzRHMREVhG83VQhsSc536rpDtNwR/vf2Ww==", "541c045d-6a05-40bf-bdde-c6c68dd686a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7942e71-2945-4aee-8507-227e6ff1d4f0", "AQAAAAIAAYagAAAAEAbUpDyb1m9bwhbb9WTH6yPZhrxHruGgb4d4yvrX/lfFV3B8GXtCbPAWCKkgY2lxqw==", "32fc77c5-2475-4965-a795-7cb81eb07b56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0acd9bf8-2320-47b0-b4f2-a0db6e54c9f3", "AQAAAAIAAYagAAAAEPoJYz/lIUtWkXKcZ1r/6n3N6R5jK9Yta7gPVHBXmhFl9BQJNbm3KzTc+9gIhCnzsQ==", "9b1b36bf-927b-4387-a2b4-126577c79016" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5e4ccdb-6ef6-44dd-bab3-b13661eb51a0", "AQAAAAIAAYagAAAAEDUQ0LT+k7LBrxWehvHwsWHMxHPY51Ue5biXSHrFc0ut1Y6366o5URXwRK+2UsHClQ==", "b6043d50-bcbf-4a1e-862a-fcf55be37b74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5da44d6-cd61-44ed-809b-1a862931e7b0", "AQAAAAIAAYagAAAAEIQAyPrVHAp1FVHLiQIcjG8xT1DhUvlzSHtafJWoX6sV9c+/1umMGGzrEBYOeakNuQ==", "a356d099-2498-4947-bcb3-46a7ba086ad2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a2cd879-73a5-4be4-92da-ff96a92a87c8", "AQAAAAIAAYagAAAAEBucp66p3Ny7frpMa1kh4iDD83mHAcfOLsd3EAZO2Ld/kP2RRI7sY4gMTqz4W1QwIw==", "52e50df7-514f-45f7-81e0-73aff00547cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70d5eabc-fcbe-46bb-aa43-6a23dff23b1f", "AQAAAAIAAYagAAAAEKWkjZLWOc8JoVO5ZRnbFlKhvVvWZzdqrCK/Pl529+gulLSTf3RQmIf77p4jncKttQ==", "19f66e75-f79d-4b99-8db9-323e9ebc5da4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae13c32c-b525-45be-9a1a-1bcd6ff00e87", "AQAAAAIAAYagAAAAEEz3gXWydYrNVJr3UzZTH8eACctuTxQIkR6BBEtKsCD/mS3NRck6+8vQdXfIFWnVyQ==", "a9e991df-232c-4012-9743-105cc38501fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "808f1b59-1c33-4f93-8fdb-86753944a5d0", "AQAAAAIAAYagAAAAEJiEze28zoL90YnJLR9cxgokPlhkGYUpK2de44I561XmI/R0UzRxLoeb1LjtZIIwMg==", "40a57fd9-abf4-4275-848d-94181d36eb44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "12f0fae9-6de4-4cc5-b24a-6ebf3b7f3b93", "AQAAAAIAAYagAAAAEIStzWmDwMNgnMdMbjoHh6nZS1ERpLzteQxrWQwryriwUNd3sJfgIdkzNh0oJTqn8g==", "ffeb315b-7b17-4bc9-8fc9-575e8f4178e6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "642ef434-5447-4bc2-a13c-555495f54e72", "AQAAAAIAAYagAAAAEMPwv4fkQXHUuQF3h7l+guWX4kWNmJtCo8nDAtwp9sz9LH51WwwIVs9lwX0GSZBHRg==", "e9337108-004c-4191-b34f-defec1bb6807" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fc3ad9d7-969d-47cc-bf89-446a3423b270", "AQAAAAIAAYagAAAAEDoUpM5XgI1Yj5IRGnMoF/tbhOUZhwW1XVNq62UiMtP3WvFZxL1VPXOGyVreGdRqMA==", "68e6e0b3-9535-46e0-9a1b-a79b937fd14d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c737947-143d-465a-bbe3-c8362bb74876", "AQAAAAIAAYagAAAAEHMr6BGxblijCs7FFIM7AA0GqFtW95T9TBAJoJvPUk6OQlm1pu7z+wuW6+alL8jtcQ==", "86e98b4c-fce8-4c14-bfbd-7ffc978b62c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "068b6b2a-36db-49a5-bda2-a558a2763441", "AQAAAAIAAYagAAAAEKA8XwCUqCkXoCVHzl9cNNo3lobIX4pHifLLnZTHWB4ntruSNNU7ybAoFbZtfPlLHw==", "cdecbcb3-c6db-4bf5-8b0c-55fd7bdcd6dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4d056dd-6229-4dcb-80b2-1cca04317f25", "AQAAAAIAAYagAAAAEKj3gm3uKXC+6aZuoas5KjjwTjWPFcYbLbdiuNInoPiz9hJNqPQ32th97Pkg1YiGlg==", "8f36551c-6c9c-452e-ba3e-a8943b97b477" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a635aa6-f6e5-4ad5-8310-57c481861259", "AQAAAAIAAYagAAAAEBUKGG3RQO5BVD4rxDhoEkQ5CROcFni8o8pZYt2HCKpJhYCmoZDprh44yu6SXPpZmQ==", "d665a378-99a0-48f6-a2c0-f91e57f57a50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "618eb881-adfe-4e9b-8c3e-ff8fa3705686", "AQAAAAIAAYagAAAAEFQTVWDbUcmT7W5d2TxPKLOE7h4gp49RlbUwMTXz/o6pASlJIjAa3cYfUqfLngnsaA==", "0b6b074e-c367-489c-9c18-8eb1a465e314" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a27d6d00-cd69-4455-8a8e-7ae068982097", "AQAAAAIAAYagAAAAEJcGEGYTiRxYew+O+uaaKee+Obf3HyYz/Tp33vO5g03O/WjXmFb8hiIXID4lPfJMkg==", "a4143116-635d-4a37-b165-db40d7b9fcf3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3c4d237-da2a-48ab-a95c-b5dfb3f6cacc", "AQAAAAIAAYagAAAAEK2E0WWafZL64/D7o2Av6yWDHk8S/ffF/txglJkrGxrm9TpDa4Ia1nb2zo/mke5mjw==", "b2cda09b-e749-44f7-8c09-c1f8a7d08b3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82f09742-1701-435b-b384-325fb931dea4", "AQAAAAIAAYagAAAAEMOpaqOe6tj2wrAt7fqILF7x+nZPr1fLnbF97nwsnfUtsDg2x4Cm513GSyU7JhU9sg==", "913adaa9-c8a6-4e59-bbb0-e7d2246fe85a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09593234-30e2-4a6c-9bf7-80e9be8f1413", "AQAAAAIAAYagAAAAEPYbYsYEZD4Bz9uoCqyyt/QUaTYCm6aIbAKjGOCnVftjJIMOat9C42BGQifzGQzZww==", "c7532d6f-82fb-48b7-87f4-bc93f92be1df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5ff86c1-600a-4924-8c37-098588743fea", "AQAAAAIAAYagAAAAEKAa6sW1L2x6pO2/KkFptwruF0TGiFIYHr2wWS4UQvpZyN+eYSyhqYwH3uE4BHx59g==", "d6d4d931-3585-42aa-af62-c5d0a238a2fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58558de5-6a0a-4a1a-8a87-3129f30ed9b2", "AQAAAAIAAYagAAAAEAyqA7DY7GX5WaUMVmUyWlK0M6pEE+x6M0vr4fr0gFb6AJxJcJfNBIyEh3073pw+Hw==", "ff24a2ec-4d7d-48ba-90f5-1b51441039a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "307650a9-f54b-4c2e-925c-c41a10013a74", "AQAAAAIAAYagAAAAEHDO/VgetB9WCjPiqh1mnERTzsVNoStPbQ/fZ/x1R6ss5zXDQMlrC/oRt2UR9Ms7FA==", "b32b443a-fb63-4749-96dd-c3d6bae8e74e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "182eed70-ce66-4815-ae85-244e636c5ef7", "AQAAAAIAAYagAAAAEMBFBEs+15Hq0HDTKRq/GVxydvFonAc433iPEBYQlR7wF+JCbELw2gB3SQSqEN/pwA==", "c0d790b3-670b-4ae9-9509-66aa2e49fa3e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d502197f-5b6c-4591-8064-3fa29462c96d", "AQAAAAIAAYagAAAAEPwK1hhZIv66P9a9hAG7z7ns9HNnS3oFwGwjKGxhV6gqTPMRJ1oEODsFyQ2dXu1bJg==", "a953ac22-8ca6-460f-ac48-cdeba0eee346" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02501627-c796-4aa3-9b4b-1078d2cfd31f", "AQAAAAIAAYagAAAAEAdHuUh5q9A4kbjX1gU/HzhoE+64NNDyMg/Lxg0fWInlVa+mhgq6OwAwOJMqSVj5Ew==", "dc10609c-4443-4ec5-b735-92d814bcd25b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8721d7c5-0a08-46d0-8cf0-0e94b31ef551", "AQAAAAIAAYagAAAAEPJeL6xVDTX6Hgry2xtv5so0OB7LQW6Q0m73iSQFIXqfux/BkH0GeIpB3wj3sr7IeQ==", "6e6e0d10-f83f-4d05-9cc0-63cfeb220292" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec5fac7b-4bc8-4a45-8edb-5bb2cf5b77b8", "AQAAAAIAAYagAAAAEOV+ChW797pLTbMUU051ev7ndpDlAqzJtZrqR/opBZoTGuRhbZiO567Z9YeWwfZthA==", "43056430-9877-47f9-86b1-7d3dff015ebe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4feed654-e90c-4265-8296-32782018b1df", "AQAAAAIAAYagAAAAEPcYruRQSZeRRRnhykCZKnjY8rIMZaelZK9g2qcN5CsKptMOwOsd/ui1iJf2pscR7g==", "02e516b9-baa5-4bbc-983a-5fc3e2d315e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d9780fa-a2c4-40f2-92cb-a4fbfe927185", "AQAAAAIAAYagAAAAEAJ6585A0fhG8GyH2lBamW+9+QAxhsPMRmpSnjFVEwgzLVXR9qqCf2e9I/DY1fjeMA==", "b1911315-b6cd-48b5-a5da-750c0ffd326e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0348609d-5445-49b8-b0bc-baae52b67629", "AQAAAAIAAYagAAAAEGeh2WoCzDGCzHwwvME6FDKmBvscpbnvdxIWqPwk7YGbtZsl06rpR8mcPrh9/UjC7A==", "833df94a-b635-451d-a5fd-acbe3ad6ebb9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba124c43-03d9-440a-bb2c-4e2757f25842", "AQAAAAIAAYagAAAAEFaO1vdYnlkiZLaUtf8XABML3kQlRy90NItkmg34dgC8MvOiBjqs5Y1OheQYz9syKg==", "fccd9a0e-4d08-4578-bb2c-7d428be2713f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb7af100-23fe-46d7-a179-05741d4c7610", "AQAAAAIAAYagAAAAEA/rmYaX8gOvWtzCHqZSn45tOHX28TEMrJjBqhyHWGJ/gLuVhi/wfd9P+39Ntpb3tg==", "8eb95488-29b0-466b-b513-8ae31845456f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd651fd7-d3ad-4775-bcb6-30f62d3253af", "AQAAAAIAAYagAAAAEKB8RrMUG0Mx2YTsEw+kzz2UCxr5/biG9etOPeS63rfdHzAlDF2xFnQgIbl7MPZCDg==", "42b0a2fd-d7fc-4313-b88e-4c7c9eeb065e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "151da538-1be2-47e4-b065-31272b2e6c6d", "AQAAAAIAAYagAAAAECpRMq0dGS5hVZ98r4o7FJE8O1SXmSDVfH3SW1rF0X6idScXT60MauRmixxsoVnaGA==", "16aa4114-e980-48cd-a11c-1fb7b21493ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbd3c8ee-e7b9-4212-a024-6ef0e8e4ed35", "AQAAAAIAAYagAAAAEDtUK8qlgVPZNMg0LiSfnheBO8G67j4cgw/4ZUGjoO1VeL+K9ALBxhVygpJIR+GIGA==", "757a9d7e-f5b7-4e19-8b98-3ed336f9336b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ae42949-a185-4f93-8d43-1b56ff65cb68", "AQAAAAIAAYagAAAAELnORsS1Kl09IEJ0ejnnxOTNjmkxSI7u3hGLECdfO5ZeyhAftN0ug8bF2JjpEwxi/w==", "0432d350-4149-4dbc-823b-29af3ed37069" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6dbcc2d9-25f7-413b-9abd-6d8b254b8c34", "AQAAAAIAAYagAAAAECcVyj4cjrmkXklOwNa/N1GWOVdv1LNj6LOSJ0R7UMlOPxrPpb3125Hp/xBPPj62rQ==", "94d7bc97-c936-4fce-9920-2767338e4270" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d147c3d-268a-4a11-8b83-59341520d81d", "AQAAAAIAAYagAAAAEHB2molY0+BAuyI++e5m4KiK28kd0D88v7ynFr7L/fAlZjG8QCZJsDq+hZl5srnHdg==", "7ecd4cc2-fdf8-4372-8c88-432395d077ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45bd378f-3141-460d-8384-2d99894464db", "AQAAAAIAAYagAAAAENvueJ87tw64o4UClOg1OSTw0PXxhVI6w2m1vzFgywLg+CUrt3NMO8VQ+HuzsF7pqg==", "6af48865-ca5b-44ab-aaff-aad3f8e65311" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3efc78f-9a6f-4aeb-b536-f7814a8b6bc1", "AQAAAAIAAYagAAAAEA0KXUZIHuJiDSVqz+p/7FzG1YHV01n7Q3JEFsiKRHk32OXkCEg8rFPl5vExfXWc2g==", "193b7a49-5b7e-4d1b-bb6a-4dd119e85fa6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b55df74-fa18-47ad-8b95-38ccad9a5736", "AQAAAAIAAYagAAAAELPSMtPdY5xEqlBTbRZZoNXe9HjmksCiFFK4ooB+K/qatzyIZplwdVURz/PTcR3edA==", "872f881d-0ffa-4847-9c22-c8ed90fbe65e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9009df52-ef80-4836-98e6-56c23cf993f4", "AQAAAAIAAYagAAAAEIOOQpj+Qfi57vHOmU2pdyiUfcJIwPd1vIQqBOu3HLvUaqJcPTnqaKnBZiESd2R2qQ==", "0449bf75-4eda-4270-b3bc-9b892dad2219" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3187455-3e9a-4181-99fe-f0dfec5771dc", "AQAAAAIAAYagAAAAEHDyUHY+p9yocDm+c2zS1ZnIvBtJyb/ypqU3JlY3s+vafwxjMOWYvdqexG9I8fkRTw==", "80bd2495-ba2e-4b9e-a162-82583b966404" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c46e2b78-01f9-4921-80bb-d417e34f185e", "AQAAAAIAAYagAAAAEDimq2vrFmww+g4SV+cZbtYygEdb5cdgcNvXpX8EaQTG5/ZPkIe1moZN/1ego/5Lsw==", "a0fddf3d-1e61-4d26-a1c8-304a0d4c384e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9f69021-a18b-4a3c-925e-7f52e5f4ce9a", "AQAAAAIAAYagAAAAEBapMh0o34pW6g30KYa/Mw5/NF6LKKmYkhU342JvP7BiXIWj/2UHCvUk6++HqguPrA==", "d057ef1c-a5e1-4e27-ba92-3297090f8eaf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4351e797-a88c-4751-b257-2ff5c73f04e6", "AQAAAAIAAYagAAAAEJqCqyV5GV4kXZd2fA3S0J4AKiN3JVQV5kUq3KyYdYI8uxA07KqS0IgFwL125tlb1w==", "46f54fc4-546e-4285-9f06-92681481682a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d2d95c5-c821-43f3-8cf7-2c4ca0e6da28", "AQAAAAIAAYagAAAAECn8o6sF++b7fA+re2w6hlADVXNYbxWP9mGSmE6lxft1pYYOnX/7w6hj87CJOmy6Qw==", "1107144a-b532-492b-bce3-d30a496a71a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f935cc4-f6ea-4ccc-bb52-2d08ec82278b", "AQAAAAIAAYagAAAAEPNfGcreW4iAjCuym+TNLV2bDphS7XG5gK1444/t3CguoGg5kSkjIqVOvrOHZ03hKg==", "90ffc078-cc54-4ece-94f2-0a3f24034c71" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac63004a-28b6-4b99-8a52-33b6128d2357", "AQAAAAIAAYagAAAAEB/8U9BnCYWypui71oSf1t+uct+NLUvjsYDx8IldM9LxhDl0WtsJSegiNKJso39gsg==", "296c6f76-391a-45cf-b058-0bc8f8feb75d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "555ead3c-b0c6-446d-9a2d-524105f34b55", "AQAAAAIAAYagAAAAEOjDPXr40YpRwtYF8G/amrkJVkIg21f1A7WMnJi7oXjJ5JyNWKcLAx9jij5XlQFEdg==", "83452867-bf47-45ec-b73e-1c4c4d903eef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07be7c04-a925-455d-8eea-42d5b277f9bf", "AQAAAAIAAYagAAAAEMucsW6a1sdzFbA45YXUiVFhJW8xO6aR+xMY65hErS7zRgQh10ooljEWpIX5FH+rrA==", "fe34d3e2-ac32-4bb7-b957-fe62f32bd24a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "16b9d2bd-1932-48d1-83fc-c2cd10efa843", "AQAAAAIAAYagAAAAEJrcVAk03NcKbl2f3S8smgXWXmRBCeWGfbbxH6WfIFNpsr02zO1AZODunPaUzMTPEA==", "010c1d22-3727-4597-9ce6-5f1bcabb26a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1dec2ce6-312d-4913-8861-cc326cf6081a", "AQAAAAIAAYagAAAAEOOpMRAUIPG3jIflyDBAOj5s2HEfrzYaaqF/8T7CK6yUufAUWbm0+OBvJsZnqAer1Q==", "a6aeb78d-1a0f-4939-b5f2-36527978be83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a53255c9-4316-4af1-916c-8b7536a3034a", "AQAAAAIAAYagAAAAEG0WcA4hUXtIw6y2ozwUaqlVmItjscpcC4Czb+EbqjVWxowFiUHF5+Z9KAxN3V5ZlA==", "4323d726-a8f9-49db-b50e-918506ebec6d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa359472-3450-4070-bd09-bbd53412b8ee", "AQAAAAIAAYagAAAAEIQxUggmHftl9vEbOBGFPmzZeWcNK9pPbF+fc2T0Qr/ZGbgRd4xGQk+O42YhIeGZiA==", "1856c751-56d4-4ad7-9cc4-689fb6e83e36" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7bd18666-f6db-4aa0-b9ad-aa95e9c93b74", "AQAAAAIAAYagAAAAELV/CH8CjtB+pxTtWJ1wjhJVHIugzer7UnzGsKWi4FrjVceBHcXF9I2QLgqYlEUxqQ==", "f690d9b5-8e59-4a6b-9e17-8db66fb2e18b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5623c12d-362b-47f7-8e9e-fb07c2ea12d3", "AQAAAAIAAYagAAAAEJOPBfFk0f1bzNUbDWMpY8Ws/PJaUAC7Q61mGIszzQkzwW6ohGmgUZSoeLuITdy0jQ==", "38fe3244-acb4-48fe-a26b-c77f450d24ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e750025-0d9e-49a8-b40d-eb377e19587d", "AQAAAAIAAYagAAAAENQTZrXAF7dhfhD4eYybGm56Ld0khL6G6mNN/FG9R4/y6gR01qZ0o6M1JnXGITswIA==", "19bcea0f-33fd-44c0-864f-4600e990fa2d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d88c2aee-f85b-40ea-ae73-a3052c5212f6", "AQAAAAIAAYagAAAAEGzFVfKwUbyBvO+DIWLLv6L7RhamPdq+CsS8nKIUVI+D9GefmDvEQFkUgGHXIasHPA==", "3259ac87-9485-464b-8172-5ca9aadc4ee6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d404fc7-ed5f-4532-aacd-298f622adaa0", "AQAAAAIAAYagAAAAELQJsQMeFnoewM5Qrf/AD3q/AXJB0dXEx5M1v3vscsw+Z3zKKLXHvbeYq5tOIAwFNw==", "8990813b-e962-4cef-b726-4e4e53969f06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10d308db-8955-46be-a85c-15e4a74775ae", "AQAAAAIAAYagAAAAEH9xjJr/QQJ1Kdc17p1H3E35e6g86S/2PjxDqpcqg5cRtWuh0kG8Nj1MO1ruCdGuRg==", "d5505ba6-4145-4351-bb7e-a8bfb9034c64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "904e470e-0721-411f-ba8e-b1e04741bbcf", "AQAAAAIAAYagAAAAED6rC4yBC/8MXmY+WSbT7Q2e78fS0mrMy9OH68fjdpiis8kVm4FBVtTxNj7LEtyaIQ==", "6f46eeed-24d4-458e-9ab4-c3031119975a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f21ce88-2e44-480b-9dc1-912eb6ce69bd", "AQAAAAIAAYagAAAAEOyBoKf1dgBNPx7OLzT9DptPR7hi7a++fACg+sk5q46qPNIG4jYxzyYrugpHJphwPA==", "705e25c5-1fbd-444c-9e16-212233ec0dd7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea31507c-6f6e-4b41-871c-6bfdb438384f", "AQAAAAIAAYagAAAAEJ1Ulp7LdVotf3XxmzgbGOxxcDax8WEAappRtM+L0zndbIngrYmNnX353j1ZQoTfRA==", "845cf25b-41ca-4521-9f53-4c25d600af4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "298221b7-4c79-41b4-9b0f-98e148920835", "AQAAAAIAAYagAAAAEO25wbFv1zllsfg9MNubEWh1KGSjCL9cLbNE9iTWSR5cdwcGz7Lxgmv0VguBoLmfAg==", "2cdd537f-2a4f-48e9-96b0-1ca3098aa198" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "503f98b7-cb19-4e31-a20d-5c1b0281327a", "AQAAAAIAAYagAAAAEPWlW2oKoAVxLefZkXwkMuRTGCUjnbJ0yveeoNYqX8M5mN/8EWAWgP+3g4BouUOHsg==", "6c84b68b-57bb-44ce-b761-fc1003fbeb90" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff74b5ce-007f-47e8-97a5-0fdbf7b8c3ec", "AQAAAAIAAYagAAAAEDPJZk0ZrepNxgLnbM4kMbjGczBogkwvzdCo0+0/OkhtghzgFC4aJMJMJ2+wItCBwg==", "89263b83-78e0-48d7-8aff-b43a5ddfc1c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e589013c-60c3-4922-9150-d4a2eeae4132", "AQAAAAIAAYagAAAAELna0xaRFbT+DEXvdgy2YqBHG8aRG7RACU3xqf24O9+G3/utn/qNNzhPiBZ7hrs16g==", "9740355a-e558-4daf-9863-15b977f4b114" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54432127-1867-44de-b418-fd59a744720c", "AQAAAAIAAYagAAAAEKJwQZwTFDpJNzBiMQr37pugfBrFQ3IgNW9bTuCXX4IJ0fWGZhdBz0NeUpHNuewRCA==", "72d2a382-ef9a-4cce-b0e6-ad8c9c4d5a4b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "966dd82d-0f17-4b51-ba64-b3617d966b96", "AQAAAAIAAYagAAAAEH+6zRzBotu3Z87ZEtXhe89JpVCLewiYLh2tDJrZWHpzF//3WYtYhHvAV6FMlQ/0dw==", "b05d2b6f-2684-4e80-9bed-018a9111110a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7d9ca7e7-b379-4859-acc1-05e895b88c47", "AQAAAAIAAYagAAAAEOnTj1eV3Y1knMJuAlRv/MOKqRILi0g8xje8S+FRzN7z9sza0plYE+rzFvFRQWZ3JA==", "c76f57ec-5411-4797-83d2-01e593645b8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00af7897-5c04-485f-9f66-7e90be8cb145", "AQAAAAIAAYagAAAAEI5wyPAptudz4VNJcc3V83D+OaDQV4C9iRLvelQZllD4ZPBc1MVbm3cK6UN8+msHig==", "b5e0de21-6a45-4a2d-b415-177253b9eb31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "32b44096-3827-4937-9d3c-2d0e189985b1", "AQAAAAIAAYagAAAAEH7eexzIdKZ3wr6LygOc+PzNLu5cF5BJ636QWVOTHdh6qMO26Ry43H4zXBUc0pJmOw==", "be31a5cd-d99d-4927-aa95-ebad9350d253" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28acea1a-ccc7-4cf3-9e4e-21b5de601347", "AQAAAAIAAYagAAAAEHB4+MlyZCk+oPvMtuQI20PaTOS8WlmM1ITnW7micMIhbtLh8UnLIRRHTcrU3hNAvA==", "bb403821-765d-4d92-b954-17e570b52989" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6341797-d04c-45c7-839c-b42f87aea7cd", "AQAAAAIAAYagAAAAEHpFkXUM0FOtoNxNxGTtyo2McKUSk3G3L2o7xA5/Et5OtgOpUpTXnfNZ8x0HWXJx7Q==", "611b3de5-5f7c-4167-b643-c9d02f2c33c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "34bb85bd-b730-4611-b44c-754b579e3797", "AQAAAAIAAYagAAAAENbg8yCo9iwudUg8xWoqfkljLl7TOMSzSIOIGzXAQ5JsTQVx2df4jNXql0y/9DeFfw==", "5210fdbd-4064-4564-89a5-f262d5e78885" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0b56d80-561c-4491-966f-8185ac8bc001", "AQAAAAIAAYagAAAAEN/XkWH/LA9mDwJnrH/rbGbM15MmGiEL8avt50hIoqVTKX2sHyPgYKKtkyT5yPquuA==", "871ed348-0e4b-4ae5-8d9c-e67f8d57b10f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "018104b5-fed9-4a92-93f5-0ed965e9d728", "AQAAAAIAAYagAAAAEGDcVtj0AfHAx5wEbdolF35i0ZrEIoRjoOB6nQ63iEIQCOB2FdzpFQn0AR/sGJ73RQ==", "fcad1b26-813a-4f9d-b6f4-7da35ced796e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cab82538-c139-4f1f-b005-63470b33a28b", "AQAAAAIAAYagAAAAEOXKSWGtQ4bKdw8iDh4hPMmCV9TXbOCHeJlGing1PLON+/F9syHz0xVpUKLIP0YQ5A==", "5acf3933-2751-45a7-98b0-ad9c47bfb85e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6244f9f-e2e0-40a3-a969-63748e80f390", "AQAAAAIAAYagAAAAEO5m7c6eooBpCzrPa2aQxSDbl4C4ju7KDnctd38dhOXeQtt8LE4F4BjQM4CidIWCrQ==", "1fd5976d-fb44-4c96-8eba-12018f8b3caf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e88bc24-a512-42ee-9cb0-a610eaa338dd", "AQAAAAIAAYagAAAAEJSFUP5D5HV4ajnWIDPYG+ZoMuYXFxDfG0zzsc+Z27hStLdfZczDjIKx/41FfJNdVw==", "26f15c64-ff93-4027-8a52-15b53d1c9bd3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d49e658-8a47-4051-9fde-565d8e628012", "AQAAAAIAAYagAAAAELXPsefKjaUcAw1OOeiD2OxzL4eBlzxrLnS01GBx7Qx7tez0GfAnu+OopIqcCxLR0A==", "d502fee9-5f2a-41b5-97c9-cc029f79104d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b3a3d0d-d639-4432-87a5-db2d00e046f6", "AQAAAAIAAYagAAAAEFcFgeu5JA+qT/epaACfoaxUdYN5e9raCwG7L7yHZYBKMUM3/FR4EmCtWt2Crv4T3w==", "dc9da851-13e1-4493-8366-b85f14e07f48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2c7f29c-c48b-4e62-8853-653474fdca6c", "AQAAAAIAAYagAAAAEIF3SYr5/69WwjgJFj7TMJbsUJyRZmtXPCg1HPP3qm10kYGIA0JjjEeonPcDxs4+8g==", "cad68a77-0831-45b6-8260-9caba45b4828" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c126f2e2-9ad1-46c8-8be1-1094672d320e", "AQAAAAIAAYagAAAAEJFkBlarZ0qu8dzXauCeSovUaGuEVgymlvmIzcHhHOTyllcHhpWfyxcJeIedx+vbcA==", "b0e1479b-6f67-40c6-9554-2182490c6eb5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01b6df15-2ab9-4784-9463-f6e22e0083e8", "AQAAAAIAAYagAAAAEHtKOvpF3/ed5P0pjTXq+tykf3VHuTlkfgzTrDf6Ue56TSJDD2QRTurU8NW0hPnXIw==", "980991cf-43ad-42b9-b925-73639bb50227" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 10L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4", "Quality management system and its processes", 1L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 11L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.1", "The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.", 13L, "The organization shall determine the processes needed for the quality management system and their application throughout the organization, and shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 12L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.1.a", "Determine the inputs required and outputs expected;", 14L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 13L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.1.b", "Determine sequence and interaction of processes;", 14L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 14L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.1.c", "determine and apply the criteria and methods (including monitoring, measurements and related performance indicators) needed to ensure the effective operation and control of these processes;", 14L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 15L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.d", "determine the resources needed for these processes and ensure their availability;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 16L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.e", "assign the responsibilities and authorities for these processes;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 17L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.f", "address the risks and opportunities as determined in accordance with the requirements of 6.1;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 18L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.g", "evaluate these processes and implement any changes needed to ensure that these processes achieve their intended results;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 19L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.h", "improve the processes and the quality management system." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 20L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.2", "", 13L, "To the extent necessary, the organization shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 21L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.2.a", "maintain documented information to support the operation of its processes;", 23L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 22L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.2.b", "retain documented information to have confidence that the processes are being carried out as planned.", 23L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 23L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5", "Leadership", null, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 24L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1", "Leadership and commitment", 26L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 25L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.1.1", "General", 27L, "Top management shall demonstrate leadership and commitment with respect to the quality management system by: NOTE Reference to “business” in this International Standard can be interpreted broadly to mean those activities that are core to the purposes of the organization’s existence, whether the organization is public, private, for profit or not for profit." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 26L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.1.a", "taking accountability for the effectiveness of the quality management system;", 28L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 27L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.1.b", "ensuring that the quality policy and quality objectives are established and compatible with the organization;", 28L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 28L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.1.1.c", "ensuring integration of QMS requirements into business processes;", 28L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 29L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.d", "promoting the use of the process approach and risk-based thinking;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 30L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.e", "ensuring necessary resources are available;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 31L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.f", "communicating the importance of effective quality management;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 32L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.g", "ensuring QMS achieves intended results;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 33L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.h", "engaging and supporting persons to contribute to QMS effectiveness;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 34L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.i", "promoting improvement;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 35L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.j", "supporting other management roles to demonstrate leadership;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 36L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2", "Customer focus", 27L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 37L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2.a", "customer and statutory requirements are determined and met;", 39L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 38L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2.b", "risks and opportunities affecting conformity are addressed;", 39L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 39L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2.c", "focus on enhancing customer satisfaction is maintained.", 39L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 40L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2", "Policy", 26L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 41L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.1", "Establishing the quality policy", 43L, "Top management shall establish, implement and maintain a quality policy that:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 42L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.1.a", "is appropriate to the purpose and context of the organization;", 44L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 43L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.1.b", "provides a framework for setting quality objectives;", 44L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 44L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.1.c", "includes a commitment to satisfy applicable requirements;", 44L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 45L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.2.1.d", "includes a commitment to continual improvement of the QMS." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 46L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.2", "Communicating the quality policy", 43L, "The quality policy shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 47L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.2.a", "be available and maintained as documented information;", 49L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 48L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.2.b", "be communicated and understood within the organization;", 49L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 49L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.2.c", "be available to relevant interested parties.", 49L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 50L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.3", "Organizational roles, responsibilities and authorities", 26L, "Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization. Top management shall assign the responsibility and authority for:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 51L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.3.a", "ensuring QMS conforms to requirements;", 53L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 52L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.3.b", "ensuring processes deliver intended outputs;", 53L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 53L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.3.c", "reporting on the performance of the quality management system and on opportunities for improvement (see 10.1), in particular to top management;", 53L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 54L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.3.d", "ensuring promotion of customer focus." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 55L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6", "Planning", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 56L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1", "Actions to address risks and opportunities", 58L, "When planning for the quality management system, the organization shall consider the context of the organization and the issues referred to in 4.1, as well as the requirements referred to in 4.2. The organization shall determine the risks and opportunities that need to be addressed to:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 57L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.a", "give assurance that the QMS can achieve its intended results;", 59L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 58L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.b", "enhance desirable effects;", 59L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 59L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.c", "prevent or reduce undesired effects;", 59L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 60L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.1.d", "achieve improvement." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 61L,
                columns: new[] { "ClauseRef", "Description", "Particulars" },
                values: new object[] { "6.1.2", "", "The organization shall plan actions to address risks and opportunities and evaluate their effectiveness of these actions.." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 62L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.a", "actions to address these risks and opportunities;", 64L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 63L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.2.b", "", 64L, "how to:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 64L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.2.b.1", "integrate and implement the actions into QMS processes (see 4.4);", 66L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 65L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.b.2", "evaluate the effectiveness of these actions.", 66L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 66L,
                columns: new[] { "ClauseRef", "Description", "Particulars" },
                values: new object[] { "6.1.2.NOTE 1", "Options to address risks can include avoiding risk, taking risk in order to pursue an opportunity, eliminating the risk source, changing the likelihood or consequences, sharing the risk, or retaining risk by informed decision.", "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 67L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.NOTE 2", "Opportunities can lead to the adoption of new practices, launching new products, opening new markets, addressing new customers, building partnerships, using new technology and other desirable and viable possibilities to address the organization’s or its customers’ needs.", 64L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 68L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2", "Quality objectives and planning to achieve them", 58L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 69L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.1", "The organization shall establish quality objectives at relevant functions, levels and processes needed for the quality management system.", 71L, "The quality objectives shall: The quality objectives shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 70L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.1.a", "be consistent with the quality policy;", 72L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 71L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.1.b", "be measurable;", 72L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 72L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.1.c", "take into account applicable requirements;", 72L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 73L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.d", "be relevant to conformity and customer satisfaction;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 74L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.e", "be monitored;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 75L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.f", "be communicated;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 76L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.g", "be updated as appropriate." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 77L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.2", "", 71L, "When planning how to achieve quality objectives, the organization shall determine:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 78L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.2.a", "what will be done;", 80L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 79L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.2.b", "what resources will be required;", 80L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 80L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.2.c", "who will be responsible;", 80L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 81L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.2.d", "when it will be completed;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 82L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.2.e", "how results will be evaluated." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 83L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.3", "Planning of changes", 58L, "When the organization determines the need for changes to the quality management system, the changes shall be carried out in a planned manner (see 4.4). The organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 84L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.3.a", "purpose of the change and potential consequences;", 86L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 85L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.3.b", "integrity of the QMS;", 86L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 86L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.3.c", "availability of resources;", 86L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 87L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.3.d", "allocation or reallocation of responsibilities and authorities." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 88L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7", "Support", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 90L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1", "Resources", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 91L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.1", "General", 92L, "The organization shall determine and provide the resources needed for the establishment, implementation, maintenance and continual improvement of the quality management system. The organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 92L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.1.a", "capabilities and constraints of existing internal resources;", 93L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 93L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.1.b", "what needs to be obtained from external providers.", 93L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 94L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.2", "People", 92L, "The organization shall determine and provide the persons necessary for the effective implementation of its quality management system and for the operation and control of its processes." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 95L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.3", "Infrastructure", 92L, "The organization shall determine and provide the infrastructure needed for the operation of its processes and to achieve conformity of products and services. " });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 96L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.3.a", "buildings and associated utilities;", 97L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 97L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.3.b", "equipment, including hardware and software;", 97L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 98L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.3.c", "transportation resources;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 99L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.3.d", "information and communication technology." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 100L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.4", "Environment for the operation of processes", 92L, "The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services. physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise). NOTE A suitable environment can be a combination of human and physical factors, such as:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 101L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.4.a", "social (e.g. non-discriminatory, calm, non-confrontational);", 102L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 102L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.4.b", "psychological (e.g. stress-reducing, burnout prevention, emotionally protective);", 102L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 103L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.4.c", "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise)." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 104L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5", "Monitoring and measuring resources", 92L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 105L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.1", "General", 106L, "The organization shall determine and provide the resources needed to ensure valid and reliable results when monitoring or measuring is used to verify the conformity of products and services to requirements. \" +\r\n            \"The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.\"" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 106L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5.1.a", "are suitable for specific monitoring activities being undertaken;", 107L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 107L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.1.b", "are maintained to ensure their continuing fitness for their purpose.", 107L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 108L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.2", "Measurement traceability", 106L, "The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary. The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 109L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5.2.a", "calibrated or verified, or both, at specified intervals, or prior to use, against measurement standards traceable to international or national measurement standards; when no such standards exist, the basis used for calibration or verification shall be retained as documented information;", 110L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 110L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.2.b", "identified to determine status;", 110L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 111L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.5.2.c", "safeguarded from adjustments, damage or deterioration that would invalidate the calibration status and subsequent measurement results." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 112L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.6", "Organizational knowledge", 92L, "The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services. This knowledge shall be maintained and be made available to the extent necessary. When addressing changing needs and trends, the organization shall consider its current knowledge and determine how to acquire or access any necessary additional knowledge and required updates. Organizational knowledge can be based on:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 113L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.6.Note 1", "Organizational knowledge is knowledge specific to the organization; it is generally gained by experience. It is information that is used and shared to achieve the organization’s objectives.", 114L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 114L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.6.Note 2", "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, or the reassignment of currently employed persons; or the hiring or contracting of competent persons.", 114L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 115L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.6.a", "internal sources (e.g. intellectual property; knowledge gained from experience; lessons learned from failures and successful projects; capturing and sharing undocumented knowledge and experience; the results of improvements in processes, products and services);" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 116L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.6.b", "external sources (e.g. standards; academia; conferences; gathering knowledge from customers or external providers)." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 117L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.2", "Competence", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 118L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.2.a", "determine the necessary competence of person(s) doing work under its control that affects the performance and effectiveness of the quality management system;", 117L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 119L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.2.b", "ensure that these persons are competent on the basis of appropriate education, training, or experience;", 117L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 120L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.2.c", "where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 121L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.3", "Awareness", 91L, "The organization shall ensure that persons doing work under the organization’s control are aware of:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 122L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.3.a", "quality policy;", 121L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 123L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.3.b", "relevant quality objectives;", 121L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 124L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.3.c", "their contribution to the effectiveness of the quality management system, including the benefits of improved performance;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 125L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.3.d", "the implications of not conforming with the quality management system requirements." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 126L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.4", "Communication", 91L, "The organization shall determine the internal and external communications relevant to the quality management system, including:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 127L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.4.a", "what to communicate;", 126L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 128L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.4.b", "when to communicate;", 126L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 129L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.c", "with whom to communicate;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 130L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.d", "how to communicate;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 131L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.e", "who communicates." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 132L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5", "Documented information", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 133L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.1", "General", 132L, "The organization’s quality management system shall include:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 134L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.1.a", "documented information required by this International Standard;", 133L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 135L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.1.b", "documented information determined by the organization as being necessary for the effectiveness of the quality management system.", 133L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 136L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.2", "Creating and updating", 132L, "When creating and updating documented information, the organization shall ensure appropriate:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 137L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.2.a", "identification and description (e.g. a title, date, author, or reference number);", 136L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 138L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.2.b", "format (e.g. language, software version, graphics) and media (e.g. paper, electronic);", 136L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 139L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.2.c", "review and approval for suitability and adequacy." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 140L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3", "Control of documented information", 132L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 141L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.1", "Documented information required by the quality management system and by this International Standard shall be controlled to ensure:", 140L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 142L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.1.a", "it is available and suitable for use, where and when it is needed;", 141L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 143L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.1.b", "it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).", 141L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 144L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.3.2", "", 140L, "Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and be controlled.Documented information retained as evidence of conformity shall be protected from unintended alterations. For the control of documented information, the organization shall address the following activities, as applicable:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 145L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.2.a", "distribution and access;", 144L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 146L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.3.2.b", "storage and preservation, including preservation of legibility;", 144L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 147L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.3.2.c", "control of changes (e.g. version control);" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 148L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.3.2.d", "retention and disposition." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 149L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8", "Operation", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 150L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.1", "Operational planning and control", 149L, "The organization shall plan, implement and control the processes (see 4.4) needed to meet the requirements for the provision of products and services, and to implement the actions determined in Clause 6, by:The output of this planning shall be suitable for the organization’s operations. The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary. The organization shall ensure that outsourced processes are controlled (see 8.4)." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 151L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.a", "determining the requirements for the products and services;", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 152L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.1.b", "establishing criteria for:", 150L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 153L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.b.1", "the processes;", 152L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 154L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.b.2", "the acceptance of products and services;", 152L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 155L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.c", "determining the resources needed to achieve conformity to the product and service requirements;", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 156L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.d", "implementing control of the processes in accordance with criteria;", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 157L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.1.e", "determining, maintaining and retaining documented information to the extent necessary:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 158L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.e.1", "to have confidence processes were carried out as planned;", 157L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 159L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.e.2", "to demonstrate the conformity of products and services to their requirements.", 157L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 160L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2", "Requirements for products and services", 149L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 162L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.1", "Customer communication", 160L, "Communication with customers shall include:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 163L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.1.a", "providing information relating to products and services;", 161L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 164L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.1.b", "handling enquiries, contracts or orders, including changes;;", 161L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 165L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.c", "obtaining customer feedback relating to products and services, including customer complaints;;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 166L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.d", "handling or controlling customer property;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 167L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.e", "establishing specific requirements for contingency actions, when relevant." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 168L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.2", "Determining the requirements for products and services", 160L, "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 169L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.2.a", "the requirements for the products and services are defined, including:", 167L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 170L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.2.a.1", "any applicable statutory and regulatory requirements;", 168L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 171L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.2.a.2", "those considered necessary by the organization;", 168L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 172L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.2.b", "the organization can meet the claims for the products and services it offers.", 167L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 173L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3", "", 160L, "Review of the requirements for products and services" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 174L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3.1", "Review before commitment to supply", 172L, "The organization shall ensure that contract or order requirements differing from those previously defined are resolved. The customer’s requirements shall be confirmed by the organization before acceptance, when the customer does not provide a documented statement of their requirements." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 175L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3.1.a", "requirements specified by the customer, including the requirements for delivery and postdelivery activities;", 173L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 176L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3.1.b", "requirements not stated by the customer, but necessary for the specified or intended use, when known;", 173L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 177L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.c", "requirements specified by organization;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 178L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.d", "statutory and regulatory requirements applicable to the products and services;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 179L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.e", "contract or order requirements differing from those previously expressed." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 180L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.2", "The organization shall retain documented information, as applicable:", 172L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 181L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.2.a", "on the results of the review;", 179L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 182L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.2.b", "on any new requirements for products and services.", 179L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 183L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.4", "Changes to requirements for products and services", 160L, "The organization shall ensure that relevant documented information is amended, and that relevant persons are made aware of the changed requirements, when the requirements for products and services are changed." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 184L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.3", "Design and development of products and services", 149L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 185L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.3.1", "General", 183L, "The organization shall establish, implement and maintain a design and development process that is appropriate to ensure the subsequent provision of products and services." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 186L,
                columns: new[] { "ClauseRef", "ParentID", "Particulars" },
                values: new object[] { "8.3.2", 183L, "In determining the stages and controls for design and development, the organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 187L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.3.2.a", "the nature, duration and complexity of the design and development activities;", 185L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 188L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.3.2.b", "the required process stages, including applicable design and development reviews;", 185L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 189L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.c", "the required design and development verification and validation activities;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 190L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.d", "the responsibilities and authorities involved in the design and development process;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 191L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.e", "the internal and external resource needs for the design and development of products and services;;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 192L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.3.2.f", "The need to control interfaces between persons involved in the design and development process;", 188L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 193L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.3.2.g", "The need for involvement of customers and users in the design and development process;", 188L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 194L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.h", "The requirements for subsequent provision of products and services;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 195L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.i", "The level of control expected by customers and other interested parties;" });

            migrationBuilder.InsertData(
                table: "IsoStandards",
                columns: new[] { "Id", "ClauseRef", "Description", "IsDeleted", "ParentID", "Particulars", "VersionID", "isActive" },
                values: new object[,]
                {
                    { 7L, "4.3.a", "The external and internal issues referred to in 4.1;", false, 9L, "", 1, true },
                    { 8L, "4.3.b", "The requirements of relevant interested parties referred to in 4.2;", false, 9L, "", 1, true },
                    { 9L, "4.3.c", "The products and services of the organization.", false, 9L, "", 1, true }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 7L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 8L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 9L);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "412766f2-45aa-4cbf-be53-8ff1b883cdc9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "d1bc626f-9f48-494d-9a87-3ea9aa900acf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "3686f40a-ad90-427e-b5c7-c09c56ead49c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "e977f71c-5676-4bea-8e29-4f62637d6a53");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "028ff995-5648-454d-aa4b-717c6a267b02");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "184aa297-36d2-4b13-a2aa-387fe8f7dc59");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "a158ae2b-fefb-4b37-9ca0-67e4f4864dae");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "8792ac06-bf4c-4c32-a860-20868f11baae");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "a598d0bf-be2c-40e6-b03f-537c7a3f23bc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                column: "ConcurrencyStamp",
                value: "c90344e5-09c2-4769-9661-1de79a440137");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "513e244c-e80a-43fe-87f5-82e8e288496e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "9bf34870-1610-45c7-8ba2-91aed76b75c5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "1edb25a1-4797-49ce-a0fd-c7a96499b2ef");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "f895795e-828c-4052-a084-3dec0b131b4d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "bba8dda2-1b4e-4aad-93da-8cd7bb762e1f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "204c1c9e-3e78-48bc-a947-9d7a1fd38987");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "938af798-c6bb-4f21-b68e-2f7e340311c0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "7744276d-7bce-4c87-9859-61b8defb54b0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "1d0689b9-927d-4cd8-bc52-2e23d52992d4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "43500f8e-34e6-4ff4-8598-c81538937ecd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "2aa3821f-26b6-4015-87a6-d5b91aed63c3");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c4e8af4-f184-4a2c-a533-913a706cdefa", "AQAAAAIAAYagAAAAEFv6eK32BKgZhpDYeXyuEzKsfrjSayEZ87QvzS8clrG+vMiHjdbRfuTd56bf+cqEIg==", "89364007-39eb-4a37-974d-e35844d5ee3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18a13727-6e3c-4e5f-bce2-870abcbdd149", "AQAAAAIAAYagAAAAEKKbV9TG7Om0CMLGstmsmLihxmm4y9T1H9W8Ye9gjvRaCDBvpSHT/0rQpduY4M0GRg==", "507965ee-b1a5-41d2-87ef-933a7a6fbb2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "baeca468-ee76-4e94-9a63-63f180d3d80e", "AQAAAAIAAYagAAAAEIPVK96UlcWN5NhVli7VG/L98zQVo45OWy0LWpSmhE1DTlHXjGC5NVoGGSCmE9TKSA==", "5daa0b96-4add-471f-8a8c-1d281d8ea1cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8ee12db-693e-4acd-91bb-9bd3c0db45e5", "AQAAAAIAAYagAAAAEI/MYNdksZAMBzui6Sv05SvB6e7gPaIMwWAtGM0ljo3YgDNJiqPB+ut1oiTTjGB3gw==", "06ed0120-b278-4361-a14c-35642a923e51" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c925aac5-f17f-455c-93d6-ae6c08730c6d", "AQAAAAIAAYagAAAAECkWcCvrXwyTLfLyl+JRP5iZ7CnwjAkGtD2cZ7Bd/K3WHnaGKzYOFSTVrot4yzt6lw==", "729c786c-4e1c-4f1c-94d9-54d1452c29f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cd82d3b-5384-439c-99cf-253dd1ae057e", "AQAAAAIAAYagAAAAEOcQ6E7kCdhYToaBUVmTLRFB+uG5WZHLcGoyKigTfcAMrGa//F5e6No+zZA0HjdW0g==", "2124d6d0-f82d-476f-a2b4-a84372e7fe7c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da5d9208-66a1-4a01-93eb-7622db72e344", "AQAAAAIAAYagAAAAEDugQ4+MKjsHsi3enQZZykYQS42wZoUsUF32dsB1A7xhvhew7XKyatsWUnIUGFDOuw==", "2be797b2-f6f1-4f07-9d36-38ef227196f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "884e92f3-cc6d-43cb-99bd-25a5871ab446", "AQAAAAIAAYagAAAAEE6SNqiA3joqmyEEJDzkCbOV9q4NRkLxNzl90AwYiWiw8cpNKoURLyg0COJgRvgbPw==", "fd97d07d-394b-40ff-be56-9aeaad4dc956" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b0ff60f-db76-43d5-99d1-9bb1c3612d03", "AQAAAAIAAYagAAAAELWUx0CoJ15ulKmziB3OZpTjawQzmWAuAWAwTxW9gvJS69Q9ZLwy8POJkXcAtJHkuw==", "aeb614fa-ee95-49b9-9311-0ef0c61d8c6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf0cf5c3-9c52-4faa-967d-32625868d9af", "AQAAAAIAAYagAAAAENr+UuOfhpA9pBe5fam1hnL3qCbXNx+yaslzx+sDJEjJc32u00JNgdLyDZ3SXUMFUQ==", "9f0e2437-2e06-4e66-8a47-afebb15653de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eade0472-ad0a-494e-b202-0cdf5d55eba0", "AQAAAAIAAYagAAAAEA+5JERlNX/sb+aqooQd6NRtyMP+NvoipdKtnIKBHulY7ax7qw6SLsSAYuW/V7zSdQ==", "b61c6332-3d1b-4181-b282-a3b0eda608fd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de6fd49e-da39-4bd9-aaba-60335dbaf823", "AQAAAAIAAYagAAAAEF2vz/m5iPp2dtXnhHhnrr234N89qbQwkeQAlPPsGfIuUuC3hVWActksvozvAs9DhQ==", "55d04909-23c3-4ac0-962b-88906c92663a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58dd6059-006d-4656-9682-8d5ffb5cfd43", "AQAAAAIAAYagAAAAEB7R7dbFltBdoIpPLNjUHGyDpBQM3T3mDvCrizqoJpHo1HgjxVox22AdzciuRH/UbQ==", "caa327da-7168-4af7-9a3f-9403edb57ddc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ad0bc35-b822-4b59-b2db-ca11395fa58e", "AQAAAAIAAYagAAAAEKqrbnguS20MqZhV/mRBdKE6fOBlc4a6hLY73v3uz9SkslXLrs+tRHpNAFNUj+5ScA==", "74296249-ec6d-4054-b7c5-3d0064af5247" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdc53c48-c7e2-4e25-918c-a5c8ee4a5108", "AQAAAAIAAYagAAAAEDMk6GpAS/iBfJXviBzw2qMLfj9U1KKWxl8YFrDX2DbSHz6gJVjrLsQ+c1ltiZX6PQ==", "8d33c9b9-b9a4-4099-9059-f5297f5e4c2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78a867a8-6450-401a-acaa-00a722c833a5", "AQAAAAIAAYagAAAAEFaMeo4Hhzjp4WPTES6B/Sj+mZmFkfEjLkpNICFxl2qb1II5Bq1nWBaM2tiuX2swgA==", "c52464e9-817d-47b1-a741-2a31f5be7ca1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a73666a0-ce0b-413c-a9ee-8cdb25375435", "AQAAAAIAAYagAAAAEBl5+NMH9GUzUX2Pe0YBl3uxtPPLz00Sl/JsL4iau45vdA8+25gsmVu4bHyUHs4esg==", "786b1e72-5841-4244-9c83-214ab6645660" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6600259-2854-4dde-a3b3-ae559da8edbd", "AQAAAAIAAYagAAAAELLbh+3mRnJ6xdHb8HI1ZtN+7FyUJs7fDvP2teDpxyVgv4hx8xSv+xKBMN3G6RDf3g==", "01449489-1d29-4fae-bcec-b94178026c5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1bfa11e4-4b72-41ef-bb0e-54157ab4b13e", "AQAAAAIAAYagAAAAEGj5PLxmG+mNey2+QVVxc/L3UlxOvZ6jH6wSNYPSIKeTRZkbv1I6OcOwzHgCnu08sw==", "dbe2f040-f9ac-47a8-8eaf-c1f3ec2aa008" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aafb1c18-a18e-4058-b8e3-811021df90ff", "AQAAAAIAAYagAAAAED9JhtDOeZ0UfpFFgss89r0bsvjXakPWMX40dL54Jvyh+xobbKIk32HrZG2mF9EG/w==", "910f54d9-5858-4322-91e1-e53803fe5794" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82297996-fcd7-4bb6-842b-7b060e59b0c4", "AQAAAAIAAYagAAAAEB7w+NtOz+U100P2Te8WVLRLnvDj9nbJvO9IkLsaiuIt1xo/nhyB66rFs4tU8e+XrA==", "a76b7136-e3f8-4046-8e82-6d5a93361593" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2fd387b8-88f5-4e43-a9af-e44efa4b0be8", "AQAAAAIAAYagAAAAEPPKbWp5Iz8D1TDJUjG5joai9tLnfTshwDcLK9jNwRWq3BWqnUJQKftXHg7kTx644Q==", "1181508f-fbc0-4d36-9f37-d4b93888677b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e07bf86a-8d79-4771-b974-3573ff88ab83", "AQAAAAIAAYagAAAAEC06YcxZ5i4xD/db8ow0XJA32S41bFlSdJyPTgSAEtrlqArW1xn5zcxnk7WEGEjK/w==", "341debf2-0181-4029-8323-d6fc12dbc4b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab037468-2516-49c7-838a-5b2484a62550", "AQAAAAIAAYagAAAAEOnP43+QmW+0BQ3yxI4AG+hBh2nHkNoHZoTcTpXY5jA1I/If92mdH8rJUM+b4xN/Jg==", "f2aaad36-d5ff-4314-a6ec-11c3932f71c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93489405-9c93-4270-ab3e-b27b2a1ee619", "AQAAAAIAAYagAAAAEH1GLvjDlArtTpNyBFc5BJxtQIakx+YRaGM93/86TnLRQxeOQWWeghnCYuvajJ16Iw==", "24587f56-1bde-4c44-af5f-b852e8b3fe5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46913536-155d-4a6e-9d6e-afcb79de3092", "AQAAAAIAAYagAAAAEOSDJYZBUhHfpgBYkv7B0CAX4WazstbPGdL0gdwFnt6pTTbjTgHHFRWeMtvlrk0khg==", "787e65ea-362f-470e-815f-60dd8950d3f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad7fcb19-ad3e-487b-967b-5298cda93d22", "AQAAAAIAAYagAAAAEDF54FXAebGJfhPyw+GbK5yoaJJADIVbpSv1JKvWcpyhl16vjY993Dhiuggx1dgdcA==", "9981bfbe-4332-47ef-8967-f0454b1624d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "43c05795-63f9-413e-9838-5b2f799a18e9", "AQAAAAIAAYagAAAAECA1/BdsJwrtWd5D08i8Sm3SVEp0XkblIP3IeSVUOVMT1JOGITdqZo+hlLmMkBRs0A==", "e76d0792-f04a-47d9-91c3-92a5a0151d66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a881a632-e629-4bb8-8915-cb6a6b7e3ec8", "AQAAAAIAAYagAAAAEEoNj1Wi58jj0RSxMQ1/PiLhCJvgaI0+vq289qtDN0mztaQmJe48Ly1+PzCy8LirvQ==", "a4383187-d096-41a5-8e56-8ed63b69f1e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd9fe0e4-c38e-4522-a9fa-ab3d7367ebf4", "AQAAAAIAAYagAAAAEFYI2n4vFdC67ZzJZxrjAi5unaUn6ZXq7hUp/uFEJuoHGRtN9o7TdARznfq3JC0ZfA==", "f0ee2f5f-9ae8-4ff9-9f88-f51c6bddc56a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e335562-5011-43ea-812b-84c441d8a828", "AQAAAAIAAYagAAAAEBwstFAM/Gorrrf6FP9HaxaqQ7XjZ/pEh9V5yLmyalY1jOHagNh/ReyUykpGe6jPlg==", "ca572c5d-0420-4458-8b6b-9d27775f5a13" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "462b52d0-3629-4403-97fb-66e1ec0fe341", "AQAAAAIAAYagAAAAEKXljJX4YfqiR9oEIRwFOyLAKcfaXwFjB40PWwSPeImHUKq34Ao1Nv6lBuSw+9288g==", "f8c526d9-b1da-4da0-9fd9-073abc5c8930" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10f6be15-d09a-44f0-9634-66a743a90b59", "AQAAAAIAAYagAAAAEAK6uEVLDqrVUNCHNSQHPVGCnEaqMAXpyZCC2XVvqKV8nBQjhszsCpi+8s8Etq011w==", "618e4f1a-07b6-46f8-a12d-8c9e0ed44c7a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de17c9a3-0151-4e6d-bc0b-ff4625814f3d", "AQAAAAIAAYagAAAAEAsJDifr/dAlQBcFAJdPdQx5yD6QZ+zWhEyhV0rYdq2K988HpHGCPZF6z45jE3VA4w==", "5c686a21-df36-4359-9954-ae0d602a24e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f75c0ab-ad6b-4b69-a063-5b073a8aa254", "AQAAAAIAAYagAAAAEJAWZZlD1Qh9dEB5BcajR9w/2ZWAl+27OlZbcZVDrNBn760BXwEWrDZc82+XWJY6PA==", "61eba4f3-4d7d-440c-800e-4d0c8c53f220" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c43ea255-81d1-46c0-8ed1-9bf3fdd734ae", "AQAAAAIAAYagAAAAEMdblD6bZoNsoDAYLXiLl6kOj2nm+2ZG0mrkGXzitKjtOuE1gqp3QJ4zW1WjUrri+g==", "9fcc9329-1a8d-45af-80b1-4f1c0c498aae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c9996d0a-8ebb-451e-9092-9f2aeddf9dae", "AQAAAAIAAYagAAAAELsM7x3dpL97SgFgo5VA8VlkMYHW0w7RtUvl5S2RwY+TxyNPH1qcFbFlzTMcVuncTw==", "f0671ac2-3644-4a8e-870f-4b6a6d3bfbc1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "644a736e-6081-4a56-af6b-8bb4e902c4fd", "AQAAAAIAAYagAAAAEB4c8r/lVgMw5jjutTjp8Ywnm2qYoNsFUzxg5qrWLnpM1bS4Y+jsstWtyxaO991Zag==", "507c449d-8c21-4a7f-b157-33a90ac5e3f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ed45f1e-dd43-47c6-b28b-374f9e77d3a3", "AQAAAAIAAYagAAAAEGqrQ8JWG4AHtGRBu8Pom3GtBTHm/wq7aWqKRBJwyL0BjNbCmqeEwCBwcHfKtEY1aA==", "3c2e73d6-e1c7-4581-ad5d-f73de10b13f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64d807f1-dd85-4616-99c3-f02ece1cf43d", "AQAAAAIAAYagAAAAECZVOzbSx9ud/shjrgF/VaSNCuMWPrOcKkHAs3mz09A3wT+e1gbGx8iw3IeyrcK6Fg==", "b8756cef-c010-4a4d-82cb-080709835744" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "922735c9-6d3e-4157-b460-aa648886d5a2", "AQAAAAIAAYagAAAAECYcednrgdP5Lt9qU88DHpCjTZjK4Ycx23nvWF+TiRGNjLPi4z8o1XWolc4+XL2bOQ==", "c5c6b1f4-aba5-4561-99d5-1051ff028666" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ce68861-e6a9-4937-b4d5-9597553cbfbe", "AQAAAAIAAYagAAAAENM2d1RmSmCF0s8+xA811qqTPMmidpz9HLs6iHkGGw7cT2k5BqDTm7bmzYNuly0mjg==", "10681378-1e3b-4735-b460-fcd01491ab18" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "923ac917-fc90-4364-9b48-4f6b55332a55", "AQAAAAIAAYagAAAAEGaBHKpJSPmtY8n7aDfR99sTSlT0BkgY6sV3ZXzB7EiNmJ8Kd/RdzU/0LSIazK6a7g==", "16b23566-fe4b-4d32-9b29-11d1937094ce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "510d2ab1-6083-4d37-936b-739c046a76d9", "AQAAAAIAAYagAAAAENBhtB765NuRsFFSo3UjCok09Vuu9L9eJrRasH2KUcTI6dTnSvtiCjpjqEcQ4m1LPQ==", "047b8095-fc9f-47bf-8ebb-2e430daccb40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0ded4f1-b15b-478a-b797-106b8b14b3d8", "AQAAAAIAAYagAAAAELVSl45/CTdQnWn3J3zcwqBIKN1n7768E7/TF0pkyP3N7lVOfE7v1DnvdJRgf0AFWA==", "58e55bdf-853c-4f43-a3aa-4cc147d21d82" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2c32f3b-5966-4e70-a05b-edcc0850966a", "AQAAAAIAAYagAAAAEDE5lfqT0hO6cfjNR9ZDDZ3N/bWm68jRlV3wmWspjoWL68Rr7lFGw06iktniQB7NzA==", "69993e84-7221-4ba6-b440-bee6d5eea559" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e255a062-425a-474c-be21-6feaaad87e4b", "AQAAAAIAAYagAAAAEPXeH7QmjpFZo9D5Vm8OPtktDhrmwm7VlqhrrqYIdZ5vj7HOcEczUDwIvaqxp/obxg==", "9827f0ee-6ec1-44ec-be2d-0a86820ccd7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0bf54406-c0ca-4cfa-bef9-d0d600c10b1a", "AQAAAAIAAYagAAAAEJu37irxF/kYqfLRHHlli1TR+oWRA1OtO9iCxeIfnqFFtzn43/9kasOIUXDWdsOQIw==", "d75e5c6c-7b7f-4de2-9775-fbcb60a31218" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb14ef90-1df5-415b-a570-dcc3bbdab415", "AQAAAAIAAYagAAAAEJ0Irw9n89iAZW9SWTpWIJmELZZIpj9L28D6JS/dpiUvQIRdhf69ugiu7Xx97G1GRA==", "b47fcd7f-266f-49a8-b1d3-79d94d42c402" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7161ce2-3c98-4124-8e22-7d50464c0dda", "AQAAAAIAAYagAAAAEN4nm9UleNNUvhrW3jwTvJNfWs1YzvwJWDPztu88ZCYHVnl4x1LuTX1g1dsDp6VUHg==", "da491577-9631-4aa2-8493-cace2509b7c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc3f8ae3-87dd-4276-881b-93c205a6126a", "AQAAAAIAAYagAAAAEAA7kqPfsuSuQ/odbb7NgncIE+9Cl+7aB4CNhzAnwfmhhx0anISbdhWbzX37hxbEQA==", "e08052d9-863c-4240-b1ce-65b6bdb40255" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebf0b37b-4a74-4f58-842b-0229c6bb3a45", "AQAAAAIAAYagAAAAEC05xOhwYuhSHHbGUP4TW5D5mZo+KA2kjIy66ogIOBf040zAUzZgc5/Ts7T0kePpWA==", "91006c41-e000-46a8-8f36-8e0acf0bdffd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "afcd2dd4-1858-4e6a-b89f-5dd9ab0edf62", "AQAAAAIAAYagAAAAEP1YQeJbpAPLa9WhphP3LF7ouSWeQ3QiDgw3M7AqELWUX7qOczgyRfL5ZT+nUkmbdA==", "13214179-b8fa-4b08-b5b7-df9780ec7e6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ba5c00e-e5f7-47ca-9c7d-85d455f4753d", "AQAAAAIAAYagAAAAEAlPSYmIHPPO03CTM27J+4HDpinDuI6BSNjuR36BrZMVpmC3EVpDd9Ma3ikJd7Dl6g==", "548a8678-be00-4037-86f8-4d9f7e423281" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd447c27-4bc2-4771-9bc2-43476ab2ea35", "AQAAAAIAAYagAAAAEL7ru5pYVin5gb/qwaXAgFdy8BYHELVmjLTlww1qq2BXKNALsePzmByJ6u8l+Heo+g==", "2ce96185-e6bb-42c6-8813-c306841e547f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a001eab-40b2-4bfb-a18d-da68a0ef2a11", "AQAAAAIAAYagAAAAEEJgYpWd2pgnvghUnc5EWbbBQZQgxZqZALXvVYde3EenY/k6Tm4CFTlKCslzrnsuLA==", "a5721456-2ca7-4005-8123-b54eedc01aae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b89141b8-0338-4e18-92ba-80534f19587c", "AQAAAAIAAYagAAAAELQHG+TQFl68RML7z2eAO5QQSrttvMJ6HzpDtdG6RiYyHALjEDyU0roHoI7vSja0vA==", "4bc37540-dfa1-4257-8ad3-153d7192dcd0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd3f29bf-0566-4ca3-a8ed-0acbccf77932", "AQAAAAIAAYagAAAAEGhBwU2Tn9RVaPGd+CLODYGvmUFcUw6YHcRo1feS3COX8upn/Q1je2xp0phM+Rcl9Q==", "925a96a5-fb79-4821-9568-26a73651790f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c9eaece-d6ef-427b-a186-87726c3b35fd", "AQAAAAIAAYagAAAAEJbIL+AhYf7kcFRkroq+6N/crPG2tiqXLeZp/RFkKOopL/ETJI7OO1hJjCANOvKGqg==", "f20d5a46-b5d5-4dce-b18c-19bedec99544" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "650f8c4a-9083-4503-b95f-b039aef0c52c", "AQAAAAIAAYagAAAAEGQ5csAz8z3A9ouvD/iAXXSGLWF6Qq7rRE99wy/wXYzKNhL7xoer/syFtuMeSt5UEg==", "8c4393db-6eda-45a2-a64c-72e92dacb4da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c990ba3b-909f-44e8-8a6e-be5669743313", "AQAAAAIAAYagAAAAEBi07owtMBu5uB4n1uVkThU29ZaFLwtx19t523ejyKZXhlq4FAvNtoibi6SLcBxOMA==", "43d8f1c6-2abb-426c-a4d2-86988ac2d00f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86be93ea-2749-42ec-9269-87ca795510b5", "AQAAAAIAAYagAAAAEOmHCqASo3wlsdXFgdIgkZKC++j5tPPYsSL8xl+p8VbIm1yvtJGac3/WjUx3d/FxBw==", "62d25738-4a43-4a0f-a921-59cd67310dcc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9d81104a-fd6d-462b-b3fc-a4ed549db26c", "AQAAAAIAAYagAAAAEB+umTrIovEVFjwE2BgrCX+5Y5AdHcoGQBhhVd/ijJIxUyfYP1rVKgS8QanIAWrbZQ==", "3701362f-b9da-429f-9e7e-0478ea6e693a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9497e2b5-2b23-4d51-959e-4c1d765cb34e", "AQAAAAIAAYagAAAAEOk6HUNL7RuO+p5yhD/BU7CBhhxG3+qUdHNY9fmbrYgaK5HOtBKGfg+16MKHx/RMEA==", "814abebd-bc3c-4edd-8fa6-15a9d2853d8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7af40532-8bad-4ba1-9866-30067b3f81ca", "AQAAAAIAAYagAAAAEKuJ5767LIYPCphML8th8if3uB2kBVubzK92EX5QsI15+jwkWmPDSa4IAEjiWai3HA==", "54b08865-48d5-455e-8460-5a22ed8c6080" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c476bbd-7386-433a-a341-b2125cbb1a37", "AQAAAAIAAYagAAAAEPD5pzGn/IvSFCvi8eijRzQJIS0rwL9jJjIhi+0L9ri9bvjw/JkVv00IXsRMdbVXfQ==", "84df5f19-67f3-4b42-a2d9-cf28e6109ba1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b567840c-9067-4160-9e1f-b008bad5772b", "AQAAAAIAAYagAAAAEC7MrCtveWj2FQ1499wn8uTQwOD6s1dqk9OwM1mx4V5XtbwPjqOmfvtSZcxg7XRvtg==", "0f447887-2cb3-4992-a905-32f5ff66ce59" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb730836-534c-4add-955d-b87a1f74e7d2", "AQAAAAIAAYagAAAAEEt645NB8PFdKUyzixlLCegFAb3CV82oFsgDt+P2oYVwAHSuSIaX1dRQfLco6eiY5Q==", "68f1aa87-4ff1-4a9e-991f-cc262ad90061" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2fd429a-1523-46dd-acde-d67687d9340c", "AQAAAAIAAYagAAAAEMRDt3joyCPm+auqJ9TGnHWZEKFabLl+gfnSzHoLoX174oYubV4IDdQj5moIhwKYgw==", "c20759ab-d890-4a0d-b83f-fe37699f550e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bfa78594-2b84-4eb0-b4a4-a3961a2dc760", "AQAAAAIAAYagAAAAECMukH7Up/6k7ikWVrjSocSZQVk138m58dORifELlADkU6/DFvS/OwbugjDh5NwpQQ==", "033af442-03b1-4f6b-bf92-9ee02a12cb60" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0de2c347-02ba-4016-9345-88febd02ac70", "AQAAAAIAAYagAAAAELQuEbMN8ibS70w+CVr2k93cmVYJbtIyatd2pLQZhsd3k0qZeC5vfThw64vddcNOfA==", "1d5a8927-fe14-4dd5-8dc5-87411e3bbcd7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c44c45e8-d01d-4c79-83fb-64ea82434520", "AQAAAAIAAYagAAAAEO/jB9GS4CDao80QGiPpFZOH8Oohw0MEzeC/vFpIsxzLTmGvviJYe4SycwKqrSIdcg==", "fa634674-cdad-4993-bb92-f28d08b2cf4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8d91efc2-7859-436d-9c92-d138ba15b629", "AQAAAAIAAYagAAAAECV7BOkRFOi6fVfjYjV8dquyX9b1GeSQe6DkeZbF4zkqymDGUAQ1YsC6mLnQYDLf+A==", "49803628-aeb1-4708-b3ea-cf25ceee0b81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "312525d7-e210-4188-9bf0-b7fabf14d30f", "AQAAAAIAAYagAAAAEDZ3AZl07rvpywejDjE3gIgKsxKT0Uib4YMZmeoKO0HMcD3ax4MeDVtwcOeBYwrxrg==", "8f58751f-c669-4cba-9ea4-2f6a3cab53a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "efbd796d-d1ff-4130-bee3-b682cd6e6b4e", "AQAAAAIAAYagAAAAEF0TN/U377/XzLmRaygWkzTRqAnnwPz8clX+xipUXmcD5nIBBE42T9LVagLmjK/dog==", "bec68ece-b6d9-4a63-ad1b-af53d25147f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ae8cdb2-0285-46c8-960e-6bb55afbfe5b", "AQAAAAIAAYagAAAAEILoNykmwcMToYSOBDpfEpUbTge4iEFD6N/WbQQ2qQRInX2laJiHtHPbeI/iZ3XK2A==", "03a58360-2267-4d5c-ba62-e52883ca2923" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5facdf57-6eec-4dfd-bfa7-0d5d58062af7", "AQAAAAIAAYagAAAAEMD7JeFt3A9hL2PCK76NOZ7O+5lqf24AmuDTMeaB9nFcpDxIGhImWoZVmvQZrsF7nw==", "830ff565-d837-49b2-843e-ed17c898a5af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60184246-f37f-4b2f-b3cc-2cae110d6718", "AQAAAAIAAYagAAAAEM984FxJ4DrAGJEDgldKB+hZKycoegHMNtep2YNUF6LU1270TiS21MpwlLELx7hYEg==", "6474d5d9-b267-411d-9011-ba85a450de89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c479d07-e58d-49a4-850e-dccca1f15386", "AQAAAAIAAYagAAAAEFjgX7Y/o3M15k2/djslusnl5UI5JhlpFU4E4ldXxjGfMl1Ez1CehS9FOtvA/tQ5Rg==", "2ec95149-1c6f-4008-b212-260f5475a17c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51a77b64-c829-468c-ab16-cc05e0ccb743", "AQAAAAIAAYagAAAAEKsQ79IBIgP3XXFFhItyGZnt4ktX5MfEupP0nKg+zZt/Qn1yqjQnYqO/2aUzEfmT5w==", "01eefee8-e191-434d-abd6-841d743b20a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a75e218-3b9f-4874-b997-6a0393bf9c4c", "AQAAAAIAAYagAAAAEF+TKr6mhT0liEg+HAY295E+sQ8GsqxQASu2Q5XTHr3AIGe7mamKAFltiVejyF4eEA==", "821cff07-198b-4dac-b5ba-092a862c75f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f3b0d88-f9ff-4ff3-9c70-5b821a07c7db", "AQAAAAIAAYagAAAAEIeEzZdFWz4NGPWZYc7zwLn7K6+jXtb1UJmK4CA2XjNK9BuaVelzArTjFft+4nd8WQ==", "a5d86565-2c9e-4d8f-b9fb-ed73adf36fe7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae30a352-8292-4286-a5d6-b8833c0d483a", "AQAAAAIAAYagAAAAEFw39hkAE8wJBRITqAiDuuhbB9M3X9IC9xrnY/3MFsLjhSZ4/sV4R/HwbZlFAxn0pA==", "40b8d187-74cf-473d-8b58-122a657e9245" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9e76e1f-32c4-463d-9355-59502e876c3f", "AQAAAAIAAYagAAAAELwIuZKTBWpJKTssLfUP9hnlo+ujAp6XbPBTH+g03Yp7o8PD8XBrRvpihpapoTOtIA==", "5148fb27-1074-4c37-9670-9a4e47e2f944" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63927647-4759-43fc-9a6b-daecac6e39e1", "AQAAAAIAAYagAAAAEJbg0j8zO8Stu1Kpn0hSPDVSuQwnVVvb+a2YHDooMyxAWA/3W2U8ArnztuyygdAUIQ==", "90516ff6-d3ec-400e-827c-238000bb2b48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e92f0176-5b74-420a-9dda-2eee034163cf", "AQAAAAIAAYagAAAAEAzN7VUB0nfVfvHbna4p6RJdHNVWvsxMmK/IMsZ+vIKWmOreKDUuK1iIFolve/knKQ==", "063e7743-f872-44c5-9de1-6ec20622d8e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4a739c6-6bc1-4b4e-b69b-9690e9251b13", "AQAAAAIAAYagAAAAEEyIhXbbgfH5R5d6FeqLitEToil8S3uuyufnkuN7XXkxhVK1nwEIFgBVqQwKln1Xxw==", "58ff1605-8040-4527-af00-9b50d4232665" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c14a4f39-f7cd-49a6-bd62-3ffc09681161", "AQAAAAIAAYagAAAAEO6JX5DjMoRlZum5hLx/bNgVUFjJL43yOxkMhURTjAZMbAHVNQoFCVpn5RXRimY00A==", "30d339f3-e296-4348-8f78-ac6c57dc8c49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ef7da9f-168d-4011-9803-f06ac53703ab", "AQAAAAIAAYagAAAAEBnVDTG1DEPQK+6xPlTUICBAr567YuEiq2xldjQDvzZRcAglwmIlJStsWVO0wkl/Eg==", "21da47e4-9fd5-4f3f-8a5d-ad3e4313ecc7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd9aefc0-bfef-4c3c-9fb2-6d7d44b71b73", "AQAAAAIAAYagAAAAEDE88D2zGi84Jdwk/8Z3A1TCpSinRmU8uEOYc1bDb9InniLELZORFWzlqoXR5o+Jyw==", "e24f5b2b-9c5f-4fd5-a1a1-20e522eae2dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67f7353f-e2d1-4644-9c89-b98ef2d4e8c0", "AQAAAAIAAYagAAAAEFI2kCN7gdDMtppgohbLqTV+4NxDiyJSobgd5PSvMBnoleeVqdgnZOHN4ZXN1Ts40w==", "0e417599-40a3-49a5-bae7-c3cf32975e0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22110d0d-da50-44f8-b1ae-e94e9334ec82", "AQAAAAIAAYagAAAAEBDmGE9NUPbTWFgdid+y+UkroI6iBLM/rj1yAB9gI5Tq0z+uKCxdmoyUNUgntCcPZg==", "1466ffe1-d9fa-4fae-bdbd-e329a926dce9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c914df1-08f7-4e5d-80b6-b2b21e4c05b4", "AQAAAAIAAYagAAAAEFmtBd9kqnZqMJmlSgYDlHc0LG80buSpt/cqJS5wSdbBKv2FjYsMvSdj4bUjUJLM2A==", "01db1884-86fe-4391-8e25-c8c0bda99318" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d79dac0-a7c7-45a2-b5ed-ae16f440548b", "AQAAAAIAAYagAAAAEH6j9A2UpABGZsC5ZJKlzak9Wj2+GHeVQAWnEtrO7qjoo9AUrhZrTkYIk9AlpZPQ5A==", "f68f3c12-07c3-4d47-b58a-0c1f4c7a9a4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e60bcf46-2845-47a8-a200-d564714ff4d8", "AQAAAAIAAYagAAAAENTq3tEaxu7ERTbxTiUjVM5gKYB/J1YFka7XL8qPwBnul1Xw1cA+4gAZpf3qZVk/Nw==", "f8a2d814-c002-49a7-956a-b093b8df3646" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a4b5ba6c-dcc9-45ae-b256-473b3d0335f3", "AQAAAAIAAYagAAAAEPpKL6y2mzBCrjtnv+lRROCAzW2rY6TLml9GYYjNhGbXzE435d2x3GrpUqKM9SGlKA==", "66c2fded-33f1-4fce-a1d2-1f52d4cfb575" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ec739af-b454-4caa-b68c-96ec45296472", "AQAAAAIAAYagAAAAEOG2lIiLS7DXJ5n4s0xN8XvUCOpDpQWoKTe1b3e0IPfghNtZiE1fUkCvStpRX3mxuA==", "34c07833-c47b-428f-b7d3-9fb0fc877909" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "83a58a2a-6cd6-43fa-9cf1-b9e01d64e4a3", "AQAAAAIAAYagAAAAEICF+YTMENkEdQaFU6RZVzEXMeQIyl69JAMJ0BbHCqJFFow7eGWahfoNZcAkWTu/qg==", "4246bbfd-7d71-4f86-b134-2cb08a834721" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5980c3c-0ea3-4ffa-a79f-cacb908e3e53", "AQAAAAIAAYagAAAAEIdWW77/uTXWMDqoKr0z0UTub6RFeAk7/VEhYvgSa0bMc8DPx2dJk5Okq0xhBeNPcA==", "df85fdc6-b0f9-4287-bc00-bc28a51acda3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "885047d7-05f2-4aa9-a9da-8032c7b8b304", "AQAAAAIAAYagAAAAEJRAEs95S1VLEVmqW+7/zTmmdkjo+rOSV5qObwiG23GzU00EnF4Wjx1oFYOcqI8GbQ==", "baec3b01-153f-464d-a737-955b2b2a344b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da930bf1-eb21-4b45-a8fe-42bfd1f32de2", "AQAAAAIAAYagAAAAEHidOhUzMWva9hdLk7aQu9vViWbV3BIxSH7O252tSTlxzf1VrQVpvcgIJPbpjT3CMg==", "e205321d-f11f-4663-bf7e-5cf2023b4879" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75d35f0c-d703-452b-8dec-31ae48357e40", "AQAAAAIAAYagAAAAEON/a+95JcHt9gNXX5izeHT3F4b6m6cAxRUDg4XyBZbVYWFgtXwca6e77jViSyEuDw==", "ba107bec-8205-4159-885a-2d7c84619e0e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a39f02c8-f656-40ee-ba5e-bbab6a1e4dd2", "AQAAAAIAAYagAAAAEGcBFMF/qSht+JjGlZAOXVauHPko8qprkW0YITkvKqbgrEfm7+4AgaEVPeYyK4e5dQ==", "b0aef237-6dab-400b-9d3d-1e09f626ad34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa7c6533-6016-41b6-9ab1-31ca0a93f3ae", "AQAAAAIAAYagAAAAEE6Wtf/8Q6L0HQWspRF4iQfvsz+mzce3PfgbMStrrxgtt35GgiifRcD0HhKbSLDUjw==", "9502a28b-9adc-40c9-9510-4fb4486411fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b922f63-e538-4184-a82d-c572dfcd3210", "AQAAAAIAAYagAAAAEB5JMko3PzV06TKiMONM2pYEMxr0B3JHAzG6fkZ3NoBzXe2ZdsJ8FrRZT9QXFkC5MQ==", "45307602-6a5a-427a-9f40-ba5a1aafaeb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a21b016-1016-49ee-9ecc-207a38ec1adb", "AQAAAAIAAYagAAAAEOAUmVi+qaTNASlvcRX9xQ+62tzzq5Qwe7wAr1fH9oKbSHoWFli0iK3UZkZv3eSrXw==", "852e183a-d624-4dc6-8d48-2b7da38f6e3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9f2de2b5-0182-4369-8ab6-d74706775f73", "AQAAAAIAAYagAAAAEFHvBoK1MgXAWKEn72eXOYtBIRvIn3bN1Ass1oRsf8Wj1uQgUF8MlouZiMb3Ug9huA==", "517c6f9c-4bcc-4c35-aec5-1bfce3cbfd9e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17d577d1-8688-4933-af2c-1d1bb45aa874", "AQAAAAIAAYagAAAAEAS62bBIiRF8N5Pc/Ct4xzdT1CYOsv+FmW27ddxuUozQCBqxfXEcdq4XcnoRfgkEnA==", "fcbe6221-1015-44d7-8322-1b26372ee74f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e6f6721-4d93-4415-acfe-ab062d4e8843", "AQAAAAIAAYagAAAAEPoDQFkZvhv1Qwf33wG6nE2XLsOw5WerC08YsOwGJ18G7+YLPT7S1aCQVWPCHi5Kwg==", "ec5b914e-3ed4-4a6d-a1d8-73eff0ad7ccb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e687ddf-4d02-4a36-b769-cf9942c73d3d", "AQAAAAIAAYagAAAAEBABPbraBmQBKF4Jg/11fvjxpFG312b1riyulvlGddjOLhugtYB7ZuE/ZsvR+hc2ow==", "0619afc4-6983-4ace-b589-262016c819c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d6e33eb-0fa9-4d94-85bd-f0b82f41617b", "AQAAAAIAAYagAAAAEAh8rwhCd3cNnUcMHFW+taJyB6ePvy4cA+L/GV350NLtrAlPyKrBv5BsEmDSSn0aaQ==", "6c734269-0aca-4867-8a3f-0de8cad69ca7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5045f378-1fe1-4fe1-b147-f42ae4670f02", "AQAAAAIAAYagAAAAEKMJVZbHPyYBIjwtLmh4/Mio7WoGybOgMUx8mRV6lovfaPJsnGp7ZGNR28o7Rvc/kw==", "a00547af-9d75-448e-b7d1-99e42f20b136" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "148af91d-28d5-4b2c-bb05-c21e282dc303", "AQAAAAIAAYagAAAAEHFOkxBznCdQJ8JhFvJE5AR4WrrPx/CWQ6JIfPqGdK8l0pFFmcFHSa8ilzVve3fzcw==", "f8b6b889-a39b-4591-a50a-b8656b919156" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c6f1514-d012-49e8-9774-de2fdaaae9c8", "AQAAAAIAAYagAAAAEIaCen00cMNUmKbEadzw9X3tmwci3m55MriJRZi5yS+qyrQAdZzAMMWBUUl/dCFlfg==", "44262641-e1e9-4c5a-aaf7-d260831f14b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c551a84-1212-4d3e-a20b-0e593bd124e1", "AQAAAAIAAYagAAAAEJC3piYO+x9kmW1ZMn9On9y2HRtfDIF/Ruh5YfFEEHoQtS9Evqg9oV9Fp1Gbptj55g==", "dfbf6535-9879-4c97-a7ac-76059f3f2771" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c42f93dc-18d8-4896-9eda-b10f3f64360e", "AQAAAAIAAYagAAAAEH+Hymn7HEJj/ryeBCWGe9yUfKB/21nQO2h5GL4c6XjiR4gQNKdzTjlM0ELr90wu3A==", "e7d4276f-2bbd-4e0d-b57d-bee8f0529e0f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79e591a8-92d6-4de7-9657-136b2f5d53cd", "AQAAAAIAAYagAAAAENuJXYSNLg4yABxh/Jbbe8JtWMGZ6zerueUjYlzxPe+BXe+lNLz0dvJhE52vZ/z2Kw==", "a036fddb-1eb9-4e97-9d24-1901c8521176" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d8d43a6-b701-40cf-8e38-fe770c69ed8e", "AQAAAAIAAYagAAAAENBVKAASQutaP0Bl/KN+NfL8qJBOgAMOBCXTgMaQ3eP97WFuC2iV2jn8SkqvUFiELA==", "75fa5976-6022-45ec-8815-03946bf3bda8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe523ffe-7189-46af-9b7f-50ade2b72657", "AQAAAAIAAYagAAAAEODGp5m/nCtV9+dFQrXb/GVcQtkyuqu+48wa39lyfF4Pz1mN0+dp7J+G3nxrWv0SMA==", "849e3d10-883a-46ca-b387-a5770938dde6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f286e1c3-1a6e-4419-a058-6bed79fb78bc", "AQAAAAIAAYagAAAAEIFj7Sb4Wouatu8+ehVsRPFaGI42dtL76dK12bm4mEK2AdyMwn29R6bAgHJj58oDUQ==", "033496f5-d050-48f6-8ea8-58982655d807" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11b592b2-e4f4-45a8-ac3e-ca3a281b3277", "AQAAAAIAAYagAAAAEAUzYi9gduzoOfDxWO/1987xtqS7TrStIQ0TV2JKQqaTjTMGxsR7DME6RGxAV/bhoQ==", "590e57f4-9517-4453-b8d6-fedb593cd1b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a32b9cb3-6372-4521-8614-8d976fbbbd28", "AQAAAAIAAYagAAAAEJ9YkdBn2CUqdAlUYLKGvWiAnEWbioSwK1x5Yi9H6EEU28FTLJDh3G2X2U5CpWYOBQ==", "c8522b97-7eb9-4764-acbc-43aa00909ac9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45f6fe3a-5209-4b46-a781-57d06b76a0a3", "AQAAAAIAAYagAAAAEJmy6OEkrh8LJGTRl7LLg4kDNUmnj6cliGWHgOhGsSl0ABFvr3zDAQaBhhuYQTSsqA==", "c952d26c-76ce-4d9f-8f26-c344a1778f89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf698e46-3b20-4986-adb9-e3fc2bb3b18b", "AQAAAAIAAYagAAAAEJmEM3uD+DE5kv5yPRR79K4d0Z1JdBcVB86iDRmfo0mGoM66NLTHUUFbwhH3bhbqtw==", "c8fcfaad-242a-47e5-a4ba-16f680d7ea46" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2a8c410-f5df-408e-95ee-60ddc593de5a", "AQAAAAIAAYagAAAAEIZZXy6R67tfJcx+0x5avGPZ+4GolnsNUgrGag+0GNJ4P+EqP0696kwCyGZaTU6KJw==", "cf821cd6-a73a-4c57-bbd4-ecd7983e2622" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75db6c56-9f29-4238-a1ad-bcbfe838a44b", "AQAAAAIAAYagAAAAEO9m5BJyZ9t0qMdUTQ7U6SWgSkhBel0m1+AstakFql78fxzxlOT4NZVxSMVY/2eymQ==", "e00e0584-4749-4fa6-83f4-62c181b2cf20" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6665f07-6929-44c1-9207-fb613021b0b1", "AQAAAAIAAYagAAAAENGOPLCGWnhZ7WDg3heyMyjremw3p3Mjt3Ug1dys1IlN2xYkz3KJ2Y/eEjAzwFDoLw==", "2b1dba0e-1253-4985-8023-c8ec2c6c32cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9fbe6a85-cde9-463f-91cb-6c2ab2884b45", "AQAAAAIAAYagAAAAEGZiJg1ViB+Y6obo6FI87FgycnGkYKaWTR7el34MQ7x2Va9sxllc68jAzyGsD0rgsg==", "23bb6b6d-8f88-4cd0-be09-4acd324dcd7d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8ff6adc-d2a6-4db5-9ff0-22c97d0448b5", "AQAAAAIAAYagAAAAEHs2Opuh430AQEcTIvUsGU+WYiyg2VIkc4hk2GPE8szY+XYeEzk0e9OhRvzvj8rZKw==", "164ef69c-f990-4da4-b475-42188474ad67" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d602c0e2-6b15-4dcd-b3df-61f1b8b018f2", "AQAAAAIAAYagAAAAEMgGWVbmiEkOWINmPqJu/l4y2xfcNtQdIW8YLhvzdvoQMBqxuanqSm7rwLJl+wQl4g==", "b2c36e73-5c15-48c5-95e9-be7dbeab3107" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e9c48dc-353e-4e22-890d-ae69185f50eb", "AQAAAAIAAYagAAAAEAOwWF4WMlIrJkLvrEYLppL2ewk9wxaKlfd5KOaxKnHrveXZBju3q7XhXXwdke5hvA==", "a7fe938e-ad6b-43bc-bbb4-17ec555db382" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "acf4b5b4-eb40-498a-928a-0570a1397ade", "AQAAAAIAAYagAAAAEMOOP1jpg9zUQQu0fp9d8RWx1g0riK5meiQUdACzDwQDVSozaai4DJZ5LUB9RCf5Xg==", "c77eb268-7082-4c8d-9f92-1837ded62b10" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cf8511c-4c60-4e49-8b14-74f85dcae465", "AQAAAAIAAYagAAAAEPz/impihwAvfjIOBPLLbLZl8gcXu4q+X62n9dbRAR0Lhk82D/j6RV9YaMKJISKMpg==", "2f9b3adf-693d-4bf6-9789-3779efd3c094" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a540ff96-2b5a-4e33-850b-be4d7b185d46", "AQAAAAIAAYagAAAAEO0Dc3QM/Snpf8HxF29lvuYfoK78KtV/vTxSeMidoHjHZN/fgM9FNCi7PXsR6hCpwg==", "61a7b821-dad5-4f08-a5fd-fe3cf770cfdf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a8e38b0-0d5b-417c-9289-74196f77f2b1", "AQAAAAIAAYagAAAAENCnAqZp8l0gTJ5vo2g7IM1vxbCE9VYxnuEkM0Hg3A77Gfw1rA3HzCFxCUGmbN6YdA==", "6e8e0b12-3f95-4e30-8ea8-f11ead9fbad5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6493468c-ecc5-41c6-86c8-3271dad98651", "AQAAAAIAAYagAAAAEAfFCjZGNjo72HjDNXDH0QFwnP9DNScAak+kkkKh9Q0gQtbRa2js0ywgFjyVpGy1fg==", "a1d79d14-8419-4453-a002-570d1646bcb6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77c802be-2620-43de-a9f0-5940b9ee18e9", "AQAAAAIAAYagAAAAEHUQ4zW47bFaSTR3Ezz0adpHOxxzBrAvpUDGXHdh9ww2o7pUveI+QBBDzol4k9EIjg==", "3e12ca28-4394-4d99-b300-05d8e4af8514" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8483eb01-7cef-486c-a172-deee3d4bddfa", "AQAAAAIAAYagAAAAECwEDEE3+b/VSPvq/YP0KpwOukUjSbEAqd224PkVEnHWreebAhFcF1oZGdQ0IO5jng==", "86ab1042-9a9d-496c-bd2a-87ef28a074a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a86a943-09dd-420a-af66-421dc63a0571", "AQAAAAIAAYagAAAAELW3lJffd3CuwlbD/Po3XrgdXZpv9WZ1qtlHplSHWu2v3js23rzsqoYa/haoY2WnTA==", "7cf974b4-6907-4ce5-aa77-cbe7a2f1d634" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4cc1188-90a7-4bd1-b951-078802437928", "AQAAAAIAAYagAAAAEIdrME3mQRQa+xFXUFHP+q+CBekCwbMeRP0thRwUmZRsmffdQvFOXuyHvp9LLY2ggg==", "70e6c130-fa4e-4302-9b14-f79925ee80a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf4866ea-851a-4389-950a-0d2af883bfcc", "AQAAAAIAAYagAAAAEITRImpbNtViX73dBP25FeE4xikyUf2AA1URBpZe4PwPSjy2HJmqlrOUKV+2TXLSzA==", "a3c2c040-0182-4673-ae5a-e44f332de1c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "490ff7ef-4f62-4c8c-b903-d99633319bfa", "AQAAAAIAAYagAAAAEAwnGc3wO5Hw8b4ryiKpWZfjr/tPJf966OHYccBjmexwAdy+dTFTVf1QFPkTV9wsNQ==", "9d7b03f6-3241-4300-8949-a19be7a0013b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f879f4c-1db9-4e5b-9742-972bbc152ac0", "AQAAAAIAAYagAAAAEL6jHQEjhvarO9KPk9iPZTz1pj/fYJ1XPK3ogdGt7nt1J1KsRICMM9XqjsP6zhcb1g==", "6fbf0cd5-e4e4-4f43-ad89-02bf1de17df2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "516e3639-79f4-4a78-8d1c-9ae000e25b55", "AQAAAAIAAYagAAAAEIb0+t2noOXztxYzBVZwN3tI6SfxUjsB+LKZO22K/Bl7rnh6A9fWb55CWYC1Eu5k2Q==", "2819555d-2e12-4d6d-9cac-5492571d4764" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2393acc-087f-4e03-b38c-aed2fca14568", "AQAAAAIAAYagAAAAEOsSminW7MnFhTpr4rZHppKIxdVXypHL+rdEFeom/Z0o2WfILZq0+vKxSv8X7igBfw==", "17479390-c114-48ec-9800-38ff058e7146" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "304783a1-d8f0-4c20-bf0f-203bdc7a1843", "AQAAAAIAAYagAAAAEM+ejKKYsHMKR/KcZACd+VCWdPbUSExtw70vvnKal7WmfFyw6vCuLFzXg2ZmTrfydw==", "2fe5d497-0940-4c7f-9e04-62e496467057" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6caaa1f8-1a20-4b01-b5cb-5bd5f96a0044", "AQAAAAIAAYagAAAAEDcIcyDwJUgt8axI7p2QsF08GPoHtjxQn5gA0oZ/K303hehadx+TBtCD8PZ66PflCA==", "6e7deca1-54bf-4b18-96b6-641fa8cf9db8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "922b1cd8-e695-482b-b7c9-fedc5f838921", "AQAAAAIAAYagAAAAEBRi6EjXfdNGsDqWId+6cQy3Oq/OKQZU7GBmHsYky/MDuHK8QCu14wEAtpOCuRhrqQ==", "021783af-9d21-4267-adfa-d8340c6431b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5575abb-2b50-4a42-8781-f8aa532226e5", "AQAAAAIAAYagAAAAEDOsP51po9ON7x6qzhuZvgTCzufI0cmmFYVnwhMWeu7TfzEO7TJQPA9OPYl6IK8A6Q==", "7812881a-d946-4c56-9301-5be8a7331597" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "229e23d4-aedd-4125-b59c-f66f1c2aaa05", "AQAAAAIAAYagAAAAEGbO5Lr7ctGMqa55MblHILWl3n4DOGA4CySkA0oho9JQyqMMger5el9esr5CgEkKGQ==", "32de26e2-855d-4bfd-b283-77c1ba8ff7ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93fdee44-9f1d-4ac4-8e44-1f24251ef087", "AQAAAAIAAYagAAAAEHN5EemUZuNSFyow11M3JUlbZTWE0U530jam8jc1+R5Vq7MYEWnEJRDnb+PVsj5H7Q==", "91ba3241-38f4-4b9d-b52a-180711ce7f9c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa9d94c7-056d-4127-b733-a7ae7bd2a148", "AQAAAAIAAYagAAAAEPbEGoAn8aTKnzQH0iKPzPF4WqJslQcPMakqXUWCb3+CRCi3Y0ujnf1IYN53TwAgFQ==", "b5c59160-6582-456d-bb4d-b60e63053776" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fba4266-3fec-4e97-8eea-9780ab695fe5", "AQAAAAIAAYagAAAAELiKGS87Wwv6EHvm/U+VsCuLE30YIyZLUqWWCThdWhlArRxeWXU3fMVHbXe33LwTng==", "b32f782f-b8d3-4fc5-b57d-e23ba8a70b55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aeb827ac-1d76-474a-af09-60ac2d96a8ec", "AQAAAAIAAYagAAAAEJbk+oyxCEuHpHwy1IydUC5jkNqdr+8Nb0VVR4CKzi6VLnJVhMJWVjTKO2ucQiS4Vw==", "7255e195-25f1-484e-b2dc-5c59c2471afe" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 10L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.3.a", "The external and internal issues referred to in 4.1;", 9L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 11L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.3.b", "The requirements of relevant interested parties referred to in 4.2;", 9L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 12L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.3.c", "The products and services of the organization.", 9L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 13L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4", "Quality management system and its processes", 1L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 14L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.1", "The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.", 13L, "The organization shall determine the processes needed for the quality management system and their application throughout the organization, and shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 15L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.a", "Determine the inputs required and outputs expected;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 16L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.b", "Determine sequence and interaction of processes;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 17L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.c", "determine and apply the criteria and methods (including monitoring, measurements and related performance indicators) needed to ensure the effective operation and control of these processes;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 18L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.d", "determine the resources needed for these processes and ensure their availability;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 19L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "4.4.1.e", "assign the responsibilities and authorities for these processes;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 20L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.1.f", "address the risks and opportunities as determined in accordance with the requirements of 6.1;", 14L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 21L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.1.g", "evaluate these processes and implement any changes needed to ensure that these processes achieve their intended results;", 14L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 22L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.1.h", "improve the processes and the quality management system.", 14L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 23L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.2", "", 13L, "To the extent necessary, the organization shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 24L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "4.4.2.a", "maintain documented information to support the operation of its processes;", 23L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 25L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "4.4.2.b", "retain documented information to have confidence that the processes are being carried out as planned.", 23L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 26L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5", "Leadership", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 27L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1", "Leadership and commitment", 26L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 28L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.1.1", "General", 27L, "Top management shall demonstrate leadership and commitment with respect to the quality management system by: NOTE Reference to “business” in this International Standard can be interpreted broadly to mean those activities that are core to the purposes of the organization’s existence, whether the organization is public, private, for profit or not for profit." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 29L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.a", "taking accountability for the effectiveness of the quality management system;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 30L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.b", "ensuring that the quality policy and quality objectives are established and compatible with the organization;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 31L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.c", "ensuring integration of QMS requirements into business processes;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 32L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.d", "promoting the use of the process approach and risk-based thinking;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 33L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.e", "ensuring necessary resources are available;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 34L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.f", "communicating the importance of effective quality management;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 35L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.1.1.g", "ensuring QMS achieves intended results;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 36L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.1.h", "engaging and supporting persons to contribute to QMS effectiveness;", 28L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 37L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.1.i", "promoting improvement;", 28L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 38L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.1.j", "supporting other management roles to demonstrate leadership;", 28L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 39L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2", "Customer focus", 27L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 40L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2.a", "customer and statutory requirements are determined and met;", 39L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 41L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.1.2.b", "risks and opportunities affecting conformity are addressed;", 39L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 42L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.1.2.c", "focus on enhancing customer satisfaction is maintained.", 39L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 43L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2", "Policy", 26L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 44L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.1", "Establishing the quality policy", 43L, "Top management shall establish, implement and maintain a quality policy that:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 45L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.2.1.a", "is appropriate to the purpose and context of the organization;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 46L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.1.b", "provides a framework for setting quality objectives;", 44L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 47L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.1.c", "includes a commitment to satisfy applicable requirements;", 44L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 48L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.1.d", "includes a commitment to continual improvement of the QMS.", 44L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 49L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.2", "Communicating the quality policy", 43L, "The quality policy shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 50L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.2.2.a", "be available and maintained as documented information;", 49L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 51L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.2.b", "be communicated and understood within the organization;", 49L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 52L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.2.2.c", "be available to relevant interested parties.", 49L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 53L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.3", "Organizational roles, responsibilities and authorities", 26L, "Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization. Top management shall assign the responsibility and authority for:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 54L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "5.3.a", "ensuring QMS conforms to requirements;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 55L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.3.b", "ensuring processes deliver intended outputs;", 53L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 56L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "5.3.c", "reporting on the performance of the quality management system and on opportunities for improvement (see 10.1), in particular to top management;", 53L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 57L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "5.3.d", "ensuring promotion of customer focus.", 53L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 58L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6", "Planning", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 59L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1", "Actions to address risks and opportunities", 58L, "When planning for the quality management system, the organization shall consider the context of the organization and the issues referred to in 4.1, as well as the requirements referred to in 4.2. The organization shall determine the risks and opportunities that need to be addressed to:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 60L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.1.a", "give assurance that the QMS can achieve its intended results;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 61L,
                columns: new[] { "ClauseRef", "Description", "Particulars" },
                values: new object[] { "6.1.b", "enhance desirable effects;", "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 62L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.c", "prevent or reduce undesired effects;", 59L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 63L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.d", "achieve improvement.", 59L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 64L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.2", "", 59L, "The organization shall plan actions to address risks and opportunities and evaluate their effectiveness of these actions.." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 65L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.a", "actions to address these risks and opportunities;", 64L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 66L,
                columns: new[] { "ClauseRef", "Description", "Particulars" },
                values: new object[] { "6.1.2.b", "", "how to:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 67L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.b.1", "integrate and implement the actions into QMS processes (see 4.4);", 66L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 68L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.b.2", "evaluate the effectiveness of these actions.", 66L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 69L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.1.2.NOTE 1", "Options to address risks can include avoiding risk, taking risk in order to pursue an opportunity, eliminating the risk source, changing the likelihood or consequences, sharing the risk, or retaining risk by informed decision.", 64L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 70L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.1.2.NOTE 2", "Opportunities can lead to the adoption of new practices, launching new products, opening new markets, addressing new customers, building partnerships, using new technology and other desirable and viable possibilities to address the organization’s or its customers’ needs.", 64L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 71L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2", "Quality objectives and planning to achieve them", 58L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 72L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.1", "The organization shall establish quality objectives at relevant functions, levels and processes needed for the quality management system.", 71L, "The quality objectives shall: The quality objectives shall:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 73L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.a", "be consistent with the quality policy;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 74L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.b", "be measurable;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 75L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.c", "take into account applicable requirements;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 76L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.1.d", "be relevant to conformity and customer satisfaction;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 77L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.1.e", "be monitored;", 72L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 78L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.1.f", "be communicated;", 72L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 79L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.1.g", "be updated as appropriate.", 72L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 80L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.2", "", 71L, "When planning how to achieve quality objectives, the organization shall determine:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 81L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.2.a", "what will be done;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 82L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.2.2.b", "what resources will be required;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 83L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.2.2.c", "who will be responsible;", 80L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 84L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.2.d", "when it will be completed;", 80L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 85L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.2.2.e", "how results will be evaluated.", 80L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 86L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "6.3", "Planning of changes", 58L, "When the organization determines the need for changes to the quality management system, the changes shall be carried out in a planned manner (see 4.4). The organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 87L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "6.3.a", "purpose of the change and potential consequences;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 88L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.3.b", "integrity of the QMS;", 86L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 90L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "6.3.d", "allocation or reallocation of responsibilities and authorities.", 86L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 91L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7", "Support", null, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 92L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1", "Resources", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 93L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.1", "General", 92L, "The organization shall determine and provide the resources needed for the establishment, implementation, maintenance and continual improvement of the quality management system. The organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 94L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.1.a", "capabilities and constraints of existing internal resources;", 93L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 95L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.1.b", "what needs to be obtained from external providers.", 93L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 96L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.2", "People", 92L, "The organization shall determine and provide the persons necessary for the effective implementation of its quality management system and for the operation and control of its processes." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 97L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.3", "Infrastructure", 92L, "The organization shall determine and provide the infrastructure needed for the operation of its processes and to achieve conformity of products and services. " });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 98L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.3.a", "buildings and associated utilities;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 99L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.3.b", "equipment, including hardware and software;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 100L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.3.c", "transportation resources;", 97L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 101L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.3.d", "information and communication technology.", 97L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 102L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.4", "Environment for the operation of processes", 92L, "The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services. physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise). NOTE A suitable environment can be a combination of human and physical factors, such as:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 103L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.4.a", "social (e.g. non-discriminatory, calm, non-confrontational);" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 104L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.4.b", "psychological (e.g. stress-reducing, burnout prevention, emotionally protective);", 102L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 105L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.4.c", "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise).", 102L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 106L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5", "Monitoring and measuring resources", 92L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 107L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.1", "General", 106L, "The organization shall determine and provide the resources needed to ensure valid and reliable results when monitoring or measuring is used to verify the conformity of products and services to requirements. \" +\r\n            \"The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.\"" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 108L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.1.a", "are suitable for specific monitoring activities being undertaken;", 107L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 109L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5.1.b", "are maintained to ensure their continuing fitness for their purpose.", 107L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 110L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.2", "Measurement traceability", 106L, "The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary. The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 111L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.5.2.a", "calibrated or verified, or both, at specified intervals, or prior to use, against measurement standards traceable to international or national measurement standards; when no such standards exist, the basis used for calibration or verification shall be retained as documented information;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 112L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.5.2.b", "identified to determine status;", 110L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 113L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.5.2.c", "safeguarded from adjustments, damage or deterioration that would invalidate the calibration status and subsequent measurement results.", 110L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 114L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.1.6", "Organizational knowledge", 92L, "The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services. This knowledge shall be maintained and be made available to the extent necessary. When addressing changing needs and trends, the organization shall consider its current knowledge and determine how to acquire or access any necessary additional knowledge and required updates. Organizational knowledge can be based on:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 115L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.6.Note 1", "Organizational knowledge is knowledge specific to the organization; it is generally gained by experience. It is information that is used and shared to achieve the organization’s objectives." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 116L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.1.6.Note 2", "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, or the reassignment of currently employed persons; or the hiring or contracting of competent persons." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 117L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.6.a", "internal sources (e.g. intellectual property; knowledge gained from experience; lessons learned from failures and successful projects; capturing and sharing undocumented knowledge and experience; the results of improvements in processes, products and services);", 114L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 118L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.1.6.b", "external sources (e.g. standards; academia; conferences; gathering knowledge from customers or external providers).", 114L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 119L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.2", "Competence", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 120L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.2.a", "determine the necessary competence of person(s) doing work under its control that affects the performance and effectiveness of the quality management system;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 121L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.2.b", "ensure that these persons are competent on the basis of appropriate education, training, or experience;", 117L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 122L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.2.c", "where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken;", 117L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 123L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.3", "Awareness", 91L, "The organization shall ensure that persons doing work under the organization’s control are aware of:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 124L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.3.a", "quality policy;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 125L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.3.b", "relevant quality objectives;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 126L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.3.c", "their contribution to the effectiveness of the quality management system, including the benefits of improved performance;", 121L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 127L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.3.d", "the implications of not conforming with the quality management system requirements.", 121L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 128L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.4", "Communication", 91L, "The organization shall determine the internal and external communications relevant to the quality management system, including:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 129L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.a", "what to communicate;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 130L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.b", "when to communicate;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 131L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.4.c", "with whom to communicate;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 132L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.4.d", "how to communicate;", 126L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 133L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.4.e", "who communicates.", 126L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 134L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5", "Documented information", 91L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 135L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.1", "General", 132L, "The organization’s quality management system shall include:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 136L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.1.a", "documented information required by this International Standard;", 133L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 137L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.1.b", "documented information determined by the organization as being necessary for the effectiveness of the quality management system.", 133L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 138L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.2", "Creating and updating", 132L, "When creating and updating documented information, the organization shall ensure appropriate:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 139L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.2.a", "identification and description (e.g. a title, date, author, or reference number);" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 140L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.2.b", "format (e.g. language, software version, graphics) and media (e.g. paper, electronic);", 136L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 141L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.2.c", "review and approval for suitability and adequacy.", 136L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 142L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3", "Control of documented information", 132L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 143L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.1", "Documented information required by the quality management system and by this International Standard shall be controlled to ensure:", 140L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 144L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.3.1.a", "it is available and suitable for use, where and when it is needed;", 141L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 145L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.1.b", "it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).", 141L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 146L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.3.2", "", 140L, "Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and be controlled.Documented information retained as evidence of conformity shall be protected from unintended alterations. For the control of documented information, the organization shall address the following activities, as applicable:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 147L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.3.2.a", "distribution and access;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 148L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "7.5.3.2.b", "storage and preservation, including preservation of legibility;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 149L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "7.5.3.2.c", "control of changes (e.g. version control);", 144L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 150L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "7.5.3.2.d", "retention and disposition.", 144L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 151L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8", "Operation", null });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 152L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.1", "Operational planning and control", 149L, "The organization shall plan, implement and control the processes (see 4.4) needed to meet the requirements for the provision of products and services, and to implement the actions determined in Clause 6, by:The output of this planning shall be suitable for the organization’s operations. The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary. The organization shall ensure that outsourced processes are controlled (see 8.4)." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 153L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.a", "determining the requirements for the products and services;", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 154L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.b", "establishing criteria for:", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 155L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.b.1", "the processes;", 152L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 156L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.b.2", "the acceptance of products and services;", 152L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 157L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.1.c", "determining the resources needed to achieve conformity to the product and service requirements;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 158L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.d", "implementing control of the processes in accordance with criteria;", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 159L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.e", "determining, maintaining and retaining documented information to the extent necessary:", 150L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 160L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.e.1", "to have confidence processes were carried out as planned;", 157L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 162L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2", "Requirements for products and services", 149L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 163L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.1.e.2", "to demonstrate the conformity of products and services to their requirements.", 157L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 164L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.1", "Customer communication", 160L, "Communication with customers shall include:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 165L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.a", "providing information relating to products and services;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 166L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.b", "handling enquiries, contracts or orders, including changes;;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 167L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.1.c", "obtaining customer feedback relating to products and services, including customer complaints;;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 168L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.1.d", "handling or controlling customer property;", 161L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 169L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.1.e", "establishing specific requirements for contingency actions, when relevant.", 161L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 170L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.2", "Determining the requirements for products and services", 160L, "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 171L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.2.a", "the requirements for the products and services are defined, including:", 167L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 172L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.2.a.1", "any applicable statutory and regulatory requirements;", 168L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 173L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.2.a.2", "those considered necessary by the organization;", 168L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 174L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.2.b", "the organization can meet the claims for the products and services it offers.", 167L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 175L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3", "", 160L, "Review of the requirements for products and services" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 176L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3.1", "Review before commitment to supply", 172L, "The organization shall ensure that contract or order requirements differing from those previously defined are resolved. The customer’s requirements shall be confirmed by the organization before acceptance, when the customer does not provide a documented statement of their requirements." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 177L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.a", "requirements specified by the customer, including the requirements for delivery and postdelivery activities;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 178L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.b", "requirements not stated by the customer, but necessary for the specified or intended use, when known;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 179L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.2.3.1.c", "requirements specified by organization;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 180L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.1.d", "statutory and regulatory requirements applicable to the products and services;", 173L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 181L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.1.e", "contract or order requirements differing from those previously expressed.", 173L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 182L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.2", "The organization shall retain documented information, as applicable:", 172L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 183L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.3.2.a", "on the results of the review;", 179L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 184L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.2.3.2.b", "on any new requirements for products and services.", 179L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 185L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.2.4", "Changes to requirements for products and services", 160L, "The organization shall ensure that relevant documented information is amended, and that relevant persons are made aware of the changed requirements, when the requirements for products and services are changed." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 186L,
                columns: new[] { "ClauseRef", "ParentID", "Particulars" },
                values: new object[] { "8.3", 149L, "" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 187L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.3.1", "General", 183L, "The organization shall establish, implement and maintain a design and development process that is appropriate to ensure the subsequent provision of products and services." });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 188L,
                columns: new[] { "ClauseRef", "Description", "ParentID", "Particulars" },
                values: new object[] { "8.3.2", "Design and development of products and services", 183L, "In determining the stages and controls for design and development, the organization shall consider:" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 189L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.a", "the nature, duration and complexity of the design and development activities;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 190L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.b", "the required process stages, including applicable design and development reviews;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 191L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.c", "the required design and development verification and validation activities;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 192L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.3.2.d", "the responsibilities and authorities involved in the design and development process;", 185L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 193L,
                columns: new[] { "ClauseRef", "Description", "ParentID" },
                values: new object[] { "8.3.2.e", "the internal and external resource needs for the design and development of products and services;;", 185L });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 194L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.f", "The need to control interfaces between persons involved in the design and development process;" });

            migrationBuilder.UpdateData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 195L,
                columns: new[] { "ClauseRef", "Description" },
                values: new object[] { "8.3.2.g", "The need for involvement of customers and users in the design and development process;" });

            migrationBuilder.InsertData(
                table: "IsoStandards",
                columns: new[] { "Id", "ClauseRef", "Description", "IsDeleted", "ParentID", "Particulars", "VersionID", "isActive" },
                values: new object[,]
                {
                    { 89L, "6.3.c", "availability of resources;", false, 86L, "", 1, true },
                    { 196L, "8.3.2.h", "The requirements for subsequent provision of products and services;", false, 188L, "", 1, true },
                    { 197L, "8.3.2.i", "The level of control expected by customers and other interested parties;", false, 188L, "", 1, true }
                });
        }
    }
}
