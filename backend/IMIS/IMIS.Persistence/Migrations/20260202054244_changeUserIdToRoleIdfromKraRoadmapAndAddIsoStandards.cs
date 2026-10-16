using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class changeUserIdToRoleIdfromKraRoadmapAndAddIsoStandards : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_KraRoadMap_AspNetUsers_UserId",
                table: "KraRoadMap");

            migrationBuilder.DropIndex(
                name: "IX_KraRoadMap_UserId",
                table: "KraRoadMap");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "KraRoadMap");

            migrationBuilder.AddColumn<string>(
                name: "RoleId",
                table: "KraRoadMap",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "StandardVersions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    VersionName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    isActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StandardVersions", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "IsoStandards",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    VersionID = table.Column<int>(type: "int", nullable: false),
                    ClauseRef = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    isActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IsoStandards", x => x.Id);
                    table.ForeignKey(
                        name: "FK_IsoStandards_StandardVersions_VersionID",
                        column: x => x.VersionID,
                        principalTable: "StandardVersions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "75ce9743-e7a5-4438-8e20-d90beeb65c68");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "fb2b5dc9-d447-44b2-a8a3-f7e857493706");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "2847eda7-2501-4fda-bba6-40e3d576027a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "94d20b0c-bfa9-495b-8adf-7946c13f044b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "9b2d6451-9025-436a-8537-d54d62aadc0a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "33d468bb-d490-4e5f-9338-686fe3275dbc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "292a6f77-d3db-4317-83f1-b458cb23d13e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "ecf26ad8-f2db-4c17-be0d-f211914f8514");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "b60a2629-5ffd-4dca-8974-f1bf69047be6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "1c9bed4b-f17b-490e-a31c-7b880273ff26");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "4aaf15c6-4d4e-4770-af04-95c84879abdd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "c1ecee99-1e69-4492-ad34-ec6cf988869d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "caaeb800-b869-4f11-9013-b2ef91d21c9c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "13a90fba-a774-4d37-993f-2ac77d865741");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "ad67e9b1-b795-4df9-ad6e-bbe772d84c08");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "0cf6bf9d-0b49-4dbc-ac69-f30d7269231e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "4d819502-c758-4e70-8a26-0f5a97c92cc2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "30037d19-81d7-4cc4-ac64-6dd12fd94bb3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "f028e2b4-0961-4289-b01b-fda3b9c96562");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1cef702e-c8c8-4b6d-9671-d178a4dfc4bf", "AQAAAAIAAYagAAAAEOyzQRv03E0TDK6MAag/FKZOiz97maS1HDJ7+GLKmltSv+v2MePqrKU5yaHFm0dgFA==", "61a5f597-7793-412f-b240-40654afb7166" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b565ba73-f360-4d28-bf18-26ce324e2b2d", "AQAAAAIAAYagAAAAEDcq+mEYbsrJwUSVdMWEtjU2xZWv0Daz/Nvw95hoXberM/x8fB2/65/cJJpgUKZDeQ==", "e93df7f0-1443-43f0-b7e1-03838e0f1430" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98931beb-3e3b-447f-9db2-cf3394296dfc", "AQAAAAIAAYagAAAAEJDctdYR36algRhfH1KHx3H1ccBvpu2+zW7jSjDOK3SloyyWcORhY5QRDDfsiqFP1w==", "3b00f967-ecad-4871-a6e6-eeb13282848e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3cd7e002-e7a6-4098-b9fe-cd6afb89fcf6", "AQAAAAIAAYagAAAAEFB1Si4sdge8CxOvkvNPzgIxH1Uj7ZwueGDJuhJ223W961sQ1Fs8Ek2/OXPOcT5Ggg==", "75f65e0e-f61d-4cde-ae29-5a634d2a30b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9c12873-b9eb-4d18-9a47-e73def844039", "AQAAAAIAAYagAAAAEEtq+ATelHbl2xakAaV5IkRIIMAuBFArbdaJo6FxDn45viMoAvnjQ+pJtuOPEL0xRA==", "64cfe52e-79c7-45c9-8ae2-0464cce33a68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a323b0c1-3e8c-4bd3-9d39-685cbfac7005", "AQAAAAIAAYagAAAAEHS5KbBoQBGWuDmdpnjZGZ5sa02wLn3rz+6p15XMlRX3UruUUXAKPT7ubTrXVl2jiA==", "787869fb-bc2c-4d18-b582-c05647eb6a38" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67055c29-7cf1-4232-b42a-342bc2a73586", "AQAAAAIAAYagAAAAENO05UxeyrFLigPbvIzhvgd1ccitD+EuCCw7nCpo58ZWpIW6lkGV21bdO0S6WvsSEw==", "b15d25c7-9774-4fd2-8b7c-dd1f21d6d358" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9750f736-7185-4c86-8f3b-4c5f07924767", "AQAAAAIAAYagAAAAEGfZUCzY7Uq9wPj1XGQz0dTlPyftJbPKtVdcH/EUApRThBrSSeN1YG5xMvKBlTl4mQ==", "4ea48504-f013-4ce7-bb43-67349d7b7f3e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88939436-624c-4a8c-a730-c3c9095da43a", "AQAAAAIAAYagAAAAEP/J1uE8OFb2g1JMzvjk1/IT5GuVdaLVg9JFRXbe0SbnJpdVUB1r2vmYeSgH3ardzQ==", "33d34539-bbad-4ccd-bba6-337076582616" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0959b13d-db41-4c0d-8eb1-1bae7a5429c1", "AQAAAAIAAYagAAAAEMiL0YEgfCToP5/Nkek9yHTJH4R2LiDg5AmRZ/0v5U1DyBTyU+/79ZUabYmCxF6dYg==", "cc10ef8d-3b86-445c-9e1f-f345617c8d4d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7bb0a945-6d8a-401e-bdfd-b41d8e009d8d", "AQAAAAIAAYagAAAAENHX65ZC1NSHSxZ2B1qj1RKlrreBqLcLNt63+lYkvN3WkSjinvp7J0AlNJsdeg0C1Q==", "e3bd1cab-fa22-4628-b180-9a52adcdf0a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fc3311c7-bbf1-4838-b6ad-5163ca830153", "AQAAAAIAAYagAAAAEC2aDBcqbJmWbSrAVv4ENDLcBx0Jv5EbceHXyXArH7b566VVBZAWByBZd2vNNFtDnw==", "b6e31713-3019-4872-9bbb-5d7fd3bcef95" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "16b45d2f-7e19-4bd1-b827-c354609a4e50", "AQAAAAIAAYagAAAAEN0GuKv01QhvOkzwWy11ODkr6QMF3LDhXwdNT+MSvjI4v8Tk9wbwp7jgRzJYuOweUQ==", "fa8bbace-e3e9-44ce-b2e6-e093ea45cfd7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ffe7ebe5-cd67-4b58-aac8-efe6604f2f31", "AQAAAAIAAYagAAAAEBXWdHR3gnpxcKFfMsTHG9QyeRekuZaGP+zhlNUejXtBL5jZfUGGSflUsf/KM0TpzQ==", "c7901118-478f-4d47-9038-df73c3478f8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72a729ac-0ddf-45f2-8828-53c03b977af8", "AQAAAAIAAYagAAAAEORAKyQNSXSexMwMEZ+xZ37N7PoqBdJf7FVwHQyvtUcehDPH4Jdu69Afbo5J9kvGIQ==", "002596e0-7d99-41af-a3f1-18e0342b014e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c7d0f03-a664-4802-a9e5-dd53e7fda5e8", "AQAAAAIAAYagAAAAEHg3fejnU8XKqTSSLVD3lddCbsKgrzVlyDHvAV6oeoigr7m55r+nXBS296/xv/iDIw==", "f60b62b8-98da-4dca-adf1-de72441c391f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "861a3140-7c42-4772-a1d7-a85b59204b44", "AQAAAAIAAYagAAAAEGpsMw9nGYYjskiQ+r44tx07IczRr/48hQT51cZU01uN4ArfZdzwZYmIIajZsnDQEA==", "e25ba34a-0e57-495a-b205-050c2ad182c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bdb97ae1-4bc9-4c4d-b2eb-8d6ec0f750cb", "AQAAAAIAAYagAAAAEApCzg54Y+GXH7i+o5iwU6WTqB+lHR7Z8XByVV5UgY5mEDYK+tbHq36HdDnYpMYgiA==", "f3b5e6ac-3809-464a-aa01-8c2af4bf8526" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63c1bf8f-b089-4d5f-a4d1-604df3e8bb2f", "AQAAAAIAAYagAAAAEKVbrwCQDbeSKBke2jUiFj1dAUa1/wRSvZ1xLVk1rL8NlHFrzC8+IA8X37HKtC0Wew==", "23d4dc71-2311-4cf2-ae41-a8def8e24474" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49d11177-3c02-4843-bd15-76b034b7ee87", "AQAAAAIAAYagAAAAEH1gfqRfy0Tb8bZdmOJfaDNE4acr7Z7Hw6dVhA8gUT0HAh9l2vszGe1xJz96meG78w==", "5c55ed24-7735-4a36-9e46-9f3331f7d9bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7386d07c-0c43-4bb4-90c4-dcf40793fe4d", "AQAAAAIAAYagAAAAELK49u6DFpW3FFnjb47coR/bnldkBwV9Q4FuW0ADYgFh6kg2WvhGZcWeyWrpqq8ZWQ==", "28230221-2fd1-4069-bf43-beb647b81a72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78b43721-8edd-440a-a6de-2c4077611538", "AQAAAAIAAYagAAAAEHw28j0SHORadv77xN0TCpgnbWO+Ne58O1LFwoBWf6F3xTnYbzIvQf8JRC6k7VbC6w==", "66e0f1a3-5ed1-45b2-8583-a0973c32f9ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "507f9928-7737-4070-86b0-5a2e2efa6857", "AQAAAAIAAYagAAAAENTqIulCxnhFwD3tV+2I2x7NZVRczjQgVHckeXSiSu6insTGhc5mgyxa6YluHKJicA==", "d4d8f7b6-c39c-4e72-9538-5b2d7c09e2fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b39ff88-1149-41ed-b2b5-597f07ff587f", "AQAAAAIAAYagAAAAEHrxnGQZY+LT6OoXVSNbbKriPqdy1WkiH4MTgzrRk2w+UYjbZUgyrkuzJORK+HUj9Q==", "5623b163-2308-45f1-bab9-ea0631085ba3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c222c51-f392-4089-a87a-bb493c802774", "AQAAAAIAAYagAAAAEAKOh4Ua6VS/cvaYBykskTnUhuNun9ndFi21OmptfPg3Esm7hPH7xnGbz5omAUGWbQ==", "5ad527db-325c-43dd-be1e-62c72620791c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22696d66-6cde-4584-91d1-165ed7f25287", "AQAAAAIAAYagAAAAEJl2xQGtM6sHe2eqPF/cZdhkUUe76d5jOI7az9/fgZcOBNp65+ApfZT2+l0X1GG/2Q==", "cb8aafa2-d335-48fc-8d83-49cde56d1a8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10664968-df90-4fde-92b4-cd96d5e97ba0", "AQAAAAIAAYagAAAAEGKzOkUpFm/GDMDoxic2MkYZcBe1CkBuHyxVju5nD0MKmllWlMg9EPuEHMwif8XkzQ==", "e0a91ee4-ae1c-44a5-9e4e-b7e453a91786" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8b21af7-331a-43e2-acc5-97c313a9193f", "AQAAAAIAAYagAAAAEPUH6Sal3UEnIJrrSy5F7x77EgVV2BNsLhXNeCa7vkzhW5pgTlVSf5cC+QVtG3w2Ww==", "7a5b5810-5489-4e3b-9912-cfc4c992ffea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "668b904e-4373-469b-97ab-faca765260de", "AQAAAAIAAYagAAAAENhAa4wgaTooL8/tBjoRtzVTOxq5HAEVK3PmmSiK9mnQS3RoOIoSHZbbEFMeuZ097w==", "d07f1b01-303f-41cd-bc0e-f26644fba366" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6db13bc5-6645-48db-aeca-918c0ad9a600", "AQAAAAIAAYagAAAAEGhCgVTlNI2u4ICLnqpo19yO6NvWtGMcqQwwlemQwEN9tu5KTZz2l8PaO005mgBT9A==", "5ff0fd05-bb3e-45c5-aab9-1f930772708b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df6ca85f-fb4f-441f-a637-c4bc8b42cd32", "AQAAAAIAAYagAAAAEJ4O6S4ETJozQTYsFo7Sq/cwoLrsCsdUAVITCtwBoOVbaxdu2KDgKmoGvwCXRHD7Wg==", "7a6911c2-fb7b-4f13-a6d4-265a56150875" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15c2f4f5-96df-4e70-b7fe-09aa30b21b9e", "AQAAAAIAAYagAAAAEDH/6WBoRU4VZbX5lCdtz3NVdt4hUICSuFgELxxWFpz1dZBwUvF+qVAWpep+xzqkxg==", "24b89979-22b7-4388-8e54-df3a6ff0f454" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f36938d-d9df-44f7-ae43-97bafa32bfd0", "AQAAAAIAAYagAAAAEBNQ3+TECHHvgYtkBWwe/G2qWQR5+hQmj0ofROnY6xiK3Y6jqTJWmM4XXvLdy9qE0g==", "9a876087-97c7-451e-92a3-18e3ffe37afd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2336b885-6a99-4274-8677-15955a89e57c", "AQAAAAIAAYagAAAAEB8MOhqu6oaq1CuJ2amjen1BgIix2uM9FvmhXgTw/s5C6xVGdJXtoxIVKzadmLSQgg==", "3439d7bf-1386-4430-86ea-d42bbbe5109e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "803a136f-e51c-4fbe-9ba7-e21a98fa070c", "AQAAAAIAAYagAAAAEG1OsLU8aUJGDIFkdfFh4c0v7fHL8I7WbGluYPvz+cyLmKfJhJRqhUD0awb4oLX87w==", "0dcf9fd8-3693-47fa-b573-756a4f2aadd1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca86b2a2-e0d6-488f-b378-bb39400e2780", "AQAAAAIAAYagAAAAEH3lnOue268I31rqiXLcVFevi5oeSinFOknLlz04oK26uzc1EICwSBcCvoRl3PvEcw==", "86337dad-0a1b-457a-95a8-2c995e783765" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2e998e46-8610-4fd6-922d-561608e1d296", "AQAAAAIAAYagAAAAEO/jiQOXE+knz2d0Ztm+i1ykc90gedRhh0Pfg2jMgJA2A81ZodA7VSPQIHz6R3gu5A==", "26a67512-aff6-40eb-a638-76e4b453607f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9dbd711-3b83-4502-adcc-6d6db5afb97c", "AQAAAAIAAYagAAAAEI/fvv/HZYaPpxS339626+YFjuNeMAxg+qeDmDd5bqKGghOxQ/n/RcoU3tYXm4AZ8g==", "a0be5863-276f-4a63-996c-6142d86ae665" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb3ffe3f-cc40-4959-8879-65dc9a7dc0d7", "AQAAAAIAAYagAAAAEMAwiN+Z9hBPMkUgoz+24IA83qTqeVEAv93QoRXQpflbUnUj0Jlylu7DrfTPsSXvLQ==", "77c57b86-48a5-40e2-8261-14a136b0e7ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "871f8e3b-8130-4526-9ad2-9a29cd9889ee", "AQAAAAIAAYagAAAAEIPWz5KX8RiXLRM/R1qi7sxfeF4T61GekIqdC86EFxT67o74hTzIX3X1ZqvRqu31/g==", "c341c9db-9436-44ff-b234-a6d6ad52e471" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "adaba86f-f4d1-49b7-8cc4-14b5bc1ba0bd", "AQAAAAIAAYagAAAAEDqyD9XOTo6iTZMJj8xAQFtZJoCW8HcAXJE31raLVjyRQYIpzekH8u+otC2EDM64nQ==", "c4bbddfc-0cff-45f5-bfe4-655683178fb8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4829c68-8747-4b79-82cf-350b687eeb86", "AQAAAAIAAYagAAAAEH8ZJZ2V5t8ZzEGAfLToSVIVK9wx1ZVutrt1l9phmvPgsHW6dnt9tLLUfq7dnXCELw==", "bc5ff27c-e4fc-45ae-9a83-556046faa4b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c4dc2e8-e0e4-4371-b3ff-37cfa511f87e", "AQAAAAIAAYagAAAAENi7qtKdcFfLu42UAs/HRU5exJFMoaYwql6dNhVe9+S1wq7ueLorl4n3u0q5xfehSA==", "184fc8cd-b61b-4181-a221-d5304434c461" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed91c6d7-12ce-4fa3-ad62-a209137a6e7f", "AQAAAAIAAYagAAAAEKI0uGY/G6Rw6KCVUhtRZrtOz5lnXy26x3BL78KvOmSbLlYJXDrfoxCNHdnYtdmCsQ==", "d7e59d54-e36f-4591-a078-82d3db58e7f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "acf37c60-fdba-418e-8722-abc94910d4aa", "AQAAAAIAAYagAAAAEC8E+WmpkM20+/MOHa3HL0sGiPK4mz4kK1EMIwPOp/UCS2+QhKS0rbxllVEESEaeig==", "7c7bd5b2-3f89-4012-b155-747f521266b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89fb5bd8-a698-4f8d-b83a-c5e2dc01c512", "AQAAAAIAAYagAAAAEPUgnZGYet7fZsgZVii+6PYVF03h/lV8WYdFiAcJobMCdwHesgAcOKygxxri7Sri6Q==", "6bf41148-24ab-44e0-9b3f-41a52f9ef3b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a0e7189-73d2-49e5-b480-2a4b3a87768d", "AQAAAAIAAYagAAAAEHq48lBaJzD9V1TPo1Xih8TxZOniMTmvayTMFPqVDS441xc4Qa0Yq//7X6JBHuwdYA==", "d823ed8f-701e-4f0c-bf39-3c2bce919354" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d58a6d25-eeaf-42fa-989a-b50be552fc4a", "AQAAAAIAAYagAAAAEMTj6dk9pPCM/T86DbcRUcs4AeP84Is8c9lqlHJxlYuLmtl08ChygLqyXRGdjdopAQ==", "db0e0521-2450-4aff-9b60-1ac49934f57c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c83e4f2-e2db-487a-8696-98c75316ba88", "AQAAAAIAAYagAAAAELMlhzDss9cW/1MWmr3KwYoUlWYUUfJeuCXxaQesg12eY44NR7vPdWnPM9M0tWNONQ==", "8724fa23-86e3-4b0b-8768-32e100b4957e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9d4521df-12ec-4503-8903-21df1be26c03", "AQAAAAIAAYagAAAAEJ7tUM5HOXQqeiN8i+lA7ZJBd8iVuo+U/6h9LQbZqflDSrYioI6otrqeO+txdc6EYQ==", "96d56b72-052e-464c-b47d-36207560e674" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6204acbf-5e67-45cc-a499-6184182b018a", "AQAAAAIAAYagAAAAENXqBfqtA2GN6HPdR3a6zEanad8xGN6vIGuaLwFXudBHlqwEd9DXY1SkmbNlcg5zUA==", "465377ad-8249-4712-885f-bdc79604b050" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbb09b7e-ba59-4bad-8795-2a16fbed64df", "AQAAAAIAAYagAAAAELgW3bTDRR3SAymolYkdBACDn5fBCkb8lOB0IsVnUxS755kK55Wgr56HE55Ip+xANQ==", "e8e6aa10-e5bb-4120-82d9-48cd66b5060e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c3b7613-f27d-4c07-b0ad-0563e47a936f", "AQAAAAIAAYagAAAAEDwmMTQdxoC3uTw2Y/sNq56ue2BwpZlO2v10ujNLCb2gUUMpMdKIDkzVeFM7OfI01Q==", "ffa241e8-14d3-49a9-b936-3467f42ae1fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ca7b69b-6755-4b4c-8cad-730d34c549ed", "AQAAAAIAAYagAAAAEIjS+bqsQIgTkjF7/VHgiicpRLds7oXStKSL+IKkUeKK64WwS2+tJ6iEI8pU1xFlGA==", "7544b37f-b9fd-4c0a-91af-1044a3aadf78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a12cc295-17c5-4914-9042-5ade76b0a2e4", "AQAAAAIAAYagAAAAEPvkxQKTkohVPRZ+ssn7JdZlqND5KJmyuEQaJwbLBEdpcbG6tUrTsJ+fPyRYl6oosg==", "82c2e2b5-01aa-4488-9114-f7bbd1102396" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd678c73-dd58-480c-8103-1ebc1ac8173a", "AQAAAAIAAYagAAAAEEVSjIME7jekvCiCoGA0GtFeaop1I01QFt73tDPfgRHHkAnWhBB9k1AZ/xCv8NJ1lQ==", "51081b82-ceb6-48b6-a162-5ef3bfcb98ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8325ea77-cc34-47ea-88c6-429e09175b7b", "AQAAAAIAAYagAAAAENHH8OB/ZLd/bk9p0xJ8GFy3BGmD2yVcVHqxOwCYsuz0DLaGUm2gJ/JO4haxc31R8Q==", "dbd20967-f971-4e78-bc76-f2125aa9c264" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "886c02cb-ce0c-4bf4-ac78-988166838331", "AQAAAAIAAYagAAAAENgpUfvJ+xrHvlvo0HHQaTjkdySbEu+jsduoeHb7ArJqmF34Y7xwU9ZhQPZrJnGEHw==", "61ce6a66-1e49-4064-9029-70e6d01a71bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "92f9d597-16ac-4159-bfeb-78d211279d99", "AQAAAAIAAYagAAAAEFYF+qoI5mzgwbDZ/XVn6owYgqdTFElq9gAlqkE86FmPKiE3i69Y53HUIHkahLHZ4Q==", "8ee4c37d-d752-4bf6-9ae2-70108e379c03" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4fe19f0c-022d-405a-a5af-2fc1e4677ecb", "AQAAAAIAAYagAAAAEKM+lc7y1NLcTt7lx80kS9UVo2z0sHjCr4TG4nwUmLzQPiS5aXySQluWZaV3p5jgOQ==", "74d59891-5d4d-4af2-9a17-b81247ffa693" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3adfd453-cc94-4580-bb09-df65504b0f60", "AQAAAAIAAYagAAAAEFhUdMkUISaCD41voD2u8yqJSahKqwLw3AzUmtasta/9yE0S9/N7QP4ipxDVj/QS7Q==", "737d88f1-425a-4738-92d3-fc5e6d6ae0a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db662650-d6d0-41ef-a65c-8cbebcc5b0df", "AQAAAAIAAYagAAAAELaCXfP8odb7bJr9w51W6CtekPHolLR91QCe9AkiajZbHhl7T1V2qaexaJCAyTpsIw==", "5b7035d8-b74b-4422-9b30-e95f257cf33d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b4c61f1-9457-486e-8504-1ed0c4bda53d", "AQAAAAIAAYagAAAAEMoZ7AmSuvRJlRDOMOCtK+wRw6kUyL/r+jgs3LQz1LBEdwysxrmHxYfDtS+2vcP1Ig==", "0459c9ed-a9c6-4fdc-a01a-0240d218837f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72bd821e-1420-4493-bd09-8ba75744f430", "AQAAAAIAAYagAAAAENpLdpsRiaz5xKQvBygZC5tWJvHQmF7+30YvejjGy9hvmdhYLyd8oZXU2NayyDDJEQ==", "5cc04d1e-2d26-4575-b5bd-8b59cb0b8eba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ac255ec-11db-41b9-b38a-66b563d6513e", "AQAAAAIAAYagAAAAEHKpsNCuASBoA2QSy9m0YdFi591Nqree0dFL24e8NuI4bGoeGcB34MHI1s7JtPXKlQ==", "f9dc3d39-faf1-49d6-aa73-1cc8ef411f4a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab9869c1-ded0-4ea8-a853-2e5dffbb8c73", "AQAAAAIAAYagAAAAEM7/BqZqjw3lzk+EdVxVzomO23mblynpZwHsVdwpWldaJZycMQvhUhv0p9KWdxBEOQ==", "9492b4de-d8b7-45ba-84e9-e1bb400e9629" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d887c44a-62bf-4daf-bd2b-2e45246ff281", "AQAAAAIAAYagAAAAEAWzhP46aEL53yOejUPvDFbW56V0r+ZaWYNSQ3AlFMVQoKBVk7/DChtfBaJnv/N6KQ==", "6d912df0-7f00-463f-8a78-0169313d1c01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c9af394d-f863-4184-bd79-f48bb7f22e80", "AQAAAAIAAYagAAAAEAxIHlxhWNgw9OB8Ls5Gti5AShaDff7j3oEXTZA9UJkPMQeybNrESewJwphSTs7zDw==", "cd8532ff-bc5c-4a6f-98bf-c84391c40f8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68628103-593f-4fec-9f7e-94f558f84291", "AQAAAAIAAYagAAAAEPPXmi1+tEworiiD9Opmn+ixcYa0rEjK4HHiy/9arL6uCAxu0C9vNFvMzwVQ0O3cew==", "13fe326e-4910-4d09-8f24-0eca92df3a93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b95d8cd2-ce95-478d-b885-559ec045e840", "AQAAAAIAAYagAAAAED02Ze83w60khEGAGAH7mFhXXthq9SholQ8b22k1UeUL4XPchmUiYLCSonxb3lSmhA==", "1dad6fae-3896-406b-b7c0-26a65ba649d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6037e688-595a-4180-8bcd-a31983a0d215", "AQAAAAIAAYagAAAAEMw3uQEw9OLLID9OlbtkHkMW9RhzPIHpq5JZG6KSEvF64piMnUk+4H8t9n07ZOs12Q==", "fe001ccc-a518-494a-808b-8d6001e07821" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3976de1f-0743-48cf-bee3-57fbb9a03023", "AQAAAAIAAYagAAAAEFTaEp6ZrG/UoGxHFcxXToc/nRZulXl+VNnhWLovOiPZ02wS7LSBn+sFj+C3OCwZUQ==", "0bc7d13a-d100-405a-996d-8c0978e1fbf8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87d558cc-9a8f-425c-8e07-2833974e7e0d", "AQAAAAIAAYagAAAAEPO5l8cPCEUepolszciCg+iQrflJxSffERVECkyxc2mK5Zg227WLvFMj80isFCMmfA==", "37402f25-681c-4203-932e-f8af58b8b8f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "90f8e4c5-2923-40c4-91b4-e685e8c02b1d", "AQAAAAIAAYagAAAAEDDIm+71rgsW8GvjOLx7+6gaGVbBNgPcvvRtclS9TFXWQj2g5txJdCPNoigsPDc8mA==", "8075fa98-ca1a-4f45-8f43-4f923955b34f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf2ee5e2-a1e4-4948-ac04-6a46f6519185", "AQAAAAIAAYagAAAAEJ8dGjC2v83cW7g1fWMC0bThGAIslMO6uMowdwaKh/fcFQusi31Dxu0YELL08ndHXg==", "dea001d0-4383-41be-8307-862e635d8c56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb27a5a0-a889-4ef7-9f53-7cbaf839a6a1", "AQAAAAIAAYagAAAAEKZeAJD8izhfS4LW1d+QPIGsrDH2tOEIcMbzwH9xcECrGAC8ls8MpQ/dCu8Ji+GZWw==", "fb709cdb-c5e9-4ded-a11c-d2b56d400c0e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c202e79-c3cc-488f-8cf9-03f6a279aab9", "AQAAAAIAAYagAAAAEFZD4Dz742cW5Tb9dAWPdSkswcuVqHX6QZkSuJ0MDDYeE6cKoXPgixzF2atU++39Bg==", "4f308f8f-e9c3-4460-a7ee-d6b16fb70b43" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00600225-6870-4018-9f32-5608352d4113", "AQAAAAIAAYagAAAAEBgDG8qahFJHNp8F1mfJA8LFSoe8BwsMmOji7/c3YR8TGujb+Cl31FyHetPkE3APDA==", "8b1fd51f-090a-4a59-98b9-ad54d6cb4c6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d94fceca-8ba0-4ae1-861c-06cf46805e68", "AQAAAAIAAYagAAAAEGViUIxndAx4+ALpC2Ud1csdG/nI0jh8MF1Ilj1yjWJvFK7SfWrOJWIn5O0gPt0bNw==", "4e56c3d5-1122-4492-b8e8-5fccb7bca049" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6106a6c-359d-48dc-9a6f-9429af07409b", "AQAAAAIAAYagAAAAEJVhmWFkXvCHMc9mK+Qq8UWT7xVtwnYx3FAucSMm64nEC+llWlAZHF6wdvK5/df78g==", "db615ce5-36ef-4739-9603-a65c107ba047" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c53e8fe-1532-418b-832a-c435b6589051", "AQAAAAIAAYagAAAAEMRXVuj2k9dRZUqkfp44ANqsf7U2bnaG24j2FHOclIpL3382y+WRuZAHt7dk914v1g==", "981a965e-c3a3-426a-8ddf-60c12bd9007b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17275b82-b774-4a61-904e-9d22462918f3", "AQAAAAIAAYagAAAAECL7VDZl8mQmPCKiwhGaNO3838ObCisFK+m9oqpb+1/daez/PICWUz5PnLrGGUn/FQ==", "5ce27965-0735-41f2-9d6e-5f7b8be14efa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5161f908-1426-4bb6-b505-f437f5591cb8", "AQAAAAIAAYagAAAAEMSgBsrioCQUwmVinsKc273vAZOeP6LWklIp8nOoYcuaFPM3YwiMxVpJZXt3bPlgDQ==", "cce67c5e-3e7d-4d68-84ca-08fe86c9d57e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0a07905-bb43-4bcd-a096-ae07d2f7b7f1", "AQAAAAIAAYagAAAAEGqsOIpyBoZmU/Kmqa7x41XTLoxksuQbV+DzIGbe9xkEPYmwAP/90A45hTwUcFsJQQ==", "00378713-0f62-4a73-bc00-98a3d08c5770" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc6e1779-4074-404b-918b-fdf54aa9387d", "AQAAAAIAAYagAAAAEMGGr/q/t2YYrWs39Jamh1wfpdzFFfK+aGJW0GpluBJOXBn9WZYAMzu2s8YN5+qUsA==", "9ddbe76a-c42d-4ee9-a0d8-7dc2297a072f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f2464b11-4c45-4921-b1b3-d0f47ac38bc8", "AQAAAAIAAYagAAAAEMPyNpnffo3ijkhaymDzdFR7szUP5QjMTP6Y3b0WyyBDzAZjiJpCuxk/DEpFEiXtfw==", "aee59a8c-e191-4a5f-ac70-c6a45ac414b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "246617da-bdf8-4a9d-bc06-2371224b8338", "AQAAAAIAAYagAAAAEL+dzGap8LeVVdpNsnM6eEAUEv8Q/etIELcMP58ibbB9c+gjR/SPLZNaEVfAc5A6aw==", "17b8e77a-1246-4c23-98b4-c2d21aa19308" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9603b3af-f52c-43fb-bfa0-fd0f85f0fe41", "AQAAAAIAAYagAAAAEG4pQGEhw1d9iDAyF2KHammqXaWZsu7YKAu+dA7reDFXHegQDiaZes7kuTRr3/htsw==", "f91babbe-e30c-4016-9e88-55e2e8125f7c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3c9e396-9e1f-4511-a471-b25db3ca4eca", "AQAAAAIAAYagAAAAEMKI+O58YmcSrWUxlCchmxXHQZSg5IKrOhFgY+dDGA+Ddz3hOOG2UlUDhdnz+izzFw==", "c1612be0-4274-47bb-b7da-0e81cdef7504" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "563906fe-4f50-442f-9d5d-cb79e4d137e5", "AQAAAAIAAYagAAAAEIeaCz2D9BZSXtP86scSCVIVglk624PgT3jNbhXvr7crQS/khqg9wthhUDBzQIVRsQ==", "0ee8a9ab-352c-4be9-b152-d8841e6caf3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da61b0a6-5e6a-4b6b-8127-383a2a8b0bbc", "AQAAAAIAAYagAAAAEElGmXYIYgXMpoyo4yPV+S2fjpXaVRYEI4srwOc6ffUe/VXFl3fzST50zlijLY+8dw==", "146e4179-6c15-4442-9ca5-ac4ed2fde2c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a62165f3-20ea-456b-9d6c-594c06a527a1", "AQAAAAIAAYagAAAAENGNsAjx43bqJGMIuBVImT518LcxchvQJc9G8sHvJnSMJbv3L1XTp32VDem4HP3lCA==", "44136f37-dcec-4385-947e-5930c0b2011d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89ca474d-85a9-49ca-b3da-8bddaaed03f4", "AQAAAAIAAYagAAAAEK/8JAUT9Jz4ePVrs1cTdbvL+WwRwpyRV7f/fLjNqVkppuZB3M475yLGnU4IMsni7w==", "d9f0a132-1691-4ba7-a3aa-d7134883b57c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f30cd67-8667-4c97-8547-ed6bf58ff16d", "AQAAAAIAAYagAAAAEPYrXrHUXEJWP18KH2wp/3ZFnO+jOwgWLhPQDEmqvcji9WmCWgQ41fM8xLXQseFMyg==", "9dc404a6-64ce-4d86-9b50-e9f6f80dffd4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0c9402c-77be-4eeb-b8a2-f5d96157ca8f", "AQAAAAIAAYagAAAAEDccWovuGEyWtFxMaOQmsQBt2EaekqMYAjoJ+6hLEsMQOI9LcgI6jrknc144+hom2g==", "daeb4364-f9f6-4a20-8877-1ba26ee38ac6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73cb9176-4051-431c-8420-ef83baea37aa", "AQAAAAIAAYagAAAAEDa+8tQLGsuDk/Bf26Qdo8/GRyKrpqzpcxLd5xYtRFvoCjLRf9+LITkk7BBmIuZOFA==", "e3384fac-9bb3-467c-99db-5e2e2620bbb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9426418a-ca32-4931-9563-56113b6798b9", "AQAAAAIAAYagAAAAENJ3yEqNRzz8actHOeh/cfW38BKgMs3ZzmrAdLI/GRvRN2nk4JuQv4Of160OfkchWQ==", "7bee145d-7fa1-4ce6-bbb4-757ac484ff1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "daf5e796-382d-41ed-8a0a-b3581f3c45ef", "AQAAAAIAAYagAAAAEHrjcZr2xbea9TVGbwtNbqFcd7MYfkdMckHQEd4OgME4aPrZIZNLn18ljPlcCrZuRw==", "92641e63-6c50-4383-8953-523dabc0f333" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77f88ffe-3299-4f77-b7af-30a3833f6849", "AQAAAAIAAYagAAAAEJQU6SMWP2qlPtYU0Td11cxYsEaUh7NvWKVUZVw3iHIlQmLl2BkdnaiL68/hT9kZsQ==", "b4ec219b-58a1-4c68-a358-62904908da78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e799433-8c64-430d-95dd-75def080a552", "AQAAAAIAAYagAAAAEAQ+VHXoDYDyvxdz9mnfO9kfEuk/w3O17g0WINchLwHmeTXT2BSLv/3ono5SeBgnrw==", "fc6fac8d-81f1-4679-afa5-ae56ac4f358d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "488a8c16-6728-41a5-8fc1-85043f4d42e9", "AQAAAAIAAYagAAAAEOSx8p+Jcaj4m7O+Foamdw7+LMSINpv7BrJQEZFaXiV+sDLgzFnPVA4PF8Q/Q8RLOg==", "5c6fbd52-98fb-4ad0-afba-0737fe0b2cbc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc6d4ef3-b5f5-4920-bef5-b60bbf56f4ab", "AQAAAAIAAYagAAAAEIDS6k1km19kFUoU4sHAw9RcbdiBR0ZWmKOotlgS2S0xihAD8Hh+ZjwyThJzOtfjhw==", "8e07ec31-7c00-473c-af31-bbc1cb7184c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "574ea72b-6819-4edf-9276-3a46bbb0e8a5", "AQAAAAIAAYagAAAAEHejySgiO5OZXfWOy5ijO6KN9KfBPL+c5QnpK8XGa2thjna81fn4KOxIS7+AB3HH3g==", "40107efe-d6f1-4197-be63-d3cdefcbbb27" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e2216b7-5a7e-48b2-a4ba-606ca13bbec8", "AQAAAAIAAYagAAAAEORKnGM/yj2AzHJ/Tebok5vEw7gXrfaTYITo2s2C9zhmzQAWP6Hp2udbPO5Cv12VZA==", "bb5e9243-3791-4435-85fd-241bcd246811" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d8e26c91-699c-42b8-852a-7250a3d0b4a3", "AQAAAAIAAYagAAAAEERIuUrfehwsO6uSDiNFInv/NHjsbVrAhUZzo9Qi7PdrVv7Lxjvl2Sn13Di1Xu33WA==", "1a1b0d00-73a8-4401-80f3-19a5864285bd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e5232a6-8862-4c7a-b353-69d56bcc48a0", "AQAAAAIAAYagAAAAEEiQM/D8KRAUZvsePBGWU1d+WUnJnzIHA8SYyLhYjhyoLyu+vVy+iR5SjqOhaLOahQ==", "90c789d4-448b-40e6-9649-7b5db2b1ea17" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46c6abee-efaf-4d35-baca-756e69217c8e", "AQAAAAIAAYagAAAAEM/4PGlJ1fFPgecK+YFs0+B1EFWbCnP/JSL7I88oS0kD178KBqeNaRBj6BvaYryTdQ==", "c7e94a3c-af16-4654-b956-59a5fba67bdf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c48aa9d-4031-4772-828b-2799e48cd02f", "AQAAAAIAAYagAAAAEL6D90p7NMDJ41j/PpCq+O/D8uw1+m+Gs7r6vgNO6nu7hV5fNW1N+n4+ntj7FQ6ReQ==", "ac4d1e4a-bd09-4b9c-9d38-7ca253ba3294" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48da31de-29dc-40ea-8ecf-3e56dc903648", "AQAAAAIAAYagAAAAEK84hDshEwJvvpYy5PLXBjKmXuSTnJuFZbNAWyBFEuYss1LHaL6jXSB31VnCUbE+Ug==", "216f4fa4-bf78-437e-bd32-c3c019feb0a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7cd53cc-c49f-41be-a1c9-92a3c35e689d", "AQAAAAIAAYagAAAAEAQGJb2e5gKG+DyHIBjOTqyerxDUzbM3iuBOTRoA/lnlOHCSNMSy2Hngk6PCoeGXfA==", "1624cdc4-3e66-4a42-bb13-3a8f534ea5af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be47fe52-2312-417a-835d-8afc33f36c16", "AQAAAAIAAYagAAAAEA0vI9UwNDuzqta0HxebmUZz4DOg5ZFfo624G4Clbsg5pLgTC4GmGmqf2tAkIcDXdA==", "5a020bb3-2702-4879-a8e1-add1cdc480ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e08c424-93f6-44e7-86ea-3ec60d1a962a", "AQAAAAIAAYagAAAAEJQz1yTgsdrx/5/YdyM019WGr2rAXpZt2foqhWSC0J5r2ieyT8aKSatEfcVPu4M40Q==", "fa86ecda-1885-48af-a194-e5a4549ef7a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f54a103-bfd7-4fe6-be42-4abf23c3aebd", "AQAAAAIAAYagAAAAEOpCuUt2hnAoen4BUtjiKNzpW4IAutZ97VYZpRbR7NWj1+yUv/mCzpSZqeFBfdiJ9A==", "caeda867-121e-43ca-939f-f638a85f4fe6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c0340b7-91a6-4256-9d86-fb8999a6fcdc", "AQAAAAIAAYagAAAAEGjKYqsCsZc2Mgi8+H5v3OHarOHDwHERK+OuPVNJE46bid6vMUlo9A6FJBJGOiAkzg==", "206b4cb1-5d0d-4f92-b027-e24872b90252" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7295d28-5454-499f-96f3-60a97feec631", "AQAAAAIAAYagAAAAEDXqLG0KgvsAO6/BbmuVYvsAGUbuZaxZ5gRCWTHjZcG5Yd5WTz7jBqOj1lK8cJL3Rg==", "f0d6336a-0e93-43db-8555-a40b4f404f05" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d32c71c2-c17c-4635-830b-8acdfaf4eb71", "AQAAAAIAAYagAAAAENQlWES37h/Y6n/6qkaMxicCBccgYa/Jn61kopiRJNMWmQ6HfZ9ZrvoB3VLgqoG2XQ==", "96cef33b-b265-45dd-b885-70d431648826" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "447e71a3-74fb-49ec-ae39-24be915dad37", "AQAAAAIAAYagAAAAEIfojOpW6HMtUYV/FLQlKhCNGimC1g6cx629yd+pkxD5NKxmaN7Mpl5KqT376Jig5A==", "df1f8294-1cca-4eae-bac9-37dd045faf16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3be1a842-6680-4f60-978c-d555636f61a8", "AQAAAAIAAYagAAAAECknOoVqgrWlFfOhUgR+jlhsJI9XCApIJrGh9t1/6cLuRkiAaxQsPbnwmENKWcW6eQ==", "8ca48f93-c363-4618-9778-82627e6b9b88" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d89aa2a-ca59-40e5-963a-3b32128cd033", "AQAAAAIAAYagAAAAEJSh8WEdQLJ3RevrzL2yCdRUBqdGFiQbUwdhTl7rDN4hh82i0QNkn4Ma5N6Akqdxow==", "74efb200-10b9-4f48-a221-d7dd762eb781" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17e8a40c-5e38-48c4-acf0-0fcd782461fe", "AQAAAAIAAYagAAAAEEmSeiOej8XxytZWmDBB3gXo498gn6T029ABgC86KFXffZUs8lNQUwXKuaCyZYTV0Q==", "f54c1e32-50d0-4ab2-9b4d-90e3f1b37c21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "866ecffb-91ce-4c37-b369-e0a291c23dc7", "AQAAAAIAAYagAAAAEKSjI7F9obLiozXggvd/fvB3EUAZKkGCxHdwpkVG1IUTCqFO3I+iVUWhl25j5sPPCQ==", "a19c3d25-2de7-4055-98b9-f7a4c7ea5304" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b8e9d48-deef-4ffe-8a04-a6a506876785", "AQAAAAIAAYagAAAAEJtPPbySrrqy8qAMIduyNJaKvjlgD+4Bt0TMqhnH1BXo4GUJ5yxSnE0WE43jRI1oZQ==", "b03e1664-fce2-4488-b984-2bc16d7f0a94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52c22cb4-641a-4e88-b2f3-0eb1e66ecc69", "AQAAAAIAAYagAAAAEKo4k6OL1VhnojDtTArk8fNN4Q2ISEvE+1iLhgKIL3YLOJ2DQ+YgF4vRNH/LHhY9/g==", "bb4cb5b1-6b40-4d6e-a4df-be3f443300a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a538b164-904f-48f3-b9ba-fa5f06b99f6f", "AQAAAAIAAYagAAAAEN1h+/TkzVa9KD3pCgERHVNFROBO4cEkcyewY4RCP6PLS3Jr46CgftRUUXM7+EkioA==", "6fa11815-43d1-4d5d-b502-5e8904400ec1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd5cbc42-b4dd-4bed-ad42-56bb3d9255e1", "AQAAAAIAAYagAAAAELt6xRenJLSIrp4QhDBOk0WVyKlT00fYDJzXD4V2LXfwC6tozdK6E7HwziSp+wzC7g==", "444496ed-4688-49d6-b091-6bd1100f5c77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aaec326d-7e4e-4373-b1c1-8ac65db73549", "AQAAAAIAAYagAAAAEHRipqiSEyO+nCdhN71q4ELw/KlsAQi22OtUzIROAJ9iW1Fh/YeyryQw/3aPDmEl/g==", "80b5c05a-5cd3-4e63-897e-b33a82910518" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30fd1ec5-0e45-444c-9b15-8713cdf5672a", "AQAAAAIAAYagAAAAECLpUsiYw0Gh745J51epjCMLtYpb6TBZIR1eOFa2UvPQlZ575A3MQJVaLAamSZHMNQ==", "3327a44b-4c4a-42c5-bd47-fa42e04c7268" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2ccb7d7-4398-4756-9c08-9188cda8678f", "AQAAAAIAAYagAAAAEAAhDAPf+TdYt8lw3FmFeayTlriWYK4qbCL6XvfC13zgeADJqGWThxdtr8z8wo5org==", "e8a7969a-f125-46be-aa9a-3f9a6b8a8044" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ce7f6f3-abdd-477e-a792-210bcb4937cf", "AQAAAAIAAYagAAAAEFXIxjELVLXLMWDujPSmpNwOcsopHpG18781NBsteIh7+jdxSvcsYP/hBpkAofuYSA==", "d90e91e2-0f7e-428d-82a5-ed88f8a6a304" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72b38c8d-2627-48b2-a284-40cccc4c91f4", "AQAAAAIAAYagAAAAEGj6B3BnosR4UuhTGcGpUUclu/zdzakGR1MHiqe/e4sNh+FX8/AvUoOz/VtHLXJiVw==", "32e01aeb-52d4-41b3-bafd-2cac9f10f407" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc9852da-0b12-4b9b-8068-4a5efc7b61cc", "AQAAAAIAAYagAAAAEGnvAImTOAwH2ev5BsAmiaXW5QbAjOzfIVRQ9XrntTC0Ezfo8tjh7hBSWYumdBbMNg==", "0be73452-bcd4-46e8-955d-464057706d0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7e042e3-d857-4e7f-b490-48191f218c79", "AQAAAAIAAYagAAAAEJmjv/OiVkZ5FSwtPafe8B5MMfcfWH1ZslLnRqTeECy/+T8Y9Ju8pQfmOii8uyMBIQ==", "554929b5-3445-43b5-a4d9-45bf2e894cfa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0cc96781-ed8b-4403-88ed-a888ea301082", "AQAAAAIAAYagAAAAEM/k/4p8BEd9kBTxHimJXFp2jGxtMC1Fv52oyPXZgEV8Vp1kl3m6MWP2cEdhuJp37A==", "ca193ee6-eaa6-4fca-ad01-ec9adb3a2a4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf7eee32-2e23-4f19-840a-637223e0ff91", "AQAAAAIAAYagAAAAEPRM9NaY0Hq0j7vUmzTTBG2YYo08IZ7T14Z6h7mSEOkacJMwMw/WlYGApYg2X3GExg==", "b668b714-cab6-47de-ada5-d327a6cc6093" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae01a428-80d6-4b69-af79-b89a800c6d21", "AQAAAAIAAYagAAAAENkjiSuC6U9kFgCq76KTTM7RlgH58MtbHj7q2Yd6lmzb+dT9s0g80aLNtF+SLy3u6w==", "eb1733f0-2700-4726-b817-02a6721d5650" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87d4ed1c-fb6b-45fc-bdcf-1c45d304c14b", "AQAAAAIAAYagAAAAEIYO3dHwjqjG6DbzKEfSlJpgUBHHx9Vrd2M1TaOL/MvBfB1LzqBKJYhglQ7QJyAB9w==", "29d473a9-7901-46da-97ae-d70c0837cc12" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "565021fc-0f5a-4471-b95f-9009f312adc2", "AQAAAAIAAYagAAAAEH3IkTw43BRsT2Fn1waBYeqxpe8ZC6TDAODao5+THkZtUoSr5gTil7H1hF/6EgZDog==", "441c0cc1-e04d-468a-b199-793ca642bdb5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df6a72d4-e9e9-4ace-9945-ed9cd9881b68", "AQAAAAIAAYagAAAAEMFOkpqnl1hfNWV/y5RUDZDqgs7bhGXaaZMiCZXzQrF21LQlVOKwFBAvK66ptvpYRw==", "4fc023a5-9b5e-4c9f-8043-81a289e5a0fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b384371c-c5a3-458e-842c-9f8614665663", "AQAAAAIAAYagAAAAEPapzotakuyljNzCADIutGw3oVu1+1bXUHwZAjI0cjb5a5kmPmeQVD6tFS0+WySCBA==", "c8d69353-464f-4161-b341-3f567f33e629" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3542b4a4-150c-47fd-9359-1bdd55cda913", "AQAAAAIAAYagAAAAELtpSij7hQaq6smTM5Je/kD3YwACANR6gAsCB2AgaQ7LJB97mSUsl12j5/ttaOTyJw==", "6a791fab-6cd7-453b-bd75-8325fc6f6427" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "013d4fc9-f371-4e59-9a57-d251131996f7", "AQAAAAIAAYagAAAAEHyLc1O9a6V4PYB1jV9AFeieZz+5LbHmzTuELIdPEKAJYz8DLCNZzAEMgYR72tHk7Q==", "ff0ac479-af66-4c85-b32d-6e4cda45f810" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99b35078-ebca-40fc-8ebc-bea72fc3b1e4", "AQAAAAIAAYagAAAAEF8hLU/a8uijfR+vSzJNLi41U/zgQ9FuWw6Aq/sOIQss7eZT1ECMgJTLzUpFQoBhsQ==", "74d6407c-81da-4725-9ed0-2ab46001e0b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c814b30c-50f2-45bd-9d66-d401551fd789", "AQAAAAIAAYagAAAAEOzywHRfHbWBB1TgSR/+LuwwKs0pKdYRFyx7akP4U8oWo9Zdkw9I3+rwLgNr5dOesQ==", "9cc81b3b-bdcd-4d90-9944-532033ef1968" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "53235303-13e1-47ce-abce-0ea778dfd1ea", "AQAAAAIAAYagAAAAEK9VBPUv/zZsXoiIU6vFJL7c4EkzaK3ek+Tije6gPbyFtlZm33x6FycsOgiJKIFFLw==", "87f5d982-6657-42a4-ac02-37ec1adf61af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3f222e0-af75-4c3f-a5d4-cd0edab99b27", "AQAAAAIAAYagAAAAEF/Jv3QhSBH5MQoqvahnz5eqNth5w1/3vCQ4dXGZrLsKs1SNBfgPz3jT1Y7whuL8AA==", "48d835e4-e230-4ae3-b2b6-22e1c3c82acc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "061868d5-dbfe-44c8-a0a3-2652a5535659", "AQAAAAIAAYagAAAAEPegH486IEJwznPGpkDUdGmtU3mY0ycrMBbP/TVHpUn7SIBv5gBEFfpQJQqChJvXRg==", "9e1abb9e-42d5-43cb-8352-969eff472560" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87ba24b2-5826-47ab-b0da-38dbe9b9f3f1", "AQAAAAIAAYagAAAAEIE2+iwdsDiauBEAwKsSqyBy+2y5/5U0wUEUZyLv2krm9OITeUrt0/n9zrFVG01lVg==", "099f3cfa-e3d3-4624-a613-8e3b10a63381" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8280b74-7689-41fd-918f-9fc83dae67db", "AQAAAAIAAYagAAAAEO/XkMS/njvkyZFqpYRFb0vMKxp+DqARI0gYEZRUo/HMBOzKcyrElnvFKxdIhCYyyQ==", "680027b7-a45b-4cb5-8da9-e448a3937430" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6b206ef-2cda-40a3-b7a4-9997680ded74", "AQAAAAIAAYagAAAAEEvPMfmjv/3Yvq8NFcMYwY87aH9Uj3yxE97WcsiZhJpZxmqyAWSZ5UJYx9/hn9uD1A==", "d744e6cb-54bb-49ff-b3a2-a55ed262d7a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50ab722e-3f34-479a-90f5-6f087a0a95c6", "AQAAAAIAAYagAAAAEC9OC3VMvzdq2S82dDnEEOnJ3jZS25nSmMwLriEhBUgvUShzzXmaxyECHgvN4Y08aw==", "fc3ae13d-b6e5-424f-aa70-22c6bf868f1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0490cc0-ea6b-43a9-908f-76ba48843af4", "AQAAAAIAAYagAAAAEHWLZjrJItwAk7zRvhaYwyRzVd7x0c1ZOAxVTP0bIMBiuQvL5oEVy6FjkzKN9RaTOw==", "0ee540da-ab77-4aaa-a8db-b8a6cf96404e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "207f47a3-86ab-4c20-8dbe-1260de0e65de", "AQAAAAIAAYagAAAAEJ/RL17ATmvkCFwvEI8ll4f7Q98bFBy9EtYQ17F8vUzReDmz1tcPIR5t4O6nXJPLcw==", "4f8b49a9-b467-4fc6-91e7-4e40980ae7fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47925b60-45ec-4cb4-848d-f6b353398ab3", "AQAAAAIAAYagAAAAEBU5+oguGo1j+pvLX7F63mNn+G44wW56T0BG5rdQlc0rmuJLSRqPVUGKmYw9lDez3w==", "dd340ce5-0451-4db1-8ad8-25b050811640" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c1d50191-f03e-4a94-9f8a-45ef4142e4c3", "AQAAAAIAAYagAAAAEFwh/6mM7/ZpLKxD+q0OvWMDNcJV4Xut8FLRDn9LyexjVx+ODbVE9CZjKmY2kjos0w==", "b75801ea-6ad8-4308-b2b7-3338856ffc1f" });

            migrationBuilder.CreateIndex(
                name: "IX_KraRoadMap_RoleId",
                table: "KraRoadMap",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_IsoStandards_VersionID",
                table: "IsoStandards",
                column: "VersionID");

            migrationBuilder.AddForeignKey(
                name: "FK_KraRoadMap_AspNetRoles_RoleId",
                table: "KraRoadMap",
                column: "RoleId",
                principalTable: "AspNetRoles",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_KraRoadMap_AspNetRoles_RoleId",
                table: "KraRoadMap");

            migrationBuilder.DropTable(
                name: "IsoStandards");

            migrationBuilder.DropTable(
                name: "StandardVersions");

            migrationBuilder.DropIndex(
                name: "IX_KraRoadMap_RoleId",
                table: "KraRoadMap");

            migrationBuilder.DropColumn(
                name: "RoleId",
                table: "KraRoadMap");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "KraRoadMap",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "bf3a2826-0b18-4185-a650-9880582b0fa5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "8f20b7b2-a930-4a07-aa6c-51b359216106");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "91fa9167-ad69-4e00-a5eb-6ca6be948677");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "2c6f9284-57f9-41b1-8449-44bf3eafa0b9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "fdb73eb2-110e-4935-b3ac-e0261fc733ff");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "c09c621d-dbcc-49a5-8d63-341fbc046295");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "6a4674cd-684a-497c-a6ff-7542ac7f9144");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "60fccdf0-4172-495d-a7c2-e38b026bf4ba");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "42f92fb2-4b81-46a9-89dd-6ea056295067");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "06b4a23c-7f1d-43d2-978d-d052bf9a646e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "ad04cdf9-beb1-4db4-a4e5-8dbfaa58cad5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "4a3d5c88-a5cf-4575-b685-dd79ad9f85c0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "3ec7547c-e1ab-4b24-acf2-7bb8d4135fcf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "05e2a5a0-1a10-4f4f-ae1a-f1fc764cbcb1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "2bb660a0-9dfc-47ec-96d2-ea127f1fbdf5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "00a6a460-b411-4f7a-bfaf-e27117fa11bd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "7f5656f7-fd0d-4786-9137-9eabb08b479c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "18b64ff2-2627-4a94-9d1b-a8502cba10bd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "3fe062db-a16d-457f-855f-ce21a3d6e1a7");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56e1584f-8313-48d0-99b0-83e4bc1fd3d9", "AQAAAAIAAYagAAAAEA1ujiFj1uMOOpKOusO6Rcxv8VOfj/AtJmZWHmv1VumYSKERrs8izSgdQTFfnAGNhA==", "7b2a2a17-288a-4562-93a5-9be50e8b6d4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b784ece1-ae82-4fe1-a452-03fb57125a4f", "AQAAAAIAAYagAAAAED3yNI8frRyDr7obz5OQoXOtWnSywIJenhM+oIdqvRShKmABtgafKahS6E18pY0zJw==", "401ed5f0-4799-4a0f-887f-305e9c351fb8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e1ee4cc-3e95-4ee1-b908-125ad14b28ae", "AQAAAAIAAYagAAAAEKp5Q6qWN/CNJYfHF0vHcG9IwjSt/X2/EF9iFh3pCZ2Cd2D6C9qDLoz/23F1WwYSww==", "d6474607-522d-4071-88b2-60d902d211b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3838e746-9e81-4bb6-9723-4abd115e4d77", "AQAAAAIAAYagAAAAED2p0Brs3kEv/RkKz0rxmdsrT3em4TFEKrkjXJ94vy0n54r7VVQgH/19EeABJUpHBQ==", "30cef951-465c-4f54-b86f-d8d3924022d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45cf2cf8-9b7b-4f41-b249-e7c2a90b67bd", "AQAAAAIAAYagAAAAEP10v8AUjyvai7mn6rUOKrtaJPhkTVXiygSAsH6BicjlJnESPV4QlXhpv60zrRveSA==", "f9a80324-6f32-4b0e-8c81-f1dd90e3695e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7e5c2c6d-deeb-4577-84ba-203e7e3e854a", "AQAAAAIAAYagAAAAEBEWPBEtqBu5MXz/iQ1jqSusy2cLmp/wk9HDaHVxWj5im72k5Nl1cnRQ06jIsxjGUw==", "75aa6a18-b202-4eb4-992e-a44e4c3bb710" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf41fa51-4024-41a6-9290-edae44e86c1c", "AQAAAAIAAYagAAAAEA+2q7sJyq1Xd0inWrM9iP8ryO6MBiNryfQ3Kgidzt4IZng4a5MdgTgafPoziX+d+Q==", "e04c6884-4699-4714-8376-29949fa97c2d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "edfbb032-1ae3-4730-9406-dc252f24eb39", "AQAAAAIAAYagAAAAEBJ9CPC4/iGr7YABNpSi784MBDjK40n289jnAs2QiRqnXuu8PAUfk2HWmHMJ7Vm1Ww==", "6eaae703-ff3b-45c1-8703-da69e853514c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f40becec-ab08-4c1b-9831-da302e80665f", "AQAAAAIAAYagAAAAEAYHZL82xhCl/8d9hPOOcoAj5Sv0ExkeUn9lBHJucuP6accyzrykLaW9txAhiOZpUw==", "763379ac-aa80-431e-b6a9-cd12910bc645" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ffc202f-a87b-457a-b522-e3aa2e85240f", "AQAAAAIAAYagAAAAEE3PtZA8N/dXU0E+rUPihO0Gforby9Nj8uJcLzmNsqI9SRNg0a8DuQ7JhVZSZnC/WQ==", "572c3c91-423d-48ca-bd0e-d906339af194" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8482c336-893c-44df-b889-6983b8c4d633", "AQAAAAIAAYagAAAAEEKFX39FNPX/AW00+u/s9aJtjuI7g1fxTVgMUorZTO7CID2GLonSEtva9U3axdORHg==", "47b6f9fa-0368-45f3-9678-34cef62db410" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef105d9e-94d0-496b-8e72-3d788b3572d6", "AQAAAAIAAYagAAAAEC4nlOn8BHF8nmChFN6Ch+B5ZW7GhD4nI0Y3if5UOAKXEdgwMZol/QlG5TGRBjpH/Q==", "d63d56b6-f92a-4970-9806-0c02b9b4edb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96bee155-d5d6-43c3-9f65-a683740bfb57", "AQAAAAIAAYagAAAAED5OxiEHhEgAbWMGAoJBJ7jg0uHYSnfE/ZiYJOu2A59ORSa1LAdg9ksyjHbbnVd8Og==", "c8ddbd58-8730-4cda-be09-a29087b60eb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee77c87d-e7eb-4abd-bd7d-e16084c4b206", "AQAAAAIAAYagAAAAEMKvlH5BBAthx5A5fbUPa4It6+UebF6rD9TH/Q4mw/fCB1adoMTX5Dz3WsMRw/MyMg==", "0e0b2431-c543-440b-becd-71cd17aed724" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb040584-315c-43f3-bab2-69f35e81855b", "AQAAAAIAAYagAAAAEF6YntLl6xzA1tmONjdwQMf4DB1JHuXZj4OLlAlyEA0UXmoDzn8oKK6UF69Jj44o9Q==", "03691a39-c544-439f-adf5-000efecdc88b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61fec618-f610-471f-b5d4-1d2f632ff422", "AQAAAAIAAYagAAAAEDpt0Sc3z9ewLXKDAWQAbTiVwrYeuI9aBPHtZhBMC+ZXmF8eWmPfIpYk0IFzOZKy/A==", "d0884d77-9f8a-4fc1-8f66-6fb4e99c712c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b057c15c-6c80-4478-916a-bb695a28cd64", "AQAAAAIAAYagAAAAEEw0EjKNBZIXpXXe/hAlnB2HvT5gd7LpveK++jZ1XAYE96mciZ03IRsnt0/qSQ3MWw==", "466e8e12-4497-448b-8faa-6b58bfdf86a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "694e619a-cf33-4f4e-90cb-9190b08a35be", "AQAAAAIAAYagAAAAEOwU8IrU83TklIRVVdWXge1arC4qRT1wUKYfvd64ZUkA3oe/Nvsrgw2wO5Mm9BJQdw==", "7642926e-2135-482f-945f-1ab260aae50f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "447e2bc3-9756-4a1b-8bc3-568459aa3752", "AQAAAAIAAYagAAAAEFq5u0jtEVMTvRY5ScD/jLyHIjsWQ/9DLdQxGCeiFqav0neOnqNg7eXSLuUIgZv0xQ==", "56766d10-f64a-4930-8eb8-8fa8e6434be6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5265231-9515-4cfa-a9b2-a41ee8109991", "AQAAAAIAAYagAAAAEEBozwDf4Y+qNbL6y2Iw91cjzJNlDPCozJqJuSiOAdaalzbhp/A8AX6lpQZ3R1Vesw==", "bda60a46-a647-46a7-a2b1-1f2aa3b636db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "802cfa69-ccc2-439b-8291-4d419a0a1c8d", "AQAAAAIAAYagAAAAEPmh7gmtEdMeRqPTzUMlUJeUohuGU1XJ5RCVjsBTebmDh8a5CTU/+FMFwBfSF00Zug==", "959f923e-a1d0-44b5-b619-a5a271a9b54d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86e9f6c7-738e-4584-9c51-07c1a6254ac6", "AQAAAAIAAYagAAAAEPXBvw/8MRvzc+q2mhE/MR+CtOgjNdRPaxwczDL4ON+vL5b1QtyHgnPrzd68zeZh4w==", "e89c692f-458a-4052-a386-6836a8a0d152" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45a3eb67-1369-4ad0-8b00-2a397f6ac55b", "AQAAAAIAAYagAAAAEB1XdePWffxZsd4aEPTQXA6gv02GpHDsKi/8CezeutQrdI+TOfMFKaSZMBIZolgwCQ==", "ddcdded6-a124-4426-8ab5-1e0c77081665" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f70fcfec-90fa-42ff-a083-c11ae21a0734", "AQAAAAIAAYagAAAAEM5WiF4bcP7JW/NIL7P02WO6VDn01hoVZFcfP6j2gp401YwNcXQdeFpAiTopdJ/6cQ==", "ba7e0033-3658-4f5d-8de1-4fe1e6a5f72a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28ddea0d-5d53-4ee3-85a7-8081c59c293b", "AQAAAAIAAYagAAAAECl1cu94oJ/Z2df69L5YOTI2rEOpuA54Qf6bP3YtnWJoSfrCZD1Ip/tbxuSCdyLctQ==", "9d1c5a1d-ff24-4880-89dc-898b625ebfac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1184ccee-95da-41e0-b80a-14bde2c59cef", "AQAAAAIAAYagAAAAEGgRQF7gOj08cDXTZTLCY9DZrmVKgtmOJBFobJRtjBOQaL6AEwUp3T3gsk8SUvBsAg==", "075e5f9a-548b-404f-930e-2db646cc8b8c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d2d0b38-7a20-4db7-8b4f-b68a745d88ed", "AQAAAAIAAYagAAAAEB+BmQPV8AVYcsmDrETcO91IuwBP/jA5ScbSbfVpYJX9jgq1N666muYhpRYMHYyOiA==", "f5497707-5989-47da-9e16-4508cce81f4b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a3c921d-034b-43f5-8fd3-5bef372dd983", "AQAAAAIAAYagAAAAEKxIcBcVMKvomB1yDRJjCP4iKcm/CPU9q+ZWVgYhFgqur8+SVC2xpHZToqveBW/2CA==", "dc9c2443-6e4f-4645-b04d-528031f0eedc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e2703f38-545f-48d4-8796-8be034e5be7d", "AQAAAAIAAYagAAAAEBBJYuiRZKryeaIqJqrfqX8GhN0mz08jJ/LrjB62XumHOYbtAi62yu7DyNLG7ZKteg==", "abba9d8a-26e2-4ffc-a6a3-78e5ed8bf33a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "842c13ba-66e1-4e28-9864-67ad4b6d1590", "AQAAAAIAAYagAAAAEFQUzIsWrMZ6XOlhiGqz19Tj6WbhRcY9T3HXvICFQTkvaArRuUt03acRV3sdSzeMJQ==", "38e15216-42e2-4587-9171-fa0ce7184eb9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7981ac8-2dd0-42a0-b55c-dc788f2f55d8", "AQAAAAIAAYagAAAAEDj/+IXOHue6wUnl7AJogInv1KmHMPsUmArTcwl97eESy8lK2bqT8OSr1t4PjgDLaw==", "64e0b84a-7699-4139-b4b4-03bbc9b618a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0979702e-58f0-48fe-ac23-1816fc22159d", "AQAAAAIAAYagAAAAECl6a5DKwEY10Y8vAa1yN3RfR+Z7gmbW5K671ubPgh94b4mb/U9hVPJA2Odvay5HYw==", "8cd41d16-3173-4662-9bf4-bc49b3bbe34d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aca7e156-2fb6-4249-8610-101e41036e02", "AQAAAAIAAYagAAAAECoHJZ8V+Kt/4T2O2czejRB/6buD7Y7lzlPawhv6ayPdCO81IHXwXnGt9z7Vf9EaNg==", "f4fd1662-08c4-44c2-9eb6-2aea45935596" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71ae5f23-d078-40cb-9f85-ea1d61865990", "AQAAAAIAAYagAAAAELRcs4L7mcoO1+1yqGZexJTrifFg9B+ogxVO1dvAzuDU6xUG5IZxRM1YTD6pe3WD+g==", "1adf6d7a-7537-4d1e-9ecf-413ea22e5e85" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ee63d7b-0505-41e0-a817-251d1ce51d1c", "AQAAAAIAAYagAAAAEHIAiFBTdvxZjjjOxRsd8fMHoY/S4f76MTzmhfAjRZYXyF0RlxPmBDc2ug7G5jLGoQ==", "5145ee83-a689-4067-85c8-2f539895459b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b2d1e68-e760-419f-aa9a-16d0f8dd7cd6", "AQAAAAIAAYagAAAAELFDarmNENG2AjpCt9aWf6XJ8z93XrbhMM9WQNnRpPUhpybXe9pdWwYXcNTgV3lLHw==", "666ecebb-a388-4542-95d4-fb64f61555e6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ff2b672-4a8c-4cf9-8e28-a2aba34a119b", "AQAAAAIAAYagAAAAEG1NI3RvedAjfHSFvuxmyPlcEcayDa2q9bukp1byVYjMmSBXrxbHx64EToI65p5v6A==", "512885bd-610c-4e2c-9dd8-84f934c612f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d803ba8f-c359-402b-8444-283ac27188ab", "AQAAAAIAAYagAAAAEOvqzf8kpwKLTTG7mMot6Z0lt/qB/o0xMB1/T5iwsrWoPMT+jYVAuRmApCYL6e1KmQ==", "8a5e0481-a063-40c7-ba90-57e77a14f91c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5284d0f2-7fd3-4ee1-861f-a8da71ee0011", "AQAAAAIAAYagAAAAEJrn2fjaRGwExZOwZDbA3OJjJQc5N4HeIWstwUC3avcigJHhkSCeF9AHwFyF1Cig4w==", "e77d01b3-28bc-4cc3-8e40-adb93c07f702" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58c1569d-0507-44c5-8d38-79bdbca942a2", "AQAAAAIAAYagAAAAELXXZS2BrzKI6sUOOfw6fWETNPKDZFH7/5yeothNr/ybiwWRo2gxrtoPay1HzRNy2w==", "5b1828d9-b037-4f47-aa05-048b8860f28f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73c4117b-1287-4494-902f-5dd2108016b7", "AQAAAAIAAYagAAAAEJomNvHPxWH49v+cZOOkY7rADp0R4+77J3+ORdJLhO1tUXlzXFrkN6hbRpzLJewoPw==", "ddf74f83-b73b-4fca-9a4e-a1526146ec8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56a4d89f-817a-40c4-a3c0-2f84aa72def0", "AQAAAAIAAYagAAAAEBNLKQ/Z+ZyJ/1zhsa4iau9G532r9DnQ7BRoV/myxoXh2ujiUHtO17n/FNDMsYMIvw==", "62cee864-59d6-4f64-8b50-6198292e770c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b583ecb-e806-4fd0-be93-ca96f902cd28", "AQAAAAIAAYagAAAAEL1qO+2i14dC3de/nbLJcSxnPtEdi1HLRpVNuHhGZ3roTdaQbhMSpVXgmHNxf3TVTg==", "90bb4952-d9ff-4aea-af36-2c808b692b07" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1e5b2bf-c4fa-4f49-8474-baa48ca78287", "AQAAAAIAAYagAAAAEAirVkqQS6jSZP/CyhyfX50LQRqaAG2C/Vf29XbYyLvfzEzD2fkQaOOE7y/brIFXsw==", "45d6d9e0-49f1-4f20-a419-17a55d84cec7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10140352-a832-4fb8-bdb0-e4eb83677556", "AQAAAAIAAYagAAAAEBxzQvJl63GHhuvvNMpr4B0zBDaS3ns6gnVLqdbFp0hCtaI1RqAr1IChYbQYvr2MLA==", "4d418fb0-2861-4084-9f56-b900fcd62b74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57417f70-6860-4022-9f3a-37d3eb896c9d", "AQAAAAIAAYagAAAAEKP9mHfN+ag9Ru0Jtaaf1N3dAN7VjlhAVvtqXGGjvcdNVUR9nXVpv/5dwiEgkeEVlQ==", "dbcf88fe-28a9-48a0-ad03-3db08fbcc101" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "926200f1-9b1f-41ce-90ce-c2fa3514e3f0", "AQAAAAIAAYagAAAAEOM9I6XIIvyapnOwPoeXsRsLor7OM1wzC+e2CrODAb8OQ8AFyCz5zwqtjUZGQrqPqw==", "b1c40056-5db6-4eca-b985-f3c138836879" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38eb462c-5e13-4502-832c-070ddbe21365", "AQAAAAIAAYagAAAAEAE2i5tEhAD4W3kRkpLRXdtN8SiZR4VgXbG8q6bkuGfU0uq1Yn1vqsyS5oZvlNsUAg==", "3afbe023-911d-4604-a2ad-c1692b4c7d49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87af4d7d-0364-4ba0-89fe-2ea43afb4aaf", "AQAAAAIAAYagAAAAELk08sVYiHoozphiq7VJ4Zcoaxrr9MlNRDfPFvyRpTJ/nhP1tl6fspgjXyUgsxvLvg==", "47b441cb-6e3d-4e53-b596-44115313e392" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c90e82f6-c1f8-4a5a-ae16-151590f8aef6", "AQAAAAIAAYagAAAAEJI5qpcBKpWdnG0k+WpjTV8hIxpEuu9vzjxK3Dsni6EwEP0NWtHz12WTAgUVhi46bw==", "3b54f929-952e-45de-b5d3-05a353f3ae68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b38385a-831c-4ab1-9d03-7c5abcbe6a07", "AQAAAAIAAYagAAAAEN6oseeC4kRslj6mmMJk3jeL+e/07defDjQUSZSjfIDMISJszCvIwLicT3+qoZXfaQ==", "af526d4e-ae8e-4778-8115-3f88cb791a47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2e9f58b-1e60-44de-b71b-a3f0537d48ed", "AQAAAAIAAYagAAAAEKJwftymPZY81UUVp61PSH6DcdiAYs1becJmNE6Si3nconK1oQA1RxsSGZWxfsh06A==", "fd60a968-d9e6-4ea9-96d2-6fd31a9f2df6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e926636c-837e-4b59-a4fb-c96d68988a92", "AQAAAAIAAYagAAAAEKWevDqBFwlIZlpHSsuBpv5lM02qw/XkQ2jmToWVI3U1A1DB11UNwjvx7LyYIKDSaw==", "9cade288-c31b-40f6-a1a0-5a87197c8502" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75fc823d-5c66-4973-aa70-5a5783d298bb", "AQAAAAIAAYagAAAAELipAYMbZ17AVRK2cI4+e7ck4sWWDa3dshWTD8Pl3sYMEUrSnrT3UvAGFNvM2Q3d7Q==", "d597bd8e-c9ee-4bc9-8730-eecd42a58087" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3567948-c29b-4729-82f8-8c36e910b513", "AQAAAAIAAYagAAAAEM3JihQahKNkk19YFqxSgmpd6wJr7JxXqU+z1eAmh7flrte81ENGOrILDcVqqI084w==", "89339a13-49e7-4084-852c-e2bcf142c310" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6dfb6323-8e17-4061-96de-7e4ce83887cc", "AQAAAAIAAYagAAAAEGD7eoCBwIZFUCGp7S9nwUsN7MEZNkfgrtyPTWv67zv4apxS90Wx+LN0nD6j8mA+PQ==", "99f80663-9dc4-4393-992e-48b1975da671" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0e7bb40-7173-42c4-b8e5-bd01e1fe7f2c", "AQAAAAIAAYagAAAAEAnDmE2fozVxVwmlZ8rmgfDttFrcXo9OhRcz+weJ+pw9voCnMJnL6mn3I/mOAUyNrg==", "cfa8984f-2324-478a-a1c6-daa8bf3f07e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1370292b-09b5-4c9c-9733-9b3309856634", "AQAAAAIAAYagAAAAECkThIWCs/9pILDLDp+rXveGEioftmCW2TTtHYbCp8FFgzg9aML6KFwcmbYD1Rx4MA==", "00a3318f-41c1-476f-bd48-daf66997af0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5471693a-4d45-4cae-81ac-610f7ebee767", "AQAAAAIAAYagAAAAEKXPHiPCwnceGgicKDFyLspNCPOzFC/wt3vk6qEdQloM4FoDtdBCJu1O2luAOIZzBg==", "5fb65f95-2436-442e-9484-ee9f07a5e3a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd2227c9-34ce-4b87-b7c1-5d4762a0f31b", "AQAAAAIAAYagAAAAEGuwaro5mVjjz+SKlFeNh+binQ8FAyLuczl5fSDjHIAg+MzRun/ufcdzcL65wEhqwg==", "3ce331ae-b579-44fc-bafc-8f4e8e1a8f6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5d10a13-db53-4e96-a45e-ef53262b8105", "AQAAAAIAAYagAAAAEByH82Islk3R7Ps6D0VwyRlJH88ugFs3WLZMfrMInOuU8ynMTqk76hb8k1N39OMJcw==", "642fbe04-c483-4682-8fb6-11835d3618e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6cba42e6-429b-4d34-8d13-6a954bc9ee55", "AQAAAAIAAYagAAAAENjYCPHgMKDbi8V2I5tq6hCRrxzD61gH+Q/uSf69RYhrdrHFg0ulPc55X1H0g/d2Mw==", "a28392c0-ba4b-4df3-b866-246eed6a2b35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ddb8787-ab9b-424e-993a-494f367bf94e", "AQAAAAIAAYagAAAAEMEVqWTDsiRq+f0M53sKUmuOTdKta38vLg6lE1Wd6oLe7WBiEKVO9DIs3z0nrxSEkw==", "0f0abd0d-fd51-4b10-98bb-20a4a7b5ce8c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bbc0f479-4d7f-4a51-bd02-48b54cad0e30", "AQAAAAIAAYagAAAAEHzFqx9+4OoSxZPmDqoCOiVZEJCoMTmw+z/yJ+LSEP5C/dYvo0OZdKe3yaoYsXBH8A==", "a795c53f-08d5-414d-bed9-e79473621a79" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49984efa-d3b8-4961-aedb-fe5f5d173091", "AQAAAAIAAYagAAAAEDc6NaraPPKsdbGzGvCe68WXTup1RV70eb4akoK/CqCWkpUZP1+kEGFwvnKsTBq9LA==", "ba66f03c-8c0a-4555-ae6a-abe4409642e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7207200d-514e-4a5d-8cd4-3f0bdf022dc9", "AQAAAAIAAYagAAAAED158noLgugqPTNMuoER/bmuTjLVxZuSp5PGTIoGS244wh7UzUQDBif/EPmlb7Y18Q==", "340265c7-377e-48f5-ace1-ccfb990f13c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4570eabb-b4d8-43f9-b4d7-8dbaa0933abb", "AQAAAAIAAYagAAAAEJPJ9l4uu1jFzA8WuGMCfztq2RxWNZFhJ0fgEv2NB4662mLm73e/MC9v6o7MTK3Wfg==", "deee95f6-c818-43de-a0d7-0a8d89778465" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9458bebe-d30a-4855-812d-efe24564a1ac", "AQAAAAIAAYagAAAAEMxR5IFB5zITxTV5S/vYbe6c8sWOijU3NRV2XtQuCiG5JkzpbCSg35/Db7FbuzsAgw==", "10547daa-0600-46c3-bedf-87ab2fbf47a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2800a8d8-bc27-44ce-b4f5-fac0dad88636", "AQAAAAIAAYagAAAAENHgdmyg7Ae2iVIf9KfgkEQnw4q2ccsq8eG1NvtjCBwPdjMDomONUs2jxzEIitmDYw==", "e121f73e-01ee-4168-b18a-f580cb65795d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51de5b2d-4d32-4c14-8522-66d7d36b2ac5", "AQAAAAIAAYagAAAAEMStVilICBWMR6MQXcRxJ8bfF+ag+NbznI//BD7dva2iuLVZkM6gwNERBtJGfDTBEQ==", "90a3fd95-7eda-42e9-bf38-15854e6748ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "41c49335-e9be-4261-9646-f3d8526540ab", "AQAAAAIAAYagAAAAEGpffwTjUM+x1of8dntp8mxUZkpuaDDZ4TsnYxr3bPTlHR0+I0HtwxqRimVErVhpBQ==", "e0f7ca1c-3fc6-4e24-99ff-0e7cea04370d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d8042197-5d84-4f4f-8669-cacd122aa1df", "AQAAAAIAAYagAAAAEDDNJXOwEhzMr7rHOzW0Jp6dke+tsFzm64Ky58wSdVSMug31ba3IA+yppr13G3tEKA==", "1c2036b9-ade5-4aff-a086-01cc6a94ff49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8f4acc1-7597-4aba-9d5e-49bf4acadb93", "AQAAAAIAAYagAAAAEF7qdC4m/U1yair1NhsYRr9x3BEH3IMAofKFYH1AMHt6IssxStWo3CKnqJTPuxBUqw==", "0255799f-6d06-4b4c-9375-5d8afbe0f769" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54e07cda-017a-4ec7-960e-047b0bce99d9", "AQAAAAIAAYagAAAAEKZX0GtiYOmAcu2oPNMqppvf/ne6aTTDTu7JPoXfjEir/q0Zsxlu5TYD/JsCO8otcw==", "27363675-0bff-4e33-9259-3e925898d7d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9bc5ddfb-9e01-44c4-86c2-2b13b17c98be", "AQAAAAIAAYagAAAAEKDewLmN45SfaaKIGjH9GrE+GrpWhY2yKVcHKpXOvDssGSBo3fy9zNT6k9R/ReReUg==", "1345a087-8446-48a8-ba13-cecc10c8f07c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1827b342-55f2-44fc-80ea-7a6096a8ff8d", "AQAAAAIAAYagAAAAEKU0kXWt2OHIQrx0Mmxf4HU3CGo8GAT1FA2YJwj/w4WmLKvf0vK3WI/um5cKwxgHEA==", "00e4ebfe-da12-42a5-a420-661ea8e504d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ecd52025-9aa3-459a-8d52-6a8605acd17e", "AQAAAAIAAYagAAAAEFlYYBS0koledd7pLl5Bw08NF4ttqq71izfolOhDAjSXVXagaB/d08K4o2NGJhe2FQ==", "80e415ac-59f9-45cd-9c37-aefeef89db7d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3554f56-32a6-4dcd-8cd5-f34ad9129767", "AQAAAAIAAYagAAAAEKmaNN9Pcc0IbEvEBcQjNkhh/xTCG4oNhL+okfaxTyMTkDGXMIyQAk2sana3VqWrcw==", "067161b2-e1ab-4b31-94ee-eb471af79750" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64c6246e-a9e0-499b-9ecf-0c23d8848805", "AQAAAAIAAYagAAAAEHH7UOpU3+Tz8kqnImEYYm8N2amlacVRoutlYlMeWToCTfj982ak5vjyTxIralhi2A==", "9f32d4ad-8635-4caf-926d-7ade9a84887e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82c8afaa-4913-4146-bfdd-8fc381ba7880", "AQAAAAIAAYagAAAAEOX0HR5pRN6/noKwKIJUEeZ5wCZCtPteCHEz53+UbqD+SG/UJzsKBb9WU9jrwVcsmQ==", "8ef459a9-3c4c-4733-a60f-2aadb422e1ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14e75778-1456-4daa-b1f7-8d0207101dad", "AQAAAAIAAYagAAAAECzd5aU1rxId5brbZC0a9eiSSmE+E6GGZ06mteIfY4zdejkcbZfyvrzpSj3ZftaBOQ==", "f5828afe-0c7c-4043-8e3e-5f56900a9483" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94b9204d-e565-4a6c-afc6-c26b701a294b", "AQAAAAIAAYagAAAAEIKLRBCPjs/cnwx9BMZ8nXRUMnt0/unUC3QcaVRYWm8rwNRSi4aPZMNB4XTpQJpdpQ==", "d2e16043-14fe-4655-99b9-57a09a86a502" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4f52a8e-3d38-4716-97bf-f4287e5cc588", "AQAAAAIAAYagAAAAEJ9i00d2kiF9Fy4PXyXpXEbKq8Ky+yAElkDrGP46QNzyWffON6A6uf1rqiUm+S618w==", "3ea279c9-6ff5-4162-b25f-fce73efc04ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "573c1604-9be7-4576-9c01-1ac8f92b4054", "AQAAAAIAAYagAAAAENob2QLc/dVGmf+SNWDSx+7xVr/8QshqHdTdYWkYS3lC+sqRhnrkf+wHuzT0UWkXGw==", "82589dd0-831c-4cbf-ab19-0433067273e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "438964ce-a007-4944-a4c1-2cbbf210f5df", "AQAAAAIAAYagAAAAENkc4Vk9MG/l0q9OZDo5P3CTLFl9K7cgb8v/dJFbs8JS9N7fTLa5Hh7yqsDfFBz2jw==", "cd2bd9ef-f83c-49ee-9fb1-3b3d743d9ec3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6beec70-5513-40cd-8015-271f3582e6e3", "AQAAAAIAAYagAAAAEIxRLKQajRgJOp47va0Nl2DukyQ+D1dm3PIXxr43zt2U3S+6zejikUhh4iuvfnZwuw==", "2b7d7894-96f3-45d1-806f-2f6fa2a9f2e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95d29645-c07b-41bc-a13d-7a570a5a18ef", "AQAAAAIAAYagAAAAECJNFGTiULyO8XNVA/w8BsqjI5HpQNKQsj+P0xLM5vJXBSgTTeBwtwdC/866NjIFoA==", "15b1566f-7c3d-4d1c-bc24-f4a85fc369bd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec740c15-ee3a-4c7d-a78c-62ac8cb200d9", "AQAAAAIAAYagAAAAEKaKxJXWr50NKFDPeI++xyyAxiUrYjjxxYAIUv3HK03rYPZOIwTRfZnbQxxOIRJsqQ==", "d79d8778-b15c-4d2b-840f-0437162c8869" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11a049ca-9991-42f6-86f1-34610ed450a9", "AQAAAAIAAYagAAAAEDCE8fQW6V+KqqetlVAS+qc6Qn56IgSZYRchEeKcD6B139ysAGJsLRW4oC7O4S83vg==", "9c634659-0732-44b9-862b-58cee65a7be0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94a13704-07b5-4c96-be82-ecc0c3655311", "AQAAAAIAAYagAAAAELvt8OJB25Fi84eOSpbjsOj0E1eevWVeEHHyeGBGMZf9NqttiK2VX8aCuN95dBuWwQ==", "c5944d3a-0b91-4780-9f14-ded58ebb91ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5822dae5-e735-49fe-8a75-f1621a7a1383", "AQAAAAIAAYagAAAAEJx+V0Yi9c03Q9rZ91nwTqQhE0Og+AkCZGpyfGCOJX6rVCKJBdnIbYUUB0PlGXNGCQ==", "36890a7f-80b9-4b45-85a3-e9ce8cd95d22" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2a78bff-d3ca-416f-bd6e-bc59764ed40e", "AQAAAAIAAYagAAAAEMPEBv1uozA3S3xMZ1WcZyq1eQnnwf9H0e+j2OQZ4+B20BBp2hGRS5JCA5ZdpXi/6w==", "86de6978-d34f-43b6-885b-43290337f682" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f5482cf-ae83-4b27-92ff-bcb4e87e8f49", "AQAAAAIAAYagAAAAEPMJcDQmKT7gZ6KZTCpOhKsYTbnhy/C/yr7PQGxS1W3LL5dV5M1dhUEeN1+SqQLUHA==", "53125a8d-c776-4517-a630-c918b070db81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c97f5ca5-d9e2-443a-a2b5-a4709411642b", "AQAAAAIAAYagAAAAEAELlX+GleqoRvSdXpyhpbn2f0QZ15iyiwseFegbfR4sOHEFH0hdlTte0i/z/aTcmg==", "e77a9012-12bc-4499-9b7a-556d05e22d92" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd949641-1dcb-4760-8e5f-25603a4990fc", "AQAAAAIAAYagAAAAELJLcoEnNECrzyIx2A9mQqD2gGfdAC/dNXg1f+vvNkKYTOjaSkUgkKg0+fl3sDV0Bg==", "227719ee-f689-4ca2-a04e-7597af9a388e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "494315ef-78ea-4377-a93f-2eeb78c053e4", "AQAAAAIAAYagAAAAEIFq0SMo99md7wFKys5UIY2FvZLK26mC6E99XDqlRKVCcH8T2f1hkpiVFWQS1fQG/w==", "4b60e709-5feb-464b-8ebe-58e2bec06660" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e230b998-aa20-48aa-b198-9f96773831ac", "AQAAAAIAAYagAAAAEFZptKlG/nunXE7VFfgj9mytJwoJnZ0bOdpIb0ZNbRHwBGpoFbTSGg0iHxfgL8zAtA==", "1d41d4cb-2863-465c-a6b4-1d84f98c3e7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0629130e-1152-42ca-a7a6-4b7caa51d27c", "AQAAAAIAAYagAAAAEORPbeTACb7QRt9aUl0WMRsR8rfzqfJCxHZeKPAJbt9EODocS98MbDDx2dcbM3BdoA==", "4263ee46-1d44-4436-ad45-b6423f4a2097" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a7804d5-9ca6-442f-a37f-9ebbd52423d6", "AQAAAAIAAYagAAAAEJo1j/gltcoTGoadmqreDK70c3UHom4VYpRQmAeiHmj5wxjt/Wf1oRswJLn/8swRxQ==", "896ba596-d8bb-48d8-a7ad-e9d57a7f54b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cbe61e77-38b7-4257-937c-3bad456ff5c3", "AQAAAAIAAYagAAAAEEZ6ShCAsxuVxWQfXKIOjnts/B0mXKbyK9ARbZfx+6i6BvGdiCMykDhHKTKOWRP3rg==", "bbc40d7a-4ff2-4980-9b78-f33659ca5874" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "505c121e-aa46-4bf9-b9b7-a4af4e12b51c", "AQAAAAIAAYagAAAAEOeqkH5YpGOsgchG8A18x161LNSQJWeHtuK6GAUiS+Qp7EEjqk3MpO8sOlMYAtwTKw==", "0f2ab25b-ca10-4f64-a48e-d5360ace6149" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b301936-6c1b-4eda-bdcd-a8bd48a9b47e", "AQAAAAIAAYagAAAAEIahT8t9RymzxWk3C3iqDBHBrk86+XuNdrM2uTEr8TD8FzqBdyu8WKR/AK2M1ppUVg==", "a0b8d0ab-407b-470f-a23b-0f70fdac7377" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "83059bb6-084b-4a72-8dcd-f73052807174", "AQAAAAIAAYagAAAAEENn6OAyQBCjrPphBqEPrqEagH+Q+RE2ounwq7ZZLw1cn89E4EmxKeAtkVyH/yx13g==", "2bf72f71-7a4b-4bdf-9b06-4ba5d2f8c103" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3004a246-52c5-4fde-aafd-60b2d863af30", "AQAAAAIAAYagAAAAEEd+iwR+uQmdaSeMiSEHchdsRBxHTR8OJ+0alR6HWDF9IaITKPEwTI97VqRpZpfN8w==", "143f005d-00d2-4617-91c2-1fe9e78169f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf895264-5d5d-400d-a8fe-a55b3334a193", "AQAAAAIAAYagAAAAEJDqqamOzbQ+kHAvHHo+dHEuhfTgSnkw1iGUEAqSSSITv3eyy775m9G6BbAYWDyjPg==", "9fea6a6e-b7d5-4dd7-bf86-0bc28786ab6d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "484319bf-4798-4c13-a950-35d3c3bc01f5", "AQAAAAIAAYagAAAAEK1aRIQLKD3b96wG+HyTyjyObUn5w/HJubRRgvAdvoq//XyZbnj/OdIBqaEYOFPSgw==", "bda3af27-2a13-4ce9-9f18-fc210647be09" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a38adbaa-f55e-44b1-9f98-cb1ff4df4824", "AQAAAAIAAYagAAAAEKECtRt56BTWmf6zYxgbT2fQk+BmS8yOZv+N0gs6btsgl++25KVKKy/DtSfIIykThQ==", "02edfc97-119b-43cf-be6d-dea2034db95c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb654bcf-7545-4f2a-9a94-331024da454d", "AQAAAAIAAYagAAAAEEXSJ9C7WjL5o4Py0L4NKhkoaPbkm8WDsckab+XbrEmnckNzhP1A+oVgfJK2ms7Mbg==", "ba752894-1089-4bea-bae8-d2f816980b3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07b7dc31-3649-40a9-8c48-7cc122a4d132", "AQAAAAIAAYagAAAAEI14flh/so7Bkl+uhobtIuIDspQbDhxqKoKQGXM6jjzmYkBTSagOtuxp3bhpFCPP8A==", "e72b1977-2a38-4d30-b2b9-3b8290c5f49d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b9c8413-4dbb-4ae8-9531-107f2d151397", "AQAAAAIAAYagAAAAEOZa4xbOBKFLArLvlpEJk80r/ZCZKkljgJW003S2s8Y42PmbkuXfXRuyNveZz8cwvg==", "927de2f7-748f-4034-a084-2c5a7188d9ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "276a11c9-5039-4551-a5c6-39ba1e897e38", "AQAAAAIAAYagAAAAEPeUCXSSHTE22wFqKU3d6nKuuym7j5BxdFaX3CKRzYcNhj5Efk515UPIBw1OH1TgVw==", "883c4d18-c70b-4938-bbdb-90a6996fe767" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68ad60d8-79c6-4824-b528-d5b0904c6070", "AQAAAAIAAYagAAAAEI7W3kVJL0GdAI474g0sSNMJVr/0DF4vh6MmqSMZzxhirx5TFyF0ksWIH9Gsr+OnGw==", "07a3d601-67b0-41c8-bdb2-2454ab54586f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a089a2ec-2f29-495b-b319-977d9f3e010d", "AQAAAAIAAYagAAAAEML5YH2dKt77rK06Xzo1OODSid3gI6WFDac+aUpGPytIBE7kxR9zEd2IBvX7fyNO7A==", "5f295c68-4521-4479-8cc0-57081a4ce9aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "445bbe59-b2cf-4b75-9551-f640126f0aff", "AQAAAAIAAYagAAAAEJpI/P12tdS+INV6cMJJjxdDqeujG9I8ZkrLoRG4NLVuBsjw+HQZxi2zO+EkUyMthA==", "38bc71c9-9695-44fd-baba-e3a71e1fad4d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dfecc603-3f6d-4ff3-af40-86f0e48026d4", "AQAAAAIAAYagAAAAEMuozDBNMasobN50WQb7BSe+2cqSMzqo0MGMrS90Z01aBNWBSJD6s+PmBbhQDCncyQ==", "f210204a-255f-43b0-9f93-816038d182d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0811603-9b82-48a1-98b5-ea7f94e0150f", "AQAAAAIAAYagAAAAEECTfbcGirPsRn00c9CuJmXtxiT/d2xMK7pwQZdOXphw0aURsC/+uWrqRZJBrOY/bg==", "b4990747-32ef-40b9-bcc6-bf18d35307dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf48abeb-aee4-46e0-8bf9-a23ec8014641", "AQAAAAIAAYagAAAAEHEZfOPDXXa+ZRzG++LHxoyF3xcyUc6D3N+4zaByOMyjptsyFXzK0FvoE+NPUQQNmw==", "4a173b5b-1a97-410d-b34a-0d8c735b7da6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3265b856-38d6-4f6b-8e54-03a51da8e56a", "AQAAAAIAAYagAAAAENQq/0i09VWTDdzmPKLGKS5aa69BDFkkkNU+6ID6Ktk1l7plFi69hdIvvHryQZfEjg==", "a9c7d4ff-ea94-48ce-8f06-9e90b39f74f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5015c19-9684-4d5c-9ff7-28e5fb1ab01f", "AQAAAAIAAYagAAAAEAYuQAnks0Qls2XwFidnnnKGvrGVIK8OAUj1IWGCviEsa6UUkyv0MLFba9CEiM9VwA==", "4e3b97ef-6f6c-4eae-85ea-fe56368ffd52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cdaec722-a106-4ca5-8aae-0d08847d080c", "AQAAAAIAAYagAAAAEN+XNdfb//o1t6DIz9a6yiHL6cpZf4R1TVbCMcDlSuH3Rl3EX3c5eW0XRsbyARH77A==", "954cbabc-d292-4a6f-9e0f-b1a08f66ccc3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64039399-23eb-4cda-a86a-688180df2f58", "AQAAAAIAAYagAAAAEM/G/MRgN16tAhT1rN3YDott5an9o3qldZ2nSgt4oLJ6E1TfQNpvX3uIiby6uyRUTw==", "d6afca05-e86b-46ed-8df2-83ac54189ebd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "615bb557-eaa2-47b8-865e-3c0386f0a4a7", "AQAAAAIAAYagAAAAEH1BPg1f0Y2fIdpNQ2c/ugNibQ1s1Yzsue/GX9Tcuyp3WescVsX/TOfgmx1uMqcThg==", "dcb947d0-997a-4360-858a-2175c081029a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59ea1fcb-a112-4dee-bedd-d51b66fe7a1d", "AQAAAAIAAYagAAAAENiSXtp/jNsZ20CdpX7fQMkmLikG+xB6znPzKf7MtZMYqT2JVxeVrshduYyRQs9mig==", "5a3e8ea3-44d6-424d-82f9-5591cfd797fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e5e8aee-3444-4573-b4a6-aa7ddf7fc93a", "AQAAAAIAAYagAAAAEDbD2DiYhPDWtDovdgHbi44TTyxCDz89MdBB7TU9nTau1DD3RMhZdr03m0rIAr4jaw==", "e71e20dd-d7fa-4c26-b710-2d05b0584442" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a24a7587-b2b7-4d5e-85d4-b0bd9fbb5211", "AQAAAAIAAYagAAAAEI8fHYdaPRLSlMkhMq3qLhlO6bN3ca0uLU0nJFDeiWlwQQgWO+li5i78hHfKLw15qw==", "8096f249-ba1e-4397-83c5-4bcd6ae3df5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e84d05f6-d781-4cc4-b061-7c8089ad65d8", "AQAAAAIAAYagAAAAEN8okjBH25b0tZ5pM69/6ioLaS9hITvDna+Ni1V9SFMQJ5Ly0SYlUTBoLIfXKO0FOw==", "6c914d23-0721-4adf-9fbb-470824145578" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5e5ad08-2267-4247-a57e-6b693d9c96c8", "AQAAAAIAAYagAAAAEMsGKWCe4NeDu0NA5PQwkuEMHu8MCINPmVBzjTe1P4T6AU/lVtygx41UoHA/FCBkjw==", "40924859-8c5d-4d9c-8982-1e0ce852587f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d93aa252-89aa-4fcc-a753-2fe21f4a0f33", "AQAAAAIAAYagAAAAEBFmWfB80ic+yPN0GncgKKMY6N4Zve/QXeNqJ3jyrKHWK22ku8MaiLJCXmQgASMNgg==", "dbb1205b-2f16-4410-ba68-f2c056a6e61e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0507c7ba-e39a-488d-923d-a9cc3d993ac9", "AQAAAAIAAYagAAAAEB/hgNOL8y7DASs27b5ceCdjAurRe808dRjwfcrgEAVwwpHrl/hD89IlOav3Ahpbfw==", "ee2f848e-7797-471d-85a2-9b732ffc6473" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef960aca-b2cb-4f6a-9603-c665f41ade18", "AQAAAAIAAYagAAAAEIOXLdrGocCbCvou58aZUvZ66/ddCTZt1niNX/qlJd0COfrzSiGxXWdsAyMGWGM3nA==", "11bc7d3a-8eac-4a29-87d7-3346519745fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "edd2d33c-3564-46f1-9ef8-628544b725be", "AQAAAAIAAYagAAAAEEJvcM3eGDcaxUVVsgFS6WwR6JASsrAQr8x5rzthtTVmS7nuvjwYg2bxq7vbUXvlAg==", "abe98b0c-3215-4178-baae-4663c6cec54b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a13614c2-773e-40d7-be26-40556da0c815", "AQAAAAIAAYagAAAAEFU0aVCa/UuTQPOLwv7Vz0i0+ubs0XTwxMVQbjJa/117ZJuWuyHZwdnC7I+EKOsg1A==", "4979ee5c-70c7-468d-908a-943bef0704f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1940baf7-991e-4854-bbbc-fdd3a26a0484", "AQAAAAIAAYagAAAAENaflc3/XnwK/ppH3PilPNmLxoiDLvS+JmjrIdCIkZMWj92l8GYFtwSFjBvmHjbIYg==", "a2569864-34aa-4abc-a075-967bcd8af940" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1a0158e3-584a-4d04-8f05-6621081f5baa", "AQAAAAIAAYagAAAAEDbabKGnouX50I8cn9xYRcRcHolV5GUebyNsT9DWxbL/Sa2Tr/HDvrJMcs2eGm3ktg==", "65926d8f-9b1a-4553-9f40-746c833a8c6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0ba1635-a39c-4bc0-96fc-771a78d8f73f", "AQAAAAIAAYagAAAAEFGhfPcDrYyp9Sq6luCTBxucuHLRWfkV8+npzyyyggn80Qi9d8AavF0hS91o7MrQGA==", "5dd4a6ba-844a-4141-9e0f-08336195f48a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a68a982a-f7ef-4fed-a74e-5093a1158df4", "AQAAAAIAAYagAAAAEO8/XdNpKL1kzdKAE8HpNwt65HNkv/4/DkG0D+8KE8VAPLnSPDBXYnq6X6PWHI3vIw==", "8f793da9-d734-4a61-a3a6-d53661ebb126" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e633aafc-3d19-4449-b16c-758dbc31b963", "AQAAAAIAAYagAAAAEO/LHID8V38yAQiQKeoOkQbaMPBevj959gO5a1dI1i7jyiesQxLG/JX1SF7DqJrAUQ==", "ffbb945e-0b88-440c-8afc-2bf1b488ba72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72b32d95-f2e5-4ff2-8669-b4858a9ba7d0", "AQAAAAIAAYagAAAAENtMVMLBc7L21GTRqLb4dksqLGRdbe4MOPjs7nCcFwalksSY9ONnwAIS1hVfN/shFw==", "c49601a1-b128-4417-a193-8b6aa253fa9e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d24e68c-6009-4ba1-9035-b2f2b971073d", "AQAAAAIAAYagAAAAEDpVcv+IU24qoQNnWVLh1Be7ezYX24yGc+EYQFTDazeCahMGMWZw/o1lUZx+XygxdQ==", "38089d56-7acb-40ba-a821-797885217e34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5908d1e3-3e0a-47cf-8f46-ba99c0f53bc1", "AQAAAAIAAYagAAAAEBM///xkY2coZV765vewiSICBaRK3G1629x8I9IjzdFWPoVtFk/87Fy0hcmBxfJXzQ==", "3504c268-7154-4c89-8246-60c30d702458" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a89d9f10-164a-453d-9a5f-f2bbb3ff4dfa", "AQAAAAIAAYagAAAAEJFvjSM+GZYY5ufdrrBg5mHeJToX0D/3O9y0DxAIl0DwpxpiGTPz9W0oohW6gXnvIA==", "20d2de62-1827-4ee0-bc35-be917a64c97f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08f00092-b577-4c2d-a696-0356fc4fd168", "AQAAAAIAAYagAAAAEAUmevA5x++NcytiKQiLY5jfZS8H+2I9VvAOtKMF6cSmt+jH9K1iD5KylOrdytXI4Q==", "4add519b-756c-48e8-8701-42d6a451ec8f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a09c750-9f44-4091-84e3-dddcbe9d0260", "AQAAAAIAAYagAAAAEEeBtl3akkcuj2IYRowaX9rXzzmT0cTZeoSEjQId0nifONkyDwckcv6jVn429JrNkA==", "cd06fbb0-2f46-4142-bc96-9e81b26a5f13" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62019140-256c-4bff-b852-fffacfe8e80a", "AQAAAAIAAYagAAAAEAM8+8qhQRgHRB6xhX3tpha+HKHZyialqlRVDpdS9VA2y1oY9UHq56u2P/Pqtt+1Pw==", "459bc0ec-cdc6-41a5-be50-d0c6d4f56885" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51b27103-a259-4b5f-aa4a-6670a32c50fd", "AQAAAAIAAYagAAAAEPEBuhvo98ZsGhzlaXBwGb0QcRa36QxVSJLukNEWphLNHWfrJoXs3ExnhxrrsORVvQ==", "a114303e-ad4b-4edc-bc08-5a40db675329" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "772a99c5-71c5-40ad-b972-33b11c13682c", "AQAAAAIAAYagAAAAEBwpM4Oeyr665H2+NM+0oPtEAEFsI6Yl3SfvKZ4z0UGqllCnIReAkXmbu10ukxxUXA==", "2d4d0321-7026-4a98-8779-1dfb7bbca401" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0ef5132-ff71-4b4b-812b-be87f5e72b84", "AQAAAAIAAYagAAAAEOTcsTa6WyY6TxWcHNGbXbhUT3p6X20ewY3YF5mE0o+Ooe35FHRLQjvWChj6HxptHA==", "47a3feba-a1e5-4efe-b279-01e4b7a1b432" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ac2361d-a615-48c9-a57d-a31eb5f855a0", "AQAAAAIAAYagAAAAEHsRg7LlyqAuzX/1jLmMR1mGaERk5SqPHDEP3zjLT2cOw9v8Lqz4o/Kn3SLK6DECYg==", "168a399d-d103-4ce4-b877-47b77823702c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2e0269ae-e5be-4667-8cab-f66b111b7719", "AQAAAAIAAYagAAAAEAkOJZcORTAkCqxWm8vx+aC9vXTytPys7HSgheQRBHjKuEiUeUtIVHdA9+bIIhf4FA==", "4c50da46-fe91-4c8a-9b62-2ad7ed3e45b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5396d5a0-5c71-4173-ab49-0eef27523cd4", "AQAAAAIAAYagAAAAEGBspcebI11KPHKanqmaJz4aRGa6ynYQs7LvZThcfEJBhaKGGM+YAIHacCGqCfcBXw==", "706c4432-1dc6-4970-86ee-18fe5f1709e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1768f882-804d-4692-bd92-3c386f7e6da5", "AQAAAAIAAYagAAAAEHHP4ffYa2WPgOB8fkXvLO3QW6BNxjpZVjJWORS2d4IEz3PiFaBnyusVQc+45q51gA==", "512a9628-ad92-4b24-8404-8f46d830efa8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "311b8983-1378-40b4-b5d4-c585e1789be9", "AQAAAAIAAYagAAAAEJRBF8AbNfq5CmJtcBuRDP9s7J2qwtH77VzNBYcx1MkTfPnLNj57qlCK6qX81sc2qg==", "32cd9573-d223-4807-9699-e94d9b8d4e0a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ee0edd6-d883-486a-b288-d7daebbf81d1", "AQAAAAIAAYagAAAAEBZO8/XdRPhFCCl/WS/vDvHIH1l82k4k0Q1lvThXq6yyRqNLh1C5DP/MHNLiO6WnLQ==", "04a95bf0-9735-475c-acab-7af4f5d4a6ce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b765391b-7663-4e6c-8cbf-58f38ffff6bb", "AQAAAAIAAYagAAAAEGhC5a8uKI4OiaTTYtGrr75qnbcLTg3/HPp5t3eN0jr7v49A//kG38nQJyyAkzUK8w==", "f2ba45de-c411-4f5e-ade0-2123d389d544" });

            migrationBuilder.CreateIndex(
                name: "IX_KraRoadMap_UserId",
                table: "KraRoadMap",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_KraRoadMap_AspNetUsers_UserId",
                table: "KraRoadMap",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
