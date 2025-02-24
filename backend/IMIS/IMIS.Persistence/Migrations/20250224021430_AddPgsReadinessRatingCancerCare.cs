using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPgsReadinessRatingCancerCare : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "PgsReadinessRatingCancerCareId",
                table: "Deliverable",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "PgsReadiness",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Score1 = table.Column<double>(type: "float", nullable: false),
                    Score2 = table.Column<double>(type: "float", nullable: false),
                    Score3 = table.Column<double>(type: "float", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsReadiness", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "72277c97-b621-4c5b-961d-ab3ff962b08a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5328c3f-9855-4164-a617-7d422dab0937", "AQAAAAIAAYagAAAAELct53PYWBrZWZXTKLYW0W5j315Us2qqrDDSzQHdx2l4MMGuMzROqFxQWhfjBgQ//A==", "d03a2566-f36d-4bab-97aa-0268f4170953" });

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_PgsReadiness_PgsReadinessRatingCancerCareId",
                table: "Deliverable");

            migrationBuilder.DropTable(
                name: "PgsReadiness");

            migrationBuilder.DropIndex(
                name: "IX_Deliverable_PgsReadinessRatingCancerCareId",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "PgsReadinessRatingCancerCareId",
                table: "Deliverable");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "1b605c4a-5e92-4f69-920d-a9a43733cce0");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7d8ff1c2-fa09-4cc6-93a7-fd94d16456da", "AQAAAAIAAYagAAAAEA2DbshCYavKxpV46VSbb/c1rKkLru7qMwDY7FXRckW16nlrgT1SeMEf++ATOilRdw==", "e9261325-b7d0-43f6-91f2-a3d262f5b5d6" });
        }
    }
}
