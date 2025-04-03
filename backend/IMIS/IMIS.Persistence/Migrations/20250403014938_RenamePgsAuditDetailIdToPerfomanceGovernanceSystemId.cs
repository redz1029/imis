using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RenamePgsAuditDetailIdToPerfomanceGovernanceSystemId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsAuditDetailsId",
                table: "Deliverable");

            migrationBuilder.RenameColumn(
                name: "PgsAuditDetailsId",
                table: "Deliverable",
                newName: "PerfomanceGovernanceSystemId");

            migrationBuilder.RenameIndex(
                name: "IX_Deliverable_PgsAuditDetailsId",
                table: "Deliverable",
                newName: "IX_Deliverable_PerfomanceGovernanceSystemId");

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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PerfomanceGovernanceSystemId",
                table: "Deliverable");

            migrationBuilder.RenameColumn(
                name: "PerfomanceGovernanceSystemId",
                table: "Deliverable",
                newName: "PgsAuditDetailsId");

            migrationBuilder.RenameIndex(
                name: "IX_Deliverable_PerfomanceGovernanceSystemId",
                table: "Deliverable",
                newName: "IX_Deliverable_PgsAuditDetailsId");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "44106d71-d006-4ee9-b594-0f7e83b536a7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "e393c773-a17f-4ed2-9bec-19447190f2e1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "c3e331a9-f932-4382-b27c-2ecf4091ee2a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98e87f03-fc95-4b96-bc50-b6817aecaefe", "AQAAAAIAAYagAAAAEApMXUMhgG3kX02dQTXWgtUyayh/jSAnhpQzQpNnmRP6WFxk+WiDOM78NqfITPSTVA==", "bb78a744-2e30-42fa-9c33-992d4efd4a1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79b320dc-5f4f-415b-af05-ab51d6375edb", "AQAAAAIAAYagAAAAEMIrKr1Ep+Z3PsGjRUFmKJDFSfJKhA+wQTirgaKNDzT8i5PzfTiDtZiZizqyg4kcIg==", "ff285325-fd36-4c35-bceb-2aa7c3bc6b16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87707c99-028c-4d19-9dc1-b8e9214f5962", "AQAAAAIAAYagAAAAEO4uHLy8DDZvZojm6H2MYBbr1+KKuvL4MgcCvBwwtLGZFz+d3A0mgi7Rpz9/bBxgMA==", "feab78b6-e25c-49b8-a0e9-9eb1971b3acc" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsAuditDetails_PgsAuditDetailsId",
                table: "Deliverable",
                column: "PgsAuditDetailsId",
                principalTable: "PgsAuditDetails",
                principalColumn: "Id");
        }
    }
}
