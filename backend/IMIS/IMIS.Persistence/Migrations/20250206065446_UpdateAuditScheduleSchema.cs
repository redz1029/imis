using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateAuditScheduleSchema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "262fa398-79d5-41ce-a67a-1e25360fb9f9");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fa726c0-6ef3-44c3-a2b5-dfcbf1a1b459", "AQAAAAIAAYagAAAAEFeZXqKh6qCdkPgIv2Zo+MWgCtPwMT2ZgXe7UeWe7Y//gzcb8sLPiQhl5SkqvxQ2cA==", "dd2c8c87-7a9b-4bb1-99d6-8e5b4288c37a" });
        }
    }
}
