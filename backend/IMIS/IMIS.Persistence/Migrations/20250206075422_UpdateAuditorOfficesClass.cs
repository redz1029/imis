using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateAuditorOfficesClass : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "b47d3df5-59c3-4710-bad0-e4aca7dcefc6");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5956f1b6-679b-4e8f-80e0-bf7f46248296", "AQAAAAIAAYagAAAAEDJTsWBWUML+9qyFAvn02KghL94zZ4T1NQ2AO8Pq7Rs9uSsN6HCwniF2cksZbzZFkA==", "160a8e02-42b1-48bd-80ca-5fc43c00dc87" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "455a3a82-5bcb-4a89-b8cf-ad6de935d7b8");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5c990a3-1aa6-414a-aa48-72dcb69fe700", "AQAAAAIAAYagAAAAEPOrvte8oKFQHJ9Al8IuGH95xjk1D8kU0CwUVSNVYBbv7x+n8gwnahtneYAi/WrBuw==", "8b9eb423-0f36-40da-b0c3-b7d70e5b0a0c" });
        }
    }
}
