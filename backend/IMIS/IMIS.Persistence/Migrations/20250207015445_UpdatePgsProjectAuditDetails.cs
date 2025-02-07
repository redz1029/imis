using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsProjectAuditDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
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

            migrationBuilder.DropPrimaryKey(
                name: "PK_PgsProjectStatus",
                table: "PgsProjectStatus");

            migrationBuilder.RenameTable(
                name: "PgsProjectStatus",
                newName: "PgsAuditDetails");

            migrationBuilder.RenameIndex(
                name: "IX_PgsProjectStatus_PgsPeriodId",
                table: "PgsAuditDetails",
                newName: "IX_PgsAuditDetails_PgsPeriodId");

            migrationBuilder.RenameIndex(
                name: "IX_PgsProjectStatus_OfficeId",
                table: "PgsAuditDetails",
                newName: "IX_PgsAuditDetails_OfficeId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PgsAuditDetails",
                table: "PgsAuditDetails",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "b42e497e-fd68-4125-bac2-460e6f004a16");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f31606fd-fdf4-46d5-bbdd-5060cc51c381", "AQAAAAIAAYagAAAAEJ+FPhcbnKuXZbiKFpneSaaunMlOEVVlHrnCkzrTaXinlugxs4cAeiF/8/nZZ15ZOQ==", "167b6fc8-86f6-4ae1-a789-04e1584f8a54" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsProjectAuditId",
                table: "Deliverable",
                column: "PgsProjectAuditId",
                principalTable: "PgsAuditDetails",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_PgsAuditDetails_Offices_OfficeId",
                table: "PgsAuditDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PgsAuditDetails_PgsPeriod_PgsPeriodId",
                table: "PgsAuditDetails",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsProjectAuditId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_Offices_OfficeId",
                table: "PgsAuditDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsPeriod_PgsPeriodId",
                table: "PgsAuditDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PgsAuditDetails",
                table: "PgsAuditDetails");

            migrationBuilder.RenameTable(
                name: "PgsAuditDetails",
                newName: "PgsProjectStatus");

            migrationBuilder.RenameIndex(
                name: "IX_PgsAuditDetails_PgsPeriodId",
                table: "PgsProjectStatus",
                newName: "IX_PgsProjectStatus_PgsPeriodId");

            migrationBuilder.RenameIndex(
                name: "IX_PgsAuditDetails_OfficeId",
                table: "PgsProjectStatus",
                newName: "IX_PgsProjectStatus_OfficeId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PgsProjectStatus",
                table: "PgsProjectStatus",
                column: "Id");

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
