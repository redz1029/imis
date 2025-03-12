using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUserOffice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserOffices_AspNetUsers_UserId",
                table: "UserOffices");

            migrationBuilder.DropForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices");

            migrationBuilder.DropIndex(
                name: "IX_UserOffices_OfficeId",
                table: "UserOffices");

            migrationBuilder.DropIndex(
                name: "IX_UserOffices_UserId",
                table: "UserOffices");

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

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "UserOffices",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd");

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "UserOffices",
                type: "nvarchar(450)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

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
                value: "f6d41030-d518-47bc-b54f-4ed90e199e44");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "475e45a8-4dd9-425c-b405-b6598ef700fd", 0, "a25a957d-3420-485a-bbd4-1929976b456a", "IdentityUser", "ADMIN@MAIL.COM", false, false, null, "ADMIN@MAIL.COM", "ADMIN", "AQAAAAIAAYagAAAAEHq/QowiwWUIIBpx57QFCAuF521LHWAE8QceP+Ri1N/GkIaSRI33SnznSq7PjnrLmA==", null, false, "4a484f89-9495-4f01-b197-75c227f53c52", false, "admin" });

            migrationBuilder.CreateIndex(
                name: "IX_UserOffices_OfficeId",
                table: "UserOffices",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_UserOffices_UserId",
                table: "UserOffices",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_UserOffices_AspNetUsers_UserId",
                table: "UserOffices",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
