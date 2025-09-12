using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedPgsSignatoryTemplateConfigurationAndUserOfficeConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b106841-09a8-493b-825b-e921d2a71c16", "AQAAAAIAAYagAAAAEI9RRa/L7xshD3PmkWPEmMB8/2ZEGw/zhImh8wiG2avoS6DCx9X+fefmiHj9/XtJUQ==", "f42cd9bd-3fbc-4296-8331-09e1fd816cfc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "MiddleName", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2e40ef6-9ea8-42d2-81e6-b83255e84807", "Bello", "AQAAAAIAAYagAAAAEGgK8jUXLfu73QUsakhZNwv9qs1EnmeafnG2r18H6WHSpibRgylyrDo/cBmJ6rVH9Q==", "0ae98bb8-3e1a-4de9-950e-d781c1884589" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "537d9fcd-b505-4f93-afc6-17eb8eddff83", 0, "d9b40295-d14b-4989-bdc0-dcb92260476c", "User", "Nolan1234@gmail.com", false, "Nolan", "Avanzado", false, null, "", "NOLAN1234@GMAIL.COM", "NOLAN", "AQAAAAIAAYagAAAAEA3CVZf/kXLcrVPtN4wWDMgeGFU+ObWjePAqjgZLE0Wbzv4yq8GAfMRN71pHjLCiLQ==", "", false, null, null, "21487ef5-1807-4c42-80b0-579970df7098", null, false, "Nolan" },
                    { "743b9807-3441-47c1-9285-5ff8dfd7acb9", 0, "bab19a6e-026b-482c-b8c3-a0edcb78c30f", "User", "Sheila1234@gmail.com", false, "Sheila farish", "Mangelen", false, null, "K.", "SHEILA1234@GMAIL.COM", "SHEILA", "AQAAAAIAAYagAAAAEKjfwG5MNhTHLFMKBrk4fEaIK+MaQc0YRPD6LDIb67ploDOPsPC6bYxmEZSlbPaWyw==", "", false, null, null, "1f6bbc62-4203-497a-9f8a-711de6e54904", null, false, "Sheila" },
                    { "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", 0, "643d50e6-4c7d-4ff4-a950-1a18b66a93d2", "User", "Johari1234@gmail.com", false, "Johari", "Casan", false, null, "P.", "JOHARI1234@GMAIL.COM", "JOHARI", "AQAAAAIAAYagAAAAED8AIac2uGow4X0LRPeNnjZywWX+Xswd29IRZnYjPRRdvnQZege6TNTS4wCn3knWnw==", "", false, null, null, "5229e3bf-5f66-415d-a891-d6b01e856172", null, false, "Johari" },
                    { "7eee5b08-df0d-4ac0-a8db-39d924dd30b7", 0, "9393937a-9eec-4cf2-8680-21ec7c65018a", "User", "Linda1234@gmail.com", false, "Linda", "Garde", false, null, "P.", "LINDA1234@GMAIL.COM", "LINDA", "AQAAAAIAAYagAAAAEMrPmZgIU0RF9WcRY9g8Ce8t9cWLOsUIZmlkNdYUVraBOlJcoWZ1UEm4jxcXEF/xlw==", "", false, null, null, "c98e3afd-17af-426d-a28d-f4b364f01e56", null, false, "Linda" },
                    { "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", 0, "7b548c55-f0be-458e-afd8-72779829d635", "User", "Java1234@gmail.com", false, "Sergio", "Java", false, null, "C.", "JAVA1234@GMAIL.COM", "JAVA", "AQAAAAIAAYagAAAAEEnjCTWkIi9L5J+49jeF+bydQyp3ctviAd6xlEW+pKUO2ixmn1gjYiecJYA4j1pVfQ==", "", false, null, null, "3f3ce96c-2b5b-49e9-9c6b-4dbe53e01c19", null, false, "Java" },
                    { "a6866933-92a9-41e7-9100-8bee51ed0ada", 0, "9701bb7c-f8a1-4524-bcfd-8613fe02e429", "User", "John1234@gmail.com", false, "John", "Maliga", false, null, "O.", "JOHN1234@GMAIL.COM", "JOHN", "AQAAAAIAAYagAAAAEMA3hiMLNO0ymaEEaW68DWAmnlvuiemegsW7l0ObCI0CjGkb6u4zeZvZ4n2+evzX1g==", "", false, null, null, "08382f40-bb3f-4ee8-af84-36b03d3990c7", null, false, "John" },
                    { "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", 0, "6dc559a6-606c-49c4-8966-d83449049a06", "User", "Ibrahim1234@gmail.com", false, "Scheherazade", "Ibrahim", false, null, "E.", "IBRAHIM1234@GMAIL.COM", "IBRAHIM", "AQAAAAIAAYagAAAAEKKS4bJGwp+1iyipHvEWV16tlzPdCJlU5KYxav2viGnJ6ApglqLUHzhzufPXVS2lHA==", "", false, null, null, "1490f240-98d5-4b1e-acb4-f95004da7d54", null, false, "Ibrahim" },
                    { "e1a3ac20-1d20-4f37-8826-242657a746c7", 0, "c92794fa-d487-4ad7-b307-4d0205dd0317", "User", "Dimaren1234@gmail.com", false, "Ishmael", "Dimaren", false, null, "R.", "DIMAREN1234@GMAIL.COM", "DIMAREN", "AQAAAAIAAYagAAAAEDdjaOevDdytq3y7hAwMLIC+CQF2YjpsFuPiht888zoh9yZWwLCJAJVv53k/neBKAg==", "", false, null, null, "b045613f-26b9-4edc-ae80-44a7cfd7109c", null, false, "Dimaren" },
                    { "e9bcc340-e63f-40e6-8326-8fe86cbef923", 0, "b775d32c-27fe-40cf-954e-3ffa998273e8", "User", "Precious1234@gmail.com", false, "Precious Love", "Esquillo", false, null, "Y.", "PRECIOUS1234@GMAIL.COM", "PRECIOUS", "AQAAAAIAAYagAAAAEG/QVfKVXrPqMv6GvvwfPiTPf6pWa6++qCrcAYPLstqimHZADq/37GchTI0kVhLLAQ==", "", false, null, null, "6eabe881-c698-4977-af9b-98122ce8dc4b", null, false, "Precious" }
                });

            migrationBuilder.InsertData(
                table: "UserOffices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "IsOfficeHead", "OfficeId", "UserId" },
                values: new object[,]
                {
                    { 1, true, false, false, 1, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 2, true, false, false, 1, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 3, true, false, false, 1, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 4, true, false, false, 2, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 5, true, false, false, 2, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 6, true, false, false, 2, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 7, true, false, false, 3, "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" },
                    { 8, true, false, false, 3, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 9, true, false, false, 3, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 10, true, false, false, 3, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 11, true, false, false, 4, "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" },
                    { 12, true, false, false, 4, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 13, true, false, false, 4, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 14, true, false, false, 4, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 15, true, false, false, 5, "e9bcc340-e63f-40e6-8326-8fe86cbef923" },
                    { 16, true, false, false, 5, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 17, true, false, false, 5, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 18, true, false, false, 5, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 19, true, false, false, 7, "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" },
                    { 20, true, false, false, 7, "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { 21, true, false, false, 7, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 22, true, false, false, 7, "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { 23, true, false, true, 125, "537d9fcd-b505-4f93-afc6-17eb8eddff83" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { "6efeb4b8-8f63-4f75-b33a-37904ebdb409", "537d9fcd-b505-4f93-afc6-17eb8eddff83" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7eee5b08-df0d-4ac0-a8db-39d924dd30b7" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "a6866933-92a9-41e7-9100-8bee51ed0ada" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e1a3ac20-1d20-4f37-8826-242657a746c7" },
                    { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e9bcc340-e63f-40e6-8326-8fe86cbef923" }
                });

            migrationBuilder.InsertData(
                table: "PgsSignatoryTemplate",
                columns: new[] { "Id", "DefaultSignatoryId", "IsActive", "IsDeleted", "OfficeId", "OrderLevel", "SignatoryLabel", "Status" },
                values: new object[,]
                {
                    { 1, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 1, 1, "Recommended By", "Recommended" },
                    { 2, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 1, 2, "Noted By", "Noted" },
                    { 3, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 1, 3, "Approved By", "Approved" },
                    { 4, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 2, 1, "Reviewed / Recommmended By", "Reviewed / Recommmended" },
                    { 5, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 2, 2, "Noted By", "Noted" },
                    { 6, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 2, 3, "Approved By", "Approved" },
                    { 7, "cade94b1-d0d9-4ded-a46f-c8473d9fbc00", true, false, 3, 1, "Reviewed By", "Reviewed" },
                    { 8, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 3, 2, "Recommended", "Recommended" },
                    { 9, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 3, 3, "Noted By", "Noted" },
                    { 10, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 3, 4, "Approved By", "Approved" },
                    { 11, "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a", true, false, 4, 1, "Reviewed By", "Reviewed" },
                    { 12, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 4, 2, "Recommended By", "Recommended" },
                    { 13, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 4, 3, "Noted By", "Noted" },
                    { 14, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 4, 4, "Approved By", "Approved" },
                    { 15, "e9bcc340-e63f-40e6-8326-8fe86cbef923", true, false, 5, 1, "Reviewed By", "Reviewed" },
                    { 16, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 5, 2, "Recommended By", "Recommended" },
                    { 17, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 5, 3, "Noted By", "Noted" },
                    { 18, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 5, 4, "Approved By", "Approved" },
                    { 19, "7acb06ae-c2de-4fa1-8b62-53c1d63121f0", true, false, 7, 1, "Reviewed By", "Reviewed" },
                    { 20, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 7, 2, "Recommended By", "Recommended" },
                    { 21, "743b9807-3441-47c1-9285-5ff8dfd7acb9", true, false, 7, 3, "Noted By", "Noted" },
                    { 22, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 7, 4, "Approved By", "Approved" },
                    { 23, "a6866933-92a9-41e7-9100-8bee51ed0ada", true, false, 135, 1, "Recommended By", "Recommended" },
                    { 24, "e1a3ac20-1d20-4f37-8826-242657a746c7", true, false, 135, 2, "Approved By", "Approved" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "6efeb4b8-8f63-4f75-b33a-37904ebdb409", "537d9fcd-b505-4f93-afc6-17eb8eddff83" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "743b9807-3441-47c1-9285-5ff8dfd7acb9" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7acb06ae-c2de-4fa1-8b62-53c1d63121f0" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "7eee5b08-df0d-4ac0-a8db-39d924dd30b7" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "a6866933-92a9-41e7-9100-8bee51ed0ada" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e1a3ac20-1d20-4f37-8826-242657a746c7" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "e9bcc340-e63f-40e6-8326-8fe86cbef923" });

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "40012e96-55c6-4dba-901b-40c50991e18b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "ea8a5461-30b8-4b33-803c-08c601168aec");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b30468e5-537e-44d5-9c27-cc6d1a2c022e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "76d5aea9-9056-4131-bd61-e271f06fe7fc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e358ff6b-e3af-419e-8fc2-31a872147213");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "a4d92d40-3d83-4ca6-98c5-e32acb073116");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "be1f7b52-f2a5-4b87-b8b3-f9058c686a17");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "aeb38fe7-2794-4c88-81b4-52f60d9cc542");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3bf2ec8-faff-41f7-b93c-09be789bbd30", "AQAAAAIAAYagAAAAEImeUvdoocYWhjQkJNzhMuHUiQckWQvxhIBROUd9EOKivJbKxn9WTQs/qT3L7HMgoQ==", "89421508-3114-463c-aa11-912512872b96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0215289e-2d58-4cd5-a6ab-c57f11b05a85", "AQAAAAIAAYagAAAAECoXcG14AwmsJbdiaASgIUOJRPHGpYlVT4OVxkcNtS36J6EO2H20sIi4ymembA2Z+w==", "32c432b2-ce11-4322-8cd5-361de15cc74f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "MiddleName", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01aa752e-99c1-4134-83b1-7939a93019af", "Belli", "AQAAAAIAAYagAAAAEMB2Jq7QMTGjODdXFkbnBgL0ByfVNT/4/2sP2tknyaJYzJ18FIkn7WIXBz/Fiesj9w==", "0eff7506-1bbe-45b9-9d9e-a2cc79d33c39" });
        }
    }
}
