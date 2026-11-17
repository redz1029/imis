using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261117090000_AddAuditChecklistFindingType")]
    public partial class AddAuditChecklistFindingType : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // NC or OFI of a "N" checklist row. Rows saved before this existed
            // stay null and count as NC.
            migrationBuilder.AddColumn<string>(
                name: "FindingType",
                table: "AuditChecklist",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FindingType",
                table: "AuditChecklist");
        }
    }
}
