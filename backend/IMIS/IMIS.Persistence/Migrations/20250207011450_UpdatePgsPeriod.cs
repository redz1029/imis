using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsPeriod : Migration
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
                value: "576f7c6a-89be-4971-a3ee-d42185e5b678");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8794d3a9-de1f-4e35-8ed6-24fb68969249", "AQAAAAIAAYagAAAAEAzog2QlyG1KPrOJvAGFYoY/buMHYBr2p2kcFbfOdEuUjseuI5qhRtTt4SsjYxY0uw==", "96a8548e-6d09-4c66-aeda-3c67ea11b56c" });

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
                value: "d743eaf7-b98a-465f-94ed-59371fb39fd9");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a15c2478-57e6-4b1b-9830-e2254f73847b", "AQAAAAIAAYagAAAAEOo6CO1AdeaoN64V8rLYn22Qn/mJ32uZadG6DbZtuETFc1x8abinPHQOa+Jd7zj3gw==", "cdf64f00-d633-4b81-b7aa-e1c1a0751949" });

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
    }
}
