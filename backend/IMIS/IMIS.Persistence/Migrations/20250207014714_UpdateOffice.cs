using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateOffice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "ff4fca05-b1b8-4833-a0d1-25dae6e10699");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd60247b-d616-471e-a76e-bbaadd583f56", "AQAAAAIAAYagAAAAEEjXKqYuUn6f7Yyd12cZziMGB1teLv7klE5tfZWIqoqR2zeXioTLcBqcfEVSwnWHag==", "9ec9a6fe-533d-49a8-a18d-29b596864edd" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
    }
}
