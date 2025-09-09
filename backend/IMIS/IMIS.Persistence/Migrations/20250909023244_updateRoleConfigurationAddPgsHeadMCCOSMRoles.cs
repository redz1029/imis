using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateRoleConfigurationAddPgsHeadMCCOSMRoles : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d493e50e-03a6-4eff-ae5f-86484e419d0f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "215316e8-ae7a-40c8-8103-4d4ff1c6fd23");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "470d6bf5-19e0-4959-94a5-fa41f26e7f71", "Service Head", "SERVICE HEAD" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "64a06072-5dbc-4972-b92a-c6c57461720c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "e0ba7661-49a0-4c0d-91b8-e8b16eb5c48e");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421", "46ffc5c4-49a7-4ea0-9dff-29eb311f9cea", "OSM", "OSM" },
                    { "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234", "dea26083-13e6-454a-8e5d-b98fd1186e1d", "PGS Head", "PGS HEAD" },
                    { "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21", "fd9e60c9-b56b-47a6-a4ec-bce3b3380629", "MCC", "MCC" }
                });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f49817b7-d431-4bba-8e87-0b840b587c77", "AQAAAAIAAYagAAAAEEd6HaWrTcaleUQ2BzkGA2L87LxpqsCe6oOMO9sks/MM+tgvwwHF9HdZFLDlfcpC/Q==", "7540af5a-11b9-4fd6-9e9b-c54a45471ca0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0221baea-2c35-4cb4-8f57-6e7ed9f86f60", "AQAAAAIAAYagAAAAEBjUw4/Cj6pRRKec5/axjkHRx8S69tY6gilFzwhCjptutp5Vfm+CfscT0D3ijEbHfw==", "c0146121-dc00-4781-8878-63f53b3140e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87d4f98c-9324-4334-aad1-6010d66c704b", "AQAAAAIAAYagAAAAECSVU6KGigqwEzg2f8HoIjlSAFDxpKngknCam4y2t4fZqCudbo8/D03Dwp/sntBd4Q==", "26ac8c36-ceba-4e0a-88aa-660f3bb1b69e" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21");

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
                column: "ConcurrencyStamp",
                value: "623114be-71e3-47d8-87e2-76da98555922");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                columns: new[] { "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "2a172bab-d7b7-4f8c-922a-eaa9ebe8d8c2", "PGS Service Head", "PGS SERVICE HEAD" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a79422fd-e69b-48b5-852d-1cb0b5180705");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a64cbc03-0f92-45c8-9f08-1e9980f9ad66");

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
    }
}
