using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsAuditDetailsAndKra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsAuditDetailsId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_Offices_OfficeId",
                table: "PgsProjectStatus");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                table: "PgsProjectStatus");

            migrationBuilder.DropTable(
                name: "Kra");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PgsProjectStatus",
                table: "PgsProjectStatus");

            migrationBuilder.DropColumn(
                name: "Status",
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

            migrationBuilder.AlterColumn<string>(
                name: "Remarks",
                table: "PgsAuditDetails",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<int>(
                name: "PgsPeriodId",
                table: "PgsAuditDetails",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "OfficeId",
                table: "PgsAuditDetails",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_PgsAuditDetails",
                table: "PgsAuditDetails",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "KeyResultArea",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KeyResultArea", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "021c20ed-7863-46dc-8bf8-b22f87943203");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68060113-21d8-489b-8ccb-f1100ba58d26", "AQAAAAIAAYagAAAAEMNt0lY+vYpU1Iwxu/lbolLEPy/2nxoV7tItYGhOmctCUuGlY4X88oWce6DZ06DDFQ==", "5ee80b2f-981f-444a-8dea-9e22ad540625" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_KeyResultArea_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "KeyResultArea",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsAuditDetailsId",
                table: "Deliverable",
                column: "PgsAuditDetailsId",
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
                name: "FK_Deliverable_KeyResultArea_KraId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsAuditDetailsId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_Offices_OfficeId",
                table: "PgsAuditDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsPeriod_PgsPeriodId",
                table: "PgsAuditDetails");

            migrationBuilder.DropTable(
                name: "KeyResultArea");

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

            migrationBuilder.AlterColumn<string>(
                name: "Remarks",
                table: "PgsProjectStatus",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

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

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "PgsProjectStatus",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_PgsProjectStatus",
                table: "PgsProjectStatus",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "Kra",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kra", x => x.Id);
                });

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

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "Kra",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsAuditDetailsId",
                table: "Deliverable",
                column: "PgsAuditDetailsId",
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
    }
}
