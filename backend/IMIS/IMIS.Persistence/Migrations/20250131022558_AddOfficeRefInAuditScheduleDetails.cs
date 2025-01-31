using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddOfficeRefInAuditScheduleDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "OfficeId",
                table: "AuditSchduleDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "db2f130e-94ac-4142-9e51-061ab4e36119");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "017a0e8f-3f3a-4f95-85b1-fa8e2b816b82", "AQAAAAIAAYagAAAAEAhLQc3sMKB72K4Qv3l4dBzOkXvgLoXVgNK6Sc0osUnOSRSULQQ5ioBj++fTXh7eFQ==", "ceddfc4f-d2f2-4700-8a19-bda2408138e9" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchduleDetails_OfficeId",
                table: "AuditSchduleDetails",
                column: "OfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchduleDetails_Offices_OfficeId",
                table: "AuditSchduleDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchduleDetails_Offices_OfficeId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropIndex(
                name: "IX_AuditSchduleDetails_OfficeId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropColumn(
                name: "OfficeId",
                table: "AuditSchduleDetails");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "ee8dca77-645d-42ce-aae7-86b3acd4c13d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ecca9bc-066a-4c42-8f96-464f847d9da6", "AQAAAAIAAYagAAAAECGuiRlQNI0+5L1qQUSbUiSPSOGw6wOoOQ8JOTjkTW8oP9S8N13BBfbvn/vEbGXfdg==", "ffc50297-9024-44bc-b7a7-d2605ca02ebd" });
        }
    }
}
