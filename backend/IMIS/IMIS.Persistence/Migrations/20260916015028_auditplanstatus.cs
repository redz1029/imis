using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class auditplanstatus : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId')
    ALTER TABLE [AuditPlans] DROP CONSTRAINT [FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId];
");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuditPlans_AuditPlanStatusId' AND object_id = OBJECT_ID('AuditPlans'))
    DROP INDEX [IX_AuditPlans_AuditPlanStatusId] ON [AuditPlans];
");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_AuditPlanStatus' AND parent_object_id = OBJECT_ID('AuditPlanStatus'))
    ALTER TABLE [AuditPlanStatus] DROP CONSTRAINT [PK_AuditPlanStatus];
");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = 'AuditPlanStatusId' AND Object_ID = Object_ID('AuditPlans'))
    ALTER TABLE [AuditPlans] DROP COLUMN [AuditPlanStatusId];
");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = 'PlanStatus' AND Object_ID = Object_ID('AuditPlans'))
    ALTER TABLE [AuditPlans] DROP COLUMN [PlanStatus];
");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditPlanStatus' AND schema_id = SCHEMA_ID('dbo'))
    EXEC sp_rename N'[dbo].[AuditPlanStatus]', N'AuditStatus', 'OBJECT';
ELSE IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditStatus' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE [dbo].[AuditStatus] (
        [Id] int NOT NULL IDENTITY(1,1),
        [Name] nvarchar(max) NOT NULL,
        [IsActive] bit NOT NULL,
        [IsDeleted] bit NOT NULL,
        [RowVersion] rowversion NULL
    );
END
");

            migrationBuilder.AddColumn<int>(
                name: "AuditStatusId",
                table: "AuditProgramme",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedDate",
                table: "AuditProgramme",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "LastModifiedDate",
                table: "AuditProgramme",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AuditStatusId",
                table: "AuditPlans",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "AuditStatus",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "SortOrder",
                table: "AuditStatus",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditStatus",
                table: "AuditStatus",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "AuditProgrammeStatusHistory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditProgrammeId = table.Column<int>(type: "int", nullable: false),
                    AuditStatusId = table.Column<int>(type: "int", nullable: false),
                    ChangedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditProgrammeStatusHistory", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditProgrammeStatusHistory_AuditProgramme_AuditProgrammeId",
                        column: x => x.AuditProgrammeId,
                        principalTable: "AuditProgramme",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AuditProgrammeStatusHistory_AuditStatus_AuditStatusId",
                        column: x => x.AuditStatusId,
                        principalTable: "AuditStatus",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "272d5212-0efc-4a08-9632-22ec690891ba");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "b7f32bb9-1cd9-44d7-9582-c3ed8c4e0d73");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "5c733182-153e-4aee-9693-d6d6799c19f1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "c8539ac9-b910-45d4-929b-edab297206d4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8c2b6610-acc8-4171-82e1-21106d4fc80c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "ea358bb0-895a-4b72-9038-839e991a2ffd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "d90513e0-725e-45e6-ae4d-889f291afbd8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "6506ef23-5666-459b-9c40-45d46549aa4d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "6040f6d4-8d38-497c-ba0a-9da69f9d9fe9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                column: "ConcurrencyStamp",
                value: "e299ab57-d224-439f-9155-7bb37817e73f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "717dd042-2e6f-4aeb-9ec2-a021b28ac16f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "1ccbe158-1b59-46a6-b4ee-68be023b08fa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "f978b6c6-e781-4854-a399-eeaa8f631413");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "899a29a9-228b-4030-9a28-cb74752a249a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "a0dd57fb-5615-462b-822e-9d3999385e5c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4b94b514-656a-482f-b368-b1f662afb525");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "2094aa07-c39b-467a-bf28-bd811fb77401");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "af98c6f6-287a-4cfb-9883-680a1efdd2b0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "2a10a59b-1afa-4cd6-bcaf-d7810a337a81");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "adc1a138-2865-4c03-8b51-11bd4635917a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "345c081d-0e46-47e7-a861-3c12fef5b1e5");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ed8d47d-171b-449a-838f-33b5ef364b67", "AQAAAAIAAYagAAAAEBIja4rL+A5EgXa5hC6vmDsachzsMXZIx7yg0uaiFN06CPP21sqma3AFPZW1lAPntg==", "055789c8-3199-480b-92c2-b4631144f833" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7d26c9a-ad24-470c-b2ba-d2f01237a825", "AQAAAAIAAYagAAAAEJtbYk/Y/1j4v1pAlPLQrccwE0GEd54ukMz32/E3jwRVEq2+QcLujueUwmCizAQuuA==", "8da285b0-489a-4cd5-bbbd-5f1596c07130" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e964ce41-9b51-48c0-9366-4173c1f16f47", "AQAAAAIAAYagAAAAEMTrE52AEQoTimuwSb8DAED09LxawEGNZMImU6ukudO2ftWP70k8GiAVhbxBOkA0hw==", "fd3ab259-bd03-4464-acb2-0cc84100b212" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f55ae4ab-ba5f-4619-ba5e-e36c625f0884", "AQAAAAIAAYagAAAAEHAKqepPjQ+DET9FQaG4J7Flp8oMzZsArMb3pZOUh2ZFoaBRDbJlc//hZKRn8sAwWg==", "d4f9ed44-5926-4d36-9b13-dcc9b5f0b706" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "772b3811-a996-4c97-918c-f6e630405bcb", "AQAAAAIAAYagAAAAEEqhtV0tNVlkagmSbmSQEIhxr2YgfJ6Oof7F2OAfqLM8knI5bM1E+krpjS9gXTtFWQ==", "8fbd7f40-bde7-48e8-b611-24494ff6d2fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7115b0c6-b85a-4194-bbb0-06531b64eb69", "AQAAAAIAAYagAAAAEHxQ/7nTo5PlcDVigcNZpzkVCQmS0kp/wMpLnljdPQP4Uwxc4AuE8En+VEzkMZwhyg==", "a0bcca5f-7180-4b1a-94cf-eb8c199854e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7a67b75-f87e-497a-a62d-a42c9703d5dd", "AQAAAAIAAYagAAAAEF6EacHusfYag23Q2iJbu6h3E8kpZm6VkCsMEhFdHeI/5vhdvYzs/wVVUPfHeEFJyA==", "66a9f024-5c79-4729-8901-2e0990eb4453" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01d2ed3e-d488-4f43-9ebd-117393592fc1", "AQAAAAIAAYagAAAAEKW91gUTnix1OlFT2N7o+raDUrVVk+ttxPmRpsZr9ByOlaPex58MhOW6n2Up6E9OfA==", "dd037a5b-9767-4a1e-a572-de4762b299c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48aab80c-ec91-497e-8e11-ea665c65dced", "AQAAAAIAAYagAAAAEHitydc2+kdnFlLc4MjybL0kP1hm2NM661BcDFioIZAY0c9nnsChHHUOLbvBU9r04g==", "161771c9-66ef-45cf-9827-8c99002a7b0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5eb3a20b-3ecb-4631-863d-5d1d23c6d622", "AQAAAAIAAYagAAAAENa6QwSyXJlmaMLzCxrGnN5ox4aN1qRa/gKBPyTm9LnYgbUDuFN4PajW3oDDTLkNOA==", "eebc726e-2e10-4069-8f29-460dcdd8d15d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c90097be-b7bb-48ac-a125-8997afe45f7e", "AQAAAAIAAYagAAAAEL9u2EFadeNOS2tJvr3MXTD36K7mnX+xFylNEW3MZUFy0EqsFaFCxkxCGw+azbLrBw==", "46ba264e-1e0f-4155-8010-c8a17aeeab03" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e79609d-04f6-42ba-990a-4275cc693288", "AQAAAAIAAYagAAAAEKsM4/F5dce15WmaxfXpsO0Tmlbk7Rw2FUifX4cnrC47Yh05E9V6BYrGC3OoT9oOLw==", "36197bc2-050c-4407-9ab4-39d980d16aa7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "129a1ac6-be52-4065-bfd5-eacb488d07ad", "AQAAAAIAAYagAAAAEFg2kLvJMf8EHBf93KZ3Yke+oUADpXJyrMLE/QWIGZDTJSSAiMpdvqZi2cLreXjYWQ==", "e3b83442-7def-4876-886a-1fdc379b70e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f277d88f-03d5-4113-960d-2f3a8d4729ee", "AQAAAAIAAYagAAAAEMRSujUj2SI+uiU8yMiRSQmVvcCV9mciwkVu7EzjELPFN7ZKfrlf7adyKQA6HFPSBA==", "857f7124-f72e-4f42-80f8-2078c06efbef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1695018-189b-440f-acaf-a28458a1973f", "AQAAAAIAAYagAAAAEKbXwQ0DpMnoq5yr0GihlfCA8eoxiNBB2+IUqWwQ/S9y336Acdk8ODxgLrXh6u895A==", "bc7593ca-e45a-41b0-b84d-b135675803c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "caa205a3-f2b5-4b67-9078-48a5a445e5e5", "AQAAAAIAAYagAAAAED9XoChusMHjnT/vfckLaRpP4ICfHkMLW/3PlrsWSUqH40kdDsjbC6qXklL4BXHLZw==", "5f38ec34-866e-447d-bec6-e310a1fb1ecf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "43870536-037c-407e-9aa0-a1eb1317030c", "AQAAAAIAAYagAAAAEBW6vzznvp9S7s0oFrsxEoNUycIwpRTfST/2tPR0NSCDNUjdC4OfQ4I11bMrIUF5uA==", "930811b7-d94d-4eca-b042-7581fef0eb11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b5104d0-3d8a-4ef0-935b-2f59eca9a6fd", "AQAAAAIAAYagAAAAEP+gizcPOssECHvk9FJcJnwG6FGxVE1iZ3lHVh5gaoif2NRRVE433c92G7/NCB2Bcg==", "8ccdf9fb-07ab-4027-967d-bc9eedc03eeb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d92128cd-3802-43f0-bd3d-f8845d78e39a", "AQAAAAIAAYagAAAAEH1UqwHXz7yzAY+tPyDhY2Ysfzk2Yq/3Y249KLgWu/pClzLGR/WaU3hkmBmQf2OSAA==", "fd8bb72a-a4ba-4953-bcaf-8377c9734cb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15baa893-17c1-4d32-8817-5ef3169495c2", "AQAAAAIAAYagAAAAELCLax6piqire+6xbCu8S0oS5W4oPBbO0BrAm7oZC91vve9C3eU/BORs4vllRIqurA==", "0acb47d0-ceab-4057-8d45-ea4cda3f7dc9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "259bfa31-0937-49ac-ae54-ae68482dc109", "AQAAAAIAAYagAAAAEHtBU7ubs1ZX2NtzXTJKdIbMHVFvId0mJnHRbIH+Kujw2CyxHdGvedv93LtXtZDQsw==", "b5c1834e-4e7d-4db1-880f-405f68fa2a63" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "285969d8-4f06-4e1e-a238-76bf2c2f94e2", "AQAAAAIAAYagAAAAEEzrMMAtCTQKGSW2APAIwNG4nM2OW7HnHM0mhZR2+cmz9Gm6z+LyauY9xruB5uYSyA==", "158690e4-680f-4447-b9cb-6084171eb601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aefd924c-6849-4068-9800-8da9a8db28e0", "AQAAAAIAAYagAAAAEOOYQ4Pc5m/tphj6Y7qvejwHz6rDw+tJGfmfG3WqEmMjQJ6jgh4clP0P5yNQAVVHcw==", "9de6cbeb-fd0f-4a58-ae7a-093fc258b9fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0cb84630-b83c-4b12-8a0e-68214555bbe6", "AQAAAAIAAYagAAAAENY6i0ho/5yF7bz9iDt7wSl9ccy8u41UomVr6zvyzKWNxf6BjhnBoOfm5/Z6MLKR8Q==", "859d8b97-a0ea-4716-a345-63f7d4fe3bec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "974a45e1-d167-4301-a544-4b03dda37466", "AQAAAAIAAYagAAAAEHYwu4pv1NbVbIbx1Kzfme498pMHG+tfNAsOQANoMLRmzVpqyRWhkIz+5ELYpSGg4Q==", "e58783fb-16e0-483a-a567-5152cf34cfcd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "810245ef-882f-4c22-b82d-7bbd3ae6600a", "AQAAAAIAAYagAAAAENksJzlaza4UW1ppPPVOMB4fmJLynxG2f4frOk2BCWDwjdXs4nrA08seSblu+OdK2w==", "1ac6c212-ab12-4196-8eaa-e8d3a16f9abe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1794a3c9-d0e7-4026-87d2-f38c0108c98c", "AQAAAAIAAYagAAAAEBtF5hBPzRtQ0HfGkJkdEv29GAq2XHLvzCG5qmNRDHB3CcDogf6tEvoNxgYmivuc7g==", "d6550b82-c6f1-4380-98bd-e22bed3e2bc8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f1f9843-11a9-4a0a-b647-8306cbb388a0", "AQAAAAIAAYagAAAAEObmoVosJK9rNr8fMBVaFkcp4eDNFehxyHDTsDiJL5PgAV5iBNZv6mOYtaNTrjYZYA==", "65d40435-467a-46bb-9dee-e4b2a760a8f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4069a375-fac4-4224-b7b9-51999aa8d40f", "AQAAAAIAAYagAAAAEI4p2B44jRyVgbOeLPfVMg2WnEWphZhOW41nogEyS8o48OT0vI5AUiyMcq3kq0xrfg==", "e392b857-8cee-4acd-b148-4517aec1207c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d145e252-cf9a-4161-a420-ec9ae8f9cd23", "AQAAAAIAAYagAAAAEByf0w54x6OIzXkvkCZgIR2IhIPAQw+olAacBfCXOWXH9tsT2WTtodUFhp+YxGskFA==", "c5de27b1-3e3b-4fa7-af99-d592f909358c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07daebd5-ae2a-44d1-b941-5058cc84548f", "AQAAAAIAAYagAAAAEGFqTDt0u0A9BMaedFs6WW0xVEBpbJ2S6eGKUeN6akPCUrTXjKi6x6+gEAmExM1kBw==", "624bdd01-b0bf-460b-8605-06d9bef30bbd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6f561f9-2997-4bb2-bb6b-704fd4e2963b", "AQAAAAIAAYagAAAAEMp6pPxbLHDctrzzcN2RR9T/5v4FP5u1TGlKeLG92O081z+mCM8AemXTJu5I4Qnzzg==", "2861bc67-a8e2-419c-b173-2f77a195f3b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "879416d3-6247-4b40-aaba-3b419d623504", "AQAAAAIAAYagAAAAEBmOsmeh9z+xpeMlWdYiRrHj1JwYJdkAxSU7VmJ/DEBnkwtttkOeqXXgpGYvumlIOA==", "df2d902e-d8e8-4a9d-a898-9a04bb7ac85e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3fd28ab6-6900-4f2c-ae88-213607b65b66", "AQAAAAIAAYagAAAAEKmdo5r0nNvtYQ23wgPhuaqodlG1Z4xb/Meq9hGGrHAr0BFlQIMOXfoxSkQNBwH/0w==", "c61616e7-fb60-44c9-9f18-17c5bcca3c0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "214f19da-7ed8-4ad3-94a0-ecee4225c452", "AQAAAAIAAYagAAAAEKcj8cf2tCePtqhfdlLxy7PReQ6pCMw8iqKGz+Zr96ViFiMPTyWjMmuHZ65Svp2SfA==", "b6d897a2-8340-4efa-a731-bfef4655157b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ee3a154-c721-42c2-980a-2464bc09f98e", "AQAAAAIAAYagAAAAEGRh88Vv5i0rIMUI4vz9t20bnNqEaV2MJ31Qx/tCIHVx09PhzvFXFEn1Y/EAhskmVg==", "dc6e29f9-d1fe-4ac7-bf9e-3774a28558df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96b57f1c-eab2-45c0-b6a3-0adac133a6f9", "AQAAAAIAAYagAAAAEMcq9pCTNukylSvbdhrmi6HHekPxSglIqNVEFT0ELoEEkVVs3QxcZ8Kfmh6+r8NheA==", "c2c47a7d-911e-4b80-a042-f8d87f14d601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ab50820-b4a2-4135-bac7-14e1200e4274", "AQAAAAIAAYagAAAAELJyDcR7uMTg2fjvqkgX3bbM4ttnjEebs7GhasF9o3JnJ4tBmmIhrpZTxyVw1NgMuQ==", "a0b7d351-3529-44a8-8c29-96170b071f5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f72fe80-012d-46d0-84fb-86c52174e13a", "AQAAAAIAAYagAAAAEOAzaZGpHgUbzu/O+XYVQYiOC/00UjHbEOx+GBggbwP7ONfrOGAPVjqOgblnI4ht3A==", "259c3d60-03ac-423d-8e66-f1c765287554" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c64669b9-4e35-4565-a2fc-e1c4017ddca8", "AQAAAAIAAYagAAAAEPGkPqUEnDtTOx6VcMbTHdcxUAFj2oHDYR6jrZFgcM/HTeQ1SuIkM4lTzpX3lDAN8w==", "f7ca011f-99a8-46bb-9c48-a9012ab7986f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f1e71c2-cddc-4b82-acc9-4b9a2f082500", "AQAAAAIAAYagAAAAEJqbFE8TnK9OVKk558WlJv0IMk00pKsdZTK9ILwY9ztPg1gmvA06uIr1MdUvdHuCbg==", "4fd80483-a9ec-4e34-985e-c5b83c3429a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6ad9294-7ada-4e4a-89b3-8356324ecf6a", "AQAAAAIAAYagAAAAEFiRnpxys0eiT2FpGShgS6q11sD+a6ifvStEJVsri80cWoYHCX8TnFq4cO2CDcBtnw==", "a64e3cbc-91ee-4e01-ad69-11c99e118bda" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "097bded0-7e3f-45c5-988b-cd9d688e3294", "AQAAAAIAAYagAAAAEFYAbwc7rnQNo7q235kB3sL6y1vjHvsNKL4YczXeEpxNB39NkOy4hawUHpv4hl00Cg==", "8b9d6335-b1d9-4a9c-a208-35c356811234" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a8eb1db-ffb6-4787-928c-38db3361ac07", "AQAAAAIAAYagAAAAEFB2dbKMgUr5YvEPBb7dfHPd6nZ13Cej2/hXOGJvX3hradGx8/L693wbz2wcH3PEmg==", "3381117d-4044-43ae-b54c-2ea1d13ace11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "783db998-08cc-4803-857b-aa3b3a2ef0ae", "AQAAAAIAAYagAAAAEHNqDvb3RUA7Bc479+Jz69a2AfTMo2pvMycxnvcLh+GtcKlWoHFC0rYYOtxU5P5l2w==", "197e1f39-f60f-494e-bf83-c74c7713e529" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f83791d9-1d5d-4a85-95fa-6dacb9aa09fd", "AQAAAAIAAYagAAAAEH9wvVeua9tfn4BffovQnWq31nHHEQQEphUXkqUMZMjj1u/G6dfbFCnYkCa1hp0Y3A==", "f571cd46-f02f-4ccb-81bf-c38253ff1347" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b091534c-e4a8-4b57-81a5-0b0ae4457c7e", "AQAAAAIAAYagAAAAECWmb4ng0N3j/wrDNhmHf0WjqNN6cnMIzGex6PZZpYkNyeyfH7b+QHqAazeNARqRfA==", "f1737c27-2507-40c2-96fb-a7017b2c7c28" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ef8a824-6973-410b-8846-ab2b0f50abd7", "AQAAAAIAAYagAAAAELy9ugNNaE2qeG8BdTCS3gVetnNJUlCu2qzglUTEZMU71oKD4YDBRO1wDFR+MXBP1Q==", "62876bf8-a54e-4ccc-ab76-03c534c8c03d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "feb047e1-78bb-459b-aea4-f9e4d7313bcc", "AQAAAAIAAYagAAAAEGpia8o/xAs50Gukd7bOON1jvpzfyOg22D+/FdrY6U0uj24LWFpHfwlBpHn1WaZNqw==", "d58d15c6-6cda-476d-9211-3336ce5cf84d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cda55e16-005c-4a08-b494-d607f2b139a5", "AQAAAAIAAYagAAAAEMYsT8Fe0epMePDVTnNcOCwcl79TFGTL3E279wS1441FGB4FArMQiyw0lOnSDu+e+g==", "7c62f027-72cd-4ff1-bb8b-2fcd1fce7b42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8332b430-2cc2-46eb-bac6-5e84d8f0a6b5", "AQAAAAIAAYagAAAAEMwm/7k7IzoEJb2jEQZMCvyNIIPBaHkW6kNOfSK1RBIZ9EOfoFwzkRp5UifkJlEa7A==", "c79b8588-61ba-470a-a9a1-d107c4266835" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38e69117-eead-46e2-80e1-46f6f2abc0dc", "AQAAAAIAAYagAAAAENLv4tp+Ap4ktgPrQhnbuDvnb1CJKHjaRdvF1vgzWPPzVQPyMfEboALPy7XbnPAayw==", "619c4766-32ae-4417-99cc-eb3164b35d57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d31e2a4-6dc7-48bb-8be1-acf9d82af424", "AQAAAAIAAYagAAAAEBLLVAN3w5U0R/7aMtRphTf9hZrqeNFrdFbR57WIbKI2e0fahplBci/WwZdvNZr4Xw==", "e99e372f-5c02-4fbb-8ea1-157974d5de50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6992fd6-45a9-43e2-ae2b-b3a1912d8ac2", "AQAAAAIAAYagAAAAEEfFeYjjZWXrRcJMfbaiDi1A2o8gzwAJ2Og+siqxuVY0yZkgU61iL+YHj8ZYJ4g5xw==", "5a12e83a-8839-4ddc-add3-1482db7b95e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82126d3b-31ca-4719-baa5-b2149d405c2a", "AQAAAAIAAYagAAAAENYh1No7Oh1S2vk+1Jjov2baK2wEnkanfj/hmjQOAKHlFIjINu/ylknFpp/go70diA==", "37e5b04d-dab8-4537-a4ca-fbe57ce19025" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "256f047a-633d-4640-b163-4420de375bcf", "AQAAAAIAAYagAAAAEEsli30EPNLkDUW0t3XmZ3UCPW94ys6DcwO06YeKj4QthWPTGVcrF6FuCBNmXyy30Q==", "96533619-73a3-49c2-a091-d6d9db3f307b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec33661b-dd8f-4dc7-b189-c425823bd23c", "AQAAAAIAAYagAAAAEEp6T5tUOEtxf6GfqqkN2NsFbKKgiUsjNYiL3W6FYHFjgMPmDS8KcUZqazysUdZ0Sw==", "d11a48ec-c32d-49cc-9235-1e6299b26ccd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bfec224d-f814-4e58-adce-e16287e29f85", "AQAAAAIAAYagAAAAEBGSoxgk3CEeAnoHGdpvhh4TuociBJ5stTEcZ/B9HDbMcqlDpffSkfgadlkUlkdHDQ==", "e7c81f8d-dbad-4c9f-b76c-ece7420abea9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a317e1e-8653-45f3-9f60-5b8a6d8162b3", "AQAAAAIAAYagAAAAECeuNhLkQ6ryXY/LIpdjmDfF7ir84eBeO1/9WVfcKmGxZWRTCb23OEP/sZ5zY+fzIw==", "1be32a92-8606-45d4-ad0e-3e59d476d527" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28d3bc8e-c8d9-4429-8f04-015840fba0ad", "AQAAAAIAAYagAAAAELIkAqRzn8dkhO3XtAnOkTAORhATbWs9QMXP/y2XAvOPmtrVbVAuQ/gZUD9IH4wpgg==", "ec2a845e-2fb4-4637-b5d1-707b2e59b180" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "088cd286-a516-497f-9a8e-5c257e8734b0", "AQAAAAIAAYagAAAAECrXg87twQNakLPsyrksFmAo+1h+XhffZGn0tBDpDLLyoDIZQYqL7R2b4+tbNq4Dpg==", "5a6d7eb7-6b6f-4c4c-9b94-9630dafdb953" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6453daee-e61a-419c-8621-27e9d03790e4", "AQAAAAIAAYagAAAAEK1dn8PYdpCj1M8CMNtma9GQNhXxm8bceV2pE8DMs7dxvJ5xZnCE81P1bFOw0MbyHw==", "2cf3451d-92a5-4a94-8c86-abd0a7cbe4b3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0911e5a-ca48-4af1-b815-ff646233386c", "AQAAAAIAAYagAAAAEBuFjuSNGvLHU0w/83lJL6hoGZj533Q6hLIOrgFUiRJ6ENQr3XJ7eaINKexP6aPE/Q==", "2bc1139c-2d4a-47d2-94db-23b907683446" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62ca42da-4673-4476-aaab-d70a63689c1c", "AQAAAAIAAYagAAAAEPfsKOvKEYDRh68iYWyORmQ15I+JZu5b35/ieMq7Pn2YNgZ1H6XBHYz1M9OoHaxpPw==", "228e22dc-dd9a-4f31-9fbd-3dd2922f115a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e59efd6-b5b0-424a-afa4-82e43564fdad", "AQAAAAIAAYagAAAAECmhYZVtVlrIOeojzI9WlFcDfJEo+wTYrLh1f7UP44lL/7TYwewyiYiCQ1NHSaew/w==", "d96afd79-2ec3-4e93-8132-1c3ef12bf3cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6b92ec6-c770-42ba-8671-dddbe9c50dee", "AQAAAAIAAYagAAAAEKN0l1zhNLROis4v7ivV6UWVG0ubmlV1grAV4b4iNDZ6vii2O/WSG476LOZGLcz96g==", "dcce5c20-1ca6-4231-b6cd-e7cc9c9139a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb6a095e-1e5b-43ed-9a86-5602720deeb2", "AQAAAAIAAYagAAAAEF4Dw/XnnXT1jqK0txneUrcvh+94jr42mrUj0m6yqEjobKtB1MvbC+8jeKYw6S2FNQ==", "5dccde6b-3608-4321-ba5e-88926ecd505a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ec27d7f-089c-4a48-8bf3-55d50af0a011", "AQAAAAIAAYagAAAAELzzCuQvlBFgzX2GuPQ5Fuw0zvK9OtDmbt7ang+BEgyd94ypJcj3FW2dcPP/a7OkZA==", "5bc7e29b-ee82-4123-aa1a-31d32ccce6d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de87ed77-753f-4e59-ad5c-c0261d4a55b5", "AQAAAAIAAYagAAAAEKhsgmR4E+jfAX+nDleHg/tpZWUQGyOLunHn5nHfcBsfkRQT/28H3bZ94tw2+73GDQ==", "17d7d48b-2d3f-4958-aa64-3bc68e35d476" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "628f24db-3e59-48ce-a670-74714a12fd70", "AQAAAAIAAYagAAAAED2+jXQZTmdlR94JJtGlnNSR6m2sx3+4m5v51qth1Q8O/9S9rRvAA2vG8qa6QgnwXg==", "22ce097c-07c3-4420-897d-e12bef7ef798" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c6bb9a6-edfb-4848-b7c8-d73ef6a39522", "AQAAAAIAAYagAAAAEMm030ry/7ysaq2atRjTY3Q2iNVHgZnYHGSkwb1K9eh0gGVNLA2KAjVANV81vFDteQ==", "e43a8b23-0949-42a4-83b2-5ac999ac19d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ecbde6d7-acfa-4ae1-b0e6-701d64c0bd01", "AQAAAAIAAYagAAAAEN5DEeqkKXgGaGb0tt9esa33pv2BjLJrdth0JbIGtEhTL6K6BJnHTWxYJXiE0leASg==", "618b245e-1bf1-4cdf-9650-72b948694f23" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "841c3c0c-300b-442e-b9a3-7125b5c4c1d4", "AQAAAAIAAYagAAAAEIjhnol43w/9PNAAFiw/3/TzgpbHUdBqQBMeVv7ZrD5RdBdKDp7IXIwHK4HlSw3MLg==", "17971eb0-85ec-4129-84e1-4fc6714daecd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67ff6217-3137-4988-a581-c744012c5f11", "AQAAAAIAAYagAAAAEK6SncVvCLFYFAIotq+GYnek630Lvl7qf40LgYutMpAhqPTi3lV2mE1iSCcoFlTG1Q==", "15c294ec-c675-4fa6-acb6-1d7399e4a918" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a0cd3b5-ae27-41c1-88d0-4663e50dadba", "AQAAAAIAAYagAAAAEMX1xDsE6iHVtZQtlpLjXML742BQNlI39dXu51ZV/Ghhf5XLDEOAUDoUGlHDAFZFbQ==", "01b3ae06-ee63-44d2-860a-8baf5bda34e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7989fbec-4d39-4e42-935b-678ccd5dd74d", "AQAAAAIAAYagAAAAEPfYJbLl3P9R6pYbjjg+ZHNWmqbCpuKUU9ACgL5wTkfV+DARjq92t4zJjPCusRhzuw==", "b8aaa322-44c7-4aaf-86c5-523b910e2ef5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "386b9fe8-2924-4221-9926-20ff4ff6a294", "AQAAAAIAAYagAAAAEJkqHfbssCLCNI2gqv460+hIRhqwa6FghcK7Mgm3HKcpZFOZ7u0b8t0zKjeGzzCW0g==", "dfb9b93e-1391-4dbb-9d34-53f2d009091f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2be636ba-b0dd-4e30-a1ae-c92ae1051725", "AQAAAAIAAYagAAAAEN0CUQ0rY7u8La+iRj+12X7B/r8hc3xiILYe/54qupDTLBmWYaGpJgyYh9bTHX3/tg==", "2f58596a-1bf0-402f-92f5-0302830e4a52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47dcbf32-6cc4-448a-be0c-9580aa7ae0ec", "AQAAAAIAAYagAAAAEGFDxeL4FgfZ8ATXpswpsx3gLeD1pjvmv5XE4dL30kW0ENelsfNCjC2Shp8LXhGZpA==", "587e5dfc-641c-430a-829a-7a468e6459de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4504a608-b523-4df6-ae29-1a0baabcb36a", "AQAAAAIAAYagAAAAEOKNnkwFRHsp9lQs8dYfKzepDdRxuh1yOb/dMTsdoxVUXnmLpBP1PLsDLc4DaFXmtA==", "9c53ba11-8ee0-4ccc-828a-6c6541dd4910" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "662a9ae0-91ed-4d00-a0b7-60c573c6a83a", "AQAAAAIAAYagAAAAEJGr5hX13b+jQbNGVnHjiaqZPA4BqVjc2cncCFet2Ad/c9TvaWUklrAjqxyQMT8N+w==", "2fac48e3-a766-4e1b-9949-2937a11c7f51" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40fe2c5c-b0ed-4bf1-bdf8-bbf632e10315", "AQAAAAIAAYagAAAAECASS8hIRw6BMFdzQYPM2KutjDQCGR16J4vDnY2WB1joEg74wIxTonXBs2dEpdPZLQ==", "af7a930f-758c-4e99-954d-7e92688a4782" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45b3a04e-dafa-4846-94eb-94a0473408ed", "AQAAAAIAAYagAAAAEPEyccWJ3HOfxziFclIcz9iF/ZOBcbBcSRNjuCsr5S1AcDX7Dk5xWZIay/VdyGfUPg==", "2bb8952c-106c-410f-8b59-8b3a5c142ff0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "454f1f93-10f1-4b3a-b3f9-28c1ed919563", "AQAAAAIAAYagAAAAEK2HWKScuVDqWUCxEyo6/JiW+ZBwhDJD6CANJTcUsTztNgci6mwREPZ0MW+LIjLP2A==", "2c17acd8-12ca-4e8a-bdd2-03bfeb767c0b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3cbc26c7-329b-4f45-9016-6d412224af60", "AQAAAAIAAYagAAAAENTJT0WezKUgN9DZr35TZtB4E1xyB+2kJWPgVf4ol3ZgMmCkoqneaKr0UhMvOtPdKg==", "634607b5-f72d-4bdb-a311-31f62a3e6e1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c09b4d80-3bff-43f6-aa4d-394ef57b0d8a", "AQAAAAIAAYagAAAAEKNAidKkYZpMW6nIPqmGZ5EzW/TI9jFH59EU7+X5fbiCLqsAgifenxWX6tprKjRFfA==", "ebd0b593-fab2-433b-9d75-2a8839a63258" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76fc7d79-a5c8-4299-8d7c-1b8c3c4bee45", "AQAAAAIAAYagAAAAEAJISJZnmS/LjHr/f08JCyZMTwh82SjUD3qUXRfZdRqOoB/KgJHF8c+cfUUttB5bMA==", "3807a63d-b835-4418-9391-55ba75656903" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "babcf1d8-7256-440a-bfc6-70fec750bcb7", "AQAAAAIAAYagAAAAEPuGn73jBmwMmCXyILQBVzdGaAciH461lXKXaWQq3KSa6/0nU1hPxCliaS78bcSGiw==", "37056fdf-84a1-4438-b06c-5b188edf5c87" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7ca20f6-3901-4ffa-85f6-5e5da5062e36", "AQAAAAIAAYagAAAAEIpjnLfugSBUcvE/damS79pOJSK+m2SbnCqP/S47apJt+4Alh9lY+phncGZeQYtmkw==", "8315aaeb-ddbb-4edc-82ad-3e25aa027d0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30a20bb2-5e52-4437-971c-5c1eaba09787", "AQAAAAIAAYagAAAAEKT2RZGn+UG4G3AAMKeE3N4nwoCfnE10WBXUrJevGCkMWTE0V98I/Tw3H/luEutX3g==", "8cfa5a72-ade4-498a-ba3e-97b5a167c092" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f121280d-eaad-48d4-a4ec-0516aac3bb3a", "AQAAAAIAAYagAAAAENHZzvqKIRESA1jCWavAV0M1kwTcIfTWPINVrGwKs49/p53cPhiKnIQFqfG4ZTJ+gw==", "a6a49659-bff2-434c-af22-c04d5fc99dc5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "65dfd9bf-6a94-4294-be39-1a2f94ff03b1", "AQAAAAIAAYagAAAAED0LeN1KkcKF23W/xjGRQM7kQ6emt+IbUltNNBjWmZXEmzYPiXm5ccaNaZTLafrWwg==", "b5435130-e0f9-4447-9ac4-bddca4491b3c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee9c9dcd-980f-4b79-ab77-0be689df9335", "AQAAAAIAAYagAAAAEO1e615EgYrammaffZtOBZK91AgfExze/AyBgTAUWO0P82wFMZ+JW+dmIKPpVRFSvg==", "e5fed8b0-0e14-47ad-9fc6-a9c1a220b061" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa475b22-f7e5-48a2-95e1-938d0af7a624", "AQAAAAIAAYagAAAAEO3DMUPoUeTeOYvHDLJ5a42kvHlN2y9YUCeZGbyrfHOtSnWG/q8acfH2fgPOwdEPSA==", "dceb6415-bce1-426b-a648-fd919f250975" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "324921de-7fe4-4a1d-81b4-80dd8c35947a", "AQAAAAIAAYagAAAAEJ8G5SpFE60cQRQXBKm5g3dsf8thV6iKvwCdMxQbBlxpM2O8s2KrdOxakGyKTUTBKA==", "bb2ed536-cb46-47e4-9a17-4e990365994b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6419663f-b2b3-4930-bac9-562bcdd90be3", "AQAAAAIAAYagAAAAEH4IbGxNYNUUbNW7174qUej7C/4mojw7kFLXcRw9+6nrzAr9v7LsWK+TaNRq1qUeDA==", "bea20b77-145d-4341-a1a1-323fc3ce1f83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3ba5889-cd38-4afb-894a-9381cb99dc67", "AQAAAAIAAYagAAAAEJAuor5lTQmzHsoFeiF5xrhvfnHArtuDdqwL7RIYubaZp4Jau7r0gekzM7NRUIm+XA==", "0c28f739-9af2-421e-84d2-d8b79e73346a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdf99a5e-836f-4fb8-bfa6-3d6a288c1f71", "AQAAAAIAAYagAAAAEDdBtYBMP7MTCbj6Arx8XGJjcsyOA1xs13O+9y9yAAY54PquCkbM91d8j/ZppRXp4g==", "93377122-c02f-4ce7-9e98-130ca6ec92f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87913d7e-bf51-4d9d-96cc-94af82499b84", "AQAAAAIAAYagAAAAENtiYv93/8Al3OiOds5lH0DyCWAORA4zGDZ9iJ+pqdWCUyLqR7bBAosJja4B+n6I0g==", "63b43650-d546-46ef-a9f8-c59387062371" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da51fe46-1438-4e19-8041-f15540c63e57", "AQAAAAIAAYagAAAAEHbRA23bC7mgyqJtdrEqjB2bQpnI7TNrxP6S8yG0i5ikNneIw6J6P8oqAcK26AOwyA==", "2ebeb84c-938f-4c77-9308-68d1889a2fab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f930af8-fdf3-45c4-8029-1c005776b730", "AQAAAAIAAYagAAAAEJpqrTpjRkgNA0WpsGeu5altqlq96N/4jjzESumyFN1ZFu4iMNr6HEnHDQjNGQ71EA==", "b1baad59-708e-4fc2-a0e2-356be18f218a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11cd3143-5e0e-474b-81c7-770476e17a07", "AQAAAAIAAYagAAAAEAamSkqA4bf2AWdb/RwGQVisNlK/KFhk7B2RUTopgN5sbU2qlKhPRNaVcclLuBArkQ==", "fc5825bb-b944-4dea-a63e-4c52b5f76693" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf19f14e-478f-42d0-a0b4-af4b37aaf061", "AQAAAAIAAYagAAAAEFfUS5P4ettUHHzSEOax9rn1NMS3dmmkPu2rezVkOH8TOe3O4UmR/uf/x/wJ6fCpJw==", "9653c605-0cf6-46bb-8dd2-dd688314287f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d82d33e-5e62-4f65-b478-c0e523d65429", "AQAAAAIAAYagAAAAEEECjWxqvRwWG0OiYhztTNZyIAfjoj8wex8YGSpSJndK1Nzd3qKcCTbkFbgdZ76nfA==", "9339274d-5fbc-4a84-9878-f554316218f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f509856-b566-4d60-97e3-bb38dbfa1069", "AQAAAAIAAYagAAAAELX5MoT6J3ZCELCwS/X/5Emd4Gc+HuAq9iFicF+cXqdhoYOYX1CljVzXA2JnVdpPcw==", "c4a6210b-65e3-4b98-8dd3-532a6189f8f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4b99995-a394-4798-8c66-0b0dc9e6726c", "AQAAAAIAAYagAAAAEA5heQ7bXsYxEV/KYF/HEt01FJao1scXLEOyptshwdJuiAeQ5217F5vWSmu2u4b80Q==", "6df47333-34cf-47a8-887f-5c60155d7838" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c236076c-f073-4f1c-b1b8-3c372c4a9723", "AQAAAAIAAYagAAAAEHCB4oHiczPKVf8AfVsGgAvWthYDVzjfBQjDejwGFjBmmoNk/uHucucx13lwjzQnDQ==", "cc4c8eb1-ec06-420b-8c68-989d2db42bf2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5eaee477-33bc-48c0-844e-b28c836547ce", "AQAAAAIAAYagAAAAEPkjGwRpTbA8tjaI0IRc+BF8KAFKV3jJFQX4JMd4alRR/MGyO4XkMJVs1dXCvHD5BQ==", "a3849dbc-47f9-4f8b-9c0d-37421d83dc74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59b195c8-8715-4d04-b887-00a6e3e2777e", "AQAAAAIAAYagAAAAELXLIUUc7TFLGr9vp9Rs5/Vw9L83DckCgou9UvTxx6JBVlTSZ9W9KCe0/fpA55sPxw==", "b955a04e-d3f4-41d4-ad6c-de405e6e425b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61a05917-6471-4918-aeb2-85ab47d231ce", "AQAAAAIAAYagAAAAEL/6Ywi4ynG4VnJxBnZQxi8N+QIu6ry1fna0wvfzzjes5RtDNWbxFSFeokVX0fEELA==", "1deb96fd-610c-408f-98b9-cbee81b5c1a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "584bb50f-57e4-4762-bde6-e3a1c9d2a391", "AQAAAAIAAYagAAAAEMQB0KECpJikqahQh9mw6Fytqb2OVmW5hTIMPUkbM7bReCKKIfdhSmevFd5WG8Z9Hg==", "9646b570-3242-41cf-95b9-d946708868aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "582cbf40-7392-44ec-a582-26ca952e918b", "AQAAAAIAAYagAAAAEBj525K4bxtCF99MuDAHsHz1SjzaRdso8+/oRY716Phn7gqG8yZ12nyuNI7Yu3B6Xg==", "9385c7a4-2978-4b39-906b-f9bcdb9576b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "557530a5-477d-4b53-ae01-d18f7b8ad374", "AQAAAAIAAYagAAAAENS985gpCFE/JVwad7g3jIbasykfM8grTg6slrVTvvo8jPC6PUeDF/QyQNSa8v39uQ==", "9448d13f-35fd-4000-8dcd-0f53b6b38040" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8471085-333e-4779-b399-a6b2b10f4d03", "AQAAAAIAAYagAAAAEFd0ylgMQGNUtOWyBiJN+/xh366ZqpILIDE7wkvT/ezhzB4GqgnNqZNWBibJ9A7Ykw==", "497f37f7-eacb-4517-96ba-8a63c0c31402" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c081232-1f61-4b29-b0c4-9670c13d4359", "AQAAAAIAAYagAAAAEHdTMvb5GJ60MfmYgYLMBmmq32WWQ5y61BJTcrUSYrnBwcOXx9daL50q/kb2c3Y0eg==", "f312d2e7-2138-4d35-be05-9491da33d326" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f74b3bc1-e498-4d45-b9ff-a26404c39300", "AQAAAAIAAYagAAAAELPZQipCpEAHhUbo9Z7XPhEftQvV/eEp2KVQXYswHINCZbIDTEFCGvVivmuX1XDjuQ==", "5fe02cfb-86bf-4126-80c8-c9d851bf73f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7800d2c1-8704-492f-9815-98affed679e2", "AQAAAAIAAYagAAAAEETwIILj8aj0AUL/O0lxVz8xtlYd3ySP6oOZgcDAQfGJnv6Bgzk3J3Rg4Q8b4cR7WA==", "5f37ab65-b05c-42c9-97d7-412baa45f731" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5577f049-5a20-4152-8830-20946fa2c440", "AQAAAAIAAYagAAAAEHq+JckAgMVM0nKbE3zT7b/0uVDvuaW00LHXZEcvQRZGHdNuG6/JRajelus3/lk3Ig==", "a566725b-12ee-43df-a872-d32349d7ef56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b15f021-5ce6-4375-90cd-370042e58780", "AQAAAAIAAYagAAAAEChW8s4S8vFVSMva9rAYjHh6iZlFJM0EhX2vHB9EbM2U9rn5ULXJ9n8RjRd0OrO1qw==", "f9c30850-3ee2-49dd-ba84-0f8941ad04fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fb041f5-8250-411a-a564-69c82c45757b", "AQAAAAIAAYagAAAAEOjS6Xis5YknS1XUcEcV9Jm5WKnau+2ZcE0/P+1CjHRp9E083/qxgZIq1EGC4ujyvw==", "fb85e7da-512f-4c54-89c4-61a3e93774e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7bdb5c14-121b-4fc6-90ab-929079340de5", "AQAAAAIAAYagAAAAEA7D3Wgg3o6iIHjX+3muLEMKHo01iw+ftIR+aMMX57pXsDeg9b/cDYmMJrogLwQgnQ==", "a163eb38-e3d2-4be7-abc4-3c9cbf724ed6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b84058f0-5a3a-4162-951a-2bc7156a7cd3", "AQAAAAIAAYagAAAAEEgrFfKJQ9i+ycnMeT3At59hUA2kiJcqbtMNLUQjcxRMenfS2ChF+GJaxbsGJfYLFA==", "0cdc45b5-1854-4495-8b86-595492272c05" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59f4bd22-a1da-47bb-93a2-f0dc2b2a2383", "AQAAAAIAAYagAAAAEIrr04CJid7jRcDTrhL/+e4YS5nj7eYYPXJgkVCexE5z+KvYoMvXvG8bf0jtcfphjg==", "558ada0f-0954-486e-a528-e3e215b20f41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11022652-d487-4503-858d-0b30c456f4bf", "AQAAAAIAAYagAAAAEL7Syu066wheSfPt3rfC3J3ujl9xdDOYrxMZyPJJ7aANEM/3b80TKa8jl6XunbTH4w==", "e14aaa37-8bfb-439d-8b92-939650a6aabf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5eec2b3-946a-4d4e-bb3a-dcc641479358", "AQAAAAIAAYagAAAAEDEMnHfsk2ZoT5ojRxXaDS5PPNE035y9brdFAZsUFV2J4RdSg5gv+Uzbxjy9y5ke/g==", "56e248b6-ffca-4ff5-9463-d6aa3f344034" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5cbd15bd-636f-4663-91e3-43a307f5bee2", "AQAAAAIAAYagAAAAEEv8jnopLIwkajX134YY1rbjklMYrQDAa55EG9SvmtwjmOVvXo/iBLi7nvn1lyMJ+g==", "997b2c02-8dc1-4d78-b13d-ea73190f98e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58f155ca-ee8b-4260-8bda-b5b029ee7f93", "AQAAAAIAAYagAAAAEPL+nVLkPwI6XscM6g0VroqJF8e2vU/8XqUotfbOdo4zxV6saNbe/lJWT0Z6Iryejg==", "0def8ed4-747b-4d95-853f-9a739f97b12c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a6be166-e431-4805-8348-60ff4a4c99be", "AQAAAAIAAYagAAAAEOO+TUA58d2kGRpXOamJd9YP29dqyxJ9Aszwp0klSZS188nZdpvy15ifmJYi4AyaHQ==", "e723d7cb-765e-4302-aa9d-3d3c476dd5a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fff02243-5b28-4e6a-91fc-d60c1bad25f7", "AQAAAAIAAYagAAAAEGNIke6KeltelKWmdajyf9oZ3oCC+GjQpWQ2vHfMkoiXXYAnQ5YoK5GkpGqYM4PSOg==", "4e79498e-9d24-4bf8-b9fb-848bce246944" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52d1606b-d0a4-45a8-a30a-586d462b3b25", "AQAAAAIAAYagAAAAEC1dLOURBdCmgMGoOgtsdNsNrvG3GHHWKSBNwx040A6h+BUTwH2ui5kRNCGTh1+qtQ==", "6d59dcb5-ab69-4398-bea8-d76ecb6f300b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "263606c2-bc86-4605-8531-30ac43ac2e93", "AQAAAAIAAYagAAAAEEagHy2UDVGKfXgt1dNAWaT3v8ugbm/Bu/ZVkX10iTQELw9iuIHupIJu/dPNOf6Ydg==", "eb00128d-afb4-4150-92e7-8360980688d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "376894bd-f0ac-420b-afe7-528b9681a1f9", "AQAAAAIAAYagAAAAECP5r0xDHH5uDcTEhsLWLFdj595rLvuhQDqgmaMDsrI3ymn4p1UfHQpnKAxHxvwCtg==", "ceb75209-25a7-4120-9ece-91bde3f75602" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5770dee4-82a8-4f55-a358-6f4abad99f43", "AQAAAAIAAYagAAAAEM2Mqw8sfO4xvxrbdtUVflzEhd3R5Cg6AVd0tc1qeQWB93BX9kzcdH0qo7Wf8cawQA==", "a176e325-6498-4688-8aae-c608f95c98c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd1e0b80-fe74-4109-bd96-f1c7bbf376a7", "AQAAAAIAAYagAAAAEGeHAFUktQVzGx3ptlPpM82+tzYJIFD3tEoxIOXb5FZKpWOoe80yY+gNa0BK5/hg4g==", "a12f4f6f-42ee-4563-89a0-d4c97965825d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86698594-4606-428a-bc05-95431ea0fb0f", "AQAAAAIAAYagAAAAEL50oyKNMIz+dj3DkgCHUYnUkHa6OaCfOaIHqjCyT7Z+OyCHW3/x/feVZdJbmiIDqw==", "eed5b0ab-4025-494d-927b-73b336d78eb0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e2f85804-fb2c-40b2-9331-f72690d6bdaa", "AQAAAAIAAYagAAAAELYBdKB184fQpHjNObknYLmfLY9yfIUv5DNtqA5D4YCE9TtYcwNNQgKTvdIu/tX/Rg==", "d304264d-5caa-4a91-ae8e-05f72e379278" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "951dad58-6343-43a8-bd27-ee973a6e506f", "AQAAAAIAAYagAAAAEKpkIyvvwJU3dPVaBO9uCXmOTOE9eW0MrBsUDxs9cfnJDMNXJVSTxOm2eO0BDADmsg==", "351f58e4-3217-48aa-b9bb-81d8ef32b4f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "789a6a7b-c048-4ab0-95ad-28f18c7ebc27", "AQAAAAIAAYagAAAAECoRQ2UvsNiTqFue9GOLgEmKF0MwOy5BDAXrhYfdJe/edhmray7Olym0tR+mwSkJyA==", "713a0dc5-61fd-43cd-9a1d-48c8cc8b3596" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3003ef4-adbf-493c-a4b9-2d6545cca34f", "AQAAAAIAAYagAAAAEIbvRAfz52RBLGRdsxp+UnuVoH5dlQkqXEOvKF8yXlz698qDLoHUEvfMe1/ghIEcug==", "2c5188f3-fc99-4859-9b94-9f3bd5367caa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "545032d3-2e14-4caf-908e-76643f2488f7", "AQAAAAIAAYagAAAAEM399ACXM8ya39ZtCoUX3ZtGwUAjevomhGneGrTcW5Z5OmvL32c0fX4bOPUk4idB3A==", "3cd533ec-6044-4022-96d7-c268eac6447c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c05ac15e-b47e-4d92-a054-109e049adfe3", "AQAAAAIAAYagAAAAEMeyZ0z+dL7G3u7p7SfBJajr9ZNfMpq0ccXvXhIC5cgys6iDOH0fsh1PoR0ZX8BCsA==", "db2ec011-da9e-46a5-846d-faccb6c0db90" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24e02888-d4ca-40c8-a707-65f364f5cdb8", "AQAAAAIAAYagAAAAEATgmAlq3yN+glIBXiIYxNWWyg0/BRCrkTTJ70cy9Gd/qqu06a7fAf8YlFaFsLlFag==", "8350ad4f-5364-4835-8049-898440f4e818" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f703bf58-c5ee-4c1a-b6ad-b20dcbf4871a", "AQAAAAIAAYagAAAAEFIEtJtSSACVQWVnMUsQz5vfZNWebEmjqk/xAKXgTaTeU+IUu2TRt69BzvMDxvibFw==", "c24322b3-01cf-41d9-965c-52c33c169f9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e257f70-2b02-4bc7-b87a-b9fc0c7bb6d8", "AQAAAAIAAYagAAAAEA8KXUCz/8vKsL1nvSCTDKeWs9JjYO5URKvlaCUMVFcREt1nPYVaCzTkc5fD89hAxw==", "de439cc8-e070-42a7-bda9-6b3d331cd893" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd4b02ef-88ba-42b1-a130-7ff3a958e1eb", "AQAAAAIAAYagAAAAEGzKmHHX/zSvrAMM2lNJsOtyG5+omz6fy5UkQ+mWjRUQQw4DFG92slYrrN3UnBcmFQ==", "4b3e4c75-7747-4f40-9007-5474658aa2d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82a9987c-9f5d-4356-a932-c1407929d63b", "AQAAAAIAAYagAAAAEDAbczCV4RlHOMEZ9rSFduYOlgbAeVjTEU28YayrQseP+LZf/m+ZPYDHX45MTDZ9NQ==", "c2c6dffb-e2f6-4c49-92af-1481339d4f63" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7538f0d6-91b8-4f05-9502-d2fd3d23af14", "AQAAAAIAAYagAAAAEK1xUIa1/smXxCdevi03KhllRTtirJHBP593v6pYSNLN0z6Gbkz+7rlK9WcQD7GTPA==", "66c0ca7e-281f-4172-b6dd-399706f431f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88c1a51e-5680-414f-965c-5f4ae57aac7f", "AQAAAAIAAYagAAAAEGai2wjojAh0OE2+VhNQgTHg2gmmKvNPH9101tZ8fHtv85SXuajpTJz3D/A+5jgIDQ==", "a5de8263-0d68-49bc-a21f-bf993e72bc79" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "969a6b1f-0789-4157-a0e1-bc353d241d27", "AQAAAAIAAYagAAAAELfQ5Z5urvp1EG278Q9aB+5RacrFqjY9N3HPCSX815umNvh/La9b9+rLXefeRMbQrA==", "03de567a-f155-48f3-98a1-76b924ab04a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4386a801-889d-44b0-9ff7-a617f47d162f", "AQAAAAIAAYagAAAAEJp96ljCpmKq8p2nYuzzHaNMEU90/iyNFrr6SOdebu6cIoJ5df+3a11arkQYaBN9XQ==", "d5066dfe-6c39-42d4-99df-eb16249a33c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6595a3ee-85d1-4d2c-b3d5-0c75ed9aec06", "AQAAAAIAAYagAAAAEFNiYwJx2Lrt911nqTt4YN1o6Q3+GZ0kb02DpQ1Rs2J+mtYoUw9Bjmttv2VlHcWG3g==", "e3344557-b53b-4c2a-9822-621d132fd818" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ed209a6-ecde-400f-9e7e-557da1ae6b28", "AQAAAAIAAYagAAAAEC7BjNV0ORku1m98DX9Q3UoADexUZyKCYKHfbrcKMGExXF7zOmJpZ+UiwPzmauRb6A==", "cecd1c3a-7096-4230-a30f-d24eacf7553a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4dfdc037-30f0-4227-86c7-5304f01f17d3", "AQAAAAIAAYagAAAAEIZowxPULJml0mFFmk+Buij12DHLfyhyDgLE7GDJF+TpnwM6wKpaM809+HKWuGBOAg==", "a55211f3-7731-4592-bb7c-3b85c3b85f29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4108bf00-ad5a-462a-b066-ee7893e9b604", "AQAAAAIAAYagAAAAELxUq05Rbwu8FVmxXevgfh74kDG+aDctDPQicaH8JSiDCF8EkLVuq4j/cmQ3XnepLQ==", "ba6a82f1-3e85-4bdf-842c-146c209559f0" });

            migrationBuilder.InsertData(
                table: "AuditStatus",
                columns: new[] { "Id", "Code", "IsActive", "IsDeleted", "Name", "SortOrder" },
                values: new object[,]
                {
                    { 1, "DRAFT", true, false, "Draft", 1 },
                    { 2, "PENDING", true, false, "Pending", 2 },
                    { 3, "APPROVED", true, false, "Approved", 3 },
                    { 4, "DISAPPROVED", true, false, "Disapproved", 4 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditProgramme_AuditStatusId",
                table: "AuditProgramme",
                column: "AuditStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_AuditStatusId",
                table: "AuditPlans",
                column: "AuditStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditProgrammeStatusHistory_AuditProgrammeId",
                table: "AuditProgrammeStatusHistory",
                column: "AuditProgrammeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditProgrammeStatusHistory_AuditStatusId",
                table: "AuditProgrammeStatusHistory",
                column: "AuditStatusId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditPlans_AuditStatus_AuditStatusId",
                table: "AuditPlans",
                column: "AuditStatusId",
                principalTable: "AuditStatus",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditProgramme_AuditStatus_AuditStatusId",
                table: "AuditProgramme",
                column: "AuditStatusId",
                principalTable: "AuditStatus",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditPlans_AuditStatus_AuditStatusId",
                table: "AuditPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditProgramme_AuditStatus_AuditStatusId",
                table: "AuditProgramme");

            migrationBuilder.DropTable(
                name: "AuditProgrammeStatusHistory");

            migrationBuilder.DropIndex(
                name: "IX_AuditProgramme_AuditStatusId",
                table: "AuditProgramme");

            migrationBuilder.DropIndex(
                name: "IX_AuditPlans_AuditStatusId",
                table: "AuditPlans");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditStatus",
                table: "AuditStatus");

            migrationBuilder.DeleteData(
                table: "AuditStatus",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "AuditStatus",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "AuditStatus",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "AuditStatus",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DropColumn(
                name: "AuditStatusId",
                table: "AuditProgramme");

            migrationBuilder.DropColumn(
                name: "CreatedDate",
                table: "AuditProgramme");

            migrationBuilder.DropColumn(
                name: "LastModifiedDate",
                table: "AuditProgramme");

            migrationBuilder.DropColumn(
                name: "AuditStatusId",
                table: "AuditPlans");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "AuditStatus");

            migrationBuilder.DropColumn(
                name: "SortOrder",
                table: "AuditStatus");

            migrationBuilder.Sql(@"
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuditPlanStatus' AND schema_id = SCHEMA_ID('dbo'))
    EXEC sp_rename N'[dbo].[AuditPlanStatus]', N'AuditStatus', 'OBJECT';
");

            migrationBuilder.AddColumn<int>(
                name: "AuditPlanStatusId",
                table: "AuditPlans",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PlanStatus",
                table: "AuditPlans",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditPlanStatus",
                table: "AuditPlanStatus",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "7fa15677-cd7d-4212-af04-88f3cde910c2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "86cb0186-0c7f-4dd7-8bf1-98660a27f07c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "8603ac88-063c-4cd4-be55-71773157abc8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "06ee15cc-2178-49fa-87f4-99fa06982c80");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "0fb94829-2a39-41c9-ae01-e6d663e881be");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "8991990c-6d3c-448b-9d43-05736f6892f5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "c6101ce4-2fb2-410e-a7e6-69096555ae04");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "f443bf67-1c0b-4122-a8c9-8ccb5cd5bf4c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "6778d6f0-2867-4dbf-926f-0530f2044302");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                column: "ConcurrencyStamp",
                value: "8d10bae5-be32-447b-9e66-642dd6ffaa58");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "71f6535a-2dff-411d-a559-c9c90c45fd05");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "fc7b1534-3299-48fd-9148-1e6fb0bdfb05");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "180654be-56c3-456d-befc-5a27a82ccdf7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "300d246c-8253-45e1-af2b-4fa429766a38");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "69de33b7-65c2-4f28-97f8-b12a2fd738f1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "debf089c-ee3d-413c-ba18-ec669c9ced95");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "9845b50b-88cc-4328-a215-fdbfb3a6811e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "51cf1f4d-f22b-4039-9caa-421dbfc8e56f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "ffa4002d-6e2a-473b-b270-b0ae159f389a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "761990d5-0db6-4cd3-b0ea-5194d60d65c3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "3a20104f-7a33-4ae1-954d-fe0cbb60170a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bde90edf-c928-44f7-9f23-e0ece9825b6a", "AQAAAAIAAYagAAAAED/ZATr0/PQ+IFmwg0ICvM+8svJRsB46/Tetr/hntUla+Ry3Bt6vbPTcEu4DKn2yIg==", "2e3af718-2e96-495f-bfaf-3f12b8575678" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "702d7165-3531-4934-a23a-2e0ab69726a6", "AQAAAAIAAYagAAAAEIrW+S2nWRf/uTTvq9RXZyyV6V5Fp3Y1ZHeAhW6C9mOzZM6iyK8v6GkvWSLY+TSgiw==", "6560b422-31c5-448c-a17b-fc4f34aec082" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ce444f2-17aa-40c6-a15f-cd4ec47a9990", "AQAAAAIAAYagAAAAEJIOwASNPmwckjbtrNVbCcH3esk2qeUjVJ69DtKT4u4RTjKpEBzwp5vQdXtwkgdU2A==", "a37aa982-9bdc-4133-ae3c-185871d07614" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebd34843-a525-4715-9ef0-77965754d9eb", "AQAAAAIAAYagAAAAEAj3VjVgnA2zbS/5AovDCNRyc6WJnhThFdjKutKhg2EsR1c5EmR2/tk86D5Sarw2YA==", "9459b84f-dbb3-4029-95d1-1697c140d4aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ceab0df-52d7-4148-bdd4-49f8bddb7722", "AQAAAAIAAYagAAAAELJBdo2rQAq6D3hmZdtm6uG0g0laDojsGh+z13JeKHpaQNtK00I46yMm1FRWrguiTA==", "f8e44e1b-affd-42bb-9fd6-efba64b728a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20166f85-b23f-44f1-9a02-4dace7a5d8e2", "AQAAAAIAAYagAAAAEFeTnRy6H+gg5Mr8K79gvuWpzER9gXbgnxpt5Q8WnSV3ohJkBMp7JCORfssezhjzjw==", "78bff6e4-a063-403e-91e0-0433cf442f9c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "703e33d8-fa53-44b6-930e-1aaf2356a3a6", "AQAAAAIAAYagAAAAEPfwVSvseH7MFnMCK65plJYg/iPK/iUR6SYaZG+fOtlIkzaTAgK8gCz6NZKUMNdcUg==", "c73ce0a2-cb57-43cc-9b51-dee210cbb1fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b256ab1-e2ea-48cd-8479-a0a1ce510c8c", "AQAAAAIAAYagAAAAEPeJpIMG+0jY2ZITjfNAvVkXbD6QCNcNGkdJjR6kaHZ/c5HrVfzLMmP/iGc/EHQq8w==", "ca5b8a4c-47b2-4586-8c69-3002e1b54fb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22025acc-8ec7-429a-960d-352c54ad70ab", "AQAAAAIAAYagAAAAEFAJIbcNocMo9VLgR1mcv7dGOSOCWgnlNSEkZXZNHW/K8kvGElIRjtauDJINoEhIFA==", "19109c04-01b3-4446-b760-bf18fe1c84b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2bb3d60c-7342-4a29-a7c0-89246949b4bb", "AQAAAAIAAYagAAAAEOJ9WY3YvXUMMkZYjVYhLurhSq36Zw9Rq/9XA46CUrKFCnT8vgdh6ZXuDj0FvPdwqw==", "f43bce41-545a-4fef-b542-34daff41c343" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "825ac035-9b57-4980-9d70-31a7f6081163", "AQAAAAIAAYagAAAAEHV6w2vMK20iMrzAxUS+rRHLZu1zSx0kG81k2E8UICsJhcAOotuWa80z5wSRRYGQuw==", "f0f27378-3304-4885-9920-61ec77e4ba26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2085d0e2-e9b2-4e7f-9472-ed0191f10df9", "AQAAAAIAAYagAAAAEDRXUdM+LJ4Maf1qRqVy/TXt381g7Vd01zO2vN6KDoGIM+gy4BfrZ0g0QxCga7OEgQ==", "680fe74f-d591-44a0-bc3c-6897d08e29f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6769be0-905d-47fd-bd80-1df12a279169", "AQAAAAIAAYagAAAAEHBHXhoQFffp9dUhTgGC6ehloMF3s/Vu7Y2KxM92Tweyorh6yzzE5gYFIqx3v3VAsA==", "c69822ea-bdb6-4502-93a5-16b42ee30e9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cbb3126-282c-4315-b6f3-05bd7811ccc1", "AQAAAAIAAYagAAAAEFxerhLtzB2ZA1E51fKFEB7nOVdfZbICvePVW8XZiqtFe/xNvDJsG3pCkTQDldbDiQ==", "c5ce99d4-b1eb-4fff-b5ab-1342c3c55d6d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "187c59c3-1c69-41d5-a628-1cc8602f8491", "AQAAAAIAAYagAAAAEFaLE86tHoP98FzXfPEOqob7Vj7CLo0qr5l2RL8whb/rRcTdxEIuwRFcwvcYaSlPww==", "faebb269-6e67-425d-8522-4f57be32ee33" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3166d30-da94-43e0-ac40-e0dfc3f54494", "AQAAAAIAAYagAAAAELQev9z6x+L3rd9twy6Hnnd80K/JkjSVXvoP8Ilay4gMGCROgS9dYTFv6jmnysNpmg==", "b0d37988-364c-4620-8280-994f56c25d12" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50488719-659c-4c42-8305-48f40949cfd7", "AQAAAAIAAYagAAAAEIJVe0YRmhtzHn86TggfY8QVuH4aIWJgAwWn9sUd3azLdknwYfbevqg140dLIyPdag==", "ac4481fd-a42e-438f-83d2-f2c8a1a1bce6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b576c60e-10b8-4d70-ba3a-4c45d7f6af72", "AQAAAAIAAYagAAAAEKn0HGgB+b0NnBcv3Dmd5DjO3O1/3EtQ0vQw26065UdB1VLrFH/lJk72khPIf+9cmQ==", "5bdd51b7-b806-46f1-9fd8-dbbd6bdb5855" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "efb06f68-7822-417e-a8d1-01b29a4b437a", "AQAAAAIAAYagAAAAEHohfOvgDlRNhZcX6NFlTujTpTuGHX+55/kIEzpTUpubnc3fD4t1vd12jXJoG9EPlQ==", "07bfbbc6-9f81-41e1-9065-f641382689e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddfcbe55-e264-4a14-b68f-20ba8381244c", "AQAAAAIAAYagAAAAEKtHijzw5m3TFtz0Ra9PIJd+5SA4bSYcbC8FOP+05hlWLZDkNgVz8jp0aPtx2h2+mQ==", "b842105d-847d-4884-b9e4-7900c74df10b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7803fab6-e88b-4e37-8423-1f63326631ff", "AQAAAAIAAYagAAAAEOg0CgLTQ2cOtefudHuFXd66BgKO8Tbm+LWd0e1gIhfvQDkJE7pXV50HRoNaPLmDXA==", "cccec21e-e32c-4465-ae64-b1d815baf932" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89da3a9d-2dd7-460d-adf2-a034f88a242f", "AQAAAAIAAYagAAAAEO7gWq3QYQQQo7LS6poWUiQ6rS7kvakwzhzJCoWHnByjM3Lkj4jH0GUuAhhKJN4WYQ==", "e400f3fa-8980-45d2-ad2c-63e4c68eca68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "92001c71-5b21-4044-8d82-d09252c96e0f", "AQAAAAIAAYagAAAAEKiQFAji3FfJXy2rCmkwXe7AW2z9/zXotPR/WSvecsWa3N8A9P/6/PhMN5dtGpK81A==", "6836b2c5-b4b4-4e8e-8aec-9a69209b2a5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b7497f3-bd12-40b8-9102-a3bcf90c7170", "AQAAAAIAAYagAAAAEA8WfkYyUbD+Yc/aZ2ASKMPdgrvLmAcOLm4jegFV2xgCzWfbs9dPfq1gRsC/3Nqruw==", "7e76ffcc-ea67-4228-abe4-6a72ab6a8781" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54938a74-8d28-4b66-a0c1-fba58d285d88", "AQAAAAIAAYagAAAAECuW5w9hcZf/aIlIRqTBzE2MiLgco9b1PAN9qBc2P9AVsCi6YcZSAKALhWglGf6LXw==", "d9f2520a-b90a-4d4b-9fdf-3329eb99ac37" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9df46087-75f8-476e-b116-b01bd78b4ebb", "AQAAAAIAAYagAAAAEE1ReDfWXvZvYJ6vrh1brqpXUoWocE3aTqK41nMdVZBZiiSjAIuMc2JiBcG08CSFvQ==", "95e2fcf9-c0d1-4d41-aaa0-0ff8cda2442b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6856636a-6923-4523-8dce-d6e22bda36fa", "AQAAAAIAAYagAAAAEGQdVJ7DdPscipMKIqevvi4DlYesMLBiZcPDOUNQKIqVjahmEZO8D/qFNKT8TO2zrQ==", "11c77a30-66d0-472f-b4c9-247f0d7d58a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c71e6ada-2c7e-4dfb-9811-f3b710a05af6", "AQAAAAIAAYagAAAAEAng271DgASkjgIXhvOoai9Vu8WylGtFhoDFMyq4uYu0ClNd6P+EhQSof9j5E+pTYQ==", "73cc8cfc-4b92-4338-a84c-1382dc03d4e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aeaacc97-f6bc-427a-87a3-52b9db0b061c", "AQAAAAIAAYagAAAAEPrhOZFrg7qq171wN+oX9cq8ngI3geyPW3ZKNBIayUQ5Zv6W1mutmOT89vNdgen+RA==", "ac11ba16-f6c6-48dd-9625-61844c92e207" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d17f25e-171a-4a61-861d-fb2277905c34", "AQAAAAIAAYagAAAAEB98ahapzPqwGpsUeuJ5LO5GYLWZT/l6veNQceMUxycuhwm/9AqtmLvi3EV/k1LfMg==", "a4a9db70-ad4e-4c8d-934a-38cff9ac378f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e2ecce3-bf8f-49f4-8a2d-c63cb3ffd0a4", "AQAAAAIAAYagAAAAEP0aWc1TgdTh2gNSBSIxpTpe31KWvKF/Zrfb6PPpGOo8MZ1ZhDy/iyZCodV9TXH0dg==", "47b1f8fe-b221-4f5e-839a-957ce6a166db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2015fdb5-923e-49af-a323-78f8ecad64e8", "AQAAAAIAAYagAAAAEBv1bhfmQAUOIfckJiY4dR8nvFjhbf0JSTv1GeT/7vRC5C9UzXEE46t/jOTtABd4TA==", "4b87331c-9f62-4c86-9702-f56fce515b11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c9e21a8-6509-4463-a7ba-d633a57dd771", "AQAAAAIAAYagAAAAEBcmxFBwdh4i7d2vjn8PEAQ2CGu/+97yO9XzdMen7ETf499eoZ7ieri9Igtp9b9DBA==", "282f9b04-2077-4a5f-9ddf-75212a6de302" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2eebb4a-63c6-4589-a029-6273a8b3ebed", "AQAAAAIAAYagAAAAEFA3mEYLKJ/Ayi8tc0cxAFsGhl5XkCMCG08sqC990v/SGM/q9R+HXHveIuCrjeMhgw==", "14e01a59-f97d-40d8-9c36-fbde640f9fb3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ccbe49d-50a5-4cf8-9b50-16aa8e803257", "AQAAAAIAAYagAAAAEFKkqFM2NNaJPN/9l50n4bfHbVLz1y1YmgBP2U4IyPEkY3ASymPHx5x/bwFXMdp/Xg==", "75f7da08-81a0-45c5-a5bd-6fbec95caf56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23d786a2-80b1-443b-b226-56eada9fbb7e", "AQAAAAIAAYagAAAAEOj1DeU00ZvvzVImZDgf168nyUXTxmkYbfNjl9jPxxv6vItP59sz4A1h6Z6lnNGirw==", "b134d4a5-27ca-4181-8d97-a937a7a02579" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "43275883-7fc7-4d73-bb6d-978ca7aa8060", "AQAAAAIAAYagAAAAEBa+yOLodooTtCazTwsgWKTLyFAhJBET79qyIHkLANuqwgyA5cEucc7yXza0ZwgCVA==", "a5a5f87d-84e0-47ea-b521-b5cccd6f2905" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7f494eb-46ee-4f93-8d32-d22064a8db27", "AQAAAAIAAYagAAAAEGHY5/MXMFe+A+q38gT2L04hJXD3AvCYjBD9yREHtmzf3wc2W0ny5fVXkeT7c8tt1Q==", "9d54dca4-5360-4ddd-b962-54f46964423b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f712fe7-6c2b-4778-ac95-52103dfcb232", "AQAAAAIAAYagAAAAEKB/79VZmPnUHcWt8lAxE74w1uS2WCWCuf6YrvACRu7AIlzTfWMecv4U/XXSuO3zwA==", "787e0bfe-8248-4953-9dce-81b2f54a9def" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec394d4d-4bb5-48c1-9dac-eb30b78b77c0", "AQAAAAIAAYagAAAAEJ1tsDnDB+B7kqXB8hVie2KK6GObec8cNUOIuEkt3T57WZNPg066HvGPx8xHu6aDaw==", "2cbc1ed0-398a-4adf-b414-610c5ccbb9c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "13760489-7b90-466a-8ded-48478694ad44", "AQAAAAIAAYagAAAAEBwRE6IjSUf7i9BmdAWwqrhIatGeHr4M0hP5h/gmkUMb++22IXALqtHdcW2q/oNzag==", "6e69f99f-22f5-4293-a8b6-72cc88975aec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5a0b0f5-17cb-4c63-908b-59a2ae47f1bf", "AQAAAAIAAYagAAAAEGP2GO+Ac379Jt1Ik6tv93P6djrYHg27nnQMzyxwlRksY6M27pj3ditR/+Hf9HmOpw==", "9817edae-b667-44e3-9657-330ce8445957" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be24cb90-d40b-41a9-984b-8f90b61f4f4a", "AQAAAAIAAYagAAAAEBPOXD8MCNXxcRmOnZ6AIMaEsHPnj7pt4eD/8SFsLJU4g853u/W31EhkmMC3VnMlcA==", "f8911e67-45ed-40b1-832f-759947e9e136" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c417558-7977-401a-b66b-6810c3719de2", "AQAAAAIAAYagAAAAEAs02Wi/nvNBgv2Cus4kv1oCpWSsnsMyv0ociSlbkpQ5thiEAx8CV64+kxIDIj9tQA==", "82a8a4cd-08a5-48f3-bdb0-f4b5d60c88bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a584e075-57f3-4046-b4a2-4b7b4ee399cb", "AQAAAAIAAYagAAAAEKgAaXsnBS4+ob7F0doKqDTau3BkbzcVqjLe0PF6ib8qhv0CYb8JPHrskFYgIMNH9Q==", "65e46b2f-8fdf-49df-998e-1762966a7859" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7421e4cb-597e-4261-9bb0-8783d2da08ed", "AQAAAAIAAYagAAAAEDNhMQVEF5MG/ufc0mhryAh2zdd9KQkmy8t8ZqH792mrExEUGxjmVOPRF9tKQjKaqg==", "adaf730d-8f92-4a5d-a0e3-dd8bcbe7b738" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a81e317-fd40-470e-80bb-d6c12d9ba7e3", "AQAAAAIAAYagAAAAEIpWVMQMO4mY5XO8lmCik2aickYk2W9lTjXxS1KwMxSD651BAVL7aUONCZZzNPOpRA==", "aad7c3d5-7cd1-4b6e-8c40-632391f06d62" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "704bb2c9-7406-4fca-b1e1-fe4d05983f23", "AQAAAAIAAYagAAAAEGwmBTdoC9FLnA1/NUY8AIcOTltFGiONTLvBHqKbeI1tDe71S3Qvq3pBGZiAW17rOw==", "06c43787-16d5-4b3e-b472-0564242a55f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "66db3a64-a938-49eb-ba34-a52410bdb3d1", "AQAAAAIAAYagAAAAEDXjryOaqYr3LF8QFpOamv/zeHtKa5ytpRrWmObw2obK4oOzKkpz80fJCAx1u8u5fw==", "fe2a7572-49ba-45dc-8b75-01e9ab6ae57b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "85d189f0-6e64-4f03-b2bf-64cea5ed233b", "AQAAAAIAAYagAAAAEONxMOIX/4iFWFEc/qoMUruMm/DzUw7gDF/q3BBSmnGhXGzETgSpezGsjk5ZdWzdng==", "77e0e828-a69a-4846-95ec-b6e9265302fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b5bcabf-33b9-4e5f-8978-3edbca7885f9", "AQAAAAIAAYagAAAAEGj8G05PsgHOY/QeANCVA58pgJydE2wudo8XHhnEOwoTJfeHa7MzyTm+V9/99bTl/w==", "76e8916c-c67b-46c4-9b58-f06dbb6c1f73" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69ec3efc-9644-41e7-895e-d25af1be55cd", "AQAAAAIAAYagAAAAEIJBjKDHt4qNiv8sISnM8iHJoZXfgXgrbFC/GUex9DkyJkkUdc+va0xbzJdguzhNrQ==", "7e558a4f-c15a-47e3-9d8a-4323ba4d35c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c1726b20-49fa-4c4b-9377-b767630f3bf5", "AQAAAAIAAYagAAAAENnTl0SpC/dRi6eAJbFaFoM+hQRK2PPc96mHPbu5hyrbXhMegugGFjL8C3Q+asgt6w==", "4585c033-7670-4dda-880b-87f653ff226f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24ce2aa5-8d40-4b6f-bf62-bd1d2193e714", "AQAAAAIAAYagAAAAELHNQhN5jelaEkPRikNh0EwKbSZupbBaa3xo6vSKtVukETLdYlrD2VBypmGCw3C+hw==", "4e07b346-4c5a-4bb4-97b2-fec547bfe88c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74cd819e-5b9a-475c-87cf-8e2e193cc3fd", "AQAAAAIAAYagAAAAEOHMY//+XPrLE9G87qq6T1E3KewP/kHATffm3R0Y7oNGhxGV8VJhit5o2nwBSwBPuQ==", "87fa1b27-2d72-41e7-bd70-1259b5f52cb2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17ff6f35-00b7-41fe-8fa4-530f582bf2e3", "AQAAAAIAAYagAAAAEKyy4A1qwZpj11H2lw7w3Qt+TP33shJFOMTXOF11KPtY0a4/elo5Hn3KIj+Ug4L6ZQ==", "a2b6e7a6-538f-467b-8068-5707b1babad7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c7ffa27-fe7b-47f5-9eb2-af7b45955d97", "AQAAAAIAAYagAAAAEBVgmwistBV0VgTchsdXsfpx0zCTxOTqRU1y2USob/FH2DS3a0L7z5/VqA5ujuhjFg==", "ee197e41-5677-4489-b540-0447cf9ef324" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72fe632f-ff27-4dc2-94ea-9b315d2d7dfa", "AQAAAAIAAYagAAAAEGcvYVs9DBnvYou8I9ikj5v9JFWPU8G69mnEq5HV/cIftBcbHHlQSMy2S0p6z1Ywkg==", "c2974be2-e8af-4d47-b775-32416ba15f5e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d5cb0ef-928e-4a12-9690-202c529c7875", "AQAAAAIAAYagAAAAEG0kbEu/qO/9gL7wg4EF/30OZnsGNF2rKimQ0qgKrfB8MSkqaU8vbBFl2AdmmVwjCQ==", "8c84ed4d-24e4-4723-8b91-862d0f6717e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "92718e87-c547-4096-8146-e4fdff249bb2", "AQAAAAIAAYagAAAAEEw4mEOOR/fWSBD4tlId1HW0Ahhn0ZvrqDg1a1QjA/zFYKqX9+HXFKrgeZj5fHGdlQ==", "72f006ee-2958-4486-acb0-d88c2ee50819" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e145f452-eb85-483a-a261-141890e5f8cf", "AQAAAAIAAYagAAAAEHwnd1h0ToGvha3urGwf0rw2lMSlC+J8BtZ+tKwe1X2SW8yoY6A2oBgjSxrnTo3Wbw==", "90be9177-1af0-4b49-a3db-13dfdeee44fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "462b0c45-5af5-4935-8be9-267d0c8578f0", "AQAAAAIAAYagAAAAEN62lLAbU5HQx/4iiIyR6iSxMU9EWgXJZ1aWdUN6tKg9vo4ZC0H9Fz0wernp7V5JHw==", "5746005f-b2d9-4750-a5b8-65b12a9299c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cdcad14b-5a14-4838-a814-0a4523af42c7", "AQAAAAIAAYagAAAAEAWBUrnx5bl5jDO6o8ZG92YV/YQ5Qxt1htF3vPW+xm/BDM4MbbTnNQlHfNn8F6BH6g==", "48aa5078-f68b-4bd8-b0f5-fbb726fd970a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1c98b21-757f-4012-be43-df946e9a6ba0", "AQAAAAIAAYagAAAAELqfwXQKDqHo40xwad8XviEbXrgMpDwDH9yyQXCOWrRjyJTnsffoVg8Sbptu7jHTbQ==", "1036c7de-caec-4f6a-b6d7-0ac3f51a1de3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9559709-73d5-42be-a40d-5fa1e095951f", "AQAAAAIAAYagAAAAEIdvlmt+RoDtzoOy/3V3ogxdadjj0jlxaIlmqVNawqD0/L1sMhyE8ADXMHEj5RuhRA==", "e704c956-2e70-438f-995c-b748f30bbecd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7ef5d41-7a03-4caf-bbcc-eec3ca4a5c9e", "AQAAAAIAAYagAAAAENiSXXxZni3K6I1kXa7ZAD+1I0cSsDmXsEn4icYMFFTz9FO5+JEP0Nf9zSKNFUSJBg==", "f1211236-9daf-47c4-a2ef-382204cff34a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1cc67e3f-8a14-4f5d-989e-6064ba333a4e", "AQAAAAIAAYagAAAAELdui8Zt3eeAu9dgUxkUtyyMYlGF6wnYkYFsXoRgEjciStpJbgQyMFIMglQCJuTY2g==", "ba7ce13e-7e91-44c1-81bd-474338fe24fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d6e92e0-16cb-4f87-a18b-2b4f6fb033f9", "AQAAAAIAAYagAAAAEBL/Z+/AKegTnT1swYYS7komAoHohHzNvRFHTLiJUF3gC4/fa1vsAOyfiXxc9C+MBw==", "cbc81a30-417a-40a6-9f36-b3012f9d464c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0564c112-b15d-4acd-bbf0-bdae7d77690c", "AQAAAAIAAYagAAAAELKQL2mnqczgzXqAtX7KMuut3q/TV51bICUr3AE7z2VbqMCzDhh2wZCV5RWp8Fpe7g==", "2c2b3622-4a38-4490-90df-6188c11d2e69" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd69e5a6-285a-4b75-b0fc-7d54be2079c1", "AQAAAAIAAYagAAAAEKQptBWLYs3lRAJyfWPqLvH7gUijFsk5SpWNFunYPRh5UBuIjSS3jkEsX4BPejsKPw==", "bdb31eef-9d1e-4f56-8883-9cfc5f2729ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8013fac-b86a-4987-b5f0-2e2f9b31163b", "AQAAAAIAAYagAAAAEAUwYQ/s1o3f15a32/ixnVwJqeirbtIwEIulQqGDgbbfsLQorsA0jFfy0YnbIZDNNg==", "1301893f-b805-4808-baf0-f89cb2a74fca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7149acb6-455c-4970-a8d8-790c7ebbab76", "AQAAAAIAAYagAAAAEJU21Uu0ghlr3+M3B+IorGwfrhtY25V8gfbc0trpS23Se3CArnHvon2HqZYq9svg/w==", "e59259f6-de9e-416a-9f10-50b452fbee5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67135813-401e-45bd-b0f8-0899d86316c4", "AQAAAAIAAYagAAAAEOv77O6tNrhunS8mcKt8P3rsdeQd057M/l8HuHw/f3+fyl0moCHIGIYxqHoX3qleIw==", "aee25f28-f588-4316-b8e3-99abac6419c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c3a9351-df19-451d-a97e-3764955fe451", "AQAAAAIAAYagAAAAECzSvLSl4voQLisAggucCLJf1IB5bq6sY72mNqfuQbLp88YTXUzwu+wBU0J21/bKuw==", "66dd2d50-74f6-4539-9111-3b121e76943e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "afc2efd7-cd7b-4204-a261-23252af57460", "AQAAAAIAAYagAAAAEKiZgVjDqj4035QaW8WxJcuUdOkwNejBl9FEL0ftsVFAGpZXvuaK37ibGLE1oHD6zQ==", "cb028298-e2d5-436f-84dd-920085c515fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71761ee1-7d06-481a-9883-92ea1759dca3", "AQAAAAIAAYagAAAAEEj4mDTwPeBHUhRrEOuepDND41H1Zrukw1ujOteYABjkgYcFSa0RhjQoLruzmKaMmg==", "e959ff18-8312-4ee8-9d43-cdcdfd6a5b80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e272fe6-0436-44a4-99e1-462f11d83efc", "AQAAAAIAAYagAAAAEEuFCo326E15ovMR2R7I1fT+hrcdl09C6J62NPgDEjIRa8LJMhxVUfb4DppUkQZr4g==", "d2649a7a-fc1c-4a98-8c79-3168163fe687" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e7bdaaa-cc68-44a2-a21b-b884c470b122", "AQAAAAIAAYagAAAAEEGcY3X4GfJO2I697sEfM91ygbkXMCs4m77ibPrBGH29GjfmFwIRxjNMpN2GnEVgCA==", "85c8a099-0172-4995-93ec-bceac7999935" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f097aa90-763f-4581-bc3b-34ab06549dff", "AQAAAAIAAYagAAAAEO4DRylRCRVXoywll6C3isSLf0zBgDSI3P37ERlztjvq2ld+ftRd5/A/Pwi9G+H0hA==", "4eec65a4-3db5-4e14-940f-34b824a6abdb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ce831b0-d915-49cc-b842-f026d50e8880", "AQAAAAIAAYagAAAAENSSIqDRI5IvNywXR08LdQ6GwkO4rRK01UhaXfa32nWPIWgfus6TCwTjg1VWL3a3Hg==", "09b5eab9-1a72-4271-912d-a3a004e8357e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10ac332e-bca0-41be-b9bd-7583f54d9c58", "AQAAAAIAAYagAAAAEAxaxZt9WO+DEVKr2UVfkY6L3gByZIeuDQlTOSbJNsk9zAIqXYt2JJMWbgsHdRCT9g==", "a14fe643-464b-4761-8da3-8ddd1657b7e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e09905a3-8747-4653-beeb-88b814f62781", "AQAAAAIAAYagAAAAEIS3tZ+MkOZ5RY+80sORrhv9IRss4qOu/scDBxsSKCkUjshM8qp3d9JMdfyAu7Wyng==", "f9153255-2868-44e6-92ab-df2f7f9384a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b61fce8e-c227-480e-84f4-7478d4be58ee", "AQAAAAIAAYagAAAAEODZTpuL/j2VC8b/XOP8TVSTipda+zCFjYq+fpii+YYwDRAR76C33T1ozFd1e9Ksqg==", "40731554-2dda-472e-af3e-1940d8acc45a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f71e77f-3724-4027-8102-45804a59d781", "AQAAAAIAAYagAAAAEHoW4EwOegeOykxnCtQ2lW970mD2TycfAjsQ4AjO4v30rnLkaAl31tONvnXDXBEBRw==", "c1d7143d-ffcf-425d-8c7f-70cc18c74781" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d85c260-666f-4d56-92c6-31ad0b405591", "AQAAAAIAAYagAAAAENB699G9Nx6SSoHYzFbLrlVVs7tv4lRC1xHfwkaUBh98mCdrzDUi+0/XECR153+iRw==", "ea84d8c7-f62b-4607-89d6-58c2bc6178f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4747a9f4-20ba-4f25-9dc2-3ef640d50f28", "AQAAAAIAAYagAAAAELBqzmYsMa/sMcuGSYJba/Z3PSXWkWcQ1KKFLZvbswqkFeNXpYypkAHFUR7dEA2aRw==", "c2e4548d-a3a9-44d5-84e7-6df02683f156" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab1b62ce-3b48-4f7d-b84a-8c3c5ff9af9e", "AQAAAAIAAYagAAAAEKOyFdnmBySBMZEWRlv605eADvI2JCIURBiCF+Oqjc/HM4lz77GAUSA67aV0KGctOA==", "3c7e1b15-96d1-460a-8554-d27afdffda08" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0710b58-7187-4c0f-86bc-a1cf3ddc70fd", "AQAAAAIAAYagAAAAEOiIepX6EcnCukdzKmnVkbRL1zs6D7YEciwKZnD/mY4MKSNbGo/ojzvaEZJEiL87mw==", "dcb86e92-5598-4802-b402-a115beec9510" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0f016bf-7cc0-4261-ab18-8bc4d248fb20", "AQAAAAIAAYagAAAAEGczp6gRD0RjfO8NwP010CvnzgHKqciFwW0qTwDS2E4pXU3yIwiRtl02syaYeCkpyA==", "5ac62598-2eb1-4170-b5b2-e15be51e9010" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ee4589e-c4fc-4512-beb8-e42fe01bae5a", "AQAAAAIAAYagAAAAEKgI4eZDXT553a6O9h0yp4pURqS4yiWPvYrA/IsLdOCz0PyAr1b5EqZre3qNvew6yQ==", "13bbb126-b096-4455-9be8-cbc3f08273a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cfdca22-9e35-4fb8-ba12-d9a1dcca2f44", "AQAAAAIAAYagAAAAEBrhoZ9l2ae1tlavbxwSylX0apiES+dqf/NCPjObezVbCPiaRnZt683/Y6xP0+pueQ==", "5666bb08-1180-41dd-89bd-79ba54cdd0ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac8f792f-de2f-4dc6-835c-27c75093940f", "AQAAAAIAAYagAAAAEFQk+IrM40P0i2BC0x8lEU1Rflnl68Bg/ska1aPaYwIpoSlCJ9bsDcGf/h9UHfWTZQ==", "91be9bb2-fec9-4e1c-9e27-1877cf869739" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f73af726-79a8-423d-bb7d-d7d2ceaa926f", "AQAAAAIAAYagAAAAEOjSv3vOVzWZvhekgea3x41+TMAyjgEEjsH6nXHNaL8RlvCOe2DrMzttd86TOUSWyw==", "fc3ef20a-6aa9-4808-91e9-0b0dcea19635" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2979502f-51d3-4306-9103-4cef20649b06", "AQAAAAIAAYagAAAAEKNNtTcllDhl0Z+PWH3BRM3bIjLm5fmOWCgfgGoHb6OVGCQ/eGbEWGsNDj08eglj0Q==", "9594a81e-f7cc-4394-9b58-4510bdb74c73" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76590441-1a85-47ac-88a2-e5ef4fd394eb", "AQAAAAIAAYagAAAAEI2y82h09X5RWwVsDQq5XCVMhaZjJ2sKihu7GYb1NTvDJ0BbIJ/OqpFYF++PSpgD4A==", "cc56e149-a89e-484a-bb79-a7040e3bb75f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bfee8483-1778-4598-80a8-2ccaf1dfbbd7", "AQAAAAIAAYagAAAAECIVEAmEHAj4TtIMg3AEeT9r+ejK3FenTX4Fo2Jahmr3GoIcBU8NkCeBPUPUk0qn4A==", "ad012f32-60f2-457c-b138-6c8b263c6c53" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f33e46d-daa8-4710-a838-99090a8a0399", "AQAAAAIAAYagAAAAEDLZqLeBKPdRn8RmlF8kOLixjP4JSBDL+7TZ8t0KsFT4hfwxRndwJW45CVYGZ2b/kA==", "db601398-f9aa-42d2-9014-b88989c6e3e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a5fe16d-386f-4664-803c-3e46e239c064", "AQAAAAIAAYagAAAAEM1OVJs+EVhXw25+X6V7470kaPSVYCZuFwcMApep3fjb4dyeBNX85Jx1hQ8+ABeaCw==", "f26d1b4a-ce45-4ea2-bead-779e03c645e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ea31533-e06e-4e42-a35f-383c57f7c52c", "AQAAAAIAAYagAAAAEEwY4ssmf7HVMcbT4vPHixwwbw2siiHPWeBv8YhGz56d2Q6Nkkvb4H7oTr4P1Uz45A==", "12dc9091-a429-40cb-b4ce-109a9ff5c4be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b4d291c-85e2-4739-9182-9675fbd662b1", "AQAAAAIAAYagAAAAEE/BPQFwhPgTkvJKP2jBB3n0/BMtyWexZUBzO05sa3whH51P+1Kn9QJgLDsh+2NhUA==", "2b8f6e0c-4304-45d9-9e27-f5f50e8cbf98" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fef0936c-68d2-45e7-9988-bf193c8a3387", "AQAAAAIAAYagAAAAEGwXU0QI562zmD62R1sPXgP3kNSoY19DLREz6Y/62LRnvq4MrMkrKrx2977qIG0gHA==", "115d3e2c-485d-4d9a-b713-f2f73e4c6e2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e09c722-31e8-48b8-b950-1c1c3ba3257b", "AQAAAAIAAYagAAAAEPB9SlJDeVUGPVQmPCDoUavl10voIFpnUBg+8zQ9D8AH+V3FDMdqjEbsUzuo953xaw==", "ba6275bd-fce8-46a3-8f96-be043e3c6bb3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e5689b0-3819-40b1-a476-5fe09c2be6c8", "AQAAAAIAAYagAAAAEHZ7HEWN/oDwXMYA1vOte/TxqD/WPxpnIq1y/uZPAvqu5Z4nR5dn5OQ7ghQZ7o+MeQ==", "85ae9dad-2fdc-4182-a175-12323c76db12" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b07f8dc-48b1-4636-87e9-39facb4b0670", "AQAAAAIAAYagAAAAEASj4ViyZd8y+yqwtfEoO6zPX0cOFVG/aKaxpZEMeiSM9mhjsjBxTO/GIrmEu/eJlA==", "b576a6d8-b48c-4f78-a3b0-56a940d57432" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc7e3136-fa2d-4808-9bcc-12a0bd90c06d", "AQAAAAIAAYagAAAAENXcXKfKFppYK2nNG+hfYE0/rLF2jAOiMfJcO+t0jY8vFlpwGUwZUg2qyVfja6f5dw==", "233a4a60-652f-429e-b493-64d4995c51e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a27669e2-2cc7-47d7-ac21-d7efe35727e8", "AQAAAAIAAYagAAAAEFEINn2VDOAbf7wEOflTaEgHjE19MqhqTxI/UpOJqVglL7Zz7FOgEkwQNzgF3DwKkQ==", "e2f7ee2e-8035-489f-8b16-4a30160dfef0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c3a78bc-9e68-4dc0-954d-37064e946b46", "AQAAAAIAAYagAAAAEO6ziJTtioYimFQxYrc6dmcdWExWvzk2nREiWauihpDTqmQLSNwQgFCsChTnM5gN0w==", "494c4ec5-3c45-4fb4-9d71-ca88409afae0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5699553b-5d84-4942-8a99-bbaae9232581", "AQAAAAIAAYagAAAAEDu49t8/Ux6l8cCxo+0AgENMC410HqC8CKwaQZNUIkRLNjXfm0XBJOGQQHTQ8YbPWA==", "a4b3d0c2-af7e-408a-aedb-e57ddcd8c808" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c474accd-ee62-4e33-a083-b24d1fe8cf05", "AQAAAAIAAYagAAAAEMQYCc8UVoOf4M90VXRLzRBUDga26OgRqjAP304aqyaldOCjuS2HyNQt3NeseCes4g==", "cbd8a9d6-8074-4bf5-90b3-c016744556f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9b2efa9-ec2a-4fa6-bbe9-91f3494782a5", "AQAAAAIAAYagAAAAEHT+3FkIqqciHzDS838oogvnEco24zxJx3DSJnj8fsi+E2V281R1ri715i0HLVnqWw==", "f93eaffe-c067-4fb4-87a3-04fc54976590" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "756abb65-94c7-4175-bbe1-e02e3cef85c7", "AQAAAAIAAYagAAAAEJhwCyxhcQDTPIkY/18nu9df1M6BRBvBcx9ZOLsI2vAPDuVdzM6FjiseAFKBGgGUPw==", "a585439e-d029-4990-bf31-20046b1bf71a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd4cdead-a744-4723-bdb0-858b34b68778", "AQAAAAIAAYagAAAAEGKSrCMw2ny5j3m9pZ6947FhgSMH9OqOb/ZaTB88DNRYLSAedvHYx4Gj9AHanJZAjQ==", "c4b8fa6b-a884-4eb9-9974-030c9e52289a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "343070c8-42f7-4a04-bcfb-20db162764cc", "AQAAAAIAAYagAAAAELuCcPm5uB2zdudAHC25WVDnKl1K0HQcnsu+kfIqWU/w2vSFHkt/4infxUq8yVg0/g==", "6e369302-588c-47a9-b9cc-b5be7fc9cdc0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b5e489a-e74e-4d40-97c2-46f950a9074d", "AQAAAAIAAYagAAAAEL6kFOKULMk80PDediGM2Jki96F7hk0DhCsC/qatqOpjGXWmwJFLYnR0Mjitvr7KIg==", "8644a041-20b1-4342-93e3-d8311c3bd2c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0eeef236-3991-47c3-a6e2-6202e37e9568", "AQAAAAIAAYagAAAAENEWJ0WTV1BRGuzciv4Zh6QqGVLo9mbOYuJiiL5fYpDoQbX01J9FM9PNvdG/PGzllQ==", "ee3eca7c-3e1f-4da8-b635-572a83936f21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2656462-b1db-425d-9953-eb0165ef2a02", "AQAAAAIAAYagAAAAEIuACr5EREl4y0LKepXV5przcthHQIsA35VLcIKTcatvQK6YkKyKYlrGjGZFW5/D0w==", "da05f7d1-8c61-47cf-b6da-baf3d5c83523" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4b88693-3614-44cc-a739-a57d743ff213", "AQAAAAIAAYagAAAAEOtOAFOfK6jQF6nND/o4u4WsjnIb0eOJg6T24zrqRakey0Ay7UyVgPVwv5FIij2ISg==", "d2c7c2d5-b6c3-4608-b58c-66b3740d0ee5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b542867-5822-4a4b-a0c9-ab709f472c1e", "AQAAAAIAAYagAAAAENDpTK4c0Wh6tljPDO6XsROb4enLlRrLkQA577LHbPZDp9xHPo8ZNW4K9AYzKswbaA==", "d7850047-a659-474a-ac3b-e8dd6c7ca4f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52997eb3-414c-4979-acd7-076b23693dc8", "AQAAAAIAAYagAAAAEPaSDa5XztTsJWCoWPpGeJdfzW64T85faImd0W6U9mc0K65mguMhgDQtgoXmWxO43g==", "e101f8b7-7a26-49ac-a5cb-467955aa742e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4f314c6-6869-4f9f-8bbf-26d98d14428a", "AQAAAAIAAYagAAAAEGO1bdxdyzeZn+geU5U16YymOWzEbSzJAaHG2ZyP28w3eG+Rw2lonFCo5WKiJlii/w==", "2a64abbf-f638-4f56-aa71-4357bb65cf97" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "397d0f27-964c-4897-aa97-b83077361740", "AQAAAAIAAYagAAAAECzRWkLlEl8nHeCF0sYvhFySczz4tsrGRdE8V8L+ysSnIxz1BgBB6Wv6pWXVGU32xw==", "ea12dd32-d778-4613-be0b-d3248f57da5d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dfad9761-4d20-4346-8188-286779d8e31d", "AQAAAAIAAYagAAAAECF93GrqkhEHLBxoYojYRMmBGPGMiLfPNnW/GWID0aNj5Wbj3yjR0c1NOMYjofH1vA==", "f6ccd4b7-95ce-418e-9612-72ace5a1167a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bccca14f-0ede-4673-affd-517010d4b600", "AQAAAAIAAYagAAAAEBk7XBIFarUhSIoR5NYMTEvIAhvWK2x0N1TDncwDo+yqC2K2Vj2Rh4o9xAhrriPaPw==", "d962a094-bda0-48ca-a7d4-05661836ae40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cae2934b-755b-4589-a716-b5ee55e1b2f8", "AQAAAAIAAYagAAAAEPW9GIOjgZYFiIkTnulgCqn9SrZjbCupINNZNk5Hw7FTqH4ygkgrBs5TKmIyeSQiWQ==", "fda6fbaf-e902-416a-b841-9d9604436e78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "43e7784a-918a-433f-bded-d0ab2c5921e0", "AQAAAAIAAYagAAAAEBxk1gHRw0ffvraG1svrwVyPyAt7w0WctON5Rf31vbgnVTr76IasugQuwdAFXd9ieQ==", "5335f2a2-1811-4a60-a825-c68e13c7b584" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "29dcf423-a805-42ea-8efc-6e8e7cf3329f", "AQAAAAIAAYagAAAAEAHu0Bc/KTIXrlylYvASSiB1mTF/vn8Jaah3Tk9HQq7+LFVfd6ELX1l0V6ynlMhyDA==", "77498d73-3ede-4868-b7ca-31cb412f8afc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee0cbc5a-2d65-4908-a283-b5314d1b5797", "AQAAAAIAAYagAAAAEIkjLxeXCelTjoAGwiQoyhDwGnwCiNwodQX9kc2MhDlu77LIH9qHZZThEDPGwiRDYg==", "ceca3cbc-b1f1-4645-b4e7-129c7dda61fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e2d4cb1-3d34-4ade-a8d0-a0cd25fcb55a", "AQAAAAIAAYagAAAAELfZCJvUQWGNepRYjgJhFy1bqJP4pTQScqvAsi2a9hY4Eu+k4+YtAF6hBUlis3P9oA==", "411fd541-1a5a-4d50-a0d2-f99507e41a3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8560689-d081-4d13-9380-4e752b1c35b3", "AQAAAAIAAYagAAAAEBnAt1wI4Uyd1di+27KNItT84DtXg5UZoA0S7eRIHPtW7xnsgMLTMxvUw8tmXcFoxg==", "5db17b7b-e2c2-4837-8c08-c6a89948d369" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e314ebd4-1182-4aba-a548-f0902c7b968b", "AQAAAAIAAYagAAAAEFsMCccJexbb8ZyoXrLizPBGVYXDqG1Vuf6L4gvE8tcknIxhIItxmHcRYCRWFNdcSQ==", "2cbef8af-34b7-4632-a1f6-66d53be98365" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9981e3d3-a61c-4150-9e59-38975446f372", "AQAAAAIAAYagAAAAEEAfMH4qDe+0KAIhcjeq7lrytPyF+enmokbFzGdsY6RBh4xdfnIc/jld0k/8mAkhfQ==", "8e497c34-8545-447f-a8ab-cf48ea043f19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48551e23-ae1b-4af2-a419-9d9ae335c969", "AQAAAAIAAYagAAAAEKNkhPGudduGlOwYjNCNzsBUBcdengggJ2ZG8BqpAS8RMvlRv51QCZ7s9/PUnNkwRg==", "5b79d19e-1805-457e-8e9e-6cf3fe36c235" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5ab14b5-2f9d-4ead-8c6b-0a6844c1926b", "AQAAAAIAAYagAAAAEFKiz+KWU2AHOF051BM9n2Lmc18riuxjRXr70UEqPylbTQMpaMFesaV0n1Zpuu830w==", "a1366169-0bdb-4a39-9901-3372e0f65234" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0954ec9e-f153-46e9-af0c-0e3a44cb3f10", "AQAAAAIAAYagAAAAEEDwhHvZC9lFixlBa4EBEYsKXMfe7has4AOAJICNtEYDUCxGx2ltLy3Hwy9I0HaZaw==", "d1debce3-d363-41a6-b11f-ecd1e1bfaeba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9c90fe1-a6f4-4b6b-b4f1-8b840c13e3ac", "AQAAAAIAAYagAAAAEJKQ8OUpUr/Yr7T4RhEIq0AdOaU/7F0Sv0IGRxl28MMSpfrVycKCrl0rjBEDmfcK5Q==", "3f998f15-e2e0-4958-8d5f-9f887a6ea5ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06cf1ae2-4bd3-4513-a2f7-c2ab56b32e56", "AQAAAAIAAYagAAAAEJcnd0/LZm+G6FE8d9Vm6lApnVzzQnu638eZdDwHpNk2S4HXLkQ1FxX7HIKZG65pag==", "05986fa6-2f0e-4580-b1b6-19c0accfb2da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab429bc5-3661-4177-a621-a80041ea2598", "AQAAAAIAAYagAAAAEPzWjiA8UA6I8qy4jbUL9srV3WwOhHvquyHwh2H1AUIVWVmhcUomqNtLfmj9KJYLiw==", "184123b4-a1f8-486e-ba4d-10b77e17606b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93df1451-539f-43b4-95a0-734328ae16cc", "AQAAAAIAAYagAAAAECnvXMAtzAPx7jnU3FBSixzf49RjWQbQ5kpPapxexPrMgMI7Vxjw5TX69xdu+o8+pg==", "38539b5a-64ad-407d-b1db-5566181fa786" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd858bfc-43c9-4380-89e6-addade24edc6", "AQAAAAIAAYagAAAAENo45wmgjYPEhjkuxn5zMU0wJo//5bOdMe1dtwtFpLy9eyecz+iwlCX9evIYdYC02A==", "bb872192-5a48-4a69-8b01-dae055d69fa7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52e67bd1-393d-4688-9b1e-58d734b622ec", "AQAAAAIAAYagAAAAEGXZUxjZJTsF0Yd9YWivg076/3dmcf9rr9XKRwrjowRqMtXEi45wi7WYxfiTW//jCw==", "015e3b50-b8a4-48cb-bdc4-6eb4503bd6da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4158d52-64db-4a65-ae48-87b2a183c5cd", "AQAAAAIAAYagAAAAEF8OjRcBmV453EYCOypVpluNT/xEmVqdcsnK25lQqiT/bI1KLktetron9OvjkAWRww==", "38d163ce-c67d-4bea-9a76-2c194e82f283" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d389dd2e-13d2-4750-88d6-3691487c7374", "AQAAAAIAAYagAAAAEJ0XuJnWBtzelIZqi5dhtYup9XEJLy2YueFaALoYQLBAfPKOV/9YYxmVyCsGdMRv4w==", "ee05fd6f-dcb6-4e75-88ad-d0f69d512fd6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb5c6332-e368-4ea8-ad12-7f9f03247fe6", "AQAAAAIAAYagAAAAEBdimdqcS1t25/48UdAeqTGP3w7s8z1nLKqdB2vunvywM14mdyppnCCYwwOrgVoUVw==", "1787eed4-979d-4bde-a62c-031c608b3573" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "891e675a-2eb0-4058-bda0-4dfe8f1dfae3", "AQAAAAIAAYagAAAAEIeuXr9mZUB+uyeRV3CD2QX4ANyMRLH1p0Htirt6CThfhjOkzP5edAVvvxWxJg+rEA==", "d83a1dc0-70c4-4d92-8896-220d65864aaa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a6e9f08-00de-4448-a738-e006726c842a", "AQAAAAIAAYagAAAAEPc7bH3taHC05WRz/jBTg3pc4OG8uxoRDcMCB1BumQA+3LZs8mDmTQvdT3zkMVqRsg==", "102d7de2-2e8b-4884-bbb1-3948d5647274" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "318ca9dc-109d-4e82-9570-79409935d029", "AQAAAAIAAYagAAAAEOi+EI9NCykOAYJ73uZsfxbKwG/68TZCQHCaReDwcD439oaeFVeeBmD+yT88KWJxXg==", "61f4f701-5211-40d4-a9ed-af6e4bdd7e7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab254828-16b8-4bae-8980-a5415156cde6", "AQAAAAIAAYagAAAAEAW5EktjJqJZnvUiH3WFUeQY40IpFlg6ZFFrqIY6PJ23ALQndBbYF0qw/PEe+M6A8A==", "ff2e1d79-53dc-4a50-bbf4-06d7e9e0e41d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8f93c28-a6b8-4cb0-869b-106d02c14f50", "AQAAAAIAAYagAAAAED8WHavoKkB/5yD3rglP+zLA46tarlRP8H/TPSHrOEIvOt00/8HHWiGl5y0zrAZ4uw==", "ed48dbfa-a3ec-4926-919b-34231b4dc509" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2af47417-38a4-4c8e-9ab6-af60d6ca9d74", "AQAAAAIAAYagAAAAEIRPxCNL9bLndkiJBT4jGD5/ckh99NqRneWd8kw0Gcw/YGehVWTnwBf9j/qoAcuwiA==", "50425ee9-e7d8-4dbf-9d48-3eeb33162481" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95ac2e30-a0aa-4c13-93cd-45808f415b64", "AQAAAAIAAYagAAAAEDK79RpkBvkxROojW84fuBREPv6IzDgQ+WnpfqFhtit5vuI2z2JEX/tL9qnusSB6Rw==", "d566e720-619e-4d30-8e22-93192f4b2f67" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7271fa64-0b02-47a9-88d3-8a4b62443fc1", "AQAAAAIAAYagAAAAECfGNfu8Ht11SIQEtwQzfTKprhl7O5FwbLx2QWY81XaDirse0qtFmJvRbJcO9mLjLA==", "b3535b46-992f-4f76-a72f-c86500e572f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7000cece-cf00-45c0-987d-080c2a5c7b13", "AQAAAAIAAYagAAAAEIQ74dJtSWbHF40tEGPadClq9Kz0+dUgo3Yj140/ZNCa5Sfli/JCgcgooVLS2EZYKg==", "3f723833-743b-4e1e-b507-d9e63ae12578" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "03466dd2-ed10-4acb-ae74-c4c179e0a51a", "AQAAAAIAAYagAAAAENR++6UlDtzAUKzs66noPHDE/rHJZGM8v3v01WgDzp2t2qIwTdra1IHPDmBFznEwFA==", "9dced4b0-9d9d-4de5-924e-732880daf539" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5270596-eab1-4b08-a9b4-d4a6606e9dc2", "AQAAAAIAAYagAAAAEOOxXd+Sbkq3e10A1QAzUC/N3jEUP0rUpJaN00MqWizk0IwANNF7rwqtiyoqOY6L0Q==", "5dc8ac0a-0505-486e-bcac-47552f92b8b4" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_AuditPlanStatusId",
                table: "AuditPlans",
                column: "AuditPlanStatusId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId",
                table: "AuditPlans",
                column: "AuditPlanStatusId",
                principalTable: "AuditPlanStatus",
                principalColumn: "Id");
        }
    }
}
