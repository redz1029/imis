using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsPeriodAndOffice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "b47d3df5-59c3-4710-bad0-e4aca7dcefc6");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5956f1b6-679b-4e8f-80e0-bf7f46248296", "AQAAAAIAAYagAAAAEDJTsWBWUML+9qyFAvn02KghL94zZ4T1NQ2AO8Pq7Rs9uSsN6HCwniF2cksZbzZFkA==", "160a8e02-42b1-48bd-80ca-5fc43c00dc87" });
        }
    }
}
