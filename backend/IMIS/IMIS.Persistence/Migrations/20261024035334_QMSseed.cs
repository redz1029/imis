using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class QMSseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Schema and seed data in this migration were already present in the
            // database from earlier migrations. Kept as a no-op so it can be
            // recorded in __EFMigrationsHistory without replaying the stale
            // snapshot diff (which tried to drop constraints that no longer exist).
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
        }
    }
}
