using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class auditPlanEntryV4 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "ParentID",
                table: "IsoStandards",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Particulars",
                table: "IsoStandards",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "AuditPlans",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    PreparerId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    SelectedApproverId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    PlanStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlans", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlans_AspNetUsers_PreparerId",
                        column: x => x.PreparerId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AuditPlans_AspNetUsers_SelectedApproverId",
                        column: x => x.SelectedApproverId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanApprovals",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditPlanId = table.Column<int>(type: "int", nullable: false),
                    ApproverId = table.Column<int>(type: "int", nullable: false),
                    ApproverId1 = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    Action = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Comments = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanApprovals", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlanApprovals_AspNetUsers_ApproverId1",
                        column: x => x.ApproverId1,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditPlanApprovals_AuditPlans_AuditPlanId",
                        column: x => x.AuditPlanId,
                        principalTable: "AuditPlans",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanEntries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditPlanId = table.Column<int>(type: "int", nullable: false),
                    DayNumber = table.Column<int>(type: "int", nullable: false),
                    Time = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanEntries", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlanEntries_AuditPlans_AuditPlanId",
                        column: x => x.AuditPlanId,
                        principalTable: "AuditPlans",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanPersonResponsibles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditPlanEntryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanPersonResponsibles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlanPersonResponsibles_AuditPlanEntries_AuditPlanEntryId",
                        column: x => x.AuditPlanEntryId,
                        principalTable: "AuditPlanEntries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanProcesses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OfficeId = table.Column<int>(type: "int", nullable: false),
                    AuditPlanEntryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanProcesses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlanProcesses_AuditPlanEntries_AuditPlanEntryId",
                        column: x => x.AuditPlanEntryId,
                        principalTable: "AuditPlanEntries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AuditPlanProcesses_Offices_OfficeId",
                        column: x => x.OfficeId,
                        principalTable: "Offices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "IsoAuditors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TeamId = table.Column<int>(type: "int", nullable: true),
                    AuditorId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsoAuditorsId = table.Column<int>(type: "int", nullable: true),
                    AuditPlanEntryId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IsoAuditors", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IsoAuditors_AuditPlanEntries_AuditPlanEntryId",
                        column: x => x.AuditPlanEntryId,
                        principalTable: "AuditPlanEntries",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IsoAuditors_Auditors_IsoAuditorsId",
                        column: x => x.IsoAuditorsId,
                        principalTable: "Auditors",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IsoAuditors_Teams_TeamId",
                        column: x => x.TeamId,
                        principalTable: "Teams",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "IsoAuditProcess",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    AuditPlanEntryId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IsoAuditProcess", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IsoAuditProcess_AuditPlanEntries_AuditPlanEntryId",
                        column: x => x.AuditPlanEntryId,
                        principalTable: "AuditPlanEntries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "IsoStandardAuditPlans",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsoStandardId = table.Column<int>(type: "int", nullable: true),
                    IsoStandardId1 = table.Column<long>(type: "bigint", nullable: true),
                    AuditPlanEntryId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IsoStandardAuditPlans", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IsoStandardAuditPlans_AuditPlanEntries_AuditPlanEntryId",
                        column: x => x.AuditPlanEntryId,
                        principalTable: "AuditPlanEntries",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IsoStandardAuditPlans_IsoStandards_IsoStandardId1",
                        column: x => x.IsoStandardId1,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "0a98e818-a325-4ed8-b0c7-ed4e902a715e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "d08e4770-c9b4-4823-8153-1a9b395b45b7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "941d2b69-5863-4a2c-8840-dc1e9ca61446");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "1f8336dc-c835-4271-966d-1ecfcbe9563e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f2df2f24-53ec-4414-b197-8e256d33baf4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "643a3a87-1df0-4706-907e-fb1d37b3b508");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "b16b6903-f235-4d30-ae14-85eea8763d3f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "710d6999-efda-4558-bb68-1ad84fea9fc1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "d488274b-4485-4cff-8d44-e4ae1baac4a6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "544aeb1e-5705-477e-879f-89f30ab17785");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "11afd4e1-37aa-4323-9510-6eff1ff51233");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "11196305-ed3a-472c-8481-85094b130b40");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e5824a67-9250-4298-81e8-313ea7e5a453");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "9e9300fa-d4b7-49e4-ac46-b83d420174a9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "2800e767-e5c2-4422-9e54-ae54dc482ff8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "af95dba6-edaa-4c50-be67-e3f89374bc59");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "c8fdc8ea-71e8-427e-9d64-4580cc728bad");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "cbc7c50b-d866-4f78-9d6d-32bb15e09ea1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "3d24d3c4-a3a6-4e41-9839-ee2204e77c69");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6f97550-b9a1-4b4c-a7fd-0f029770d605", "AQAAAAIAAYagAAAAEBhIk8wM/0wTeliNVk1AEl35StEfE8LfLKzrgRfp4c1EN+SDcbpVodavLl1UfqGfhQ==", "10415543-4ce3-4500-8ab7-9c6ffb73a3b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c1123b6-d170-4c38-9e42-a035c0f45060", "AQAAAAIAAYagAAAAELrF1RX1tmTUsfGiUIwcbiY4i3ebQOf2he7zKdX9ioJS0TrCmtjP7Z0AWvxRgWZcbg==", "9bfe2c59-b2d2-4a1f-aa4a-ba140e4fe62d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1231e4fd-32d1-4b93-bb28-25bf6d257e03", "AQAAAAIAAYagAAAAED+l6jRcjTPdDBb6f0Zb2sxI6Jx9+e4mNym5ybITiB7IRlJgRwu7j1HB+4M5nBURtg==", "fc3e1784-9293-46b5-b3a8-decefcc47911" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e00f4c14-c58e-46a8-9c55-f0e538ef99c3", "AQAAAAIAAYagAAAAEHZQZvvnemELpsWK6wJJj3Z3Wc2YRGxRbVp26s6UQrNmU+aKZLXf87yi0WuJGpeUHQ==", "34cabe06-9fa1-494d-a92e-5dc6ea042c26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ace2999-7fa3-4111-9f03-cfb425dd2766", "AQAAAAIAAYagAAAAEGHu1q84zd9bKBboFRYsbuEkChFmcJMa25fRWcaCS2VQzlvOjm3ROcw4MwUovYQz4A==", "58754987-4844-4362-a9d4-dbdb857f9adc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e14370b-cb0e-4ca5-b5bd-d901ca82e274", "AQAAAAIAAYagAAAAEKms5CmGEaL8co8f9DRUZzHWDHN9IZ1N4Ilg1IoGI75lHESeD64A3EDH07OrrTc2cQ==", "9c883d4f-2daa-45ec-80a3-1a62d089c8ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "514b4110-6376-41cf-b250-2fa0dbf5fa1f", "AQAAAAIAAYagAAAAEAKRCTekeYPLX2SRhL4d8xMDOwANtG4IEi2CSfjj1fx5K/sraYvT1hH8lXydfmy73Q==", "87db7411-20d9-4fc4-b3dd-4176c6c56cc8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f85665cd-0fa9-4e85-9fab-b2359b41b5e2", "AQAAAAIAAYagAAAAEFKx45L+YDfT537v8qaEcsFT/Jh7wAUT5FDj2usAZUqslQ8U/WyTFz6ITSJzej1ePg==", "55189688-b50f-4bea-8f2b-b8a7119c309d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "100edf24-359e-49d2-ba4c-3d1d97aff51f", "AQAAAAIAAYagAAAAECOnq0LkREIsk0+ldXRx4JpVS0KRYDPpyFAmHHGE9blf/x8nLpNr6xWL176Dz8YXjA==", "ad71a4fc-4038-4222-9ead-88184b1fe25b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a526d9f0-80f9-41a0-b546-53f180f5ae71", "AQAAAAIAAYagAAAAEAHmG0YYttLA0RFatxSUlmSqej21NNsp/Z9hMLnJ45d5E3AVcaYtm/lVB3I+5tqAag==", "e3c17417-ea18-4e59-a9bf-34d76bfaa31a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b8273e3-b257-4d2b-a4c3-33fa80894693", "AQAAAAIAAYagAAAAEEZ11Y4s5jEM22SyrVJhmwdn5IPfd8n5usflH1y7eXMcRDrfGl3TCVKEVUMfmGD5iQ==", "aa3841bc-df20-4e20-a279-96bc41ace162" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0dcdfec6-8c46-45db-9d3a-f48e7ba59f39", "AQAAAAIAAYagAAAAEPC8/AProit7BalFQZb0oD9vMpJSC+ASXC3+iHpMZr77tr2MpAJjDidiVQNp/tsp7A==", "0d519abb-bbaa-48ed-8c1f-446402d1c4ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9cdc44a5-7ccf-477f-a6f2-06e1644c8da5", "AQAAAAIAAYagAAAAEFB2Sx9qFEruNp/OOkKsHvzph7Phxa8/clHgYQHmULbVw5LiIr358Ah92lLM/KmHGw==", "6cda8c62-c0a8-41b4-86bf-40bb14df9d26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8343b5c2-fa2a-40a2-85b5-8da4cd46fff7", "AQAAAAIAAYagAAAAED6mpDuFoI3bg3fJrCgH3q37EVFJzQ+sbVCwC0U1az2txKGYIE+64Ub1NmIGIoCSkg==", "136c8906-fc38-47d1-b0cb-d4dd5d197649" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "13d7b34d-2ffc-4fea-a0c9-55a1ff2297fe", "AQAAAAIAAYagAAAAEDTHd5WAWi74ovrbEzoYnpSsuBe7dssPImrsJmdW4uh0jZXcwL/JoLFaSDWcDLi5mA==", "00acc376-9544-41da-9e63-f6f22c8f7f4a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ff548ef-eb9d-4ece-b19c-87c6ccf238b7", "AQAAAAIAAYagAAAAEIOIhLigZlZ252oe6NNFBNg8dbHEvOelDgVbujD1CsLtKM89ZOaVz4AfFUPiwy+IFQ==", "c0f55858-f093-4405-a516-ce2ae0b5f147" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "42d0863d-a726-4bc1-b6ef-62dc744f1b45", "AQAAAAIAAYagAAAAEOnWELiIx/5EFrmXrHKUoV42Y9496STqz+XxzQpwCOLuSJTnlLQwswZweeBEWQSJaw==", "833b676c-1867-4f95-aaa9-477cdc5a5c2b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3fbf8517-928b-4bec-8ca4-7e961f306c09", "AQAAAAIAAYagAAAAEFf9MYtsOTj05tlLGjWPpESSgmIABW40OeJ1jmAKvj2WsTzETJRln7O8MkArU9aJlQ==", "a622897f-77e2-4f47-889e-72097fca231b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "124c1a00-371b-46c7-97f3-504b0c5d7492", "AQAAAAIAAYagAAAAEKAA23I734aCASwhTH7GQ3knkf/ogQwiJV1Yv/TFiAQBNI2sNdLgdy4BzGuzCPRK3A==", "f605ff26-831e-451f-bb52-78432b7d9d5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1241a83a-e5cf-4183-8f6e-eb6981ff7e19", "AQAAAAIAAYagAAAAEHD3Gm1H9gM7/xM2CvyqrnnJmzugq/V2W6y+aHcRoWfNTOzHmdYdkbrpKaMNqUXufA==", "c381bd72-07ec-4f2f-baa2-01e8cfe9f519" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8578dd73-e437-49f7-b02c-78e5f4e7db8d", "AQAAAAIAAYagAAAAEFIvuPlCl+BxNIJU3ezcfiWvpYN2Afb6d1h1g4Dht5MFD/z0L7+SDUC3C52TyLaSQA==", "b953723f-2b18-400a-91b7-a8e75991fe7d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "132a13b0-1ae4-4435-bceb-2392121c0360", "AQAAAAIAAYagAAAAENLstWGTCuzajOwQbKdscXtt2Z985kyOK+D5gGelFyluGWMDsWVFGWg3SJacVOJgDQ==", "9a415b22-bd92-4a46-8d1d-4ab583fc0bf6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "659a3082-d7d4-405a-b74d-9c04409c1628", "AQAAAAIAAYagAAAAEMAZhZr1gsU0XFeqc7eQdie83VmCV1RF2s1s474jP8usJTiUANjroI+i5ltNjy8v9w==", "aa564b71-1cbd-4c83-8770-c37d32dc2398" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91815974-8ec9-44e9-998a-f01661fd9e75", "AQAAAAIAAYagAAAAELtg/iyW5lgZvsbs6/0NsH0jrFcx7bpAlRnb01zu+tU2QqPsyO59Bm7M3zDBuvO85w==", "a808cdc7-e8cb-4bd6-9e6b-c9ae6f86da40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf2e2ea2-927d-4962-b985-461954737f1b", "AQAAAAIAAYagAAAAEBvOIKzh6NPZWF4wZxptDCghKskzlL6EDmmXIEfCtGnzr7ioU+WjOfZY0BBDReD3pA==", "9c756113-b806-4d7e-aa94-18020ddd72db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e7e88e4-3617-4caa-837b-32835160391b", "AQAAAAIAAYagAAAAECEt3OHqn2VB3Y3s3nnHRT5MX5oliaohu20+QYoTKjEnE5+RDbTUtHmgxp+uMW+SnA==", "0bfd9c9b-3de0-4829-b02f-cea9b25a66c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8754a4bd-098c-4c86-8c0b-3026e86ed323", "AQAAAAIAAYagAAAAENh3Ep5a+DZDz/cXmX5Je1i5lC4gSlyP3jcCq74+KSZ8/FYQ7JTgFmSMyow8sokg7Q==", "df269767-9cd9-4fc3-9ba2-dde8f1e2aa62" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "515ac414-86ae-423a-97c8-61bdc9da5d25", "AQAAAAIAAYagAAAAENZKrzRbEFsPRpQWBLg1Z25W4V/BJyRoV/hjA86swSVirBKwcfEUDPjxZIdYgNfXlA==", "5d4d8d53-dd0b-405e-89d7-aab854ff7507" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6bec46d7-1415-4165-a322-cfa7e387d494", "AQAAAAIAAYagAAAAEGrFOfUm4EgzarNr/uGM5Pq3V4akEuImpPWI8RVutuzE2M4ILVGl0ncVnejBmyYSOQ==", "8166e5c6-4c6f-47ec-b02c-41e24f61a4f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3fd07b91-65e4-49a0-a20f-c7e190cef144", "AQAAAAIAAYagAAAAELIkU81zIpK4rujHDt6v1jvSCThJD7o11D/VDe3fmav7JuZh4UnOO3FoKYF8DF9EuQ==", "c6a9808a-4ed9-4bfa-9f58-90be076f1e7a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9bbf68a-0878-42da-8344-9048fbe425c2", "AQAAAAIAAYagAAAAEMStgT7JEj+nAXGP0wUB212YHhmG236yqt4cCsZRPa0tdA9Y6sn2P9GNprB/BQNOUA==", "de8567f9-b822-425c-a039-0e5d1ee6aafb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61f70cce-ea48-4411-bc26-7019d6fb04b6", "AQAAAAIAAYagAAAAEGUdioZIupJyiqMoeqrO7LNcQEMoIWruIQ55MO196f/FBdoVSaxbRvmXQKoMkR0/UA==", "02f9eeae-2675-4b4a-8f4e-2d9c0b22ff52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7c5102b-3bed-4f3f-8ed4-4ed0c82de39f", "AQAAAAIAAYagAAAAEMC7qCxlOltUOin0t7EK/GxmEOihFNx+iNELXJ3HxuiohW+cdE6F2MK+qX5eRi7zug==", "87fd247a-e046-4217-bdd7-be1ef445d811" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b241810-eb3c-4a04-9f3d-e4f5e2bad9d2", "AQAAAAIAAYagAAAAEEGsFSyarwSn1dMU3YAWwu5Yny7PpfcOBq/w5mvmf8XwAuiJ4pBSDndvWgpSNsg8pQ==", "e26c15fd-13eb-4e18-8b4a-46e16eb60c39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86a9d3fc-3d08-4516-bc38-4da17fdb028d", "AQAAAAIAAYagAAAAEBUhRcoffpDy8Hl0/JsUBZ3wOmwIrwwm6fQuB8zNUTrTHxRQQ1uty1Jtz08PkjvdCA==", "1bc3679c-c7ec-42e1-9bb6-ec74f3dd0ddd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d812e990-0751-4843-9e69-8f3dc7c7cb65", "AQAAAAIAAYagAAAAEBprej7txhzyPTx0g+SzmKSY6+FEz9vaBlOLbjq/mh37y+Q7efA+t0SkPqbjCKPbAQ==", "d4497a44-a45d-402d-a2b7-d640b431f9bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4071e671-7cd5-4ba5-9f2a-dc961f3eb284", "AQAAAAIAAYagAAAAEI1mF/568QeUz4ZgoqekTFTXiNXF+fcFlOBPtgnL2XfrkUbujDuq2n4SFAcMecao0g==", "36d02798-d39f-455b-aa59-0be719c2f183" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6072e21b-305e-424f-85bb-a862d3e16845", "AQAAAAIAAYagAAAAEHhA6DF6jyneUZsl31/pEA0zFuihwyBztl3bmI1WRAvf3zYOthmA/EVyBUM6HZAFkQ==", "75413cc1-c90a-4779-a688-bda5b210f5e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0939414-7957-4e91-a663-3ff1eaa002a2", "AQAAAAIAAYagAAAAEFf9zWFzrAFzWwQ3AV0FVgpfTVgT9xcIYKcMW107KxevnYVvGG1ueCaQxanCm0Y+oQ==", "2bb30831-b0f4-4e39-a4e1-c990b9018917" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9cfdb354-c881-411e-93f2-6585db8c0b63", "AQAAAAIAAYagAAAAEHWu90jyGX7MZcdkrfC/nEOz1UgM4Wt9l28fR9rJdUeBomS8WnVKWqN1EMa6JYf4Zw==", "5c9c5016-1d59-41f3-9847-085d73e06868" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8e74749-9d1c-49ac-bfa8-e78f6341a0df", "AQAAAAIAAYagAAAAEI9Ay31GvC5iVbswPJm8ywDm/at6zFekx7oRi96Z3fdWCcl+SKlg9sZuu7jD4nVogw==", "6b4cc21c-83f3-4763-8190-9f9344cd1405" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97bee046-e596-4810-a330-14b7833e9245", "AQAAAAIAAYagAAAAEJK/uhNK9tfp1eUOF3HZBzf7S69mIsolZEDjebrY67OqgKeLqBA8OHNWvph0fcxpKQ==", "e7967e7e-d616-40b0-b7a0-80b22d241b5d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5cd0f9d-d2ea-4d8c-80ab-aa403cfdf1e2", "AQAAAAIAAYagAAAAEIlJi8+nTXsSdQZQzE5p6dDV93faBwayK2ppk02Q6jRSsvzDai87X+P6F3ZaT/8L0A==", "fb7c1c73-e83d-4448-b8e7-868d68a137ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84491fef-733a-4d43-9b12-e4ddad199923", "AQAAAAIAAYagAAAAEG4828AN7KYFnrEIfm/PDA9laWjwIK3Zf56JnclodtzcDOnRHL/iEUThWqsG7ncn1Q==", "7af3a8b8-3567-4f8c-8112-1d1fa0de43ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dcf49fe2-5dc4-4a7e-9f69-3a2fccdb8209", "AQAAAAIAAYagAAAAEPBnPhNES5nElPBHVZoJtmSxGagnGP9Frn1Ecgz8RStB4KQw1iB+jUxGHtaoolQvxw==", "e0c1a804-4c8e-45f3-9f08-ce6e22e50f2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4627ec3f-b95e-4c35-aab9-5a03ad52b3a0", "AQAAAAIAAYagAAAAEF419N4imd8ymB/R40MXc/p92PQRni/wMsDi3e19lH1FpuTj4kdnq3AEtZJmVlipKQ==", "cd218ec8-7fb5-4eb5-b22b-12b5cfdb8595" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20e6c6b0-8d91-42e4-a287-be95ee897e1d", "AQAAAAIAAYagAAAAEKbHUdJWWJd9d77S44M7gTSygyxM1HgPKF1XLM84/xvgumJ8glge2k4dxj0yeDgyGw==", "9fb45d9f-6b1a-4d37-ae1f-a530e3eac1cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "233fd2fe-d104-41d9-8674-5436565914d1", "AQAAAAIAAYagAAAAEGazmtAUEP+ORHcZcSeqVOXl2AIkdw+T4buXE3VSinKddxoP9qjTLLOFBvAz6F5vrQ==", "32b616ee-7e4a-4dd9-898a-a67bb41d0110" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "416eacdb-3b9c-466c-a008-b8eb65678166", "AQAAAAIAAYagAAAAEPlJEPDe0Nz0tVnC9iRpPD3TS21z/N9rJoIs5zVq/3g25jGMhdu+MFieOmnN0JgLRw==", "3c9d5428-421f-4ebb-af3e-71937408d8a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2a51f03-9084-4d6e-9015-60251e3c9d7d", "AQAAAAIAAYagAAAAELcFylpFX0K5liOUb7WVnaub/olvUeMFj6AY6QPPRd+ztTDd44n5G605fy3eRbrWNw==", "ad61156a-6108-45fc-b66f-47f8ea0d38cb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "503d19c3-51fd-4239-8259-1a2fc119cd44", "AQAAAAIAAYagAAAAEBf1v7jmlx1b0LzHtUjeakQS/GgCpVt9Al8hpt6U1yMlm/2a6fsAIJuD1MIAYQZGyw==", "c5ddc063-77a2-4204-869e-629764c7766d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9cd63570-1f39-48ac-b70a-b22fce5b7aa3", "AQAAAAIAAYagAAAAELFG/7dZdu/9SOeygb/yS7UruAmcaYPYlUBh3Wzyg+Hmyhvwoat8cLHaeKfryU4YFQ==", "e1b34fec-c9a4-4952-90a3-39d063b82bc9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1ef859c0-5015-42cf-b16d-a522bf89a84f", "AQAAAAIAAYagAAAAELxQBoyzxYTdr+SaYCfsDIe5dZRJqAyuYzFN86ehzhlAPHTfiRhVYPXAYIqbmQ8vrw==", "879a13cb-536c-48e5-ad46-5a7a2ad65299" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a9dbdd7-2c46-4031-b2a9-502b3501f78b", "AQAAAAIAAYagAAAAEGKa4W4MONtczr45nDOnRKXhRiBSiC+nt5krd1gQb30PW1Z2UW9tv6L8cbi04G/BPA==", "4f2f63ca-fab0-4bb5-b199-f0917addc49c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f814a4a-9e5d-43f8-9989-d8e379c0e8d4", "AQAAAAIAAYagAAAAEPZLEEcPfmF+hk6GGK+KpjhOFl/cRXO81AabQmJ9XbOrBYQN8SPZIimMA70QbMhBUA==", "79dc46ba-df46-46a3-a5c1-efae5bfda894" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1848619d-2804-4e4c-babc-78b76e0b88f1", "AQAAAAIAAYagAAAAENaVucvhwJmGcLeTBrnT2ogqNrkFtQlc+8knoRTDFdDVxir0p1zisMknVPmaA+wwoA==", "3001fa97-8f11-4e08-9383-0d027033593a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2a59f6f-867c-49c9-8f09-893f769234c7", "AQAAAAIAAYagAAAAEAvtwe0+AWFCcx3G5R6AS6s0BixLuYWk794Cga3UXMYcibrK4clv6HIfaxlMzTO26g==", "62108c6d-e8b7-4de6-be8a-766f303b1d0e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5dba8995-46fb-4e9c-ba41-93870669dffd", "AQAAAAIAAYagAAAAELY6/nOOzIHnAe5kyo0OPRHcG3+y/wP4mTwhU9s7hflN8R46RAGZnH+DseKB8jRdnA==", "559c5562-969b-47e9-9af6-58d68ed149c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb8b4b9e-65e1-4768-9b56-4a9d874f23bf", "AQAAAAIAAYagAAAAEJNdMqL2v8X7taczzXxTxQb/ep7o0VluQ3pxYHyTiQKOyKuvTNePoDyXpl6FZftI7g==", "1493b846-7451-4c63-922f-b3fe0b6da2b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f346e46-3b02-4f5f-ab24-96c65895bb5f", "AQAAAAIAAYagAAAAEI2IKaVOw/8HpCT86+YOKFrWBYjdFjCV2Q6UReFjvLiFog6VTrxpO1RsfnVzvDhvpg==", "6d2fa742-26b1-4539-8a6e-f92e50f98d89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47c72344-2d22-4b9c-a03b-da6b5be556fd", "AQAAAAIAAYagAAAAEIhwBemSbCBFomJx43f+/zIciT/gv7YDZPMaIvo1195E+rY0DS0eQC8F9P0vYm7NxQ==", "6a1b481d-38c7-4c5f-a81f-7c8a3d37700c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1aa6a04e-15c3-4c32-bb48-0d60dd279bb4", "AQAAAAIAAYagAAAAEB/YWexCACNJUwGwwxA7VrNqMtYdDXGsWUfK8831s2kH9aMpvEI4cTf8OZEOasgexw==", "dff13536-1fda-4838-8039-2bbf1383c5eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77283d0a-b7d7-4cc9-8eaa-7560974d0dab", "AQAAAAIAAYagAAAAEA1/bvClJMn5VNvro5FNT30GQlnldKA8TLJee5ZwkiFgT8iVsV9qYEEXqvrJuasAeA==", "aea95a5f-d3e7-4d92-8179-0f77cec75fbf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4aea2ee8-edd3-4852-80ec-70093b2b4265", "AQAAAAIAAYagAAAAEDDs/kTFYmtTpsHnmBefNAlLKjkNfqaULUZnlxN98mI2yQCtlpvWd3/2d8hmNhkveA==", "89b5b19f-716e-418d-9ab3-da0388997bd7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "034230f7-882d-40f7-ad18-d53a710afc66", "AQAAAAIAAYagAAAAEI2jh42wN5ook2zDbpzIBntCzHOsSr1Egs0uo5u+o5xLtMLpiaOF9sJQ+LL5JxAQ0A==", "8e29a72f-4679-4577-a639-9969e4134da9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6db2a930-9542-485b-8938-d799d415091d", "AQAAAAIAAYagAAAAEMmGALHhCpTXmRZTmg8qgafKbPBM+dqKZhzzIsqJfyyVeud2PINl3NxLRlHh/mAhYw==", "1edfc37b-f3d9-4555-8762-1e18404e0964" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35e32d16-4610-4cc8-9938-25678df49e20", "AQAAAAIAAYagAAAAEG91or9KOxfCi4WR63rB2K+weZfC+4vta8Lpwlvyn9tnkEAvEQrBOG/vZs8TgLw8rg==", "9bd5b700-cc0c-47c2-b184-d9579ec75997" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "786fc21b-d916-4218-9c27-d58ba8ff3406", "AQAAAAIAAYagAAAAEH5ORcKuxbMuzmYbJixg23jkuurKm5teLOgnoQtDhTNm3R8kEaPEbCo1TZHvTBj+5Q==", "0682122b-43c6-490d-a869-c6e547723e5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3131143f-159d-499d-a0a6-93bd7d897374", "AQAAAAIAAYagAAAAEEdkcE8mN0TVNxWTqM1+Ii6VZex//7E+u3Bf1a7pqGlAUTC/HVox7JAZ97O8l7fUOw==", "555188d5-598b-4288-8c8e-13febb33d542" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d81cd509-ada8-49c5-8829-385cbb3b1739", "AQAAAAIAAYagAAAAEAF5+HsWOgscSJpNq8bJk18zh2Bl/ZOqT00i4i9id4/RuXfJ4H0PAsTTkSG0OtLxmg==", "4d547f3f-5983-48f0-b936-feadbf1fca2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe0b7e9e-a791-45d4-9ab8-2b1ac345aab9", "AQAAAAIAAYagAAAAEB18QcR8fuWBO390YcNliP44H1bbRwx0BpilPDtRF9kvnMa6cNniKwEx9ayDYQGlJQ==", "f850d664-1b98-427c-a04b-095293206046" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1dc52c8a-9c5b-4e4b-b0d5-5814944bc0ae", "AQAAAAIAAYagAAAAEPCpDLEsTVfiSyXxlfzNkMjNtRErNsIPMfZG6ujhFG+/2fJu+IgAcsWOqX0lZvd+Xw==", "4e78418a-0674-4c2a-be9e-84b6e20c4b35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c36f627c-424b-42dd-af85-a11ba8fc3db9", "AQAAAAIAAYagAAAAEBjWzoiM2sE9nuPNNJh7p5qH1EC1nXZCJqhFRPV3mqelIa7pnOiDsFAZQlfwrvMe7w==", "6a492275-0aec-4f1d-ad3d-a376296791e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f19bdc7-881e-443c-ade7-fa09b147a34a", "AQAAAAIAAYagAAAAEL5DHw76KVVCN1GfqtcRr4GUiWcJHb5gaPXM+XaoH5A59mQ+Uum5DsicSAXegi8Odw==", "45d8a34e-4354-4e44-b9a5-0bfc9697db64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "699e8f80-58dc-479c-8e2c-2fc8783e01ed", "AQAAAAIAAYagAAAAEOk/n7IU3pNhXB2aWXnqKff6gKTSnHMAqG8qcawgS4qR7jF/ufDGFawJwKSZO2qZiQ==", "d6a83a0c-630c-4a58-9fca-21e0918348c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe824eda-8e29-435f-9dbf-3b79de109e7f", "AQAAAAIAAYagAAAAEFCNE3gzaXq/beVIG0bZNNofdrqZGFkWiece96LquxVyE8or2vlrwYC+OVMpn0jXDA==", "e3efce26-e312-4217-9e22-9079eb4f50ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "888b481f-8106-45cb-a349-e64371ba61af", "AQAAAAIAAYagAAAAEI7h8zAQQ9Ux35A/MSuML2aS7nKP2KJE7/tgag6eZxyR8iqeh3BQZ+M79J3pMTYJxg==", "a27578e7-270c-4d92-837c-05c0b10bafc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54ab8c49-4f6b-4a20-a96c-e601892dba37", "AQAAAAIAAYagAAAAENblAktEhx2H/AdPR4Qp6z9GMhrdV/MaQWbvKjBcrgsOS4URNsEDxejDky11dkuVFw==", "f09dbfa9-4ec9-4149-9f66-60525ba390ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b25de5cd-0679-4d98-bff2-9d61eda0eb47", "AQAAAAIAAYagAAAAEKfvbLtXlTDbD4+z1o1Z4PiiKF+ISKE54NPc9upeWe9MEb3+T2F93qWAEh9Ir514tA==", "47fd8067-b02f-4f8f-a258-2ff3b0c8862b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c9ca0a6-59fc-43f3-b6c7-3df8f054a947", "AQAAAAIAAYagAAAAECqjoE9CQ4mu0mVQFdIGoNSMOOwgj9MJzp31Qfz51rzUtKGlfHHJNklbm+9uJItyHA==", "341e9f3e-1f91-4107-8755-58d8d9d81f64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0eb46238-f0aa-4adc-b3e0-888a6ff04eed", "AQAAAAIAAYagAAAAELL5iNI/QOP1QN7djqkf3+2eDMkYn/op+EIO5OPIz8I6dojxnlY4bGSBlPMxJM+iFg==", "83ce2771-6583-4dc3-8791-753c9961e641" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "37a456af-9da2-46fb-8050-9969d758cd55", "AQAAAAIAAYagAAAAENhJARnt/TU3PIGIHZQZIwg0dm+JWbl9zoXJW+YeMYBbc1ZgsgC7L7s15tE9D656eg==", "b36609b0-2867-4f68-b99c-498cdcfe0798" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e2c17ca-0473-47a3-90d2-9631c9854670", "AQAAAAIAAYagAAAAEHNxxN1+GwkPMrRe7/ZIaaJVqwXX11j8/WyLS/1u512diREqDGKKWvPI9DbjzV+CSw==", "8234c908-9c9b-4264-a7d7-630aa44a19b6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dda0483c-e6da-487e-a038-0500236a728d", "AQAAAAIAAYagAAAAEKKoGOA8QUsPFyoFPHiX3HpbRwE1FIpVIzvtDqwy3B7eOuCuOa6b6MPWFxtzONKe4A==", "bc96005a-94d9-461c-ba03-5d17964d14fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "128738d3-339e-4337-8148-e5f39c7daf88", "AQAAAAIAAYagAAAAEHsIlVYXRwciaW1JdvbZrgpIVxyNEz1ZQTKb4YbmyhUqbYjtQe4HGxd93dA1spHJcQ==", "d1e43763-8fa1-483d-8a6c-3875f0a955fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7c0b9e4-0fdf-482d-b829-43547a2e4e1d", "AQAAAAIAAYagAAAAEOZHv1y9wBHuAFNLlJeBAJue4qwec5w5lV3coic1wwxfhohDaM6n96mti0dGOPdvig==", "8a81ede4-0407-42f7-82d8-604eb51862d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54f94b0c-be58-4919-aa88-de44daa40219", "AQAAAAIAAYagAAAAELXspWl+iMDmR9pXLdjsJy71Mv/IFzVPPW/ODhddZPngHK7Iwwfn44LHPgFYgX11pw==", "24edd6af-397d-45fa-addb-e4a1cdfd3efe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09177ca1-6136-4416-adae-127af0089004", "AQAAAAIAAYagAAAAENXxHk/PK1IhyMEED+SKS81871+lyqkEs02S4wAO+jXBMzVKhdTUIn4USPVWRpSK0A==", "38a21a94-7283-4a35-b5d9-b944e2f6b563" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "303d9eec-9ab2-459f-9e8c-9f8c6f1d3501", "AQAAAAIAAYagAAAAEGsfwFV7STt0indk4MEqS5AWaVv7xCwvpAa145N/Ok1KfjyvavDfWcjiQjUb2puGDw==", "03d8d81a-7796-4af2-ba50-7c66a411c4e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "378147e7-61f6-48ef-927d-0cd89fcbe6a2", "AQAAAAIAAYagAAAAED6fdEV7+lj1273zBcDQVYb47BM+UXK70Si/rv3/pNdPIFIH1vsLasM9hZNVEak9fg==", "41fa6a31-6a33-4380-a1e6-03288403165e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15a89c3a-409b-4af6-804d-c293595be6b7", "AQAAAAIAAYagAAAAEM17KG/iI9BsxozyrB4dj0TyDYj4AKwVjdvdPA6l2xvdmdDyhXkaxxvz7yrIsR3DqQ==", "7780a1e9-3e63-49ff-b1b9-5505f41d0c09" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ba787fc-22ae-4877-b5e2-777dc0710635", "AQAAAAIAAYagAAAAEMR90xjAhH9ts9fui/4PnHFF5ZnOW4TubLC9BxV3uTyL8qXBdb6nUFmLo2fxgjEf4Q==", "0ef557a3-6ac4-4622-89ad-4077bd3f2c80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d797f9a7-9a92-4788-8b58-61f86b1721bc", "AQAAAAIAAYagAAAAEE141F8/HGJtSlaaQs03gUZEFlhkSGTaZggVMZFjh757SsibONz4RNLnIUqbnKPhFA==", "fda8b45e-768e-4d2a-a7c6-43f9d73ddcaa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60908c84-9cf5-4310-a58b-4a11518d105a", "AQAAAAIAAYagAAAAEGsAx8+OXV9QQJH1dlFtMUfKVspTcZfSvyMXcfsKt7nPYVE41EvjX12Rstuf9rY9+Q==", "2aa72f79-7d2e-4c05-af54-9a3cf1af3773" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28d87a31-07de-43e6-95fc-79b05f639eb4", "AQAAAAIAAYagAAAAEC0H5CD6+Vf5qBpyhAEpAjQaDqgNq9PSXTwE5Z6rvIMGYknw5ClqtKgP3hHnR7LmUw==", "8f52b55e-2508-4fb6-9ca3-ad10288e5a51" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "546cf476-ceea-46b7-910b-6e4ddaf26f2c", "AQAAAAIAAYagAAAAEKMuK2dJ8NiEpCYFWDq8dHlQfokZfN3GEEmfHXDXDNmZl2JCl+WUsAfT0wmDxT6bNg==", "f3487e19-93aa-49e6-b33c-6de21d6f905c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8d7cbca4-1635-43a1-b075-b9d53948817c", "AQAAAAIAAYagAAAAEPrtoGkA+rO2NXGK3RaU6EN3hUCiNC/dV/Msw8Ait4NcBHKsRrNLp0ILhIBxX+yLig==", "bab56f00-d7e7-411f-87c6-bd27433993da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70bdae10-6163-4561-974e-62796d82490a", "AQAAAAIAAYagAAAAEHcfz6EIgxYIb3Mzfy+YkqICcCRC9RPGvsuTFYGWERpGjt6oOXUmAetEUZjDrROKBg==", "6eab70e4-19f2-4195-bfea-13a5d5c6e793" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb2685e9-779d-4799-9313-1e7ea5149ccd", "AQAAAAIAAYagAAAAEC2zJhf0p25KDMF4SwX2ARof3VmFyu030Xh+oxXWWHxyNlaNsafn4kBpg2EwYQ7XrQ==", "e7c48e67-7508-4190-8a44-8dbb21e65fcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72191845-75f5-491c-a529-d14ef980924b", "AQAAAAIAAYagAAAAENmfjzI6LYxnyMP9wcWiTlyV4qVfYTnxVX7PlBiVAcEBCXqZdjTkA416taQMtmOXgQ==", "e5191421-e3f2-4a28-9bca-d50f5a7c79d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a868ad7e-31e8-4f3c-8097-0260dd1469f9", "AQAAAAIAAYagAAAAEIWfdY0ye9Qj/tPa02xQfvXXm8aPspH9qq3FsKkDVYLYD4hvBiJIGX1RKHOsLN8K3A==", "1397fc99-afb9-49d3-b121-96a12813fbd8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21c61908-ffa5-4d8a-a7c1-635cd5c79f3b", "AQAAAAIAAYagAAAAEE7koYdLQm6jMwUWcTqZuQofXlthkQ15FXzJTSgZqluYtJJEaWeeaXCvgpA1ZV13tA==", "1206f387-70b8-44e1-a6bc-5f4c3d0d0820" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e28d1fb6-e587-4b7a-a3cc-fcfaea860601", "AQAAAAIAAYagAAAAEKZ/s8cmu1tEo3WQB1qxWiNMAM/tZE/FqeRDp3LA3NPkxQUWBV0+ZBjNgNnH5v7f6g==", "86f42fd5-c793-41cc-8357-716b2088e880" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f088bda-aaab-4f96-9ce9-deffd2da7da0", "AQAAAAIAAYagAAAAEJAUlIpbdU8DhKuCuvusnaYcR8qwfpH8L7Mj+TrTdZ3M8BFIgsXP2FvA8BZHcGT2ug==", "0059b1e1-7469-4313-9630-650768216985" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5a2d5536-3765-4484-baa9-1b5b96295b63", "AQAAAAIAAYagAAAAENjiAt+DbB4KB0JJRpkzbXnrxWRn0DbRPbvyYv9QQz+WOVA9bF3qdle5RCbgYYoUgQ==", "07eb4d20-aa2b-4f90-aff7-6ff64b5489e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00bc857d-b112-4511-bfc8-3cd0478b1183", "AQAAAAIAAYagAAAAEEDMziaD8vjemSxsAx3oZ4lSz2x65N9/00ycIxmIv7zRKPwD0EY9ftDulXdLjVmEMQ==", "f0b3e976-6877-42aa-a6a3-670a4812a725" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca736280-e98c-46b9-af68-39a4184568d7", "AQAAAAIAAYagAAAAEGBWIetB+g02E7phkpyUI3wdB5BDalOrJQx6YtITKjXhxTvcX/nCPCz5QwiS/1HiMg==", "811a9975-6116-48dd-8a2b-a4d6bddd5838" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1373755-23ec-47ba-858e-e95c64e92c78", "AQAAAAIAAYagAAAAEHdFMDE3rxvJe/vxWtT/29K69KiwBC1dycIZ6WQPO60fD/SyTnWDF2x6f4u1E4PEqw==", "3573f636-cc07-460b-b914-9095d7fe2f50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "80cc8426-dcc4-4400-bd15-7e433c01b687", "AQAAAAIAAYagAAAAEGHBLq7nLXWj781Jk39DRmkAvRqGhCVG+qxzF2wDE8oPfokOjVmczJ4vvHiWd3ATpA==", "4fb92728-9fb8-4175-acdf-533c81d79f94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ad3b728-4706-4bc6-be5a-b9e4e7dec44f", "AQAAAAIAAYagAAAAEFVqvoWEgsNafZQpIoILHp0It4hCLF+W/Rq+JduYxdUoQ2ybeLFubXMYX/Mvx2WAVw==", "00feb30c-9a29-4a65-94cc-497e309e55a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "413477a7-6c23-4621-8cda-93565d74fd4b", "AQAAAAIAAYagAAAAELobCnQx2R2lEaad4Zyz1Qs73dChfeQJNLA4c5I1EndIzL9FXjN9Umy183UXQuIuRA==", "9bb8f696-8e17-4f06-b489-115260d3b29e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f01e8d3-dd13-4e6b-8474-8c3def21b398", "AQAAAAIAAYagAAAAEHkX6iiWgNEq/LyJjj9D464qDK4/GAw7JZL29WWnSLi/BhlzgKQlEtNKqdN331E0ow==", "754dadd0-8abf-41f2-b33d-8c1509e62e9d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "663a20ff-f27d-4eb2-89e7-1dbe15dc4b0a", "AQAAAAIAAYagAAAAEOBVPcnA6IA1HXVwPzH/GE/9MbbxLNZuI3tixlN8h5OKbh1WnHf4RMKEr8SZxay8bQ==", "7ae93d7c-b7a5-4f12-a873-b916cf00330b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50257f98-779f-4050-8587-98f7ddf66bd6", "AQAAAAIAAYagAAAAEIB1QmXjU/4RsbFjAvK52wlZp7yam46p/h2cSSBfT0baCaKiOz4bQq90TYYX5rjnIQ==", "1b11af8a-36c5-4d29-8f9f-e5127ee2582a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7441989c-f039-428c-b71b-51967a5aa935", "AQAAAAIAAYagAAAAEJnjej20Guuwi2RRJHx1l7T9qP8GscRyJLQh0hqd0GES5niPmcb74TrQJ79f4Lf8tg==", "3f0d83a8-ab2d-47ba-ba16-ad66b7c14033" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6d5fb38-5c1d-40e5-84a9-982f94d351aa", "AQAAAAIAAYagAAAAEBGmO6a4ydMA0Ap5q3apea8megW4W5Do88OeLay8Qxq1pNphtf7am0WPtQ/kT6xFtA==", "1dbd5944-2add-4455-a886-9f61c35610cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77672e90-f3ff-4a9a-8be0-d85045947c67", "AQAAAAIAAYagAAAAEAu9SzcSV7t173chGPRFaCFexHOFUUtE6RAtQq2LZ/9kFLMBvvh7ZxjL1MDQl1OJ+g==", "2282a8f1-66d6-47d8-b45b-9904e355e412" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ab0e3a3-bbdb-4395-9bf1-a8b6847caff7", "AQAAAAIAAYagAAAAEA0kMPaahCZFWXZSNFwQ7afhbDhC/mcxuUUOxnY0KyjaTcSPBWV6SlimSlf6Bi8P4w==", "d2cc8554-c6aa-4655-921d-ddd60c780600" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c5391d9-444f-4f77-a888-d05041f987b4", "AQAAAAIAAYagAAAAEAH4MbhhVeQjedEyT2DerkkP9Wx0cOWxCe5NsGdy4dMzdEaUi2MUxttpGiBEMUNkCw==", "de13e068-5f4e-44b3-ab30-4caad27f2630" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17070ac3-a93e-4b6a-b6f5-6e51c5ecfb59", "AQAAAAIAAYagAAAAEDCQTpAt4vZIMAK4CoCm8d1Xf94HPX84NkguUVu21t8fnWcH/TgEvlEWTcUk90qrgw==", "f44248b9-d186-40fb-9cfe-6cae5add1a21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce344adc-ed30-41f3-ab27-789310bad980", "AQAAAAIAAYagAAAAEMQQbhZ3RPo0SBpKbYtRmtaSmE/RAoKnBEbUVicmfDKVORmfGl5RCrNITofxKBj0hw==", "ba5524ef-60bd-4c6d-85d4-a1b573569e2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7199020a-52c3-4e49-bff5-552fd900735c", "AQAAAAIAAYagAAAAEPaekAwyWo7eFh+EwBy2DPNrOOmLe/k22Kbu9wmbVnvBTqWYRMRIjhr+jpInDiQYkg==", "baacdf9d-d00e-4c8d-92c9-5b42b29f2c4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75bde78c-a072-42ba-87dd-1046f7c501ae", "AQAAAAIAAYagAAAAEKp/A+tOnvHtFxPuWvJnVvyCeQl+FP45034v9dg/mJOpkvI2OGoNKFLk8dmFRfYJ5g==", "2a592536-732c-49f8-9a93-8f0f7170c1a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9fa2dd77-a622-4e99-bf0f-5996a8521a0c", "AQAAAAIAAYagAAAAEOuLZqEWpLxoeZa23GvsyMdGOhcVEPx+iPMxJ3OErU9Kk/whOKu8pJk53xYrX0rDeQ==", "b5af7cfd-12de-4d5a-86cf-79af1f6c0f63" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "85cb4f79-e72c-4606-b9ea-3b5cfab210f7", "AQAAAAIAAYagAAAAEDf57Yek1jxr0hYKBstKOJ6GKVfneeSaO4bF4WIIzn5FqPcp1JkG9eEQqoJIyj4Tdw==", "54382f3c-fa24-4b41-a564-33f43e5cc7c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3b1124d-75ac-4bb3-a847-930786b692cc", "AQAAAAIAAYagAAAAENFukdVdPDVg2/0TmSuT7u4ir5Qi3UTibZG7bjCjHEAmtn6A5/LHjybVC4aTJluYiw==", "96657d9d-1b65-4ce1-a3e7-2f138c1dd98c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60bc74f4-56cb-4428-8739-a9ea57d571f6", "AQAAAAIAAYagAAAAEHn6itizBFUEXc6QjU+AclXN3D9/ytf/z+L7W+bgElHZtXgsN7zLGD8LC23+ENu6nQ==", "7d78a3a0-a18a-45a9-ab65-387c74289384" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d909d409-e2ab-45d5-b581-8df9b8276b62", "AQAAAAIAAYagAAAAEPCvmMBt+N8xsPoaQIU4BHhztSYv25vQLlMr6+Unc5pEgmVY4Q1KkkiJ/5tZ1eHPJg==", "0a855ebd-8f71-4ed0-8c9d-766e755fa2a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c731198-7fb4-4f93-b561-e1ec6bb4ef44", "AQAAAAIAAYagAAAAEEsJDD/KQKTchh0RPCBkUYfI2zkEz6t+1aZfGKW1o8horqXPWWbOVsMeK18nwnJyUQ==", "6313b63e-aafe-41ab-948d-7692c3ada6a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bde4ef13-8371-4605-bb4d-907d27dbb23b", "AQAAAAIAAYagAAAAEFnP9BoDTuFyi1vjCSJcTW1jg+MBnHh183jU0L69wYYBKgoJ52ESqt5jV/Z6drq5GQ==", "8d264f37-c6c6-4bd6-a1f8-738ae98f3f1f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "316a514e-8a25-4786-b076-f4db335bbd19", "AQAAAAIAAYagAAAAEEL4JEfarXoAfw2xF+EfFtrmkIevY04XgTsCR7t3EJXbBsfnO3wxiBkN53sPnbV9FA==", "089fdc9c-841d-43ba-a766-7214b380bffe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cbf6e4d6-099b-42f6-88f3-73eba50a99de", "AQAAAAIAAYagAAAAEJkujZESJKTUqAcy/ENbG8/QPiFAr21qH1KkXv+opsCP1PjHAh+ipvRKCWPiVva/QA==", "f82d0ec0-efde-4f1c-bd8a-116a85741984" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7e12c406-79ab-43d4-9176-23320292ef0e", "AQAAAAIAAYagAAAAEMy7tou36Th943fAYv1XFxL+otz453/9QCxXjqEEPezGz6UmVhYTrNJcv4AXL13bqA==", "00019978-0642-4c84-bde6-61389b1c3afd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7fb2455-5d08-4fdc-8fd9-504ebfa041de", "AQAAAAIAAYagAAAAEJ0ffaOhhWa/Sasr1QZSIpIdwssXuSN4siado5qDoIlsxsEC/lTzGTIJC1rDljseHw==", "e3c9b4fa-a749-4f7e-88c5-f1c6183d0e78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "658fe3bc-caaa-49f2-a94b-e3a3615daaba", "AQAAAAIAAYagAAAAEJx3P1oCbNVq1C+01rPcNdI3sNXx0oOpueeR4OpIHdss8AEIeQ5D6NM6uDSCkFPehA==", "5b730672-f9b4-426f-a9d7-b91557fe9cbd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ccf05957-a8cc-41e8-825c-bae62a332117", "AQAAAAIAAYagAAAAECkSgpQjR9IIfaI/L2rK8acYraw6+TbOhM3Kk4BjMMgXLmkLfLxrOwXtojk+p7fx7Q==", "d0fa0ff3-9201-4f81-8ac4-2fe25c2d7759" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72dafaeb-441f-4868-83ce-060937d94ce6", "AQAAAAIAAYagAAAAELpI+CQsdjEUG9X0DLGA8H9fEF3dfRFSWs9oj3veBf8AGkYWvMtbUOLmHmExfW6Zzw==", "57abf412-649d-4fc1-bf75-d3d99d9e8abc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae0ff402-f1ad-4784-afc4-ac1b777dcc98", "AQAAAAIAAYagAAAAENg8akv8/sGkNl4GyWM+XAsoAKvDp6v3E25VpYxQpjMSnFiAubcKDZ6Aj8RiPuk13g==", "d349ff55-bac4-4d5c-a54b-569917601b0f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c668ce5e-496f-4f8c-88ec-a7cc9993346e", "AQAAAAIAAYagAAAAEGTpQrOxXbS5E/ysJm9LeRDAFhfjS3RX2EvogoTyak35cQo9T+yPqe9zcZYD5aTicQ==", "adf53057-7ee2-46af-acd8-9c70d07c5e25" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "157cf203-658e-42f6-8c6b-02027dace930", "AQAAAAIAAYagAAAAEIY0gLu5gGzK/TP0h3zNeodoYUa8LSuHtG0ncKTqqZqEWisBq8cgZjgMWO2S9OvHrA==", "f421e078-a3c2-40c0-b503-fca65a2f1ca6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a3481c7-cc50-45ae-ac66-8cb9670cb1f3", "AQAAAAIAAYagAAAAEADdTyRJkIZGXTNxbRnP9g9sQ+1PNxcGg3Y/9WlnkgaQC8RxrB9jDBWvDvLRgi0k+g==", "f61795c9-abda-4f92-878e-8919649a3d2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ef9e5f1-54de-484a-b7ad-58c2900e32ad", "AQAAAAIAAYagAAAAECHbmFQDmCajVke0jPoHfI1WWyHHXEEl1l1bevf5ocJqez/TjWFy4J3frJIImUVtXA==", "bf60b284-6ab1-4c01-a1a3-9d2370bc7fb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4239b7a2-86fc-49bb-a61d-c0e6291f1e94", "AQAAAAIAAYagAAAAEEwqcy6eqT78xlqBfgSpucG4eUCnHb8O9cG/ZzUwuBIar2AcWTDD6pZp1fjsAmt5IA==", "e3892c07-b830-4509-ba66-c084d117c02d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22b5629a-a106-40f3-ad3a-c492f3b6e92d", "AQAAAAIAAYagAAAAEASfpvwphyxAJMdclh4eIEQyhH8lrwxDuOMJ/h0zd8cWj41UbqVIOwwAfucNCKxKVw==", "b738dd05-01bf-4738-9d78-984a05eaa70d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b6b6da4-f4a2-4700-95cd-ab6243ec469c", "AQAAAAIAAYagAAAAEGlbwNSr7OS+5V4kzo+CvGpdmGIQhKAA7FsFiCgaP11SbOAtr7hEs6mTwPFG3l340g==", "27af27b9-d722-472f-a12f-fadae5bb5b44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ec4744a-75b9-4fec-af4d-a6810d43b649", "AQAAAAIAAYagAAAAEADv/5NpEOBslhbLrdYsjxhi814ZE9psiL/KhRmitwwpdCgZmrCaqyjAXpf2uPcmuQ==", "36587be5-89ea-40c7-8893-080c402023a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b64200a8-2899-4dfa-b3b4-40e0d86154c4", "AQAAAAIAAYagAAAAEMJLJypaDo8b66hIyYpT0cF1Ax5SzYVkr8mGX219ndG0hFRn1Cws4JVKq4EF+LBRkg==", "9709fc52-9e56-46fb-8dab-cfe892d39d60" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf5ad598-1ebd-4593-9c24-3d485ee1972c", "AQAAAAIAAYagAAAAEHKzNkPRCxshCX7nX37PZmz9+ZAn3zQMrq57vkS08eRwC7WxM0LIPF2USiN6lVIpMw==", "5b3f85d4-6102-47a5-bc33-f3a2cc5447fd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "241089dc-5a37-4bf3-b278-c16c6746df27", "AQAAAAIAAYagAAAAEOSs4eNWWWSTq2zNUV5Qoyd0DTf9FeH0bbWOfm6VhIMybuZ0NcdPTYWwpojCD+mWhQ==", "e88fec2d-4aaa-449d-800d-100ea20c4340" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e04f0156-74d1-4eff-a10e-bba2209bd9c5", "AQAAAAIAAYagAAAAEHXtljJjs10m49s1LWvQjfnVPbDxuP3DsU5SWZdWOdrKg2NUd3xVizAo7fq6VUkVhw==", "084b08e5-b991-4a03-8b37-9c241f9061ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a46dcce5-cde3-4e3c-a26e-0c8443d8aab1", "AQAAAAIAAYagAAAAEA3iw4wQPZW7yQvm/kcyrgMv14jzVu0jIPNMeGPhAGwqd0VrAD9pmf6S97ICuTU1cw==", "e929242f-ab0c-455a-9971-0c8b8cf571a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a6b24ac-a46d-4e0c-b3e5-bf0e4a175cfd", "AQAAAAIAAYagAAAAEDHJAq3jtu0/GPKO6aCF3YVbMb21f9EyHe5utbNXQ2EU/9Bg+tT+9Q2PEOzwA053Vw==", "5a58d2eb-87ec-4acd-9ebd-20def67cb5d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da0df1c2-1bba-4ccb-87c2-fcb2765d4de5", "AQAAAAIAAYagAAAAEJt0Ib0J+HKjmV6pTykZiQ65xAYbKwC4TrjGb3yKPzIR8xkVxWFJ07z7f3ITLPJKAA==", "90e9f9a7-c2c6-44f0-b20e-9434c6c1767f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a4ced5b6-fdaf-4878-865f-20f3b018eca5", "AQAAAAIAAYagAAAAEGJVkBaM6MmsgPsyUkTfe+ahU/V897zAILC0Xvhf6TAGWwo2fqlR6rVxLgeSmx+EMQ==", "21703e60-c546-4248-b464-638030eb03e7" });

            migrationBuilder.InsertData(
                table: "IsoStandards",
                columns: new[] { "Id", "ClauseRef", "Description", "IsDeleted", "ParentID", "Particulars", "VersionID", "isActive" },
                values: new object[,]
                {
                    { 1L, "4", "Context of the organization", false, null, "", 1, true },
                    { 2L, "4.1", "Understanding the organization and its context", false, 1L, "The organization shall determine external and internal issues that are relevant to its purpose and its strategic direction and that affect its ability to achieve the intended result(s) of its quality management system. Issues can include positive and negative factors or conditions for consideration.", 1, true },
                    { 3L, "4.2", "Understanding the needs and expectations of interested parties", false, 1L, "Due to their effect or potential effect on the organization’s ability to consistently provide products and services that meet customer and applicable statutory and regulatory requirements, the organization shall determine: The organization shall monitor and review information about these interested parties and their relevant requirements.", 1, true },
                    { 4L, "4.2.a", "The interested parties that are relevant to the quality management system;", false, 6L, "", 1, true },
                    { 5L, "4.2.b", "The requirements of these interested parties that are relevant to the quality management system.", false, 6L, "", 1, true },
                    { 6L, "4.3", "Determining the scope of the quality management system", false, 1L, "The organization shall determine the boundaries and applicability of the quality management system to establish its scope.The organization shall apply all the requirements of this International Standard if they are applicable within the determined scope of its quality management system. The scope of the organization’s quality management system shall be available and be maintained as documented information. The scope shall state the types of products and services covered, and provide justification for any requirement of this International Standard that the organization determines is not applicable to the scope of its quality management system. Conformity to this International Standard may only be claimed if the requirements determined as not being applicable do not affect the organization’s ability or responsibility to ensure the conformity of its products and services and the enhancement of customer satisfaction. When determining this scope, the organization shall consider:", 1, true },
                    { 10L, "4.3.a", "The external and internal issues referred to in 4.1;", false, 9L, "", 1, true },
                    { 11L, "4.3.b", "The requirements of relevant interested parties referred to in 4.2;", false, 9L, "", 1, true },
                    { 12L, "4.3.c", "The products and services of the organization.", false, 9L, "", 1, true },
                    { 13L, "4.4", "Quality management system and its processes", false, 1L, "", 1, true },
                    { 14L, "4.4.1", "The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.", false, 13L, "The organization shall determine the processes needed for the quality management system and their application throughout the organization, and shall:", 1, true },
                    { 15L, "4.4.1.a", "Determine the inputs required and outputs expected;", false, 14L, "", 1, true },
                    { 16L, "4.4.1.b", "Determine sequence and interaction of processes;", false, 14L, "", 1, true },
                    { 17L, "4.4.1.c", "determine and apply the criteria and methods (including monitoring, measurements and related performance indicators) needed to ensure the effective operation and control of these processes;", false, 14L, "", 1, true },
                    { 18L, "4.4.1.d", "determine the resources needed for these processes and ensure their availability;", false, 14L, "", 1, true },
                    { 19L, "4.4.1.e", "assign the responsibilities and authorities for these processes;", false, 14L, "", 1, true },
                    { 20L, "4.4.1.f", "address the risks and opportunities as determined in accordance with the requirements of 6.1;", false, 14L, "", 1, true },
                    { 21L, "4.4.1.g", "evaluate these processes and implement any changes needed to ensure that these processes achieve their intended results;", false, 14L, "", 1, true },
                    { 22L, "4.4.1.h", "improve the processes and the quality management system.", false, 14L, "", 1, true },
                    { 23L, "4.4.2", "", false, 13L, "To the extent necessary, the organization shall:", 1, true },
                    { 24L, "4.4.2.a", "maintain documented information to support the operation of its processes;", false, 23L, "", 1, true },
                    { 25L, "4.4.2.b", "retain documented information to have confidence that the processes are being carried out as planned.", false, 23L, "", 1, true },
                    { 26L, "5", "Leadership", false, null, "", 1, true },
                    { 27L, "5.1", "Leadership and commitment", false, 26L, "", 1, true },
                    { 28L, "5.1.1", "General", false, 27L, "Top management shall demonstrate leadership and commitment with respect to the quality management system by: NOTE Reference to “business” in this International Standard can be interpreted broadly to mean those activities that are core to the purposes of the organization’s existence, whether the organization is public, private, for profit or not for profit.", 1, true },
                    { 29L, "5.1.1.a", "taking accountability for the effectiveness of the quality management system;", false, 28L, "", 1, true },
                    { 30L, "5.1.1.b", "ensuring that the quality policy and quality objectives are established and compatible with the organization;", false, 28L, "", 1, true },
                    { 31L, "5.1.1.c", "ensuring integration of QMS requirements into business processes;", false, 28L, "", 1, true },
                    { 32L, "5.1.1.d", "promoting the use of the process approach and risk-based thinking;", false, 28L, "", 1, true },
                    { 33L, "5.1.1.e", "ensuring necessary resources are available;", false, 28L, "", 1, true },
                    { 34L, "5.1.1.f", "communicating the importance of effective quality management;", false, 28L, "", 1, true },
                    { 35L, "5.1.1.g", "ensuring QMS achieves intended results;", false, 28L, "", 1, true },
                    { 36L, "5.1.1.h", "engaging and supporting persons to contribute to QMS effectiveness;", false, 28L, "", 1, true },
                    { 37L, "5.1.1.i", "promoting improvement;", false, 28L, "", 1, true },
                    { 38L, "5.1.1.j", "supporting other management roles to demonstrate leadership;", false, 28L, "", 1, true },
                    { 39L, "5.1.2", "Customer focus", false, 27L, "", 1, true },
                    { 40L, "5.1.2.a", "customer and statutory requirements are determined and met;", false, 39L, "", 1, true },
                    { 41L, "5.1.2.b", "risks and opportunities affecting conformity are addressed;", false, 39L, "", 1, true },
                    { 42L, "5.1.2.c", "focus on enhancing customer satisfaction is maintained.", false, 39L, "", 1, true },
                    { 43L, "5.2", "Policy", false, 26L, "", 1, true },
                    { 44L, "5.2.1", "Establishing the quality policy", false, 43L, "Top management shall establish, implement and maintain a quality policy that:", 1, true },
                    { 45L, "5.2.1.a", "is appropriate to the purpose and context of the organization;", false, 44L, "", 1, true },
                    { 46L, "5.2.1.b", "provides a framework for setting quality objectives;", false, 44L, "", 1, true },
                    { 47L, "5.2.1.c", "includes a commitment to satisfy applicable requirements;", false, 44L, "", 1, true },
                    { 48L, "5.2.1.d", "includes a commitment to continual improvement of the QMS.", false, 44L, "", 1, true },
                    { 49L, "5.2.2", "Communicating the quality policy", false, 43L, "The quality policy shall:", 1, true },
                    { 50L, "5.2.2.a", "be available and maintained as documented information;", false, 49L, "", 1, true },
                    { 51L, "5.2.2.b", "be communicated and understood within the organization;", false, 49L, "", 1, true },
                    { 52L, "5.2.2.c", "be available to relevant interested parties.", false, 49L, "", 1, true },
                    { 53L, "5.3", "Organizational roles, responsibilities and authorities", false, 26L, "Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization. Top management shall assign the responsibility and authority for:", 1, true },
                    { 54L, "5.3.a", "ensuring QMS conforms to requirements;", false, 53L, "", 1, true },
                    { 55L, "5.3.b", "ensuring processes deliver intended outputs;", false, 53L, "", 1, true },
                    { 56L, "5.3.c", "reporting on the performance of the quality management system and on opportunities for improvement (see 10.1), in particular to top management;", false, 53L, "", 1, true },
                    { 57L, "5.3.d", "ensuring promotion of customer focus.", false, 53L, "", 1, true },
                    { 58L, "6", "Planning", false, null, "", 1, true },
                    { 59L, "6.1", "Actions to address risks and opportunities", false, 58L, "When planning for the quality management system, the organization shall consider the context of the organization and the issues referred to in 4.1, as well as the requirements referred to in 4.2. The organization shall determine the risks and opportunities that need to be addressed to:", 1, true },
                    { 60L, "6.1.a", "give assurance that the QMS can achieve its intended results;", false, 59L, "", 1, true },
                    { 61L, "6.1.b", "enhance desirable effects;", false, 59L, "", 1, true },
                    { 62L, "6.1.c", "prevent or reduce undesired effects;", false, 59L, "", 1, true },
                    { 63L, "6.1.d", "achieve improvement.", false, 59L, "", 1, true },
                    { 64L, "6.1.2", "", false, 59L, "The organization shall plan actions to address risks and opportunities and evaluate their effectiveness of these actions..", 1, true },
                    { 65L, "6.1.2.a", "actions to address these risks and opportunities;", false, 64L, "", 1, true },
                    { 66L, "6.1.2.b", "", false, 64L, "how to:", 1, true },
                    { 67L, "6.1.2.b.1", "integrate and implement the actions into QMS processes (see 4.4);", false, 66L, "", 1, true },
                    { 68L, "6.1.2.b.2", "evaluate the effectiveness of these actions.", false, 66L, "", 1, true },
                    { 69L, "6.1.2.NOTE 1", "Options to address risks can include avoiding risk, taking risk in order to pursue an opportunity, eliminating the risk source, changing the likelihood or consequences, sharing the risk, or retaining risk by informed decision.", false, 64L, "", 1, true },
                    { 70L, "6.1.2.NOTE 2", "Opportunities can lead to the adoption of new practices, launching new products, opening new markets, addressing new customers, building partnerships, using new technology and other desirable and viable possibilities to address the organization’s or its customers’ needs.", false, 64L, "", 1, true },
                    { 71L, "6.2", "Quality objectives and planning to achieve them", false, 58L, "", 1, true },
                    { 72L, "6.2.1", "The organization shall establish quality objectives at relevant functions, levels and processes needed for the quality management system.", false, 71L, "The quality objectives shall: The quality objectives shall:", 1, true },
                    { 73L, "6.2.1.a", "be consistent with the quality policy;", false, 72L, "", 1, true },
                    { 74L, "6.2.1.b", "be measurable;", false, 72L, "", 1, true },
                    { 75L, "6.2.1.c", "take into account applicable requirements;", false, 72L, "", 1, true },
                    { 76L, "6.2.1.d", "be relevant to conformity and customer satisfaction;", false, 72L, "", 1, true },
                    { 77L, "6.2.1.e", "be monitored;", false, 72L, "", 1, true },
                    { 78L, "6.2.1.f", "be communicated;", false, 72L, "", 1, true },
                    { 79L, "6.2.1.g", "be updated as appropriate.", false, 72L, "", 1, true },
                    { 80L, "6.2.2", "", false, 71L, "When planning how to achieve quality objectives, the organization shall determine:", 1, true },
                    { 81L, "6.2.2.a", "what will be done;", false, 80L, "", 1, true },
                    { 82L, "6.2.2.b", "what resources will be required;", false, 80L, "", 1, true },
                    { 83L, "6.2.2.c", "who will be responsible;", false, 80L, "", 1, true },
                    { 84L, "6.2.2.d", "when it will be completed;", false, 80L, "", 1, true },
                    { 85L, "6.2.2.e", "how results will be evaluated.", false, 80L, "", 1, true },
                    { 86L, "6.3", "Planning of changes", false, 58L, "When the organization determines the need for changes to the quality management system, the changes shall be carried out in a planned manner (see 4.4). The organization shall consider:", 1, true },
                    { 87L, "6.3.a", "purpose of the change and potential consequences;", false, 86L, "", 1, true },
                    { 88L, "6.3.b", "integrity of the QMS;", false, 86L, "", 1, true },
                    { 89L, "6.3.c", "availability of resources;", false, 86L, "", 1, true },
                    { 90L, "6.3.d", "allocation or reallocation of responsibilities and authorities.", false, 86L, "", 1, true },
                    { 91L, "7", "Support", false, null, "", 1, true },
                    { 92L, "7.1", "Resources", false, 91L, "", 1, true },
                    { 93L, "7.1.1", "General", false, 92L, "The organization shall determine and provide the resources needed for the establishment, implementation, maintenance and continual improvement of the quality management system. The organization shall consider:", 1, true },
                    { 94L, "7.1.1.a", "capabilities and constraints of existing internal resources;", false, 93L, "", 1, true },
                    { 95L, "7.1.1.b", "what needs to be obtained from external providers.", false, 93L, "", 1, true },
                    { 96L, "7.1.2", "People", false, 92L, "The organization shall determine and provide the persons necessary for the effective implementation of its quality management system and for the operation and control of its processes.", 1, true },
                    { 97L, "7.1.3", "Infrastructure", false, 92L, "The organization shall determine and provide the infrastructure needed for the operation of its processes and to achieve conformity of products and services. ", 1, true },
                    { 98L, "7.1.3.a", "buildings and associated utilities;", false, 97L, "", 1, true },
                    { 99L, "7.1.3.b", "equipment, including hardware and software;", false, 97L, "", 1, true },
                    { 100L, "7.1.3.c", "transportation resources;", false, 97L, "", 1, true },
                    { 101L, "7.1.3.d", "information and communication technology.", false, 97L, "", 1, true },
                    { 102L, "7.1.4", "Environment for the operation of processes", false, 92L, "The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services. physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise). NOTE A suitable environment can be a combination of human and physical factors, such as:", 1, true },
                    { 103L, "7.1.4.a", "social (e.g. non-discriminatory, calm, non-confrontational);", false, 102L, "", 1, true },
                    { 104L, "7.1.4.b", "psychological (e.g. stress-reducing, burnout prevention, emotionally protective);", false, 102L, "", 1, true },
                    { 105L, "7.1.4.c", "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise).", false, 102L, "", 1, true },
                    { 106L, "7.1.5", "Monitoring and measuring resources", false, 92L, "", 1, true },
                    { 107L, "7.1.5.1", "General", false, 106L, "The organization shall determine and provide the resources needed to ensure valid and reliable results when monitoring or measuring is used to verify the conformity of products and services to requirements. \" +\r\n            \"The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.\"", 1, true },
                    { 108L, "7.1.5.1.a", "are suitable for specific monitoring activities being undertaken;", false, 107L, "", 1, true },
                    { 109L, "7.1.5.1.b", "are maintained to ensure their continuing fitness for their purpose.", false, 107L, "", 1, true },
                    { 110L, "7.1.5.2", "Measurement traceability", false, 106L, "The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary. The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary.", 1, true },
                    { 111L, "7.1.5.2.a", "calibrated or verified, or both, at specified intervals, or prior to use, against measurement standards traceable to international or national measurement standards; when no such standards exist, the basis used for calibration or verification shall be retained as documented information;", false, 110L, "", 1, true },
                    { 112L, "7.1.5.2.b", "identified to determine status;", false, 110L, "", 1, true },
                    { 113L, "7.1.5.2.c", "safeguarded from adjustments, damage or deterioration that would invalidate the calibration status and subsequent measurement results.", false, 110L, "", 1, true },
                    { 114L, "7.1.6", "Organizational knowledge", false, 92L, "The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services. This knowledge shall be maintained and be made available to the extent necessary. When addressing changing needs and trends, the organization shall consider its current knowledge and determine how to acquire or access any necessary additional knowledge and required updates. Organizational knowledge can be based on:", 1, true },
                    { 115L, "7.1.6.Note 1", "Organizational knowledge is knowledge specific to the organization; it is generally gained by experience. It is information that is used and shared to achieve the organization’s objectives.", false, 114L, "", 1, true },
                    { 116L, "7.1.6.Note 2", "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, or the reassignment of currently employed persons; or the hiring or contracting of competent persons.", false, 114L, "", 1, true },
                    { 117L, "7.1.6.a", "internal sources (e.g. intellectual property; knowledge gained from experience; lessons learned from failures and successful projects; capturing and sharing undocumented knowledge and experience; the results of improvements in processes, products and services);", false, 114L, "", 1, true },
                    { 118L, "7.1.6.b", "external sources (e.g. standards; academia; conferences; gathering knowledge from customers or external providers).", false, 114L, "", 1, true },
                    { 119L, "7.2", "Competence", false, 91L, "", 1, true },
                    { 120L, "7.2.a", "determine the necessary competence of person(s) doing work under its control that affects the performance and effectiveness of the quality management system;", false, 117L, "", 1, true },
                    { 121L, "7.2.b", "ensure that these persons are competent on the basis of appropriate education, training, or experience;", false, 117L, "", 1, true },
                    { 122L, "7.2.c", "where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken;", false, 117L, "", 1, true },
                    { 123L, "7.3", "Awareness", false, 91L, "The organization shall ensure that persons doing work under the organization’s control are aware of:", 1, true },
                    { 124L, "7.3.a", "quality policy;", false, 121L, "", 1, true },
                    { 125L, "7.3.b", "relevant quality objectives;", false, 121L, "", 1, true },
                    { 126L, "7.3.c", "their contribution to the effectiveness of the quality management system, including the benefits of improved performance;", false, 121L, "", 1, true },
                    { 127L, "7.3.d", "the implications of not conforming with the quality management system requirements.", false, 121L, "", 1, true },
                    { 128L, "7.4", "Communication", false, 91L, "The organization shall determine the internal and external communications relevant to the quality management system, including:", 1, true },
                    { 129L, "7.4.a", "what to communicate;", false, 126L, "", 1, true },
                    { 130L, "7.4.b", "when to communicate;", false, 126L, "", 1, true },
                    { 131L, "7.4.c", "with whom to communicate;", false, 126L, "", 1, true },
                    { 132L, "7.4.d", "how to communicate;", false, 126L, "", 1, true },
                    { 133L, "7.4.e", "who communicates.", false, 126L, "", 1, true },
                    { 134L, "7.5", "Documented information", false, 91L, "", 1, true },
                    { 135L, "7.5.1", "General", false, 132L, "The organization’s quality management system shall include:", 1, true },
                    { 136L, "7.5.1.a", "documented information required by this International Standard;", false, 133L, "", 1, true },
                    { 137L, "7.5.1.b", "documented information determined by the organization as being necessary for the effectiveness of the quality management system.", false, 133L, "", 1, true },
                    { 138L, "7.5.2", "Creating and updating", false, 132L, "When creating and updating documented information, the organization shall ensure appropriate:", 1, true },
                    { 139L, "7.5.2.a", "identification and description (e.g. a title, date, author, or reference number);", false, 136L, "", 1, true },
                    { 140L, "7.5.2.b", "format (e.g. language, software version, graphics) and media (e.g. paper, electronic);", false, 136L, "", 1, true },
                    { 141L, "7.5.2.c", "review and approval for suitability and adequacy.", false, 136L, "", 1, true },
                    { 142L, "7.5.3", "Control of documented information", false, 132L, "", 1, true },
                    { 143L, "7.5.3.1", "Documented information required by the quality management system and by this International Standard shall be controlled to ensure:", false, 140L, "", 1, true },
                    { 144L, "7.5.3.1.a", "it is available and suitable for use, where and when it is needed;", false, 141L, "", 1, true },
                    { 145L, "7.5.3.1.b", "it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).", false, 141L, "", 1, true },
                    { 146L, "7.5.3.2", "", false, 140L, "Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and be controlled.Documented information retained as evidence of conformity shall be protected from unintended alterations. For the control of documented information, the organization shall address the following activities, as applicable:", 1, true },
                    { 147L, "7.5.3.2.a", "distribution and access;", false, 144L, "", 1, true },
                    { 148L, "7.5.3.2.b", "storage and preservation, including preservation of legibility;", false, 144L, "", 1, true },
                    { 149L, "7.5.3.2.c", "control of changes (e.g. version control);", false, 144L, "", 1, true },
                    { 150L, "7.5.3.2.d", "retention and disposition.", false, 144L, "", 1, true },
                    { 151L, "8", "Operation", false, null, "", 1, true },
                    { 152L, "8.1", "Operational planning and control", false, 149L, "The organization shall plan, implement and control the processes (see 4.4) needed to meet the requirements for the provision of products and services, and to implement the actions determined in Clause 6, by:The output of this planning shall be suitable for the organization’s operations. The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary. The organization shall ensure that outsourced processes are controlled (see 8.4).", 1, true },
                    { 153L, "8.1.a", "determining the requirements for the products and services;", false, 150L, "", 1, true },
                    { 154L, "8.1.b", "establishing criteria for:", false, 150L, "", 1, true },
                    { 155L, "8.1.b.1", "the processes;", false, 152L, "", 1, true },
                    { 156L, "8.1.b.2", "the acceptance of products and services;", false, 152L, "", 1, true },
                    { 157L, "8.1.c", "determining the resources needed to achieve conformity to the product and service requirements;", false, 150L, "", 1, true },
                    { 158L, "8.1.d", "implementing control of the processes in accordance with criteria;", false, 150L, "", 1, true },
                    { 159L, "8.1.e", "determining, maintaining and retaining documented information to the extent necessary:", false, 150L, "", 1, true },
                    { 160L, "8.1.e.1", "to have confidence processes were carried out as planned;", false, 157L, "", 1, true },
                    { 161L, "8.1.e.2", "to demonstrate the conformity of products and services to their requirements.", false, 157L, "", 1, true },
                    { 162L, "8.2", "Requirements for products and services", false, 149L, "", 1, true },
                    { 163L, "8.1.e.2", "to demonstrate the conformity of products and services to their requirements.", false, 157L, "", 1, true },
                    { 164L, "8.2.1", "Customer communication", false, 160L, "Communication with customers shall include:", 1, true },
                    { 165L, "8.2.1.a", "providing information relating to products and services;", false, 161L, "", 1, true },
                    { 166L, "8.2.1.b", "handling enquiries, contracts or orders, including changes;;", false, 161L, "", 1, true },
                    { 167L, "8.2.1.c", "obtaining customer feedback relating to products and services, including customer complaints;;", false, 161L, "", 1, true },
                    { 168L, "8.2.1.d", "handling or controlling customer property;", false, 161L, "", 1, true },
                    { 169L, "8.2.1.e", "establishing specific requirements for contingency actions, when relevant.", false, 161L, "", 1, true },
                    { 170L, "8.2.2", "Determining the requirements for products and services", false, 160L, "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:", 1, true },
                    { 171L, "8.2.2.a", "the requirements for the products and services are defined, including:", false, 167L, "", 1, true },
                    { 172L, "8.2.2.a.1", "any applicable statutory and regulatory requirements;", false, 168L, "", 1, true },
                    { 173L, "8.2.2.a.2", "those considered necessary by the organization;", false, 168L, "", 1, true },
                    { 174L, "8.2.2.b", "the organization can meet the claims for the products and services it offers.", false, 167L, "", 1, true },
                    { 175L, "8.2.3", "", false, 160L, "Review of the requirements for products and services", 1, true },
                    { 176L, "8.2.3.1", "Review before commitment to supply", false, 172L, "The organization shall ensure that contract or order requirements differing from those previously defined are resolved. The customer’s requirements shall be confirmed by the organization before acceptance, when the customer does not provide a documented statement of their requirements.", 1, true },
                    { 177L, "8.2.3.1.a", "requirements specified by the customer, including the requirements for delivery and postdelivery activities;", false, 173L, "", 1, true },
                    { 178L, "8.2.3.1.b", "requirements not stated by the customer, but necessary for the specified or intended use, when known;", false, 173L, "", 1, true },
                    { 179L, "8.2.3.1.c", "requirements specified by organization;", false, 173L, "", 1, true },
                    { 180L, "8.2.3.1.d", "statutory and regulatory requirements applicable to the products and services;", false, 173L, "", 1, true },
                    { 181L, "8.2.3.1.e", "contract or order requirements differing from those previously expressed.", false, 173L, "", 1, true },
                    { 182L, "8.2.3.2", "The organization shall retain documented information, as applicable:", false, 172L, "", 1, true },
                    { 183L, "8.2.3.2.a", "on the results of the review;", false, 179L, "", 1, true },
                    { 184L, "8.2.3.2.b", "on any new requirements for products and services.", false, 179L, "", 1, true },
                    { 185L, "8.2.4", "Changes to requirements for products and services", false, 160L, "The organization shall ensure that relevant documented information is amended, and that relevant persons are made aware of the changed requirements, when the requirements for products and services are changed.", 1, true },
                    { 186L, "8.3", "Design and development of products and services", false, 149L, "", 1, true },
                    { 187L, "8.3.1", "General", false, 183L, "The organization shall establish, implement and maintain a design and development process that is appropriate to ensure the subsequent provision of products and services.", 1, true },
                    { 188L, "8.3.2", "Design and development of products and services", false, 183L, "In determining the stages and controls for design and development, the organization shall consider:", 1, true },
                    { 189L, "8.3.2.a", "the nature, duration and complexity of the design and development activities;", false, 185L, "", 1, true },
                    { 190L, "8.3.2.b", "the required process stages, including applicable design and development reviews;", false, 185L, "", 1, true },
                    { 191L, "8.3.2.c", "the required design and development verification and validation activities;", false, 185L, "", 1, true },
                    { 192L, "8.3.2.d", "the responsibilities and authorities involved in the design and development process;", false, 185L, "", 1, true },
                    { 193L, "8.3.2.e", "the internal and external resource needs for the design and development of products and services;;", false, 185L, "", 1, true },
                    { 194L, "8.3.2.f", "The need to control interfaces between persons involved in the design and development process;", false, 188L, "", 1, true },
                    { 195L, "8.3.2.g", "The need for involvement of customers and users in the design and development process;", false, 188L, "", 1, true },
                    { 196L, "8.3.2.h", "The requirements for subsequent provision of products and services;", false, 188L, "", 1, true },
                    { 197L, "8.3.2.i", "The level of control expected by customers and other interested parties;", false, 188L, "", 1, true },
                    { 198L, "8.3.2.j", "Documented information to demonstrate requirements are met;", false, 188L, "", 1, true },
                    { 199L, "8.3.3", "Design and development inputs", false, 186L, "The organization shall determine the requirements essential for the specific types of products and services to be designed and developed. The organization shall consider: Inputs shall be adequate for design and development purposes, complete and unambiguous. Conflicting design and development inputs shall be resolved. The organization shall retain documented information on design and development inputs.", 1, true },
                    { 200L, "8.3.3.a", "Functional and performance requirements; ", false, 199L, "", 1, true },
                    { 201L, "8.3.3.b", "Information from previous similar design and development activities; ", false, 199L, "", 1, true },
                    { 202L, "8.3.3.c", "Statutory and regulatory requirements; ", false, 199L, "", 1, true },
                    { 203L, "8.3.3.d", "standards or codes of practice that the organization has committed to implement;", false, 199L, "", 1, true },
                    { 204L, "8.3.3.e", "potential consequences of failure due to the nature of the products and services.", false, 199L, "", 1, true },
                    { 205L, "8.3.4", "Design and development controls", false, 186L, "The organization shall apply controls to the design and development process to ensure that:", 1, true },
                    { 206L, "8.3.4.a", "The results to be achieved are defined; ", false, 205L, "", 1, true },
                    { 207L, "8.3.4.b", "reviews are conducted to evaluate the ability of the results of design and development to meet requirements;", false, 205L, "", 1, true },
                    { 208L, "8.3.4.c", "verification activities are conducted to ensure that the design and development outputs meet the input requirements;", false, 205L, "", 1, true },
                    { 209L, "8.3.4.d", "Validation activities conducted to ensure that the resulting products and services meet requirements for the specified application or intended use; ", false, 205L, "", 1, true },
                    { 210L, "8.3.4.e", "any necessary actions are taken on problems determined during the reviews, or verification and validation activities;", false, 205L, "", 1, true },
                    { 211L, "8.3.4.f", "Documented information of these activities is retained. ", false, 205L, "", 1, true },
                    { 212L, "8.3.5", "design and development outputs", false, 186L, "The organization shall retain documented information on design and development outputs. The organization shall ensure that design and development outputs.", 1, true },
                    { 213L, "8.3.5.a", "Meet the input requirements", false, 212L, "", 1, true },
                    { 214L, "8.3.5.b", "are adequate for the subsequent process for the provision of products and services", false, 212L, "", 1, true },
                    { 215L, "8.3.5.c", "include or reference monitoring and measuring requirements, as appropriate, and acceptance criteria;", false, 212L, "", 1, true },
                    { 216L, "8.3.5.d", "specify the characteristics of the products and services that are essential for their intended purpose and their safe and proper provision.", false, 212L, "", 1, true },
                    { 217L, "8.3.6", "Design and development changes", false, 186L, "The organization shall identify, review and control changes made during, or subsequent to, the design and development of products and services, to the extent necessary to ensure that there is no adverse impact on conformity to requirements. The organization shall retain documented information on:", 1, true },
                    { 218L, "8.3.6.a", "design and development changes; ", false, 217L, "", 1, true },
                    { 219L, "8.3.6.b", "the results of reviews", false, 217L, "", 1, true },
                    { 220L, "8.3.6.c", "the authorization of the changes", false, 217L, "", 1, true },
                    { 221L, "8.3.6.d", "the actions taken to prevent adverse impacts", false, 217L, "", 1, true },
                    { 222L, "8.4", "Control of externally provided processes, products and services", false, null, "", 1, true },
                    { 223L, "8.4.1", "General", false, 222L, "The organization shall ensure that externally provided processes, products and services conform to requirements.The organization shall determine and apply criteria for the evaluation, selection, monitoring of performance, and re-evaluation of external providers, based on their ability to provide processes or products and services in accordance with requirements. The organization shall retain documented information of these activities and any necessary actions arising from the evaluations.", 1, true },
                    { 224L, "8.4.1.a", "Products and services intended for incorporation into the organization’s own products and services; ", false, 223L, "", 1, true },
                    { 225L, "8.4.1.b", "Products and services provided directly to customers by external providers on behalf of the organization; ", false, 223L, "", 1, true },
                    { 226L, "8.4.1.c", "A process, or part of a process, provided by an external provider as a result of a decision by the organization. ", false, 223L, "", 1, true },
                    { 227L, "8.4.2", "Type and extent of control", false, 222L, "The organization shall ensure that externally provided processes, products and services do not adversely affect the organization’s ability to consistently deliver conforming products and services to its customers.", 1, true },
                    { 228L, "8.4.2.a", "ensure that externally provided processes remain within the control of its quality management system;", false, 227L, "", 1, true },
                    { 229L, "8.4.2.b", "define both the controls that it intends to apply to an external provider and those it intends to apply to the resulting output;", false, 227L, "", 1, true },
                    { 230L, "8.4.2.c", "Take into consideration:", false, 227L, "", 1, true },
                    { 231L, "8.4.2.c.1", "the potential impact of the externally provided processes, products and services on the organization’s ability to consistently meet customer and applicable statutory and regulatory requirements;", false, 230L, "", 1, true },
                    { 232L, "8.4.2.c.2", "Effectiveness of controls applied by the external provide;r", false, 230L, "", 1, true },
                    { 233L, "8.4.2.d", "determine the verification, or other activities, necessary to ensure that the externally provided processes, products and services meet requirements.", false, 227L, "", 1, true },
                    { 234L, "8.4.3", "Information for external providers", false, 222L, "The organization shall ensure adequacy of requirements prior to communication to external providers.", 1, true },
                    { 235L, "8.4.3.a", "Processes, products and services to be provided", false, 234L, "", 1, true },
                    { 236L, "8.4.3.b", "the approval of:", false, 234L, "", 1, true },
                    { 237L, "8.4.3.b.1", "Products and services", false, 236L, "", 1, true },
                    { 238L, "8.4.3.b.2", "Methods, processes and equipment", false, 236L, "", 1, true },
                    { 239L, "8.4.3.b.3", "the release of products and services", false, 236L, "", 1, true },
                    { 240L, "8.4.3.c", "Competence, including qualification of persons", false, 234L, "", 1, true },
                    { 241L, "8.4.3.d", "External providers’ interactions with the organization", false, 234L, "", 1, true },
                    { 242L, "8.4.3.e", "control and monitoring of the external providers’ performance to be applied by the organization;", false, 234L, "", 1, true },
                    { 243L, "8.4.3.f", "verification or validation activities that the organization, or its customer, intends to perform at the external providers’ premises.", false, 234L, "", 1, true },
                    { 244L, "8.5", "Production and service provision", false, null, "", 1, true },
                    { 245L, "8.5.1", "Control of production and service provision", false, 244L, "The organization shall implement production and service provision under controlled conditions. Controlled conditions shall include, as applicable:", 1, true },
                    { 246L, "8.5.1.a", "the availability of documented information that defines:", false, 245L, "", 1, true },
                    { 247L, "8.5.1.a.1", "the characteristics of the products to be produced, the services to be provided, or the activities to be performed;", false, 246L, "", 1, true },
                    { 248L, "8.5.1.a.2", "the results to be achieved;", false, 246L, "", 1, true },
                    { 249L, "8.5.1.b", "the availability and use of suitable monitoring and measuring resources;", false, 245L, "", 1, true },
                    { 250L, "8.5.1.c", "the implementation of monitoring and measurement activities at appropriate stages to verify that criteria for control of processes or outputs, and acceptance criteria for products and services, have been met;", false, 245L, "", 1, true },
                    { 251L, "8.5.1.d", "the use of suitable infrastructure and environment for the operation of processes;", false, 245L, "", 1, true },
                    { 252L, "8.5.1.e", "the appointment of competent persons, including any required qualification;", false, 245L, "", 1, true },
                    { 253L, "8.5.1.f", "the validation, and periodic revalidation, of the ability to achieve planned results of the processes for production and service provision, where the resulting output cannot be verified by subsequent monitoring or measurement;", false, 245L, "", 1, true },
                    { 254L, "8.5.1.g", "the implementation of actions to prevent human error;", false, 245L, "", 1, true },
                    { 255L, "8.5.1.h", "the implementation of release, delivery and post-delivery activities.", false, 245L, "", 1, true },
                    { 256L, "8.5.2", "Identification and traceability", false, 244L, "The organization shall use suitable means to identify outputs when it is necessary to ensure the conformity of products and services. The organization shall identify the status of outputs with respect to monitoring and measurement requirements throughout production and service provision. The organization shall control the unique identification of the outputs when traceability is a requirement, and shall retain the documented information necessary to enable traceability.", 1, true },
                    { 257L, "8.5.3", "Property belonging to customers or external providers", false, 244L, "The organization shall exercise care with property belonging to customers or external providers while it is under the organization’s control or being used by the organization. The organization shall identify, verify, protect and safeguard customers’ or external providers’ property provided for use or incorporation into the products and services. When the property of a customer or external provider is lost, damaged or otherwise found to be unsuitable for use, the organization shall report this to the customer or external provider and retain documented information on what has occurred.", 1, true },
                    { 258L, "8.5.4", "Preservation", false, 244L, "The organization shall preserve the outputs during production and service provision, to the extent necessary to ensure conformity to requirements.", 1, true },
                    { 259L, "8.5.5", "Post-delivery activities", false, 244L, "The organization shall meet requirements for post-delivery activities associated with the products and services. In determining the extent of post-delivery activities that are required, the organization shall consider:", 1, true },
                    { 260L, "8.5.5.a", "statutory and regulatory requirements;", false, 259L, "", 1, true },
                    { 261L, "8.5.5.b", "the potential undesired consequences associated with its products and services;", false, 259L, "", 1, true },
                    { 262L, "8.5.5.c", "the nature, use and intended lifetime of its products and services;", false, 259L, "", 1, true },
                    { 263L, "8.5.5.d", "customer requirements;", false, 259L, "", 1, true },
                    { 264L, "8.5.5.e", "customer feedback.", false, 259L, "", 1, true },
                    { 265L, "8.5.6", "Control of changes", false, 244L, "The organization shall review and control changes for production or service provision, to the extent necessary to ensure continuing conformity with requirements. The organization shall retain documented information describing the results of the review of changes, the person(s) authorizing the change, and any necessary actions arising from the review.", 1, true },
                    { 266L, "8.6", "Release of products and services", false, 244L, "The organization shall implement planned arrangements, at appropriate stages, to verify that the product and service requirements have been met. The release of products and services to the customer shall not proceed until the planned arrangements have been satisfactorily completed, unless otherwise approved by a relevant authority and, as applicable, by the customer. The organization shall retain documented information on the release of products and services. The documented information shall include:", 1, true },
                    { 267L, "8.6.a", "evidence of conformity with the acceptance criteria;", false, 266L, "", 1, true },
                    { 268L, "8.6.b", "traceability to the person(s) authorizing the release.", false, 266L, "", 1, true },
                    { 269L, "8.7", "Control of nonconforming outputs", false, 244L, "", 1, true },
                    { 270L, "8.7.1", "", false, 269L, "The organization shall ensure that outputs that do not conform to their requirements are identified and controlled to prevent their unintended use or delivery. The organization shall take appropriate action based on the nature of the nonconformity and its effect on the conformity of products and services. This shall also apply to nonconforming products and services detected after delivery of products, during or after the provision of services. Conformity to the requirements shall be verified when nonconforming outputs are corrected. The organization shall deal with nonconforming outputs in one or more of the following ways:", 1, true },
                    { 271L, "8.7.1.a", "Correction;", false, 270L, "", 1, true },
                    { 272L, "8.7.1.b", "segregation, containment, return or suspension of provision of products and services;", false, 270L, "", 1, true },
                    { 273L, "8.7.1.c", "informing the customer;", false, 270L, "", 1, true },
                    { 274L, "8.7.1.d", "obtaining authorization for acceptance under concession.", false, 270L, "", 1, true },
                    { 275L, "8.7.2", "", false, 269L, "The organization shall retain documented information that:", 1, true },
                    { 276L, "8.7.2.a", "describes the nonconformity;", false, 275L, "", 1, true },
                    { 277L, "8.7.2.b", "describes the actions taken;", false, 275L, "", 1, true },
                    { 278L, "8.7.2.c", "describes any concessions obtained;", false, 275L, "", 1, true },
                    { 279L, "8.7.2.d", "identifies the authority deciding the action in respect of the nonconformity.", false, 275L, "", 1, true },
                    { 280L, "9", "Performance evaluation", false, null, "", 1, true },
                    { 281L, "9.1", "Monitoring, measurement, analysis and evaluation", false, 280L, "", 1, true },
                    { 282L, "9.1.1", "General", false, 281L, "The organization shall evaluate the performance and the effectiveness of the quality management system. The organization shall retain appropriate documented information as evidence of the results. The organization shall determine:", 1, true },
                    { 283L, "9.1.1.a", "what needs to be monitored and measured;", false, 282L, "", 1, true },
                    { 284L, "9.1.1.b", "the methods for monitoring, measurement, analysis and evaluation needed to ensure valid results;", false, 282L, "", 1, true },
                    { 285L, "9.1.1.c", "when the monitoring and measuring shall be performed;", false, 282L, "", 1, true },
                    { 286L, "9.1.1.d", "when the results from monitoring and measurement shall be analysed and evaluated.", false, 282L, "", 1, true },
                    { 287L, "9.1.2", "Customer satisfaction", false, 281L, "The organization shall monitor customers’ perceptions of the degree to which their needs and expectations have been fulfilled. The organization shall determine the methods for obtaining, monitoring and reviewing this information.", 1, true },
                    { 288L, "9.1.3", "Analysis and evaluation", false, 281L, "The organization shall analyse and evaluate appropriate data and information arising from monitoring and measurement. The results of analysis shall be used to evaluate:", 1, true },
                    { 289L, "9.1.3.a", "conformity of products and services;", false, 288L, "", 1, true },
                    { 290L, "9.1.3.b", "the degree of customer satisfaction;", false, 288L, "", 1, true },
                    { 291L, "9.1.3.c", "the performance and effectiveness of the quality management system;", false, 288L, "", 1, true },
                    { 292L, "9.1.3.d", "if planning has been implemented effectively;", false, 288L, "", 1, true },
                    { 293L, "9.1.3.e", "the effectiveness of actions taken to address risks and opportunities;", false, 288L, "", 1, true },
                    { 294L, "9.1.3.f", "the performance of external providers;", false, 288L, "", 1, true },
                    { 295L, "9.1.3.g", "the need for improvements to the quality management system.", false, 288L, "", 1, true },
                    { 296L, "9.2", "Internal audit", false, 280L, "", 1, true },
                    { 297L, "9.2.1", "", false, 296L, "The organization shall conduct internal audits at planned intervals to provide information on whether the quality management system:", 1, true },
                    { 298L, "9.2.1.a", "conforms to:", false, 297L, "", 1, true },
                    { 299L, "9.2.1.a.1", "the organization’s own requirements for its quality management system;", false, 298L, "", 1, true },
                    { 300L, "9.2.1.a.2", "the requirements of this International Standard;", false, 298L, "", 1, true },
                    { 301L, "9.2.1.b", "is effectively implemented and maintained.", false, 297L, "", 1, true },
                    { 302L, "9.2.2", "", false, 296L, "The organization shall:", 1, true },
                    { 303L, "9.2.2.a", "plan, establish, implement and maintain an audit programme(s) including the frequency, methods, responsibilities, planning requirements and reporting, which shall take into consideration the importance of the processes concerned, changes affecting the organization, and the results of previous audits;", false, 302L, "", 1, true },
                    { 304L, "9.2.2.b", "define the audit criteria and scope for each audit;", false, 302L, "", 1, true },
                    { 305L, "9.2.2.c", "select auditors and conduct audits to ensure objectivity and the impartiality of the audit process;", false, 279L, "", 1, true },
                    { 306L, "9.2.2.d", "ensure that the results of the audits are reported to relevant management;", false, 302L, "", 1, true },
                    { 307L, "9.2.2.e", "take appropriate correction and corrective actions without undue delay;", false, 302L, "", 1, true },
                    { 308L, "9.2.2.f", "retain documented information as evidence of the implementation of the audit programme and the audit results.", false, 302L, "", 1, true },
                    { 309L, "9.3", "Management review", false, 280L, "", 1, true },
                    { 310L, "9.3.1", "General", false, 309L, "Top management shall review the organization’s quality management system, at planned intervals, to ensure its continuing suitability, adequacy, effectiveness and alignment with the strategic direction of the organization.", 1, true },
                    { 311L, "9.3.2", "Management review inputs", false, 309L, "The management review shall be planned and carried out taking into consideration:", 1, true },
                    { 312L, "9.3.2.a", "the status of actions from previous management reviews;", false, 311L, "", 1, true },
                    { 313L, "9.3.2.b", "changes in external and internal issues that are relevant to the quality management system;", false, 311L, "", 1, true },
                    { 314L, "9.3.2.c", "information on the performance and effectiveness of the quality management system, including trends in:", false, 311L, "", 1, true },
                    { 315L, "9.3.2.c.1", "customer satisfaction and feedback from relevant interested parties;", false, 314L, "", 1, true },
                    { 316L, "9.3.2.c.2", "the extent to which quality objectives have been met;", false, 314L, "", 1, true },
                    { 317L, "9.3.2.c.3", "process performance and conformity of products and services;", false, 314L, "", 1, true },
                    { 318L, "9.3.2.c.4", "nonconformities and corrective actions;", false, 314L, "", 1, true },
                    { 319L, "9.3.2.c.5", "monitoring and measurement results;", false, 314L, "", 1, true },
                    { 320L, "9.3.2.c.6", "audit results;", false, 314L, "", 1, true },
                    { 321L, "9.3.2.c.7", "the performance of external providers", false, 314L, "", 1, true },
                    { 322L, "9.3.2.d", "the adequacy of resources;", false, 311L, "", 1, true },
                    { 323L, "9.3.2.e", "the effectiveness of actions taken to address risks and opportunities (see 6.1);", false, 311L, "", 1, true },
                    { 324L, "9.3.2.f", "opportunities for improvement", false, 311L, "", 1, true },
                    { 325L, "9.3.3", "Management review outputs", false, 309L, "The organization shall retain documented information as evidence of the results of management reviews. The outputs of the management review shall include decisions and actions related to:", 1, true },
                    { 326L, "9.3.3.a", "opportunities for improvement;", false, 325L, "", 1, true },
                    { 327L, "9.3.3.b", "any need for changes to the quality management system;", false, 325L, "", 1, true },
                    { 328L, "9.3.3.c", "resource needs.", false, 325L, "", 1, true },
                    { 329L, "10", "Improvement", false, null, "", 1, true },
                    { 330L, "10.1", "General", false, 329L, "The organization shall determine and select opportunities for improvement and implement any necessary actions to meet customer requirements and enhance customer satisfaction. These shall include:", 1, true },
                    { 331L, "10.1.1.a", "improving products and services to meet requirements as well as to address future needs and expectations;", false, 330L, "", 1, true },
                    { 332L, "10.1.1.b", "correcting, preventing or reducing undesired effects;", false, 330L, "", 1, true },
                    { 333L, "10.1.1.c", "improving the performance and effectiveness of the quality management system.", false, 330L, "", 1, true },
                    { 334L, "10.2", "Nonconformity and corrective action", false, 329L, "", 1, true },
                    { 335L, "10.2.1", "", false, 334L, "Corrective actions shall be appropriate to the effects of the nonconformities encountered. When a nonconformity occurs, including any arising from complaints, the organization shall:", 1, true },
                    { 336L, "10.2.1.a", "react to the nonconformity and, as applicable:", false, 335L, "", 1, true },
                    { 337L, "10.2.1.a.1", "take action control and correct it;", false, 336L, "", 1, true },
                    { 338L, "10.2.1.a.2", "deal with the consequences;", false, 336L, "", 1, true },
                    { 339L, "10.2.1.b", "evaluate the need for action to eliminate the cause(s) of the nonconformity, in order that it does not recur or occur elsewhere, by:", false, 335L, "", 1, true },
                    { 340L, "10.2.1.b.1", "reviewing and analysing the nonconformity;", false, 339L, "", 1, true },
                    { 341L, "10.2.1.b.2", "determining the causes of the nonconformity;", false, 339L, "", 1, true },
                    { 342L, "10.2.1.b.3", "determining if similar nonconformities exist, or could potentially occur;", false, 335L, "", 1, true },
                    { 343L, "10.2.1.c", "implement any action needed;", false, 335L, "", 1, true },
                    { 344L, "10.2.1.d", "review the effectiveness of any corrective action taken;", false, 335L, "", 1, true },
                    { 345L, "10.2.1.e", "update risks and opportunities determined during planning, if necessary;", false, 335L, "", 1, true },
                    { 346L, "10.2.1.f", "make changes to the quality management system, if necessary.", false, 335L, "", 1, true },
                    { 347L, "10.2.2", "", false, 334L, "The organization shall retain documented information as evidence of:", 1, true },
                    { 348L, "10.2.2.a", "the nature of the nonconformities and any subsequent actions taken;", false, 347L, "", 1, true },
                    { 349L, "10.2.2.b", "the results of any corrective action.", false, 347L, "", 1, true },
                    { 350L, "10.3", "Continual improvement", false, 329L, "The organization shall continually improve the suitability, adequacy and effectiveness of the quality management system. The organization shall consider the results of analysis and evaluation, and the outputs from management review, to determine if there are needs or opportunities that shall be addressed as part of continual improvement.", 1, true }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanApprovals_ApproverId1",
                table: "AuditPlanApprovals",
                column: "ApproverId1");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanApprovals_AuditPlanId",
                table: "AuditPlanApprovals",
                column: "AuditPlanId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanEntries_AuditPlanId",
                table: "AuditPlanEntries",
                column: "AuditPlanId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanPersonResponsibles_AuditPlanEntryId",
                table: "AuditPlanPersonResponsibles",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanProcesses_AuditPlanEntryId",
                table: "AuditPlanProcesses",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanProcesses_OfficeId",
                table: "AuditPlanProcesses",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_PreparerId",
                table: "AuditPlans",
                column: "PreparerId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_SelectedApproverId",
                table: "AuditPlans",
                column: "SelectedApproverId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoAuditors_AuditPlanEntryId",
                table: "IsoAuditors",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoAuditors_IsoAuditorsId",
                table: "IsoAuditors",
                column: "IsoAuditorsId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoAuditors_TeamId",
                table: "IsoAuditors",
                column: "TeamId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoAuditProcess_AuditPlanEntryId",
                table: "IsoAuditProcess",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoStandardAuditPlans_AuditPlanEntryId",
                table: "IsoStandardAuditPlans",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoStandardAuditPlans_IsoStandardId1",
                table: "IsoStandardAuditPlans",
                column: "IsoStandardId1");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuditPlanApprovals");

            migrationBuilder.DropTable(
                name: "AuditPlanPersonResponsibles");

            migrationBuilder.DropTable(
                name: "AuditPlanProcesses");

            migrationBuilder.DropTable(
                name: "IsoAuditors");

            migrationBuilder.DropTable(
                name: "IsoAuditProcess");

            migrationBuilder.DropTable(
                name: "IsoStandardAuditPlans");

            migrationBuilder.DropTable(
                name: "AuditPlanEntries");

            migrationBuilder.DropTable(
                name: "AuditPlans");

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 1L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 2L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 3L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 4L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 5L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 6L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 10L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 11L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 12L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 13L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 14L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 15L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 16L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 17L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 18L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 19L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 20L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 21L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 22L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 23L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 24L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 25L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 26L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 27L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 28L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 29L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 30L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 31L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 32L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 33L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 34L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 35L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 36L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 37L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 38L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 39L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 40L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 41L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 42L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 43L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 44L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 45L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 46L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 47L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 48L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 49L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 50L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 51L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 52L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 53L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 54L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 55L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 56L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 57L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 58L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 59L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 60L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 61L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 62L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 63L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 64L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 65L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 66L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 67L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 68L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 69L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 70L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 71L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 72L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 73L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 74L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 75L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 76L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 77L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 78L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 79L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 80L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 81L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 82L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 83L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 84L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 85L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 86L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 87L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 88L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 89L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 90L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 91L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 92L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 93L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 94L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 95L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 96L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 97L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 98L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 99L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 100L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 101L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 102L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 103L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 104L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 105L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 106L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 107L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 108L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 109L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 110L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 111L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 112L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 113L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 114L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 115L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 116L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 117L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 118L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 119L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 120L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 121L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 122L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 123L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 124L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 125L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 126L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 127L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 128L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 129L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 130L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 131L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 132L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 133L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 134L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 135L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 136L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 137L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 138L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 139L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 140L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 141L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 142L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 143L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 144L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 145L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 146L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 147L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 148L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 149L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 150L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 151L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 152L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 153L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 154L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 155L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 156L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 157L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 158L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 159L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 160L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 161L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 162L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 163L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 164L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 165L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 166L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 167L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 168L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 169L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 170L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 171L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 172L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 173L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 174L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 175L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 176L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 177L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 178L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 179L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 180L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 181L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 182L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 183L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 184L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 185L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 186L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 187L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 188L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 189L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 190L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 191L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 192L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 193L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 194L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 195L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 196L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 197L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 198L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 199L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 200L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 201L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 202L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 203L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 204L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 205L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 206L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 207L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 208L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 209L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 210L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 211L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 212L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 213L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 214L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 215L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 216L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 217L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 218L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 219L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 220L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 221L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 222L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 223L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 224L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 225L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 226L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 227L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 228L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 229L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 230L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 231L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 232L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 233L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 234L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 235L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 236L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 237L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 238L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 239L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 240L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 241L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 242L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 243L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 244L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 245L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 246L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 247L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 248L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 249L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 250L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 251L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 252L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 253L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 254L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 255L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 256L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 257L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 258L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 259L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 260L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 261L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 262L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 263L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 264L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 265L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 266L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 267L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 268L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 269L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 270L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 271L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 272L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 273L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 274L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 275L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 276L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 277L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 278L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 279L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 280L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 281L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 282L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 283L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 284L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 285L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 286L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 287L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 288L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 289L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 290L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 291L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 292L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 293L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 294L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 295L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 296L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 297L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 298L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 299L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 300L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 301L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 302L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 303L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 304L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 305L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 306L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 307L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 308L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 309L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 310L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 311L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 312L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 313L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 314L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 315L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 316L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 317L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 318L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 319L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 320L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 321L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 322L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 323L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 324L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 325L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 326L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 327L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 328L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 329L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 330L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 331L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 332L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 333L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 334L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 335L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 336L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 337L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 338L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 339L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 340L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 341L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 342L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 343L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 344L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 345L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 346L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 347L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 348L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 349L);

            migrationBuilder.DeleteData(
                table: "IsoStandards",
                keyColumn: "Id",
                keyValue: 350L);

            migrationBuilder.DropColumn(
                name: "ParentID",
                table: "IsoStandards");

            migrationBuilder.DropColumn(
                name: "Particulars",
                table: "IsoStandards");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "8f5c1a84-1099-48a9-9c23-878bdd1a6452");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "26262090-00ec-41b8-93cf-9c73f489d094");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "18649954-0788-44a9-a4e1-5a7e1ee6edfa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "487d90ee-e5a3-4fed-8f14-e0ce65f55719");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "4041aa7a-b301-4804-a1ee-9778c88a305a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "d6009685-0b6a-4f4a-9406-8801d0f7237f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "deddc1be-09bc-4101-ab8d-bd80d5192f27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "16f73dbf-71d4-4f1b-b70c-073c469332e4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "bec82718-83cb-4216-a346-5fc779678d88");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "121d7511-6a87-4443-92fa-f2872e9f8506");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "05e04898-3396-4793-a8a0-30adfe65f480");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "f46cae6f-d1b4-48dd-ac77-36bf9cbd92f8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "6c6e2ddd-1f61-47c4-a1c5-d1abc0ace372");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "22789743-e49f-4116-bbbf-21d7e391b86e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "14d195a6-9f37-4bde-baa1-d62a01f36946");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "2af1dfe0-486f-4e2e-9d2d-ff006c05ae39");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "ecbfd8cc-b1d4-4268-b372-9749c5960803");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "f6397df8-365d-4d31-9836-de720e066951");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "0cbb5fba-4a0f-423b-bedc-c189e9f083ce");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5f10d9e-8bb4-4b99-ad48-f6548770b369", "AQAAAAIAAYagAAAAEBXnZgVKFGzUr1EMyBN0LVWk3GX8DT6CglNCPj5yPn5c3M6Y9fkFpL+zCTKQ8rl3zQ==", "102f7eb2-680a-436d-a35d-3f0e9ae41c4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4947d16-7ba9-4bc0-b400-c3baaddf5f4e", "AQAAAAIAAYagAAAAEM0GGvnScOjKpTlom1DF55VkH5kycXZ+ymdgo9MfbH8kO4fbs6qTUnlD/KZWV6b5JA==", "58653066-2f7a-4190-a0e6-68ba9aefe349" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "595fa6a7-6b30-4590-83b8-ae5f8346edd6", "AQAAAAIAAYagAAAAEJ3tSmkTZavUbA7urE+Q9uyekQHoWf7jn7ydOI+1KK1goaq52pK2ehKddAS0ACsBfw==", "898652c3-9e41-4f76-bd0c-d16ab234ef78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55bd99a3-f28c-4dcb-873f-11b4c3b57a2b", "AQAAAAIAAYagAAAAEL8RiOaXHNU+W2dEDnOVL3+CVC5+sx5BtUz10aSOlz6uO6RL6xm24SZLaTW/5OCbFA==", "58c2a868-c98b-4f3c-bb65-e40a0d91ee28" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ed66ce1-e8ee-4aac-85b1-b974255ef589", "AQAAAAIAAYagAAAAEP6XKifg7OR0hAwN7kf8ALMK3+u8YGDatTPdxoHJPttAIV9Qec9y2BCq2fRSVM3tZw==", "37421067-1b50-4fca-967a-f1ec0c39c4ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ec8100b-7651-4426-ab98-5f11a91a7166", "AQAAAAIAAYagAAAAEO1FCrkBIUQ7jE0CVA0HJ31GAPe96ljUe3XhrLVI364cro1PYlZ/I8H2CtPz4+llMQ==", "fbc7c2e3-63ac-4a62-b736-3c10ca065266" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "427d764d-3b8b-4875-8411-0481d94d80e6", "AQAAAAIAAYagAAAAENzRMkd8kYzZXdN+QHc+kkwe4rFCl8iUPCg4lI9iSM4mGkSnJCVyi/7FVosrLDdVUg==", "c36f9e42-0ddd-47cc-8f2c-2a95c349dff6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "34918a8e-9c28-41dd-a5c3-4b68eb4c3e7b", "AQAAAAIAAYagAAAAEIDw3bfUM4sZNc99uUrtrMRa2DCs3sBzj2xM8xMlX9jnS66VTrHIeCzybmMs7yntuQ==", "ad150e92-1293-48c7-8565-0e79a6ef8a88" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18909fdd-286c-40d1-a20d-aae63d1bbb8f", "AQAAAAIAAYagAAAAEF0vFOnw9Mj2EheiFXDacpu1U5xroNyxwNKISjgIANQTuuBYclxaBHqd/dMAdka3JA==", "39966fe5-cf31-4570-9ebf-39dac4c93391" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "32b28cbf-6935-4243-b8a3-74a0d93f1038", "AQAAAAIAAYagAAAAEIDfC4yQdZ5ffAV9Me8ReSN4CF/II/UkuchTokWuveie1shV2irDFuEgC9qZ+T+iCQ==", "9011c600-9dc8-45ad-b55b-3e054295a164" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6742d8fc-bfa2-4876-96de-f44d6651d56b", "AQAAAAIAAYagAAAAEHPzjgX5Wi19THyMorRh3MZZoD7faHe36Lh3FxbdDUGr7qMnSMeQz81ioIkW+tphDg==", "2334484c-ca64-40a0-b068-42990c253378" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47223767-94a4-4c41-9c41-f1bac555b8dd", "AQAAAAIAAYagAAAAEFU3NRDgvF3noqxrqghohCSOM2AZvj0wEVPvNArUYMJ/V3GyNYLRzfy749RRc1ts3A==", "0324deab-5b84-4d7c-9c43-eebeb64614b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dad889c0-680b-4d36-a6bd-678be47adc1c", "AQAAAAIAAYagAAAAEM7r6PlwtbdDpnabwGD/csI3Od+fQnyOQspS376j1RiTiV+jPfv/vcO2YWlePKyI0A==", "fd19d6e2-54c2-4901-8b9b-8b0db29aa49e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0cf20b1-6193-441d-a9da-fa614e81dcae", "AQAAAAIAAYagAAAAEF4C5/QEwMzJgdf8ZCcaOM/q7u7sp7iivT4I1aXcFsqNXmffQ+RUacbqOpzWG7faCA==", "0bdf5a49-eed3-46bc-933d-5582a9b1a601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac68c6d4-c52d-460d-8339-90df3fabb8ad", "AQAAAAIAAYagAAAAENHVCh663VUDkX57ePssR2jHsZ9rnpHe+oT8kK4Qx/e+xNLw1f2m2H1AW+eXjniJLA==", "9d8421cd-18b1-44c0-90bc-dd13e67dbe66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca410192-38c0-4d18-af3c-b4386b29511c", "AQAAAAIAAYagAAAAEIvdDtFipyUpbj9rjWYXjkDrfZQOQRCGlqXYXQVplGj1f7e/+Th90sEyPju1UCqxEA==", "3fb5fa0e-7590-44a3-a9c0-7e57669432e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb3a67ac-e877-42e1-a8df-d077df8e3411", "AQAAAAIAAYagAAAAEPS5ixHLQTrJUF27ZZ7ArGXB2sbjwuMyczm3P85i69/FjRNJsStj1Kp9Gimso2w+dw==", "a59f4335-75ae-40d2-acc2-6092d9a8f702" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8b7527b-981e-4c9c-8264-30e4983a102e", "AQAAAAIAAYagAAAAEFXnb5D1GY2NWDnuPHAg4CNo3O9qN+35Vkyw82QDcx2UbQpCsYdIQfsCX3onKyXBJA==", "0353e040-0d4c-47ea-af01-d7ecf799d220" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1008a3ea-acf9-4e78-a9da-d679c132d156", "AQAAAAIAAYagAAAAEHdkVLKabX45doGH5+K2RJJMc5Qj3I47NqMfRlSu0GrDZVhkjPVhmu3fYJCHd98B1w==", "c05be6eb-eafa-4a27-a664-ce7137326997" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a88140c4-6d6f-49b2-9178-d00e1ab835be", "AQAAAAIAAYagAAAAEBub6gRLnNdOPYcrWOqkhSeI0SIle9baWQtw9Th24oxvyCMrOTDbYaBhUL1Lk3M/9A==", "201071d0-9fd8-44e9-9424-d1c59aa6523b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6fa42446-9d58-4098-b7f7-2640f7225ef8", "AQAAAAIAAYagAAAAEHLyuRmOn5mS43pKSf+jOO6v8TWfI7/G6ZpzUaPPQlbM1o7AXgyluv+2rSuvxtdROQ==", "064ade85-721c-4bc9-818f-0248165e9bbd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "43391b17-7b98-4b61-835d-0364bf665f1b", "AQAAAAIAAYagAAAAEH67BB69cGF3AYJNwaotmolB0YDd0AyfNOJNHskpNIu1CUTzNGaLVkA6AxA7Q5uBYQ==", "42034372-d15f-413d-b964-31efb67f5d71" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9af41f02-8870-4487-88b4-e64b4024a9fd", "AQAAAAIAAYagAAAAENw++Gp9bDzWClAjaGjoRYHP+7G+AA99sal8Bfg3oeR2LVCMPC7xjmHQI3cViEjang==", "81f4d097-c729-41ad-ab04-ec80b1c9530e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "179b78bc-c9de-47bc-aa1b-7d1e7b3aee9d", "AQAAAAIAAYagAAAAEDGVBsQdfsMVFfStuVOgo4TtdG0Qn6Fi5gMIvDPZxhFpqmNJUqxaul+OYBfo/R2JNQ==", "63a899aa-310b-4641-8acd-d16fb41d6316" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d15402bc-7ae8-4068-8ad7-ff643e32df87", "AQAAAAIAAYagAAAAEBMQ4OZ7vxtK39epjKP/4ZGMa+d11UzLE8moak/UjmfOpQs1X8qBeqb3KsY7OWJf9g==", "5062a56b-876c-479e-8657-189846749493" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c43d49fd-bda1-4ab8-b003-818e84b874a0", "AQAAAAIAAYagAAAAEJOccJbk4h27XYFS7snJM6v0N8ogfC6lOlW7LvR3Ut6Xf5eHm2Y8sEpDuSNlFX1pSQ==", "d677b687-8222-4c36-96c0-8bea9edf0dc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52e34aeb-55ac-4c47-9f0d-8b41591fca2c", "AQAAAAIAAYagAAAAEPPxfR7ffoQ1pC13EuXSC3p2RkD4JX+yvStLv1S2+6OwmZ39F/9T9Ip4U7GZDCIWjA==", "cb463006-e5e3-4729-a3d5-a5e679bb853f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2dd54489-4bbc-4217-b0dd-67b4a74dede6", "AQAAAAIAAYagAAAAEB8CKgnhzbJ/W2S1YRjMJ+D89082pp51crGS+cgNk4vh48dlJYmvJZ1f+3OxiV0eGQ==", "70e17be6-4f43-487b-943a-bc872ace28ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0975b398-c551-4bea-87c7-00e898c253e8", "AQAAAAIAAYagAAAAEAlM9jEWhN3LVzhvWU79WP/NMB8K3KymNEgGW//i+vSesTY5wZfj5LTh2HZ3Q4mn6w==", "94bee4b2-368f-493d-be35-c5a14b67d95d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7362d3b3-f0f3-4d67-bb79-2ba1b9688766", "AQAAAAIAAYagAAAAEO2SHNYuJ4oVDkKSpeRx0SV8PzOWuIDYCNnpLWAFokhxh/m5tBnh2m/bqwjJU7M67A==", "d1a0cfdf-32fd-41ab-bfb9-bd52d4d65ab8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "956b27e6-7b1e-4400-abd9-add11234a25c", "AQAAAAIAAYagAAAAEKFYSL3TiDMe3WH/hfFhVjbb/TIu1iRjk7UBqy+vm7wiqjQxqKLDZ1SXEEgAY6Eg9w==", "7f78f9ed-5220-430f-95c1-64aca8004ec6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0fe20b7-219b-4cb5-b264-08f325c588ad", "AQAAAAIAAYagAAAAEBnN4Z8uVeL7hvsfkwQ6J5w4lIA1PAA1hVL6rBRmIfqrlxrfYj31Wanog6ScGwCnGQ==", "e98bbe44-5fb6-47d4-b17d-4fe11819af62" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6bf26eaa-b0b5-4238-a11e-d0fc15074b89", "AQAAAAIAAYagAAAAEJ1e4sBZaNeiUPyj40q//2SgMYJzBeVVUsIi+jmg6v9oVUyStu0h1dsMi7EL5yxr0g==", "158be911-5554-4ae1-9273-e80d2b5ef58b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de7c6c02-731d-4924-80f5-d210456d980f", "AQAAAAIAAYagAAAAEFW0Dk2vt4FZyZP4Y3iyyK4S/rIHrhMpFmG/09se2Rb+gT6PZLTeqmwy9ysuA0yiUw==", "acfcab97-0ea7-4a98-a1d9-a7581483b59c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbed981c-9e28-48ef-9389-d1c0596b4fcb", "AQAAAAIAAYagAAAAEOtNJtZ/sU+adpUTT9ugkGQ72pSWgx2jkZMAHAWejy4YpIiIRY+jd1plD0mXYRehDQ==", "b13fae59-0199-48fc-a6bb-42f949cf90ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89f559d7-b1a3-4318-b8b4-aabe3b2e604e", "AQAAAAIAAYagAAAAEFF6VX/l4zVmTr4m3LeYUz2D8A92QDq6BYAbwYtlcR1N8kWFCl1l7R4TE+OpWoI8zA==", "1b3d5836-8416-4733-a3fd-b8451dc6a1cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f8fd15f-5f04-4714-9501-178790ba34f2", "AQAAAAIAAYagAAAAEGkuPbOimn5c8hRUaQIve5PvJbW+4ot0NgMgNILWhij3z7DO/GInFJ5cD4SPSyWUjQ==", "b4e03eb4-1ee6-4a97-a101-ed3638457be0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7dcf31b-fe53-4c2c-92ea-788b826d2d25", "AQAAAAIAAYagAAAAEJen8hKev1ip8c4/BirGJWVS+b/1ZRlp0gJNQVk/gxVHmADGjT1/nSfZr9tLxyGWIA==", "bce63be1-e2c0-4948-9236-1cfce90e9470" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33554b1a-71db-4092-ab56-edc609e245fd", "AQAAAAIAAYagAAAAEFasI2nHt+RZ4Z8iIUjzqsdeeiFI6FmDnWsT5YdP6h3wBkPj/a7rZawBLO1SYOUx2g==", "0ad620bf-f852-4105-a04b-4b55ab592cc3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "16042d9c-12de-451f-8c90-cc1c116a43fb", "AQAAAAIAAYagAAAAEGLNpICz1u+CMVUqNuieiQ9SfmJnEp0ROoNxCXrSpTdfe7lCdijqULgsmABUQvjeMg==", "13ba2d43-519b-4220-87ef-f48334fa2c81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5046a98-e8c9-44bb-a193-565fc40c9de4", "AQAAAAIAAYagAAAAEMZAMNoyHX+JfdboOQErfSnlNkyeILelsjcqzPkHvTvUYGfJgxcdgFMTP/FBtYGbvQ==", "60f8b1cf-c769-415b-9f1c-9c620ce2e814" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb93b3ef-3163-443d-907d-15e09f859c54", "AQAAAAIAAYagAAAAELYVeEKmCUvPcvtqh93cPZQfNcvwblQaGgrwduBRR/OI7lrh0xLQZIwxOSdP5fRQWw==", "e6a8040a-a459-47de-864a-6cd0656b461d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "530d74a5-2e5c-4d25-abe5-e5a904765496", "AQAAAAIAAYagAAAAEBrofSLHHrQU6AIosZjs6Ax2/hzL+Itj8SkvfTbaZw8bW7Se4lGovBrCxUcz3ATt7Q==", "7e0fd771-a6d2-4bb2-b40b-a44866f6c6cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d44fb779-4495-47d0-95c3-ea2662d4d104", "AQAAAAIAAYagAAAAEDFfwDP8BRUgdmPA/xNFWPtBhXwZcpeyxAa5gxf86C2sXqxcha79KwQmDj5GpoIvKQ==", "b809a2f3-b536-48a2-a179-233c2536abbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8648f42c-f89d-4341-afe5-024d28d32b6c", "AQAAAAIAAYagAAAAEAUrBaO28zmWn8i7Kp0rWaRSp03diY8kX/tYypdy25pb2HwUGMrcc7EadHN0d0B6eA==", "380fcb72-d5db-4ac5-a984-933906b606b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "483a5d98-f5a1-4c1e-b1a4-d0dd1b495870", "AQAAAAIAAYagAAAAECUAldzHRinoOSZXh/qd6idYda0SsLmu0JYIrXBjAT80YoGt9R9LH+dvWg4Os607tA==", "0395bb76-348a-4224-a8c6-71a3a56359b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc1623d8-0094-4fe5-97c3-a654486e15cc", "AQAAAAIAAYagAAAAEF9ovW6hUnyvd/fqP7nYTpG3JaSHhtZ2/HxTWW8tzj4UuuApmme/eGVbbkPDiDLaog==", "0b4379d8-34bd-4ef3-8db5-2d92cfbb094e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a990e3f-66ec-4581-89dd-5b287eef5d6b", "AQAAAAIAAYagAAAAEB6CkOURd95WYi2XEifPKsNhOh82MlIq9PgWUc3xAT6HWOcYs33GoNaqjyLlwBweQw==", "1ea6db97-4119-4615-921e-28e35c4cd4a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67e8d0dd-3543-4d88-bc16-a130a7226fe6", "AQAAAAIAAYagAAAAEDtK8iqBQwNXFyjuhpmPzdKtzF2D7fFFtp6JZsMSbb0Um8Sjdo9juIRBroiONkjYfQ==", "9f27ca75-649c-41c5-9577-cd898c3ee783" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "555c6bb4-9493-4c8e-b7f7-037e59434c39", "AQAAAAIAAYagAAAAENSHvW5G/x4Np6X4hHUHSxB8qpN6uqAAtMJblEnOXlkWylHJ1BXw8Db67+oEUuWGBQ==", "04a87b41-ae65-4bb1-9a00-8ce3cd2fcc94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b8a22e5-60e5-4d43-8da7-ee35ccdd5425", "AQAAAAIAAYagAAAAEO8HZfC43ypQHoGWrm+YprWcX3JATX5UPH9tCAiKP8Q1z7hiAieegS/4Jy8dcVy8zw==", "cada9d10-94f5-4f9e-918f-6bd073c82fcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49cb6aa4-b974-433b-8e77-15170ef3b13e", "AQAAAAIAAYagAAAAELrqZB9AdUotOP4JqVqle4SloiVOae3LjBtoYIyZPYknkwDs8Z7CaV3WlfV+0laZhA==", "42b94963-b79a-46b0-91b3-3bb914d1a991" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7bae109-49b7-4849-9c7d-8ccb7aaef6f4", "AQAAAAIAAYagAAAAEFGd+0G5D35BPU4Co2nqIfuagxXJUrhvQJ2gj3j7+gZWNcmYtAwF6DEKH+QOTChWLQ==", "232efa13-d756-40f3-b4f8-26066ab79924" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "064e9d7a-b13b-410d-8ce9-5573da633a4f", "AQAAAAIAAYagAAAAEM0lEPBJA9jMkZShEo86aE9yv+yhsErE9aFS+95Y/iEt8DZ67W231SeJFJre0qfb2g==", "6a1a479a-95dc-4d72-af27-6375862e1c71" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0338099-2462-4e8e-a200-f1ce4cda36be", "AQAAAAIAAYagAAAAEBV7l9XrDg8xwv3N1WYmzuSKBkCLfDKqTvDIpzzoJlXf/LjoK/PCGcprxz9hjGeCQQ==", "e7282caa-1c34-41b1-b93f-9e9a93ff01bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eaf92247-dd3f-41de-9c4d-c60662a6e4d7", "AQAAAAIAAYagAAAAEGdqyMKKg0eZ+A5SlCGS84eUJwPsmFVcVGBV1KWcOFmmnNe8KsTOMm72F6GOUXH3Rw==", "8fddb38f-4cd2-4c57-9553-3ee4dd9dffdf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "580a3cbf-b674-456b-a54f-4d2c21c278e1", "AQAAAAIAAYagAAAAEAJGSU407SaIiy1dxK0Z+Odh9gg20L6FiiNEkyUL7eVSQj9IwnKQXp7AClZVVTP6HQ==", "34569fa8-8467-4166-abdd-15c2c217a2df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7b48760-2676-4b5d-8564-6955ba961805", "AQAAAAIAAYagAAAAEK1FfFli6F+o06Z4lXXFArpa2iZFNWvStazMJ+SlY70cr8pJLRc0Qhp5s5Tv+8fCuQ==", "ac00373f-8871-4fc6-8e74-030404c03726" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f369bd02-d168-4aa6-a69f-2a9a3524a3e3", "AQAAAAIAAYagAAAAEBj1zZflwQkuUO2qe53mv0/3RR9jwyTR7LA7G9h9p2eM156P8N514o7O2MHVj2Adug==", "70e09a22-d0ad-49b4-8cbf-4a04c780d795" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a98b916e-0c83-4007-b29d-394f06258e7c", "AQAAAAIAAYagAAAAENmd3TRUaojej5xsLw1yDSnyPlr2MaqkMVcLmKnrpmfgVscCj6cP/Y7AzphKYJD0lA==", "8dd90b4b-bfa9-4876-9cad-50341ba002ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a16c70a1-cb8b-4023-b0eb-868dc6039d5f", "AQAAAAIAAYagAAAAEGxPVbsu5eibZFWLj+l/4M5iKm/a/NsY48gtZgZXPYd9VnQoMnWtpRe+5L361oSl4Q==", "78ed1344-4768-4939-ac9e-8bb30d4207ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddc45bd5-c6fc-4c2f-a0cc-c046b93068ca", "AQAAAAIAAYagAAAAEBIWB1woJF+/0VrVdlSmongYtljkMgYTbPqY7gJl3h00TrUxpUs6bpo1MgNmxBD7zg==", "698dfbcf-1741-433e-b2b6-45ee7902edf6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d7458a0-3bb2-41de-890e-15ff34353091", "AQAAAAIAAYagAAAAEFB5LeNCOd2K0++2nGcV7ekPfvi213xM5WLxJksks5FPygv21Q0rA8JTqqcLkdis/g==", "44350d9f-d54c-49c4-9ecc-028eaf7fc849" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "096c0233-67e0-4048-a29e-5cac05e4ba42", "AQAAAAIAAYagAAAAEBLqEWKh5KllSnwPiNUphKzfdBXyAw1kXOfRF3B8nEY3DN/CesOkFypRs+ihauT1KA==", "b16a919c-8876-4480-8bb5-d235f93e71f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33255a1b-bbe0-4064-99ee-9343531cc7c7", "AQAAAAIAAYagAAAAEBtzbFBeTDASdvdY/fMOOCZmkR2s4igL3MwjcTq+EJcEy2puMxEZEhEVU8nGgYXEUg==", "47c5c3be-8ea8-4905-a046-9cf28a9a2224" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e828d19f-e188-40e4-b426-ecb147215c65", "AQAAAAIAAYagAAAAEMxOUuS/t9oh1DraaW7nupAQhiTFc8JOuaBMYsO47FWu8ymGTKMgkChNoliRcCAXHQ==", "c1100bb0-e6c1-4a6f-b80d-3365c57f00ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5fedfe6-fc81-48fc-bcf5-72aad3d1e400", "AQAAAAIAAYagAAAAEPrhtDpbLoYRKJ77zo5xAcsK6RBvWvHZ54w5R5Rnjo1cV/sANjHnONERAfMHwXf9fQ==", "eeb066c2-a4c6-4ae7-b4e2-c55aaa0e9aef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d052f23-531f-478b-9ee7-324152a89507", "AQAAAAIAAYagAAAAECXGQiwg3ug69wSG1ZZYMXGj2xMONxxzP/Btyhk4qfUXxzgxAqlIiuMeg7PDYAtQpw==", "826328e0-190e-473e-a250-83f7a9d7dcf9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a8863a8-fd13-4f6d-ac25-4fc5ec9d7621", "AQAAAAIAAYagAAAAELcwgo1FKaUdHCHhXi8U+2V59YlcXXH8r7BMo5OZYhi8xHk9Fdddvx1tAOpWbZzSeA==", "2acac7f2-5147-4bcf-be8e-531952087d31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "39fa8127-74e4-4711-bbe2-288b460600a8", "AQAAAAIAAYagAAAAEKtBNjdpkqlLTGAGrg2ZqgQpczlo9BeuD3ccX7F+ih4FGc4EpGRZbe0nsC4e3sMRKQ==", "8d6fbf7b-ff7c-4942-968a-8c382a9e0069" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25e0bc9e-c450-4299-94dd-3fd6697faa54", "AQAAAAIAAYagAAAAEIKooDJOLsfsdMwdYYuyXzKBB2U8ByjNd4unhIjqHVwwIyrdhTczcG8vr5UC0fimZQ==", "4c850113-2640-4e61-a222-0d84ed52877f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7b698d9-5c89-49d1-aef1-c9cd7a849100", "AQAAAAIAAYagAAAAEKkz1nXGAi1lkkNxfO9D/3S/iaeDl9t7TZtkA9ZeC95zPbviSbNVuXUz483CPFGVHg==", "02b2627b-4fd1-47af-9aac-0f1dfbd34e62" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5709ed3c-770a-4ad1-8d7e-03711dafb144", "AQAAAAIAAYagAAAAEIHGeMo+hg/aUQuPolJQO0qZzrPl3CKnysVrKzyj38TgmIObfkE7B7oJyM5MQ0nigg==", "c9fb444a-b942-4642-bb41-198a6211eef9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0fc2315f-5b4b-4636-9388-0aa1723cb082", "AQAAAAIAAYagAAAAEG8w43V+ivlFgnFWh4KK4CGv8EbijJjBvuuOERuc/zIZoBJotlsx+OVTFVI5X3Ptlw==", "a1ca34a9-f844-4869-827e-25222d9bf0f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c80adeea-f11c-4933-81c0-de494680da52", "AQAAAAIAAYagAAAAEIgTSj6q05SRWTGircGXs0Hb7xf3p0TQoX5kFPgawyuBhcQtzv9hiBFthgxcvVHTqg==", "28679aa8-e980-4ac8-990d-299e4bec8841" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "203aa87a-6e6c-4b09-a337-a70b5bd3dc87", "AQAAAAIAAYagAAAAED1aEamAYlemH3UaC2n/MIwutZCHg9cNx0EtBrJ1SQhHRVyeT1turG1K3+B402GKNA==", "6358b8cf-b64b-4ced-a3fe-b3a2e7088faa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d96632e-811d-4f51-b151-84245768419d", "AQAAAAIAAYagAAAAEFrbrK6fouJ8FcnOt8wKJw41SCsh9oD64FI3we7Y0oYsxq2w7Vz6ZjuvWvfDCFsMfg==", "ae6ba45b-1f56-453b-acf8-0e04e1cd8355" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5baea490-6a11-44e3-baca-c007191b0cec", "AQAAAAIAAYagAAAAEHRW9+gOlDAUQnh7HY8QBK2hQN0BuOFywK55aaRjpxdphiEQAnhrlrVIlsGvU6WhOw==", "44cef9b5-a703-4cf9-a855-812acdc59124" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c22cec5f-3ac2-4f1a-943e-2dddc3d4390b", "AQAAAAIAAYagAAAAEAUCqK3402tMpi+oJlEmOLgKHUGySroK/MU+nDMX8NXiIjr49zeFhKwAExr10vY85A==", "7a243869-ea75-4eb7-9cb7-c85a14080de0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72d42d21-536e-4b98-a3c7-e5b3d6a91bb3", "AQAAAAIAAYagAAAAECLDBIHGLTxQP9WIGR+BLeaOt4X7Bdm04KnLubRcX7GjKtDYA6hnjK7LK+U02Ogllg==", "97f2066c-2032-47bf-be4a-ca45327a39df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "baee2e46-e6c2-4c3c-a316-c5406d604193", "AQAAAAIAAYagAAAAEOIeiZMNliVO3LnZuX4NTKPaY34Ec1e6K7ryIJjoxdl0oaXeeJBYqrMdcB0akCTBNg==", "f7a7b702-d92a-401b-9f7e-73ba6804811c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c1adca5-7138-4d20-bc62-7729aadb225d", "AQAAAAIAAYagAAAAEAlwwuvhEtS36m5UBCR93w9dnj+BE4oTdsApfXuM/WL0fZ/rTdq/WocYMZUcsduTYA==", "78c0a9a0-e790-4f4d-bc1d-8aa3b845fb2b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3640a05-cd4c-41bb-b2b1-75b4c931c2df", "AQAAAAIAAYagAAAAEMgr+usk7Jqi2ODrcSkLLzKQtALpZq3F3FkEGWgP307Hm9CjCbULUhDHD8o+O8/jdA==", "bcf1b74c-604b-4de5-913b-444b8b6471d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c74efda2-3009-485a-afd8-915b121e92d5", "AQAAAAIAAYagAAAAEFRoifFbCkJcZmh7TjyWkPiZ5mve/52vrSFxeJhuZNlHiky+ph4WvkXmpNRDUoZ8Og==", "2f3db081-2207-4d54-90f1-ad4b23b5a945" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "811c650a-612e-44f2-8228-9fa7983587d3", "AQAAAAIAAYagAAAAEHexbA2fRxtCE/10kMsu9iGRr5PWCrgyZDtrhjQUEAmRFBC1F7sruwLI2H/aeVgYKQ==", "c90b5de1-a5b1-4b19-8372-816f126dca5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9f16b125-06db-4dc5-a6b5-f41d3ea95b97", "AQAAAAIAAYagAAAAEEI0h8J3dGEs4TjOUUpEoE4tP4xNKC59T9YZ+x2cUF1vVCCkbkDfrzFEQcfrHFFIAw==", "97c8adfe-cb1e-42cf-bae1-4ec7d5ba1435" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c0ce475-dd2f-47d6-bc11-8a7f12d89d9e", "AQAAAAIAAYagAAAAEOfFZwaQMcMDcidmzvn5KHsPgOHeWU1WRV6Dpy7t5Z+HexLEixwAKNZLGXjccViDxg==", "07fc8266-acb9-4aad-a7b1-62e02827978d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd9a1e3d-2352-4ba6-9526-619efecd665b", "AQAAAAIAAYagAAAAENzvyTKiysrxiOgPoGLNaxKtAuST0c4y6SNms4nEneq5sh2rNXlLEbnvGlI2uKQigw==", "f053d270-9cda-4e55-a7b4-c56773662701" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0bc7830e-7d9a-43e4-96d2-790dbdb2cda0", "AQAAAAIAAYagAAAAEPBRQs0rmKRes3QI2LtsmQv8yVggtUBTjHiiE0hxLaCy7Sq0CxEJkF3Po3R579gsDg==", "9a21915e-a553-4bde-94ca-8a79743d7668" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48761705-57a3-42fd-8c2c-74f1ad7e73de", "AQAAAAIAAYagAAAAEH1Wed//wn4kbksbQ5YIY0YHuEvN+wBnpFgHAFsAqBBnWdQNj6bx1CFIoJCLXhYFjg==", "68f77994-c81f-43fd-8f69-849efd6e0232" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88e319ce-3558-4df9-975e-322a297104d3", "AQAAAAIAAYagAAAAEP5RtzTt9cZ4ZkTtKiQ7PDa82y7UrhOXseYYz97H4xPTfX30tx2FTatiN+UxpT1LJw==", "3300969f-b9aa-4983-9ce7-0686e855771e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b47cee3-067b-4a28-84c5-80603f1f1fcf", "AQAAAAIAAYagAAAAELMF4g8oCsIw5VmMQ5xurY3WzDA5em6w0jctrPan9zs6bCJKVL8x6egBFvOjs0B91A==", "3765eaf6-1e59-4e9e-ba1c-78297bec2279" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "431eb51e-2eec-4f47-8393-9f2cec4aaa14", "AQAAAAIAAYagAAAAEGzcwqQYNghhyAWi89+3AA/3ghwXMYBtmaE//kPQ1ffWe/KadTWoREHDRiVuQPtP0Q==", "2e19af1d-edc4-4767-a251-d84b7f420008" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08caa73d-ca2e-4c6d-87be-39d1832ab171", "AQAAAAIAAYagAAAAEFv8D/dOG6ez0MXBYabeGgRhTVb4lI0XyT0z12dOBSb5RmbGe7hVGh3Bg6/QxAvK/w==", "f8904ed1-8bfc-40c2-90c9-12fc256226bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0626d3ae-6622-4d80-b087-29c043791cd0", "AQAAAAIAAYagAAAAENJYTGyJOKtJdABtuWwFgyFpv5V3ms/lV+sP4ipwZ8UCMMpReuC8VIlYVzJNERxjpg==", "f81979b8-3161-4785-9cfe-d4a3757e5c06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09ef50b1-0cf9-4a47-8c49-980161f849d1", "AQAAAAIAAYagAAAAEC+rmT9JwYFmmn/SjdVskZYFcplDbcvNohiXR7xVL7JDgsFptAeUOxXwYJNWieZDWQ==", "ee9b96e5-bb2a-44e7-a4e4-b85857bd6323" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fef625d2-bad9-4481-b8c8-fe2313eb1ae1", "AQAAAAIAAYagAAAAED4P+GI06Iunj9AdcKyOQi1N78H3LA+BcSjC3TTwByF+2yP59oqAF7Z8Xp1HoQjAPw==", "97fbe3a0-25d6-45c4-9794-1060b3229174" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddaeb60d-86f2-4190-8875-03f012be2689", "AQAAAAIAAYagAAAAEIrat+aWLxmgBFscy9N79xVmcJi5i5NBTlqzm7pBH9YAHqPGaPyxjBlelBqEvU8d6A==", "b5193216-9690-4e77-85eb-47b5c31c9870" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96b9ca33-a993-4f0d-af4c-785fd04d12ba", "AQAAAAIAAYagAAAAECfLyehylTsI+8SId9sKA7fhWgkUuqAd0bUH70H/ArDal2+cvU2GSafSr5IL1QWHlA==", "d964c5ec-c0ee-410c-b784-8878e87229e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b43dbffc-45b7-4bfc-b592-ac902e07fce1", "AQAAAAIAAYagAAAAENYcHM6Y5HzrTVCVdviOtgSpuuOn4DrlyTSNSXsPxzNaV8m+J8ytRW0fAEy7HfzRbg==", "c7f0a1e3-8345-4ec1-9fdb-e329ba5fe662" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7075fb5-bf1f-4fba-8a83-b087a8a49a63", "AQAAAAIAAYagAAAAEMCBd3z80HD7hmBjqGLd1YxQhxzcTHPF7HeDd3YZr3opZCYVagmcf7WeL+r4xzwLLA==", "69f49e74-af80-4000-bab5-3b22ca3febeb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a62c072-5dad-4419-8f61-bf3d609e643a", "AQAAAAIAAYagAAAAELENglLON9T2xbcmose23z76YwN0XjN55SOT+Hxh0JbjtU/xVnMMHbVzONZfQJ0Z9A==", "a00c58d9-6d1e-4fd2-8a1a-8032e79f5571" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3feb846-6ace-4d92-ad41-96bd93ac54f0", "AQAAAAIAAYagAAAAEJ1/6lUshJTOHiR3dH9WWPERFAHkTqtSKJLD+tl2KGtXyDsli44RoyqfEiYmkAZKGQ==", "7e2c7126-2f9a-4896-bc9b-efcaef7840d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82386e9b-262c-43eb-a325-465ac0863e5d", "AQAAAAIAAYagAAAAEGN1FMqijvYdChj6a5nQbuFd8kPdxfE6YrkgJRBh9iVN9scVy1ZRxcI3bN5Sfnbo5g==", "ced1ed04-23f2-4d2a-947e-fe453c866ea4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "099b3cc4-e2d2-44d6-8d08-d49285725892", "AQAAAAIAAYagAAAAEO1L2wzqZf4w4cSaLvLrk0bBi/uUmvqSOuQHCCNEudjUnEnWOJNKz9gUSnkIGJuPCQ==", "0b4a344b-41b0-4a51-9577-3b7a53ebb219" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cac079a-d3b0-41c8-96d2-4ad8133fd856", "AQAAAAIAAYagAAAAEG2osoVJhKncStPRXguxiPB8Z+N1eF82HqwEfGhASpes8wImdDrjv3/SBhCk2QY24Q==", "e70aee63-2173-4257-b80f-40e3e5939794" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c272ff5-d160-4c74-bd34-f630d564b764", "AQAAAAIAAYagAAAAEHUYzmD5CYzk6lYrXxGu6kBMBDSICw8cvLBzp3RD0TZiZ1RAejyftidTUllkNe/kUg==", "2db34585-27fe-41a9-8d2d-95d469e4da61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ec22854-9ac4-4bb0-8361-63d7f8612f14", "AQAAAAIAAYagAAAAEG93Mx63mpUKoeZEB9ILxP9Lkh92betqqkdTKMeiC5mRUFCD6FuykdQ/TiRrvy9Lig==", "32a54d7e-8aa8-4690-99d0-333f30066465" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bba0ad8b-20b5-4ac9-af94-0a7692562604", "AQAAAAIAAYagAAAAEE65Mocs6j8nqEGYJErkgAKa+zvIq/SLSTYE+dnLlJAeDHVfOr/+HoTDvqyheCQJhg==", "eacf9db7-ba52-4d18-9331-3749dde5c36b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10ed3dea-296d-4a66-96be-ceafe9f0c21f", "AQAAAAIAAYagAAAAEAgRwvQlCOiRQ1B5mAce9rbYXE2tICPHsSgl891rB/0ujoeqK0UfXqf758P81Hq6FQ==", "d4487b79-91b3-4302-8b9d-b8ac6f532e8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6eed41e7-f20b-4919-a461-2d0cdf8136f5", "AQAAAAIAAYagAAAAEPFBzRLU1I6thD29+n+g9Odr2s01AFqOiGchsvEIeCGLy6cmotUjK4jMvSMtjL34wA==", "9ae06a70-4bcd-421f-aacf-4a84f7ab565e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a4f26a21-c96d-4385-a9dd-18a8d6bc67d7", "AQAAAAIAAYagAAAAEKie4AuXdsGdr/F4aUkNxm4J0kQ9T92U4jNkzjuKGSqcTsu64cz4ObJBfC+6nXFnFQ==", "afcf335b-663b-4566-bdc1-3eb7916b8c36" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5304f07d-6d88-4203-b197-2538ebafea98", "AQAAAAIAAYagAAAAEJEghj2PkzCmw8HKMn43dAbRsTqPmw+aFXm/Upk3uYgiEvfFyZIMlzRHS/0dlnfJqw==", "6fafb569-7498-404f-a223-81ff78109690" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dabb90a1-11f8-4daf-aa13-1edce7d28351", "AQAAAAIAAYagAAAAEOeTsxNoceyKWWfRe7R2qLcvRSIj/e5nCLB3MpLxX6MHTRjmWTvFPqbrijeYIb7dpg==", "0b9983f1-94d5-466e-a6d9-c267cb6a6ae7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99501b52-5fdd-4d53-a107-6855724c10e7", "AQAAAAIAAYagAAAAEHq5+fYY+jUw/D4CAKJXGxk5NSuhrrnxxFFwrVBPLPZnCKSikgmSigEeYL/k9OII8Q==", "63ef5a63-e367-4d7e-9408-13e6aa278d97" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f26775f1-c40a-4a79-8f78-b5ce0971626d", "AQAAAAIAAYagAAAAEC0VFZlu5iGcgX8qXU/2sxMRzV1Xym63c7Uv+XQk9lwf9Vcv6ZWA1KZn8BZFLjKWSw==", "299ec6f7-4f2c-4880-98cc-5ad2acf3cff8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "552f5e0c-3370-4a83-8ff6-dc9c920ea17e", "AQAAAAIAAYagAAAAEImLmKic1xzFNg+Twv9XZt7iMgoZkLzoRsKhUwPYEZYM3Nf9s14W9T2ncsk8ZtXBLg==", "2329523a-ec45-4f64-888b-8a4a7db61f54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1133c993-1bac-43c7-8d3b-7fa5b16d62e8", "AQAAAAIAAYagAAAAEOFdG+DBZcPE1CbBTzB+03TWHpFiGB8tHLa4p28kLBO15N2PS6xYczqYypTmpBLj1w==", "02652a4c-1609-4be4-a6cf-c672d1837297" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3b270b0-8c0a-4a07-acbe-b96314f01324", "AQAAAAIAAYagAAAAEG+2JrBqDy0jRP7eROkLIUVQQjbofKJ4EHLzlpWPZPKP37nJenfTWOrID/seb1fPWw==", "2327ddbf-6f7f-4e83-b48b-46cda0b7fac4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14415be0-7a15-476a-ba63-100de98442d4", "AQAAAAIAAYagAAAAEHQzLed9nEVnbToJjnU3mnBpRfClmMAs38v2kZd+hrx/QEWPVWqSOr0MpqREVfsGlQ==", "0ca5c345-7501-46ef-8fdc-e203282994e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "447f8ede-138c-4336-9745-76ea539951e1", "AQAAAAIAAYagAAAAEHXWP8gqgcdjsGmtsu8cR+HrXBHsmsNuH0pfve3lAZ31zlquK3b9rWFJPC0RUk4ZEQ==", "ffefb402-2bce-487d-9728-518a8792effc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3c813e1-bf16-465f-be45-6d7294eca8c5", "AQAAAAIAAYagAAAAEJIrj4XeA0Axw/UkUzWn9p+naWOmuv9ADDaXqOFjoJxLN8dsF+9hv8AWP3++X9SCBA==", "f9137d61-acf6-434d-882a-01701d30723c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb5e24b0-1ddf-4c0c-878a-df5cf3ecbf52", "AQAAAAIAAYagAAAAEBa6ycJbgWvtPV2KfLfSYHsu3pwzD/FCqAyxmKnHMgU6nq8GzoXQvz2nJe4NgHAEIw==", "1189f92d-e31e-4610-beb0-5ad23961553e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c86343a-cdab-4e3b-80e9-53daa5e11f87", "AQAAAAIAAYagAAAAENfMv8VbX2Vlq0Wo6FdE49nseEDl3jsH17Y6MVPWe6NlUZLqsdASuQlVJvKVh5Hdqw==", "14465022-9019-4ad6-8b14-be8878b16f82" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f2939cac-b29a-4625-aea2-2078ad1b56c7", "AQAAAAIAAYagAAAAEF5ILXnkZ4EbNc6rcGhkVtwZqGG5EYA5nE27IXrqhNsncTwDG4faz54OJOAW19D0Wg==", "7c00b0a8-b929-4d83-abb0-5e705db8b958" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c5dfe40-1ddc-4a17-94be-01aedb493279", "AQAAAAIAAYagAAAAEBB4IqCyfjozC+M8p6gk5hCuLbeng9UXn+SKMA/bYkJVby9/MczgrYSGX4CjIiJm1g==", "26efc043-acf0-407d-8f29-b52174c96325" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0ebcada-2fde-4b1e-8bf7-b67b0e232b8f", "AQAAAAIAAYagAAAAEHrI86phhTXgv3q+PxZy+6CXgR/SDWTA9aQlqCiCaMspLWNfZNnhyB8dcEj8DGD0bA==", "1f36f247-d229-4f4f-9466-64bf8441ec1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99e591e1-66e7-484b-85d6-a6c0f441961a", "AQAAAAIAAYagAAAAENH6LruZScnwk44mL8QyTIc1fXZ4S7Sm68FEqu1Jd59+YjarSZNxcPGZBIsP/D9e7g==", "29a96686-2e68-4e4d-872a-d3ea6204a92c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0205544-999f-4df5-8a41-1912b12300b7", "AQAAAAIAAYagAAAAEN/ibTx7gE5f2a93g60dzoQlwEifGrbkAILfY6TrjIeu2nhoHuhthYRLF1a5ICMRGg==", "d673966c-cb12-47aa-8455-0a746863a5ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47cbef61-028d-4e97-be29-476a9f5a71a3", "AQAAAAIAAYagAAAAEGr6FmJRphUVOFGNcWOV6JsjauInJcnz8uVMpIC/XlIZEgEOq6vz1jLAseypHe62Lw==", "27e9cd3e-b4f5-4a75-9265-a9605a24004f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "521773bb-483d-432b-8d7a-96dd360599dd", "AQAAAAIAAYagAAAAEKR5+E3E/UGNyikHErDLyygAmKGl4QStJtUuLgNe6TpB00qKuaYoXSF4bkB/AiKi7Q==", "12a5aad3-e640-4c5c-97b8-7dff5e339fcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51efb7ff-c40e-4aab-bf90-ebc29b3e79ba", "AQAAAAIAAYagAAAAENGR/ol4bxPFCW45vNyeS6Q4fhFxHUAZJAsUrzpkpqkVy+CrESl1Y+h4bI5K9hOTCg==", "2daf757b-f3f6-4590-9b11-78258b1c4f96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "289da3bf-e78f-4399-ba67-b0c3982f9892", "AQAAAAIAAYagAAAAEP/BwuYZXu1N7o10sDiLafY3M6GJjalTyfbTm7RQ/Boiz0Jhf1Pz5D0IZm7ery8sHA==", "4a290efb-7ed8-423b-b464-eb22d1a22a31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4680e4b2-8696-481f-8302-6c6df17159bc", "AQAAAAIAAYagAAAAEEn9aFlLlfzmX/qwTgEkjQNGyTI29USWCtvJXisQx04Tb2mKZ9nKuzcZxleJHfQBzw==", "d909ebe2-07ca-4056-8352-5929552adca9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "372d0bed-28af-4034-8e63-a1649f1a5853", "AQAAAAIAAYagAAAAEMOyASLL6g7wONurxWeTWHVbvhtfPW7mL1//ANAMQ2Ohx1YMbXFIyWDSAXOXe3pUOg==", "48915a25-f34d-4af3-a4b6-6b01805c5ce0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcb23e0f-33c0-4b4e-9ac5-1bd6567563f8", "AQAAAAIAAYagAAAAENIQGhW7wlDeZZI2qUzu1IX5BNTB28OP8unz4gb4LFMT2P5/qOe+9dgGlevoEgG8+w==", "d102fe9b-5f60-43d5-a6ac-9754b16f79be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89f0dccf-d8ef-44a3-8d7a-08670584cbc6", "AQAAAAIAAYagAAAAEIH3BRXzFHyiaslBYhJ369kKQxMBqIWI0zSwqM3T8nh75TP47fuQ9kNRXdcHzOc7Ew==", "837ef9f7-97ed-42d4-82c4-c2231e33407d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "672c87c3-fa9e-48bb-8a8c-57c3129512ab", "AQAAAAIAAYagAAAAEJ+reFMNRmkvWsw77N8y9Gydw/S6XiGV8tthY7b01bclEkQ3RMZCMzOvEuDXTOZGBQ==", "36a88d45-8677-454a-8545-3e38b59b7530" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38ab5efa-d905-4cc5-a5a6-3fce2e52feff", "AQAAAAIAAYagAAAAEPM3ZDgx7tBghamAnXdKBnqbBzojRlO+AeM4MfJUYs+fYuBJYaBI7t9bAzPbhD+5+Q==", "a32f5dce-6b10-4a66-9dbc-0c0d314d5bb8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8fffc28-5e10-4a22-9ce2-4f641f11b25d", "AQAAAAIAAYagAAAAEBuzUa3yPLUGEpGXCsQ6dEbyTDTM/3mCJN7Td1TzC3LCeu/G37RMcGKm0VnlZlSCMg==", "f2527f46-7ef8-4fa3-a04f-94d1fb4ff74b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0fba01d9-c01e-43b7-b92e-f814a32f6f02", "AQAAAAIAAYagAAAAEHA9NEp5rRQJgxJqCgROjFpZTNGVUmRglqRPnptdiD14dN+QewVHWXuJIAlBGvldVA==", "2f092852-8ebd-419d-91d0-69dce9bed66c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "403180f1-a72a-4e31-a5e4-40b908b38f89", "AQAAAAIAAYagAAAAEAIPzqN2BDl87IVLA+IPi8GytDNtWuXOMoyrH0BS6bPcWBH6nYhmd6gxOi20iKa5AQ==", "c3fb9b76-6dcf-408f-bf72-8b2e0d8805eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4eed3fec-7372-430c-b557-aa491ae52ed7", "AQAAAAIAAYagAAAAEHw1Cj+blwUUfrBgNA3v8Yl3RRMvLe/D+cgAipy2UnzxUPbt5xnGhGlf9vglBynxjQ==", "6b6b1169-87d2-4d73-bc23-3d2004d44338" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "41e0f1dc-d80f-4c52-a17c-826b6a31230f", "AQAAAAIAAYagAAAAECO5YLrPeGhj14HwW+Zrl9FcZSMfgx0r0vWTtJzHQDtRbhuTRZdkQ6KUFCPjV3SO+Q==", "caba6eb6-dd6d-4dad-ae86-1fc8ddf009da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74f87bbe-a9d6-4387-b18b-28ccb7c99a0a", "AQAAAAIAAYagAAAAEGpS2te+jOT0ZycMlS5FsFRqZYKg8ph5Ibvrr69PE3GgiJSgkUxqyjcKTTtVpxwpVg==", "d3c8799d-48f1-41a9-8811-cf970814bd2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81a5dd74-4084-4a2c-9b18-4e3612d8fe87", "AQAAAAIAAYagAAAAEIq3F0k5U8FIqTU6E981xGse9VO7NOfNccr93KSqUeLgi4Ix8eBgLETvI4MrrVG7kA==", "6c961629-c38b-4feb-bacc-d279bdf04f61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72c72841-7e67-445d-abb6-eea79c0b664b", "AQAAAAIAAYagAAAAEF73XGyBtJr4WaFCZr8DFwUGRMLb872BgG6a0jE9DkPSD+MtWuViA6zwrhQnzle/Zg==", "cc2eaab0-095d-4060-9217-01bd1cf889d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e4c9b09-c7c6-440b-b4ab-df39acc4d9ca", "AQAAAAIAAYagAAAAEIvGGlfszkX3kdWZJ3DMc07rky8r5Er2L31R2R+WXzHsRHyb/hZXJ7d91XIv3le3+w==", "28ef6e45-1013-49fd-9a78-fbb35cc8aebf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e097bcc0-4416-4fe8-b59e-261eff026ee9", "AQAAAAIAAYagAAAAEGrOqpVvLc0ULA8xW14rdArVxSn8H4IskFtVku06ofB3PtaseRS4gbgw1B/2xfh5lA==", "a9817f4f-635d-4efc-8489-fce31b19193f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2cfc9bc2-943c-4c37-af28-b31dc92f9882", "AQAAAAIAAYagAAAAEOdgXdzHghjZEPnR+hUMqzS+d4q48ynh/3iKa6yhkypaUycva45C/jWgoosWb67tiw==", "60339680-5e61-4874-8d4a-f26c69a96bf6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "919aaf01-848f-4775-b47d-803bea5843fe", "AQAAAAIAAYagAAAAEI5RKFO2cI8lzkhcD/E1U/ZrPLSLZxeiSFY36w7CotyUgtrCAoS0e67SJbbbqhoV4A==", "4351ebf2-f135-4d50-8ffa-1d2617aaabd8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c90fd7d6-bec0-421d-9f96-efb2c8bbcf78", "AQAAAAIAAYagAAAAEF1nE4FDdJKaxIx/lEbhQNyjjOReQAWHpxf0vym3LYU21BCpCaCC340SHHxmzqgzkw==", "88466803-850e-4bcd-86c5-daefe5c384a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3c27b83-1c1c-4fca-8aee-09dcf91a5461", "AQAAAAIAAYagAAAAEGaOSK59rw8obt9PnugsRHBQm0pC/37Zk2R6Ui5joQHSjY07k+XnWFtmoIZNV+A6Pg==", "f542d381-5d23-4d3a-97b3-6aa077bd2f92" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d25d0740-3962-479c-abd7-ece74101a741", "AQAAAAIAAYagAAAAEAECpy4lI2w+O6VQQMr0OvCOITEhCDpooxn4cmpwtA0sypojMVVS0jfcSl47BWLMug==", "c1c0f025-d66b-4e39-ba98-4fe7318ef955" });
        }
    }
}
