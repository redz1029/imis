using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateAuditTrailOldValuesNullable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "OldValues",
                table: "AuditTrails",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "bc27cb6c-9564-44e8-b6a1-abedbe663803");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "87fb1a40-448b-4a3a-8170-4b166be93182");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a03604a8-ad6e-47ef-89e7-d5731770409b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "fa86447e-c8bd-4f4a-8fc5-55c70127cd19");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50747c16-f270-4dcd-ab95-dfd29a05bdee", "AQAAAAIAAYagAAAAECjt50vHfu7mA0LpPz6yecGvOvjyXu5fwWDkACSeNQc8AicI6rOOtMEay2zB0QYIHw==", "95760211-4ce1-4002-99b8-4c04a40843d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0efa3e0d-90ee-4409-8f48-f05774e2b9e0", "AQAAAAIAAYagAAAAED2+gt0suo80SdLT7Xo+EJNI0MLT2rgeTtCFqq/TjRTCBCWbqKTTS/+soiLDT+QloQ==", "554e7e56-7d25-4c0f-a30a-7323e81030e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30f992c6-927c-4805-a1b1-cde046a4ddbb", "AQAAAAIAAYagAAAAEBkmpwG5UdewvjMdC9XWZnE25T/X13LmpM9suvbzl4cOdiNNcF0xkuyUKigI/HbNHA==", "1f6bc2fb-fd5f-4a81-8bee-d623758dd18f" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "OldValues",
                table: "AuditTrails",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

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
    }
}
