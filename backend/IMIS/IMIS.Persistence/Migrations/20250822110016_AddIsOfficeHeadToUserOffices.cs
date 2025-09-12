using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddIsOfficeHeadToUserOffices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsOfficeHead",
                table: "UserOffices",
                type: "bit",
                nullable: false,
                defaultValue: false);

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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsOfficeHead",
                table: "UserOffices");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8334fb1f-bcef-4fdb-9058-57839eaa1ad0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "d2928e9a-7050-4d08-8f88-f4503f25cd0f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "7217a627-8d7b-408d-a43c-ba3011839b27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "b3dbb8bc-024a-4fa7-8020-470aecefc3ec");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0c2fd4f-a880-49d2-9eea-cb47f442f929", "AQAAAAIAAYagAAAAEP8m1SmGe3PO1PjnCUnkqnaqtQTC/Js+L4gqG2WCMsc8UF9Oo+23re/2I4cFjJgpcw==", "e6170319-560e-443b-aa15-e9bb95218333" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "997538a2-8fdd-4e64-8f04-f51f431b3125", "AQAAAAIAAYagAAAAEFJYhgRplO1r6QxOtbuat/B2nOaxykpOLrN3SjtMK5VcKi89AcS+POljkFazm1Tcsg==", "26de5e35-e66a-4840-a687-a7bb046a1063" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89d9349d-7c38-4a4b-8d17-ea81da89cec1", "AQAAAAIAAYagAAAAEGA5+xklme1JB7x8KrMXs1kk16bfcP6azBsIjFxSoy1+vNDSwHwr3Xmv/jzqNw0nOw==", "5ef9bd4e-7780-4c99-94a0-5b460577a9a2" });
        }
    }
}
