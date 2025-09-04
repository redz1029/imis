using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addServiceHeadfromRoleConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f40acd51-9017-4dd7-9752-1ca9d21303b2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "623114be-71e3-47d8-87e2-76da98555922", "PGS Core Team", "PGS CORE TEAM" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "a79422fd-e69b-48b5-852d-1cb0b5180705", "PGS Auditor" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a64cbc03-0f92-45c8-9f08-1e9980f9ad66");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "95f224dd-3973-42ef-b350-7af30f67c2ca", "2a172bab-d7b7-4f8c-922a-eaa9ebe8d8c2", "PGS Service Head", "PGS SERVICE HEAD" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d6a4b3c-cd5a-4279-a6c2-175420ca9733", "AQAAAAIAAYagAAAAEDRL5QE8Iaq6uXaTUstGy0lm1xuGbtmzbkqM/wzImZAXWogVKrfGZLR/tmKpUutdXg==", "18451ffc-68e3-438e-a67d-750b20bfcb39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0885e4dc-9968-4433-86be-1f3b2ab3f8f1", "AQAAAAIAAYagAAAAEHePTye5//S79cL8l1/VgyxvX+Iyyx006SDU4YUOl/wt2dgxP6W695vXluxrKvbHtw==", "72f71fdd-9018-4e08-b1b4-1b106887684b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4645f750-51b0-4abd-bde3-1ce04f77b141", "AQAAAAIAAYagAAAAEGPmtXfcjOY6YaowUbzmzNmPHx+XPGJVKyQ5Foko96hM8LbtHx5H2+/qBXRKaPIFYA==", "5eecb340-16d7-4fa5-8ab5-6386673acdcc" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "84a6d68e-25fb-43bb-9d47-b07e962c7041");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "8ca164d1-6e00-481c-af90-7129ff3e790f", "Pgs Manager", "PGS MANAGER" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "9a511cca-077e-45eb-9006-57e8aae3e617", "Pgs Auditor" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "f10be83d-376a-4cdc-9265-68306c96be9b");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef4da378-4008-441a-b78d-9eeffe86e769", "AQAAAAIAAYagAAAAENHhQKxPI3GNWDOoyC4hHE8ImbmL38vzghUDyusw0w5z4aCUv/1Ud/rayqHht3O/VA==", "19611e52-f65f-445e-93e4-c599a80eb349" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55a4ffbf-f4bf-4e25-965a-d92d4f8d5be9", "AQAAAAIAAYagAAAAEIyrir7CaXKbGgeRJ8bn4KT/+GBtBOQq2tPRzPjOnh9cgIViBmnNHsMS1sXyZTrXcQ==", "ca30516a-bfcf-446e-acdc-47001f3056c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1eb5f4b2-4902-4684-a959-11a1c2fd5909", "AQAAAAIAAYagAAAAEOmzFTmJlWSEOqMv2zyxWPNvLYYfx+uXh7QazBWs1Fc/Vz4PDTZ2nqltf6Yt6wPEow==", "d9d0e3f9-da38-4257-9215-06d47ade72a7" });
        }
    }
}
