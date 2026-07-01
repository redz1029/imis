using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class IsoDomains : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropIndex(
                name: "IX_AuditScheduleDetails_OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "EndDate",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "StartDate",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "EndDateTime",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "StartDateTime",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "Name",
                table: "Auditors");

            migrationBuilder.RenameColumn(
                name: "TeamId",
                table: "AuditScheduleDetails",
                newName: "AuditPlanEntryId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_TeamId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_AuditPlanEntryId");

            migrationBuilder.AddColumn<int>(
                name: "ImprovementType",
                table: "Teams",
                type: "int",
                nullable: false,
                defaultValue: 0);

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

            migrationBuilder.AddColumn<int>(
                name: "AuditorTeamsId",
                table: "AuditSchedules",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Purpose",
                table: "AuditSchedules",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "ImprovementType",
                table: "AuditorTeams",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "AuditorTeamsId",
                table: "Auditors",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ImprovementTypeId",
                table: "Auditors",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "AuditableOffices",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AuditableOffices",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<byte[]>(
                name: "RowVersion",
                table: "AuditableOffices",
                type: "rowversion",
                rowVersion: true,
                nullable: true);

            migrationBuilder.CreateTable(
                name: "AuditChecklistQNA",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Question = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsoStandardId = table.Column<long>(type: "bigint", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditChecklistQNA", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditChecklistQNA_IsoStandards_IsoStandardId",
                        column: x => x.IsoStandardId,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditNcarStatus",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ncarStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditNcarStatus", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AuditPlanStatus",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlanStatus", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AuditProgramme",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Year = table.Column<int>(type: "int", nullable: false),
                    For = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    From = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Purpose = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ScopeAndFreqAudit = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    InternalAuditSched = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditPlanObjective = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ScopeOfAudit = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditProgramme", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ImprovementType",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ImprovementType", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AuditChecklist",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditScope = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    conforming = table.Column<int>(type: "int", nullable: false),
                    FindingAndRemarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ItemsAndQuestions = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Auditees = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    QnAId = table.Column<int>(type: "int", nullable: true),
                    AuditChecklistQNAId = table.Column<int>(type: "int", nullable: true),
                    AuditorId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditChecklist", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditChecklist_AuditChecklistQNA_AuditChecklistQNAId",
                        column: x => x.AuditChecklistQNAId,
                        principalTable: "AuditChecklistQNA",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditChecklist_AuditChecklistQNA_QnAId",
                        column: x => x.QnAId,
                        principalTable: "AuditChecklistQNA",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditChecklist_Auditors_AuditorId",
                        column: x => x.AuditorId,
                        principalTable: "Auditors",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditProgrammeObjective",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SortOrder = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditProgrammeId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditProgrammeObjective", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditProgrammeObjective_AuditProgramme_AuditProgrammeId",
                        column: x => x.AuditProgrammeId,
                        principalTable: "AuditProgramme",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditComFindings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CommendableFindings = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Area = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditReportId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditComFindings", x => x.Id);
                });

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
                    AuditPlanStatusId = table.Column<int>(type: "int", nullable: true),
                    AuditProgrammeId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditPlans", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditPlans_AuditPlanStatus_AuditPlanStatusId",
                        column: x => x.AuditPlanStatusId,
                        principalTable: "AuditPlanStatus",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditPlans_AuditProgramme_AuditProgrammeId",
                        column: x => x.AuditProgrammeId,
                        principalTable: "AuditProgramme",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditPlans_IsoAuditors_PreparerId",
                        column: x => x.PreparerId,
                        principalTable: "IsoAuditors",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditReports",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditPurpose = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditConclisions = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OfficeAuditedId = table.Column<int>(type: "int", nullable: true),
                    AuditStandardISOId = table.Column<long>(type: "bigint", nullable: true),
                    DateofAuditId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditReports", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditReports_AuditPlanProcesses_OfficeAuditedId",
                        column: x => x.OfficeAuditedId,
                        principalTable: "AuditPlanProcesses",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditReports_AuditPlans_DateofAuditId",
                        column: x => x.DateofAuditId,
                        principalTable: "AuditPlans",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditReports_IsoStandards_AuditStandardISOId",
                        column: x => x.AuditStandardISOId,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditScope",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditProcessAuditedId = table.Column<int>(type: "int", nullable: true),
                    AuditorTeamsId = table.Column<int>(type: "int", nullable: true),
                    Auditee = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AuditReportId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditScope", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditScope_AuditPlanProcesses_AuditProcessAuditedId",
                        column: x => x.AuditProcessAuditedId,
                        principalTable: "AuditPlanProcesses",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditScope_AuditReports_AuditReportId",
                        column: x => x.AuditReportId,
                        principalTable: "AuditReports",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditScope_AuditorTeams_AuditorTeamsId",
                        column: x => x.AuditorTeamsId,
                        principalTable: "AuditorTeams",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "AuditSummaryFIndings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    No = table.Column<int>(type: "int", nullable: false),
                    CriteriaId = table.Column<long>(type: "bigint", nullable: true),
                    Findings = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NcarStatusId = table.Column<int>(type: "int", nullable: true),
                    AuditReportId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditSummaryFIndings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditSummaryFIndings_AuditNcarStatus_NcarStatusId",
                        column: x => x.NcarStatusId,
                        principalTable: "AuditNcarStatus",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditSummaryFIndings_AuditReports_AuditReportId",
                        column: x => x.AuditReportId,
                        principalTable: "AuditReports",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditSummaryFIndings_IsoStandards_CriteriaId",
                        column: x => x.CriteriaId,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "2e78e261-2554-43cf-b9f1-47db650413e3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "7edcc5e9-cff5-476b-8fc2-594bca80be20");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "985492ae-ec1d-43fa-8fde-16051c3849c9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "19d7c73b-12a2-45f9-b935-18f1d0400d01");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "2a173c5a-ed9f-4025-a0fe-fb721c6b4954");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "da2428f3-3417-49cd-850f-5c62cefa400f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "f7f4bcdf-b281-476f-ba43-7858113c9c42");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "93c4a4b3-cfb5-490d-80b3-70a2ce22969f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "83d24c39-2f0f-4f6a-a6d7-20aa93ff4e92");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "c820cd14-6de5-4efd-885f-116f7fadd239");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "8eec8eea-5374-47a9-8438-08754d319ee6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "ea45abba-38fe-449b-b02d-802899965e72");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "4baf9e35-3089-412b-b149-b7d15a0f2242");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "fc7929be-b649-4dab-82ef-f1b257ffa494");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b29fc58b-d1dd-48b3-bcec-5ec5690150b2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "49aaa29e-5288-47e9-9e1d-8485ff694119");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "2f5a180b-4554-4888-a128-5299b121a870");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "78753723-c73f-41e1-b352-9aab83b9d602");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "270de92f-192a-4930-ac86-8f955b2ee6b6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "ae124187-e9c4-4e68-b237-5bf50747bb64");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9fd7eea6-c303-4194-9586-ef40d9657238", "AQAAAAIAAYagAAAAEKU90RU2Lh5tc1i0EMO66feCmGPK5+/A4XDthlo0WEh1Msex+et2IR9+PW4cXEHuFw==", "ae25af4b-cb42-48e3-81e4-a19ec5d86505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a665ed2-8e91-4d75-bc8c-6ea6e1934868", "AQAAAAIAAYagAAAAEE+5+MD/cPQBZ0X8Uf11FhxrIAizimHUB41iosxxDHatbaqGkhPz46CWSHpsM7+UgA==", "7c3bb347-068b-4180-84e1-fb26e6bf77d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "16681ea7-ccb3-4f5f-9e57-d1cbaa4b2a2d", "AQAAAAIAAYagAAAAEFjO8s12bGMpI6dKyalpkVBmtjHvtWM+jXi+BQ7FSV7uBNi1aSwm/PncrSWuZcJWDQ==", "20ec41ca-f10a-4247-8a4e-70b6a9d22920" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f070f9b1-21d7-47ce-b067-f315fec79946", "AQAAAAIAAYagAAAAECJP3rjLtSgYwcUU0IC6mL5fV6Ef3H/2YEC0RrNRFKvxWOmFPb9SXHYZUqs59UDHqw==", "c4e2bc0a-44d6-4fbd-a8fe-2c5f8a804c11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c9387ce-4a9c-45d0-b96f-9f3d47182789", "AQAAAAIAAYagAAAAEMu5+FK38Rqe9I0jVMZ205Do9zas7j9WCFIi6ZTjJ71BLG+5GkReApp0D3NRfvJoFw==", "902c1bf7-034a-4353-80fe-5d89b32964c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "42fb60b6-f75a-4c35-89e7-d0d796a8a303", "AQAAAAIAAYagAAAAEJRox8ESLleAHkRkfGh1e3daJYdZiw2yk/8KbkKY63qXGeeMDgauSo33dPtHlLhocw==", "375c7b2f-7d1f-44c2-a3a2-81e62e653d73" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "717be181-3e49-4289-8304-3f383aa56e58", "AQAAAAIAAYagAAAAEHC8Q+t6YDTOUp+nqGQ/Hh1ia6fVbIeh3AaVqWDS44WhnIojEmZ8C6wcPjeTYHIy8g==", "d75dda19-4022-440d-998a-4cf3435eb28a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "031a26a0-eee2-464e-a134-44ec64871eb8", "AQAAAAIAAYagAAAAEHrwqNu3732SI2b4hTczjXOAaRlXk9RUC7IcXOCHkofEtnCUip46lMb5sJU7fkhiUg==", "f2644fae-cddd-4c0e-8d66-5052fe632bb2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "969dec9c-89ca-4f37-bdfb-4898ecba563b", "AQAAAAIAAYagAAAAEJAM41BFZDtFqLakG6gLVi05t8O65lIn3RCllK/NPrM3J0/ltuq5sbfdpg7HFi2INw==", "34950d20-672b-475d-bb26-90838204f674" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e9b05f0-b376-45e1-8b23-e0b243335b61", "AQAAAAIAAYagAAAAEFUXYanPhAJVooA6vKx+F9wFcSKExsaTe2Rs5qO+X7UHVYk5Aw0YiLpU6v/p9ZJkvA==", "997b486e-a019-46ef-8aa1-bcddfdabcc2e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73f1df96-d4a1-4cd2-a81e-2ca776682230", "AQAAAAIAAYagAAAAEKjUGyTZ76zg8n/sPTiogLDe5f/6sdFuJm3WUIkA0rcLS1BgvPccBsMxYBNlCLOOkw==", "308010fe-6e87-491e-8c80-24fc887f1300" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6eeb4116-c94b-4edf-85be-ce916afe1ba0", "AQAAAAIAAYagAAAAEKWVtSLXEipKX9QychbE3qiT91ShjX2BtThmxr3kAUtgXACG/X8zi062lHherZV2yw==", "bccd7ad9-dec1-497f-8e21-af75adb0dfc0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5a3418c6-21cc-4e74-bb8e-fd7f4b8ce489", "AQAAAAIAAYagAAAAEN2iMkKhRqUnLaQZrIjr4v3KS7PZMpWZ9479ITbFYdZ7c3pMRBXklTUULUsKTRZ8zQ==", "06224081-111c-469b-a9e2-372e2cc57347" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b1625f3-19f7-464a-aa44-ec8d9629e01d", "AQAAAAIAAYagAAAAEFaOuIrQe3/aHKw+aJDW/WjCgzvtBB4Z0wpkxKDPH7gQT4c3yqbwDb3iIRZanClPkA==", "a38d419e-9327-4eac-8075-c11ad26196d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d6fc4e8-5206-45c8-929b-06bf583b801f", "AQAAAAIAAYagAAAAEKorVq4ymQaFWsK6qH/8V56wwJ4kQCvXkhZWtpfdDjddDWzOxltMcUUChup5qAw03A==", "f2f3abee-266f-4026-b90c-e32bccbdef1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b779f19-87ec-4057-9f05-4f1498bb44fd", "AQAAAAIAAYagAAAAEGSsV/NqTyVBxGN+lXrxZ+RdKIynyAYgZrOby8YoAEwOXUD6mRwuEtIAmAgt3ew0sg==", "d0807079-f39a-43ab-bd51-d6224c9c644f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ef35b22-4d65-4609-b4bd-4fe1acefd46a", "AQAAAAIAAYagAAAAEGJLoSQQkThvbVFU2DKkn3je+sgk0VNTYIWXKSxvB2r+ltcyc+sv3wwYqs1D2MrcLQ==", "97e4b022-8e81-4676-9b7b-604003eb33b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ea81be4-a973-45f3-9a52-a1f66a528610", "AQAAAAIAAYagAAAAEMEJ1KsNTUYyV9xNQeaaqcF1ENOL7KWq1cJmWxrKDEJCZY0qwIy2aSAqy1VQrIMgqw==", "d603026b-8a17-402f-8026-c0e9db27f56f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2c060fb-517c-4ad7-9a8c-b89f1a961b0e", "AQAAAAIAAYagAAAAEKj6aKqU3lAqmZce/Sh3BC4BRtjzWDH3hYa4taJ1J6mR8MeQE5izS8Rdb1OBWEmb2A==", "b9920daa-7258-4061-b910-41516e984ee3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "541c04e6-9e85-4cfb-91b2-cf1922e6d9a8", "AQAAAAIAAYagAAAAEOujBEeIDc9vcWAVa+7JjHJC3P2zP5pgLqfqWn+KaKYnSZfcgzMW6UTMSvJ1/VqwhA==", "779c8472-891e-4ba1-a272-292fba4e8352" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ccf06beb-c4af-4c57-8e0e-dba2348f94ab", "AQAAAAIAAYagAAAAEOQ9LqLJ4Tmt/SWFrg3SaHCtR0BgMtK51kJpowtTYSiKo81I/nqZ0mhY3AnQMJPQsA==", "24b6b098-d249-4c5f-a72d-098a89ac6129" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "800a5f2f-97fb-4e8f-a407-2cbc9df62f83", "AQAAAAIAAYagAAAAEFpd5v7cKJ9TELkDQWYaWppna7fCA7mMoDT23W3hVCwbRovFXAbNcOYc6RDmSLdqmQ==", "bd9c845d-2827-4e18-b048-eaf276071362" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3365e209-2d17-4816-bfaf-c9835d1b36b9", "AQAAAAIAAYagAAAAEPidI4/ZFDVEL50yFQd32nahlaPxb0uF3/tdaIu1joBj9Wr3gm+CTJaQk5hr6+G1pg==", "d3c7db21-66d5-4473-bdbe-bfb32f9f0c77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6bd654a6-a515-4fae-8f42-25df08e56799", "AQAAAAIAAYagAAAAEKDecZwjUKnD/XhG6gy4kAFZviUcoPTXeToFRDYmW+xxzURWsiasE32tn5vOZG2/Lw==", "8dbf0b87-655d-42a9-90b7-5a756d7e78a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "131150d3-88d4-45b3-b85a-97c8b3186397", "AQAAAAIAAYagAAAAEEsv7DupLq1ibHNjOqPJ+hH7LFS5TyGMYVXwO2TteizkZfvo4ipx6iYHHEcJOO3vhg==", "d7798573-c9d8-4e78-9cf9-54104e9abcad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00557cff-445f-404e-ad20-647eed46ad5f", "AQAAAAIAAYagAAAAEKnNNcYbUuNrh05P6si3G65xy9IQiPcwYzg2uU5jzYyhOr/R8O6P1rU4tSJdk2t9pQ==", "b1cc917a-63a2-4007-8ec2-395bd2fd1af7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c23c3c6-7e0d-440d-99ee-07b1897a1b17", "AQAAAAIAAYagAAAAEKJnJf4dI9QyNsfQDwDs4fCcX8abKtUa/lpYA8XLTN+q+bIUuiGdz1QnEesW9p/2bQ==", "32065b99-961c-43cb-a1fc-a1a52a1f9ba1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56db568f-02b3-4fcb-9c0d-a600daaa57c1", "AQAAAAIAAYagAAAAEExBQxZo6Vb48/LKNxVixvTcJC6YhjadJ/Qj6FEMs7+ZSQE/Y+o1WRHs/K9IweyDSA==", "a58cec51-94e9-43b9-a47c-1bd58159d18e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9d8a7f06-e277-47fd-877d-b925f640f5e9", "AQAAAAIAAYagAAAAEDiVSEzUTDQ2bHRVDZedPcT/fu3j2dhyp9cHHGnj473Sl4/eeDQ+b87G9twu5P09NQ==", "7b8cc5b3-8804-41f9-8e62-add800efb7e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9f291d4-f5fa-4187-b2c0-2788445218e3", "AQAAAAIAAYagAAAAEGoKPYMPulwxWk7G7nOsP70DCi1fl7WsCIhRG4Uuey/66vxEiUlFzNVbLRk0rDt+gA==", "15a00afc-7f3d-4280-977f-f4a20891e800" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11e2e416-8e1a-418f-bed4-77871778a468", "AQAAAAIAAYagAAAAEHTsaFC+qldhzqOF7EACIMAx9inVbCC+FWpiJk87FQqv08Pics7wk+/VryxVm06j9w==", "1b002d74-a70c-48c6-a2a3-1d55e1825d34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84e77a6e-9557-41da-9fc5-0e3260f4a6a3", "AQAAAAIAAYagAAAAEFoBAeJACypnYI9P63PMZwwqF414d2CAbtwHRx3QmTz02NkkUqQQwLXi2AMp3qRSZQ==", "1770dc20-7b91-4d97-a9c1-a37fa5935148" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2dabe56e-38bb-4275-8750-a31f1d25c16e", "AQAAAAIAAYagAAAAEGReHx0Okx8jUqqzcrD9y5iVmPVVYwVyiPb0Kxfrwx93KS3roK1kcaXMCOaZ4fef8w==", "a51c7592-fa1e-4828-ba28-8b1479a52eb6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c800ca13-9c2d-43b5-9cad-de7aeda65201", "AQAAAAIAAYagAAAAEJKwgTwbqRNUn+UpVaL7claM3kDDMgvssg/RuCpbcKvgPXCApvP+XskjMs1oqJ7dXg==", "6a31247c-5015-4990-aef3-eaecf7fe156b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f4d343e-100b-4e88-8931-e0264640900e", "AQAAAAIAAYagAAAAENamRF1pEyEXEsNB/Z81XJ5ni9M7PgxObu3JqdQ7nLq/ZbvLCoFlm5bShbvl7KnLmQ==", "f80e89b4-3640-4494-9c5a-3a42598ae56d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a65dd248-bd3f-405a-8c93-2b959ec2dee7", "AQAAAAIAAYagAAAAEABq53Fxtn81Tzvsz0jf9zXv9JB9wJQg+k0gpIcqtzXhQ0OJA5TeNMLq4BQ0ca0RUg==", "7ed4bbe6-ac52-4110-ad37-27edbc0418c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf166225-5557-4072-a0eb-5191a659f716", "AQAAAAIAAYagAAAAEBG8//HY887M5cepoXqsvHnmkywSQ/dRZUnADYx53vN6+Ke3Rlg9nvcLWz42zQeutg==", "3cd95fed-58aa-4283-ae1a-5a5be36bbca5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c44e0ee2-6e73-4870-9737-4c21fd68dafd", "AQAAAAIAAYagAAAAEB0TJ3i1NjWHTbK+ckGj2Ev59Okhxh1MqyJLQLfFaveHZJyCK0jhe1UqzgHVQ8E9pw==", "cfc8ede9-9abe-406c-95c8-e0e4875546c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c32052d5-6894-4776-9ad6-d87e5f7eaa9c", "AQAAAAIAAYagAAAAEH8ltbL+dkzR2iZjUkz0yGyeLLl9pRdW236LCTgaG0oIFAqy29QCO5ixkOMR51zByw==", "31a8b03a-4a9e-4085-ba8d-9c0e4ec70b54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f3052f6-7a93-4b78-8b87-9370ff85c92a", "AQAAAAIAAYagAAAAEHjzkpm2cx1l9AwYNOeXTT9RbZ5UJ6fUEvwP+ipKt46foVW+HnJk3v11qbVvZ3j+gg==", "66e275a2-0161-4ae3-9cd6-2f7f2584c4c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b616c968-496d-4a16-a4a9-1f90f7fe0cea", "AQAAAAIAAYagAAAAEPtQ01mDoYzSWej1iptD08Eew49DFbE3azcw7/k0EOZJrzhsareLXoBnQly95wKajg==", "830b2345-3353-4edb-917b-e7a0f7a986da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "278d7101-7dee-4848-a519-ad256cceba71", "AQAAAAIAAYagAAAAEBCjfl5MQ6dKOlcdN9jeC9sFYua0ezcT/hPQQVS8HiKLzFmHTNX0jedqMwA5zcv9og==", "a9652c4d-e0ce-4f7e-87d2-a36ccf4a7d45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b26766ba-7975-4b6c-b6da-da02fa1dc4e5", "AQAAAAIAAYagAAAAEO4aoLlsn8YkLW6cR4KHA8rU5riUZxqYKrxSpjLWFw0QjJ6HSRHhrDjfmzOW6Ulcwg==", "9ab7c8ea-0ed1-4dca-b637-26c55df7f1b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71ea48f2-fce5-409a-9c05-f0cf8f92c017", "AQAAAAIAAYagAAAAEMj2IyTOVVBw/Y2XuI+N8/NG+Hs20JvDKjbfgEL5fW4/S2r7aAIAY81pn1mO2b6PIw==", "20922ff3-3cb5-42be-97b0-c40c8c7addec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22e7f8da-e659-46b3-afa2-cba8fb291cda", "AQAAAAIAAYagAAAAEICjTVZ38GoMZXQin4Np8mreNrDBsGcqNqiFGB6UTjJ56DKsWmyTT66hm+yJ8ecy6A==", "f72382f5-49f8-4039-91d3-908b9ab1b1b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cf53326-d1b5-40c5-949a-045449dd1842", "AQAAAAIAAYagAAAAEHc92q2+f3AXhfgoYoRvx/ruYMmw+XAdcCsykA6zDQbCKu+J5CdWpgxQQHwNfp2WMA==", "029c3fe7-ddfc-4622-b0f5-1d1b7b871735" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "daceb95d-8ead-4ea8-b0d5-81e683e8b308", "AQAAAAIAAYagAAAAEExWrhW4Fr1DLPA6jYoF48N9uGjPQcYKrZlm9pK05ZNfi/fv0Cf1hQlIM1l6MCX9UA==", "64240ebb-7907-45f3-a759-897d53e76fe4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71d5db37-09a2-4c49-8fb5-2310aaf895e3", "AQAAAAIAAYagAAAAEJqYgOb+04hu2E31aORp6D+8j1yEVJMtD8EI5tOoacyZ2G6yOQ1fqc1UwMW4TFXrmg==", "45ea8a00-641a-43a2-b479-67d40aa18873" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14d58b4c-e61d-4f9e-87e0-a678c385552a", "AQAAAAIAAYagAAAAEOHIeAhQCaT2TESXW28XaCc38LWMZSST/g2N5tF4yKvttfODNPXr1g/Jb5yYGe6KKg==", "6537a6fd-88b5-4913-b37c-afaa71cebecf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2a9f1e8-c19d-45ad-817f-fbd65ac8508e", "AQAAAAIAAYagAAAAEGzq7yl+0RvcWsXnmKiJiKvwRDX6OLWJiqVOfvJ7AxYwVA2N0PGmEuFHvwjhbm4Jrw==", "582ef763-324d-45de-9c02-864eb991697c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21eb9cbf-dbc9-4841-8efb-668381e9cb03", "AQAAAAIAAYagAAAAELerzauWb8Y5pNe1ms1eN8oOERxZStkHwkf6VgXU2CHyYmQa/EXLU3bEU0RLKTqisg==", "f5d77b7e-c3ba-4603-a7cc-9ea32f89a1cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f527506e-7002-417d-be97-907f2c7db451", "AQAAAAIAAYagAAAAEPiJreculW7Mww4AXmLW0+DPVWPQzvFv98utBggdKBSM91jficEho+MHB/5dCt9Mfg==", "8e9ba467-36ca-4733-aa61-2d9aa8c6849e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21a344db-3e8d-4e4f-889c-a084e6d0604e", "AQAAAAIAAYagAAAAEFX3wFDWG8JPuVBoJ3m1gAmlJj5aTzm2F+x01bQScvdmKFiYNdTSD0crHXe04AShnw==", "394ccd64-c486-4cc9-ac4d-7500b13e3d16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "839c83ca-7437-4979-b55d-f13a1dec9580", "AQAAAAIAAYagAAAAEC5fCR+k72CeByuuJ7F2YIMARlhbbFevLMuJRYfSQp2LJFjm4tF+OeA54xTGBVq/eA==", "0391dd09-4c71-4f0b-a071-ef4d656134c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6b465f9-915f-47f2-8dd0-b408bb43bdb1", "AQAAAAIAAYagAAAAEA/WYNQCrn7Ho3SqqPp3NTIQIMcjkoWj8qYnbV+L/ozxDrcv+dMGWEZPdYUj7lPoJA==", "4df4eb3b-a6e5-4b43-add8-136497053133" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77bb2a4b-cad6-4b64-99fb-0a0b341e6ebd", "AQAAAAIAAYagAAAAEKGaCku7c4Qpj4EtH4eVLeBSHhklNuZr/Q6oNW3zPb7XuRQszCll9i1NQLfdtreuHw==", "9392c3c9-4563-4013-9406-d8e5e8642e19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19b257f3-0a32-45e9-a274-ea033dcd6c13", "AQAAAAIAAYagAAAAEHrBDh30AOTNcL1o3g1Aetkyi8T94sgR8YcLs65QP1Xu+ZQnpX+gT95Gjdh2Q/SYIw==", "ee3e7553-302f-461b-b095-1b990f4cd362" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9fddbed3-0470-4674-8db4-a2ec5a223421", "AQAAAAIAAYagAAAAEFmzkE8/ARqZYGT8lRFb/QyEG0C+xnZlNe8OQ/lKUyvnaEdZBWhIjyEIAoqAEy9iUQ==", "05b92973-161a-4c44-8434-a0fa21fbd1c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bab573fe-55ae-43f5-978a-124f66c809b2", "AQAAAAIAAYagAAAAEOKb96r/HOUIAHROYi6w0DBluQArdz9eSX9+0FsQOInfsHTcx4U33JsVao0ozT7PBA==", "e0ccd17a-fb12-40b7-a9d1-4ed43f6785e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f30dc90c-2ebd-46c1-a9b1-378f899cf10d", "AQAAAAIAAYagAAAAELvEwp1aRolv3lOi09tmbC/+6Tw50sV8J4qb9njrW2TYbCfW5Y7oIf3Ork3Bn7gulw==", "6c9db3b3-75f1-4303-af23-ca8c448d5a0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "759801f1-d280-48ca-ba54-07e7de546b70", "AQAAAAIAAYagAAAAEBQ4zlmvyFhJTU72HvHU7f6/WapTYvI+ZhUtH1QDQWsA4ZCYLXe5XW7iCQ3aq66vng==", "7bd8a2e9-9976-46e6-a677-5c9a75c8b954" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "748a9dfd-be8d-4371-8c4c-b056867a3c81", "AQAAAAIAAYagAAAAEMKOS+PbwywrpXvng/bVYLhE4ydCqKBEv8W7WtlzKOATDluMzKe6AwiqJML02n+Q+A==", "de25769c-ec54-4593-8ccf-25a4afa732ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df9f977f-0196-4bd5-be41-4796a693efcb", "AQAAAAIAAYagAAAAEBdD5bK4kLoUMG7y1Tnwqtnq9VoA3x2A4OphfbQcCNM438rw6UVksEwjJF6bSFiANA==", "20cbcc16-5508-48e2-9b4b-7ad6c98ab291" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "daea418f-d29a-418d-9020-299947c8f8ba", "AQAAAAIAAYagAAAAEMiz8IbwLkgpPFRWenoIROy2fVfVzSNykBGfQdvFn7yKYa4ACvlccdjsxUGTfoPuiA==", "8f15d6c3-1837-4776-8e73-317ce1e96c13" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5947b19-3057-40f0-b198-1b0ba4c6ce69", "AQAAAAIAAYagAAAAEFwtrXtuRI0qY2DW+UxKcQQD0uBvOCBN0eF54ey5rQWITR905T0fcf1v2sWAHDElbA==", "2b67b254-dbe8-4898-85f7-69af8a4f7c2e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b996b589-80cd-438e-b261-4328befdad47", "AQAAAAIAAYagAAAAEMSxDDVQTTNHDHmw4V1cuOPDmlUuI8ADK3+KyfYQ/6XcKo4pKLYSjdrGqfBW0JAT0Q==", "dff02ed6-35bf-4df3-967f-cdd913dd5e66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d3143069-88e5-4181-993b-428708da62d3", "AQAAAAIAAYagAAAAEE9kxq21qFHjdd5NwlpE39+CNu5rMRH2lWkcpcPWb19uCAoFpIDi55OwAEZ9g+6AZw==", "1f7b608f-6d49-4960-af5c-7f52970869bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e91876d2-57b6-4928-ba9d-13be1cf51a5a", "AQAAAAIAAYagAAAAENXEmHJkHuYbaO1YyMZE+1KmFQgTEhis7CKv6EO7FwiyskZAjPSCaOGTmXCXVwS60g==", "f3c7810b-6cb3-4d6e-8ab4-7d69d52eb335" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91f54aba-b8d9-4397-8243-a2f6bd2ef065", "AQAAAAIAAYagAAAAEItmAEtCXKNYBCFE/YxIrW8MX0o7hl2Y/cca1tPsvdiFI4J3vuBMMDS4o7hcCjqa6Q==", "cb1d2592-2a52-4fe8-86f4-840ecc61a3d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0df49c63-8258-4ca0-ab03-d8b8705d26fb", "AQAAAAIAAYagAAAAECPialLM9OewnSdB2hi1GL0L3lsWKy4KMxddKZC7gtEfIZBSTIQJZbZuDWrsFY6OoQ==", "456a8bbd-6af1-4eb4-8d0f-d74be4f72710" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76fd4f8d-c49a-4487-ad60-6fe6a83fd321", "AQAAAAIAAYagAAAAEEBLNYTobkpqqV4KoSt4UF033wid8fzsDAtaWmciAu5uwCPbVYvMkribzwq5N/9kBg==", "3764c354-a3e5-415b-89d0-79785af8ea8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ef129e0-8dac-4a84-90b9-d7d241dae529", "AQAAAAIAAYagAAAAECzLtuxsPdtWbQpwYAuY9lpPNiOr3NilNAfoYPL1EA65vptOU1c3yiNol3wk5uOW5g==", "6721a413-ece6-4ec0-b7b0-7bf82e5c23ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "051aafe8-a8a0-4cf5-ab89-5f091a916217", "AQAAAAIAAYagAAAAEIFUQA0es4J4S0y+lW3/eifqcnTLVxvwEET/Yw3NFp8DBDaNqIAthW020HL31pmYAA==", "da1f6612-ad1a-4e58-8309-c0edcda4110f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "518e65c9-5206-43d5-8782-ecadf2711a0a", "AQAAAAIAAYagAAAAELa95gXTPS5CCDDUwLZPLrZPSCSm4JTkTR65eu7T2tKyzN8qm2hLMuGPodH+6XwCDQ==", "792c7853-1bf5-442d-91c1-27051abf43ff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d0f88b3-ee49-4c02-943c-126bd8f09458", "AQAAAAIAAYagAAAAEDKBYQsmhfwz0orXJsRu/ZcQybawzmXoRebPTmMLlUyUiZ/+ML1yUN0xiUUVZIqCLw==", "b267bd72-c55c-4b14-bf20-6a2e290e19e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0597386-3be6-4c48-be94-25aa006de8c3", "AQAAAAIAAYagAAAAEDRyG1Ve647qRcumZW+KlwIioNrv30asNYKlKH6iFHGBSAsv+nqVg/+rkMvI1cTgNQ==", "4b386c2b-9eef-4032-a57e-b1aaba73879d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b12bf1da-0559-4a34-9362-775305c106d2", "AQAAAAIAAYagAAAAECtNdV8rg8/Uh1yOB0XpqJz3v/a3IjwWcI+uahL3H3oK6KALnHJhlFwWt0HGkR+CjQ==", "ccb9292d-422d-4752-9b0e-e52295309074" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "142ea428-8c17-4367-996f-1e387ca5ea15", "AQAAAAIAAYagAAAAEHd/HKATTGTMxYobr83Sy809ud5szUYbx6vX3v9O0YCZnMm5/NMUufYgl/L+3lNHSg==", "b122b5e1-e1eb-4d20-a61f-9fc78e232de3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a814e30c-663c-45a7-aa82-b16769a17875", "AQAAAAIAAYagAAAAELslWN/5Np0QNhPJhCZ4SaBeidm+/neSRtPLUJVM9/UIV2L4oAH5MHcULN2+f53nyw==", "e1691b62-c46f-4769-87f1-82091b67ed39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e8af507-6a03-40bc-b0ea-b116d60d5c6d", "AQAAAAIAAYagAAAAEBRZJfb7XyRklQf1k94bG65trU+xJ9ydHxAp7bqufyC5EVe/xRBH6PBhU5Jul3l3aA==", "4f4e95a5-57a7-40c8-8ebd-c52e79935402" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6f51515-634b-4883-8b31-48ad3a81a986", "AQAAAAIAAYagAAAAEA4deRZHAbfsoiWV6SoSILUjsbUS9UFh8i7TdLwoeNlVqTZ23qqIfomwujLb1vRPLw==", "ee67baba-6e20-469f-802a-20165960bca9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c88d9a82-b5c8-4eb9-8fde-59ad109761b9", "AQAAAAIAAYagAAAAEOAe9A8RYQgTiR3xgndxrBIkpLU1ApHnYrK1IadgKNSfGGlOXWudKgjSfEuO/fczRA==", "186643fe-a1cc-432d-bd30-1b5c731f1417" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "139441fb-e864-4994-b7c4-0df54fd493e9", "AQAAAAIAAYagAAAAEEpEirPbWClIUKC3eZ3nmcq2XvwZuT4zl4AgdjQ+xsoWh90/g1UG92LiDMnIynSOyg==", "3dc09534-b523-4d33-9e7a-a85c0212776b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad38684c-f2cf-4306-9979-f87a4f897efa", "AQAAAAIAAYagAAAAEP/BRT6B9gzFaCC6mNPBNrQ/GR/XT6rJRnR+0UKrUdMJDtPJyNorGzYgTmTacjrJ5g==", "1e0519b2-3d5d-46a8-a540-eeedb6619c23" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d24021e7-97f9-4446-ac18-e2baf20e4993", "AQAAAAIAAYagAAAAEDux3WHorqiMJtgsQbsM1iuhKhSFDCNBinmhLdxMBbHbLn97Mp+SPuZ9rOuwG3QUPA==", "a5289250-be6d-4c8b-aeae-b834efa5ff21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46e7c197-a750-4d5d-bd00-e579a5a62195", "AQAAAAIAAYagAAAAEOOWB4VALjWc3qfkZ+IHyLmurjMRFAfk3ewIlQ0Yh1h6Jj/4BPu9E4z5vk7iXcMUHg==", "525050c7-008f-4d26-8c63-d790d2b4dc1c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd0c9acd-e8b7-47d1-ad03-60bd55cb0bc9", "AQAAAAIAAYagAAAAEIqkoqsU8KY4t2JameO+PS/Qvvg7ujSSuxTEjgy6IUzWNIE+dRVcYMCG3ZIXAIafZg==", "1931be09-19c7-4b1e-a21f-02e7034d49de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5505a1c-d403-4cb2-a842-027ec2b40118", "AQAAAAIAAYagAAAAEFA1S3wO0/Na39EPuve85Z4uP1VoyxJEKTQaNvoW13QP4/T8rVAuyLPCRPtDAnPS9A==", "274060b1-b085-4063-a3de-197f2033004c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2918463-ba48-4c0c-a023-cb57ddc748eb", "AQAAAAIAAYagAAAAEEYwAK9/SjwCeaWSPwmEFH3u5Ns8AWrTQsMXpaN3LFkhYjdbNL7v3WkCZTF64llWnw==", "f2fa852a-ea1a-4db4-b08e-dff92afc1765" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4db2bcb7-b67d-44f8-98c1-db350506aba6", "AQAAAAIAAYagAAAAEKn5Vb210j/paKX2duo5VldTBwy0RL8y31XMLjfjak3h5azNSp4xNugjCr2So90f8g==", "45eb30ca-6577-436a-9140-54473ed076dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51de2803-339c-4e98-8579-8e1f5623ffb1", "AQAAAAIAAYagAAAAEL2OsjHPNO/WwzNDBJo2rVAcxjbUWtH9XLj0NhFn75MVbM8MP/UBvzU/98vJpEUVsw==", "1b12674c-2339-4f05-870e-efa7e73fa878" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff18be30-7f90-491f-94ac-55f15cee3560", "AQAAAAIAAYagAAAAEBt+uf0/CJZeZ1GSGi9TjJhnmuf5rvuTyU3BJUrvkcBM5Tvarnja155WuOZj8/GaNA==", "e9acbc47-3a71-42c3-8902-d0911f78d16d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f52194ab-fa49-454a-85b4-d1df4b4467a8", "AQAAAAIAAYagAAAAEAX9FSgzO9JL7gTypunXvZLoFGj4FkbJDcQ36P+YuBWlLgnDnnqqRuYo1EBzLqTj8g==", "487dcb33-99d2-4529-81c1-cab790eb7ebe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "831ce4fd-8542-4d04-9f73-c6473d61c777", "AQAAAAIAAYagAAAAEPsVeoUmpv2RmakzrOdO7736xICXLiKwq39XyvVWzG0OAnZc0DWWBGubIr/Zm4ViNg==", "80b967dc-e9a2-4370-92cb-20072a5b1da7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cbabc1ce-bd1d-4ecc-b574-3056cfc42558", "AQAAAAIAAYagAAAAEEq439BOG6SAgNbeAQsUaSWgBQm9pCsZL/+l5qb/VeHVxdl/mMm9gnffzRhLxpOQgg==", "ba874def-cf9b-4430-a1e0-0fbf34b0ed68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6b21ae64-204d-49c8-954a-af34329603b2", "AQAAAAIAAYagAAAAEMIMBR3Z9FVHGDDnnYqSD+bLqnbFgHPLpCVcG0M7pmnNTEwazWlcT4rWMftKp7rJBw==", "40838285-ff28-4a17-a8cf-546a50d3eae1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b53afdf-3b9d-4bf0-8429-ccfa94599ba5", "AQAAAAIAAYagAAAAEGEifl5c0Os9VPDWHYMk3i86pybJPM1b4vHx4oYnDjgR/JUpHd9911JIuxo+z4ym7Q==", "eea2249f-491f-4279-b25d-13ca786de3a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "92067530-d020-4997-a423-811387978510", "AQAAAAIAAYagAAAAEM1ldibkPN4GufPkGtCNETjbsukxMLUMCbXDazNrxAdJwaG0AFo+RuXUxwFzKbL//A==", "be16e561-0961-420d-a257-5ace89e6641e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c35c73fe-7871-4539-b3ea-0d3dfd8889da", "AQAAAAIAAYagAAAAEGvbGKLXzmFNxAuAhITcn9hQX4SWOBIC726S/ZSGeR60oN7VZdjpktK9ihsX19I+Vg==", "03adf2eb-e542-4278-848c-423aa5c90f5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdb3c1cf-b27c-426d-94f2-399f47b8569a", "AQAAAAIAAYagAAAAEOgN4AYoeBBrG1ovZc3efsPsHAO3vss2IvgXWoSJJ0uFTgOe7AohnGO2mN3tugFVcg==", "6564cf29-eae0-4820-8812-db7f089f4d84" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab513457-543e-4a4e-9b77-ef63e516aceb", "AQAAAAIAAYagAAAAEMExy+nv7DIArXK0IBrHqutpTW6t+cutNQQQG6R4Bk06DYMuwJ9aMm65IvOddNk56g==", "beff39fa-4050-4c51-af60-53b879d37048" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d34545fc-3d14-4a6d-9e59-6df48019b82c", "AQAAAAIAAYagAAAAEFz+x9CoHarrCcviVQ7/qnUpGBuh7+m4BFEyL8LL1EH3l+VsrGFHYJE3FUXtL2cMUw==", "d16e471e-835a-461e-870a-800666024835" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3797858-cdf4-4568-8ac3-b2a0878b10d1", "AQAAAAIAAYagAAAAEJ2QGGX8uiHtdrrTUJ5r1jX5UmNmhz+xbf1bd9zTU+ZNHfuysRWhMfJIEr8vT1ijhw==", "cbec96fe-6e8a-47d9-850b-056e0297e36b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb3af979-becf-4a5f-8993-27abd85451ad", "AQAAAAIAAYagAAAAEKa+ywb6r8sHQYBaR+EHShAZxemgCbPgZfDgPfGs+YMtGnkNyyU152ZTxy2Z4MpL9w==", "fa2c4a06-72f6-44bc-b32b-9bc15c2249c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02ebb9cc-c16b-45f0-9aa8-f674a91ade37", "AQAAAAIAAYagAAAAEOxgvS46Gbrrns0NSeWyg3uEqY4c1OSJZy4u6nJn8VSE9CT0rZSPbdb5s2qk7e6Vjg==", "237ffedd-1268-4b53-b063-93d9bd93b157" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b3bd51c-15eb-4296-b87e-3c46d09f9a85", "AQAAAAIAAYagAAAAEJTVTJ4Jy8/RLAC+eBj/Kbl3wAds2oZbxy/0O6yM0W+aTlnIMG0mY1IPlTzKeYkjfw==", "04152fb4-d086-4d76-8134-a80b4c197514" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8b27f38-b4cd-4619-879a-8aa4c17e31d7", "AQAAAAIAAYagAAAAEDv95sWWZ8w2WrBRBGQHp7FnwGE4kMMUrdJVt0gzPn5e4cEwpUcgRZgYOj1ILUbuSA==", "8c16664f-7cf3-45e0-aa46-5724a70cef38" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33a310a8-d651-4953-ae1b-8aa92f910282", "AQAAAAIAAYagAAAAEBHLJTJFfDeotn0s8PrJplrIopzJrn3yklVRqnVpFUARMAO5h1ZzoxfPWSeSCmputA==", "860aae18-6f2e-4929-87ba-b6919e14db64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca339164-a1b1-4c63-a4f1-1249c4bb5ffc", "AQAAAAIAAYagAAAAEAm0XbdUwSFYBgzhSrZJtx7lPctrwc1JLnLN01PTp8t3qe+1QexRFxSI9Ywpmeg9Dw==", "6a48840d-faf5-4cff-b166-914835e3644f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec0e5664-0721-4769-9546-4ad8378507c0", "AQAAAAIAAYagAAAAEC2FEnsnaxerPoBfb57C2oFmfy8sCnozrqExpeUOptTTrsUGdGMsunouDkrmqqlZyQ==", "e4887219-fe22-42fb-a76f-be2e419864d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81664e2e-78ec-4170-9a82-f76a71a53dae", "AQAAAAIAAYagAAAAEKKaeoGJ1mrW43PtuOpDnTuJmaIR07HKFJqyrG6PrGGSQ7Ap8uEKOgILlquIEkJdPQ==", "a4e46d11-250a-4b1a-a088-ec1c4cacb9f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "355f69dd-80d3-4be2-8c81-4290a71fd7f9", "AQAAAAIAAYagAAAAELrCb2qhHANzRJeEcq8pkTGcHmNr01hs0bqLCJLdbJwWuBLlKjGMT4cr+CIlb3sQzA==", "9a24015d-7439-4da2-90ca-093b923b0eff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdac62a9-3462-4fa7-8da3-a6e972a9a885", "AQAAAAIAAYagAAAAEFoweZcTMzuOwltUlH5M4ezT07f5uHnLM27ZsKyE11WmpULNMwFXG6WRktDJZbjy1g==", "7a940c4b-127b-45b3-be58-411037d5361f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e781cd8-f7bc-4058-87b9-1c7b3f5037a9", "AQAAAAIAAYagAAAAEKFyHkIu3gRIGyBP5BLkizJqqc1+YztR7rgrAuXvspAkCbhQQ53fcrYDro4x5gdzJw==", "59c9d2b8-1633-41ec-9eb4-d218f50cdb29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d869404b-474f-4a13-8cc5-d91e1d84e4e0", "AQAAAAIAAYagAAAAEEKL9hGysKF5ssET6XnZpBPS7Gyf1DXt4zYWQ5uPfjT9RvkM/mwp8ujx6Vx6S7E4Qg==", "aee0584b-3ea6-47e1-861f-474437369700" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "90d9e484-e255-4d7b-a87b-3cdfd79abdc2", "AQAAAAIAAYagAAAAEO3+rHu1o3KMGxeEjo0C/JWJpmld0HFO+sjTmKrZYSjXmDjhOvQcwWFCuEtuYIJ82g==", "b16a27d9-37dc-459c-a925-1b86b22460a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f514cd1-d8a2-4a79-b7c7-3b55bc3f8f58", "AQAAAAIAAYagAAAAECHlgqb1oCOYe7LkD/Dlr9iQ9v4L14gQ7V7De4FBUlGDYPjvyuqVh378bOYPFJwvHw==", "dac67e05-7fad-462b-bee4-d69b1c0727b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de014af8-2282-433f-8e17-8a1c5d043cb9", "AQAAAAIAAYagAAAAENhnizpM7JicUZe0MotJq2kGjy1C8w8L2Zmfuqmj4WeKZBwXMVik//+l3ulNWR+eUA==", "85700721-a864-498f-b8cb-3663f9072f0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b388588d-a1c5-4c02-a106-fddc2cc7d93b", "AQAAAAIAAYagAAAAEIddTew9WT39Rpq5IWdUQwFl8nNOI9muwEmw+tCwzuKKUv+EqArJ2Tx3rEIyWRx8BA==", "82a0dee4-543f-4bec-94e4-09c1f022807f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8afeafb8-752f-4c72-bcb0-d6287f4b642b", "AQAAAAIAAYagAAAAEJ7YW9HGt/OjNWlQCwXAklbitBVlqDao0SYWnwkf4FpLGcQPhRdSjFDQNdMhHyfMyg==", "fdb753ef-1408-4239-bf2a-16ff2d4a094e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50e38429-b5e5-471d-a6ec-19bf4c26f259", "AQAAAAIAAYagAAAAEAspGDwa78hwMqfKpzAl2ivXtNhad9mWpxc7RBsndrgafrPxsYXVqyDbVmOK5I1DyQ==", "e74c3e09-e51b-4c3c-bf7d-4d57f8059b49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af85b114-a99c-4027-aef6-1aa3767b369c", "AQAAAAIAAYagAAAAEEuyLe9e3aRgKTQNwz60NozvBUoYFdxAI4qZ7h+O1yMn/ykVyU2nHiG2PxfKmCaxvQ==", "f3c8f69d-d5fb-436b-993b-fe2c4c1f81a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "369966b4-f65a-4c09-84ee-5da2a56f7736", "AQAAAAIAAYagAAAAEG2pQZz6thxSvzuWUcG6hkIq6traUg4U2IR7gpHg1ZPMpw0xqLXSmK04VxbMAJB90g==", "4aa2f583-6cc7-4c99-b869-f938f84bb889" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7281988-0a61-495b-8d3d-6100fa8d686f", "AQAAAAIAAYagAAAAECkTow+bqv0KwSR9PxR0oqbi1sc4zeB7ktVpn+711ER/XqAmIZ/8liTEMeXOwNEcFA==", "5039fa11-764b-43f2-952c-39c375beac01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de1c54b6-a468-478a-b103-f6024b212446", "AQAAAAIAAYagAAAAEB3tIHLe0xf9YP6fEqUIBdddNfGJnd+lVsrVUYNPIFtKwR6VbpWSb22O5Bp6jMejbg==", "eaee5b82-42a0-4832-83a5-cd86ef25015c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b28ad119-7628-4378-bcc3-e8cfbcb13345", "AQAAAAIAAYagAAAAEBKVRU4WUM/K2uTVavaZPFf/egQpkhg1oiKCsDGThWvg+6JJxpRVIp0f1vIWcVAl3w==", "a79bd070-2d69-4ddd-b0bb-164c275229df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3ac4b55-1b85-430e-b4b6-9d6a4db63d0f", "AQAAAAIAAYagAAAAEKSS+A4fGTlAyGmno+8K/uWTV+soOfwO0KCEoqzS8IBdPztnZ8MizKClCG+5Tv1YUg==", "4760a58f-2852-4656-9e9b-b9f259b836c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2db46ad7-cdc7-42a2-b1d7-b8822852d609", "AQAAAAIAAYagAAAAECHj0TIHeCPRGs6xsbqUhhl5AFVQSJV+/OubF44ViLMoGqSQdvvK2h2wMO0k694Lqg==", "34522193-8ce8-46c9-8ca6-5eb0a8f3ba24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76486eb5-c4b1-4138-8c38-841d542a6a5d", "AQAAAAIAAYagAAAAEJymxSfiPIhLKZ2gNFZnn/MDGYBBBTHDYEBN1qX3MavxZ//lAQ1BUid25pjQGDyCaA==", "de93e884-ae1f-4e33-ab3b-d4ea80502886" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a114743-0665-440f-8d8c-996fc8705d9a", "AQAAAAIAAYagAAAAEFKFNVkqoxEC/2r1bgnX8+5J8Q8bP2kyrUIRdiw/Uo7beHvptKepzXMzP2VbzLLvCg==", "0d9a97d1-fbc5-45a2-8ed8-6025e2d88bb6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d7a518f-7388-4994-a9a5-38709d1b3281", "AQAAAAIAAYagAAAAEL/7rkTVROP8Eb9NnI190UXP9reAO3J94PjkvCJdvu2V6macEaas2/m/e3qzqdUqIg==", "47061de7-cbce-4bc5-ba25-cb766281fa4b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1a4b9b7-2aef-43f8-bb12-3af99e647fa8", "AQAAAAIAAYagAAAAEFAqsBZbCEjAovxs0LG/Q50y76XmMlmobGiJLmxJ6MUFk7QdbfeUwa4wjPLF2eh0bw==", "991cbead-0856-4829-ad46-b70aa50a5bac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d96286a3-94eb-4f38-a726-18ebf0d02ba2", "AQAAAAIAAYagAAAAEDuP3H3ScEqcw46V9tKuCHXoXOc8KblaN+m79ztHP2al+8BOMY+U+JugRzQ5q8M7ng==", "c2dddf89-3d80-4ef3-a928-7bb9795705d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "afcb72ed-b4df-4642-8f11-711078f1a52d", "AQAAAAIAAYagAAAAEP/kLJ/Qttl5a2xGL/XqxKjuaGEqog8EAfN+gb9PWkBr+J9C+/sTTto/1Wl+60iM3w==", "be815472-e886-4355-8e94-2e57d26bacef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b39e7f7-c8fa-4ef5-a992-518865a1c24f", "AQAAAAIAAYagAAAAEHVmdUQQwJ7eLsv6TYgCX1QttRhHYsk8IRooIHfIv2UGVeqGoQpZFXnxKtAyNiwTgA==", "489e4cd6-fa0e-4487-b123-069d58aa156d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a6befac-7ff0-4ff3-ba06-bd5b32f0357e", "AQAAAAIAAYagAAAAEFCRLkdprQJ8qgl5FDWVjlZpJfKEionoH1E2WZLxfI8gVHPK2g/1G6LLmqvDrnMp+Q==", "1ed84a61-5fb1-43d6-b055-ee86376dcc84" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5341e98-92d7-4e05-97a0-2235d176eab8", "AQAAAAIAAYagAAAAEAycyjpIv3cqDlfbaCveraGnD9K2iJBQVwLTGzSeHJ+iyHCx933f78CUvGWSoLkjOw==", "1e1a1332-68cd-479b-bfd6-9897dc382d4e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8042f55e-8a13-4072-94f3-d26544623e67", "AQAAAAIAAYagAAAAEN3dU6gToPxYtCxFSx8tNr3FVrc0KBsKVNnlMRPrdq7lPkcrEseW4HCFUK8WygQyQQ==", "0fc6a6ea-ae05-43ed-b4ee-f65d76c13979" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b02e32f-7653-405f-988c-ec6117bb1d82", "AQAAAAIAAYagAAAAEBgFxDGsDgCrbd2r+Or2TdryWmOIHZefpklEcEPiu0n1GgB1vXPv5Jk4PefZn9GvDA==", "29248f0c-b6d2-4ff2-94ff-2732eedb9ab2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af7cdbde-e9cf-4b13-b57c-7f775e9c49ee", "AQAAAAIAAYagAAAAEIniYZ9BF4N0ZlNuR5lfY+cmliBkCYGP2S+pW093+QhRCM4y3kHzuPZJYXqaMMV78g==", "350bf9ee-5e54-4640-8ff1-83684815f7af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f3f081c-9411-49b0-9d50-2fb2c21a1fd7", "AQAAAAIAAYagAAAAEPj0bd2ahhObTX0jALcBRKO03zqf8Pvs6S2cYuDhr/w4E/ZCl4hu4wbBXHe9aXfsVg==", "c8a10b64-ef4b-43ec-895a-2684c5183f27" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c82ebe52-b36e-4bbf-b3ed-6fa5fb326e62", "AQAAAAIAAYagAAAAEPzBzwC2Pc4MWsPqqkxaw1KOMXdxyPa177ifI+wQbugWfJlk1ROHhBlWGrrZ28slkQ==", "9c3cc122-ebce-4e61-8e05-69f7a9fa1a3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "16a2bb7d-ffaf-452f-a3dd-614e48b3baee", "AQAAAAIAAYagAAAAEHWUpuRavhGILbFQdkGpDJOEVxUPpiyqQvuzZZw0USjEe07PlfXa6jZ12/bQ5EjKHQ==", "24c70135-7a89-46b7-9757-f1a073d76f9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9909b8e3-4469-4684-9392-6bd7a9ab0afd", "AQAAAAIAAYagAAAAECFmkNE2hDCh7RT+H0bs7SzIwR/i5Z3yo6eJUBf8RcPX5LdMiqn8bexY/Tj558KV/g==", "09d5916e-d4b1-4168-8874-e77163d043d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3fdb776-6244-4801-9c3a-e90399162021", "AQAAAAIAAYagAAAAEHYRpU9lAOPi3tMwOcf3jYPErhX0gMnUxixBxHfsD0bXo1dNfHEL51TdzxLM2XaddA==", "cfd133ec-72dd-438a-98f4-6e41713aeb10" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63bf7fe4-26e9-479f-b0b6-5465550deb30", "AQAAAAIAAYagAAAAEEfXps5f+rG7z5RD5ExBOEEUNslhRhfIdNIKmiYpZwb2+49exH3CdNDSxzXRrgBhHw==", "28878462-5aff-45ab-a522-46e1a9a40ae0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bac9b973-a7a7-41b4-97b8-f29fad8c123c", "AQAAAAIAAYagAAAAEBjfvyDepnVwkqBtkV+yUwjGY6qTP1oMCTiuyZ1K+XZW+WQeg7fIcy/EofcF6JEckQ==", "e1c83a05-91e5-4863-944f-d47218ab666b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "424b568b-812e-4887-9f52-d01a2e4a788d", "AQAAAAIAAYagAAAAEFdC6DAZe1Q9ByFkPBk3QeiskD0EYAj2f2CAlUSYGPS2P5YA5HlR6KR7cQmCXJnyWA==", "a63335de-cb60-46db-ab8c-290e3cadeb91" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a2ae791-aea7-447e-9bd2-0b18d168bbaf", "AQAAAAIAAYagAAAAEKfE//uAQ8UnGSDOrZO/FOrw3sQtw/t4tbuTZcGZhzTs7xTvgo+vd6RA1mRQovI1Ig==", "bf7a7719-32ee-4dc6-b51c-55d94b402b16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "acb96e7b-899a-49ed-8d48-d164f0130b97", "AQAAAAIAAYagAAAAELhPLaFjtZPMyW0OlWbqMSq9U3i8+IJqutBSkgGmvRkg8Ly/snKkxV22lKqOgDyM4A==", "e5d8ac34-36d5-4df2-9201-7a52bd223270" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "895503ce-da1a-401a-9eb6-706be8bb28f1", "AQAAAAIAAYagAAAAENKMMrZvoOrjMN0bOZoebtITSycR5nm/VoDrctNqPT33Spy7IShGX04bAWu9OSoNnA==", "6bc69c4e-3377-42d2-bd17-b2a041dba74e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0103cf85-73f8-498f-85f6-2c3419c0753d", "AQAAAAIAAYagAAAAEGU+XPSsnkUz8/fL4jt+n/rEvFnObL4nvzZFQNU6JYjdA1dPtEVHfQtU/sgCYJ7i4A==", "27117f45-9ea8-4183-b625-98857016f221" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da65b505-5e33-4c76-ad06-6d2c73789888", "AQAAAAIAAYagAAAAEEu4rUvoD85zFfX+/Fw+pHmsgkF7lZWsJeDdks7jpDWk/toBLebJPZm871kt1RvIBQ==", "030a77a9-bedc-4952-b084-69745ca8b3a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf236486-9c1a-4237-9270-3a26d35485de", "AQAAAAIAAYagAAAAEEkgS3+Z+acK3xm6M5+PnsCE9V5Hdz+yNhaF352dakstEKW7Hj6PJtZpF+G9JFvQKA==", "8d814626-4309-419b-96e5-adf95b4e11e6" });

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 1,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 2,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 3,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 4,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 5,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 6,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 7,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 8,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 9,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 10,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 11,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 12,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 13,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 14,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 15,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 16,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 17,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 18,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 19,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 20,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 21,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 22,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 23,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 24,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 25,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 26,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 27,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 28,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 29,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 30,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 31,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 32,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 33,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 34,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 35,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 36,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 37,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 38,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 39,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 40,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 41,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 42,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 43,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 44,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 45,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 46,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 47,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 48,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 49,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 50,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 51,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 52,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 53,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 54,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 55,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 56,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 57,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 58,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 59,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 60,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 61,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 62,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 63,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 64,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 65,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 66,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 67,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 68,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 69,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 70,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 71,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 72,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 73,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 74,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 75,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 76,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 77,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 78,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 79,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 80,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 81,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 82,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "AuditorTeams",
                keyColumn: "Id",
                keyValue: 83,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 9,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 10,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 11,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 12,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 13,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 14,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 15,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 16,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 17,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 18,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 19,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 20,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 21,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 22,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 23,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 24,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 25,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 26,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 27,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 28,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 29,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 30,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 31,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 32,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 33,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 34,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 35,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 36,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 37,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 38,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 39,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 40,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 41,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 42,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 43,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 44,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 45,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 46,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 47,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 48,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 49,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 50,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 51,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 52,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 53,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 54,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 55,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 56,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 57,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 58,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 59,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 60,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 61,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 62,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 63,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 64,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 65,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 66,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 67,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 68,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 69,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 70,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 71,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 72,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 73,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 74,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 75,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 76,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 77,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 78,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 79,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 80,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 81,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 82,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 83,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 84,
                columns: new[] { "AuditorTeamsId", "ImprovementTypeId" },
                values: new object[] { null, null });

            migrationBuilder.InsertData(
                table: "StandardVersions",
                columns: new[] { "Id", "IsDeleted", "VersionName", "isActive" },
                values: new object[] { 1, false, "ISO 9001:2015", true });

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 1,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 2,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 3,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 4,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 5,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 6,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 7,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 8,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 9,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 10,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 11,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 12,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 13,
                column: "ImprovementType",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Teams",
                keyColumn: "Id",
                keyValue: 14,
                column: "ImprovementType",
                value: 2);

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

            migrationBuilder.InsertData(
                table: "AuditChecklistQNA",
                columns: new[] { "Id", "IsDeleted", "IsoStandardId", "Question" },
                values: new object[,]
                {
                    { 1, false, 2L, "Can you please explain how the organization identifies relevant internal andexternal issues?" },
                    { 2, false, 2L, "How often do you review and update these issues? Can you provide examples of recent changes?" },
                    { 3, false, 3L, "How does the organization go about identifying relevant interested parties?" },
                    { 4, false, 3L, "Can you describe the process of determining the requirements and expectations of these interested parties?" },
                    { 5, false, 3L, "How often do you review and update the requirements and expectations of interested parties? Can you share any recent updates or changes?" },
                    { 6, false, 6L, "Can you walk me through how the organization defined the scope of its QMS?" },
                    { 7, false, 6L, "How did you ensure that the scope includes all relevant products, services, and processes covered by the QMS?" },
                    { 8, false, 6L, "How were the organization’s context and the requirements of interested parties considered while determining the scope?" },
                    { 9, false, 6L, "Is the scope documented and easily accessible to relevant personnel? Can you show me where it is available?" },
                    { 10, false, 13L, "How has the organization established, implemented, maintained, and continually improved its QMS?" },
                    { 11, false, 13L, "Can you explain how the QMS processes are identified and their interactions determined?" },
                    { 12, false, 13L, "How do you document process inputs, outputs, sequences, and interactions?" },
                    { 13, false, 13L, "How were responsibilities and authorities assigned to personnel for QMS processes?" },
                    { 14, false, 13L, "Can you provide examples of how process performance criteria, resources, and risks are identified and managed?" },
                    { 15, false, 13L, "How does the organization establish methods for monitoring, measuring, and controlling QMS processes?" },
                    { 16, false, 13L, "Can you share any recent evaluations of QMS processes and improvements made as a result?" },
                    { 17, false, 27L, "Can you provide examples of how top management demonstrates leadership and commitment to the QMS??" },
                    { 18, false, 27L, "How does top management ensure that quality policy and objectives are established and compatible with the organization’s strategic direction?" },
                    { 19, false, 27L, "Can you explain how top management ensures the integration of the QMS into the organization’s processes?" },
                    { 20, false, 27L, "How does top management promote the use of a process approach and risk-based thinking within the organization?" },
                    { 21, false, 27L, "How does top management ensure that customer requirements are understood and met?" },
                    { 22, false, 27L, "Can you share any examples of how top management emphasizes the importance of enhancing customer satisfaction?" },
                    { 23, false, 43L, "Can you explain how the quality policy was established, documented, and communicated within the organization?" },
                    { 24, false, 43L, "How does the quality policy align with the organization’s purpose and context?" },
                    { 25, false, 43L, "Can you provide examples of how the quality policy supports the organization’s strategic direction and provide sa framework for setting quality objectives?" },
                    { 26, false, 43L, "How do you ensure the quality policy is available to relevant interested parties?" },
                    { 27, false, 43L, "Can you provide examples of how top management ensures the quality policy is understood, implemented, and maintained at all levels of the organization?" },
                    { 28, false, 53L, "Can you explain how roles, responsibilities, andauthorities have been assigned, communicated, and understood within the organization?" },
                    { 29, false, 53L, "How does top management ensure the QMS conforms to the ISO 9001 requirements?" },
                    { 30, false, 53L, "Can you provide examples of how top management ensures processes deliver intended outputs?" },
                    { 31, false, 53L, "How do top management review and report on QMS performance, resource needs, and opportunities for improvement?" },
                    { 32, false, 59L, "How does the organization identify risks and opportunities associated with the QMS?" },
                    { 33, false, 59L, "Can you explain the process for assessing and prioritizing these risks and opportunities?" },
                    { 34, false, 59L, "How does the organization determine appropriate actions to address identified risks and opportunities?" },
                    { 35, false, 59L, "Can you provide examples of recent actions taken to address risks and opportunities?" },
                    { 36, false, 71L, "Can you explain how the organization sets and documents quality objectives?" },
                    { 37, false, 71L, "How do you ensure the quality objectives are specific, measurable, achievable, relevant,and time-bound (SMART)?" },
                    { 38, false, 71L, "Can you describe the process for determining the necessary resources and actions to achieve the quality objectives?" },
                    { 39, false, 71L, "How does the organization evaluate progress toward meeting the quality objectives?" },
                    { 40, false, 86L, "Can you explain the process for planning and implementing changes to the QMS?" },
                    { 41, false, 86L, "How does the organization ensure that the purpose and potential consequences of changes are considered before implementation?" },
                    { 42, false, 86L, "Can you provide examples of recent changes made to the QMS and the planning process followed?" },
                    { 43, false, 92L, "How does the organization determine and provide the necessary resources for the QMS?" },
                    { 44, false, 92L, "Can you share examples of how the organization ensures that resources are available, maintained, and monitored for effectiveness??" },
                    { 45, false, 92L, "How does the organization ensure that it has the required personnel to effectively implement the QMS and maintain its processes??" },
                    { 46, false, 92L, "Can you provide examples of how the organization manages personnel resources to meet its quality objectives?" },
                    { 47, false, 92L, "How does the organization identify and provide the necessary infrastructure for the QMS?" },
                    { 48, false, 92L, "Can you provide examples of how the organization maintains and improves its infrastructure to support its processes and achieve its quality objectives?" },
                    { 49, false, 92L, "How does the organization determine and manage the work environment needed for its processes?" },
                    { 50, false, 92L, "Can you share examples of how the organization ensures that the work environment supports the achievement of its quality objectives?" },
                    { 51, false, 92L, "How does the organization identify and provide the necessary monitoring and measuring resources to ensure valid results?" },
                    { 52, false, 92L, "Can you provide examples of how the organization ensures that monitoring and measuring resources are calibrated and maintained?" },
                    { 53, false, 92L, "How does the organization identify, maintain, andmanage the necessary organizational knowledge for its processes?" },
                    { 54, false, 92L, "Can you share examples of how the organization acquires and shares new knowledge within the organization?" },
                    { 55, false, 119L, "How does the organization determine the necessary competence for personnel affecting the QMS performance??" },
                    { 56, false, 119L, "Can you explain how the organization ensures that personnel are competent and, if necessary, provide training or other actions to acquire the required competence?" },
                    { 57, false, 92L, "How does the organization identify and provide the necessary monitoring and measuring resources to ensure valid results?" },
                    { 58, false, 92L, "Can you provide examples of how the organization ensures that monitoring and measuring resources are calibrated and maintained?" },
                    { 59, false, 92L, "How does the organization identify, maintain, andmanage the necessary organizational knowledge for its processes?" },
                    { 60, false, 92L, "Can you share examples of how the organization acquires and shares new knowledge within the organization?" },
                    { 61, false, 119L, "How does the organization determine the necessary competence for personnel affecting the QMS performance??" },
                    { 62, false, 119L, "Can you explain how the organization ensures that personnel are competent and, if necessary, provide training or other actions to acquire the required competence?" },
                    { 63, false, 119L, "How does the organization evaluate the effectiveness of the actions taken to address competence requirements?" },
                    { 64, false, 123L, "How does the organization ensure that personnel are aware of the quality policy, quality objectives, and their contribution to the QMS?" },
                    { 65, false, 123L, "Can you provide examples of how the organization promotes awareness of the importance of conforming to QMS requirements and enhancing customer satisfaction??" },
                    { 66, false, 128L, "How does the organization determine and implement internal and external communication relevant to the QMS?" },
                    { 67, false, 128L, "Can you explain how the organization ensures the effectiveness of its communication processes?" },
                    { 68, false, 134L, "How does the organization create, update, and control documented information required by the QMS?" },
                    { 69, false, 134L, "Can you provide examples of how the organization ensures the availability and suitability of documented information?" },
                    { 70, false, 134L, "How does the organization ensure that documented information is properly identified, described, reviewed, and approved before use?" },
                    { 71, false, 134L, "Can you provide examples of recent updates to documented information and the process followed?" },
                    { 72, false, 134L, "Can you explain how the organization controls access, distribution, and retrieval of documented information?" },
                    { 73, false, 134L, "How does the organization ensure the proper storage, preservation, and disposal of documented information?" },
                    { 74, false, 152L, "How does the organization plan, implement, and control its processes to meet requirements and enhance customer satisfaction?" },
                    { 75, false, 152L, "Can you provide examples of how the organization ensures effective control over out sourced processes?" },
                    { 76, false, 162L, "How does the organization communicate with customers regarding product and service information, inquiries, contracts, and handling customer feedback?" },
                    { 77, false, 162L, "Can you share examples of effective customer communication processes?" },
                    { 78, false, 162L, "Can you share examples of how the organization acquires and shares new knowledge within the organization?" },
                    { 79, false, 162L, "How does the organization determine and review the requirements for its products and services?" },
                    { 80, false, 162L, "Can you provide examples of how the organization ensures that it can meet the requirements for products and services before committing to customers?" },
                    { 81, false, 162L, "Can you explain the process for reviewing and confirming customer requirements before accepting an order?" },
                    { 82, false, 162L, "How does the organization handle changes in requirements and communicate them internally?" },
                    { 83, false, 162L, "How does the organization manage changes to requirements for products and services?" },
                    { 84, false, 162L, "Can you provide examples of recent changes to requirements and the process followed to ensure proper implementation?" },
                    { 85, false, 186L, "How does the organization plan and control the design and development process for its products and services?" },
                    { 86, false, 186L, "Can you provide examples of design and development activities, including inputs, controls, outputs, and validation?" },
                    { 87, false, 222L, "How does the organization ensure that externally provided processes, products, and services conform to its requirements?" },
                    { 88, false, 222L, "Can you provide examples of how the organization evaluates, selects, and monitors external providers and their performance?" },
                    { 89, false, 244L, "Are production and service provision processes planned and carried out under controlled conditions?" },
                    { 90, false, 244L, "Are criteria for workmanship established and communicated?" },
                    { 91, false, 244L, "Are suitable equipment and infrastructure available for production and service provision?" },
                    { 92, false, 244L, "Are products and services identified throughout the production process?" },
                    { 93, false, 244L, "Is traceability maintained, as necessary,to ensure conformity to requirements?" },
                    { 94, false, 244L, "Are the status of products and services monitored throughout the production process?" },
                    { 95, false, 244L, "Is customer or external provider property identified, verified, protected, and safeguarded?" },
                    { 96, false, 244L, "Are necessary actions taken if the customer or external provider property is lost, damaged, or found to be unsuitable foruse?" },
                    { 97, false, 244L, "Are products and services preserved during production and service provision to maintain conformity to requirements?" },
                    { 98, false, 244L, "Is preservation also applied to the constituent parts of products?" },
                    { 99, false, 244L, "Are post-delivery activities, such as warranty provisions, maintenance services, and disposal, determined and controlled?" },
                    { 100, false, 244L, "Are post-delivery activities considered in the risk assessment process?" },
                    { 101, false, 244L, "Are changes to production and service provision processes properly controlled and documented?" },
                    { 102, false, 244L, "Are changes reviewed, verified, and validated as appropriate?" },
                    { 103, false, 244L, "Are changes approved by the responsible person before implementation?" },
                    { 104, false, 244L, "Are the consequences of changes evaluated, and necessary actions taken to mitigate any potential adverse effects?" },
                    { 105, false, 266L, "How does the organization ensure that products and services meet the specified requirements beforere leasing them to customers?" },
                    { 106, false, 266L, "Can you provide examples of release criteria and the process for verifying conformity to requirements?" },
                    { 107, false, 269L, "How does the organization control nonconforming outputs to prevent unintended use or delivery?" },
                    { 108, false, 269L, "Can you provide examples of how the organization identifies, evaluates, and takes appropriate actions on nonconforming outputs?" },
                    { 109, false, 281L, "How does the organization determine what needs to be monitored and measured and the methods, criteria, and timing for monitoring and measurement?" },
                    { 110, false, 281L, "Can you provide examples of the organization’s approach to maintaining documented information as evidence of the results?" },
                    { 111, false, 281L, "How does the organization monitor and measure customer satisfaction?" },
                    { 112, false, 281L, "Can you provide examples of methods used to obtain and analyze customer feedback?" },
                    { 113, false, 281L, "How does the organization analyze and evaluate the data and information from its monitoring and measurement activities?" },
                    { 114, false, 281L, "Can you provide examples of how the organization uses the analysis results to improve its QMS?" },
                    { 115, false, 296L, "Can you explain the organization’s internal audit process, including planning, conducting, reporting, and follow-upactivities?" },
                    { 116, false, 296L, "How does the organization ensure that internal audits are objective and impartial?" },
                    { 117, false, 309L, "How does the organization conduct management reviews to ensure the continuing suitability, adequacy, and effectiveness of the QMS?" },
                    { 118, false, 309L, "Can you provide examples of inputs, outputs, and actions taken as a result of management reviews?" },
                    { 119, false, 330L, "How does the organization identify and implement opportunities for improvement in its QMS?" },
                    { 120, false, 330L, "Canyouprovideexamplesofrecentimprovementsandtheprocessesusedtoidentifyand implementthem?" },
                    { 121, false, 334L, "How does the organization handle nonconformities and take corrective actions to prevent recurrence?" },
                    { 122, false, 334L, "Can you provide examples of recent nonconformities, the root cause analysis performed, and the corrective actions taken?" },
                    { 123, false, 350L, "How does the organization continually improve the suitability, adequacy, and effectiveness of its QMS?" },
                    { 124, false, 281L, "Can you provide examples of how the organization uses data and information from monitoring, measurement, analysis, and evaluation to drive continual improvement?" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchedules_AuditorTeamsId",
                table: "AuditSchedules",
                column: "AuditorTeamsId");

            migrationBuilder.CreateIndex(
                name: "IX_Auditors_AuditorTeamsId",
                table: "Auditors",
                column: "AuditorTeamsId");

            migrationBuilder.CreateIndex(
                name: "IX_Auditors_ImprovementTypeId",
                table: "Auditors",
                column: "ImprovementTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklist_AuditChecklistQNAId",
                table: "AuditChecklist",
                column: "AuditChecklistQNAId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklist_AuditorId",
                table: "AuditChecklist",
                column: "AuditorId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklist_QnAId",
                table: "AuditChecklist",
                column: "QnAId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklistQNA_IsoStandardId",
                table: "AuditChecklistQNA",
                column: "IsoStandardId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditComFindings_AuditReportId",
                table: "AuditComFindings",
                column: "AuditReportId");

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
                name: "IX_AuditPlans_AuditPlanStatusId",
                table: "AuditPlans",
                column: "AuditPlanStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_AuditProgrammeId",
                table: "AuditPlans",
                column: "AuditProgrammeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditPlans_PreparerId",
                table: "AuditPlans",
                column: "PreparerId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditProgrammeObjective_AuditProgrammeId",
                table: "AuditProgrammeObjective",
                column: "AuditProgrammeId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_AuditStandardISOId",
                table: "AuditReports",
                column: "AuditStandardISOId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_DateofAuditId",
                table: "AuditReports",
                column: "DateofAuditId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditReports_OfficeAuditedId",
                table: "AuditReports",
                column: "OfficeAuditedId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditScope_AuditorTeamsId",
                table: "AuditScope",
                column: "AuditorTeamsId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditScope_AuditProcessAuditedId",
                table: "AuditScope",
                column: "AuditProcessAuditedId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditScope_AuditReportId",
                table: "AuditScope",
                column: "AuditReportId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditSummaryFIndings_AuditReportId",
                table: "AuditSummaryFIndings",
                column: "AuditReportId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditSummaryFIndings_CriteriaId",
                table: "AuditSummaryFIndings",
                column: "CriteriaId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditSummaryFIndings_NcarStatusId",
                table: "AuditSummaryFIndings",
                column: "NcarStatusId");

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
                name: "FK_Auditors_AuditorTeams_AuditorTeamsId",
                table: "Auditors",
                column: "AuditorTeamsId",
                principalTable: "AuditorTeams",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Auditors_ImprovementType_ImprovementTypeId",
                table: "Auditors",
                column: "ImprovementTypeId",
                principalTable: "ImprovementType",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditScheduleDetails",
                column: "AuditPlanEntryId",
                principalTable: "AuditPlanEntries",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules",
                column: "AuditorTeamsId",
                principalTable: "AuditorTeams",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditComFindings_AuditReports_AuditReportId",
                table: "AuditComFindings",
                column: "AuditReportId",
                principalTable: "AuditReports",
                principalColumn: "Id");

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
                name: "FK_Auditors_AuditorTeams_AuditorTeamsId",
                table: "Auditors");

            migrationBuilder.DropForeignKey(
                name: "FK_Auditors_ImprovementType_ImprovementTypeId",
                table: "Auditors");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditPlanEntries_AuditPlans_AuditPlanId",
                table: "AuditPlanEntries");

            migrationBuilder.DropTable(
                name: "AuditChecklist");

            migrationBuilder.DropTable(
                name: "AuditComFindings");

            migrationBuilder.DropTable(
                name: "AuditPlanApprovals");

            migrationBuilder.DropTable(
                name: "AuditPlanPersonResponsibles");

            migrationBuilder.DropTable(
                name: "AuditProgrammeObjective");

            migrationBuilder.DropTable(
                name: "AuditScope");

            migrationBuilder.DropTable(
                name: "AuditSummaryFIndings");

            migrationBuilder.DropTable(
                name: "ImprovementType");

            migrationBuilder.DropTable(
                name: "IsoAuditProcess");

            migrationBuilder.DropTable(
                name: "IsoStandardAuditPlans");

            migrationBuilder.DropTable(
                name: "AuditChecklistQNA");

            migrationBuilder.DropTable(
                name: "AuditNcarStatus");

            migrationBuilder.DropTable(
                name: "AuditReports");

            migrationBuilder.DropTable(
                name: "AuditPlanProcesses");

            migrationBuilder.DropTable(
                name: "AuditPlans");

            migrationBuilder.DropTable(
                name: "AuditPlanStatus");

            migrationBuilder.DropTable(
                name: "AuditProgramme");

            migrationBuilder.DropTable(
                name: "IsoAuditors");

            migrationBuilder.DropTable(
                name: "AuditPlanEntries");

            migrationBuilder.DropIndex(
                name: "IX_AuditSchedules_AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropIndex(
                name: "IX_Auditors_AuditorTeamsId",
                table: "Auditors");

            migrationBuilder.DropIndex(
                name: "IX_Auditors_ImprovementTypeId",
                table: "Auditors");

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

            migrationBuilder.DeleteData(
                table: "StandardVersions",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DropColumn(
                name: "ImprovementType",
                table: "Teams");

            migrationBuilder.DropColumn(
                name: "ParentID",
                table: "IsoStandards");

            migrationBuilder.DropColumn(
                name: "Particulars",
                table: "IsoStandards");

            migrationBuilder.DropColumn(
                name: "AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "Purpose",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "ImprovementType",
                table: "AuditorTeams");

            migrationBuilder.DropColumn(
                name: "AuditorTeamsId",
                table: "Auditors");

            migrationBuilder.DropColumn(
                name: "ImprovementTypeId",
                table: "Auditors");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "AuditableOffices");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AuditableOffices");

            migrationBuilder.DropColumn(
                name: "RowVersion",
                table: "AuditableOffices");

            migrationBuilder.RenameColumn(
                name: "AuditPlanEntryId",
                table: "AuditScheduleDetails",
                newName: "TeamId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_AuditPlanEntryId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_TeamId");

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDate",
                table: "AuditSchedules",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDate",
                table: "AuditSchedules",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDateTime",
                table: "AuditScheduleDetails",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<int>(
                name: "OfficeId",
                table: "AuditScheduleDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDateTime",
                table: "AuditScheduleDetails",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "Auditors",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "903e1cd1-06d1-4696-a03b-07b1295abd4f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "c11b5658-7056-4e08-b2d0-a740a8de66f0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "fb69a682-79b9-4450-819c-a4168f6345b8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "cf11f756-0d38-44e5-8d8b-cf7d5d4d3e7b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f6d7ec21-4892-4e0f-b821-9b4410a58de4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "dcbc894c-1a3a-45da-a94c-de1b8c612a8c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "631f4cc2-1223-434c-9f27-df2bcad62759");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "fb1d9492-f7f6-418e-a5b3-833691f22e86");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "897f6ffb-4cbb-42ba-ad2a-e9e9c60f9ee6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "77db3f19-4713-41e8-b7ca-34996806498a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "12e170ed-6ee9-4a4a-93a2-7f643163b353");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "e3ea15e1-90e3-4ea0-a8cf-11d4c701736e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9d2a6f4b-3c81-4e7a-b5d2-1f8c6a9e2740",
                column: "ConcurrencyStamp",
                value: "1893a895-8eb6-496e-831e-f10e7fdad465");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "9b14ec8a-9549-4801-a36a-5ce0db97882d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "44bdbad4-b588-421a-a456-10d77769dc2f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "14c1cd6c-23f2-47c8-aa6e-1eae260d5b2e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "930a6137-b52a-4ef0-b888-ae4ac703cded");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "939c291d-9029-467e-a0ac-adecf4af943f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "81c7a0bc-0a74-4959-baf4-a2531f49ac32");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "7593736b-ff23-42fd-ab39-156d22c11802");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "644e8ae2-5e25-4eed-9c53-e467bc154f14", "AQAAAAIAAYagAAAAEDIsIfWmUZdD5l/F0noYHR/QMdwQVxQjF5r9RJfEk1g2rjQFMzJ/ilXtC4Gf7vP/gg==", "949a4d2c-a9bb-4e99-8df5-c48390240def" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08125a92-e925-40aa-9109-67849934568d", "AQAAAAIAAYagAAAAEMhn5B8S4Q6Ebxd0my14aRV0Y6fHu37lOzQKX3P3+hBzgW0+zKX6TPpKQvssSnk/Tw==", "e13f611e-552b-4e22-8fa7-be8152d4b3a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8840bcc1-319b-4e4a-b9ca-5c078c4552c6", "AQAAAAIAAYagAAAAEAl3sAHYbbX2R2NbMwL09nEZ+1Utqhka3sd2DfkOMX3t9AlQBiZ0anLb1taY9lQFxQ==", "aa5f431f-16e8-4467-98be-594249ee28f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cbc281d-f4ff-4921-88a2-31de19640c40", "AQAAAAIAAYagAAAAENis0/5YiphYNM/17ykIuD7G5Rn5PukGVZOctJhCUvFHhrlXAIbg1WUOiPSFbGctvw==", "81197766-addf-4107-b6b5-d764b62d7864" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e82241d-90ba-446d-9b4a-03e1110ef56f", "AQAAAAIAAYagAAAAEAqM0X0msZyk1D0olMfPAPkHTNJtuii3eTGQA4oZ/231geG5ye3nWj+snd1dhAwRlQ==", "1ccce728-7724-4739-a126-1e904dd4a9f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4597ff29-a355-47dd-b84a-62ef10fea77d", "AQAAAAIAAYagAAAAEGWZTS3i3cg7j8J2oylLS4z4epSdTTKfTBv/2Bkh8FsH/KyK2ALRl2zWmnmA1IKR3g==", "614ebc39-7219-4e5f-96a8-0e21aca86803" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0063541a-74ca-4a60-9b1d-9cc24ecaef01", "AQAAAAIAAYagAAAAEKVNjMRJKkrej3TrVrr4AfKzDXxYpgj7bSGaPujQ2SDnJxq0GFgXbzUpUForjKCqOQ==", "7c037196-4da4-4a24-9ca3-587d1ba65d1f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1cb4468-358c-4f1e-80fd-1e9f8a0aef73", "AQAAAAIAAYagAAAAEF8nLfh5h7dNj5gHrcDkjq6xdydNe6zUhC9m0BaBrCx+Z/6pEQuyil9V8FxqblJ+iA==", "ed637c00-3ea8-4ee3-a8d2-5d819c52e157" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24796e95-ba14-4fda-836d-6298526c0dfc", "AQAAAAIAAYagAAAAEAkAm8Rt996M11wT6L4251WsAeZS1hMoyiKMmuc3J2DSA4WWyfnXPEex63e27CuF2Q==", "f9676d87-17df-4fff-bf22-c609ebf3f075" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06ecf03d-5f96-4fd4-933d-394bee9bc6f0", "AQAAAAIAAYagAAAAEFRolpepVfldBy2g+JSU++/ftfHgaOv1mn7c3EBHyaulgXn7/viKB/Q1KTR43JFM2g==", "391d54bc-4be6-444d-9a68-c9024624a3ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fde7558f-3aa0-493e-b42d-45afc95f7772", "AQAAAAIAAYagAAAAEBybP4v+0OgJJRk+nI0OraTageZ7NtAJ9we4tQaRaQ42Y9m6tY/stDzkTXwfsgu/gA==", "2b30ec2d-c581-4bc5-b5ea-0224e06a6901" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7adaa60a-0f30-4c90-853d-a7e11c08950c", "AQAAAAIAAYagAAAAEL4FSVywq6TMcw0nfUonKNRlqqFPNfl8/Ep/n9WdllAcSL290FVy5C6JWfbg4VZa6Q==", "e90616e1-bdd7-4374-982b-9eb05410f0cb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd646e0a-0bc9-4bcf-aaa5-aee92231bbda", "AQAAAAIAAYagAAAAEJ6QRd+DCiT7f0cuQOVikAhdSnOI4D0zIGWUFOcJjEdMQ+g94qN6zCUcKzOOQWqGcw==", "738f8898-f207-4315-838e-028a8c9405e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3434fb44-4380-44a0-a2cd-4dc8d109e3bb", "AQAAAAIAAYagAAAAED1ztwfXZRZhpZuutQO30oPZesN0vSx6O2RMDfjnc5hLJ9iMjWADYyaigloDFVUaJQ==", "780c2eb5-dfea-415d-8bf7-09865060a1f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ef6980d-9160-4b4b-9751-0eb9965727c2", "AQAAAAIAAYagAAAAEKkN5nK2LFu6J+aFlVPl6R7Hx900Dn0vylZibFF//Qma113I5E+Xlk2tTjY+v1HveQ==", "ae302795-a485-49d8-a63d-10a3efffdba0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "802d9eed-b6bb-49ef-b938-384cea9f7d0e", "AQAAAAIAAYagAAAAEBMFJ4vdcIA0NftifkdB/eNdQW9OMRIlGVLuAyYNUXP8sYdjwGCucxanPGi48Q8npw==", "6b230d72-2eba-422f-9e2e-665647bd6de6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d3675da0-b053-4aef-b77e-c801265dc9b9", "AQAAAAIAAYagAAAAEB2bVAkvN0CDqpy7oDVD2Nb6ujuFisb71Qmj/ywke0rlqaP+Pp5AP/sD3Upds/0+ig==", "4b0d2355-4ad8-4085-999f-01db51f64c3c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "105f6dd7-cb5d-48c2-9480-b006229b6173", "AQAAAAIAAYagAAAAECqfXabZfCcY1LQEgqRUl4UpD5Yp8T/QgLTDt5YFs/knPuB7XcRWLxQArnElutZVnA==", "34987324-03f2-4e4a-9a24-b99cb8f453d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc70aadb-b5ee-4199-ac73-315c4d97e461", "AQAAAAIAAYagAAAAEB48ImTMScSbW89zRJexPpBk2AF+bz8O5nd+EJ45RnXlpxIFJmujAC8q76eZaNLSiw==", "da9fa59c-afdd-4948-96eb-35c2bd7fc593" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60a1cac6-be28-4e52-a30e-b7429bae20c6", "AQAAAAIAAYagAAAAEIHsqT5AYbElA5XoObLxeYLkFEIn3t0PGMY61xeFGgB9fVyAEFcBuCETqyj3rrwrLg==", "56b19876-14aa-41a4-8b91-ba43db081937" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19bd600b-ca9f-4ba0-a8cb-90ed5470c822", "AQAAAAIAAYagAAAAEBd+EnHpE4SI20xt3echJ0+ll+l68gwtsXyWvAZFP3M4l9W1MKN1lDYx+vh8M8HPjg==", "efcb244b-c5e3-4a5b-a28e-fc8d86da54a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08f0fb63-7271-47df-b462-5bd64a960857", "AQAAAAIAAYagAAAAEDCdotC5+usHxTnGyKZ8H5DXkTC4rqTKVa0Vxo7CsB70cwq9TphcrlixAmJFLGpMew==", "ae9a6be5-35ed-4b6e-aa20-2bfcb0b0f137" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bc97d99-017d-4ffa-8024-21ab13db845e", "AQAAAAIAAYagAAAAEK8xV7NCv9jBb2XHzjKxg4q0B09QNXcIGNh7ORucIU1lOwYYwgvEpA9IH2lkRO8SzA==", "d6399832-7e2d-441b-8f7a-9c60a9fc0d6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac1c8123-0800-4e7b-8e79-3f37af541a26", "AQAAAAIAAYagAAAAEHQmfp9zg/ccoNeNH2r8d9ec5kvjDesS4nLgbtPl8UiE8jgxznJm4wvey1go9QrBeg==", "ce24c43a-98f0-4b72-b7af-a09feca55d02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1673e4fc-aa10-446d-b3fd-3f22d6b07f56", "AQAAAAIAAYagAAAAEEZHW5FJdVU6HusO5R3sUZJO1S1yaK6iDiVcdRRp64t9MBi9fc4nl17fVUPperS/0Q==", "55e66417-dd65-4d72-a4c0-58569f8df82c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17abac54-1c27-4d6b-92c2-fe1bfc79a5af", "AQAAAAIAAYagAAAAEFHMbJyyi9jwDcx38I6yXT5mdRy033FfQ9Dd4gLmi3mEzQKGzzYX94L1SkDfc9v6Tw==", "17428009-d223-4068-aca4-6e4600e5ec05" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd9aff59-8be0-4100-8ef4-2c27d6bc3091", "AQAAAAIAAYagAAAAEJa6iue2kKgh9/a5KFleHt8uGjX4BcYZ6TAwTzGKLWhs4IN44jPvNvM6yF5BHM8o2g==", "52f0d605-ce8a-45ba-8b6e-32f30821e9b8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe12df4e-8104-46ba-943e-e5ee53a9ac14", "AQAAAAIAAYagAAAAEBr7OgWgdZRAgGyX34RqGdHCshY+C+GVv9n+2vmpq2Z08Nhi6muYY6jjcvXW9Ku4hA==", "de4602d4-bfa9-40e6-8467-cc6274b96747" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "44ab1bfa-80f7-43ca-868b-91af48805303", "AQAAAAIAAYagAAAAEHX2HxL8wXODyYzpGATEW0P0G4hLNEI4VQWfkAf+30tEa3scD4pWnvCeMjEGnxrd+Q==", "8eeff273-62a7-4b23-b9d0-b6eb343c2d83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "31ff3a13-ec07-497a-b65a-0114a6df1e93", "AQAAAAIAAYagAAAAEO0bCMsplx+BeIprsmpeAgg/N7vLjRpXgwvoAAsOIbHDDkKnAtFUwlUzw9ojwTZY5g==", "a9630b30-d5f3-45fa-997a-678e9f977856" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "260294f1-f5f9-4bbc-bcf4-88dfb075cb0d", "AQAAAAIAAYagAAAAEH/mj57S6Ewbadmb7EmUKD5UruWQRDCz4B4L4yaNT7Z3lrT2heVXODo7K1QdN2NZuw==", "287b2bd1-b745-4146-b800-87a954d71ee4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77fe2736-a195-4e85-b297-dcad87278287", "AQAAAAIAAYagAAAAEOpof02qXNcCjeXvttUmvSJVLRIqA7+W14lvgAOTU9MeF/Co9aBZsbJm9UYAXjOZtw==", "8e2b1379-48b7-41d3-a21f-267acf2633d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8dff6306-d540-49ae-9745-350a869e30d9", "AQAAAAIAAYagAAAAEO1E7Z9dG5lkeK3hQ8HLauW/t6+EuDd+mDf6yIOf/+NZAZ8m+GbQBeajUYvs9Abh4Q==", "abd2ecf6-8839-46f2-b160-29d6b6cd6432" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b20422e-8d6f-4580-abef-f15a4eea9a5f", "AQAAAAIAAYagAAAAEDaOaQ8YAepWvKvDC0YDAQGwYsxT11CsS+aLRYEbcJI7cR7Yze6hitp3yxc5c9BRmQ==", "40ec0d0c-da0c-4495-852d-d86aa5c97870" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ebe27be-e8ad-450a-acc0-e13e8903628a", "AQAAAAIAAYagAAAAEBXY3guzvIHdZY6EF4iTzMirZYaYBLdEq2+lYcLfPuBy4kzi5XOueFpuaxVIhDIkAQ==", "10fea258-c113-434a-915f-985e791eff44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d178ddb4-38df-44ac-8c4d-bfc370720634", "AQAAAAIAAYagAAAAEPbQ8F6uJaYqy7OxiPlY+FxAUV5IswRYvXeEVxk1FV+GwVyXpQXVU+Pd6surH4Uslg==", "8c1a1cba-91db-480c-9306-7dd4c5949abf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa290669-bef0-4976-b04a-18e9a120edfd", "AQAAAAIAAYagAAAAEFACqUUQYItDUSaTvhgd4kFGneqEq1+b5ynnApWHwoD+Srj3r4J7P0/Af6d5LEfwkw==", "1b821210-f92d-46aa-8b76-50c0b4597f83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c986090f-b176-478f-836d-996a5a332fab", "AQAAAAIAAYagAAAAEAA86+f4SuyApgDhHAkS4Jqm9LgzQEjTY+ynO7tQl+0jqFZ0UTHq+L0WEcqEnKnikg==", "01c2e2b8-510e-4202-a09a-d78af3e65261" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "494b357f-dd0a-4539-bf42-7ae8ae37d8b2", "AQAAAAIAAYagAAAAEBp+PmlcQNtSEYalkQtcPsgRH8RQj4QlSgQG4Ps+LEL+sl1h4P0j3mW2RwIZpgNRpQ==", "c5df2244-74e6-4bc1-bdba-87b5b10edbcc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc1c7128-0215-4b18-b153-6360dcfbb1e1", "AQAAAAIAAYagAAAAEDO3TEXBy2IWYJH4yI9htOJF54qEZThhqmxfHqIBy7OFIKq+FGR0wJ0jGmQe6msExA==", "81d45f7d-e6c1-413d-9c95-749911c6faa6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b541fa4-4a3b-45ca-abe1-67bfe28f00fd", "AQAAAAIAAYagAAAAEEOsRDtUaLmAcNYNKpeCkjEEua71/3APIfGqRbrP6wY4XUMgzo2Ufet4EtIBAG5qjg==", "c182247b-2da2-4c08-831d-bb0d492c91f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8368699f-c3df-4bec-9895-c28956ce79f6", "AQAAAAIAAYagAAAAECkNtoGJ3AAmEnA9+y1Up85qFK/mM7rGkfnm0JeA4PV6+qW5cUiWTk77MtR0JhNrSw==", "0c92bdd8-d074-4a27-a91e-ca314fccc01d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84288f58-52e2-4cd9-b8a1-a4667c5a8fd1", "AQAAAAIAAYagAAAAEL2o8arpF4JmeuoSohI9u7hZ2t+/1L7WYATxhDiDwDSc9g4flDEyxFsYmOeXoE/6yg==", "59680519-c8c2-451c-afac-d3fef23bff71" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "540bf147-6494-464e-99b2-ff2097fbf762", "AQAAAAIAAYagAAAAEJS1YZ2eqWYRBvCK8OA114xsx7fhbWGioHq6GGjleY8HHajz9b0POAOKXcrm36Of4w==", "92be5a33-f259-43e2-aa68-6dac034d478a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd53a7c3-6b5d-4c3d-82f7-587bc329f4a2", "AQAAAAIAAYagAAAAEC9+9/RuYEeofSAbSqRL1t+Wj3jgvUVO7JpBfwOaSdIozOOhUS/JfwtuO3EzEsjdeg==", "6da52f48-c69c-4ac0-bdd1-622ca36397ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c23c47ee-87a9-4676-9eb4-0c4062078289", "AQAAAAIAAYagAAAAEPGr6NR1o506Ui4BSOE6v5Os1OyKwjQ09U+RuNrvYI793JZVgxxth/MYIytHGkzLmw==", "96d0d4b3-294e-4652-9a60-d4ec3d0d21da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ff862cc-f99e-423d-a00d-76a770533259", "AQAAAAIAAYagAAAAEDmWxskbod/7GDiHNsrMXkzv49BbMbpWl5sXcOXjElXqJmj4e6fyuhe+Fu0fpgrc5g==", "e2d844a7-7855-4499-8411-2b7eab13187a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "908b3708-df6f-4a7b-9b01-8827395595a1", "AQAAAAIAAYagAAAAEN+62EbugyCG4CvWWT/89qxeKsT5Ba5nyL13ckFgGAoZ6dd8Z5FTU6B4JMqGbtjKyA==", "ca1ef3cb-1442-41b5-b0f9-6ecbf0f2201f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c54acb2-4379-48da-8fa5-2afe91c92dbc", "AQAAAAIAAYagAAAAEJFXBOEBWxZ1zMWAucD6JttkLNWgetGOBu8zZ/RzpjXFJ1FHur3HWgcFZ8Y0pN86xw==", "a53823f6-28a7-4972-843a-876d346b5ad4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "388661ab-a09f-4b05-839d-45eebe635753", "AQAAAAIAAYagAAAAEEtyiEqOmT24E/CRZ4UBRq0v0Hb/oDSB/U81I/DNsDqThsV2iW3MfCL9gXyAGzYeDQ==", "1512795c-d167-4ec0-ae7b-f5c8d0644be5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f708dabd-2a02-41ab-8635-e5d8c2926def", "AQAAAAIAAYagAAAAELf7NmlRJLREXji4Vuo1Gtzb1Za1KcfugHTnEkqc5F0eG3ZMHGqz6ndHwwXOJGHsvw==", "d01baa98-c268-4c54-b575-352ba105fc9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1887d0b7-f276-474f-a9a0-11570bbafd55", "AQAAAAIAAYagAAAAEOgG0+iSdEgnUtYM/fEqQCKA6cdz5ZcQRpg2sJjR9hlv0xGxg5nz/4JBwKTbaN1+Yg==", "42fd2edb-37fd-406a-a040-022b377ee753" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "450f9737-2d55-468e-9091-ea80eb4dac09", "AQAAAAIAAYagAAAAEDNOEUnCSWteR+R+Zz+I42bW6zgtHhXbYoJfoEytyWhH8ER5tydOT06pw5zGDbpy0A==", "e1a49814-ac75-4138-9ebc-d719aaa24e34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73446387-0a48-414d-b097-1c8df5d1a102", "AQAAAAIAAYagAAAAEPASLXVhtwtYZnYKS3uJGWpEqKbshHzjExLEWHrC8Oe0w1BOdrlrM3DA7xbtuUYjuQ==", "89afad5a-0895-4225-ac85-85dc66f15da7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5719cd0d-352f-4dd9-90ff-be9212e3a868", "AQAAAAIAAYagAAAAEASuSAH/jqN01VnGgi2qQMZ8UT0uubv05n9CibFB+P77Ly6YbD072YzVGNUeWL4JAA==", "7927c1e6-0e90-4097-84fe-9914c0bcb27f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f80f7834-4605-4af6-abe0-c0cb3922ba0e", "AQAAAAIAAYagAAAAEO2vi/uLXLS2txn4B9S9hmCL+XrEGgapwtQnYQa8q6z9mYhxxp9Oe7jZgvwtbQVm2g==", "1cec6ff0-f236-419b-bacc-c3615be5b1e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06873b73-961e-48e5-91ab-7e35d30b7945", "AQAAAAIAAYagAAAAEOWWhofIWrFe4mi31Bb6GAO/SiFYz1PyK+WvFgDEu3krtC771NqSvI7hcBae6Mt88w==", "f8e3a3e0-b416-4fd6-95cc-d0d8bcc1e8b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f2c96333-bf4c-4633-81ed-ce5f28af9d32", "AQAAAAIAAYagAAAAEHONMSQfEKKNDzWjU/ydLPEOouyYIKStmT1tWlrqqYeyg9UFv9s9BBw8MVHGRL6IAQ==", "e83ede90-a4a5-4ff8-8155-1f412ac328b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0e4914a-1667-4623-b294-36c9d883c99e", "AQAAAAIAAYagAAAAEG8ryki8zs9vP1uSrvDkBFmRL9yPHoBn0KQpUuAwcehGicrlRlZI8HGBh12jZaNGhg==", "139b9eb4-802a-46df-a905-906347eead34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e2f819dd-4822-4502-b949-1199f8be05c3", "AQAAAAIAAYagAAAAEAwFWfRV4iOboqv049Q0J9HkiuxKGHvHy43DekJFCHxVC59iobBOOfLmrEBBjPeIwg==", "69e0f196-78c9-4ffb-89dc-5badbf49c39a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a9bec33a-d79e-4715-86a5-09487174481b", "AQAAAAIAAYagAAAAEH1jurhBASQLqeavPzHgqRk0wKAlK3D1JxaGwRa253m/Ry+aWSor85+JULF/YkAypA==", "da1bb365-77ca-4113-9039-024abe99ba90" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8097b927-e3d7-438e-9f23-81e5a02a12f8", "AQAAAAIAAYagAAAAEEwif+UeRdEbyfLuuGKp8yMW39YW2u40WAxGBoiAL2Tf286R9g6mPhCcvm6wTIoYNQ==", "ad86383c-d9f4-423b-9c31-5bb46300b999" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1759e2ae-9bf8-4e98-83d4-d04c8d352db5", "AQAAAAIAAYagAAAAENv16SqVSK/JiBtwt6q0QQPqxEZwis0J/hBGQOd+SqptTqAyMjKtOUu67FTMHlemZw==", "822ef7b6-d08f-41e9-adb7-569a49456310" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35ad5972-0cb7-4b98-b54d-82c2e37eb3c6", "AQAAAAIAAYagAAAAEEDeFn+t1Dxz3T/NQBA623I4eFgF7roYB6CUC7esHV3eRU/76Cc+63P9+3UoZE1osA==", "6fe63cda-de39-49a2-a7ae-68af54adeb74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e14865b2-19a6-41e7-8b64-4462ed6d6602", "AQAAAAIAAYagAAAAEIvNaANhS2qLmMA4rBogAmD7bHDCpamqUhNYWKELBo5MH5gqwhbEq9/cORyKLmdNlA==", "1bce53f1-a873-46ac-8f14-ad017eb2fdb6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "66db065c-19e6-4378-9f17-e80b92b19a7d", "AQAAAAIAAYagAAAAEOxzM6LmQbuMRssL0VQWMimROFNZiYxauRMfn9+NmxA+QlYtG3b4Kzs2/Ad01BS+eQ==", "30f24a20-3ed6-4a49-bf69-1e32523d65bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4307db3f-c5b0-466b-9bc5-37915063ebc5", "AQAAAAIAAYagAAAAEIbYa7Or5F+7Po98Au9bsN+tmCqgPpYwqHr9ybW55SsDdV9ge4IABschhcSlnjELEQ==", "7d9e20aa-3bd0-4cb7-afad-af3a8e378744" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "232a2ca6-06f4-437b-92b9-80a2f8bed0c2", "AQAAAAIAAYagAAAAEAeiLMr/7i8PIJCsAzPi9TMJMOvYoecarPKQGPyogHRg80TCzDiVmlYersz0nfSKdw==", "3693f176-2177-4930-a732-81d37129f6eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e87b4061-de41-40da-84eb-b4be342849a7", "AQAAAAIAAYagAAAAEJwf9bGsE8N9p2ztXjLwKvNnewLiOPRSLMNoiih0duA7hISuQz0fjkSZqk6+0KDhEg==", "cf7de234-7240-4cc4-96c2-4e4c65a31d3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5b28238-8971-42e2-b2e5-2280673f0fc6", "AQAAAAIAAYagAAAAECrzQeBE76TJ5k35fFW7KAQlBlxOv8LJ86kWGRUs3P1ShHIijmydWRVSaqQajmnE8A==", "e30a2e39-dc15-4273-b920-1a30ea4d7bbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3be9f710-f03c-4bcc-b54e-75a1e93134d5", "AQAAAAIAAYagAAAAEMQlOCgG5L/xKYSvzxBgPSoKWkZUI8M0CnYTzK4PfnR+WItEcfR9go0AlJBwb/j3BQ==", "1fe483c0-1eb0-4c86-9fd7-316972b9c456" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "711f9b82-6c66-4a37-bd97-4e28b3603205", "AQAAAAIAAYagAAAAEGoPxKj3EeTBtFdgyA4v2wnjPhKEHeJU9V4vyVq3kxz8fVGidI9fWNz50aPjxjcymQ==", "ac8266f4-aa92-4970-8904-3b0996e4adf3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe8e9d22-5866-4af2-969d-7f1aa8e1516a", "AQAAAAIAAYagAAAAENxtIM4KaYY5QwIk6un/bPuPT/Xb/kTS3JB8t0HaztvWGIMzdB9t6uwPqQpikl3enw==", "b442955a-787c-4720-8de0-9bf301c5dce7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1055269c-c3d1-4376-8ce3-7c39913df5f3", "AQAAAAIAAYagAAAAEO5ssNk1IBGOmuI4CCEtQ7LuMClyyN5rIx1x4MIjvY/Jea3FU+ImN3skjMuH8fH44A==", "fda4ab88-cbf3-4857-8870-de1b14222c89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6851a09a-50d3-49e2-850b-476d4768bba4", "AQAAAAIAAYagAAAAEB+/n5xOQKwGmknqvKRoZaYzp0NUpcVp13pOUD4aKIEm2lvuVcVfsr/8yOmUUMqPwg==", "834499a1-64bd-443e-97e4-d5a3e7bed6ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87e5cacd-95fc-4ce4-9def-9c2ebfa56a46", "AQAAAAIAAYagAAAAELnwiT4YA0VKnWRVUfyonTuQk7ER0+6N5nt+eyNIAmpcq3wVTEV0tdIH7JXuAysp1w==", "cf6f3ba4-153d-4d45-943b-f1a61b35a2b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6518a753-f54d-4336-a726-cf205656fff8", "AQAAAAIAAYagAAAAEE2O9zR0C+IkaF+HHXbmBB/R3vvZBHaGJgtA+ycHSW+N8ik11KcPumDsEJRbQfIbvw==", "5f87a198-7b5e-4728-828e-8f7da667fff4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c3eb538-39c2-4df1-9b5d-c92082ff87f1", "AQAAAAIAAYagAAAAEFtnwWRxdau0C5CSwJgMZ/R13jQVHaCsPh0sUtDRX9MsqeLUcHnyMGVv1Mpf41C2Wg==", "5bd56279-efef-45f3-921a-dfa8668af3e6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08cc8228-2445-4571-ac81-e6e15228bc25", "AQAAAAIAAYagAAAAELOfUwEFIoMjW+lNtFjdKL6aOmPfcR8fm5tZavwcUJ3a8NOF23duv0xXyFS3hzLkQg==", "f7b031b6-7998-40c8-b580-584fa41961c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "815e449f-b156-475e-a7b6-74e91013a18b", "AQAAAAIAAYagAAAAEMAnAlCMplCH0XlANMYpYCXs81cISR6P1TbNHl5+qOZtgH3Mr8nehR8IA9UAet250w==", "2f1314af-234a-453f-a2d9-4a2701ff5623" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f847b1d6-e8f2-4e5c-acaa-8eb9b4288c81", "AQAAAAIAAYagAAAAEPg6rIsCvN2T/q67Gvr4Teci42kOrkZbhm4fMvkftkI8+CzPvRnA8YFRLdxI7s5tVw==", "b36a5d3e-c277-48fa-9ba6-9d2c4ef9794e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3ecddbc-82db-4bc2-a9c2-9c6fd0471f4b", "AQAAAAIAAYagAAAAEPdH885+mYaEiN7wJ1z/n9RMlUuDCEhhzJ6TOcDbAt+rksiE7u0Tt83SWUHtRg5hcQ==", "6e31c75f-1702-4c18-b42f-22e9e2b0eca1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ab4438e-171e-47d0-9c55-cf9796036320", "AQAAAAIAAYagAAAAEIjdX6d/v4sZNJeNMMAe/1ZR0WU6maumeJCNF37BJatTgVC9PD+tqiX4CCu/IXg/8A==", "a1328bb8-d061-4d0e-b33b-5ab95250e34b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2029d69f-edf8-4ca7-b0b6-8560ee862099", "AQAAAAIAAYagAAAAEAd0EtvSM8aS6Uzu3TAqvDcn80bnBU1OwdEwHjWX0Xxh6Y2uWdEXDaBKPL+qKfoWFQ==", "c9700895-cc54-496a-aecb-d908dba32183" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe8a46b3-2600-4078-b2c2-adb27565f3e6", "AQAAAAIAAYagAAAAED3BWB36ac6zLA+Pj8p4ILjwvZ60Pam9kwHyyCvlXgiF2cBquJUXk4maqzaQ+LW5gQ==", "79332cca-3a01-48c0-bec5-ec92f0a1576a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76d95d10-22f6-462a-85ef-4fbe84eba4e0", "AQAAAAIAAYagAAAAEJeWjypbRAnIGjkIkaOIBbEp3/Chk3+7fMCqj0QsIrLIl4/pBBtSTVop0650wdhYRg==", "15fb79ed-ae98-454f-ae98-7fa82f440c29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbf0b223-d55e-4d41-afc9-0051ca4a862f", "AQAAAAIAAYagAAAAEPfQV8YitYUFbIHK3viwA337y2ehZy7rlbTIiTGEFX/MQ6yq3o0cLo+LAp7WF9O3gQ==", "22a70728-4e17-489e-87a6-c161a713a7c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7fbb2e4-12d7-4f8c-adab-256ae56a5174", "AQAAAAIAAYagAAAAEMahCpIgrZW89gJa+iFkdXbakpZNxZcN7IxdAnTy5lkRroVWisSE/QF7DoZUoOoVgQ==", "a8be0064-d23e-47b8-ab65-3c2a04ff8bfc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "952f730a-fca9-4f6a-b4ca-1339b9570080", "AQAAAAIAAYagAAAAEC1lsHZQSsBqHJ8htie42G9Nj3lJdILOW4OM/2S2GRiywazSUgmn09kEAeI4FeituA==", "37e72e46-bf58-4eff-a5fa-ce15b8a6079e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c809b06-8782-4175-bbee-07bba9aa50fa", "AQAAAAIAAYagAAAAEN0zRZPEks3pDIQ5GCM5QqLi14ArhULj6ss4WG+zbkAD1UIb6CS6JgG1LlEZuMq7ow==", "1853f6ff-7a14-4752-ad19-45fac8f3b648" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f0d0bbf-7073-47ce-b5f1-3476daac4440", "AQAAAAIAAYagAAAAEAhrwYOkHpyfGMRomvkSGSup06zOM1bKjqXhCLvsdj8oN23KBdu7v9NVVHQ0k1unbw==", "38e4bc11-30cd-49a6-8fb4-a84d9606dd45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe79aa65-82d5-48e5-871e-d5de0da9af98", "AQAAAAIAAYagAAAAEKMKkzkLHa/LLYbCCodP4YzdV4lzsICjjxW8MqfzyO2xqO4tbUcc6dEnAPxBBIEKcA==", "d32442e2-2f60-47aa-bbf4-5012d7d35196" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "178491b6-1225-43b4-9c47-375cc500f345", "AQAAAAIAAYagAAAAENXO4wF8nJAyuU3BcExr8YjSP0DelVlwrBCZ+PBtcGUcO+cwurMncJzgb1qZb52NiA==", "c47a9683-8dbd-4db5-bf1a-c9d40a30b204" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64931c5b-c8ec-489f-afd7-a960b360d146", "AQAAAAIAAYagAAAAEOZu0Pc7qNI0xhoL9+kVEl+lmhi4yt6FMTOQFHzBsFr1fjI0FvCGNvsUBrvjyFKrjw==", "4285367c-d617-47b9-b44a-fb0f513ab3b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49083d96-c355-4ad1-898a-5afdb2efb1bf", "AQAAAAIAAYagAAAAEJ/ccy38AB1t/DCzzwRT6VJoS46iGHvs1O2kQWGvOFYlQSY/WgxuFbAOND95iFZlng==", "4412a558-3a5f-433a-8e49-02c7b90fb4f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a68848b1-4ec8-4133-b6cd-ad12641e2ac2", "AQAAAAIAAYagAAAAEBws1+Q3DvuaxZuEIHd8957UF99UKgyGZFnKaiOdlrY0NIlRfYp3aa36byCMammpYw==", "67ae74bd-565f-4e93-9543-ab644d468e54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e26fae10-040e-427a-a62b-81f11131592d", "AQAAAAIAAYagAAAAED8D8u48Fb73DjfxWzy5s3VhLbghFdz7U9HSUxM+bbjya8nX2TNvAsnY8fwcFN518w==", "da797794-7133-4fb1-b17d-6870e3dc026c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "406e5a6c-7b76-4053-b89f-23abcbbcde94", "AQAAAAIAAYagAAAAELjrVtARFDqbKt2NTY6aYOzGwds/KIPu5gKpHD11QaPnh0OTpzdMSxcLehV6a2BUfQ==", "ae65703d-a571-4e76-bc44-37ec224f5ef2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f442f5b-6b52-488e-a6f2-2ba0e35e84db", "AQAAAAIAAYagAAAAEEzmyJkOkkzrX+m7wjDNAVFwTUEmcnVGsxPWvq7vF+BSzfMfF9aHhUC7wlU5cdkLxg==", "5debcc17-9510-4dd1-aa06-34260df630c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3232e2d7-24e8-418a-8fe7-4391cba03e3c", "AQAAAAIAAYagAAAAEJyWu6LnJ6foSlZSwDG2iYkhoOCjs2wggOO9c1Gl6flwy0jyISZ6P6LQpR2/MG3Qzw==", "07e1756c-5d38-42ca-913d-fc16d8d288cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b75fae58-2469-4b00-8a50-bf44096ce317", "AQAAAAIAAYagAAAAEAyMCKXZsIjWromCHm30lQRxvfQMXrMWf2WflwPEKtD1/9uxaL0z6uslCOwHFLpZ6Q==", "dc1d55b9-823e-475b-85be-2bae90bd9470" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd651919-31dc-4a48-bffc-895a9b5a8420", "AQAAAAIAAYagAAAAEPp/uCMIq+4rEm3CKdManKZIrfygMdDHZF6owcboTOoVaTVAT0xmDCxBvJC+BeNZeg==", "b8a8eea8-87ef-421f-9632-14dc2015605f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82c9dbc3-1d03-47d4-8fc0-5b451aa2bae7", "AQAAAAIAAYagAAAAEBDIFOwq1N/aFakyWF4i2VCJltSjc+UfOnZWzzrLhClWHZrp65drjwSXSk/S8CO2NQ==", "7dbf7624-594d-4522-b8f7-709fc467d17b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0a7a11c-e00b-4d11-aa92-8bc9cd34093f", "AQAAAAIAAYagAAAAEF//GPJUCHLOcjbSYsaRkz4Fr7lpTa3MPkMByyEymrB25FWbICgcFKbD5jLQJmwh3A==", "6e02b6b2-58e9-4745-a409-d93066c60cdf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45144345-b72f-4efa-8988-73f51801b856", "AQAAAAIAAYagAAAAEBWbR+V5CRI9BhJgm1n6XP2BMLUeEUbJn5DvFzrRxAYsI+jLB1GJiikYMlMG4Jn57w==", "4ddd9a8e-bc62-45bb-9dc8-713a474424df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91acbcd2-94ab-4004-87fd-0d226bb0a9e2", "AQAAAAIAAYagAAAAECToY2CExhfaaBBCbSaDTTUAfnJjc9ib6lvSiZpR3tC/8v3/PvIBZ1ilFoOdcPSyQQ==", "499a5543-8203-4b71-888b-ee7bab8379d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95aa6127-79d0-4267-8e81-b6efe8c64d17", "AQAAAAIAAYagAAAAEOFSL8MHSO7K4+oIVIvVtBtpX4GQN3GbAt8c5goivE55rMZmYS0SEsj/OLwp80Dyxw==", "5da4dee3-fb1d-43da-b62f-30b1b52e8467" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f62bff5a-5802-4f19-8df5-43979681d06b", "AQAAAAIAAYagAAAAEMjW+hKOdC+ZLFAaqJ90WKlkyhH6O+aji7tC6w4jIoc3YTFMXeYlbA6mt06mm5nY6Q==", "8453e701-92a3-4820-9f95-a5351afa3302" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82fc0e91-2b17-4e9b-a859-89a5eb065cf7", "AQAAAAIAAYagAAAAEEMNZMnE5wUk3gZplFCzFgYi1kimDQTTL591r6LCu4cHzWSAHVhi5R6MEq+KIGEa9g==", "b19953e5-7e19-49d1-a66c-6e21d4ee12dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "31f800e7-c3db-4ce2-8be7-bd054dfbef76", "AQAAAAIAAYagAAAAEFK0OMWK4zJHRfKttHoN+Ym0T1KBrj51JP3vtjvgfyP4JW8qTtSjNjbQoMIkJ3AfvA==", "4ccaeae2-7ba9-4dbb-b525-585025932914" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07da8162-3439-4d3f-9201-ccb867c36176", "AQAAAAIAAYagAAAAEPmXk+Y9iRkaFf6tOmmC+QExh10xVLkA4YRcFC6cV9H2mVq26bCHUJydF3Q51xWSng==", "ef3f2154-0df8-4789-8721-ba1bea33b7a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69388d30-9d74-45cb-8b37-1d61f6b7b7d2", "AQAAAAIAAYagAAAAEFoh9KNYdf1skPqGud+2uzun2yse/ZHTRbP1wFW8+pmABUrlY6z1JoB0XLOVeK7DXg==", "9852c2d2-5b24-41ea-a386-0e2b9a7ebba5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f790620-9b76-4034-ab89-5b1ae91f8890", "AQAAAAIAAYagAAAAEEaqoJHQ5BCCZMDjrg4dVBS9+BBJh7kLglLAFCFEqN8jNcptpbha69tB27jhDkv/yw==", "a7387c95-0f45-4067-a9fc-c4e1fb8e4357" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6ad5e74-3191-4d42-b31b-170da626c233", "AQAAAAIAAYagAAAAEKGlJofCr1ANm0skEuqPJ8L12qKf/+hQXY2xHqriydHSq1riNOdXqMd0f1ezS8y/6Q==", "4c256bad-a57c-471b-86a5-4fe6a5adbd87" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69911bc5-049c-4c8a-86e6-54aec3fb7b62", "AQAAAAIAAYagAAAAEIWREEPntjxzCIpBccCOxEF7W64Lx0qIDGb1CxaDZqLFPwkq5D3YdvJa94EM27w8rA==", "492771bd-0095-450d-ab8f-090e75318175" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15f78225-8fa7-42ea-963a-cfeb31b5ce78", "AQAAAAIAAYagAAAAEC1lAx5bjlDtfTL8dvzK+NEM4qHoZW+eqRX1a2+eSYeyR2/Bh3D7Lpl0BRBAAcLI/A==", "a77a9b62-12cc-4bf3-bcad-3862576f77b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1950d734-c390-4dba-a629-c4e06b617410", "AQAAAAIAAYagAAAAENzbTM/2p1iOHmTtFtcmStTnWY+AmonCuw12PLmN4lYyXgsO1jxoivBJ5iuSxBgEfA==", "e9cd5da1-893e-48df-8750-3eb399ebba82" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a05f097b-ffa1-40ae-b8f7-84ba31a536ae", "AQAAAAIAAYagAAAAEGz5CAKNgPg+AKbuWUx41/G49J2cVE0hfx7H+WklMGe1udCy6I3MZhD/ZY1vljP0gg==", "7b7f5e12-a25d-495e-805f-149d846484b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb53d309-5b95-474a-baef-20b5cdecab2f", "AQAAAAIAAYagAAAAEOFyA+pVG//O+LTto/wMgrqKvNwA5V7aAvMbWLqZ4ct3IPUMI5+2H4u4JlPC13dn4g==", "54990c15-7e59-4bd0-9539-089f045707e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f849ede-bebb-46e2-bdfd-4385158555de", "AQAAAAIAAYagAAAAEMr3FgNCdROrW4TbAPp5Pz4cTU3Neaiolz8+1ibWEVIcs3FwsjxA37JIEHaM7DOSzw==", "be553e20-9c99-45ba-8ef5-0b8fbe09629e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1233f74c-eb96-47d0-9c11-b41c60e95890", "AQAAAAIAAYagAAAAEAE6phLVP5RcIwGDWX5vHJ92fMfXr10VcMwdMcv4WBEXaP3mIjF5Qk8nLswmHojb3Q==", "c6879cac-c864-4ab8-a904-6a0b61f69854" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2bd79584-355c-4181-a0d8-daa9d6b57f3d", "AQAAAAIAAYagAAAAENKsJd+uS1q4u6APgzIQkMi8vi6vDohcCzRALuSJa3q/mnFxTEGFMOd6sb3xo6vggw==", "079daade-1ea0-4939-84dd-6a657098cd4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a924d4bb-f7df-4ac0-8ebd-a53e0dc54f6f", "AQAAAAIAAYagAAAAEMXN3HqEmZZbohcnI8j9DVeOW9IRCQVmS+5C7tK/tI1OMd9RJsRuANoMOE6e/pIpGg==", "a6cb5c17-7b3c-4f3a-9b75-ac75bd38fc01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4fdbb3d2-582e-449e-969a-1a3129cc0bc3", "AQAAAAIAAYagAAAAELW6giQIoXmUn1TyTjRQ74sGk/HRt9sJswE4qWt7evCqWPS/LqUUDZr9NctYE5ruyg==", "7d814ae4-9ea4-4996-9876-f5af31dddcb3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6e1c90f-a2b7-419d-bd21-f6a1cce1bd28", "AQAAAAIAAYagAAAAENu/uBP4byE/3IzPCpQZvJaDsoQ7E/JkCPM4q6zbt8rYHficWtQ5CMEaI/c0AnLTIg==", "4eab036b-510c-4564-b2c9-d87ccd378773" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "269d7567-6343-49a4-8062-e72a09c7f1b3", "AQAAAAIAAYagAAAAEFPHE6qHbuSTkW3KuBIgLS6uiB+zq0W0I3xr3MA2msEkTkOKWg/w85oJL3wv/XX76g==", "6234d0c6-3a75-496a-befe-abcefeeaf96b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d913aa2a-c49e-449e-baae-c6b9fbae7ac1", "AQAAAAIAAYagAAAAEOhrc1nwIG8zuFyELs9Xugg5GssnWw7Z9a3HdbHBhj/vLBmvYq9UJvM8YtFBDaaOYQ==", "8c155cfd-2a33-487d-9319-c0b5adf84895" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d2ebf94-978b-43d0-aa8f-5aefde4d0adc", "AQAAAAIAAYagAAAAECq0ssXTMhMY11AdNCF99TTWdD3NvFh8/y+26QXh2N2dCPXJE+cNvxAnIylsAGYxzw==", "1c75f1d2-c1b7-42bb-85d5-8f8af1646227" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "44e2145d-a104-49f5-929d-f11e5335c3b7", "AQAAAAIAAYagAAAAEJwsU519MniyfKyipq46Tc6P5NWaFwAXSG8fHY7zy/lXplRLxVqhmqBkEi+xKIUxOA==", "4f7dcb60-fd96-4a61-b775-13351a7d0ed6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db67b02b-bb96-487d-b369-2df01f060136", "AQAAAAIAAYagAAAAEGk+rseJ5joTYAiEkk9bPTcx/E/6WxAI5qANFey8TGU7ua1ORG5xm+HUsZ7ZuEKvoQ==", "68051d03-2ff1-4554-9513-85caa45f935e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57fb987c-4e49-4d54-9c45-8697ce797ba4", "AQAAAAIAAYagAAAAEG/yUjrZOC1Tm8TYspVoXMKqnDs3272+I9nVucHgi9R8ts1ZC1pmgkzRVPOgvOUWKA==", "9a570629-6aec-42dd-aac8-2c8efe14a52a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08054c5e-9911-4841-b032-8237ac9d06ee", "AQAAAAIAAYagAAAAEDllYpQyy7jC1J7Xu0GtIYwLXqjOu5/yjbnwt3nWYKlyP2g4JlpKNJfb3rAYDQB0pg==", "43d6e5e6-800a-4e5f-a95c-26e8b97a558c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58b5ea54-6415-46ba-9a4d-ef7aefd77a27", "AQAAAAIAAYagAAAAEFEAwj30FiE0Hl9LM8Yj7XOSA7AFtE6oHEpU0qztER63a/ked90TFbTZ0uXdT1Es7w==", "9b43ee1e-475a-4fad-bf2c-da118eadbe33" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35d93664-c87e-4bd7-ab75-4b8ff555a033", "AQAAAAIAAYagAAAAEATLiBroS0cTBHHoE9eglGA6BNf4KLsBBP7ywjrKY6zcULAO8c86WezbRAxRvJoEVg==", "d5b9dca9-bf19-46ad-8199-ea3cd2f0dce1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "313be394-f6ae-4158-9865-222e5b64f31e", "AQAAAAIAAYagAAAAEPgoETClrAjzkNzcpP6q6QT6SDJd2eyL1aRi1CsJjMZpsmyY30bnBLyY3lg/FUQPng==", "0b740876-dd64-4b99-a2c1-7e6492c55190" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d98f8e6-5c11-4ca2-a251-dc5e6481be6c", "AQAAAAIAAYagAAAAEGGySWfQAKYKZr2SMYFgDm7CSXJuTlWIB/+CCY9cQG5Sg6slbsNJsrYhZFk3EPXWrA==", "b26c3423-6621-4b2a-a270-2fa6ed0121a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce26d04c-b488-4225-b5b3-54c207b8a4dd", "AQAAAAIAAYagAAAAEHMJCEINx0fndbt1ml0VrrMIZ1NqiR9r8LnAaDagbfo1GOeHN/j0wS38IKHNd7gEbg==", "be1e13dc-0ce1-4bf3-81bf-4dcfa6b5964a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0871be9b-9424-4949-9c12-6a57aec5bdcb", "AQAAAAIAAYagAAAAECmDRf6qpLeDqWe4kLnI42YHkcE5Aj9T7WEsbPpNSwX4Vos+rt+1Iy4poBDZs0iIqQ==", "7b53e466-f099-42f6-af34-7e6926e1798f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2bf4011-0752-409d-8f89-5352cd2acde7", "AQAAAAIAAYagAAAAEPBWmd4DTwWb/3vmZlgaWtP7CUYAG9WCuqc9PEBJSUYkZWgBEqacTLor5XbSMhuHmQ==", "a438ab17-fded-4d18-a09a-fa98ca829b0b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18c86c13-e9dd-4e54-87e0-ac91f6eebbca", "AQAAAAIAAYagAAAAEFkJ2gCpa9Hk3lvBs0fQg89lckj4SsF4Wlp51USQuv0sOpfUuwwOB/GusBM/sDwRbw==", "526cae31-f0fd-49ad-b786-e75c0e7a7e0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c38053ca-f95d-4d44-8acd-8b624f0f47e4", "AQAAAAIAAYagAAAAEC94NV+E4wpVUVBgKtNNVuR3AMR26L1Xj78/U7986eSe+qnrziTSoS5PGN88YDpvVg==", "cc8e5ff9-c4f5-45eb-88a8-88ba2b9cb7cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2935cb5d-f2d8-4977-9f7e-429c378ab2e8", "AQAAAAIAAYagAAAAEFe3pZAcAZ1IWWqfEMEQ7qzNxi8DW9H2bwjYZ6XYuF6dfKrCSAgirRF55pgrBv0alA==", "e29cfd3d-062d-447f-b2aa-dbbc9f7b9ef4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72eb8f0f-75e3-4556-840d-cde4bbead7a2", "AQAAAAIAAYagAAAAEB+OIQ73mFl9Uoz0CW5QmL+p3thbBVCpCnm5JQhBT67D3jr1BgJET9PLIGMdq+IEnA==", "81049c0d-7f2f-4daa-867d-db1364d8fac1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "777ba242-7d40-4756-acf0-28fedb4069b0", "AQAAAAIAAYagAAAAEF2C8YjLD8f1OuhawRnseDNR4S1BOwQnRm3Yz76QJ2E1e7y0dAcuZob8CnpFLIrNmg==", "d6236e7b-f1d3-40f4-8d3c-b0e07192a4dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2411ebd1-2b48-4d62-86cc-73ef60c289c3", "AQAAAAIAAYagAAAAEEkyPhc1YaIKm0lvLzjW5ShtvKHlLf2ZmH1nIRrMFmWcu8mdUKLTkd8DqfcdrkKkTw==", "26b73e13-6405-4641-bbed-a298691a873b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84de8075-02a2-4b15-9df6-f8692cc90ba7", "AQAAAAIAAYagAAAAEMj5ksz7XkL4jphdWmuBSvo6kGlxtfPvfdtClqjIrySfx/lyAv2ZPFkR+a5dj9zbvw==", "d177d880-e0ec-439c-82eb-b367b3815a97" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2904e93f-18d7-4a7a-8e6e-890c911dc689", "AQAAAAIAAYagAAAAELwpHLgc94UMnVXjFI5RMromdl4HvkDpTib9kakQQ5tAxX2w3Os7vAzXr5gceKNvxw==", "de587e36-7ca0-4711-9c52-1f96307ab10a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6515fbbb-96a4-46f6-8fff-17a6ae167f8d", "AQAAAAIAAYagAAAAEGGyGK6KFZwzKqI8bJ51/sKC455ejd5ldj2qVhBxGoyOqx6wHHlzZrYoviovye8Q+w==", "17e8ab37-4665-4e24-995a-92a4caeb0f8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23f3f0b7-1f2a-4937-9b3d-ef977fe82618", "AQAAAAIAAYagAAAAEKtgWYplOGuA3Q3CbTuRZk6S0j9/jdwZgmxTa4jTqDBZHTlySbh/J1m1qBbECzKfIg==", "07038511-f96d-4130-9844-2b4332b93779" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "29302c02-83e9-4193-8c67-bf1200ed2afc", "AQAAAAIAAYagAAAAEOsR/1pUaQ2PjYVQzeKz5GIPJifCWrwtm331psno4xgMIU8fpr+qguPfJSK0jRjldg==", "f30f7c71-d7c1-4b23-9aca-5dbbffaee70b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ccc5774-5c26-41eb-b3b0-21b682ce2caa", "AQAAAAIAAYagAAAAECHaAIK6s0qqWCdbxdeZ7X5jzt+zdRrNChuJRftJeDRfea8TgZ6vVIUHBg/Zv9oqug==", "1c1c4abf-ef30-4ae9-a464-3a319b09d223" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebd33281-8822-4de7-861c-997eee492cfc", "AQAAAAIAAYagAAAAEKdSNJ1DkDHwlf09pkPXnpx66vlw8soizUuBV3X0LGjfZ7IC3/3OyyfIP3JjUBGSow==", "8827eaa2-754c-450c-9665-399b91dee039" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "691928c5-e5db-44d7-8667-3f74d0337e76", "AQAAAAIAAYagAAAAEFz58axiE7sKdxaPT02MqRKXcUF3eYhFj7RSLK//vNgD5LY6HBxL/p8vFjVUWavxMw==", "1fbdd7c0-2612-479c-a639-675f89125cbd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7eb1552-5874-46a4-b3b3-2f65f58baa4f", "AQAAAAIAAYagAAAAEBnk9e4ZcPkuzyzrDvTe3g4fOWaWb2PnGS6uS4/SPtYcV/FgB+Av8GgSgbIYMbDVZg==", "56e610b6-2f12-4e6c-a3bc-871d0ad501e1" });

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 1,
                column: "Name",
                value: "Auditor 1");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 2,
                column: "Name",
                value: "Auditor 2");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 3,
                column: "Name",
                value: "Auditor 3");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 4,
                column: "Name",
                value: "Auditor 4");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 5,
                column: "Name",
                value: "Auditor 5");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 6,
                column: "Name",
                value: "Auditor 6");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 7,
                column: "Name",
                value: "Auditor 7");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 8,
                column: "Name",
                value: "Auditor 8");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 9,
                column: "Name",
                value: "Auditor 9");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 10,
                column: "Name",
                value: "Auditor 10");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 11,
                column: "Name",
                value: "Auditor 11");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 12,
                column: "Name",
                value: "Auditor 12");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 13,
                column: "Name",
                value: "Auditor 13");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 14,
                column: "Name",
                value: "Auditor 14");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 15,
                column: "Name",
                value: "Auditor 15");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 16,
                column: "Name",
                value: "Auditor 16");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 17,
                column: "Name",
                value: "Auditor 17");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 18,
                column: "Name",
                value: "Auditor 18");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 19,
                column: "Name",
                value: "Auditor 19");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 20,
                column: "Name",
                value: "Auditor 20");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 21,
                column: "Name",
                value: "Auditor 21");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 22,
                column: "Name",
                value: "Auditor 22");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 23,
                column: "Name",
                value: "Auditor 23");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 24,
                column: "Name",
                value: "Auditor 24");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 25,
                column: "Name",
                value: "Auditor 25");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 26,
                column: "Name",
                value: "Auditor 26");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 27,
                column: "Name",
                value: "Auditor 27");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 28,
                column: "Name",
                value: "Auditor 28");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 29,
                column: "Name",
                value: "Auditor 29");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 30,
                column: "Name",
                value: "Auditor 30");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 31,
                column: "Name",
                value: "Auditor 31");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 32,
                column: "Name",
                value: "Auditor 32");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 33,
                column: "Name",
                value: "Auditor 33");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 34,
                column: "Name",
                value: "Auditor 34");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 35,
                column: "Name",
                value: "Auditor 35");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 36,
                column: "Name",
                value: "Auditor 36");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 37,
                column: "Name",
                value: "Auditor 37");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 38,
                column: "Name",
                value: "Auditor 38");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 39,
                column: "Name",
                value: "Auditor 39");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 40,
                column: "Name",
                value: "Auditor 40");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 41,
                column: "Name",
                value: "Auditor 41");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 42,
                column: "Name",
                value: "Auditor 42");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 43,
                column: "Name",
                value: "Auditor 43");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 44,
                column: "Name",
                value: "Auditor 44");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 45,
                column: "Name",
                value: "Auditor 45");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 46,
                column: "Name",
                value: "Auditor 46");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 47,
                column: "Name",
                value: "Auditor 47");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 48,
                column: "Name",
                value: "Auditor 48");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 49,
                column: "Name",
                value: "Auditor 49");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 50,
                column: "Name",
                value: "Auditor 50");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 51,
                column: "Name",
                value: "Auditor 51");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 52,
                column: "Name",
                value: "Auditor 52");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 53,
                column: "Name",
                value: "Auditor 53");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 54,
                column: "Name",
                value: "Auditor 54");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 55,
                column: "Name",
                value: "Auditor 55");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 56,
                column: "Name",
                value: "Auditor 56");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 57,
                column: "Name",
                value: "Auditor 57");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 58,
                column: "Name",
                value: "Auditor 58");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 59,
                column: "Name",
                value: "Auditor 59");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 60,
                column: "Name",
                value: "Auditor 60");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 61,
                column: "Name",
                value: "Auditor 61");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 62,
                column: "Name",
                value: "Auditor 62");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 63,
                column: "Name",
                value: "Auditor 63");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 64,
                column: "Name",
                value: "Auditor 64");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 65,
                column: "Name",
                value: "Auditor 65");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 66,
                column: "Name",
                value: "Auditor 66");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 67,
                column: "Name",
                value: "Auditor 67");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 68,
                column: "Name",
                value: "Auditor 68");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 69,
                column: "Name",
                value: "Auditor 69");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 70,
                column: "Name",
                value: "Auditor 70");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 71,
                column: "Name",
                value: "Auditor 71");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 72,
                column: "Name",
                value: "Auditor 72");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 73,
                column: "Name",
                value: "Auditor 73");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 74,
                column: "Name",
                value: "Auditor 74");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 75,
                column: "Name",
                value: "Auditor 75");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 76,
                column: "Name",
                value: "Auditor 76");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 77,
                column: "Name",
                value: "Auditor 77");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 78,
                column: "Name",
                value: "Auditor 78");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 79,
                column: "Name",
                value: "Auditor 79");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 80,
                column: "Name",
                value: "Auditor 80");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 81,
                column: "Name",
                value: "Auditor 81");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 82,
                column: "Name",
                value: "Auditor 82");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 83,
                column: "Name",
                value: "Auditor 83");

            migrationBuilder.UpdateData(
                table: "Auditors",
                keyColumn: "Id",
                keyValue: 84,
                column: "Name",
                value: "Auditor 84");

            migrationBuilder.CreateIndex(
                name: "IX_AuditScheduleDetails_OfficeId",
                table: "AuditScheduleDetails",
                column: "OfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
