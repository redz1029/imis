using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RenameAndUpdatePgsReadiness : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Score3",
                table: "PgsReadiness",
                newName: "ResourceAvailability");

            migrationBuilder.RenameColumn(
                name: "Score2",
                table: "PgsReadiness",
                newName: "ConfidenceToDeliver");

            migrationBuilder.RenameColumn(
                name: "Score1",
                table: "PgsReadiness",
                newName: "CompetenceToDeliver");

            migrationBuilder.AddColumn<long>(
                name: "PgsReadinessRatingId",
                table: "PgsAuditDetails",
                type: "bigint",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "9d6371a3-6d91-42a4-971a-27ec1cd75c3c");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "227965bd-6564-4310-bb0c-f06aeed3af8c", "AQAAAAIAAYagAAAAEP9OXrZGjYhR3hPQj8MzEMtK5klXGi5rqb7xKKT2SeY1lO7FZqi/23SHdMGK2r40UQ==", "d94e226e-bc76-4c7b-bb23-c942cf1680ad" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsAuditDetails_PgsReadinessRatingId",
                table: "PgsAuditDetails",
                column: "PgsReadinessRatingId");

            migrationBuilder.AddForeignKey(
                name: "FK_PgsAuditDetails_PgsReadiness_PgsReadinessRatingId",
                table: "PgsAuditDetails",
                column: "PgsReadinessRatingId",
                principalTable: "PgsReadiness",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsReadiness_PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropIndex(
                name: "IX_PgsAuditDetails_PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropColumn(
                name: "PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.RenameColumn(
                name: "ResourceAvailability",
                table: "PgsReadiness",
                newName: "Score3");

            migrationBuilder.RenameColumn(
                name: "ConfidenceToDeliver",
                table: "PgsReadiness",
                newName: "Score2");

            migrationBuilder.RenameColumn(
                name: "CompetenceToDeliver",
                table: "PgsReadiness",
                newName: "Score1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "021c20ed-7863-46dc-8bf8-b22f87943203");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68060113-21d8-489b-8ccb-f1100ba58d26", "AQAAAAIAAYagAAAAEMNt0lY+vYpU1Iwxu/lbolLEPy/2nxoV7tItYGhOmctCUuGlY4X88oWce6DZ06DDFQ==", "5ee80b2f-981f-444a-8dea-9e22ad540625" });
        }
    }
}
