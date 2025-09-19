using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddSummaryNarrativeEntities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsSummaryNarrative",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Findings = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Recommendation = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Conclusion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PgsPeriodId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsSummaryNarrative", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsSummaryNarrative_PgsPeriod_PgsPeriodId",
                        column: x => x.PgsPeriodId,
                        principalTable: "PgsPeriod",
                        principalColumn: "Id");
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f69e8715-c92d-43cf-b0b4-3308ba553808");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "9dbc1053-736f-4c79-b604-d767632c2038");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "d4004f00-82a3-441e-b474-db7cebba8d6b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e1a8aca4-5b40-4244-a643-d9735407fdd4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "719e87a3-259c-4eb6-b5a7-56afc47f2038");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "23a6857d-1d7d-47f2-8262-4a03438d51df");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "66b5c958-26a9-46ef-a659-1346b40b53a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "18efe81e-fcc1-4356-83cf-3d49678e714d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f698c1e6-44fd-44fe-b9ad-e4f424921e1a", "AQAAAAIAAYagAAAAEP0E4R5BoLUAU0tCB38lB7yeK3dDcjszbZ35mWdDEZ4yxVyhhKteAW598NtelYjj3g==", "19f7eb19-426e-4a38-ad05-6cd57a6f083c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da68b02a-8812-4b68-aad3-3ab9dee50130", "AQAAAAIAAYagAAAAEOHrPDn0MAByMEb6XD+GRSQLIm+oOHEnzxrQJ6lZFRD4wRtQp7EqfjIniBFkiJhvlQ==", "d0dc0240-a3b7-4961-9340-da21b83d9a07" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d6bb29e-6da7-4730-aedc-d53eec624074", "AQAAAAIAAYagAAAAEFBiaTL4uKQ3riqNXNR+PaC/XGSI8qUOWhKWWhEIVCXKLeR978VT20iARNtf3OynBg==", "05379d9a-7781-4de5-b703-76f8c78727bd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "80b47d1b-dc08-4b4b-8a4d-bc25bb5d2244", "AQAAAAIAAYagAAAAEF2eEE6Vb5wJOsdGRXJa3+xrgR6Q9kg6TrlRBr8zfwKZsSg0k5DIcq3CmrwwJ7BSvQ==", "bb6e71e5-3118-4631-803a-f1df8bc4120e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76d5f225-7433-43c9-9b6a-9e24bef48271", "AQAAAAIAAYagAAAAEBkVkDZmDoAo8Iiw4sQzGDM8nvm1hYmQdLiBeEGXMgBX9uj+xZhF9yy9F5vO9eog3w==", "b8b1952d-9d14-435d-8332-fc6d721a6140" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eae6c4eb-3787-401a-b3f6-f9a5d0517a7f", "AQAAAAIAAYagAAAAECCYlofcZyW3weFp9Ir+yOQEULjagzRGxj+QUYqWD2kty/5zXhPaLyEAi/w556kkMA==", "71a3ce9a-8681-47ef-bc1b-dbfa18f3b303" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcbe9cf7-dfe4-444d-a456-37051778ca98", "AQAAAAIAAYagAAAAEJRAwHEhE/nRYXB1kz3f4VwzE/F39v8oDzpkTW+n3LZuABqJnWkKKwl5vXD3cG9WvQ==", "c6dde925-ee0d-4802-9821-c1183730b3b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "557b607b-3961-4a32-8242-c41f45ad4a4c", "AQAAAAIAAYagAAAAEJEzvwGGWG+dr7zgO690VUxEgR/2LLQWg85PmLSdQy04fWLQAHGVduRBLJaJNtmRfQ==", "ad8fa1c0-66e7-469e-81c8-27f0d1e950d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fad8e35-b710-4503-a414-e7396f7da5d3", "AQAAAAIAAYagAAAAEDcuTs7Ui1jV6DKarJUz/QOEgPbOPWJBKZvh8Dum/vm3TI5qNWOexZexevybEyrdZA==", "1851b072-683b-4165-94e0-599222af4290" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7a90942-b5b3-4f40-913c-0b992834d4ec", "AQAAAAIAAYagAAAAEFPKb/0gS63lvYiWwbpxWtxMCLP5xLdXBkHT+0b7raG+QtimyZO+kJ6GLaVUwAHazw==", "c68d24d0-f9c3-4f51-9b1c-c96b305e6b6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a508425e-6b03-42b1-914d-5def3da8d0b6", "AQAAAAIAAYagAAAAEDLl7mclBGaRhYWzc6Mb3NGTT6umje2L9ug/V+IvtRvqEf6bEPk2iDzQG8wic/J5QA==", "4192dfa6-a823-4f2c-a554-baf7bcc9aa93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e355c2d0-ca7c-4699-aa32-f95ed04e2ee9", "AQAAAAIAAYagAAAAEIZk/KpVXzc6+lTYqLmj7bdSNEAmYtcz5DxW4YnCmh+0DUbXI1GDqMcQfW5k8zMXcg==", "5acc9440-d351-4502-ae01-1d8ab6565a30" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsSummaryNarrative_PgsPeriodId",
                table: "PgsSummaryNarrative",
                column: "PgsPeriodId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsSummaryNarrative");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f0f02004-fa50-4c32-9003-e38f3cc6ad68");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "6d011b5f-337c-4805-a201-37e48d556b72");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "0bd253d2-8726-459a-8d94-98b0ba03dc3a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "36a7ff05-75cb-4abf-9280-4d3866e0c4c8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "57377f5c-dbb9-4c11-8177-3a4e8c31eb33");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "ad2ee196-1e18-48e5-aea1-2a16c9bd1fe8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "9b5aea9b-02e6-4af9-9b06-08797d7d8865");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "af87e194-4caf-4c9b-96f0-fc3a4e8994c7");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f50b6a6f-a820-4a6b-98e3-463c450e91ec", "AQAAAAIAAYagAAAAEKr6BTQBuKJaEpyr9NulXBpQ/L5NdNEFPljN6ybhthsk1OQw+pl9jVlPKWu1Qy6AZA==", "50b64ebf-0cb6-44a2-aa99-b38c732e84e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9b40295-d14b-4989-bdc0-dcb92260476c", "AQAAAAIAAYagAAAAEA3CVZf/kXLcrVPtN4wWDMgeGFU+ObWjePAqjgZLE0Wbzv4yq8GAfMRN71pHjLCiLQ==", "21487ef5-1807-4c42-80b0-579970df7098" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bab19a6e-026b-482c-b8c3-a0edcb78c30f", "AQAAAAIAAYagAAAAEKjfwG5MNhTHLFMKBrk4fEaIK+MaQc0YRPD6LDIb67ploDOPsPC6bYxmEZSlbPaWyw==", "1f6bbc62-4203-497a-9f8a-711de6e54904" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "643d50e6-4c7d-4ff4-a950-1a18b66a93d2", "AQAAAAIAAYagAAAAED8AIac2uGow4X0LRPeNnjZywWX+Xswd29IRZnYjPRRdvnQZege6TNTS4wCn3knWnw==", "5229e3bf-5f66-415d-a891-d6b01e856172" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9393937a-9eec-4cf2-8680-21ec7c65018a", "AQAAAAIAAYagAAAAEMrPmZgIU0RF9WcRY9g8Ce8t9cWLOsUIZmlkNdYUVraBOlJcoWZ1UEm4jxcXEF/xlw==", "c98e3afd-17af-426d-a28d-f4b364f01e56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b548c55-f0be-458e-afd8-72779829d635", "AQAAAAIAAYagAAAAEEnjCTWkIi9L5J+49jeF+bydQyp3ctviAd6xlEW+pKUO2ixmn1gjYiecJYA4j1pVfQ==", "3f3ce96c-2b5b-49e9-9c6b-4dbe53e01c19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9701bb7c-f8a1-4524-bcfd-8613fe02e429", "AQAAAAIAAYagAAAAEMA3hiMLNO0ymaEEaW68DWAmnlvuiemegsW7l0ObCI0CjGkb6u4zeZvZ4n2+evzX1g==", "08382f40-bb3f-4ee8-af84-36b03d3990c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6dc559a6-606c-49c4-8966-d83449049a06", "AQAAAAIAAYagAAAAEKKS4bJGwp+1iyipHvEWV16tlzPdCJlU5KYxav2viGnJ6ApglqLUHzhzufPXVS2lHA==", "1490f240-98d5-4b1e-acb4-f95004da7d54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c92794fa-d487-4ad7-b307-4d0205dd0317", "AQAAAAIAAYagAAAAEDdjaOevDdytq3y7hAwMLIC+CQF2YjpsFuPiht888zoh9yZWwLCJAJVv53k/neBKAg==", "b045613f-26b9-4edc-ae80-44a7cfd7109c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b775d32c-27fe-40cf-954e-3ffa998273e8", "AQAAAAIAAYagAAAAEG/QVfKVXrPqMv6GvvwfPiTPf6pWa6++qCrcAYPLstqimHZADq/37GchTI0kVhLLAQ==", "6eabe881-c698-4977-af9b-98122ce8dc4b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b106841-09a8-493b-825b-e921d2a71c16", "AQAAAAIAAYagAAAAEI9RRa/L7xshD3PmkWPEmMB8/2ZEGw/zhImh8wiG2avoS6DCx9X+fefmiHj9/XtJUQ==", "f42cd9bd-3fbc-4296-8331-09e1fd816cfc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2e40ef6-9ea8-42d2-81e6-b83255e84807", "AQAAAAIAAYagAAAAEGgK8jUXLfu73QUsakhZNwv9qs1EnmeafnG2r18H6WHSpibRgylyrDo/cBmJ6rVH9Q==", "0ae98bb8-3e1a-4de9-950e-d781c1884589" });
        }
    }
}
