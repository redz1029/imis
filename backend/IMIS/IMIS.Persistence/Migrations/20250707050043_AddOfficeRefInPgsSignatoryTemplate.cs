using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddOfficeRefInPgsSignatoryTemplate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditableOffices_Offices_OfficeId",
                table: "AuditableOffices");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditorOffices_Offices_OfficeId",
                table: "AuditorOffices");

            migrationBuilder.DropForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices");

            migrationBuilder.AlterColumn<int>(
                name: "OfficeId",
                table: "PgsSignatoryTemplate",
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
                value: "d7da037b-ab9f-4f98-84a4-7d0079a3df0b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "205ea5a4-1708-4c31-9d5c-ada866cb2c4a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "324630b8-3833-4298-b42d-7ec4c11063b6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "21dd1934-6c36-431c-8b5c-79265c6447fc");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7879e496-2548-495d-9652-c26309b30d8a", "AQAAAAIAAYagAAAAEPrKs7IMN12/lV5p6ybP9GlkTTOmmlexDlKmNyDj8badLqZ9JLabo6vVMb+EU/iFFg==", "ed8ab9ae-1ac2-4f17-8400-8c29936d228b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa2377f5-15cd-4d72-9d28-4de159a03847", "AQAAAAIAAYagAAAAEN61JwylqcI82aLBTgMdQyqwpsNRIktgf3QlRN663w7YVKgl+AGVRmNOjFZRDs9uaw==", "132ae571-1a18-4de9-8fdb-5076e7231759" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9aefb81-c46b-4d9b-b943-6b1a6b1bc1ac", "AQAAAAIAAYagAAAAEJ3zUVpRJCLBpBQk2pg2HbRhHPcknxmSS2LpB3e8E8yVv1exwQObDGiezTwoEyCZKA==", "8f7a4cc2-1af3-4124-8b4a-5e747fca0a5f" });

            migrationBuilder.AddForeignKey(
                name: "FK_AuditableOffices_Offices_OfficeId",
                table: "AuditableOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorOffices_Offices_OfficeId",
                table: "AuditorOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditableOffices_Offices_OfficeId",
                table: "AuditableOffices");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditorOffices_Offices_OfficeId",
                table: "AuditorOffices");

            migrationBuilder.DropForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices");

            migrationBuilder.AlterColumn<int>(
                name: "OfficeId",
                table: "PgsSignatoryTemplate",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d214122f-ff88-4a8a-b947-816076728d18");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "cc80949a-a36a-4efc-9d67-923544fd4755");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "93890b3f-e40c-4cc0-8b2a-b75b0e8bf181");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a13ad7c4-b03b-449c-ab9f-05565943a5cb");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "278064e6-8618-4823-afcc-694d9239fb8c", "AQAAAAIAAYagAAAAEPKEk55RVDw4IGEGSNG7f4ohH00pQ5mF9LLwoh/Ujf9H7dvH7Op03zLs2mrupDPwKA==", "47793805-8e19-42a1-84de-ddef95b89552" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c948fb3-c80e-453b-8c47-7513ec6e5301", "AQAAAAIAAYagAAAAEGdfIE96XUaqLQ5v9peCmGrOuM3DK1VW5B984u3VEWAZnLYOtRVUFewEP4+Dt5KopQ==", "501a3d0d-ecf4-4e5b-a8e7-c92d02707e09" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b4a73e7-8f14-4c9d-96e6-249244c0fd7c", "AQAAAAIAAYagAAAAEHzdrX4CM7nysW7gAomCDxyUTZXe1hVpRnjp4ZYx71zeBba6sjMLNU8PvdwXv1oa3w==", "cf37c404-9e67-4cd3-9707-b3ea187e0458" });

            migrationBuilder.AddForeignKey(
                name: "FK_AuditableOffices_Offices_OfficeId",
                table: "AuditableOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorOffices_Offices_OfficeId",
                table: "AuditorOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
