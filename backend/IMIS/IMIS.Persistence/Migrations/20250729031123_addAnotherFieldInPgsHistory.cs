using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addAnotherFieldInPgsHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DeliverableTitle",
                table: "PgsDeliverableHistory",
                newName: "Remarks");

            migrationBuilder.AddColumn<DateTime>(
                name: "ByWhen",
                table: "PgsDeliverableHistory",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "DeliverableName",
                table: "PgsDeliverableHistory",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDirect",
                table: "PgsDeliverableHistory",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsDisapproved",
                table: "PgsDeliverableHistory",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<double>(
                name: "PercentDeliverables",
                table: "PgsDeliverableHistory",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "PgsDeliverableHistory",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "36951681-1290-4ded-9674-5ff928ad8b69");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "2fb42cc0-810a-4bbf-921d-cba3541105cf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "791fd81b-1aca-4f00-83bf-c58bdfe72f1a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "10a8b42d-cee9-4d81-9e5d-e980bb73e604");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1b37067-c41e-4a07-a38a-7fe9bdde8c06", "AQAAAAIAAYagAAAAECWV5nz1g+NYkCIxvkwPqyWBUW/koWWVy/v/fJB4gjY+M58JSxS6xjfg9KWJActVjw==", "d1f005ba-0d1c-4f9d-a864-d5a1992cfd48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "138a24aa-c093-40c9-9e57-219d06bbb387", "AQAAAAIAAYagAAAAEBbUTAc5tanMY/ZYsAq7qEpW9OSvaipzbLmnqlbhOKk/1ohAgQe9J35XakLn+Atzbw==", "860c733b-2ffe-4ff5-b989-922cce3e793f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1adef2ce-62f5-417c-b984-0038762cf46f", "AQAAAAIAAYagAAAAEAA/kJRQT3oEjpo6XZ/ltmB+S9b1+40K8s1q0E+UyUQfS3dtlyprW3mfz9cU/sMRtw==", "16130245-1215-404d-90c1-7eafcd8f990a" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ByWhen",
                table: "PgsDeliverableHistory");

            migrationBuilder.DropColumn(
                name: "DeliverableName",
                table: "PgsDeliverableHistory");

            migrationBuilder.DropColumn(
                name: "IsDirect",
                table: "PgsDeliverableHistory");

            migrationBuilder.DropColumn(
                name: "IsDisapproved",
                table: "PgsDeliverableHistory");

            migrationBuilder.DropColumn(
                name: "PercentDeliverables",
                table: "PgsDeliverableHistory");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "PgsDeliverableHistory");

            migrationBuilder.RenameColumn(
                name: "Remarks",
                table: "PgsDeliverableHistory",
                newName: "DeliverableTitle");

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
    }
}
