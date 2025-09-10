using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class LinkPgsPeriodfromAuditorOffice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PgsPeriodId",
                table: "AuditorOffices",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "a3e44b30-feed-494a-a94f-e230ba4a4258");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "d256ee88-31db-46ab-a2a1-f4def68eb83f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "15ac88b2-4763-4127-b489-d237aa812cdf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "ed5c871e-5737-4d76-9b63-1562d32122b1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b20624d2-f17d-4de0-97f6-2082d6fae5b0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "ece9fc78-8b8c-4787-9fd8-285d41cdedf6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "f31cc8ca-70e0-4645-95a1-5824e563e917");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "02c0c5dd-49e3-45d6-af06-3ada89d49086");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "656406e2-4446-4553-9bc3-50cd705e9005", "AQAAAAIAAYagAAAAEH2i5pN9hSedZRDx7PRGL+lfZ+/1rMLBvUxexLcHEWf0KZmal7dGwtQ85q0L4svS+Q==", "df066198-2548-4a49-b587-cd5847f12543" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5934b56-4635-43f2-9df5-0c9089aeecdf", "AQAAAAIAAYagAAAAEB4Kb205VevrnexcWlf3in60NAes0hJPXfX8p7FtcMdTgg7JTkmJgOblP2i5hXoLBA==", "98d3abda-6c52-4789-a1b1-c5fa3b5bcf1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76ea1e16-dcb6-4f73-a3f8-ea4afffcef00", "AQAAAAIAAYagAAAAELg+QiYFlYRJWtgCL1TFq7Nb9/+8jmoym9yhoOVIFNwR3B1bTUHOYjzLq/sULw5Nhg==", "6940c0ab-1c42-4a53-8e1e-8ccf7e95eda1" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditorOffices_PgsPeriodId",
                table: "AuditorOffices",
                column: "PgsPeriodId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.DropIndex(
                name: "IX_AuditorOffices_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.DropColumn(
                name: "PgsPeriodId",
                table: "AuditorOffices");

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
        }
    }
}
