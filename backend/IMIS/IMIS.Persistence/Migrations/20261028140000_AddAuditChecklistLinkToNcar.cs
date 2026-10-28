using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261028140000_AddAuditChecklistLinkToNcar")]
    public partial class AddAuditChecklistLinkToNcar : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AuditChecklistId",
                table: "NonconformingActionReports",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_NonconformingActionReports_AuditChecklistId",
                table: "NonconformingActionReports",
                column: "AuditChecklistId",
                unique: true,
                filter: "[AuditChecklistId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_NonconformingActionReports_AuditChecklist_AuditChecklistId",
                table: "NonconformingActionReports",
                column: "AuditChecklistId",
                principalTable: "AuditChecklist",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_NonconformingActionReports_AuditChecklist_AuditChecklistId",
                table: "NonconformingActionReports");

            migrationBuilder.DropIndex(
                name: "IX_NonconformingActionReports_AuditChecklistId",
                table: "NonconformingActionReports");

            migrationBuilder.DropColumn(
                name: "AuditChecklistId",
                table: "NonconformingActionReports");
        }
    }
}
