using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class removedKraNameAddDisapprovalRemarks : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "KraName",
                table: "PgsDeliverableHistory",
                newName: "KraDescription");

            migrationBuilder.RenameColumn(
                name: "Description",
                table: "PgsDeliverableHistory",
                newName: "DisapprovalRemarks");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "5d939f70-a17d-4725-b5be-3d26f288e23a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "1c9d92e2-960d-47fa-a87a-825a6b1d08a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "7aa4652c-ff1c-4378-a237-d2ee2ab6701b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "384e1654-3345-4158-ae71-582ae0a7e295");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba4f7642-3c0d-49bd-8cfb-1852b1fe94ac", "AQAAAAIAAYagAAAAEB86oJHVgmyw+ELItb/akBWNj0Gxo5PgAxKskF/VTfb+UHU9TRJPCXHup/pk6d4Epw==", "32f51b90-2f98-4529-8946-63ab7b7d7caf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb074ba5-0c23-496d-9324-8e895d19cc12", "AQAAAAIAAYagAAAAEIe3hJuYv3WDMo8Jxmj+VASL9ktXmxdY6q9lEGkeRFjrTFqprxKMg3IEtAuOJCEcxg==", "0c96525b-692e-4666-9b18-62f3c2023740" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11ac0f9e-3d7d-4db1-9b09-e0e47c9d3d0a", "AQAAAAIAAYagAAAAEC7fe1/W0pTiY6lMg/RFikEbl5KPCmnLGSyAVnv1GjYpcc12iubw4lG6sLDEl2y8pQ==", "03a3ecbf-29c1-4011-9668-ba8bfd24b7fa" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "KraDescription",
                table: "PgsDeliverableHistory",
                newName: "KraName");

            migrationBuilder.RenameColumn(
                name: "DisapprovalRemarks",
                table: "PgsDeliverableHistory",
                newName: "Description");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "fa71031e-b9d6-4667-a54e-39b88b50c9c2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "bddb1be5-00cf-4f5a-8fd5-92807d323b12");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "1440c429-2dd3-4fca-a69a-0524a97f305c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "6d01ad43-9a7a-45e1-806e-d5eeb8ddb358");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a05e711-0da3-4ccd-9ddb-60bc79b7e42b", "AQAAAAIAAYagAAAAEPBkl94R5q8l/W5APGHsDXEYdwMYz4Pl2TO3t5uVxC/qTK9Xk41EMEpK+D9F575b9w==", "20b01e8f-12e7-4a7a-9862-c4c1fc7be858" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "126617aa-6821-4ecb-9465-7cabffb4cc2e", "AQAAAAIAAYagAAAAEFnW6v99BXcKU3GVSg91YNEKkWIkMkUzX1rb4Rf7AEiVQA8Ipx1DEYSJSYBdZ020Xw==", "438ffdfc-118c-4ece-b80b-619254982858" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cf13434-687d-4684-90f4-82f06f27e4b0", "AQAAAAIAAYagAAAAENOt0irnC9f15vybCmUuPVgbioG1mAkBrOaFtReL1qReWF3hkjtScd/nUgoEVfQl5g==", "018f568d-20da-4aff-93bc-de813e877994" });
        }
    }
}
