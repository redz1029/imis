using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RemovePgsReadinessFromPgdDeliverables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsReadiness_PgsReadinessRatingCancerCareId",
                table: "Deliverable");

            migrationBuilder.DropIndex(
                name: "IX_Deliverable_PgsReadinessRatingCancerCareId",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "PgsReadinessRatingCancerCareId",
                table: "Deliverable");

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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "PgsReadinessRatingCancerCareId",
                table: "Deliverable",
                type: "bigint",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "7db08584-bb44-494f-ae1e-6eaddebd4a43");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "8013d560-f709-4752-a502-fa08b12be221");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "003c5b28-6857-4e4c-97d3-41f2e8deda35");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04be229a-dfa4-4491-b35b-250d5ddd7d31", "AQAAAAIAAYagAAAAEBvFfsr8jVyLhmRSbXaoQRdB3eP/xpwWmxX73o+KwXPD/IaLU2HQY6UpDsxJaNl8hQ==", "95714f35-2814-4c3c-acf4-8833f12bd28e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0e56ece-cf61-41f1-a1a5-8c53af03112e", "AQAAAAIAAYagAAAAEEO8udTCynUIU0klTVLzgQEEN84vXENfZ9ObEx6ntdYvkfoxzaRZDIYfg4/Ld1KnyA==", "c5e9ffe9-97b0-466b-bf99-5846392c5bb5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ad20699-94e7-4fa1-a926-8385f0d550a0", "AQAAAAIAAYagAAAAEC4Mi9RxBzNHT8QUJl9Zo7NS9QP7kVmedjc+7XjPMVz/u1WujjWRCSTpidM2Khd23A==", "3733b2ff-5912-490b-a7fa-4c2eae940a8b" });

            migrationBuilder.CreateIndex(
                name: "IX_Deliverable_PgsReadinessRatingCancerCareId",
                table: "Deliverable",
                column: "PgsReadinessRatingCancerCareId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_PgsReadiness_PgsReadinessRatingCancerCareId",
                table: "Deliverable",
                column: "PgsReadinessRatingCancerCareId",
                principalTable: "PgsReadiness",
                principalColumn: "Id");
        }
    }
}
