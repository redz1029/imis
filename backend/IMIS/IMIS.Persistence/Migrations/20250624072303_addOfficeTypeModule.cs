using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addOfficeTypeModule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "OfficeTypeId",
                table: "Offices",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "OfficeType",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OfficeType", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8b1e1fe2-a900-4aec-89d8-ebc52945432f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "689287ed-707a-4b30-a195-38a70b0b93ba");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "83fc3db0-0032-4343-be9e-f5718977afd2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "8ceea30b-edd6-4315-a2a3-d24648871c44");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a2da38f-acb7-4591-886e-d859ca8be347", "AQAAAAIAAYagAAAAEOax/6IIp8/f7549uUVs0kQ63JXZ0trvya4+vI3CforAVqkiFi4INkuMLUnKLX+hHg==", "859b08da-7f50-4edd-956e-136eff323be6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ad3a4b3-37de-491f-9bf8-724d3491950a", "AQAAAAIAAYagAAAAEJDUNYFfgzVdPgIPUnaLaDXHHlt1Gv8gU0ArJQ+WJjo+Ewf4LSw73Vi5e0cFWUOO8Q==", "e0def2e6-7413-4559-b79a-069f6038760e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0867eca1-b14f-41e8-b670-abb56893cd89", "AQAAAAIAAYagAAAAEMXSyAjGdx2HzFLLJjZcq5cXRcjxbxXMv2T85gThY773dsplkXko1LsXLKem1tfG/g==", "ab9bdafd-5828-45c3-ace8-7dfd627729da" });

            migrationBuilder.InsertData(
                table: "OfficeType",
                columns: new[] { "Id", "IsActive", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, true, false, "Service" },
                    { 2, true, false, "Department" },
                    { 3, true, false, "Unit" },
                    { 4, true, false, "Section" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Offices_OfficeTypeId",
                table: "Offices",
                column: "OfficeTypeId");

            migrationBuilder.AddForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices",
                column: "OfficeTypeId",
                principalTable: "OfficeType",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices");

            migrationBuilder.DropTable(
                name: "OfficeType");

            migrationBuilder.DropIndex(
                name: "IX_Offices_OfficeTypeId",
                table: "Offices");

            migrationBuilder.DropColumn(
                name: "OfficeTypeId",
                table: "Offices");

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
                column: "ConcurrencyStamp",
                value: "51919e93-df6f-4aad-99a4-6a8672820304");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "da227e00-a9ed-47a0-b571-13e0fee8e48c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "bad61a58-6c8f-41f7-aa49-b9012821c7d2");

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
        }
    }
}
