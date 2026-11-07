using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261107090000_AddNcarFindingEditedByAuditor")]
    public partial class AddNcarFindingEditedByAuditor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "FindingEditedByAuditor",
                table: "NonconformingActionReports",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FindingEditedByAuditor",
                table: "NonconformingActionReports");
        }
    }
}
