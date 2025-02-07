using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsPeriodDtoAndOfficeDto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "a6163233-c8f5-4cef-b3ff-29df5ce7671a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c64a1f57-d095-46ec-80c1-ce43c11c7296", "AQAAAAIAAYagAAAAEOVnzAQxzlKVVHyq6jYfE+MI3u7siAAm5dEZUInWjL/irCKGeWCfA00bWGSkqmrvUQ==", "a8dcb740-c0ae-4b60-adc3-89dea59600df" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
    }
}
