using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsAuditDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "7b578a32-fa13-450e-a7d6-d540d48ced97");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c447466-4883-41a6-b117-447f7fc3d9d4", "AQAAAAIAAYagAAAAELj1WbNLT1GcWbiELgAYk9D9b7jM0dPMZp8fctzwKUZ3g4yutBtJ4De/bBMwAtUgNQ==", "f0587f61-daef-453a-80ce-e71672df5e76" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "72277c97-b621-4c5b-961d-ab3ff962b08a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5328c3f-9855-4164-a617-7d422dab0937", "AQAAAAIAAYagAAAAELct53PYWBrZWZXTKLYW0W5j315Us2qqrDDSzQHdx2l4MMGuMzROqFxQWhfjBgQ//A==", "d03a2566-f36d-4bab-97aa-0268f4170953" });
        }
    }
}
