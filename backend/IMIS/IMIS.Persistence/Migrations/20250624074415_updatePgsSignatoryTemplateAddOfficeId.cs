using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsSignatoryTemplateAddOfficeId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate");

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
                value: "a461bb8b-384d-4c97-b2e0-01c6c4d69f59");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "67e336ca-9a34-490e-85d1-c9935b4b550b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "2877cca7-ae83-4191-ade1-136ac60a8ba4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "153f494e-b30e-45b8-8b5e-62beb4d1a1f0");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "417c70e5-ada3-4136-be10-9e3774d1dd12", "AQAAAAIAAYagAAAAEDmv/FzJlwuosXMhqtc6JADhBzGzkfqMWj5UWZXxwyB36G1+oM9AuxweQyrRWiS6+g==", "17df75f6-4582-49b5-8e14-c4aa33d355ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b3e49a8-5082-4e5a-aeeb-6f46d9db2e2b", "AQAAAAIAAYagAAAAEEnVEfdznIS8XMetGdmApAuPRF0RpzBNYIXh2BFPJtlBaqLuKIhC6l6BoI/g36ijwA==", "9d4f0172-8ce7-4d39-9fd1-2c57438668f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ed91a89-7482-43ee-b47a-89a5dfe4c7de", "AQAAAAIAAYagAAAAELDuOa04DXnHXw5QeMML+g5t/aCdeORg6i6ZCW4rBaSoWnWGioXAufEY9640ofTrFg==", "b8650519-b03f-45f2-9bb2-cf9afea7b49d" });

            migrationBuilder.AddForeignKey(
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate");

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
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");
        }
    }
}
