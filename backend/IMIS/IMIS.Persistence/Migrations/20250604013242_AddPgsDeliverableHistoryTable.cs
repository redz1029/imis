using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPgsDeliverableHistoryTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsDeliverableScoreHistories",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsDeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Score = table.Column<double>(type: "float", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsDeliverableScoreHistories", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d7b2d9a2-08f7-484b-ac0d-36637201c554");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "ec8f8a84-a795-45c6-a1bd-6cff08fa20f7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "efb1eb4d-50de-47d0-809c-7021e47a88bf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "28b33b57-61e1-40c5-9f0c-5d92b2398ae8");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "36832034-d17a-4e73-b3e9-91030b4f5546", "AQAAAAIAAYagAAAAEM7jH/LmP61RxEqnhLtFl/Ok7jzzG3lM47uiHivGbngXWFSqJgYwfMKS+5Oe0vz4BQ==", "b5b7bc8d-5915-4ed5-a2bc-ff7b3364a1e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "83a8b182-091f-4ff6-9389-8ce6342e7ff6", "AQAAAAIAAYagAAAAEMXFHETAyY7ByX8DdAbAs1y301gQ16gsGtwePNEvcD8ZeqiHkldLHxNqFXSZtlVrgw==", "82143406-df97-45e0-ac5a-6bd15fe46898" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "043e70fb-3b14-496f-8d06-f84957926121", "AQAAAAIAAYagAAAAEGkZ7eWUmOkwmlzZ/vDKCrG8LrkTmtTsApuT6LZgehBVipasTqklErJhBwVSivJDgA==", "ce720b9f-eed2-45c9-9f06-39a51b5b3474" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableScoreHistories");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8ed2f590-8daa-42ce-aeb0-aff145c5453a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "40a7a351-2e90-4ca2-814a-b990e0a64837");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "0584e143-ec5c-456a-b3f6-3167ee654734");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "403d6cd3-638c-4740-b3d2-b36cd902f63d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6ef654a-e60f-4344-a47a-96a5a868eff6", "AQAAAAIAAYagAAAAEDxgqXhhsTyyfEGatdjJz4l/69DwCoV8IDF18APsOqjpnZZjtiG9KL1mLvcO1qVtEw==", "1f7071c2-c388-4436-a429-91e68aa8ec52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5cc46128-a148-4b10-854e-bc18b200751f", "AQAAAAIAAYagAAAAEPbF0vVB+FgCPa7wR4cUVGDtJRlZjZdPlVPXnFqv4/ECiQbpBCYOrZuQzUDsR+TdhQ==", "2adc39ba-1437-46cd-9a2d-0ac54807247c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cb3eba8-83cd-4b76-9e11-c147b89755c5", "AQAAAAIAAYagAAAAEA8MFngZPglnznJ7gcz/D2ADkyqZlJYZ81at4UnjDVOEwD0mSpheKVIx1a98t0C71Q==", "6dbcc4c7-f8fc-47f0-aa9b-e491c517db8e" });
        }
    }
}
