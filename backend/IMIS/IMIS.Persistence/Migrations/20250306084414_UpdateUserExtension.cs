using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUserExtension : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditoTeams_Auditors_AuditorId",
                table: "AuditoTeams");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditoTeams_Teams_TeamId",
                table: "AuditoTeams");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchduleDetails_AuditSchedules_AuditScheduleId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchduleDetails_Offices_OfficeId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchduleDetails_Teams_TeamId",
                table: "AuditSchduleDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditSchduleDetails",
                table: "AuditSchduleDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditoTeams",
                table: "AuditoTeams");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd");

            migrationBuilder.RenameTable(
                name: "AuditSchduleDetails",
                newName: "AuditScheduleDetails");

            migrationBuilder.RenameTable(
                name: "AuditoTeams",
                newName: "AuditorTeams");

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

            migrationBuilder.RenameIndex(
                name: "IX_AuditSchduleDetails_TeamId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_TeamId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSchduleDetails_OfficeId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_OfficeId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditSchduleDetails_AuditScheduleId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_AuditScheduleId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditoTeams_TeamId",
                table: "AuditorTeams",
                newName: "IX_AuditorTeams_TeamId");

            migrationBuilder.AddColumn<long>(
                name: "PgsReadinessRatingId",
                table: "PgsAuditDetails",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "AspNetUsers",
                type: "nvarchar(13)",
                maxLength: 13,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FirstName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "LastName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "MiddleName",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Position",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Prefix",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Suffix",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditScheduleDetails",
                table: "AuditScheduleDetails",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams",
                columns: new[] { "AuditorId", "TeamId" });

            migrationBuilder.CreateTable(
                name: "UserOffices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    OfficeId = table.Column<int>(type: "int", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserOffices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserOffices_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserOffices_Offices_OfficeId",
                        column: x => x.OfficeId,
                        principalTable: "Offices",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc",
                column: "ConcurrencyStamp",
                value: "f6d41030-d518-47bc-b54f-4ed90e199e44");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "475e45a8-4dd9-425c-b405-b6598ef700fd", 0, "a25a957d-3420-485a-bbd4-1929976b456a", "IdentityUser", "ADMIN@MAIL.COM", false, false, null, "ADMIN@MAIL.COM", "ADMIN", "AQAAAAIAAYagAAAAEHq/QowiwWUIIBpx57QFCAuF521LHWAE8QceP+Ri1N/GkIaSRI33SnznSq7PjnrLmA==", null, false, "4a484f89-9495-4f01-b197-75c227f53c52", false, "admin" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsAuditDetails_PgsReadinessRatingId",
                table: "PgsAuditDetails",
                column: "PgsReadinessRatingId");

            migrationBuilder.CreateIndex(
                name: "IX_UserOffices_OfficeId",
                table: "UserOffices",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_UserOffices_UserId",
                table: "UserOffices",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams",
                column: "AuditorId",
                principalTable: "Auditors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorTeams_Teams_TeamId",
                table: "AuditorTeams",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_AuditSchedules_AuditScheduleId",
                table: "AuditScheduleDetails",
                column: "AuditScheduleId",
                principalTable: "AuditSchedules",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

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
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditorTeams_Teams_TeamId",
                table: "AuditorTeams");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_AuditSchedules_AuditScheduleId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsAuditDetails_PgsReadiness_PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropTable(
                name: "UserOffices");

            migrationBuilder.DropIndex(
                name: "IX_PgsAuditDetails_PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditScheduleDetails",
                table: "AuditScheduleDetails");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams");

            migrationBuilder.DropColumn(
                name: "PgsReadinessRatingId",
                table: "PgsAuditDetails");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "FirstName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "LastName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "MiddleName",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Position",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Prefix",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "Suffix",
                table: "AspNetUsers");

            migrationBuilder.RenameTable(
                name: "AuditScheduleDetails",
                newName: "AuditSchduleDetails");

            migrationBuilder.RenameTable(
                name: "AuditorTeams",
                newName: "AuditoTeams");

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

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_TeamId",
                table: "AuditSchduleDetails",
                newName: "IX_AuditSchduleDetails_TeamId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_OfficeId",
                table: "AuditSchduleDetails",
                newName: "IX_AuditSchduleDetails_OfficeId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_AuditScheduleId",
                table: "AuditSchduleDetails",
                newName: "IX_AuditSchduleDetails_AuditScheduleId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditorTeams_TeamId",
                table: "AuditoTeams",
                newName: "IX_AuditoTeams_TeamId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditSchduleDetails",
                table: "AuditSchduleDetails",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditoTeams",
                table: "AuditoTeams",
                columns: new[] { "AuditorId", "TeamId" });

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

            migrationBuilder.AddForeignKey(
                name: "FK_AuditoTeams_Auditors_AuditorId",
                table: "AuditoTeams",
                column: "AuditorId",
                principalTable: "Auditors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditoTeams_Teams_TeamId",
                table: "AuditoTeams",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchduleDetails_AuditSchedules_AuditScheduleId",
                table: "AuditSchduleDetails",
                column: "AuditScheduleId",
                principalTable: "AuditSchedules",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchduleDetails_Offices_OfficeId",
                table: "AuditSchduleDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchduleDetails_Teams_TeamId",
                table: "AuditSchduleDetails",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
