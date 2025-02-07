using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateOfficeClassName : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "9cff41d8-fe2a-4afe-af95-edc51ba1a425");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c1a3ce2-7ecf-4b8a-ac00-95bd3ee6dbb7", "AQAAAAIAAYagAAAAEPbVMxqX6SghHKzVK0tEbVDRfpLKEirUw7MpGwmpZxl0rWgRilM1FWhMEdtLvNUFtQ==", "85589f4d-0755-4226-8286-26fbf66d5182" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "62e99d3d-aa73-437c-bcc6-314bc6d58dc2");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1968a47-67b8-41dc-84cf-ff53227fd824", "AQAAAAIAAYagAAAAECa5CqfC/ClPSDbWw2erp6MazcmyvIcy+IGEnKfRHvL5HRb6X91irXDJrbRWFcB+UA==", "156883ad-77df-460e-9d0f-6700a91b268b" });
        }
    }
}
