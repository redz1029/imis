using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsProjectAuditDetailsDtoAddPgsPeriodDtoAndOfficeDto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "f31bc2d2-5cdb-4764-b64b-5c1efd72e7a7");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7d1e2df8-4d60-4c21-a604-11d2c5c3bfbf", "AQAAAAIAAYagAAAAEKYNPz6ycrWGeAWicPcUNwUjjxm4KVhQ728qJRSDYEoJimmVjeRDcj+eyI9IzetFxw==", "e9d7bbdc-3f6c-4b15-8e08-e38a85505566" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "595b1c58-6d24-43fa-a2e9-0d2acc242f51");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ac1694c-a986-4a63-82df-7a95908cb33c", "AQAAAAIAAYagAAAAELeqzfIytUnrfcvnYMu959mXDxlqvok8npjno+jycsNrvGvRB6zV+hTquS7rp2YGZQ==", "ed2718f7-d5c8-4e00-8b17-2e3bfbe6e9b6" });
        }
    }
}
