using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePGSAuditScheduleDetailDtoAndOfficeDto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "9cff41d8-fe2a-4afe-af95-edc51ba1a425");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c1a3ce2-7ecf-4b8a-ac00-95bd3ee6dbb7", "AQAAAAIAAYagAAAAEPbVMxqX6SghHKzVK0tEbVDRfpLKEirUw7MpGwmpZxl0rWgRilM1FWhMEdtLvNUFtQ==", "85589f4d-0755-4226-8286-26fbf66d5182" });
        }
    }
}
