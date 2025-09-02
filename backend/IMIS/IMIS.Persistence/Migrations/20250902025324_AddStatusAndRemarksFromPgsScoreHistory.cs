using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddStatusAndRemarksFromPgsScoreHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Remarks",
                table: "PgsDeliverableScoreHistories",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "PgsDeliverableScoreHistories",
                type: "int",
                nullable: false,
                defaultValue: 0);

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
                column: "ConcurrencyStamp",
                value: "8ca164d1-6e00-481c-af90-7129ff3e790f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "9a511cca-077e-45eb-9006-57e8aae3e617");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Remarks",
                table: "PgsDeliverableScoreHistories");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "PgsDeliverableScoreHistories");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "03b28406-24de-4aac-ada0-fd1c07b25e89");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "d91a9202-cf4d-4777-be65-d645d918946f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "cdc1dd7e-999f-4f09-a2e0-1a701ea60947");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "de4f88de-7daa-4f82-9e45-ce57c3847666");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38db5f03-2ee6-4297-98e1-01887bb12e76", "AQAAAAIAAYagAAAAEEJCKmpQle9EZ1IJKY5IFvllGRnYBgNmFDMDBhylwGJLwz8i7yHM5O4nbIh9bA5uXw==", "385f1e08-09bb-4b31-96e5-7ad2e95febe3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70a86d84-1886-4646-a5d2-bd91ff16b226", "AQAAAAIAAYagAAAAEFvPkCFV2yWsBs4tEvai1T0mjzRooyUaS301nVpdOGsWx0cuWaqMqRv3y1VPIIqoEg==", "a38a8f36-f95e-48cf-a077-dc59d0ce0ecb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0d3ddf1-487e-44d5-84fd-306e485197fb", "AQAAAAIAAYagAAAAEGY+apRWVrqrYslOPiJnKEV7Rn3jxeKAHdDbRiqbEwqZ1DmJFUKVU1gdJpHQ0FJv4g==", "3aa56afb-6c1a-4ee2-b40d-1f7a98f55a7f" });
        }
    }
}
