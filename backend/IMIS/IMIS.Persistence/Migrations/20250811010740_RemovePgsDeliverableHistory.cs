using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RemovePgsDeliverableHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableHistory");

            migrationBuilder.AddColumn<DateTime>(
                name: "RemovedAt",
                table: "Deliverable",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "RemovedBy",
                table: "Deliverable",
                type: "nvarchar(max)",
                nullable: true);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "RemovedAt",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "RemovedBy",
                table: "Deliverable");

            migrationBuilder.CreateTable(
                name: "PgsDeliverableHistory",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ByWhen = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    DeliverableName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DisapprovalRemarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    IsDirect = table.Column<bool>(type: "bit", nullable: false),
                    IsDisapproved = table.Column<bool>(type: "bit", nullable: false),
                    KraDescription = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KraId = table.Column<long>(type: "bigint", nullable: true),
                    PercentDeliverables = table.Column<double>(type: "float", nullable: false),
                    PgsId = table.Column<long>(type: "bigint", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RemovedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    RemovedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false)
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
                value: "d6a4a2f8-ebd7-4e1f-b552-2258c34664f4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "3c26b4ff-f0ad-433f-9729-0476027cd430");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b0615745-f9e8-473d-bed8-ec5e6cd9a16c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "d9fffdb3-31a3-4acf-b45f-e82cb0772513");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25720d8c-1657-42f6-88ed-55b79d6e3fef", "AQAAAAIAAYagAAAAEMSolzltEl5tknfg8jVuOiyUKgqw5VCf21DuxBJ31dWgh5ZMugigJW0EjcxEly4ZXg==", "bcdfb095-8f23-4509-b580-603d3279850f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc3e73fc-0b92-4f46-a284-e578fc4e3be8", "AQAAAAIAAYagAAAAEHHeTOfYAZAf6wkxk7rltsCNCQMoVrbCcwz/sXl1ixMuHxOnQTfP9Vct0bUyAMqykQ==", "9bc99acf-ae7e-475c-8d53-946a7a2b666c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a869afc0-d954-493a-ab0e-74538e0c1377", "AQAAAAIAAYagAAAAEJD83MZdZatjxrzVwmpntZFitkhfEAor/UlDGQD1G9VH7/lom5AppuwitpOosfWZbQ==", "cdf661f5-749a-445d-b68e-02e7fd0390c5" });
        }
    }
}
