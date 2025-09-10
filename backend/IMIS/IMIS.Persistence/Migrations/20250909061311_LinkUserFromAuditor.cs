using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class LinkUserFromAuditor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Auditors",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "84a90b17-d3d0-4c63-a666-e7b7cc024917");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "a9b43915-5970-49fa-817a-0c05bd8c3c1e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "88fbe332-8795-4474-84bd-62ddd9fc68e0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "15325cce-eb28-4ad6-bad2-ab051c7d652c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4599405f-029d-4165-9fc3-90f5558ff3ea");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "1c0fb14e-cfee-4ee1-99a4-1fa2f65ecb12");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "4d1410ad-7fcf-4190-a360-51918918f6e4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "035244f8-4bc7-4d98-912e-f9f5c318dd07");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb7afddb-692f-4bd4-9b69-47ec5bc6fd21", "AQAAAAIAAYagAAAAEL4g6Y55OwfHmtEcdCUZ4fGEbLnn669SD+JEAIsf8C07CC7bDvqrEEngO7d8Miq0ag==", "62828558-6b23-455d-93ab-054802349d74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f44f215-496e-4342-934e-2ac17548e2a6", "AQAAAAIAAYagAAAAEB/BNg9qEBnIsg5xTGT2YK6TTPfhdwq7yNaVgP/8teNfRZy8g8qnzYnm09yflKY4NQ==", "aec6cc51-0a19-4ae0-aef3-743700d7f181" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47d958db-9d5d-4078-8723-d5e9b630a2ce", "AQAAAAIAAYagAAAAEJNZLNbKrqOhkslICcic7sV9Ert9sCuGB47bLcGiR27ZeUALX2ZUb1aP6qqNnjojhA==", "8071392f-815c-41b2-b67a-2400c07a8f90" });

            migrationBuilder.CreateIndex(
                name: "IX_Auditors_UserId",
                table: "Auditors",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Auditors_AspNetUsers_UserId",
                table: "Auditors",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Auditors_AspNetUsers_UserId",
                table: "Auditors");

            migrationBuilder.DropIndex(
                name: "IX_Auditors_UserId",
                table: "Auditors");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Auditors");

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
                column: "ConcurrencyStamp",
                value: "470d6bf5-19e0-4959-94a5-fa41f26e7f71");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "46ffc5c4-49a7-4ea0-9dff-29eb311f9cea");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "64a06072-5dbc-4972-b92a-c6c57461720c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "dea26083-13e6-454a-8e5d-b98fd1186e1d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "fd9e60c9-b56b-47a6-a4ec-bce3b3380629");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "e0ba7661-49a0-4c0d-91b8-e8b16eb5c48e");

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
    }
}
