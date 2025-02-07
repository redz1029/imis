using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateClassNamePgsAuditDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectAuditId",
                table: "Deliverable");

            migrationBuilder.RenameColumn(
                name: "PgsProjectAuditId",
                table: "Deliverable",
                newName: "PgsAuditDetailsId");

            migrationBuilder.RenameIndex(
                name: "IX_Deliverable_PgsProjectAuditId",
                table: "Deliverable",
                newName: "IX_Deliverable_PgsAuditDetailsId");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "4eb0545b-8139-475c-93d6-38102ec69e48");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe529114-8c0a-4074-b5e1-715c6a07e139", "AQAAAAIAAYagAAAAEKj7PzabL54854jOYc144dwSe+YL5Qv/hosjVh+D2L96xp4uS1xJ4IzoMGh0HrWeyQ==", "60f46fcb-334c-4d80-9bfa-6c08028eb7bf" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsAuditDetailsId",
                table: "Deliverable",
                column: "PgsAuditDetailsId",
                principalTable: "PgsProjectStatus",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsAuditDetailsId",
                table: "Deliverable");

            migrationBuilder.RenameColumn(
                name: "PgsAuditDetailsId",
                table: "Deliverable",
                newName: "PgsProjectAuditId");

            migrationBuilder.RenameIndex(
                name: "IX_Deliverable_PgsAuditDetailsId",
                table: "Deliverable",
                newName: "IX_Deliverable_PgsProjectAuditId");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "03538be3-b337-4431-8f9b-bd98aeab3525");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dade41e1-e3b0-47ee-bf02-9b9174369312", "AQAAAAIAAYagAAAAEOdT6nGCk28H1zauDH35x4HWJOu7fXM7CwfUmm4wJbU7KVc4+1+xc4Tc0ZH5mU3n5w==", "0a36cc5f-5b5b-4190-b2af-325c10463e66" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsProjectStatus_PgsProjectAuditId",
                table: "Deliverable",
                column: "PgsProjectAuditId",
                principalTable: "PgsProjectStatus",
                principalColumn: "Id");
        }
    }
}
