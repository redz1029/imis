using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class _AddOfficeRefInPgsSignatoryTemplate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "410b1b71-43d8-4782-8454-bbf2a7ffd8eb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "52dff866-3c44-4d34-b898-9ab47ad58ae1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "664d815f-13c7-465a-a486-8916b81d93e3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "d97d88ef-befa-4cb9-a876-12175784a917");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c1254d9-2873-4b4d-b88d-d33273a616b3", "AQAAAAIAAYagAAAAEJnZCoF9T12Vt2qmwa29SE29fWbv7plpUE/cM/RyudKb4GfaStgzhVjfmM7dvx7laA==", "bd1fa6fa-d528-49a5-aae2-98a2d67c4250" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2a25051-8091-4c33-ad4e-0da9b5652db9", "AQAAAAIAAYagAAAAENl448iIAjv0Lmuo8Yaj1Vrs+zUenp9H3V2PpQmvnw6T+4m5aZWRg0wFbQZzvrepxg==", "da21bfd9-37a8-4515-ba74-0aa22166a1db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d541fdb5-67b4-4001-a0d7-fefabbf02913", "AQAAAAIAAYagAAAAEFY9Y9yHs0nam8CAZhuXRBb3zofPnoYNVSYayENBZLBAP+iIg4EKeAFOGllUam9/ig==", "1ce9962e-52b6-4d26-926b-b55bb0320f51" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d7da037b-ab9f-4f98-84a4-7d0079a3df0b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "205ea5a4-1708-4c31-9d5c-ada866cb2c4a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "324630b8-3833-4298-b42d-7ec4c11063b6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "21dd1934-6c36-431c-8b5c-79265c6447fc");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7879e496-2548-495d-9652-c26309b30d8a", "AQAAAAIAAYagAAAAEPrKs7IMN12/lV5p6ybP9GlkTTOmmlexDlKmNyDj8badLqZ9JLabo6vVMb+EU/iFFg==", "ed8ab9ae-1ac2-4f17-8400-8c29936d228b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa2377f5-15cd-4d72-9d28-4de159a03847", "AQAAAAIAAYagAAAAEN61JwylqcI82aLBTgMdQyqwpsNRIktgf3QlRN663w7YVKgl+AGVRmNOjFZRDs9uaw==", "132ae571-1a18-4de9-8fdb-5076e7231759" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9aefb81-c46b-4d9b-b943-6b1a6b1bc1ac", "AQAAAAIAAYagAAAAEJ3zUVpRJCLBpBQk2pg2HbRhHPcknxmSS2LpB3e8E8yVv1exwQObDGiezTwoEyCZKA==", "8f7a4cc2-1af3-4124-8b4a-5e747fca0a5f" });
        }
    }
}
