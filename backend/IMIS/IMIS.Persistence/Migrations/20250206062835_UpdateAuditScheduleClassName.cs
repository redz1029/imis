using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateAuditScheduleClassName : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "262fa398-79d5-41ce-a67a-1e25360fb9f9");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fa726c0-6ef3-44c3-a2b5-dfcbf1a1b459", "AQAAAAIAAYagAAAAEFeZXqKh6qCdkPgIv2Zo+MWgCtPwMT2ZgXe7UeWe7Y//gzcb8sLPiQhl5SkqvxQ2cA==", "dd2c8c87-7a9b-4bb1-99d6-8e5b4288c37a" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
        }
    }
}
