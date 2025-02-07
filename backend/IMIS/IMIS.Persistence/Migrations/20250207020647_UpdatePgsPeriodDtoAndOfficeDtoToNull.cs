using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsPeriodDtoAndOfficeDtoToNull : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus");

            migrationBuilder.AlterColumn<int>(
                name: "PgsPeriodId",
                table: "PgsProjectStatus",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "OfficeId",
                table: "PgsProjectStatus",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

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

            migrationBuilder.AddForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus");

            migrationBuilder.AlterColumn<int>(
                name: "PgsPeriodId",
                table: "PgsProjectStatus",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "OfficeId",
                table: "PgsProjectStatus",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "f23ac7a4-9f68-4b98-b2c4-c410bfcd9476");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7927ad95-c519-4de7-bf77-fd14ca3720f3", "AQAAAAIAAYagAAAAEJh0DD8vODCbba5Ht1GUN8xTYWQeOFIyfG5Fz9D8kICIiRNk7cpjbHOFw5N+rwCIBA==", "2ec6e34e-e142-4a67-a999-e682b2e22c1d" });

            migrationBuilder.AddForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
