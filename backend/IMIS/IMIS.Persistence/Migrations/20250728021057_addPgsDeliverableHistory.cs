using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addPgsDeliverableHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsDeliverableHistory",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsId = table.Column<long>(type: "bigint", nullable: false),
                    DeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    DeliverableTitle = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KraId = table.Column<long>(type: "bigint", nullable: true),
                    KraName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RemovedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RemovedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsDeliverableHistory", x => x.Id);
                });

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableHistory");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f9484918-d02a-457c-a802-9b56403a4fa3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "8cc8865f-d91e-4baf-8f8b-414b70d7f384");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "f18b12d1-6793-40a1-9951-7d7926f5d8a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "115d27c4-e522-4404-b98d-80ec892729ed");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a7ff127-f2d6-40a9-a3a4-a88e31f84d63", "AQAAAAIAAYagAAAAENR0Irp8+1B+IBvzu5sGxN+CaMyMCtHzbgtkgUyYBxAsDn+w9LuHZcOAu1Cw/E9kiw==", "4a75c403-4dcb-484c-b6cd-a2be66fe044a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c55b43c8-9694-4384-b9cc-0ad910ae43f6", "AQAAAAIAAYagAAAAEF4SWPXlJu+zOH02/+gJLw0aaN+GH9BjV8/0ALc8h6JSiiTX/2kp7tPwKZFABTDxmg==", "9ba07d52-1c80-4379-9724-01849d26d5a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6a2bc2c-aca9-4e8c-865a-6c8bb5fef6f9", "AQAAAAIAAYagAAAAENZcnUCQ2dtSY/D2mjMOzrpDP3bIzN/agS/vEGGlihZpoa7HxxLqCc6OQwW+GbntKg==", "6c189bfc-753e-4cc8-86d1-ab6724464472" });
        }
    }
}
