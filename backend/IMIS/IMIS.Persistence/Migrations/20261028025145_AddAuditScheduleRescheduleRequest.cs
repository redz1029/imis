using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAuditScheduleRescheduleRequest : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AuditScheduleRescheduleRequests",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditScheduleId = table.Column<int>(type: "int", nullable: false),
                    ProposedStartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RequestedByUserId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RequestedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TeamLeaderUserId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TeamLeaderDecisionDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TeamLeaderRemarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LeadAuditorUserId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LeadAuditorDecisionDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    LeadAuditorRemarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditScheduleRescheduleRequests", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditScheduleRescheduleRequests_AuditSchedules_AuditScheduleId",
                        column: x => x.AuditScheduleId,
                        principalTable: "AuditSchedules",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AuditScheduleRescheduleRequests_AuditScheduleId",
                table: "AuditScheduleRescheduleRequests",
                column: "AuditScheduleId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuditScheduleRescheduleRequests");
        }
    }
}
