using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RenamePgsAuditDetailTableToPerformanceGovernanceSystem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PerfomanceGovernanceSystemId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_Offices_OfficeId",
                table: "PgsAuditDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsPeriod_PgsPeriodId",
                table: "PgsAuditDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsReadiness_PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PgsAuditDetails",
                table: "PgsAuditDetails");

            migrationBuilder.RenameTable(
                name: "PgsAuditDetails",
                newName: "PerformanceGovernanceSystem");

            migrationBuilder.RenameIndex(
                name: "IX_PgsAuditDetails_PgsReadinessRatingId",
                table: "PerformanceGovernanceSystem",
                newName: "IX_PerformanceGovernanceSystem_PgsReadinessRatingId");

            migrationBuilder.RenameIndex(
                name: "IX_PgsAuditDetails_PgsPeriodId",
                table: "PerformanceGovernanceSystem",
                newName: "IX_PerformanceGovernanceSystem_PgsPeriodId");

            migrationBuilder.RenameIndex(
                name: "IX_PgsAuditDetails_OfficeId",
                table: "PerformanceGovernanceSystem",
                newName: "IX_PerformanceGovernanceSystem_OfficeId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PerformanceGovernanceSystem",
                table: "PerformanceGovernanceSystem",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "4c0f1f1f-a5be-44a9-9f40-b6180a1d13a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "f90249ce-3330-4d75-944f-e41b83b75cdf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "c8b730f7-80ec-45fe-8439-f10727ce6541");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5a7d8e5-81cd-443f-8ee3-5c6d336c3891", "AQAAAAIAAYagAAAAEIeF4dr7I/Kz1+a1+U1RnGpZjxeMjfdLCud7A9tiseREo/qI5nkbk6OknfkWN7VG7Q==", "0e8099d7-0b79-4713-8df7-0915a532e263" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab783957-914b-49a5-8b89-539051b35022", "AQAAAAIAAYagAAAAEF/O4XRS8mCITUC0J1+ztpYKzQWQAl/oi+GljDGlT7DypWi7DEoEwfnGS3U5kRWKOw==", "cfb83ff0-add7-46bf-b6c2-aba6db62ceaa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6aec5276-201e-4d9f-8dcf-22f5a48e78d6", "AQAAAAIAAYagAAAAEBLd5aeg6n+cu0rRWee+MLVjRB8ZvuxmpEore9OqCM1DKDSq5hRoBLyNwjo0Ic3N3g==", "3c89d6fe-f444-46a8-83b3-444a6e702627" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable",
                column: "PerfomanceGovernanceSystemId",
                principalTable: "PerformanceGovernanceSystem",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_PerformanceGovernanceSystem_Offices_OfficeId",
                table: "PerformanceGovernanceSystem",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PerformanceGovernanceSystem_PgsPeriod_PgsPeriodId",
                table: "PerformanceGovernanceSystem",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_PerformanceGovernanceSystem_PgsReadiness_PgsReadinessRatingId",
                table: "PerformanceGovernanceSystem",
                column: "PgsReadinessRatingId",
                principalTable: "PgsReadiness",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PerformanceGovernanceSystem_PerfomanceGovernanceSystemId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_PerformanceGovernanceSystem_Offices_OfficeId",
                table: "PerformanceGovernanceSystem");

            migrationBuilder.DropForeignKey(
                name: "FK_PerformanceGovernanceSystem_PgsPeriod_PgsPeriodId",
                table: "PerformanceGovernanceSystem");

            migrationBuilder.DropForeignKey(
                name: "FK_PerformanceGovernanceSystem_PgsReadiness_PgsReadinessRatingId",
                table: "PerformanceGovernanceSystem");

            migrationBuilder.DropPrimaryKey(
                name: "PK_PerformanceGovernanceSystem",
                table: "PerformanceGovernanceSystem");

            migrationBuilder.RenameTable(
                name: "PerformanceGovernanceSystem",
                newName: "PgsAuditDetails");

            migrationBuilder.RenameIndex(
                name: "IX_PerformanceGovernanceSystem_PgsReadinessRatingId",
                table: "PgsAuditDetails",
                newName: "IX_PgsAuditDetails_PgsReadinessRatingId");

            migrationBuilder.RenameIndex(
                name: "IX_PerformanceGovernanceSystem_PgsPeriodId",
                table: "PgsAuditDetails",
                newName: "IX_PgsAuditDetails_PgsPeriodId");

            migrationBuilder.RenameIndex(
                name: "IX_PerformanceGovernanceSystem_OfficeId",
                table: "PgsAuditDetails",
                newName: "IX_PgsAuditDetails_OfficeId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PgsAuditDetails",
                table: "PgsAuditDetails",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "01a7769f-a3d1-4c51-bc57-19939be10819");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "965adb5a-3052-401d-91e0-c3c5e8d58935");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "c97763be-c2de-433e-ba1c-1a9024dc1133");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "161679cd-4f9e-4023-a9e3-542a44873280", "AQAAAAIAAYagAAAAEKEgwuK0/oJOjuI+als8ZPFRBLA9MlkEhxNrMivQz83R5McOUKK8r7VngH6L7+YONA==", "1521dabc-d555-4da3-9b40-400c4e4a650a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24f1de35-cdc9-43bc-884d-9935508e47e3", "AQAAAAIAAYagAAAAEOAZCmSU4Hf+NfGV3gx5SX49OMOVDVI5CbSceH6uTJTTsiQtfsAP3TmfZeSE7KYThA==", "1e805a7f-04fc-414e-8832-a7260b23a69d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd94b84c-dcef-4e06-9403-0cfc99017982", "AQAAAAIAAYagAAAAENT0wqdGENZBuoW0SbE6wK4NuRtj08Ir1/kgWNGd3Fh/nX9wSZIDfveYMnoiZIFXbQ==", "69109552-3a61-436b-8a22-e5fa2a41ba23" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PerfomanceGovernanceSystemId",
                table: "Deliverable",
                column: "PerfomanceGovernanceSystemId",
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

            migrationBuilder.AddForeignKey(
                name: "FK_PgsAuditDetails_PgsReadiness_PgsReadinessRatingId",
                table: "PgsAuditDetails",
                column: "PgsReadinessRatingId",
                principalTable: "PgsReadiness",
                principalColumn: "Id");
        }
    }
}
