using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261106090000_AddAuditSummaryFindingSource")]
    public partial class AddAuditSummaryFindingSource : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AuditChecklistId",
                table: "AuditSummaryFIndings",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "CriteriaText",
                table: "AuditSummaryFIndings",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NcarReferenceNumber",
                table: "AuditSummaryFIndings",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AuditChecklistId",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropColumn(
                name: "CriteriaText",
                table: "AuditSummaryFIndings");

            migrationBuilder.DropColumn(
                name: "NcarReferenceNumber",
                table: "AuditSummaryFIndings");
        }
    }
}
