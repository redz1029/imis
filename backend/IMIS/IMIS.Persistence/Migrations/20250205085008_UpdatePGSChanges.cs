using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePGSChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PGS");

            migrationBuilder.CreateTable(
                name: "Kra",
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
                    table.PrimaryKey("PK_Kra", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PgsPeriod",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartDate = table.Column<DateOnly>(type: "date", nullable: false),
                    EndDate = table.Column<DateOnly>(type: "date", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsPeriod", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PgsProjectStatus",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsPeriodId = table.Column<int>(type: "int", nullable: false),
                    OfficeId = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsProjectStatus", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsProjectStatus_Offices_OfficeId",
                        column: x => x.OfficeId,
                        principalTable: "Offices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PgsProjectStatus_PgsPeriod_PgsPeriodId",
                        column: x => x.PgsPeriodId,
                        principalTable: "PgsPeriod",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Deliverable",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KraId = table.Column<int>(type: "int", nullable: false),
                    Direct = table.Column<bool>(type: "bit", nullable: false),
                    Indirect = table.Column<bool>(type: "bit", nullable: false),
                    DeliverableName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ByWhen = table.Column<DateTime>(type: "datetime2", nullable: false),
                    PercentDeliverables = table.Column<double>(type: "float", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    PgsId = table.Column<long>(type: "bigint", nullable: false),
                    PgsProjectStatusId = table.Column<long>(type: "bigint", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Deliverable", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Deliverable_Kra_KraId",
                        column: x => x.KraId,
                        principalTable: "Kra",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Deliverable_PgsProjectStatus_PgsProjectStatusId",
                        column: x => x.PgsProjectStatusId,
                        principalTable: "PgsProjectStatus",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "62e99d3d-aa73-437c-bcc6-314bc6d58dc2");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1968a47-67b8-41dc-84cf-ff53227fd824", "AQAAAAIAAYagAAAAECa5CqfC/ClPSDbWw2erp6MazcmyvIcy+IGEnKfRHvL5HRb6X91irXDJrbRWFcB+UA==", "156883ad-77df-460e-9d0f-6700a91b268b" });

            migrationBuilder.CreateIndex(
                name: "IX_Deliverable_KraId",
                table: "Deliverable",
                column: "KraId");

            migrationBuilder.CreateIndex(
                name: "IX_Deliverable_PgsProjectStatusId",
                table: "Deliverable",
                column: "PgsProjectStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsProjectStatus_OfficeId",
                table: "PgsProjectStatus",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsProjectStatus_PgsPeriodId",
                table: "PgsProjectStatus",
                column: "PgsPeriodId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Deliverable");

            migrationBuilder.DropTable(
                name: "Kra");

            migrationBuilder.DropTable(
                name: "PgsProjectStatus");

            migrationBuilder.DropTable(
                name: "PgsPeriod");

            migrationBuilder.CreateTable(
                name: "PGS",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ByWhen_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Delivarables_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Direct_1 = table.Column<bool>(type: "bit", nullable: false),
                    Indirect_1 = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    KRA_1 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Percent_Deliverables = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Year = table.Column<string>(type: "nvarchar(max)", nullable: false)
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
    }
}
