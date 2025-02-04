using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class PGS : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PGS",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Year = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KRA_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Direct_1 = table.Column<bool>(type: "bit", nullable: false),
                    Indirect_1 = table.Column<bool>(type: "bit", nullable: false),
                    Delivarables_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ByWhen_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Percent_Deliverables = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PGS", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "f751e1b3-2b58-464a-9efe-c2ec4de08909");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a25d27a4-3ed1-4876-9310-a2996df733b5", "AQAAAAIAAYagAAAAEP3Aw5JUQ1dYsbuWba2ylAzVXq+0jYuyprscRwqzZEuOrEn9iLbRZTjoDeU2EJpkJg==", "626747e6-d280-4361-97b5-67b21b4e4096" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PGS");

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
        }
    }
}
