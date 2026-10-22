using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedQMSRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Only the new QMS role is inserted. The other seeded roles/users
            // are intentionally left untouched: their ConcurrencyStamp /
            // SecurityStamp / PasswordHash values are non-deterministic
            // (Guid.NewGuid() + random salt) so re-writing them would churn
            // every row on each migration for no benefit.
            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Discriminator", "Name", "NormalizedName" },
                values: new object[] { "7f3c91a2-6e45-4b8d-a127-93d5c8e634eg", "6f2b8c31-4d5a-4f7e-9c81-2a7b3d6e9f04", "IdentityRole", "QMS", "QMS" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7f3c91a2-6e45-4b8d-a127-93d5c8e634eg");
        }
    }
}
