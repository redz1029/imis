using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddedLinkageOfAuditScheduleToAuditSchduleDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "ee8dca77-645d-42ce-aae7-86b3acd4c13d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ecca9bc-066a-4c42-8f96-464f847d9da6", "AQAAAAIAAYagAAAAECGuiRlQNI0+5L1qQUSbUiSPSOGw6wOoOQ8JOTjkTW8oP9S8N13BBfbvn/vEbGXfdg==", "ffc50297-9024-44bc-b7a7-d2605ca02ebd" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
        }
    }
}
