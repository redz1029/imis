using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AllowNullIsOfficeHead : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsSignatory_PgsSignatoryTemplate_PgsSignatoryTemplateId",
                table: "PgsSignatory");

            migrationBuilder.AlterColumn<int>(
                name: "PgsSignatoryTemplateId",
                table: "PgsSignatory",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

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

            migrationBuilder.AddForeignKey(
                name: "FK_PgsSignatory_PgsSignatoryTemplate_PgsSignatoryTemplateId",
                table: "PgsSignatory",
                column: "PgsSignatoryTemplateId",
                principalTable: "PgsSignatoryTemplate",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsSignatory_PgsSignatoryTemplate_PgsSignatoryTemplateId",
                table: "PgsSignatory");

            migrationBuilder.AlterColumn<int>(
                name: "PgsSignatoryTemplateId",
                table: "PgsSignatory",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "6b85d3cc-782c-4d32-a1f9-91acc1d604bd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "88fd32b6-bced-4f47-9758-33d946894563");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "9cbe70b1-c9f3-4ec9-bae2-937201ad6992");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "d8f68c6c-4803-43fe-9382-e4a3842da16b");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be562952-aa54-4ee3-9c19-c46faaa94208", "AQAAAAIAAYagAAAAEBhAIoCNcRE+Iqa+jj6sjMfYovx6ihULku7rwFf+6JZEnv862iB8rm2ZMk3q5DZgQg==", "d511c819-058a-4522-a7c2-ad761f4ed6c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3adc1cd4-cf83-46fb-a2c6-615485d88235", "AQAAAAIAAYagAAAAEFi1o8hMacE1J9A5k1Bpj6b30Gv6YDWmIBrTh6ZmxaLNZG6PONP0EtNgnNUxUHAzjw==", "a59b4942-be49-4e01-bc87-d3a5903c757f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "647ad89e-58ab-4e2e-8e73-3a7668112565", "AQAAAAIAAYagAAAAEDlLzGk6DYOs3MXvvc/QBepEIPPyBrElMtJYXBcOTRak+nPL+682gDcQq21cws+spw==", "ccfb492c-1f61-449e-aa81-d0ec21858530" });

            migrationBuilder.AddForeignKey(
                name: "FK_PgsSignatory_PgsSignatoryTemplate_PgsSignatoryTemplateId",
                table: "PgsSignatory",
                column: "PgsSignatoryTemplateId",
                principalTable: "PgsSignatoryTemplate",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
