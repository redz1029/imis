using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateOfficeEndPoint : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "65a32621-02c6-4a7c-b818-a57a0b637e13");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8f8b43d-73e8-4872-83df-484a3d87c6b7", "AQAAAAIAAYagAAAAECDGMC303bvkUezJxame/vU5lqlp3EcxYx/ECQe/gxjWgJJKA9iweiytlFeG2wYhHw==", "b5d0f944-ef9d-4512-9dba-3f4b063d6677" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "4eb0545b-8139-475c-93d6-38102ec69e48");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe529114-8c0a-4074-b5e1-715c6a07e139", "AQAAAAIAAYagAAAAEKj7PzabL54854jOYc144dwSe+YL5Qv/hosjVh+D2L96xp4uS1xJ4IzoMGh0HrWeyQ==", "60f46fcb-334c-4d80-9bfa-6c08028eb7bf" });
        }
    }
}
