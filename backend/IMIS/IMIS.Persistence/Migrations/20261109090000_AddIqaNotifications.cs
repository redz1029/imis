using System;
using IMIS.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(ImisDbContext))]
    [Migration("20261109090000_AddIqaNotifications")]
    public partial class AddIqaNotifications : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "IqaNotifications",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecipientUserId = table.Column<string>(type: "nvarchar(450)", maxLength: 450, nullable: false),
                    ActorUserId = table.Column<string>(type: "nvarchar(450)", maxLength: 450, nullable: true),
                    Type = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Message = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    EntityType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    EntityId = table.Column<long>(type: "bigint", nullable: true),
                    TargetPage = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ReadAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IqaNotifications", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_IqaNotifications_EntityType_EntityId",
                table: "IqaNotifications",
                columns: new[] { "EntityType", "EntityId" });

            migrationBuilder.CreateIndex(
                name: "IX_IqaNotifications_RecipientUserId_ReadAt",
                table: "IqaNotifications",
                columns: new[] { "RecipientUserId", "ReadAt" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "IqaNotifications");
        }
    }
}
