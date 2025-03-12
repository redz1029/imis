using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateUserAddNewField : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd");

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "AspNetUsers",
                type: "nvarchar(13)",
                maxLength: 13,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LastName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "MiddleName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Position",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Prefix",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Suffix",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "4b8606fa-cf96-42ed-b9dd-e0679bfea2ac");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "475e45a8-4dd9-425c-b405-b6598ef700fd", 0, "763c74c4-5e2f-480c-8aff-ec9e1de0ec58", "IdentityUser", "ADMIN@MAIL.COM", false, false, null, "ADMIN@MAIL.COM", "ADMIN", "AQAAAAIAAYagAAAAEJNIMKakk4PwH7A/D9A1H/wt09RaO88tzGJ/QCg6MV82SUK+ZFwLQUk/bc41JaMa3w==", null, false, "a7cf8a31-e4d3-4c50-83fc-732581748e2a", false, "admin" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "LastName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "MiddleName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Position",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Prefix",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Suffix",
                table: "AspNetUsers");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "26919607-483d-490f-a285-746ebd469c46");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1a7fe17f-3139-4a67-b276-870b47006e28", "AQAAAAIAAYagAAAAEIEIrZEAvDwdIi80CqLpllHQtoZIoh2B0snUDmBMJSmVVRl7QXBEl0dvKPCNlQkm0w==", "16849971-19f9-46e2-8be2-d6ef4e65f5bd" });
        }
    }
}
