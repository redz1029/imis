using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAuditableOffices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Auditors_AuditSchduleDetails_AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.DropIndex(
                name: "IX_Auditors_AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.DropColumn(
                name: "AuditSchduleDetailsId",
                table: "Auditors");

            migrationBuilder.CreateTable(
                name: "AuditableOffices",
                columns: table => new
                {
                    AuditScheduleId = table.Column<int>(type: "int", nullable: false),
                    OfficeId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditableOffices", x => new { x.AuditScheduleId, x.OfficeId });
                    table.ForeignKey(
                        name: "FK_AuditableOffices_AuditSchedules_AuditScheduleId",
                        column: x => x.AuditScheduleId,
                        principalTable: "AuditSchedules",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AuditableOffices_Offices_OfficeId",
                        column: x => x.OfficeId,
                        principalTable: "Offices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "c7bb1a90-5ce5-4fad-860f-c260e2c94a50");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb34d97b-fc43-4cf8-ab3e-f1f89b19540b", "AQAAAAIAAYagAAAAEKi1GUCFyNaVBFjSVuFcTgIE/D4O0LHIN4K1cMS/BfrC5q37gPVoy/Tj3aCwEgr8Ig==", "1e8040ae-e735-4e05-805c-08b1801d21af" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchduleDetails_TeamId",
                table: "AuditSchduleDetails",
                column: "TeamId");

            migrationBuilder.CreateIndex(
                name: "IX_AuditableOffices_OfficeId",
                table: "AuditableOffices",
                column: "OfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchduleDetails_Teams_TeamId",
                table: "AuditSchduleDetails",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchduleDetails_Teams_TeamId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropTable(
                name: "AuditableOffices");

            migrationBuilder.DropIndex(
                name: "IX_AuditSchduleDetails_TeamId",
                table: "AuditSchduleDetails");

            migrationBuilder.AddColumn<int>(
                name: "AuditSchduleDetailsId",
                table: "Auditors",
                type: "int",
                nullable: true);

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

            migrationBuilder.AddForeignKey(
                name: "FK_Auditors_AuditSchduleDetails_AuditSchduleDetailsId",
                table: "Auditors",
                column: "AuditSchduleDetailsId",
                principalTable: "AuditSchduleDetails",
                principalColumn: "Id");
        }
    }
}
