using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class IQAsignatoryApproval : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditComFindings_AuditReports_AuditReportId",
                table: "AuditComFindings");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId",
                table: "AuditPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScope_AuditReports_AuditReportId",
                table: "AuditScope");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSummaryFIndings_AuditNcarStatus_NcarStatusId",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSummaryFIndings_AuditReports_AuditReportId",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropTable(
                name: "AuditPlanApprovals");

            migrationBuilder.DropTable(
                name: "AuditPlanStatus");

            migrationBuilder.DropIndex(
                name: "IX_AuditPlans_AuditPlanStatusId",
                table: "AuditPlans");

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

            migrationBuilder.DropColumn(
                name: "AuditPlanStatusId",
                table: "AuditPlans");

            migrationBuilder.RenameColumn(
                name: "NcarStatusId",
                table: "AuditSummaryFIndings",
                newName: "AuditNcarStatusId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSummaryFIndings_NcarStatusId",
                table: "AuditSummaryFIndings",
                newName: "IX_AuditSummaryFIndings_AuditNcarStatusId");

            migrationBuilder.RenameColumn(
                name: "AuditorTeamsId",
                table: "AuditSchedules",
                newName: "TeamId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSchedules_AuditorTeamsId",
                table: "AuditSchedules",
                newName: "IX_AuditSchedules_TeamId");

            migrationBuilder.RenameColumn(
                name: "PlanStatus",
                table: "AuditPlans",
                newName: "PlanName");

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditSummaryFIndings",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditScope",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "TeamId",
                table: "AuditScope",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AuditPlanEntryId",
                table: "AuditSchedules",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AuditPlanEntryId",
                table: "AuditReports",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AuditScheduleId",
                table: "AuditReports",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AuditeeId",
                table: "AuditReports",
                type: "int",
                nullable: true);

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

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditComFindings",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "Area",
                table: "AuditComFindings",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddColumn<int>(
                name: "AreasId",
                table: "AuditComFindings",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "AuditScheduleId",
                table: "AuditChecklist",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AuditeeId",
                table: "AuditChecklist",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Auditees",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Auditees", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Auditees_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "IQASignatoryTemplates",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditEntityType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SignatoryLabel = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderLevel = table.Column<int>(type: "int", nullable: false),
                    DefaultSignatoryId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    OfficeId = table.Column<int>(type: "int", nullable: false),
                    Position = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IQASignatoryTemplates", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IQASignatoryTemplates_AspNetUsers_DefaultSignatoryId",
                        column: x => x.DefaultSignatoryId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IQASignatoryTemplates_Offices_OfficeId",
                        column: x => x.OfficeId,
                        principalTable: "Offices",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "NonconformingActionReports",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ReferenceNumber = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Office = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RelevantStandard = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsInternalAudit = table.Column<bool>(type: "bit", nullable: false),
                    IsExternalAudit = table.Column<bool>(type: "bit", nullable: false),
                    IsNonconformity = table.Column<bool>(type: "bit", nullable: false),
                    IsInternalCustomer = table.Column<bool>(type: "bit", nullable: false),
                    IsExternalCustomer = table.Column<bool>(type: "bit", nullable: false),
                    IsComplaint = table.Column<bool>(type: "bit", nullable: false),
                    IsResponseRate = table.Column<bool>(type: "bit", nullable: false),
                    IsOperations = table.Column<bool>(type: "bit", nullable: false),
                    StandardRequirement = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LegalOrPolicyReference = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditFindings = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditReportId = table.Column<int>(type: "int", nullable: true),
                    IssuedByAuditorUserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    IssuedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AcknowledgedByAuditeeUserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    AcknowledgedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ProposedByAuditeeUserId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    ProposedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ApprovedByHeadUserId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    ApprovedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    VerificationDetails = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    VerifiedByAuditorUserId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    VerifiedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ValidatedByLeadAuditorUserId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    ValidatedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsClosed = table.Column<bool>(type: "bit", nullable: false),
                    FormRevision = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NonconformingActionReports", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_AcknowledgedByAuditeeUserId",
                        column: x => x.AcknowledgedByAuditeeUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_ApprovedByHeadUserId",
                        column: x => x.ApprovedByHeadUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_IssuedByAuditorUserId",
                        column: x => x.IssuedByAuditorUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_ProposedByAuditeeUserId",
                        column: x => x.ProposedByAuditeeUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_ValidatedByLeadAuditorUserId",
                        column: x => x.ValidatedByLeadAuditorUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AspNetUsers_VerifiedByAuditorUserId",
                        column: x => x.VerifiedByAuditorUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_NonconformingActionReports_AuditReports_AuditReportId",
                        column: x => x.AuditReportId,
                        principalTable: "AuditReports",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "IQASignatories",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditEntityType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditEntityId = table.Column<int>(type: "int", nullable: false),
                    AuditProgrammeId = table.Column<int>(type: "int", nullable: true),
                    AuditPlanId = table.Column<int>(type: "int", nullable: true),
                    AuditScheduleId = table.Column<int>(type: "int", nullable: true),
                    IQASignatoryTemplateId = table.Column<int>(type: "int", nullable: true),
                    SignatoryId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    DateSigned = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ApprovalStatus = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IQASignatories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IQASignatories_AspNetUsers_SignatoryId",
                        column: x => x.SignatoryId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IQASignatories_AuditPlans_AuditPlanId",
                        column: x => x.AuditPlanId,
                        principalTable: "AuditPlans",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IQASignatories_AuditProgramme_AuditProgrammeId",
                        column: x => x.AuditProgrammeId,
                        principalTable: "AuditProgramme",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IQASignatories_AuditSchedules_AuditScheduleId",
                        column: x => x.AuditScheduleId,
                        principalTable: "AuditSchedules",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_IQASignatories_IQASignatoryTemplates_IQASignatoryTemplateId",
                        column: x => x.IQASignatoryTemplateId,
                        principalTable: "IQASignatoryTemplates",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "NcarCorrectionActions",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NonconformingActionReportId = table.Column<long>(type: "bigint", nullable: false),
                    ActionDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderNumber = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NcarCorrectionActions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NcarCorrectionActions_NonconformingActionReports_NonconformingActionReportId",
                        column: x => x.NonconformingActionReportId,
                        principalTable: "NonconformingActionReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NcarCorrectiveActions",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NonconformingActionReportId = table.Column<long>(type: "bigint", nullable: false),
                    ActionDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderNumber = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NcarCorrectiveActions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NcarCorrectiveActions_NonconformingActionReports_NonconformingActionReportId",
                        column: x => x.NonconformingActionReportId,
                        principalTable: "NonconformingActionReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NcarMonitoringLogs",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NcarNo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IssuedYear = table.Column<int>(type: "int", nullable: false),
                    SequenceNo = table.Column<int>(type: "int", nullable: false),
                    NonconformingActionReportId = table.Column<long>(type: "bigint", nullable: true),
                    DeptSectionUnit = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DateIssued = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IssuedByName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ItemNoRelevantStandard = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditeeName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DateVerified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    VerifiedByAuditorName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DateValidated = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NcarMonitoringLogs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NcarMonitoringLogs_NonconformingActionReports_NonconformingActionReportId",
                        column: x => x.NonconformingActionReportId,
                        principalTable: "NonconformingActionReports",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "NcarRootCauses",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NonconformingActionReportId = table.Column<long>(type: "bigint", nullable: false),
                    CauseDescription = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderNumber = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NcarRootCauses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NcarRootCauses_NonconformingActionReports_NonconformingActionReportId",
                        column: x => x.NonconformingActionReportId,
                        principalTable: "NonconformingActionReports",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "1b576f06-f226-4fd3-8256-ae809a588dfc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "22484721-49fc-42ee-8981-64bc72638bc1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "0c28604c-bcec-4be6-90b0-275490cab0ba");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "e590b749-106b-4929-88c3-86b494ccf07d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "088e57e2-8ea7-4cf1-8c29-0445bf35390b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "1ebe8593-f1fa-4c45-91f3-31fbc26a394b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "c36829df-899e-4af2-adf3-1bfeeef4bb29");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "d272ee0d-a757-4a92-a2e0-cf7e95540a4f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "1ea1eafc-c9b2-413a-ba3b-7377cee6671a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e6041f",
                column: "ConcurrencyStamp",
                value: "f3a055f2-3fa3-4874-a1f6-53e929b69fbf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "1876709c-37bd-4e71-8b96-9fdacefca82d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "818c63cd-60c3-4907-af9d-dccefa70cf88");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "e1000ffa-1b09-4fb0-acf1-9b1a7a49b6aa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "f9e61c3d-7108-4536-ad54-1055250f0481");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "14657723-9c27-4a8f-99c9-f15d3c67b996");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "ada77569-0906-423a-b2b3-7e524bf1b86c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "5fe24b31-6c88-4a00-b9c1-c3ec129f0ceb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "4e8b44a8-31dd-4515-a984-5c4303d2d67e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "69160a29-a752-4a8c-90ec-55c1504e69af");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "86c8aca6-46d7-4e15-be01-24284900986b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "569ec014-713a-4077-9d4a-c97e37a02c0f");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Discriminator", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "7f3c91a2-6e45-4b8d-a127-93d5c8e604ff", "27fb2350-7b03-4857-ab99-efcbd263f010", "IdentityRole", "QMR", "QMR" },
                    { "7f3c91a2-6e45-4b8d-a127-93d5c8e634ff", "dec4b8d1-0ae9-4a4e-879d-2f266316b9bf", "IdentityRole", "Lead Auditor", "LEAD AUDITOR" },
                    { "7f3c91a2-6e45-4b8d-a127-93d5c8e634hh", "ad7e19bf-ac63-455d-80f4-fd0cee77c88c", "IdentityRole", "Auditor Team Leader", "AUDITOR TEAM LEADER" },
                    { "7f3c91a2-6e45-4b8d-a127-93d5c8e634ii", "3653e812-0649-49f4-be46-c71daec903d3", "IdentityRole", "Department Head", "DEPARTMENT HEAD" }
                });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebd49c75-24da-4ecf-8c49-8d22c4b66777", "AQAAAAIAAYagAAAAEMnjrCP5e6dqrz6mCNiTc7gZDI77/JewIxYE20lZA1yaNxLBcvzIXRb2xoewxaSBMg==", "6c8c9192-3dd4-471b-8049-6f7ebb3c7120" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "662cc4ec-4114-49ff-8b7c-c6ab273f11b7", "AQAAAAIAAYagAAAAEK1MVKu2XEwGgjBZVlz1mLo0SAoL48Vz86KZl1cFCOQcqLHST+6ZaSLa/J+poTLWWQ==", "bdad568d-7291-48e2-a70e-1bc5ac15ed03" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c809b75d-1564-4e3a-a766-9718218a90c7", "AQAAAAIAAYagAAAAEGZipq/uiyIxjGzjoWB1XgwEUL1gJzVl2RFAVQGHGP7NLiwH3eMjlJ9MhWvBktv/jA==", "7b2feee6-34f6-4367-859d-dc27444de19e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d05fc29a-4df9-4802-b5de-ec434b9a83e2", "AQAAAAIAAYagAAAAEBNAx0ldkz/d7k+9WepJmr66OT+pdZEXRkjANKXpORXoIXt34bX4MU8YiSGmXf2qtw==", "dc113834-9d92-45fb-a3e7-00cf70784665" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9353c996-184b-414b-8cda-4fba6e37557d", "AQAAAAIAAYagAAAAEPNoBwXeOQe3TMXlt1xLib1gRsHb+/qv+S+c41R31kQnf3kh6mRKaCXaTBmgR1i0yQ==", "7d84517f-2c77-4fc0-9444-d40ad615fd93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5beabdb4-97e7-431f-b44e-d0a66b18b344", "AQAAAAIAAYagAAAAEHXVW2a+P2Ufzm0lNFqtqsYbvy4tEEhvheFp75ECnzzkflsgRO8Hk1flrjMxaT9F0w==", "b47fda8c-076b-402e-860d-920cebc86acc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d647361-8fd7-4acd-b908-e56857754313", "AQAAAAIAAYagAAAAEK8fe1GHBGaURq9s7HlddlujEUEdpVtf7+mybwDfamdhHqt4McQp/HWxC8yiH/9lXA==", "d17977fa-6bab-485f-b903-d221012e00d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4f91d2a-0b04-4439-a855-8f5e21e26809", "AQAAAAIAAYagAAAAEPckdRhVyyrPKbRFMMeuaW1tULP3MnyeRVakcfcDzijDpqTx81fyL7a5QgzaE2+zaw==", "74d299e5-2449-4926-9d05-24da4b7382b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72c94cba-2ad6-46e9-924f-793b27750cc1", "AQAAAAIAAYagAAAAEFlut9DtAUAePu3HQEjylHg9r9U6lSDaYkrR8IGNw/o4av6CUdzeSrY0ztkO8CirRg==", "b84585da-8c9b-4526-9100-231a3c3c9c0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bfc212a-8ee6-40aa-b94a-c36e27a5bb95", "AQAAAAIAAYagAAAAEKG1441PBucPIS6cwEHTtqeasB6nkk3iE1idMc1NETqtbxjSZE+H4BRpqKYsw/zR+g==", "ad18a9a5-d1d0-4b97-ae14-6c772bc2205f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4a10595-2ba5-4b8e-a7a7-3040f8afe29b", "AQAAAAIAAYagAAAAEHR3+CKcSe6d2tDIdLVxWBqf8tZkrHibDrl/Jk5AGEKyfV2TCGi5XjJsv+9lBQWUTw==", "c3f5786a-7042-451c-97f5-ade2b5ce4efe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18d56104-e675-4231-bfcf-5fe781119e7a", "AQAAAAIAAYagAAAAEJC9nt3iRANrbnvSDrlEqKasTs1ZQLBTXH2+z94hTZs/KVAoeqTjf6VfXAOOCL2MCw==", "aca15205-81c7-4ac7-b88e-283d8317b29c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84017090-ac18-4b4d-8830-38d6aa35ae08", "AQAAAAIAAYagAAAAENdF2ydmT1Pzcr/l2R9Ffjba58n+nxXyulstIaTFP2mNnXmmd8klqhUVoLLKPSrhlQ==", "60049fd5-5709-40ba-8dac-74f85eb275ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "92806ec7-dc56-4194-b559-1aee0e8b8909", "AQAAAAIAAYagAAAAEAgFEDzNs/JtL2oBh9GLmeqPbnDup5/p0zVdFbbOG4ypkRwd/IOfbT32/AG+vh2GMw==", "ef24d79c-2e7f-41b4-8af5-a3ce200f3a43" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "833ea610-ce13-42fe-bd7f-a48165c1eb5c", "AQAAAAIAAYagAAAAEKWWuzvDrY8Z59dqjD7u5Nx893p19qi7SlwEQUarNA/qZ+Sk59JJzuOLNmhHiLq1Hw==", "b3b1af23-c5cf-4989-a5c9-c166df908f3c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d31172e4-1be0-46d1-a3a8-aa0c989ab7a0", "AQAAAAIAAYagAAAAECFl7bYlWUuzwBO16nT8y6r3jmxGGsBbjBgvU2qyK8cAUaUGnE4C4vIhBM0LnyC9wQ==", "12cf63c4-add0-41a7-ae6f-0f78ecf99104" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28092a76-8411-469d-8bc6-66576105d6a4", "AQAAAAIAAYagAAAAEFd0Vqvm0Fnn4uZmCuTtT0IUafjuUEw2G+N7pxY94A6RccmIcYzdHmAdxuyWvgAiBQ==", "70e23bdc-a4e9-403d-a16e-1912424786f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b51aeeea-9aa4-47e8-95fc-7818df0c6893", "AQAAAAIAAYagAAAAEEcVmrSzhrbiKShwJkjrxOM4jG6444h2nvgpXFmbxO0qn7PwHutCKgheMLIbrgg8jw==", "7ea5fef1-0222-429b-b41d-8efd6ba98670" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64aad354-fbad-4e8d-b741-848b1429713b", "AQAAAAIAAYagAAAAEOGMb80SgmsOEbYVyTrgzqh6bIBEvhTpymycTl0sX4miWSYxyEc05WbDhOTZ7wM1Rg==", "d3165e00-3135-4e40-9c15-56f827f8b520" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23f0c1a6-f266-4d4f-b8dd-ab16ce562120", "AQAAAAIAAYagAAAAEBTqgs5wofN396ImUSK1FCfIlGvr5UOKcFmV+xkIyQ3b4FbDfB2yXPbRgNwEYKa8ug==", "1b8f7dec-e527-4376-8d7f-f05077a37db5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d38fc8e7-2adf-4a48-8343-7c88fc8fdd00", "AQAAAAIAAYagAAAAEPuHQK97zQtJ7GTZ+wcw8oHvqL13JG07dy2Uuey3sySxxjXUIAM8NkRAXv02J+Nlcg==", "c56da140-9ecb-48a9-af3f-213fc67bdb29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "048b9ee8-6274-4acd-bc83-95aca7a05b38", "AQAAAAIAAYagAAAAEArmozrz+m6nIeWF4ARbpxUqH6uk4weTKpzrvRRWKU06hp4dp+uMIvCE4jccsVRvRA==", "edc3dfc9-70eb-4249-b083-21df5508a45e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77aa6b07-bc15-4242-b69e-aa89f4802cd3", "AQAAAAIAAYagAAAAEA7yRWMfPKMLNG894+hTYPKZamkWT/RyPTFDypAGGx19tjXcSnnK7dZuB4tMmgnweQ==", "3d939709-2d58-45ec-ac22-b528a031a95b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad675008-98f6-4bae-9939-85d3a55e0d4b", "AQAAAAIAAYagAAAAEMI4H1HgFHmQnCjXa58ZcqVf87Xc3LYo0BBv3S+S4aVuThN9GWMhFMweVNp6op9I2Q==", "d66efcc1-f12e-412b-a9fd-55606fd33b69" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3247a8d-695f-454a-ae7b-b353e07ed671", "AQAAAAIAAYagAAAAEDPZQU+bXA/3KmGhsn/7zBTLCMKdZvb/EDWcLbyDarLYabkl+BpUMy24DY1t7+m0cQ==", "199152e9-19d1-4488-aaac-f56c6e0ac17e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1fca914a-aaf0-49ca-ab70-16f55e325e80", "AQAAAAIAAYagAAAAEJxtGRB9AQ1Ocod9HqiW6+eDUWWtOZqtYcNzC9nY+t89RL+i3U4OrWX8KR8Fc60hdA==", "76f1a371-0cdb-4243-afb8-ce6355ad4ce6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bccca348-e1b0-4aa8-bf76-f565209b53bb", "AQAAAAIAAYagAAAAEPKCP2+eWN2a6uXntaxwwowftho3Xfzyg0hGNLE29eJPHgZci6zue7+2wmUKmfhMbA==", "93272ff6-c4d1-4976-8c53-efb326a9b59d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e7f2fa8-6ac9-4e37-892e-905cd1e1d86c", "AQAAAAIAAYagAAAAENhE3/DalNkBtmBM+yqQKYXWerLV1gWQo/uUj3OG8bbKUiHmPmO3C1a4ds1FSrhuJw==", "c60110e5-5e83-4705-a98d-036dab1afe2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f314a83-82be-4b6d-987b-2755e4baeb4c", "AQAAAAIAAYagAAAAELvvWq9S007AhPRyQubjXLPvCclHkWIV+XJAtujl4nmGfmZVioBjLtSEBEzVr9EDjQ==", "5c37146b-dd94-4802-b523-cbe2e2808b51" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d8135ccb-a107-4db2-9b15-0e67bb629cdf", "AQAAAAIAAYagAAAAEMrDmdht4VxGVYk0LRCJP3Gz5Y2ITcCiMuGxa5EifYVaGhS7+NPWeTnRI/zBVgzopA==", "7850f1f1-60c7-4e7b-b916-aaeaf4d3d28c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "26d5716d-d8ae-4e6d-b701-c055c127bae4", "AQAAAAIAAYagAAAAENKUkyov2Hmq1xZeHTriqIkodFAgjGsXcLvNxV9wzn/CQIp8fbglUEtG9KuIvqStyw==", "43018c4f-9eb2-4603-8507-bc572457bd7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "172db82c-96a0-4f40-b784-3cce317bfe45", "AQAAAAIAAYagAAAAELynd6lBcxfd1pmIq3RX5Sqkpv1W8rOMMNsIKvzZJ1Y691+ipe9N6Dpe3braKK68gA==", "b06bb767-21ef-4bc0-a72f-b77d0c53c4a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2847aafc-c66a-47f9-9031-0077c7c1b52a", "AQAAAAIAAYagAAAAEEzwVv7rC4bWIBRAdOM9T0Ek4XTy6dlNj5qP44UX1HNpIJg8pCfQnVdLXJ3FnKJJvQ==", "660eb8b9-b800-447d-a233-3c69e7ecbdba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f01858ed-8b82-4d8d-9ca5-382e7de3d81e", "AQAAAAIAAYagAAAAEFJBjEtMqCDA1OFr70YXU+rbLczNgmmOPWWKv7ZMAJcHhNo901P/L42NXpzBzov35w==", "0534dcfd-eb89-41ac-b4c7-ec6581e10789" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebc606df-d52f-4490-95db-0b61ab94b707", "AQAAAAIAAYagAAAAELdGAl5YS8V5sh3ZEj1ruPTOygAvSgJBRVEQCFtnZ+jW0WzRHCAK8EcmAhHN5JZlXQ==", "ecb1ca30-ef2a-4722-8b76-68916391bca1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08052ab1-5d74-4093-b54f-372938a8a284", "AQAAAAIAAYagAAAAEEqCp7kc6nBxisepqIhwECeuGI9N5VAO5kt78BAQH+35d8PXfaQyMz96nbKFbzd93w==", "d1044ed9-abee-4489-a784-1e6fb7bc45f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "036e9a9b-8cba-4962-9336-0492393885ad", "AQAAAAIAAYagAAAAEG5Rx6XkTqI66nx64c62yMEhW3zdfvhzOAvj9ZAivESGrL8ADnIu8U32pXAPVA7Bbw==", "312d0508-0e6c-4150-9c50-92d5c0fcda10" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3f719ff-c1a6-4d13-b491-fd3028c27909", "AQAAAAIAAYagAAAAECnbvP8XpigLir2xSCVh9VJATC0X+B8qgWsIdAE7jBCtLOarUY7VtUdc90v8VEThzA==", "4aa4dade-6ed9-4ae2-93ae-0414a971d894" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d59eeb3-6888-4f76-8b26-87adb73fe602", "AQAAAAIAAYagAAAAEDi+vFM8SQyZ7NV9VQXybS3tr2Gx22NeLLFqVEoR7eDFUyjwiECn0XfoBrCTRhiQEQ==", "a9dbcb66-b750-48eb-ac84-2fe984dfe824" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "782e547a-c925-4b17-97df-96514e12a9a9", "AQAAAAIAAYagAAAAEKYglLB0sxp3aGTzuQY0JzpS4AvL7oK9p/uNkn6ymsoL0xt1BLF+sTj+qYsdBi/ddA==", "5c534737-5228-4462-91ce-5a6ed072951e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "acd5ff56-5a9e-4d18-bfdf-7677df00fa50", "AQAAAAIAAYagAAAAENHp/DpERzPSZL0RuoPzyEjG5vVdPIM0NSwOWg0oUC36mpYv+GcnNxpWBKpANGWucw==", "83c9957a-299a-4bcf-a125-120b42509f9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8d7c6c36-e135-4396-b2d5-45b1fe14eeef", "AQAAAAIAAYagAAAAEGFWnQzRlTqRZW5QMJOM/kGD7K4L4/428ivmHf8cLKiqnR82M+Ziub0EhtWFd9uhMA==", "008ee8d0-5ec5-4796-b84c-69c60cdcca4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73dd87a5-6a09-4eb8-8c1d-ecb51d6c04ac", "AQAAAAIAAYagAAAAEHeaqZ7sQQgPhIVcVi/Ha78dxuVi1LE0Ciq1+k1Ln8KN8qFY6oA27AMnsjTrjjZT+A==", "e90d7ffd-e77c-48eb-bfb6-744395288682" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23adf9bb-8360-4ce4-8d46-006b8d4e061a", "AQAAAAIAAYagAAAAEMfxo0sG/AsznyglO6g8GUe3rHb7pxhcwktB8rz5TQEei+dqNWwxCpuHK9xt0/T4QQ==", "9b1eb4a7-9be3-4533-b793-ca82b51ef5ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe0c2d33-d8db-4f8a-9146-075551cd2426", "AQAAAAIAAYagAAAAEK2+mkMsk9NJdATRicnVJrKb99CT9FEnVR/g3O0PoW/SLAjL49qs7BrqYcbpTZE8Pg==", "802e4aa1-2226-4ae5-96e2-d8b83e7030bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9b18dc6-64e8-4eaa-a6ea-aa7c93ceddb3", "AQAAAAIAAYagAAAAELPXxO8xdcdCdGkvPDdhM0nykuZOFxh8ZZ9Fsdc1uUD/UpUpje+Yhdi/V6uEYyR6rA==", "99a2ab85-702d-4b2c-8c9c-48912f680b1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b26cace1-2666-46da-9e0a-6297720f0cea", "AQAAAAIAAYagAAAAEP6t2Ju5lIdVohuFACeKcDajlE+0qe3ERQ3lRApL8fRg6wr4NqCoy95C/Ht87hR+3g==", "fa4f9a3e-a947-4cab-979d-2ebbc813e1d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67dcca8b-f9f4-45e5-b5db-20cdb1f65b91", "AQAAAAIAAYagAAAAEM4eHfALgEFgH/0yiHnW1irCLYvsth+S5aP2NGzkjmOq1kFAMwkUz1BW+Mj/fDx7XA==", "6061c16e-3995-4569-b2af-799d834d4704" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57399f64-1197-4f6f-aaed-351586958b2c", "AQAAAAIAAYagAAAAEP5tlw66pOT8CjBL3R2eu6fsbtOwYkRps4ws1Qd3V+ueG5UJqfOHHKB6BIvFo9VU3g==", "07926130-7658-481e-a628-9f02fdd9479b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5db0e693-c097-44a3-b51e-f1b99c7c2061", "AQAAAAIAAYagAAAAEBSUK5wKg10FUgiT2fGRelRiGss4Lu8HsZ0oQpUIfF6IUxp5Wwo8NsyL5xTmLgt0oA==", "3313152f-6f89-4c4c-841e-9173d53aaf04" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0872949e-a05f-483d-8487-6ad62496bd4e", "AQAAAAIAAYagAAAAEEB//mExsH1o3A84ywlOLcl0jeFR6C6KG2fCPXEDU8CYRSYS2ePSABCbTniTMCq4hA==", "9c36c765-a4fc-4dc2-8b68-aff715333b7e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69245322-9cb2-4aa9-9fb7-40fab9b860ff", "AQAAAAIAAYagAAAAELToP6Y/esg1lYqD17oo3gVHOoZ7uJev8+fgWpvV8bgac3rUBv5cesbvEiUfi37axA==", "99dbbf3b-85ff-4689-8078-7949186a7f02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9eb438b-0d6c-47f3-860a-363f485936bc", "AQAAAAIAAYagAAAAECERtaLPaUqdwnSldVWOXWNjYFu8yI1zJTf7sQX5hT6qyIlgmYxo4vCjNIGo2Bz/RA==", "c92aaa1f-7274-476e-bce3-8312adeec3e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d20f0dbb-b1a4-4dbf-a39d-2d027c6e2088", "AQAAAAIAAYagAAAAEIrjQKmWZSn6AjHafEHzpFvRUOk7DYnZl+1w1gNhXbeWvTHoZOjPNcKTalNvQCxYVw==", "4dc5fd30-b954-45e5-9c68-7076d9939cc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec2e07d0-d6af-45a3-a215-82c38d345bca", "AQAAAAIAAYagAAAAEOyqmx0mhUS2JGLlEz0ufA5GGYRfMspnNEpUIEKIrR6fSQVim2/fKpD/0jXBxO6x6w==", "361858ec-c002-49d0-8795-182fe6d23e78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a0b8b80-187d-40e2-8799-0826ac9fa09a", "AQAAAAIAAYagAAAAEG5vDaCZpZ1S4l7DPe2qbIMkQkiO9dZipmJS2yp1OJRuOJxF0nOYRJR+Z/GW3SsUew==", "a0cba296-7c28-4e50-9254-09a371b12a84" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0942ab65-8409-45e6-b3b9-e87926e74508", "AQAAAAIAAYagAAAAEAWWYyuTH8GmOrRRn4t9jz+P5cn+tQM+S1PztrK+uPaDJCUH6EMhgdRAt9mG7/IQhQ==", "8790ce53-b720-4bab-bb56-5fe9811dbe9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e5f6a30-f68b-4bad-93b6-4e609191efaa", "AQAAAAIAAYagAAAAEGO4w534TVSpVDUj6wNjEZSceLtPrJVVDKwCDTa0nD/JoUrX/ZzRxWRdbFHxvkZaUA==", "766c8abc-dd16-4858-9c95-c9dbe5f15601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17d47df2-ebb8-4165-bd47-da85c5fced70", "AQAAAAIAAYagAAAAEBjIl4r2hky/sneROkN9/LlxH+uWvZsqaZhUIS6ao4k4uM9G6rg8kNjKOL6sLSR4hQ==", "b99495ed-26d5-4113-bfe1-6de7db30331b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0711d50-e47f-4781-9dc1-eb6f96edc955", "AQAAAAIAAYagAAAAEKPRZxfHl8O/qt8/9AaDq3qezL4qTFA2AH1XoVA8Row6E+QSdIsb+7t/jbJ52sVBPw==", "9b67f83e-7dab-4ebf-9bc3-d3f878ab3d76" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4b64767-19d2-4801-8044-b0732b2f9413", "AQAAAAIAAYagAAAAEKV5LH2Q/nsTDgvEadGUR2zb2/c+DaHG1omY6u4y0PUJIEB3F+gBuuS84ZDtxOZd3g==", "e069c679-90b1-4150-a1aa-8024f09ffc31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "716682b7-320a-489c-8010-7a1f640c4f71", "AQAAAAIAAYagAAAAEMq8LGxFNEXPwHXCXBW38rR5KhJqpCgfbJq21nndufHI9JgH8XCkcazC4ARXDZwGLQ==", "e0bcca98-fa79-4116-bd06-32d410b06e43" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8724307-c052-41be-a125-99a36e7aac65", "AQAAAAIAAYagAAAAEDsK+wAL4BPKi5To06wcJTkH2UmAoLDFOq7MNLyvrMINM07QVxk9l/iKseyYbIocsw==", "81160476-af40-41b1-a7f2-4f143a0960bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "476c12f7-fa70-4402-8484-5432c9960c89", "AQAAAAIAAYagAAAAEB9gBGceGmhKVXxVA8iySKkHIFmBK+fD9Coqbh1LVv3hQyh/W4Wc4NTIOUP1KgH66w==", "aef9a1f4-714c-4081-a241-6edebd3039e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c238859f-2047-47de-b545-5b4416e82e12", "AQAAAAIAAYagAAAAEHL4Pz/4YjdZ/G0uE2v1hbDu/o3tWO1Rynk4JbaeOmIBt6P5EUMqnB4iLVs+3Qyv/g==", "13635a8f-c6b3-4e2e-87f0-cfe47b3bf071" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "581df38d-9926-4758-996d-f3ec949ee377", "AQAAAAIAAYagAAAAEF/ODDb1Duvfnfy7Ged7W0QZkTrcKmdw8gH0TBA8Qa0j1uTVEUdfN+cq0JV3tuHIfA==", "4f8a5335-8a4e-46fa-8a75-d4aeee1436b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2074198f-dccc-445a-8d26-e987383b8076", "AQAAAAIAAYagAAAAEKVPtrdks2sB8mjacgbyv4VO3JWoywxKxPsXOdYLzIdRNdBmEZo21nDmyGQ48DkQZA==", "d26a6206-d853-4a3f-81ee-94223a14330a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "919c1fa3-5dfb-4484-8a6a-679fbeddec25", "AQAAAAIAAYagAAAAEFYuCp4Z1ybNEp0+RZCYUjxY5rLsXONkEAyWk7P1VA1so/odcKO82RNaVNmtBfkZtQ==", "f1009ec7-44c3-437c-bd75-e4a5a4155743" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "547c10d8-d31d-4b4f-8089-f5ca4236911f", "AQAAAAIAAYagAAAAEIAc3DLxXzep9NwqxsNwg5etSFUUxhgoyrtb4+rcGWC0mJZqwYPjjCjf25UuqZAlpw==", "017c37ec-afda-4970-8dca-90f9c10563fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad27659c-3f82-4a06-800e-fbc1d847c8d9", "AQAAAAIAAYagAAAAEHvjswNeudYgM6jcHr6ouBegQ5OIodyG1gQ05SwXYASiqBZULeK4lEpttf6Ke0K2/w==", "f7b70764-33f2-44f4-9f00-058dc8f47af5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a8c9451-884f-49a4-a871-e96f5f8c45c2", "AQAAAAIAAYagAAAAEC2diIn4yNqHdpUJg6A0F5sPyIG2DyiTnk/bryHq6gQvokAgrFQbBAPlMhPZhFI9IA==", "30edc5fd-b42c-48fc-86af-202aefe5255f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f2cf25a-0897-40ed-98b2-6d485f6426f1", "AQAAAAIAAYagAAAAEMsppWjuE+kBq/xDORBb9KpaN9FkFE8rZESkDfSKuf5/tZDF9m2xFUGFiPIEDnnQpA==", "fb10e836-9e04-4f67-8148-d42be141ccc3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f4e2d97-331a-4d26-a04e-ca67e4e87f17", "AQAAAAIAAYagAAAAEDS21iyl78R2VTZ1bI3WdypsTnaWP0nnjA+1UDA9N7kMalqzb5qcDDhAAi24JGZakQ==", "fccc36af-8859-4f1b-a5c3-0b76c9010f47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "41e43c80-633e-41af-abfd-85f052d85f48", "AQAAAAIAAYagAAAAEDaXui1Zc+xDcmi8VaJ8gQA4Nzghy8xdmuEzh8W1wg3Z1DOdWYwilgRokW0GFlofkA==", "a322ec06-40a4-43d6-a22f-79d998c69326" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b287ed48-d9ae-4e10-a2de-43fba91f8c0c", "AQAAAAIAAYagAAAAEHGjhEAnOcQGl6qqMlIrgI+2Dt2OKMkoh1uCrHJPmdSf4SzqfgxZ/4xCiL4Qc19g+w==", "44f670ef-ea11-4181-a108-2bfa324de9ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a9fc6f8-be26-4dd9-ae39-5e1b90b7cfaf", "AQAAAAIAAYagAAAAENQbnJYLPDgFBOcV1eHtfblmrsAH8Gl/f4HpVXg0LA9f37Llwg4tXm8IjhC9dawubg==", "42ba19e5-83fc-4f33-b560-af7c43fc4931" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81325db9-1205-43e6-bba2-8ff2a805567e", "AQAAAAIAAYagAAAAEECzDEb38Y1iK5YiNOdRoVRA1f6o7tRg4kl4se3VK9gWHtdKwj/PIU7LduJZs6+yWw==", "30963494-f433-4306-8f74-f5a655e07294" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5829313-3967-41e4-b861-03f920afe4c8", "AQAAAAIAAYagAAAAEFKeRdpnfOhAErWDqw0/f27cUhRkUCuMSPBVjadNFsq5JcLWR1lXkWlfcMYMEtCgNA==", "19a3e659-e654-4b57-9bd9-956461f4b196" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9092e845-8b6c-4dcc-bfd1-559f72a139d0", "AQAAAAIAAYagAAAAEEJJVaWWEj+8912+WIvYrYzbXwTvr3mDol7rqoBKzqjZa+rLQVzLeCrur+2OrF4R+g==", "3987f316-e14f-4844-ab4f-0e28a11d65c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8fb4f0f-ddd1-4286-95cf-52503278b149", "AQAAAAIAAYagAAAAEFT9cJAlPaiN8buDqJ6tsi4X4VqSbvhXfJhDhMBOWFNSlNxfhLb3kXf3/tJpbTox1g==", "8c25c0a3-7b57-4d6d-b7e0-4179fa4148b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09571fca-7b0a-4916-bbdd-47faa82c05b2", "AQAAAAIAAYagAAAAEDMefSBE4vuJ1bSA124YpRw1t9pwfebe6yVv29YD9pxfKRcE5QtSjps4dPtFFQhcrg==", "451e411d-78eb-490f-8582-696d20acfcf8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cb3ef4a-8356-4022-a9a5-855e66db5698", "AQAAAAIAAYagAAAAEC32EmBIVhhiRCXiBhDCvycDINlNenSPOHhfXnug4mh/PON7SyCejbdn/WlNBv8a2g==", "a6186e1c-b2a0-4e3d-b6af-ba9999fd535e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "956ad2e5-6437-4e7c-86b6-528adcd2f898", "AQAAAAIAAYagAAAAEHOkPmjXHncKPuBXwq3gn+aH03LeS0r7y9W7WoKGElayxWa+3NzsshNutldLQVqmXQ==", "5d20fb75-5132-455c-8190-7a27351908fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "854d5458-775f-49e9-8547-987dfa866a25", "AQAAAAIAAYagAAAAEKvJ5hE6NRmdVQP+t5EwYYG2HWNn39TaAEOEwNrH7pGJ5KedxJW2T3ZWRXlYZzNsAA==", "2243f6c0-ccf1-48d2-8b9b-a25362bca6f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a41b459-d78f-4710-adbb-0fca96699b00", "AQAAAAIAAYagAAAAEEQZKnmQLfW/K2zIRlc5I5F/1K+vivpHnixP5Eqh0bJz1tOYV3TtdNPj5z70E5Em6w==", "87f79204-a7cf-40f8-aa00-2dad0074da2d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "979b6cbd-fb16-4577-8e57-67242de02209", "AQAAAAIAAYagAAAAEF5ntoP5RdM5dbO0b0haRbBI5Nmf4lqCqba+ubGFDGibLnTFFsP+Qh1ycvmjF/6Gaw==", "3d6e3027-6dda-4897-9f8f-72afbc85731d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcee305f-a3d8-438f-8c5a-688958b81374", "AQAAAAIAAYagAAAAEIU3owhMbGSFLvIdg4kb9DH3dkzWFymeAJj4LeqLbMZxw20GJ96VCGv40yL++ALvxw==", "29d2d341-0768-4b99-ab3c-e383e489005e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97f31754-f997-4e28-84ff-d95fce69d7b2", "AQAAAAIAAYagAAAAEJJXIBG2nhx/hNMSdsASrmCv90pN3Tim5i3PBYIk7ZWOC+Vo6QK1v4IMUXWxfc4AnQ==", "39ea1fa0-3d28-4513-8f7c-3ecea21ae27a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89d209f4-d9ae-4cae-9e15-35eca56107a8", "AQAAAAIAAYagAAAAEPgdXk0TeBq4IEzT0UDKc0AK8lFNPYcM9GmYCqRvu2ulr7dSLzMffNzB++RNpjy+dQ==", "3ee83498-accc-4472-b58b-25cfc29ef68c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1129b70a-81da-4b84-9e16-3e35a5becd07", "AQAAAAIAAYagAAAAEMMgEtaZQU+Ng6+F7jji4CA5vueP7T0+2ZrlfgD90KULsLEzbw2t02BW27ZhLZikXw==", "69754ef4-c686-4310-90a7-67c1335352b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cace5a9d-28b3-426b-8657-a20defdcf826", "AQAAAAIAAYagAAAAEKna7wPij6M502AhBK8N+9AC73iWVMhdm3XIh2KVS7tbhG5u5Ho1jHEwCaP9FG/8Cw==", "71532dbc-d421-45cf-bbda-0426a6799f66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2380b39-ace0-4a67-aec6-c06ae062536e", "AQAAAAIAAYagAAAAEHyN+9+dwS3mXlkhUI4aDs/RJH0RmC/bvDgB6PFCdflhoLGPDNPsbWjYGX0Xkmmg2A==", "ed304e3c-2660-45bc-b43b-47d3c6ce168e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ec9e3a5-3a38-4dde-9180-170f0e465a65", "AQAAAAIAAYagAAAAEAYuuTRG4k2ElU+v36SDKVGU9XAjsu62jzN5q4hPsdWnZkSW3eOgeUQTLTUIrIkzUg==", "1ec8ca14-a1c4-4e87-ad97-50c5eee9900f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1bbcbfc7-4ae3-4e70-a290-b6e9f159030c", "AQAAAAIAAYagAAAAENhuFEeJwHcqHmE9kn+a0aLnYnm6C7pQm7jnUB4WRk38hj2V8nEiI5YD6Grg7DvpdA==", "1cc0671e-3876-4cf1-9d0d-82184440336d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a11defec-3422-4b23-9f8e-d4586768a39b", "AQAAAAIAAYagAAAAEMqhj7swbPhowSfh3Wo4mfIXx21ojM1hz2QYN9fWSuz+8LYqwYP3RkTQD5kNRgSQ5Q==", "edd55c8c-0848-45a8-a0a7-f1b39650c7ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e09b5bb6-9850-4ada-b447-dc32a482f816", "AQAAAAIAAYagAAAAEBOrxHcrpwFPUydijLdCJ+XrWXmrf9XXmQyFNukT3vshlcxew0FseHd7DlmiXs8Gjg==", "10db845e-50dc-47c9-9127-0b1594754b42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f44d182a-f403-42aa-a2ff-c55eaf65afe1", "AQAAAAIAAYagAAAAELxkCbyvn+ZgB/+kbcWiZcpWAr6BrkRaaNRDpj19nNLc8v0A5ZfqgiuiKwHcvr65NQ==", "d6a82004-d476-47a8-9529-a7ab3430e158" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c90471f4-8b43-49a8-b157-54e41f3ba356", "AQAAAAIAAYagAAAAEOOdYlJqJTZxcPcSJFcdtx7chFIpTjjNIrr3q2CW9NyAn6tHDrtWoZHS39zhVD6gjA==", "1f5fe5cf-0289-45f1-bcbb-c18d12d3988e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "184bc435-0a21-4e42-9428-013a8ec629c9", "AQAAAAIAAYagAAAAEGJ/nAagDFOBhDY94jn6qeTl2KsW42XhWMB5LcfyoVpmrGiUgDhNHDfKIllrhdZbiA==", "88a4cd5c-f582-4182-bd8d-1f91c2f582a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02454129-e603-4a03-a2ac-28b7a6021938", "AQAAAAIAAYagAAAAEHchupN9C17MjXm01oQCcZaBe7Kq2TviiT9/Z6Ar64a0JMHX5Q/gyDx5d/q+tGpOzA==", "f7ca348a-ad67-44c9-b067-50091200f9ff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8674c61e-bf0e-4f38-82ec-c9e940d0eb5c", "AQAAAAIAAYagAAAAEHAn0RLzX6YCnspgYVvAuaNFYTEsAQuMVxmQ58fm6bLOdZP+e40mKyMj3feIFsPI4g==", "b469cca6-6b16-4e0b-ba5d-16041255266a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20ceb405-a6a6-4022-84cf-8da71c5ed543", "AQAAAAIAAYagAAAAEG4+QW5feSw79sxtV6oBFtiGwqtvqjhxxOzM4lAgUzfMMmMUD4UMd4Lj8KWx7oduzw==", "f238237b-8533-4c95-8041-723f90913b55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82acab70-d958-4f15-863d-14b8f0d627c8", "AQAAAAIAAYagAAAAEKAuxrq56XKlUfLwmOSGM9qbBS3n3kPS5G2F49mx9BznXyc8vDnf7p+6IpaUgy4L2Q==", "b8f18e92-0c3d-4b83-9b9e-bca5b4508a54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f553a0d4-00cb-449c-a7c5-28d72e79d379", "AQAAAAIAAYagAAAAEEUHmfmOLbjyEin66WwV9pjHHEQRzVXRv58C6/l72ahccPbqlyE6nT2lI24tGbrC4g==", "beb5f628-305c-4281-ac67-8c1d35743416" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7335bf7-3233-4988-86b9-7029af0dcf1e", "AQAAAAIAAYagAAAAEIMOqwc5qIDbhFh09ZLdKqLArNhJQIOXPPCNa1pEn7xpAoCWd1cmW3x3DPHUlFIiMA==", "126633e5-cb75-4852-908d-02a0e553f353" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc1b1281-2212-4c1f-b395-ff5a2ce8968c", "AQAAAAIAAYagAAAAEATcFENWHJvZVv884NhKADFfwQsKgkfGnFBFTje/iwLk7bykAgw2hweHZwEUpy5IlQ==", "485c0be0-14c8-4674-9db7-55a9e4d2d3ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00d94962-a835-4f0a-ad19-9c4ab44714ca", "AQAAAAIAAYagAAAAEAy/A5FQWBXDLuNlMgsDjZ4v/CNl5nQo/Q9DnzLiXJbV19hAwGG3IjoDJMjqQ/TkBw==", "6f27d1e3-5772-4cc0-a85c-d7c736625e5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63c60f75-d0a4-42d8-9ea5-98f35ff30c48", "AQAAAAIAAYagAAAAEHLo31M07MdqDJqtRVz3wifnocselbFm4icRKNI9C7ZOhJOEcDNOy6w3yPspE4ImFw==", "75e578f2-6f52-481c-bd11-ea7b482de32b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98fd552f-fdd5-4695-a18b-8d7df43fa7cd", "AQAAAAIAAYagAAAAEJL70Cr5zKE2kLAV6RxYrwc1sRpk2tGetkQPRCWebEo/sxkhaObn27/ylCrl/2sgTw==", "9b0fa2e7-76ab-486a-946a-ec6890879637" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fda20d33-0d37-41fb-9deb-583ec128e9ff", "AQAAAAIAAYagAAAAEFoLsFBFEBlO1+AiroUPovdyQ4KgqOrbhWcp9CduVAWJsJTOWq0BfgjnexV/eVMMlQ==", "e458e428-78b9-440e-af8e-d698710945e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11ec7fd1-6fbe-4b6e-9b09-83585cc64fbd", "AQAAAAIAAYagAAAAEEWr7eV/ksb3lgN/rdtha3IEk29Z4hbvwBD7hDXPQxWLIrB4gevSz9NAcrdIMxNIGw==", "97f5a919-0ed5-4e48-938e-76b936490cab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddd8d26a-3427-47dc-b8d4-b4a6334ebb5b", "AQAAAAIAAYagAAAAEIIIFpOhdfBdSownq/qpsFLivi5rmgfV/xeuupNfUU8Zsi2ZV2uNibE1ifDL2XU6/A==", "ba75309e-3169-4cc7-9b72-7c553375e47d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7693d95c-3d34-4a38-a4d4-2746931d9cbd", "AQAAAAIAAYagAAAAED6Os3mTBRfD4H1b1NtrioS705Qx03m/OW/fgp8PGtxDn2Fxnq9sai/dkfTT1Nnx9g==", "7848e3d0-3509-4329-a4e9-477630376cce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eeeec3b0-ef0e-4e30-96a5-ecfba6bded8b", "AQAAAAIAAYagAAAAEF1Yd/VM72ZzOEh1menYfIcaZIsnBYQlhwktbFsr6taeue8Ioh74PQWuLt/yNauIZA==", "97b58e6f-138a-402c-8212-8be4cc4ff2cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8bd5e9b2-ce53-4f98-9b99-52e5ccf281d5", "AQAAAAIAAYagAAAAELzpu1YEhX8aiWGppKv1eTVjmEkmelwfw0SawBGhaGDoKoLsGNNWH4d5C4r80D8Oow==", "8a922e2f-297d-411c-a978-c82da4cfb646" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c3e1638-f1a1-4dc5-bbee-e257a76ab385", "AQAAAAIAAYagAAAAENlnaGt5uMiabvuareKKgZrcXzJm8PJu0RqnKqj2k9QRQBTMVbwn7Besqt7+XrrCwQ==", "c5f2cc7a-91fd-4970-9aa6-64a9c11fa0aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "049f9785-7cd3-47db-b123-b8ed14b61b5a", "AQAAAAIAAYagAAAAEHYRhRTEqOHVHb0ikxOZ27ImRWUf7aFfP6OeX5RxPYsbFHUyiYlrizLLS3XsAEyVrg==", "c8853e67-2223-4c74-96c5-cf0b2db4056b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e95331f0-5afb-40bf-9e83-ac20e264492d", "AQAAAAIAAYagAAAAEHLJePaZ1Sj6UPPTrNkwq65tHFycS+Ph6Q2A+fLn3v9MZOhLHMQS82jvtLszhwvBiA==", "4e01f3c4-935b-490e-9499-9f51301fee81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58991aa8-d481-4ce0-b3a1-10e6bc10ebff", "AQAAAAIAAYagAAAAEC5Fj5qhRY9Xs+n53R2EXQR7+0XMDzU3TJCCOfwBB1CelGBrj+d32o44nVac8B2koA==", "e5fad973-4833-4dfb-90c2-298110d66f74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b013ec3e-5094-4df6-bfc5-ad6625e27fbe", "AQAAAAIAAYagAAAAEKvYC4+g7pWrqs+zi2Eo7O44SGh2QCaasRnkC7HqNzbpOQ6ZGcOvW/YBFBJxh4Tx+w==", "fb1bfd75-f69a-4017-a6d1-a8e78f38b3f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f56bb9c-9935-409a-87cc-c7c81ece1823", "AQAAAAIAAYagAAAAEHyeOl4XBSr1YZVqlEdtTMaq/LEhJiH3KztZ1VMSdt6L2w+F3KAxSrniTahGKRuSwA==", "6b9718e1-dad3-4749-a36b-07626be3d34a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7cc1de5-54fa-4829-bede-6e123bd7eece", "AQAAAAIAAYagAAAAEHj+A1RJjW/bi/vWY81VJ+R3rG5ZhW6/ZiFSfg85s2b0XKEVnLbIGQj+acdCU7FmHA==", "c86bde5d-1333-4d8d-b7ef-49fa521745c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "647aacff-3b43-4552-b0b1-ad3248b9fec3", "AQAAAAIAAYagAAAAEGCSavVyxrgH2Hfhcki5R6xue7jV8mUvK6e5oh5BPIZ5C+MHHSqrKSDKtLLnroPjkg==", "3f3a2ca9-e8b4-4204-ab7f-58bfdf3a6966" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75b107df-44df-4b7c-abaf-a61cfd10eeb7", "AQAAAAIAAYagAAAAEPYF4FPCiAg8XAq+8O2PFpBebcVCF9xNtrcMnlYOJEuiUMva8/IVwnf9S5OkWgtquA==", "25935e9e-674f-49e5-910a-324ba4ddae0e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19662134-2fcc-4c3d-9acb-44b3fb019886", "AQAAAAIAAYagAAAAEKSkOsbdava4JZbisc8VMKELA5UklLROyAvRt9AGUA4B1YVanipp4A2FpscG6j6ibg==", "bea2dd9d-6715-42e8-b516-fc480189948d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d892f3e6-96e2-4fbd-b780-8523ceda0201", "AQAAAAIAAYagAAAAEBtWCQw1y5lk/MM4WL7aZl630l4LiPI7WrRbYGj1U28INQlUJq7e4Gj+nl0Bil+Naw==", "7a9b611a-e48e-4b3b-bb0d-1b60ce7f1116" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b8ed963-3791-4064-9166-89a199a80dfc", "AQAAAAIAAYagAAAAEH17Y8TYoBPNBsaa4RzhNqcvy9pZYhIycWA9IJXl8qeS0yNjcgK+3Vb2wAfhiRyzXw==", "48225f51-1252-42e4-a0b2-5cfc3fcbfa32" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5578da84-c7d7-4656-add0-870e37a9c425", "AQAAAAIAAYagAAAAEGXSVJvEbtwadAAqVHGwJdik+WpFNZxMRsZedxv9Q+BAQV2UkEOXT2n0dGiw4eCBnQ==", "9aa341e2-5bc8-4a76-af23-f85d5e29ce56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c3a3451-e30d-4584-a6d6-a770923c2504", "AQAAAAIAAYagAAAAEKY/P0iu5oCh76kqxNjyKx6eyQIfDr+0QhyTCVYb/Vxy/nDRMaapBSbWsFlTdrkF1g==", "415dcc76-7635-4808-80cb-db6d7b640003" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a91e0ee7-efb1-4c0a-ab08-0a336f7133d9", "AQAAAAIAAYagAAAAEFvKx1+GpZ3hHM9LXAH7leLVJqiHGXcybjms4OY37jhrk5p09vWKGq+LlpYuYLjvuA==", "a1dbe332-b4f7-43ae-87e2-f6dfa41a2d9d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "caaf2bb5-7afe-4f5c-9dcb-669a9b6166ba", "AQAAAAIAAYagAAAAEAguV5xgiP7nbTmPdfATD05cnniWbDvzUNMKwV32a0qG6vJ7nLxs/9TX3Xocwpazdw==", "4154a810-7363-4797-b071-4d0319a937c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6fcba6d6-6bf5-446c-98ba-15840a205dba", "AQAAAAIAAYagAAAAEE6+19KwfXAsg4zzdpClFo0qu44WcaNurqB2tQDbrVsArj6DFIt9XrxG45LRK4KMMg==", "24967a36-7161-44b5-81db-f46b7d9bce3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3af83236-b6bf-40f4-81e0-6cf25df77271", "AQAAAAIAAYagAAAAENwHX65uQZUtEwILVlb5QttsoHzsiffGLTKeTehR3UbAgKXCn3EiB/rB6d4p13EIew==", "a246bbfd-6cf6-4536-8d5b-ab14383820c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a354c55-b2fc-423c-915d-5e8cc9d66a2c", "AQAAAAIAAYagAAAAEEFmTbT9QTozwZwZWQ99S8TKL1SIgu6P+c3U2jUEX6stC1nc9/wOnMFwNUmaWT7JuQ==", "896e52fc-2f67-47f5-8d4a-825133f56e61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b01504a2-332f-4a7c-a070-15986be0576d", "AQAAAAIAAYagAAAAEOUIxB8si21Vb3qxv6mnLg1Glz4SQW7oieUZnevjBFlKTtSafPDGMjAJvbhChd6OIg==", "c178416a-56a5-46d6-91b9-96e7fa8566fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e905e85b-a5a1-424f-9e0b-e14d1346aca9", "AQAAAAIAAYagAAAAEBEbAT3leerZrlgeEjyVfQlovCJrr0aLfgEB1jYZCpZLldzeGSnnx9mNjvA+z9FXMA==", "05e86ad6-cfbf-42cc-9619-7b60998337bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33acea44-2829-4350-8b9c-ec76bf384351", "AQAAAAIAAYagAAAAEOC9EZr2+zmc7GGFt2PfOXmBNAe4ZAFu10dJwIYR6LYH5eusaq1X2e3tEbvQCXsEXg==", "2eb1de5c-92e3-4282-82bc-6f9ea07bcc19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cdcff2d0-8dbd-486e-835c-5104e8b44e7c", "AQAAAAIAAYagAAAAECJz0TcMn7N5nIVdLX11wkdFeposOFi8hb+/KC7XfrldtV3Liu/zzgqoKeN3KQivDg==", "f1d8355f-bf9f-43f5-b2e6-c7363eef95ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71953bb0-258a-45b2-bb87-98a64889b96e", "AQAAAAIAAYagAAAAEIMiikSj7G8RI9w4d7AFCriUFaT7iHeOx5qFMlto8cVokjUtEqc6l30Cug4gD8jT4Q==", "4d8f8251-27f1-422a-89fe-a081c338d573" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7af6db1-9189-4f28-8f42-408cdb38a873", "AQAAAAIAAYagAAAAEGgfgc9n9mKPnhxxoQSPI3BgaaKoy+ESRh1ykuPLpit75l32se9NAQDhmktB1ahkxg==", "3b24e606-92c5-4119-b76c-6961ca8072d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5bf25a7-c2be-47fa-9319-6e3667d31c67", "AQAAAAIAAYagAAAAECqZNbr0xFcG4ioMypPW7OKYID187ziQnLJ192ngaYLilmyf3mkPuSB1ssHpzM8SNg==", "cfa086f2-aa96-4681-a7b4-c1598e379564" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76c9efb1-8179-4a7c-a5dc-902118b0cc9e", "AQAAAAIAAYagAAAAEHwbA8P41H2ZEOzDgmN+bnbQW1UuFuRvPd36CZ332f1Wm364+fJkfYjQfeyW3BpqSg==", "72964b3d-ffc4-4bec-be01-0e3189480c90" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b556be99-f0ad-4986-a3c2-a293df751595", "AQAAAAIAAYagAAAAEB5OymrlJrcFpFqSddOasrX0FYs+CJ4B84kKVqC8fr62yoUQVBas1+rvoOeMDFvaZw==", "44e15e7f-6566-4954-811f-55a738d84a61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "811aa630-c3f5-4cb0-bf24-4d2c9abca4e3", "AQAAAAIAAYagAAAAEKEfppGSevBJXH/5wOXsZopbDvM1O8SgCNsujteCb3Vh+Rn4Sdg+rv1v3umYs8gjHA==", "88bdea41-a370-48b3-96b6-e16cce983b47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1587a1f0-7dda-4a7a-8d43-bef4f2d0b7a4", "AQAAAAIAAYagAAAAEDPA02jvBV5LhyE8XFl/isKsJuU1mOiL/JYV1aaIqMomjDjevxlPdu+a5Muyh0FUig==", "63725955-ed35-4fb6-8236-6fb057d854b6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cdbd0886-0ef9-403c-97cb-c14e0f634c2f", "AQAAAAIAAYagAAAAEDMI1ORbH7nv1BYU3JIOKpxUY/+HoZ6GgU6JFLZwM9CLzJjFt0XC3x+v9cQHuyIzVQ==", "e5fcecf0-65f7-4dec-8bfe-78d14259a029" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81454265-2758-4de7-bbb4-9658e63fb9f8", "AQAAAAIAAYagAAAAEPcp+TUQldFbXM+UPfLXhcFBm8coHk7u/k1whW/7242Lz/sofb9gszJXqg4NMwFD2w==", "4543ef5e-cb2c-428d-9a5d-540a4de86899" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "caf33af6-7422-4480-a363-bc74e407a53f", "AQAAAAIAAYagAAAAEBXd5tx6/lpcVmhJX5u99+gR52HV2onvn7A3aoYY47yzCNXlLgCi5hgMNnw33pOxLg==", "d7e1f767-d42b-453d-afe1-32fb639af9d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f80d76cb-1757-4109-a310-9254a4975639", "AQAAAAIAAYagAAAAENVE2+nSMCt2xOgjUNvY3LfUZ2w5xGEp6wJvBXbDyf8WJAZpnIxgl44zi2BgEFMflw==", "53de5ffd-9016-4122-b7bd-7ed55d1ddeae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "13e1cc11-8a5b-448a-a6b3-51c6d48837d3", "AQAAAAIAAYagAAAAEPZbxvT2Jhcp2ZFDanbLkzv0blmpd3VrVvu1OWkw+iaUNzTNagm9jdq0kbxMvbz8Yg==", "4fa8663b-2c60-4bee-856e-25a6418bb38b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3990433-3483-42a5-86f1-66a1d42502a1", "AQAAAAIAAYagAAAAEOq1tOVwWYiLW865FC0wNo01eV0ffzcbtWxjAjSUC2UHJDCtUk8+WDSXoiBFT6q5eA==", "abd144fe-c351-4fb4-97ae-99858cbc1c03" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee8e0b0c-60b7-44a8-966c-e83e73951a85", "AQAAAAIAAYagAAAAEBcx82IegrsnMQdrzQC7kkBEgit2w/nkSqGquA3FOaK8ktw4nnQHXbotAqQY2zhrGQ==", "5b0a3b9f-b4fc-47e2-a548-a78cd1ae70c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea8c31b5-e17d-404c-9e34-54fdd4977adf", "AQAAAAIAAYagAAAAEKFnJdy8TFufxx6rzHtHOZXclCS7uWOeSCE82y4qGRTvCzy52xTsMqiCwQo21f+waw==", "c9229f63-1d09-4839-848f-a68197018394" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "39ef560a-ea1d-4100-9ef8-04b282b0594e", "AQAAAAIAAYagAAAAEINa3Qg13wIQjqv41m9FYQATGezGC4VUZ8tfEc8muMUKedn1/bL0bpFesJMJzN27dw==", "9ee151d3-4ac2-453e-a26b-cd97f33ef3bb" });

            migrationBuilder.InsertData(
                table: "IQASignatoryTemplates",
                columns: new[] { "Id", "AuditEntityType", "DefaultSignatoryId", "IsActive", "IsDeleted", "OfficeId", "OrderLevel", "Position", "SignatoryLabel", "Status" },
                values: new object[,]
                {
                    { 1, "AuditProgramme", null, true, false, 1, 1, "Lead Auditor", "Lead Auditor", "Pending" },
                    { 2, "AuditProgramme", null, true, false, 1, 2, "QMR", "QMR (Quality Management Representative)", "Pending" },
                    { 3, "AuditPlan", null, true, false, 1, 1, "Lead Auditor", "Lead Auditor", "Pending" },
                    { 4, "AuditPlan", null, true, false, 1, 2, "QMR", "QMR (Quality Management Representative)", "Pending" },
                    { 5, "AuditSchedule", null, true, false, 1, 1, "Lead Auditor", "Lead Auditor", "Pending" },
                    { 6, "AuditSchedule", null, true, false, 1, 2, "Department Head", "Department Head", "Pending" },
                    { 7, "AuditSchedule", null, true, false, 1, 3, "QMR", "QMR (Quality Management Representative)", "Pending" }
                });

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

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchedules_AuditPlanEntryId",
                table: "AuditSchedules",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_AuditeeId",
                table: "AuditReports",
                column: "AuditeeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_AuditPlanEntryId",
                table: "AuditReports",
                column: "AuditPlanEntryId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_AuditScheduleId",
                table: "AuditReports",
                column: "AuditScheduleId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditComFindings_AreasId",
                table: "AuditComFindings",
                column: "AreasId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklist_AuditeeId",
                table: "AuditChecklist",
                column: "AuditeeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklist_AuditScheduleId",
                table: "AuditChecklist",
                column: "AuditScheduleId");

            migrationBuilder.CreateIndex(
                name: "IX_Auditees_UserId",
                table: "Auditees",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatories_AuditPlanId",
                table: "IQASignatories",
                column: "AuditPlanId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatories_AuditProgrammeId",
                table: "IQASignatories",
                column: "AuditProgrammeId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatories_AuditScheduleId",
                table: "IQASignatories",
                column: "AuditScheduleId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatories_IQASignatoryTemplateId",
                table: "IQASignatories",
                column: "IQASignatoryTemplateId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatories_SignatoryId",
                table: "IQASignatories",
                column: "SignatoryId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatoryTemplates_DefaultSignatoryId",
                table: "IQASignatoryTemplates",
                column: "DefaultSignatoryId");

            migrationBuilder.CreateIndex(
                name: "IX_IQASignatoryTemplates_OfficeId",
                table: "IQASignatoryTemplates",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_NcarCorrectionActions_NonconformingActionReportId",
                table: "NcarCorrectionActions",
                column: "NonconformingActionReportId");

            migrationBuilder.CreateIndex(
                name: "IX_NcarCorrectiveActions_NonconformingActionReportId",
                table: "NcarCorrectiveActions",
                column: "NonconformingActionReportId");

            migrationBuilder.CreateIndex(
                name: "IX_NcarMonitoringLogs_NonconformingActionReportId",
                table: "NcarMonitoringLogs",
                column: "NonconformingActionReportId");

            migrationBuilder.CreateIndex(
                name: "IX_NcarRootCauses_NonconformingActionReportId",
                table: "NcarRootCauses",
                column: "NonconformingActionReportId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_AcknowledgedByAuditeeUserId",
                table: "NonconformingActionReports",
                column: "AcknowledgedByAuditeeUserId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_ApprovedByHeadUserId",
                table: "NonconformingActionReports",
                column: "ApprovedByHeadUserId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_AuditReportId",
                table: "NonconformingActionReports",
                column: "AuditReportId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_IssuedByAuditorUserId",
                table: "NonconformingActionReports",
                column: "IssuedByAuditorUserId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_ProposedByAuditeeUserId",
                table: "NonconformingActionReports",
                column: "ProposedByAuditeeUserId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_ValidatedByLeadAuditorUserId",
                table: "NonconformingActionReports",
                column: "ValidatedByLeadAuditorUserId");

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_VerifiedByAuditorUserId",
                table: "NonconformingActionReports",
                column: "VerifiedByAuditorUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditChecklist_AuditSchedules_AuditScheduleId",
                table: "AuditChecklist",
                column: "AuditScheduleId",
                principalTable: "AuditSchedules",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditChecklist_Auditees_AuditeeId",
                table: "AuditChecklist",
                column: "AuditeeId",
                principalTable: "Auditees",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditComFindings_AuditPlanProcesses_AreasId",
                table: "AuditComFindings",
                column: "AreasId",
                principalTable: "AuditPlanProcesses",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditComFindings_AuditReports_AuditReportId",
                table: "AuditComFindings",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditReports_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditReports",
                column: "AuditPlanEntryId",
                principalTable: "AuditPlanEntries",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditReports_AuditSchedules_AuditScheduleId",
                table: "AuditReports",
                column: "AuditScheduleId",
                principalTable: "AuditSchedules",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditReports_Auditees_AuditeeId",
                table: "AuditReports",
                column: "AuditeeId",
                principalTable: "Auditees",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchedules_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditSchedules",
                column: "AuditPlanEntryId",
                principalTable: "AuditPlanEntries",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchedules_Teams_TeamId",
                table: "AuditSchedules",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScope_AuditReports_AuditReportId",
                table: "AuditScope",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSummaryFIndings_AuditNcarStatus_AuditNcarStatusId",
                table: "AuditSummaryFIndings",
                column: "AuditNcarStatusId",
                principalTable: "AuditNcarStatus",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSummaryFIndings_AuditReports_AuditReportId",
                table: "AuditSummaryFIndings",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditChecklist_AuditSchedules_AuditScheduleId",
                table: "AuditChecklist");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditChecklist_Auditees_AuditeeId",
                table: "AuditChecklist");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditComFindings_AuditPlanProcesses_AreasId",
                table: "AuditComFindings");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditComFindings_AuditReports_AuditReportId",
                table: "AuditComFindings");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditReports_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditReports");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditReports_AuditSchedules_AuditScheduleId",
                table: "AuditReports");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditReports_Auditees_AuditeeId",
                table: "AuditReports");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchedules_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditSchedules");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchedules_Teams_TeamId",
                table: "AuditSchedules");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScope_AuditReports_AuditReportId",
                table: "AuditScope");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSummaryFIndings_AuditNcarStatus_AuditNcarStatusId",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSummaryFIndings_AuditReports_AuditReportId",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropTable(
                name: "Auditees");

            migrationBuilder.DropTable(
                name: "IQASignatories");

            migrationBuilder.DropTable(
                name: "NcarCorrectionActions");

            migrationBuilder.DropTable(
                name: "NcarCorrectiveActions");

            migrationBuilder.DropTable(
                name: "NcarMonitoringLogs");

            migrationBuilder.DropTable(
                name: "NcarRootCauses");

            migrationBuilder.DropTable(
                name: "IQASignatoryTemplates");

            migrationBuilder.DropTable(
                name: "NonconformingActionReports");

            migrationBuilder.DropIndex(
                name: "IX_AuditSchedules_AuditPlanEntryId",
                table: "AuditSchedules");

            migrationBuilder.DropIndex(
                name: "IX_AuditReports_AuditeeId",
                table: "AuditReports");

            migrationBuilder.DropIndex(
                name: "IX_AuditReports_AuditPlanEntryId",
                table: "AuditReports");

            migrationBuilder.DropIndex(
                name: "IX_AuditReports_AuditScheduleId",
                table: "AuditReports");

            migrationBuilder.DropIndex(
                name: "IX_AuditComFindings_AreasId",
                table: "AuditComFindings");

            migrationBuilder.DropIndex(
                name: "IX_AuditChecklist_AuditeeId",
                table: "AuditChecklist");

            migrationBuilder.DropIndex(
                name: "IX_AuditChecklist_AuditScheduleId",
                table: "AuditChecklist");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e604ff");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e634ff");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e634hh");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e634ii");

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

            migrationBuilder.DropColumn(
                name: "TeamId",
                table: "AuditScope");

            migrationBuilder.DropColumn(
                name: "AuditPlanEntryId",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "AuditPlanEntryId",
                table: "AuditReports");

            migrationBuilder.DropColumn(
                name: "AuditScheduleId",
                table: "AuditReports");

            migrationBuilder.DropColumn(
                name: "AuditeeId",
                table: "AuditReports");

            migrationBuilder.DropColumn(
                name: "CreatedDate",
                table: "AuditProgramme");

            migrationBuilder.DropColumn(
                name: "LastModifiedDate",
                table: "AuditProgramme");

            migrationBuilder.DropColumn(
                name: "AreasId",
                table: "AuditComFindings");

            migrationBuilder.DropColumn(
                name: "AuditScheduleId",
                table: "AuditChecklist");

            migrationBuilder.DropColumn(
                name: "AuditeeId",
                table: "AuditChecklist");

            migrationBuilder.RenameColumn(
                name: "AuditNcarStatusId",
                table: "AuditSummaryFIndings",
                newName: "NcarStatusId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSummaryFIndings_AuditNcarStatusId",
                table: "AuditSummaryFIndings",
                newName: "IX_AuditSummaryFIndings_NcarStatusId");

            migrationBuilder.RenameColumn(
                name: "TeamId",
                table: "AuditSchedules",
                newName: "AuditorTeamsId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSchedules_TeamId",
                table: "AuditSchedules",
                newName: "IX_AuditSchedules_AuditorTeamsId");

            migrationBuilder.RenameColumn(
                name: "PlanName",
                table: "AuditPlans",
                newName: "PlanStatus");

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditSummaryFIndings",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditScope",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "AuditPlanStatusId",
                table: "AuditPlans",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "AuditReportId",
                table: "AuditComFindings",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "Area",
                table: "AuditComFindings",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateTable(
                name: "AuditPlanApprovals",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ApproverId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    AuditPlanId = table.Column<int>(type: "int", nullable: false),
                    Action = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Comments = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false)
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
                    table.ForeignKey(
                        name: "FK_AuditPlanApprovals_AuditPlans_AuditPlanId",
                        column: x => x.AuditPlanId,
                        principalTable: "AuditPlans",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanStatus",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanStatus", x => x.Id);
                });

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

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_AuditPlanStatusId",
                table: "AuditPlans",
                column: "AuditPlanStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanApprovals_ApproverId",
                table: "AuditPlanApprovals",
                column: "ApproverId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlanApprovals_AuditPlanId",
                table: "AuditPlanApprovals",
                column: "AuditPlanId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditComFindings_AuditReports_AuditReportId",
                table: "AuditComFindings",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId",
                table: "AuditPlans",
                column: "AuditPlanStatusId",
                principalTable: "AuditPlanStatus",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules",
                column: "AuditorTeamsId",
                principalTable: "AuditorTeams",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScope_AuditReports_AuditReportId",
                table: "AuditScope",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSummaryFIndings_AuditNcarStatus_NcarStatusId",
                table: "AuditSummaryFIndings",
                column: "NcarStatusId",
                principalTable: "AuditNcarStatus",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSummaryFIndings_AuditReports_AuditReportId",
                table: "AuditSummaryFIndings",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id");
        }
    }
}
