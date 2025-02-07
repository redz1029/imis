using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePGSDeliverable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "PgsId",
                table: "Deliverable");

            migrationBuilder.AlterColumn<int>(
                name: "KraId",
                table: "Deliverable",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "03538be3-b337-4431-8f9b-bd98aeab3525");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dade41e1-e3b0-47ee-bf02-9b9174369312", "AQAAAAIAAYagAAAAEOdT6nGCk28H1zauDH35x4HWJOu7fXM7CwfUmm4wJbU7KVc4+1+xc4Tc0ZH5mU3n5w==", "0a36cc5f-5b5b-4190-b2af-325c10463e66" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "Kra",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable");

            migrationBuilder.AlterColumn<int>(
                name: "KraId",
                table: "Deliverable",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<long>(
                name: "PgsId",
                table: "Deliverable",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "a6163233-c8f5-4cef-b3ff-29df5ce7671a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c64a1f57-d095-46ec-80c1-ce43c11c7296", "AQAAAAIAAYagAAAAEOVnzAQxzlKVVHyq6jYfE+MI3u7siAAm5dEZUInWjL/irCKGeWCfA00bWGSkqmrvUQ==", "a8dcb740-c0ae-4b60-adc3-89dea59600df" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_Kra_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "Kra",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
