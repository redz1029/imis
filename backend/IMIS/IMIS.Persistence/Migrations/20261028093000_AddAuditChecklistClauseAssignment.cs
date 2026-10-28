using System;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261028093000_AddAuditChecklistClauseAssignment")]
    public partial class AddAuditChecklistClauseAssignment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AuditChecklistClauseAssignments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditScheduleId = table.Column<int>(type: "int", nullable: false),
                    IsoStandardId = table.Column<long>(type: "bigint", nullable: false),
                    AuditorId = table.Column<int>(type: "int", nullable: false),
                    AssignedByUserId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    AssignedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditChecklistClauseAssignments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditChecklistClauseAssignments_AuditSchedules_AuditScheduleId",
                        column: x => x.AuditScheduleId,
                        principalTable: "AuditSchedules",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditChecklistClauseAssignments_Auditors_AuditorId",
                        column: x => x.AuditorId,
                        principalTable: "Auditors",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AuditChecklistClauseAssignments_IsoStandards_IsoStandardId",
                        column: x => x.IsoStandardId,
                        principalTable: "IsoStandards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklistClauseAssignments_AuditScheduleId",
                table: "AuditChecklistClauseAssignments",
                column: "AuditScheduleId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklistClauseAssignments_AuditorId",
                table: "AuditChecklistClauseAssignments",
                column: "AuditorId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditChecklistClauseAssignments_IsoStandardId",
                table: "AuditChecklistClauseAssignments",
                column: "IsoStandardId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuditChecklistClauseAssignments");
        }
    }
}