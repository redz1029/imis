using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePGSClassNameAndDto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectStatusId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus");

            migrationBuilder.DropIndex(
                name: "IX_Deliverable_PgsProjectStatusId",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "PgsProjectStatusId",
                table: "Deliverable");

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

            migrationBuilder.AddColumn<long>(
                name: "PgsProjectAuditId",
                table: "Deliverable",
                type: "bigint",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "1ec144bf-938f-419f-8280-a1929e96605d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff7340bd-2622-411b-bc7e-42cb1680a98e", "AQAAAAIAAYagAAAAEDRdyHF9HFe6rMUncL1p7S2qZKA0hEPbc5YuDpjSGotvJf8mU98GpOmhhtA62jWLpQ==", "38a9d780-f921-4115-9c1e-d6bf4185a231" });

            migrationBuilder.CreateIndex(
                name: "IX_Deliverable_PgsProjectAuditId",
                table: "Deliverable",
                column: "PgsProjectAuditId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectAuditId",
                table: "Deliverable",
                column: "PgsProjectAuditId",
                principalTable: "PgsProjectStatus",
                principalColumn: "Id");

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
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectAuditId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus");

            migrationBuilder.DropIndex(
                name: "IX_Deliverable_PgsProjectAuditId",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "PgsProjectAuditId",
                table: "Deliverable");

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

            migrationBuilder.AddColumn<long>(
                name: "PgsProjectStatusId",
                table: "Deliverable",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "0d5a6efe-584a-44a4-bee2-e53a8aa214cb");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25214e1c-ee66-4679-ab12-84414ef1eb2a", "AQAAAAIAAYagAAAAEOW8Z9RoeYMpq/ziqF/Sf1o41WfSVFWJZZNmboVox25i6ZH90xc+Zf/XzdQeIB35CQ==", "2c2b22e6-9f17-4e36-8d79-7a68164a6824" });

            migrationBuilder.CreateIndex(
                name: "IX_Deliverable_PgsProjectStatusId",
                table: "Deliverable",
                column: "PgsProjectStatusId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectStatusId",
                table: "Deliverable",
                column: "PgsProjectStatusId",
                principalTable: "PgsProjectStatus",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

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
