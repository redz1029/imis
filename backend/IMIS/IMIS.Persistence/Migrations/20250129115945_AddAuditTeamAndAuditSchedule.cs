using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAuditTeamAndAuditSchedule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AuditSchduleDetailsId",
                table: "Auditors",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "AuditSchedules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    AuditTitle = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditSchedules", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Teams",
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
                    table.PrimaryKey("PK_Teams", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AuditSchduleDetails",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuditScheduleId = table.Column<int>(type: "int", nullable: false),
                    StartDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TeamId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditSchduleDetails", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AuditSchduleDetails_AuditSchedules_AuditScheduleId",
                        column: x => x.AuditScheduleId,
                        principalTable: "AuditSchedules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AuditoTeams",
                columns: table => new
                {
                    TeamId = table.Column<int>(type: "int", nullable: false),
                    AuditorId = table.Column<int>(type: "int", nullable: false),
                    IsTeamLeader = table.Column<bool>(type: "bit", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditoTeams", x => new { x.AuditorId, x.TeamId });
                    table.ForeignKey(
                        name: "FK_AuditoTeams_Auditors_AuditorId",
                        column: x => x.AuditorId,
                        principalTable: "Auditors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AuditoTeams_Teams_TeamId",
                        column: x => x.TeamId,
                        principalTable: "Teams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "2e50ebf7-65f5-4285-bb04-b7c281310b5f");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be6dab47-6cf9-41d4-bb08-9a7e9b4ee47c", "AQAAAAIAAYagAAAAEGA+s7Tc8VBzvdJ8cVoE9K4rjStA983Ea8AJ/KlvTko8fSe2YkCcmMTVFqvRYJb/8Q==", "9f5a1723-6a6f-4cf5-9154-0687cd38943b" });

            migrationBuilder.CreateIndex(
                name: "IX_Auditors_AuditSchduleDetailsId",
                table: "Auditors",
                column: "AuditSchduleDetailsId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditoTeams_TeamId",
                table: "AuditoTeams",
                column: "TeamId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchduleDetails_AuditScheduleId",
                table: "AuditSchduleDetails",
                column: "AuditScheduleId");

            migrationBuilder.AddForeignKey(
                name: "FK_Auditors_AuditSchduleDetails_AuditSchduleDetailsId",
                table: "Auditors",
                column: "AuditSchduleDetailsId",
                principalTable: "AuditSchduleDetails",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Auditors_AuditSchduleDetails_AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.DropTable(
                name: "AuditoTeams");

            migrationBuilder.DropTable(
                name: "AuditSchduleDetails");

            migrationBuilder.DropTable(
                name: "Teams");

            migrationBuilder.DropTable(
                name: "AuditSchedules");

            migrationBuilder.DropIndex(
                name: "IX_Auditors_AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.DropColumn(
                name: "AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "bf23e206-3495-4444-b816-9854ee217823");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe3be3cd-a2e4-4cf2-a7d5-39fafbaf1abc", "AQAAAAIAAYagAAAAEJCjnxcRukiCaFqyKY161ShiN0RR9aDU6wwnPLpGU8MvqCoLKHorOoO6pF2alG23Ng==", "6c476f40-372f-441c-b200-f621cb63a075" });
        }
    }
}
