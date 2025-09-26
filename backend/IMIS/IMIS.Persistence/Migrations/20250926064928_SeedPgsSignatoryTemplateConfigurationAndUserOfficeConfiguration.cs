using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedPgsSignatoryTemplateConfigurationAndUserOfficeConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Position",
                table: "PgsSignatoryTemplate",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "PgsDeliverableAccomplishment",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsDeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    PostingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    PercentAccomplished = table.Column<double>(type: "float", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    AttachmentPath = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsDeliverableAccomplishment", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsDeliverableAccomplishment_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PgsDeliverableAccomplishment_Deliverable_PgsDeliverableId",
                        column: x => x.PgsDeliverableId,
                        principalTable: "Deliverable",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PgsSummaryNarrative",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Findings = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Recommendation = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Conclusion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PgsPeriodId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsSummaryNarrative", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsSummaryNarrative_PgsPeriod_PgsPeriodId",
                        column: x => x.PgsPeriodId,
                        principalTable: "PgsPeriod",
                        principalColumn: "Id");
                });

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
                column: "ConcurrencyStamp",
                value: "2ce6c50b-2c05-41b5-af3b-753109daea9b");

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

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "18b4151f-bff9-4525-b787-7a7e009757c3", "324e9832-31c6-4746-b7df-0e1b773dfc32", "PGS Auditor Head", "PGS AUDITOR HEAD" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7166dcda-1301-4a6d-8aa8-45b1902bded6", "AQAAAAIAAYagAAAAEPgipKIiEoeJ5g5MuTV4INUldPmuPJNQCbmP4RtvPyUfSYWWX2MSR2bcyL8Y0GDWYw==", "d928f776-d709-4390-ada8-54596107ed6c" });

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
                columns: new[] { "ConcurrencyStamp", "MiddleName", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd02bcb6-0dfd-4389-8b25-3028a6535652", "Bello", "AQAAAAIAAYagAAAAEFKAJNhzbVygXF884FfbplQTCmGPjwfc88l7zxfincMI9wXzRYwACzqeEUCgQlm5gw==", "6d3f43b9-7621-439b-b8b7-8947f9138e56" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "18b4151f-bff9-4525-b787-7a7e009757c3", 0, "9897fd33-9f7b-4a43-8f2b-c13d4bc51fc7", "User", "Singgon1234@gmail.com", false, "Bai Samirah", "Singgon", false, null, "A.", "SINGGON1234@GMAIL.COM", "SINGGON", "AQAAAAIAAYagAAAAEOQbaCnGBzgfSSgvkJYxvr6uFmBv1buVNB2V7J/djmh2sB9dmmW1crxBRiLqCmK5Yw==", "", false, null, null, "3f89e5c6-fa14-4014-9f95-fffc18386661", null, false, "Singgon" },
                    { "537d9fcd-b505-4f93-afc6-17eb8eddff83", 0, "b92231cc-0b7c-40bb-947a-373aefd2d006", "User", "Nolan1234@gmail.com", false, "Nolan", "Avanzado", false, null, "", "NOLAN1234@GMAIL.COM", "NOLAN", "AQAAAAIAAYagAAAAEOJ4U4wUoG70U59XOeraRiQEixKujiMgnXa/vYqcVPHnI8pp6IdpNoZWai/DS24Fyw==", "", false, null, null, "a4abfc23-b16e-4c7e-8d2b-8f5592091d88", null, false, "Nolan" },
                    { "743b9807-3441-47c1-9285-5ff8dfd7acb9", 0, "8bb7a7c8-a3ae-4a1b-80bf-3588628e7b16", "User", "Sheila1234@gmail.com", false, "Sheila farish", "Mangelen", false, null, "K.", "SHEILA1234@GMAIL.COM", "SHEILA", "AQAAAAIAAYagAAAAEFKmT7Jp5TRw1XbS9hU96UIgw52O1RfZivDO9RU32/2RpCM0zC8zF6c44pGsv+teXA==", "", false, null, null, "865d3dba-eef6-4846-9607-e555c5f72c47", null, false, "Sheila" },
                    { "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", 0, "479d8c70-3927-4ad9-9b49-84aa0dd5bb21", "User", "Johari1234@gmail.com", false, "Johari", "Casan", false, null, "P.", "JOHARI1234@GMAIL.COM", "JOHARI", "AQAAAAIAAYagAAAAEG9scQ4pcOs/3DcQ5v7hc81Q0uHJDj2RcSpTXBBqtMyn+Bu4aASb9Ewp/TBa2ofG7A==", "", false, null, null, "760a1ec8-18b9-4010-a91c-5378f0ac70bc", null, false, "Johari" },
                    { "7eee5b08-df0d-4ac0-a8db-39d924dd30b7", 0, "3a2adab2-1ede-45f5-8043-8856c547a3b3", "User", "Linda1234@gmail.com", false, "Linda", "Garde", false, null, "P.", "LINDA1234@GMAIL.COM", "LINDA", "AQAAAAIAAYagAAAAEEYfKywyBZcXDHhEF1jGAAmGYdhFfq+DRqyVNwXm0Eg335VZ9kphXMX8GsRVkBYa0g==", "", false, null, null, "9990c41b-7c5f-46f6-8310-0cab210a5c0d", null, false, "Linda" },
                    { "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", 0, "37f8b2dd-54e9-4fd5-9242-29074a23053f", "User", "Java1234@gmail.com", false, "Sergio", "Java", false, null, "C.", "JAVA1234@GMAIL.COM", "JAVA", "AQAAAAIAAYagAAAAEOX9cj+35zvbCnumy5cAZKpLXfSOPKZcLvbQOw7FTrQKigWAQ9mj2RGPi5iAeb2LKg==", "", false, null, null, "9d635169-d933-4601-babd-3ed01258f8a8", null, false, "Java" },
                    { "a6866933-92a9-41e7-9100-8bee51ed0ada", 0, "36d5d3ef-f3be-4eb1-8471-9f5f60cf67c7", "User", "John1234@gmail.com", false, "John", "Maliga", false, null, "O.", "JOHN1234@GMAIL.COM", "JOHN", "AQAAAAIAAYagAAAAEOiHgO9peI9htILa+GqtocjikMmtmulODaL+gq6NPULP9B+Bm0VRMdDRGW4hP4+mIg==", "", false, null, null, "6838f1aa-5e0d-4a37-a6df-f6c08a1f9302", null, false, "John" },
                    { "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", 0, "e4a9dee0-3168-43ed-a49e-81121810d9cd", "User", "Ibrahim1234@gmail.com", false, "Scheherazade", "Ibrahim", false, null, "E.", "IBRAHIM1234@GMAIL.COM", "IBRAHIM", "AQAAAAIAAYagAAAAEAdWt8yegRwIYFkcBA6T+6iEL9UDR07bOsvMOkSOCN7y7sMsqXQZOoMaiehX1PrnGQ==", "", false, null, null, "ab7b1dbc-d56a-4953-b280-8606b8adcdaf", null, false, "Ibrahim" },
                    { "e1a3ac20-1d20-4f37-8826-242657a746c7", 0, "453ff5bb-10f7-42cb-be0a-320e3e02d8e3", "User", "Dimaren1234@gmail.com", false, "Ishmael", "Dimaren", false, null, "R.", "DIMAREN1234@GMAIL.COM", "DIMAREN", "AQAAAAIAAYagAAAAEH0t4VbU0H/w9VY3aIIwuwFPh0C3QPCf5Oxn28RmVFY+9qyXwfNxwJ2JCX2gIPMHLQ==", "", false, null, null, "f17ccef4-0259-47af-a658-d5b947738778", null, false, "Dimaren" },
                    { "e9bcc340-e63f-40e6-8326-8fe86cbef923", 0, "ecb3b809-d68b-4ed1-8bbd-3afb8eca5bdd", "User", "Precious1234@gmail.com", false, "Precious Love", "Esquillo", false, null, "Y.", "PRECIOUS1234@GMAIL.COM", "PRECIOUS", "AQAAAAIAAYagAAAAEAypA4GXlXe6pdDQL4ntHXHwwAJX78sXA3Prf3w6Z6kc+NidzF6hmhXtaTnhdkV1FA==", "", false, null, null, "3bcaaa57-b4b9-4cb8-bf7a-8ad51677bc01", null, false, "Precious" }
                });

            migrationBuilder.InsertData(
                table: "UserOffices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "IsOfficeHead", "OfficeId", "UserId" },
                values: new object[,]
                {
                    { 1, true, false, false, 1, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 2, true, false, false, 1, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 3, true, false, false, 1, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 4, true, false, false, 2, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 5, true, false, false, 2, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 6, true, false, false, 2, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 7, true, false, false, 3, "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" },
                    { 8, true, false, false, 3, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 9, true, false, false, 3, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 10, true, false, false, 3, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 11, true, false, false, 4, "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" },
                    { 12, true, false, false, 4, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 13, true, false, false, 4, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 14, true, false, false, 4, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 15, true, false, false, 5, "e9bcc340-e63f-40e6-8326-8fe86cbef923" },
                    { 16, true, false, false, 5, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 17, true, false, false, 5, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 18, true, false, false, 5, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 19, true, false, false, 7, "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" },
                    { 20, true, false, false, 7, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 21, true, false, false, 7, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 22, true, false, false, 7, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 23, true, false, true, 125, "537d9fcd-b505-4f93-afc6-17eb8eddff83" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "18b4151f-bff9-4525-b787-7a7e009757c3" },
                    { "56996e97-9e8a-4d22-a693-c865144e9b96", "537d9fcd-b505-4f93-afc6-17eb8eddff83" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7eee5b08-df0d-4ac0-a8db-39d924dd30b7" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e9bcc340-e63f-40e6-8326-8fe86cbef923" }
                });

            migrationBuilder.InsertData(
                table: "PgsSignatoryTemplate",
                columns: new[] { "Id", "DefaultSignatoryId", "IsActive", "IsDeleted", "OfficeId", "OrderLevel", "Position", "SignatoryLabel", "Status" },
                values: new object[,]
                {
                    { 1, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 1, 1, "Head, PGS", "Recommended By", "Recommended" },
                    { 2, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 1, 2, null, "Noted By", "Noted" },
                    { 3, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 1, 3, null, "Approved By", "Approved" },
                    { 4, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 2, 1, "Head, Medical Service/PGS", "Reviewed / Recommmended By", "Reviewed / Recommmended" },
                    { 5, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 2, 2, null, "Noted By", "Noted" },
                    { 6, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 2, 3, null, "Approved By", "Approved" },
                    { 7, "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", true, false, 3, 1, null, "Reviewed By", "Reviewed" },
                    { 8, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 3, 2, "Head, PGS", "Recommended", "Recommended" },
                    { 9, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 3, 3, null, "Noted By", "Noted" },
                    { 10, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 3, 4, null, "Approved By", "Approved" },
                    { 11, "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", true, false, 4, 1, null, "Reviewed By", "Reviewed" },
                    { 12, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 4, 2, "Head, PGS", "Recommended By", "Recommended" },
                    { 13, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 4, 3, null, "Noted By", "Noted" },
                    { 14, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 4, 4, null, "Approved By", "Approved" },
                    { 15, "e9bcc340-e63f-40e6-8326-8fe86cbef923", true, false, 5, 1, null, "Reviewed By", "Reviewed" },
                    { 16, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 5, 2, "Head, PGS", "Recommended By", "Recommended" },
                    { 17, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 5, 3, null, "Noted By", "Noted" },
                    { 18, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 5, 4, null, "Approved By", "Approved" },
                    { 19, "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", true, false, 7, 1, null, "Reviewed By", "Reviewed" },
                    { 20, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 7, 2, "Head, PGS", "Recommended By", "Recommended" },
                    { 21, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 7, 3, null, "Noted By", "Noted" },
                    { 22, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 7, 4, null, "Approved By", "Approved" },
                    { 23, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 135, 1, "Head, PGS", "Recommended By", "Recommended" },
                    { 24, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 135, 2, null, "Approved By", "Approved" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableAccomplishment_PgsDeliverableId",
                table: "PgsDeliverableAccomplishment",
                column: "PgsDeliverableId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableAccomplishment_UserId",
                table: "PgsDeliverableAccomplishment",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsSummaryNarrative_PgsPeriodId",
                table: "PgsSummaryNarrative",
                column: "PgsPeriodId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableAccomplishment");

            migrationBuilder.DropTable(
                name: "PgsSummaryNarrative");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3");

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "18b4151f-bff9-4525-b787-7a7e009757c3" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "56996e97-9e8a-4d22-a693-c865144e9b96", "537d9fcd-b505-4f93-afc6-17eb8eddff83" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "743b9807-3441-47c1-9285-5ff8dfd7acb9" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7eee5b08-df0d-4ac0-a8db-39d924dd30b7" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "a6866933-92a9-41e7-9100-8bee51ed0ada" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e1a3ac20-1d20-4f37-8826-242657a746c7" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e9bcc340-e63f-40e6-8326-8fe86cbef923" });

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923");

            migrationBuilder.DropColumn(
                name: "Position",
                table: "PgsSignatoryTemplate");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "40012e96-55c6-4dba-901b-40c50991e18b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "ea8a5461-30b8-4b33-803c-08c601168aec");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b30468e5-537e-44d5-9c27-cc6d1a2c022e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "76d5aea9-9056-4131-bd61-e271f06fe7fc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e358ff6b-e3af-419e-8fc2-31a872147213");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "a4d92d40-3d83-4ca6-98c5-e32acb073116");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "be1f7b52-f2a5-4b87-b8b3-f9058c686a17");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "aeb38fe7-2794-4c88-81b4-52f60d9cc542");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3bf2ec8-faff-41f7-b93c-09be789bbd30", "AQAAAAIAAYagAAAAEImeUvdoocYWhjQkJNzhMuHUiQckWQvxhIBROUd9EOKivJbKxn9WTQs/qT3L7HMgoQ==", "89421508-3114-463c-aa11-912512872b96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0215289e-2d58-4cd5-a6ab-c57f11b05a85", "AQAAAAIAAYagAAAAECoXcG14AwmsJbdiaASgIUOJRPHGpYlVT4OVxkcNtS36J6EO2H20sIi4ymembA2Z+w==", "32c432b2-ce11-4322-8cd5-361de15cc74f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "MiddleName", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01aa752e-99c1-4134-83b1-7939a93019af", "Belli", "AQAAAAIAAYagAAAAEMB2Jq7QMTGjODdXFkbnBgL0ByfVNT/4/2sP2tknyaJYzJ18FIkn7WIXBz/Fiesj9w==", "0eff7506-1bbe-45b9-9d9e-a2cc79d33c39" });
        }
    }
}
