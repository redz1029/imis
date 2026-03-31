using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatedAuditApprover : Migration
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
                name: "AuditPlanApprovals",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditPlanId = table.Column<int>(type: "int", nullable: false),
                    ApproverId = table.Column<string>(type: "nvarchar(450)", nullable: false),
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
                        name: "FK_AuditPlanApprovals_AspNetUsers_ApproverId",
                        column: x => x.ApproverId,
                        principalTable: "AspNetUsers",
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
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsoStandardId = table.Column<long>(type: "bigint", nullable: true),
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
                        name: "FK_IsoStandardAuditPlans_IsoStandards_IsoStandardId",
                        column: x => x.IsoStandardId,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditPlans",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    PreparerId = table.Column<int>(type: "int", nullable: true),
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
                        name: "FK_AuditPlans_IsoAuditors_PreparerId",
                        column: x => x.PreparerId,
                        principalTable: "IsoAuditors",
                        principalColumn: "Id");
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "d3023c0d-0274-4af8-b9d5-bb5309cff08f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "aea4ca6c-d102-40d2-934a-91648819d1e6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "b2616e91-ca2a-48db-8660-a84033e79600");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "7588ab5e-a046-439d-90a9-0e2c0a528eb0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "0a60f39e-e387-44a3-82a7-379b0c6dba17");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "ceef8785-20d0-41f3-8cdc-f12f5203eba9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "a0d80449-dd4e-4cab-a8db-a0da807d4406");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "c8c76c89-bbdc-4c62-8096-00fef1551b27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "36e215af-d160-4dd9-90e8-117c7e5e8b31");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "59c0d2bc-6e02-4597-a270-2e5b4e2d9d71");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "d23a4570-258c-47f1-829d-d3c4f37a5fe7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "dc259e8b-6ec3-4cd0-bca0-4ae556b1ba7f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "d3f28fad-4ee6-4051-b7da-db560711546b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a9a10abb-e04a-4d7f-9bd5-67aa995247b4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "120c01f0-5350-42ad-bd4f-919f84ed57f9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "1f9de3ee-9409-4a64-b54d-1182aee8349c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "449955a4-f2ee-497a-9614-58dd3dd6ba58");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "29684f36-9d6e-46f0-a906-51595ed2015a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "73c0c6cf-d088-40d3-a6c6-88be0907eb53");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6869e4e4-6228-49d6-941c-fc71720a674d", "AQAAAAIAAYagAAAAELefsb4zFkD14ab8bTscum3tB8usQ5Fw3/WR5Y8+U/ChgcdZ5T4Zwmxap/VCeua/hQ==", "cd5d480d-66d1-4600-892a-23c89d924e00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de647876-79ee-43fd-8b90-e6cbbc411b7d", "AQAAAAIAAYagAAAAECrUnZGwRuqnYq0DEdP+I8/g6kqjNQNqGap6/VIEdlD+DxEO2J8uhhSDEaB5SN4SEQ==", "5c613b10-a7a5-4dac-a068-14721b8d123a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed6161e8-b555-4a13-b943-5cd24e7c4fc3", "AQAAAAIAAYagAAAAEC9Jrt7gDiCAEvN9OokZZhNPda9ldLGmrVNAjdzt0JPHgZODyrhubnRWqxtj5XCSsg==", "84df8980-3cfb-4fec-b8bc-06d59db1ba2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5fa9753e-08d7-40c3-ab20-7c68edaa1194", "AQAAAAIAAYagAAAAEDIMV2SXh3vt2StKZc9y13ZpsT1/fJSRjL7ANet70xDGqE60vlbjUcYOgPceAw5fiA==", "94f1ccdd-0ea0-430d-a594-48eae647ee42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08f608af-0608-4cf5-b2ef-b419b016b87e", "AQAAAAIAAYagAAAAECZ08IBl0d1ztsT86ZesoDZ0avgJVz+jCnYUR5C7G1HqB9CYko+VHIXFfBg315TwCA==", "18a72a42-a058-4712-be1c-e7020b4bd8d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0b8ca2a-14f4-4ef9-83a3-193b5973d218", "AQAAAAIAAYagAAAAEG1IPyzo2ik3KJO0JF0jky49clMYATbp7h7Eo8QoTerwCE9WCbI/QgAfCoV7hhQK9Q==", "55d28cd0-adae-4ad6-bc9a-34680334f4c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3bac9163-c531-444e-b23a-4f4ff4572989", "AQAAAAIAAYagAAAAEHWeLuB5yPTRfgo+Jqg9DCT3eAnNrVPCbLXNeg2Far9GfoN+bM+XBXoV0517TEJ7QA==", "afe82488-4bce-411d-b76c-cc55739026ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c44c505d-dc9a-4779-8463-1c1ed2887cf0", "AQAAAAIAAYagAAAAECrCAPENLTo1I8lzgp3Qgx+zNB+OGSuS2UE57bON/jvEbGRgwENR92SMbbSCUacrXg==", "5c1b576f-078e-475d-9bcd-3aa39e28f894" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "964389b0-c0d2-486d-9ead-35c9e07721ef", "AQAAAAIAAYagAAAAEMouyQJWMLvQkGDppi4aZeANqr1HuOLNDcCkfd+DAogp4ZIzeYK7EwRxSKsLGR+jwA==", "65563f1a-e270-4c3f-a684-28c84ba852be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb45006f-d389-464b-909d-347acf64a8df", "AQAAAAIAAYagAAAAELm5J4CyhLFHRDfO21Tb2jYi1ci444QpFtBp31OfvOlX8qJByKXYexwar5yBPCqrWA==", "bca8aa32-9be9-4746-be7c-c9c3a8a69787" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8580246-ff3b-49bf-b320-4be1184c8584", "AQAAAAIAAYagAAAAELqfduomem44IhO6y7OeqLYlZMvM+ChdYAUviTKf75d6aZwyUZiKYwEpaaJiarjlbA==", "af44e551-9320-4efe-963c-7cada0d6ea6a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6e0e7f0-7ddc-43b3-88f8-59ec2eacd4fd", "AQAAAAIAAYagAAAAENUZ8Ya/vYGUv4zdZ7N5pKvpDlZH8LULiN6LG9hipG3Zm0p9YqkhZiPTr0TTa8m1Yg==", "c44cb111-c44b-427f-9929-3a1bb66938a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0471c019-e4c5-4997-afbf-4a82e46c5d0e", "AQAAAAIAAYagAAAAENlVcbxP227UAQQiC1gYeg6Wl4S9TU35WvSKxbDdbbdSr9tcd56U9Fg8Ka7zgRSmwg==", "f1e39229-acb0-4c0b-b846-8ac3bb520c83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8900006-5408-40a5-8bf3-b4fb06160dee", "AQAAAAIAAYagAAAAECD07EeE1lB8pJ2tSvhLZ4nMgC5SkscJxkEfwro7QzmEFJ2AXn6k9r5ZHSw+zd6j1Q==", "75b92a2a-6f7f-46f5-a84d-728409ea9508" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d68d9842-2504-4639-9b9a-195dd4654753", "AQAAAAIAAYagAAAAEC6CJs2OJq/SgUhxeJ7PArBsY1shc7X+NjO2BfzxRUo59KVkJpvFM666dIJzoT0wdQ==", "c53c15fd-e002-49fb-8959-c35f132f28b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6f464ba-1534-49c0-8f21-5012d10df495", "AQAAAAIAAYagAAAAEB7/pc7HpXgbaderp81SSBDvRL+Oe7/5lBMh5xOkOPIuaz762rZQEKZbJsUckqHcHA==", "5d8a8468-b0fc-4620-adfe-a0d8283c79d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca0944f9-68c3-4c24-bebc-fc0b1c13c811", "AQAAAAIAAYagAAAAEBmZDi9btEOGE7Ptx2keP8TtXQ01aD+tXFJ4g4AVsCR0cJWIrejd0vspdwt69mMrKg==", "eb3d3c2c-8853-4346-b48f-e02ffb753679" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "331e74d9-7501-4a1a-a1dc-fdc528153a24", "AQAAAAIAAYagAAAAEGiuR4Jpx4H1nJdzyPq3+qkrqaemD+F2rIeOF6RQ8abscRJfOFA/T/p/eIi2O+zjAw==", "7c51c713-1e64-4650-8013-800091c658e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27ae3288-5b9e-4341-8744-08edfe9591a1", "AQAAAAIAAYagAAAAELjDJ+D5CmeY9NXkJYFz/0ET32eWpCMBYMgvnkvyw+PCKwmz1wH6Cswo6aOVyVUG9w==", "d50e5bb3-91ae-462d-9194-5cdd1e53ae8f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b521f0c1-6704-4fa3-b316-6936aa966a3a", "AQAAAAIAAYagAAAAEHsLsyyT+NsHEfGLpwJzMNaHusfbTv0hJ9bD7ctJuBBTizaOyRCtMryjuHD9CNXxhQ==", "eef3b999-87d7-4acc-ae78-da9117c0e47f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0033282f-6700-4833-8a90-c728a578b164", "AQAAAAIAAYagAAAAEMkjyRw9O0xfmaQqH09fv/2bcMpXGs98nFRWJiw/BdtICJzpoGHznAaLE94dvexqrQ==", "c8abae76-10d3-4de2-a8b3-a0f98aa54cbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e9ae173-719e-4944-bb75-46704406e6f1", "AQAAAAIAAYagAAAAEB+E+cVbIRfe6C+8yRTNVohY0XbmmqyHIQal/vO4ZsAzlz7Tg8H2cALJ44+ChypHSw==", "abcdc750-e9a3-4afc-be7b-a2ddeef14538" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b8f27cb-4859-48e6-a1c5-27a117b6d21f", "AQAAAAIAAYagAAAAEOCOB2JKel4s/6yNNW9UAugZ9ehTUwv+jwwTnGM1o5gYdrp+ExU1iROVFht53L8q9A==", "abef9855-5527-4fce-81be-28af48d503c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87d295d7-0d5d-4359-aaa0-c9cedef54a17", "AQAAAAIAAYagAAAAEJpK/zAouJMs9q1LJ7aW/wk92NaU2Z5ZJlzRsLkeXDU/SNSjCkEAEqHIGNg4f5WyYg==", "b7b769ac-6411-477f-9e4d-5d2bb8f00217" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54cd11fc-1455-47ff-85c8-de006c7471b3", "AQAAAAIAAYagAAAAEIRbHcM5+76QJKrzfBIsBaNejGK1SY1NN2oag6Z5MjWVSQ7oK6iZ/j4+ArYmEQ85xQ==", "cc643e4c-58b6-43a7-a562-38aacf9ad750" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f08106ff-d800-4426-9720-5be992ad9760", "AQAAAAIAAYagAAAAEF1fnCb7xLyQOcOxH6mk1yZi9n6lWD/bxsq/Yj7Mqj3K6mlGlpckOQ+IQPyP7rgamQ==", "ccd9e502-c373-4047-b441-dbf662fb4275" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76fe4d4e-0ae4-4e48-9d17-b4e6bec61b94", "AQAAAAIAAYagAAAAEC86FdQCra7+jRaw36T+e4B9CAFH1tltWlYZ9Ghtx09UuDc6gFC025ahr7O5LKypfg==", "9d1f3d4a-7024-40a1-b380-85c33482a12f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa80acc7-4f44-4ae7-a057-3fbb8d8b6947", "AQAAAAIAAYagAAAAEL1+jKSicvLdu+YekJBYET4yOwIjAEbaTXy0sTljaPqoPy6rLYrD7e7GYQuU0yYJlQ==", "3a663722-b3c8-4253-891b-7d527701b570" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf827572-4c02-4caf-8880-f855bd0566c1", "AQAAAAIAAYagAAAAEAo/8842QA6MfZrwDNTMUPoWOfWalNPu/Wltq7sp1/oCHcmHf46xSfcCPtJ6SvXwzg==", "557cd776-fa5d-4190-8be3-85505eced701" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "806b44d4-50b6-4067-b571-041ac2971964", "AQAAAAIAAYagAAAAEHqbkXphVx8gE7hNnU4bExBy4enfo6RkWkyuE9ByCTkoE3AFke4HMQlqX3MLNF+F+A==", "7a4a668c-0097-471e-ae7d-13e3d55d4db3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "793731e2-f631-48fc-8ad5-4540e8994475", "AQAAAAIAAYagAAAAEFOITGwpCQ5RRkaaDw3vpbCQo7kiAL8raph4wv5gOvy4RYB3pXFpjGUlybMIGMhCrg==", "c1b89827-5d88-4301-a09c-8a48f3dfe4f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c639a29a-5736-41b9-a032-6e2726dfaba1", "AQAAAAIAAYagAAAAENe+ty3QLkGqHKrc+5O1L6NsD80muoMbMiELWB9boaLDu/lld1MdeiE2wezmGoAX+A==", "88a7ea36-adee-4734-a705-99bbfe21e62f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09f3e25d-fc37-42b2-9664-937fd55bc2ee", "AQAAAAIAAYagAAAAENgYtIpdBdU3qQfMNstByDPfC+OOjveoPqGj7pBG7fF+BKdiZoyGr4EPFQ9300isCg==", "0f8c9fc0-6089-4547-b914-6fd9b6e6996d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09a8e966-ab47-478e-854d-bfbd3e562ec3", "AQAAAAIAAYagAAAAENK2egN+z2RyuduZPvfvHibzaoiYOwKSygrTv6BFQW7cTVr3W3mMZSV4s/LAtmR9gw==", "3ce76398-4e86-46e0-8c72-3b5d63096b30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f64d3d54-899c-434d-9685-1e3427f7a476", "AQAAAAIAAYagAAAAEOctOhcPTulQO/kMECgQ+m0Ls8rojxvtTxkYQYdMzcI9SWbJatd6FMUKxheVvRsadQ==", "1d9e373a-9345-4508-a65b-c95bd5e910b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28447065-73de-4e69-b875-3e19fd557756", "AQAAAAIAAYagAAAAEOdv/m+Qppj1Q4M/Z0qSvrF45CBbhv7pWmIzX0uhs09qhQ05Dh7yZIeQMO3Y5eOPIw==", "a07cc8b3-542e-4371-928c-8dcb3334020b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b57a31b3-1ce3-4036-900d-d2b53f2d5d08", "AQAAAAIAAYagAAAAEJeTxYDA70uaNhR60enhr+0rDa7ExsWg+JtI6aJMFNDxmPJV13sAYfI9ubv4DObPeg==", "636c1537-3555-448e-9941-a53c4406019f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0f42c6b-16e7-43c7-a551-5dbbf86d1e24", "AQAAAAIAAYagAAAAEBN9v1hVv/oPCbTA7wqXUOhpgCoNa5QBGt2CHIRyljyrEjaxS8PSKxsnWoIxxoMx2Q==", "b1f75391-b33a-41fb-ae64-705ba81e9bb4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee63d724-434a-4f6d-b753-2a4965de690e", "AQAAAAIAAYagAAAAEGfnImR7RlpCUaKPQDn3Uq5O3GSykqvnh+BIlyxHm+FaIincUQ8a1MXGUxr42DJkvw==", "0b9fff77-4a3a-4483-a6a0-f97fea75c796" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1fdfeac-cbf2-416a-a0e5-696675aa2887", "AQAAAAIAAYagAAAAENggneBTr9IEYFQWE4NZVcY2aKijHIofKlHSUzOyk4fnGjk+OAC4YZnc1csJT5fFvg==", "b27cb726-1359-4c92-a90e-7242bb5faaac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0116e0c9-b340-473c-bf2b-925cde52a856", "AQAAAAIAAYagAAAAELEXQhAFvYY68HeJoZp+pxMeFdOICNCXFoWGR8mZTET5LWNucsCaIvw3UvR2SNy2uA==", "ef606ff5-c0e4-4f2c-a895-3fcac50bd5dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "206e5fa8-b52b-4fcb-8a1d-010694286d5a", "AQAAAAIAAYagAAAAEOCnTjtgK0fja9vYRfva7l02lsU5Os6g4+QZzsVe1SoROfRQtlWzGW/9bhQDrvUFZQ==", "867b5149-2526-437a-8492-9dd4060dad9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "801edcbc-4e4e-4e83-8b35-2a3a6fbbc6fa", "AQAAAAIAAYagAAAAEF8O9iF6vC+eOPctsqF/tEG9+/jtP58/2cqj/tYYnd36JV3h7olKEzpvxrRx+aLhIg==", "4a5a371d-c1db-4cf3-8c4a-4f56733c6f3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78cbf188-aa56-4cea-bc9c-c826631a3285", "AQAAAAIAAYagAAAAEJniykE4gnWDFHngMIlm8Spg2HGzSepnBOCnOE9FpjaJds/fYWySlJROF8YCf0GOJw==", "0cd22385-5388-42c7-9fc4-674a86ee3e49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c4f9879-774d-4016-ae65-71e7195ce2c9", "AQAAAAIAAYagAAAAEDeW1qbNGWDPbT0NlgtdHv9Q+VQu6gftLudQWxzFJAyTrSi+G4AQeCeB4ocK5jTfFA==", "cfdfaaed-a999-4929-aae6-7f4a0126c756" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17ecf7ed-8f30-45e3-ad79-3fee8f0b51bc", "AQAAAAIAAYagAAAAENML4VBi98FOr7kfEgEp4ESh/d2jvjLeVcy+LkMS5sxQ+dd4XzOcZd+bTIoCo+SCbQ==", "2e6c1f3a-1e6c-4658-a176-586413805ded" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce8e7db1-2879-4f5a-a93e-84e413bc471d", "AQAAAAIAAYagAAAAED0e3OiuM0d4DoQ4k6bPuR5bNSJsRCEhJOG+2eeNE2qEvv9Ebr8q/7mKSAvWnHIIiw==", "7a86f27e-02c4-4394-9af5-32494f089774" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b9e270b-0dd0-46a6-a8c6-ec9daa9dd7bc", "AQAAAAIAAYagAAAAENPaHkehnKxCmJr0op6Oz0WrMEnk0DrWHIr1GHV1ztK90EhiLbMwYukrzq2ykTKbcg==", "e3296eeb-0922-4d83-b813-fc2d69363f6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82a3c48a-ae53-4269-9cae-64aa8e61bdbf", "AQAAAAIAAYagAAAAEOIIw8bLyxrWEjLHn0SaZXC7mOjnW/UhdRGFgfXDSaWjTR31dSAXlL3Isiwbp1+rLg==", "c260fe36-29cf-478d-bb22-ae90cc51778c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b98100d-a31c-4794-b1bc-73d634a7d7b8", "AQAAAAIAAYagAAAAEBgu+/kZvatW7vD06Q45aciiWlkKhPCLiqxjmQQcdTLZLKY+xgO+ELspWgZ5NkZJ5A==", "094bd174-f78e-4f06-a9f7-d9775cf4f2df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a303f84d-61f0-45fe-b7be-df3fec8961b2", "AQAAAAIAAYagAAAAEIgfT/LETwyGrjP+ZEN27Q0oCfLFUPKEVHzyWqc4r3hAfnusOyXvVooRI+pi5hm8Cw==", "9732b4ce-138b-4ad9-b25b-53aa17a05495" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5fb9bda8-90ee-472f-bc65-89ac2b36db38", "AQAAAAIAAYagAAAAEP1qFPTf95aMDrcH5aK4jgyQHuEr2PNnK36XazJ5tNB8aQ1R8y53RUpE9oGPWxuIqw==", "5ef4b31e-c296-49c7-a020-fbf06252da1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fc4d560-e795-460c-904f-d2506617df7f", "AQAAAAIAAYagAAAAEP+vFh25qzCXADcDFaDviZb54skkFHqYrSfBfKB/hwImajlkAtpyoFoohXcsjkFOOw==", "89047543-bd36-4d8a-bd53-e24d4f80afe2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99d40550-afe5-44c6-8f2e-d38d38a80017", "AQAAAAIAAYagAAAAEANn3QmEVkF1FGyG96miYdQxtGTZpCUUvDiG3ttYr4dd+XA+TdI4r8FSRYjixyIWlA==", "60f7615c-1342-4f03-83ff-733a86014f3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5af0c944-c18d-4131-aac4-5bb88f06493e", "AQAAAAIAAYagAAAAEFH15eRhxApqxbLWnjsrhyTPzbPC4iES+AHZ4vYNQNs4hwLW/+ehb5mbTjqsl1hrkg==", "2adfab8f-a13e-4648-af88-6fd407654110" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0b5bd38-bbbd-44a8-bf3c-0d75b74d0f34", "AQAAAAIAAYagAAAAEJbeufEofCKsvrvz6j8BGZznB51iZ5ztR0FfySMKp5liN+8SitMadoseHDMng3BomQ==", "51761467-749b-4572-ba73-6a761206acae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b53e3048-8bae-4e0a-a6ba-e807b01dc668", "AQAAAAIAAYagAAAAEBu2AiYc+KUXWh+EY5054N1izxwJBUQPpzhc1bi691C3D9qfSbOCDqwpowEjTVIvkQ==", "d35715a5-651c-42dd-abe0-2fddead7932a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fec81e2-d356-4fd9-97e9-95c072ec4458", "AQAAAAIAAYagAAAAEEq5/nPIVjxsQDesUQzvxxTetb9fZZKm0mqrzOizXstQ6Eta77CCFrBjRppbVCJkbw==", "3ce508de-9b3b-4a6d-8d35-20da2192c62c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d29db112-db07-4c52-b586-2a2769f4e49d", "AQAAAAIAAYagAAAAEJqbNWqmaUZaH9n+8dtah3O7HLT1V5CBzKq5380u2e/OhwVnITmRRwANTQ66oE7+fQ==", "36738298-a40e-48f1-95a3-60838d8b9f24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "560cf41c-6e02-4774-9b87-f20018bf9fc0", "AQAAAAIAAYagAAAAEFjHSdikzS+YIEwZixEFHFqFkNq+Ht71N10qTqFF1+/gsVnU3uHD6oSh5CDo9ubPEQ==", "d6b2534b-c285-424f-b64b-4edfe908c71e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5bbda415-6c8e-4986-9902-5ca458172afb", "AQAAAAIAAYagAAAAEHjTySgN1DD3zJyir49ZxZinxZoClz9rSmjyyz6rk/K6pvm2amdFSf6A1N0bzM3ugQ==", "8cb63d11-adb6-4c5d-b73f-46c45448be8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "401c4715-57e1-4f7b-81d9-58fb5e51ec80", "AQAAAAIAAYagAAAAEL3dONNOI+nLPS5eXGkQAHQLiTiRyrpnNcbNYZOZCTOdCMw4JU3Mg8wJh6ZRNcQMAw==", "de3d98a4-b196-4b3d-9d5c-ed8c1d224d30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "542bb562-efed-4b9e-ad53-aaae4c92763e", "AQAAAAIAAYagAAAAEMgAX9M54KswI/Isdnly/vEE7LZCFGj8vxawA9u+tEGQdXOEIEexObdSfxRl+RuYJg==", "de83c518-b4c8-4e4d-b16f-85d39f3ac452" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "698ea70c-8833-4743-aae6-5b5f1ab1b5f6", "AQAAAAIAAYagAAAAEB+u1AsZDBxfG6imz/LasiXlBXOVrus4khCFo5rluyUyTfGqE4Lr1nA9WQFFLa9Hfg==", "04b78870-8e44-45dd-a5f5-f043ee0262bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be5998e0-db61-48ea-93cd-79880c6ca7c6", "AQAAAAIAAYagAAAAEHV2oSWxrSpGZVHlm2bteNgnqSPi8n6M8HwrC+AsByRg8+OU9h3IrJzGlAH5FhUYrw==", "0b7ca1d1-9971-4e32-88ee-6d6de323f287" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9509d93d-9b86-4ebc-a2da-f4e4fc40d1e7", "AQAAAAIAAYagAAAAEN3mfdD2PLs9l7xtge71G2OGghCeqxKPY1aKafFvSYAjCcWi1OqNeum+ixMLLEP/QA==", "b51385ff-1907-48e4-99df-cb0f4c95bac4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c34d165-229d-4c6c-b375-aef7fb134b8e", "AQAAAAIAAYagAAAAEI0dhAEl8ZUCp6VZCgb9KGgnbJhUxJOaWH/LYzTh2hEj65EUWoy7d/0zwORclvVoCg==", "690218e3-c535-4b1d-9ea7-2916bfe3d634" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef6f9dbb-6a76-4441-9cec-c01f6a3de5e0", "AQAAAAIAAYagAAAAELqw/bWDBNbddrHTyfolJy+euTAjQyWs1mAmPpCzJoO8tjmaShoq6f8J1A7KN4YETQ==", "144d8a73-1303-4461-8af5-35082f2989f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c4b05c48-59e5-470f-b43a-63209cee855a", "AQAAAAIAAYagAAAAEA7Qa7kyp2Rme6ki+kS4fr8qC73oyCVgNoh30mknEC4yO4OcXnKl1WWkxjvvT/V13w==", "6c6d502f-5574-4c33-b918-05bd522ad0e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6713594-c99a-4df6-95c1-9cacef2d4c85", "AQAAAAIAAYagAAAAEHKfA1ohsqSgL4w8AdHkNocEBUBD2Wb+2DamDGqu/AxYlP8Mbef3sGYi8GyNkUL/bA==", "7a43085f-3964-4af9-b46f-414b31278fae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b35af1a-e02e-4dc4-9b6c-b3bbcdca400f", "AQAAAAIAAYagAAAAEF1ECFOC3TKJxCquifi83PVj3D6MoyJVrnV3eeYnaXy/QZjBqwPGfiCf6mfeYYA7fg==", "7c866611-eccb-4582-b912-aae6f88bf52a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1322946e-de93-4afc-afae-54b2aa5ca5ae", "AQAAAAIAAYagAAAAEHEvkfTW+VmIwKeE0u5KlOC3gOG75wdVlDZOWQIPi2r7UZQKVjZpm83+t5wh7xQ0RQ==", "c381c615-50b8-4d76-b20a-10b4d7424545" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95358ed1-0863-4af0-b2e3-d957677d73ee", "AQAAAAIAAYagAAAAEI7cyKsTzhNfr2UVPbdbQV7KIfvQaOAd/+gJ9/s0wLD3ns5nsGNHFmlJUufeoG3JDw==", "c3478783-9de2-45e2-a46b-a0badac688d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9191970-6ecc-42a3-bb95-93ec80466c05", "AQAAAAIAAYagAAAAEKkVsYpUW5vErF2jSlGlYrkGYsRCbm/iZsu1j040fE5JCaQ62jtGomV5LNlpnjeysA==", "d1d4a32a-b8a0-42f3-ad62-6fe6d573b381" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1ce4814-2a24-4060-9c86-7266720258d3", "AQAAAAIAAYagAAAAELgA3h6zVA4uI7gLvlltOs1eW2lj2CZkZrrZS0sGCYCQg2azxy9qfBSYf1NqcvuS2Q==", "84d25990-2a9c-40f6-95ae-f46356c48ab6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52eae60a-6392-4230-8f28-fafc53fe9586", "AQAAAAIAAYagAAAAEHpDyIJoEvGLztN+p/2u0h/QYgsSNC1KA/rpdlxB2zwe5/Zf/UJHNGWoGSrnGTMWDA==", "b5669bc7-bbf6-4147-ade8-1f96ca006b5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40fa6864-91d9-4209-9e60-a4d823219a68", "AQAAAAIAAYagAAAAEJbGI3LN77dyvNYDQi7fBTLAhm+WkIbEl9QtwxsssmFHD+VjrbBYnYMv/WO2f2kIUA==", "63a04f33-2046-4a6a-b0c3-7cdac7f69367" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf2c6693-5ac9-4aac-b520-63a52a1c7286", "AQAAAAIAAYagAAAAEN3NOWT5wuI4XE49DOOJAGqP5ixlcxcbyT0kQ35escp0ytgkfRMg5FeKOE2FuSB5xw==", "9bcead25-3cb7-41e0-984f-b4453f2d506b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f798a51e-2a89-43f8-a762-ce8fb9d4a114", "AQAAAAIAAYagAAAAEL/kZ7J1OC0sbQDHmYvdcAV5U4/wkL4xpb+2lGrZcqJiV38TkRmKcKerbggdorUaiA==", "37d18d8c-d6f9-4fa5-909c-ec46f673485c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64831b42-4bf3-4a30-a13a-f596bab36154", "AQAAAAIAAYagAAAAECHGZYjqNrFTmc0oLIqjbgazLyDQYqH6MB+nMqyxRkhk+WdJIZas+/EcW6ftn5656g==", "d5062f52-bd97-432e-9687-407c5dc86f17" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d3b68d9-6d4e-491a-89f8-07c4bd5b618b", "AQAAAAIAAYagAAAAENG+DXqPoLGf8xdoD8mZFSp6J6a3RdqWlOeiNPfe6kbzzLrv+pQElnzB3FNtQ+UNjg==", "72ee21b5-8f0f-4d45-ade6-077ff77b7963" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cfce93a3-4dbd-452e-9cd7-a342bd12668f", "AQAAAAIAAYagAAAAEN5n7+Wna5a0oEoL8Q7Q8uMXVoKbXT+pXGCsnXfeojdUoa257PPBkXwyySudElRQGQ==", "5a8dc950-f575-446a-82c1-587337ac18da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "458995d6-6b1b-4903-91ae-6ef0d98c95a2", "AQAAAAIAAYagAAAAEPBdjDyVdOqUFDepiOR89t1zhFcpSjsmFWrCPPrk4vIBVWJuOhu8+/rw9MjTHi6F1A==", "02393037-44ee-4d21-aa95-e8389c7d1fb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b6a3aaa-6244-45a2-b30d-62ca14395d11", "AQAAAAIAAYagAAAAEJeQtFmHWO0z+xLJmTq8Zfe49n08iHeYqgB2B/UWY3gMdABQZgfX0O/RGZ/wpBsDuA==", "8aeba2da-7938-4637-b0eb-9be6793130fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6f944dd-4955-4907-b303-b7c544bdef98", "AQAAAAIAAYagAAAAEIsLEZLD+ajXcVYwnG3fx3antf5keSuDd/IgV/qeVaWMpXuXbRk5IfJ/sXmeOgyjBQ==", "c230bb5e-3563-4103-9cda-4f166f2dd6d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06ffaa27-aed3-4893-bf85-cd435bf182f2", "AQAAAAIAAYagAAAAEB2FEzgmRRXxWq94AyI7CPTrTcq0hZKSU8HN12bF3v7VTBI5ErFAZb2mFQrHeEPeMw==", "99345d98-a0e0-47da-88aa-cb601a1f95c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21368ee7-8c2f-45e2-b90f-3a216bd9f868", "AQAAAAIAAYagAAAAELMW++O/jglKToykBqWULiBPL5wtfd7OO4e3ZYVNyZu0/j/TfoniWx2snskhw0va4g==", "6ae7640a-8e86-4232-8780-347c6ccdb20a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e246fdbf-1c18-4d4d-b902-1760a907b2b8", "AQAAAAIAAYagAAAAENeF0G4M3d5Lxp75XyCEEF/ZUDL8ujP9Zp3K9h7VlfMvQaQPaFLNkzCfytpQous8PA==", "edce6b06-bd89-4f5a-8fe9-c531e93f4482" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af4e7241-03d1-4c7f-8544-9752c050bd30", "AQAAAAIAAYagAAAAEPlMVdlzlov4bZ3uIFPrN34VLLyW1tv0WO4IQ2SfptJztV1HNeqGxFW6LhstWa5bxQ==", "c034320f-89eb-4bf6-8744-f8697806171c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48d61a86-a5b6-49db-9327-d138620d9fb4", "AQAAAAIAAYagAAAAENvJ5ecCxOZig/fbd9nCxkdybFizYbcwLAPF65pyK0jSMSMVkZ5zBpeqs+Ul+DoaWQ==", "d3d38d66-7f91-42e7-967c-9b8ab95be20c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "211db1b4-c684-40e8-aa23-73e262a08430", "AQAAAAIAAYagAAAAELsa/50iNFGuhNb5DoHn23J2FQcu1e1diHQh//VANDlCZ1sglGFqF0KcS/90+WqOTQ==", "3ce483ff-2c90-4eaf-b2e0-76a6d64b587f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78a28016-f1d7-4d82-842e-9eab4047f89b", "AQAAAAIAAYagAAAAEAt9WAR3tlEPG+9oGIGCg27rO5Ulag9A+Jev0MkniVjWsYcEj30QMmWyOXjoqqz8NA==", "b35db558-b0f9-41ea-9ea8-a742f12f3226" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c18ddf1-4dd2-418c-aa66-c8333f3c3082", "AQAAAAIAAYagAAAAEHtSxkM/L4v9BZt6H5Pzu1Nao9I2bBkovF3/HfDJUt9U65L+tV6rVaFn3lxa4zk1jw==", "b4d8412a-756b-44c3-8941-3a8a50239f27" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6d22fc1-b4b2-4891-b8ba-205b9ce669a5", "AQAAAAIAAYagAAAAEPzNoQYbFI8jYg4yhdupce4dRY9p58LI8v4cdiiLDnrRKaFj7bLDxrd10wPjuBkhMw==", "d9fa1cab-29c5-4133-b962-c1de6486459d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc96e601-4a7e-477b-9efe-24c62dca2f2e", "AQAAAAIAAYagAAAAEEWYDORhfyA5zdG6WTgRuMNp4vDT7/+aQfN+XNpIoi6tEPIDx2U1K0VRiCUhnefvQA==", "554ee4f2-63e8-477f-bd77-d2cfb492db78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eaead440-29dd-4bc2-b2f7-992f529d8ddb", "AQAAAAIAAYagAAAAELt7pTg4pELx2oTU+UM/8BIyjVEHf6/M4pQjyj8gD4T5bZl/1JZv8sEpi5qy6b2X9g==", "5567f9f1-5203-45ff-9fb4-b9262d37b2de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce88c968-c73b-46bb-9650-4d155cd17705", "AQAAAAIAAYagAAAAEEjJnlwNYWuA2UXOSmnf35uL36Aiz4S//kJtcgBFYZZlSbkV3aWfrmwIsrsHXGZw1Q==", "4f47f11f-9682-488b-9eb0-5c8ab7d72ecb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5aad542b-0d13-42c6-b8fe-a987ba5fe830", "AQAAAAIAAYagAAAAENd8Kb0CUAl9ipWlmlfHS5MIPGRVfl3AqNSB0w2L67H+k8o4VohJ9colkdh5QWL8jQ==", "3c436156-71a9-43de-a9d3-960cb506218b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4803696-b1a3-45cc-a91d-28fbf74e8e8f", "AQAAAAIAAYagAAAAEJIzRaChuLPX2lVzih13jET2DiPZkE9N692Ox28xcm8GHD3bDPAhsCffRjMmEMgmQA==", "1e266b50-0bc1-4caa-bb56-eb0870040794" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d79de2f-33df-4cee-84b0-d8fe2ea9e3ae", "AQAAAAIAAYagAAAAEJWYA9dHdv0e/C4GYYOdlNIz20wHcFirU2QZma7Ot1/On+FcPMrHWin+hNusWfDlbA==", "02b5ac7d-6e9d-4355-ae2f-38438bf6718b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bdf8f629-887f-4004-94e9-3909a352ef8f", "AQAAAAIAAYagAAAAEA5sLTXq0eztjwhe3wFxQDZqHFaGjbW1AdvBMJaElglg6PZJWBZjeD0ubIjT6IExiw==", "e84aa7b7-8b0a-4955-9d9b-d2cefccbfd35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1d89495-5b89-4de2-aa9f-5903f2d06bfc", "AQAAAAIAAYagAAAAEGobL7i9mMbwDUGoesLlbb0+UH8L8dI05iHfHtU+0NR/M2KJWNKxtHsBU0ZpBdVGtg==", "bd2a32f0-3f91-4add-a805-f104d7f7934c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed30c3ef-a343-438b-8664-8aef8890ccd6", "AQAAAAIAAYagAAAAEDtX717t3YsrSfEpji7TNydSvIqe5XnBA4kTVyxL43uRLKEXXNbnn1bXsohC4/wiqA==", "508d31b4-b9d5-4cf4-9094-7dad2d2e5cb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bbc97308-e069-4927-884c-795f737a15b5", "AQAAAAIAAYagAAAAENkVu/v2Svri+IayuB/bRfXFvWnY2XAmQ6AW+UhMsHllLzpRoKDOnUEk8bJ0zYXUmA==", "6de0b861-0372-48b3-8c5d-1c9ba432151a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ffe5990-bc72-450e-82f5-7c6528652f93", "AQAAAAIAAYagAAAAEAz60VgElOowWTA6Y1IJO10cuF4fOCYgoTnzCXQr28w9bPAAtolI4HgiKMxgWKiy5g==", "fc0dfe6a-630e-4ab5-b3df-9d29a84d12ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cd1c30d-99dc-4bba-b5f4-71141881c8e1", "AQAAAAIAAYagAAAAEMPo2ImU0ry0v0aBWGExyH3GWwOTRL2NN3Pj/lOSwQahcVwDKwC4zVth3jKIjQkZPQ==", "bbb93536-3484-413f-b09d-b3a8d1ab6948" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24b506e3-16cf-49c9-b119-ab6e20c12806", "AQAAAAIAAYagAAAAEEaWj/4xP31snkjWutsHDDw04lIhriXLFvJtipuY/8mqWBOZEeEGw7kOLQFCN5ob8w==", "902bd7ad-3de5-4b54-bad8-a83698d34b33" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fabbca48-919e-44ba-a718-aef8d965740b", "AQAAAAIAAYagAAAAEAAmpJYRDWC3O3Z/ASb/vrMKqNbrGIeVEAK3olEKk8EPxON3CfNnD34oTAn/VVy+lQ==", "c67781b8-ed59-4c1f-a02e-00709c8eacde" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4628f575-6afc-4aaa-9a5f-dd517044dee7", "AQAAAAIAAYagAAAAEMn5olTraN0MrRFNU7ZMUpik6tTKk5cOMZ+DgQR1kAv1gnqDH6/QvXR6RwAbrBOt7w==", "a0ccbe41-2bb4-4d83-8347-4269b89054dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c7b19f7-1b5e-47f5-a811-796bd1afae39", "AQAAAAIAAYagAAAAEIfSbC2kSvy+U+l4+5WR/y/TtOHP4VmvcZu92HupgAcKNDDatTg4M66Rv/77pPf3AQ==", "0675f406-30cc-48b2-a574-fb2f2577345b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4848c3f-3ee2-4081-9c40-153d80437338", "AQAAAAIAAYagAAAAENziYJe5o218LBw/u4UCMtpDZgREfO8con092/HnlcsjjYoWslQC+0sAJo8afse0pQ==", "774a5e7d-9e87-4cec-a466-d6e7230b1e50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c1edf497-cfa6-4935-983e-6c4a8efc8d7e", "AQAAAAIAAYagAAAAEPabMWK8ENTpCpIWwN1aPXr6uflA8l/yZTQK6hkDfra/hu0GyCiYp1+inwPv943GwQ==", "c0acb1fe-281e-456f-b793-b9fa5f3c7a47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2217e950-2bb7-4276-9200-b7d69cde9b1d", "AQAAAAIAAYagAAAAEIfLv76V04FRFQ/+8Zfqjhe5c2NrVLQ9qiezmsK9/q/ghvUMq+zAUt/4CHPE49Zxlg==", "ce037800-52e0-4056-9f96-5984d31841ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e29e4f0-f9e3-41c5-86a7-f76f10f88f73", "AQAAAAIAAYagAAAAEMgopIaV4yw9Ea+YlBQEI3Tonqe3VnIfqAfSMfQyUZ+xlq43DOYrdUXRo9fdLI8lgg==", "0afc00ea-20d6-4efe-8e4e-a07ae982f660" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f46da09-3fb7-4f93-af54-aca97ef6e880", "AQAAAAIAAYagAAAAEOfOCSNG78eT0dmECcsQChUN82SPK1wHeQ3wXhEzD9nAfHkOu8qCZ+B+BonL/d9Ubg==", "6ae940e2-fc1b-42ce-a4f2-735bacd3a9a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "622514ab-beb8-4e7c-8b96-697459d973d7", "AQAAAAIAAYagAAAAEF1JcSRjw+s8z+2bZFcVxQjA8j3b7Uwl4oqmO/BE9666S73xd22UtjoRshpVTr/EMw==", "555cb708-4fb2-411f-954d-9df05929ef00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a808abed-764a-4caa-affd-a411e8be302c", "AQAAAAIAAYagAAAAEEI4haXOGCdHJP1SVjwITX4GAConWhRPnAMm8E1qyLS0BhSacdxdJGR4SENTibLIaA==", "7d28cc88-b6ab-457d-b938-d11a924a4957" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4696f979-4955-459c-b0c1-090662273cd0", "AQAAAAIAAYagAAAAEJVq7OiC/FmwfupYZx8IsuhUNISmLXBWXAP1nZ2bILTyIWmB0hMFf+YOmtfJCPW9rw==", "e593dc19-c278-4e73-83dd-2c0cb4d47223" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f406d8b-6d82-402c-a25d-0bdbbeec3a14", "AQAAAAIAAYagAAAAEP2L60YdbiMjxln+B8Z/kR9lFVp1IOQJZ3B0zYor+Bpcz8BHY1jdza9wncOSh/8XOw==", "7841f8a2-6e85-4ae7-84d7-0f2f899dc974" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23c8359b-44f8-4dd0-83de-a87433ab3f67", "AQAAAAIAAYagAAAAED/1WEC7d6E/+aPaJ3Z+5RF9KFzjkn2iFSpAl/n2GV+KIHoRq5iICAeK45bmTtrkpQ==", "6f464dcd-454f-4ee9-a157-3f5a43d0f78c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57013e1a-126c-4f83-ab37-3e23971d5ae8", "AQAAAAIAAYagAAAAEBp/s5+JJwTbcwtIyKqno2qDtWtKmWKlHcPt4TgDkKNPFqvAjlpKvmp0B7hT7TBC8Q==", "39554de3-a100-4bf7-a340-73cebbd75f37" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "697dce83-7b45-4e2f-98ee-cb14e7d0e000", "AQAAAAIAAYagAAAAED6Qenlr/zmKREtgtoHT6duZMlsCQtjlPYFlHaG5YmRS+ZPJTovHdf8dS2/r1bEUtA==", "b7525cae-7e9a-4a9d-a70e-9e395edb030c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00760865-a5e2-4c43-87cd-f382c280ab1d", "AQAAAAIAAYagAAAAEHbOHSm7Kr6Hfy0TxyVafahawZdNaf7sGbBi8NwNjvkKVkIOapZhhqytU7ZmtWnw9w==", "2371d7f0-1d08-482c-9d7b-a897aa3cac91" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20f1e565-2ae4-4baf-adc0-d67ea7623d4c", "AQAAAAIAAYagAAAAEALMlAvAVanoG/dkGfSIVqSocCAo2reHfupcU8CfgBOojJRTR43Mi5uOt77z3XFsCg==", "5e46494e-67da-4517-9cf4-9e56698b5a2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bfe2a0d6-c711-4181-a58a-1afa71990ac1", "AQAAAAIAAYagAAAAEJGf3Cr4gDGtJYZU/JJE+Z9UDhKeZeJY3ffYri5UpJtOteEQCsCfW49qlNu900lzLw==", "569172c6-20e8-4e15-9000-de12a39cc505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f391ae64-6f9d-446c-b7fb-f5f669f82561", "AQAAAAIAAYagAAAAEKrUYpwkABqcO5k48epjCF3KrIMH/412QzUfFjOn/+61+dJD2AcSYYTTE0mCUrPKqg==", "efdd646d-ba60-4497-8c63-208c2f76052f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11e894a9-8e66-4b62-91bf-6c46a332f712", "AQAAAAIAAYagAAAAEFRYTE/QsQH7J3X/KWgSzfCPAQ5NPdMozRHD6KzzkmfhCPBhtWIqdwyIXbTXALCzIw==", "12bf0701-33a8-4e2f-963a-12dac1b3bc0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbf19607-32fe-4fd7-a567-21ce67d77fc7", "AQAAAAIAAYagAAAAEBv3HPQHcv/jE5ZMFFHxdTxeCkiM2782kcyM+zCj98DFhqmbUcE5foGNU6f+sPQiAg==", "495e05aa-4b41-4f27-baa5-96bc7d863808" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79c63dc2-a9c3-46ea-b954-66108868fba2", "AQAAAAIAAYagAAAAEIIGse98vcTMaLtFOE5cX/4QowVZIQGqTPRpQkumfls0nPH9ab3HHI0kXSxoUMTdMQ==", "8a50a12b-84ea-4d26-888a-ea0aa320a1cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "478d88db-9164-46a9-9f78-a26c1176fe9b", "AQAAAAIAAYagAAAAEFuiory97MJMZYCz+3qIBQChhyOAGCCptIkmXqgfYPK3dPhj1Ke8yWbLpmlR+XhF7Q==", "1a70d43d-b5a3-40d0-b518-37bd69b75512" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "924da41e-d9f9-4a3d-8fe1-895cfd86d486", "AQAAAAIAAYagAAAAEO+WQFJXWjkuSvCP33r80Pr9JFnr7tdwDZwisqMyiaVuS9Q1D/G6aptNH1uy1E2uOQ==", "131304a5-2cd0-4040-80fd-7e6603a74f45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19149801-d825-425d-9df6-ab303e81340a", "AQAAAAIAAYagAAAAEAO5L+IsUu/FZeTJElEDA2G0WOS7xTa6MGypr+YQoBU67lycDDZb2zTiO3V33aH3zA==", "902f70bc-ed91-414e-898c-ead56bd3ee6a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "349fa07e-7966-4374-b80d-fb9fe2873c07", "AQAAAAIAAYagAAAAECU0n+qP5ZuUfmP/kS5epQx6auZ8ANBLnaPZeNx9REC+qkkcJRaj0Epqv4Uk/dZ+KQ==", "6b1313f0-61b0-46be-af8f-bf9229b28d4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77bcb423-6197-4712-98e6-41bf3e4111ba", "AQAAAAIAAYagAAAAEMqlJNjYvRxaOxtVmhTPUTBljBzV4mJotum0QVBYKtwQAUEosb5yfX5Ef5S3v4sP/w==", "f08e37fa-ea3c-4f23-87f6-835fbb407559" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5a92d61-0eb9-491b-81c3-d217756fc77c", "AQAAAAIAAYagAAAAECFHZRHTPhKTRhSi8bDXOboplJTTIXUVQ5vBWHEchQLyX9ZD4ch1oCR3Slo265WJGQ==", "a8b3873f-88b7-4fd5-9afe-ec4051e59ab0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e30662b-fbea-4d5a-adbd-53bdb5ccbc9f", "AQAAAAIAAYagAAAAEAauaRKnM1amLUHYa66xK7f9zPNYV+n+1lVX2Qc1xZZwrOinv8QvLMEVWLW94K0i2A==", "c05e5119-ee61-4173-846c-d34896252345" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ebb2498-57ad-4cb7-aca3-77d27c21b9e2", "AQAAAAIAAYagAAAAECX5g/tg+5OBfhLaWPZEZy8GOSAuXLFv+ExlyqfsqrEiBU/47RrB5J7GxEv4UHkYuA==", "2cfbbf78-d976-4a4c-bbfc-f6544443bf8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff30f665-751f-47e6-815a-4616f27c210c", "AQAAAAIAAYagAAAAEBdi3NDa5kNfrnWwJgYFVl6q2Nzd9nU/6bqdlhiZdMZiROenqUG/8JDARn5oiw7Ftw==", "bdf43038-4552-4f79-8d4d-396779294f2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddcb2da7-e527-4bce-8ea8-45aee908ac1b", "AQAAAAIAAYagAAAAEOJPS7JdsSQXW7f9xH8sCUAIuidmpUHqHo5VG6YT3aDTKyRmACf00pG/89lXiE7Wqg==", "44ed8ab4-94d9-41d0-b5ab-d326c87817d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55408ee4-5ec4-4c8c-9ae8-311a1113f7a2", "AQAAAAIAAYagAAAAELMoSauIffL1jqNXq8b0LHIQ0WTSjymvGQnhtjF7aaIdfT35jpKLx/jwXiRidcxqzg==", "d21336f8-4949-442e-a9b8-93b2d51e5bfa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71f4fa28-8170-45ee-b884-4aa567f58587", "AQAAAAIAAYagAAAAECnN9q7TTye4didgz2S55V7Dwi3zhgfOzsOTqmiJpGbxkYkKG/kS7MRMnn0ZrPBc3w==", "ae311931-9700-41f5-9769-b033d5087653" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1228be4b-fa51-4597-88dc-8cd88c7e59de", "AQAAAAIAAYagAAAAEDjQ2xUulaiHz0qlkbHOiDvXfIjAiqCK6+uRtecslCcI4Z3mM38avPbPP7xolgyV+w==", "60329c8c-8e60-419e-86bc-a25c8df26505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96f03232-78d0-4669-91ec-fdea04c4cd31", "AQAAAAIAAYagAAAAEF1H/MCpaPdwf8OgSy+M/JiZVlsHQWk1PJ8Ijc/KRUUEEqY6Nr7VoarT24vxCKmlDA==", "8d71ba21-7cbd-429e-b91e-90f359e77839" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0018009-d6db-4b5d-8eda-b0163604e538", "AQAAAAIAAYagAAAAED2HKQlfAl+8Dba9EZ5vrZouLphBQEVvQClcrL31ss1cO1JT/raLSRcL05T21zGCIg==", "8b42afc7-8c14-4b86-9202-c7f6ad5f964f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6196a35b-e1f9-43ca-a4c5-6f56398028fc", "AQAAAAIAAYagAAAAEMsOg8A06A01NwjTvdgqVYsd42Q3q04QaezaAlGHX5hBKkNhA3uqO1qJP3UcUaWrlw==", "94304953-693e-4d8c-9ebd-fedb1b0fd32c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8c10ebe2-f229-443e-b13f-5147a5c97449", "AQAAAAIAAYagAAAAEDYTnNJU5j6w0P0MCdnKSNFoQemcHvwRJjm+jKnqfX9pzCULdUwKnNSAv7p/tMe31w==", "f141d52e-b2a6-4034-adfa-5f5b6facf43d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a6cf087-abf2-4464-bb9c-caad3e4f03a2", "AQAAAAIAAYagAAAAECuqA3ZrpbJcGhyRmX7VjTTxLvlqYL3ES4jjmdn2XGrlcNJcsYj61E1xU5lyCrzLgw==", "a715eb0e-684d-4986-b753-b374ff757a5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6f096de-d1d0-4e34-8d6b-728b72086d39", "AQAAAAIAAYagAAAAENUiaTUgtNMYZTBtFtYfFgHrS55Y0h6nzndh2zbhrnDNkmoaB8VjWMS923QGabkYrw==", "fa01d8a9-e2aa-4978-9f18-3a1217cdbfbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce805d38-611c-4826-aa22-8cae95295528", "AQAAAAIAAYagAAAAEBvZXTGt4bvU507+SbnGGRTezfvjLmzITgvpFP/sWubF4tFlne7eYRd0Vb7S/p9sUg==", "bda44a6b-aec3-4464-abee-3fdab56fb499" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2dd78ba-7493-4a16-aeda-5808eb72f1a3", "AQAAAAIAAYagAAAAEGU77/Ky5z7efD9lKytOUtOMRdsJjOjib5jwXwME+z8ejVbwwECloQRy71qITRJvsw==", "3b9b2fd7-1845-4fd3-9e84-389ee91b5e1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14c0c04e-0b3c-4b32-b21d-8c4089e38e0c", "AQAAAAIAAYagAAAAEOB0PyXZQzuswZhMtLXDCWkWLQTgju7KtwEVIT3SeDVxNjjiMTHjTMAFux2tWy/qAA==", "18be3d14-8b32-4eba-a946-479df2cf1fa7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa66ecfb-c2e7-4fe6-8199-50d25b0329cd", "AQAAAAIAAYagAAAAEAOL1OcQl+nZjRDsDyZ4bopJ5YLvI1UyXzpB/DQCIbgzKvg+saBJ+Q0noKoIUWqnEA==", "02b96700-0ba7-4e18-8fc2-486b87482816" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "316b9a38-e6e6-4911-8ba8-c4eb90633299", "AQAAAAIAAYagAAAAEKU0qG1NXoAj7FCNbZP+dfH52dmN8vBm8FwicdOtRhBOpalmAISreotVDoR1JoYUmw==", "14b49e7c-639e-41fb-ae69-6a97f5bb2227" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c89e3ae8-8f19-4341-a3bb-4ad20c3ff1a1", "AQAAAAIAAYagAAAAEF5LdjJT8rQcyEH8Rgd/gI4i6Of2pD1IArqGQ5CgAKBjifLdflNt/J2O4s3t88o70A==", "330be354-28ae-402b-9090-a7aa7872cbdc" });

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
                name: "IX_AuditPlanApprovals_ApproverId",
                table: "AuditPlanApprovals",
                column: "ApproverId");

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
                name: "IX_IsoStandardAuditPlans_IsoStandardId",
                table: "IsoStandardAuditPlans",
                column: "IsoStandardId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditPlanApprovals_AuditPlans_AuditPlanId",
                table: "AuditPlanApprovals",
                column: "AuditPlanId",
                principalTable: "AuditPlans",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditPlanEntries_AuditPlans_AuditPlanId",
                table: "AuditPlanEntries",
                column: "AuditPlanId",
                principalTable: "AuditPlans",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditPlanEntries_AuditPlans_AuditPlanId",
                table: "AuditPlanEntries");

            migrationBuilder.DropTable(
                name: "AuditPlanApprovals");

            migrationBuilder.DropTable(
                name: "AuditPlanPersonResponsibles");

            migrationBuilder.DropTable(
                name: "AuditPlanProcesses");

            migrationBuilder.DropTable(
                name: "IsoAuditProcess");

            migrationBuilder.DropTable(
                name: "IsoStandardAuditPlans");

            migrationBuilder.DropTable(
                name: "AuditPlans");

            migrationBuilder.DropTable(
                name: "IsoAuditors");

            migrationBuilder.DropTable(
                name: "AuditPlanEntries");

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
