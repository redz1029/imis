using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RenamePgsAuditorRoleToAuditor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "13f4bb20-1f11-468e-95c8-ae1c94930b1e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "269c26e0-5649-480d-8697-341a6aacd5f7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "f7e8fd9b-4632-4f74-941f-ae9f608e8897");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "cac7baf2-655b-497f-9030-221dc94e2f64");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "d1ea123d-5585-4c1a-bafe-6928252f74f5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "1ece6a3b-1fbf-4481-9f77-4304b07e496c", "Auditor", "AUDITOR" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "809d3f17-b971-437e-8170-e21e7c7f4c1b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "046f34f0-2da5-4a22-b467-9ba2c85fb915");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "dfe30913-ea14-420c-a066-bd3af54f079f");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8201f0ed-0181-411a-9887-b0fb9ee759ce", "AQAAAAIAAYagAAAAEFymhJvcohrI7LBFtoTe2ro40ZdLJrzzXNI8ZbwStsNCF+8hoQCGaHRZtTZMXSjDKw==", "38f52ed1-3570-40b7-87e2-7f66bb6c0566" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1483996-5540-49d6-b42e-c2b63ddbfad7", "AQAAAAIAAYagAAAAEFmy/Bo3WASedJ6uaJxJmvMYguYOIqKA6EPmsfDUXpllWWz6278Q1dgO9D0n77vVUQ==", "a55852e9-9c69-48b2-a4bd-ab9a0a501da5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11d29bb4-a21a-4ce7-a23d-f0e72396957e", "AQAAAAIAAYagAAAAEBDfEeIiWHFdIyDUdXkhVL3/uEgn3oWs4dQnLgKW9jstD57IZASOI309tSwFlJ4NFg==", "5e86d382-a5e0-4187-8826-414e5aa7920c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94c84954-8390-4146-8ee8-65302398b760", "AQAAAAIAAYagAAAAEJvuE46NRmFGLzyA4nUxCW6bS4fsERWZ+3OZEOQh8QQG71p//lnBXXj2lfcMEWWmIg==", "55ed475c-bb51-4f98-ba5b-6e688abbea1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a06f8ea3-4df9-4689-8361-91d4b716643f", "AQAAAAIAAYagAAAAENlZh1DOCNikXhJ2ZHwx0dMUCvMtJGuALIKMLgqAvGMQJoxcwxkEBb95q3EgHdt2iA==", "25a2914e-3cb1-4f0d-a13a-e16dd44a54f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "976f48de-48fb-4227-bb2a-90ec18d70d9f", "AQAAAAIAAYagAAAAEMueiKywThd9Im7kJmJ08uSh1PslAYaJgXoC3eREfUTq8fbyoQ6+pEWobEgOPSKWkA==", "bc4b1b7d-f4f2-40e0-99b5-ce81ac963b61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09a11f31-dbc0-4e87-86c4-7b0febeea145", "AQAAAAIAAYagAAAAEIN/iYRDfSPARyon9VCuxpG2l+WLlIW7Z2Hi/JrI7eTMAG/az2W4ruueQ+7uLv5qgg==", "f7796243-a6eb-48b7-b6e0-1526188ec7d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee2854a4-5d56-4e01-ba90-d1dddcd58b49", "AQAAAAIAAYagAAAAEL4dErQjDGFE9DZXMIRZcz7DF+uSBMDUE6dvDS0fHDufPbHX33dzCRnvxDNIedq+1A==", "582b74c9-a275-4f45-aa33-56b2829ef256" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ca01e27-793c-4f03-9d0f-00729f4ad10a", "AQAAAAIAAYagAAAAEEeKdajnrQTUbKoovi/+YO63V3A4hlEFo5Uxwu2sZ4ckmcDF3GrqjTYUxirzBGafDQ==", "a37376ae-3e65-48c2-b508-85a2e5f97ab9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7d89ef8e-4cf6-40b7-bb48-1862082ddd37", "AQAAAAIAAYagAAAAEDTkJU+YGEPC9G9rU/0MviuTm2uky49Sfd56aFlSyH6pn7/IXlmvQ/DyxmIwoHXr6A==", "6c407f6f-5e36-4ede-b7d3-73b56e077168" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb7aec82-eb7b-4a77-8d6c-7f6700266ed9", "AQAAAAIAAYagAAAAEDtjpBEuF9gyuGEJ+7LoLvTQzI5Uoc9GuWzlPeK+OH0elJTykM8M/r8xboOzJsfHoQ==", "578b2f31-6446-444d-bea8-8e8a993e3aa4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4129e881-b51e-4aa9-953e-774332344a3d", "AQAAAAIAAYagAAAAEHZOMH9bBKp7eubnzXOJY98O3CDm4aQWQNHWimkpNudhLgjAbP3Bd3U9qrRFfUhBiQ==", "459d5c27-13d8-4353-976f-60c9ad186c38" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "afade9b1-e8f1-4c70-ac61-b7e65e9195dd", "AQAAAAIAAYagAAAAECE04g7S/G/J2r4OQZ+RNFCgaMwN0A7R9DCriuMBbnOrxA9xe4gFdyPqV0c+28on7g==", "f404e7b2-d9ac-4db6-9c57-7ca29f4d4f3f" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "324e9832-31c6-4746-b7df-0e1b773dfc32");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "af47bda5-83be-496b-9343-47d11506b1c8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "7413fd04-eae0-42ff-9957-73adf8a70eb1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "ace3d0b3-f4cb-418c-bfa0-f392150434cd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "4a1216f9-94c9-4bb4-a72a-3cd4c1a49618");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "2ce6c50b-2c05-41b5-af3b-753109daea9b", "PGS Auditor", "PGS AUDITOR" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "5bb7f2cf-02f4-4244-b5ca-cd34982c215e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "f5473dfa-5c97-48c3-b4a5-bf87699db9f3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a0625d7a-5545-45e8-9696-53820a1109e4");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7166dcda-1301-4a6d-8aa8-45b1902bded6", "AQAAAAIAAYagAAAAEPgipKIiEoeJ5g5MuTV4INUldPmuPJNQCbmP4RtvPyUfSYWWX2MSR2bcyL8Y0GDWYw==", "d928f776-d709-4390-ada8-54596107ed6c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9897fd33-9f7b-4a43-8f2b-c13d4bc51fc7", "AQAAAAIAAYagAAAAEOQbaCnGBzgfSSgvkJYxvr6uFmBv1buVNB2V7J/djmh2sB9dmmW1crxBRiLqCmK5Yw==", "3f89e5c6-fa14-4014-9f95-fffc18386661" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b92231cc-0b7c-40bb-947a-373aefd2d006", "AQAAAAIAAYagAAAAEOJ4U4wUoG70U59XOeraRiQEixKujiMgnXa/vYqcVPHnI8pp6IdpNoZWai/DS24Fyw==", "a4abfc23-b16e-4c7e-8d2b-8f5592091d88" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8bb7a7c8-a3ae-4a1b-80bf-3588628e7b16", "AQAAAAIAAYagAAAAEFKmT7Jp5TRw1XbS9hU96UIgw52O1RfZivDO9RU32/2RpCM0zC8zF6c44pGsv+teXA==", "865d3dba-eef6-4846-9607-e555c5f72c47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "479d8c70-3927-4ad9-9b49-84aa0dd5bb21", "AQAAAAIAAYagAAAAEG9scQ4pcOs/3DcQ5v7hc81Q0uHJDj2RcSpTXBBqtMyn+Bu4aASb9Ewp/TBa2ofG7A==", "760a1ec8-18b9-4010-a91c-5378f0ac70bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a2adab2-1ede-45f5-8043-8856c547a3b3", "AQAAAAIAAYagAAAAEEYfKywyBZcXDHhEF1jGAAmGYdhFfq+DRqyVNwXm0Eg335VZ9kphXMX8GsRVkBYa0g==", "9990c41b-7c5f-46f6-8310-0cab210a5c0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "37f8b2dd-54e9-4fd5-9242-29074a23053f", "AQAAAAIAAYagAAAAEOX9cj+35zvbCnumy5cAZKpLXfSOPKZcLvbQOw7FTrQKigWAQ9mj2RGPi5iAeb2LKg==", "9d635169-d933-4601-babd-3ed01258f8a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "36d5d3ef-f3be-4eb1-8471-9f5f60cf67c7", "AQAAAAIAAYagAAAAEOiHgO9peI9htILa+GqtocjikMmtmulODaL+gq6NPULP9B+Bm0VRMdDRGW4hP4+mIg==", "6838f1aa-5e0d-4a37-a6df-f6c08a1f9302" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4a9dee0-3168-43ed-a49e-81121810d9cd", "AQAAAAIAAYagAAAAEAdWt8yegRwIYFkcBA6T+6iEL9UDR07bOsvMOkSOCN7y7sMsqXQZOoMaiehX1PrnGQ==", "ab7b1dbc-d56a-4953-b280-8606b8adcdaf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "453ff5bb-10f7-42cb-be0a-320e3e02d8e3", "AQAAAAIAAYagAAAAEH0t4VbU0H/w9VY3aIIwuwFPh0C3QPCf5Oxn28RmVFY+9qyXwfNxwJ2JCX2gIPMHLQ==", "f17ccef4-0259-47af-a658-d5b947738778" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ecb3b809-d68b-4ed1-8bbd-3afb8eca5bdd", "AQAAAAIAAYagAAAAEAypA4GXlXe6pdDQL4ntHXHwwAJX78sXA3Prf3w6Z6kc+NidzF6hmhXtaTnhdkV1FA==", "3bcaaa57-b4b9-4cb8-bf7a-8ad51677bc01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe9a8381-e4f7-488a-88b6-5271125b39af", "AQAAAAIAAYagAAAAEE0aCz3oVNW0avcdFmhR6Qyqffyy98MOJMiYjzQ6bFWnym4fiLGVAkj0+pDOBCO1kw==", "f17548ca-3b67-4516-b7e9-54ee375c798a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd02bcb6-0dfd-4389-8b25-3028a6535652", "AQAAAAIAAYagAAAAEFKAJNhzbVygXF884FfbplQTCmGPjwfc88l7zxfincMI9wXzRYwACzqeEUCgQlm5gw==", "6d3f43b9-7621-439b-b8b7-8947f9138e56" });
        }
    }
}
