using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAuditTrail : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AuditTrails",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    TableName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Action = table.Column<int>(type: "int", nullable: false),
                    KeyValues = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OldValues = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NewValues = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AuditTrails", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "992c737e-d520-4d16-bf50-7898b4460ea1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "9eb933f4-3d3e-439b-8298-9475820c2f3e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e1e383ea-6009-4022-978e-45bf15678e14");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "9a70e1cf-b6ab-499c-bddf-8c6b4ad93a8b");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d104d88-16d2-4f0c-aa50-6c6e39b6ab82", "AQAAAAIAAYagAAAAECrVUF++noPhEZSC7z0BO8PVUF2rQtZW6qSgOz8O9t75aLSoAjJm1jum425brluTZg==", "bd1901ed-3e4e-4f6f-8c73-900fcbf4fcd3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8626a006-cf74-4413-80b6-e3731bd0e9dc", "AQAAAAIAAYagAAAAEIRvv8agkiFpAez2Es3uHrlBQ4epdndJ6WWyf6De31s5OBH4gh/aQHOGYKGydNU4nw==", "b510a869-c886-45f2-b73e-efea5ce103d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a8083f7-cde3-47fc-b626-648449fd9f23", "AQAAAAIAAYagAAAAEIVg2W7dLKs+Wbcz9Adt1LHBgkll655yjCAhqiY2bJn07+UDBcwoMV7cssfsaXQWxg==", "7a3d88d3-d282-460f-8499-587e6f0f0af8" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuditTrails");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "a7bebb35-d560-4376-a6f7-a0f0000e297d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "0ebf2c83-2605-4978-8b35-9cc8cc2b2cb9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "74215862-a502-4944-a567-93d30be95315");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "0535354e-929e-4c76-bb97-786752fcc715");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6640228-514d-4032-8ec8-43b9cfafd780", "AQAAAAIAAYagAAAAEPS0a3mF/jpUDDcoWq0Rdn3FRxbfMRr9t+gwGis+n1t+QVHLCPmjK+sByB4LW7r98A==", "d57e0401-ca7e-4538-9550-68e28f7349c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c051490c-423d-4e84-b461-d880235bf21b", "AQAAAAIAAYagAAAAEDAC0xSGcCaoBWBClSI+itC3CYVROGQzDXfHkSaTog3OFKqJiIbg/qLLoStLBZauVw==", "d87cd67d-6058-48d4-84a0-254bd8c0d7bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ebc2390-434e-4ebb-bde4-66ed37662cb4", "AQAAAAIAAYagAAAAEAgw7XppebVYiE/EdvZdFUA+20OiVdb9H3Afdv78xmgd5e/GhJn0X9uKE4GPPI4h6w==", "15f3c166-4e32-43ae-87c6-8725dc2ea9e7" });
        }
    }
}
