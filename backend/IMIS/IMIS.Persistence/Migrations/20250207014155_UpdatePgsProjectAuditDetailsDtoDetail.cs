using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsProjectAuditDetailsDtoDetail : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "697d719b-1c8a-4c43-9c1d-862d88e8f4cd");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc62cd9a-2618-43ea-81bb-875aac625893", "AQAAAAIAAYagAAAAEKpgXiRv29gc6Mzje7+ixr3divNllQHCfhFFTJswXNG0XdeTlrkXDHzZoRzM5VR7LA==", "89589b6c-6ba1-491a-81f3-4352f4867148" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "576f7c6a-89be-4971-a3ee-d42185e5b678");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8794d3a9-de1f-4e35-8ed6-24fb68969249", "AQAAAAIAAYagAAAAEAzog2QlyG1KPrOJvAGFYoY/buMHYBr2p2kcFbfOdEuUjseuI5qhRtTt4SsjYxY0uw==", "96a8548e-6d09-4c66-aeda-3c67ea11b56c" });
        }
    }
}
