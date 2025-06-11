using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsDeliverableAddPerfomanceGovernanceSystemIdAsForeignKey : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable");

            migrationBuilder.AlterColumn<long>(
                name: "PerfomanceGovernanceSystemId",
                table: "Deliverable",
                type: "bigint",
                nullable: false,
                defaultValue: 0L,
                oldClrType: typeof(long),
                oldType: "bigint",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "685475b4-fdd1-48fc-bf49-fa181a2adb77");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "51919e93-df6f-4aad-99a4-6a8672820304", "Pgs Manager" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "da227e00-a9ed-47a0-b571-13e0fee8e48c", "Pgs Auditor" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "bad61a58-6c8f-41f7-aa49-b9012821c7d2", "Standard User" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "051689ce-1bd2-47be-af5d-656fe567bb57", "AQAAAAIAAYagAAAAEK3S7JhNRv8BnahBIKTIoMEHkp06XnCTgZpEjFqxsyLgGqfq+B1vS8MATLOAcGE2Pw==", "1de9d232-48d7-4600-93f2-e56465101c2a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9f82a041-fb27-48a6-970e-864cfc6377c6", "AQAAAAIAAYagAAAAEEp162zmjS73e/h9NL17FkrIzXlavN9oMIo+pSoRvrcU64+vBpB29x6fFF1R2b9PXQ==", "d198a53c-31af-465a-8f70-2f0e97197e94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f73bfd4a-ef68-4b31-b6ad-28184d9b84c9", "AQAAAAIAAYagAAAAEMsFT+a7yakj5oyac/Cu6LE3N8IIvaUPg5HUjXG+X28FLtrwObu9F0RS3VjYTkG8wg==", "a437b9f0-225f-41a7-85b3-95afd70706d4" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableScoreHistories_PgsDeliverableId",
                table: "PgsDeliverableScoreHistories",
                column: "PgsDeliverableId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable",
                column: "PerfomanceGovernanceSystemId",
                principalTable: "PerformanceGovernanceSystem",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PgsDeliverableScoreHistories_Deliverable_PgsDeliverableId",
                table: "PgsDeliverableScoreHistories",
                column: "PgsDeliverableId",
                principalTable: "Deliverable",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsDeliverableScoreHistories_Deliverable_PgsDeliverableId",
                table: "PgsDeliverableScoreHistories");

            migrationBuilder.DropIndex(
                name: "IX_PgsDeliverableScoreHistories_PgsDeliverableId",
                table: "PgsDeliverableScoreHistories");

            migrationBuilder.AlterColumn<long>(
                name: "PerfomanceGovernanceSystemId",
                table: "Deliverable",
                type: "bigint",
                nullable: true,
                oldClrType: typeof(long),
                oldType: "bigint");

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
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "ec8f8a84-a795-45c6-a1bd-6cff08fa20f7", "PGS Manager" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "efb1eb4d-50de-47d0-809c-7021e47a88bf", "PGS Auditor" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "28b33b57-61e1-40c5-9f0c-5d92b2398ae8", "PGS User" });

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

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable",
                column: "PerfomanceGovernanceSystemId",
                principalTable: "PerformanceGovernanceSystem",
                principalColumn: "Id");
        }
    }
}
