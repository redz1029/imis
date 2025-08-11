using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateRemovedAtMakeOptional : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "RemovedAt",
                table: "Deliverable",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "a7bebb35-d560-4376-a6f7-a0f0000e297d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "0ebf2c83-2605-4978-8b35-9cc8cc2b2cb9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "74215862-a502-4944-a567-93d30be95315");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "0535354e-929e-4c76-bb97-786752fcc715");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6640228-514d-4032-8ec8-43b9cfafd780", "AQAAAAIAAYagAAAAEPS0a3mF/jpUDDcoWq0Rdn3FRxbfMRr9t+gwGis+n1t+QVHLCPmjK+sByB4LW7r98A==", "d57e0401-ca7e-4538-9550-68e28f7349c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c051490c-423d-4e84-b461-d880235bf21b", "AQAAAAIAAYagAAAAEDAC0xSGcCaoBWBClSI+itC3CYVROGQzDXfHkSaTog3OFKqJiIbg/qLLoStLBZauVw==", "d87cd67d-6058-48d4-84a0-254bd8c0d7bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ebc2390-434e-4ebb-bde4-66ed37662cb4", "AQAAAAIAAYagAAAAEAgw7XppebVYiE/EdvZdFUA+20OiVdb9H3Afdv78xmgd5e/GhJn0X9uKE4GPPI4h6w==", "15f3c166-4e32-43ae-87c6-8725dc2ea9e7" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "RemovedAt",
                table: "Deliverable",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "5a427bc8-6876-4608-a686-8eadf4001922");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "ac8cb754-f0ba-4df1-8aa7-7172a389d1c5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "9a8adeca-19a1-4577-b61b-d3ae445fcc5e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "3b8bdce0-0688-4e87-a63c-21aa243a5d13");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1eef7fb4-66df-456c-b6d6-4e4deac653a5", "AQAAAAIAAYagAAAAELMwuZ9cIPlZ15v1cEf3rxyKsHlmbud1T9f2BkJg8IV7l/hj5127V/czd1FCjcEhXQ==", "683006da-68dc-4c47-bf77-5514a04dd760" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3f9f13c-aab8-4b72-a9f6-c82ae2829930", "AQAAAAIAAYagAAAAEKoVW7h/rMPqgYmpYBuVmhHFFPX9XilW8qti3bp19D4iPAP7A7zDsn91RgFcUli7zg==", "c679b49c-0e45-4d6b-b45f-d2b6154ef009" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f4a0c69-ae68-44be-a2a1-ae3cce3e2ce5", "AQAAAAIAAYagAAAAELwwX3Ic3RCLonYdOXNcB7l8zxT9sVGvD/GMH5SOH6bHF3yi5hzmSDeWbR1vD2mlnQ==", "2d204db1-1fb3-475b-9d68-468ca3c7b6c8" });
        }
    }
}
