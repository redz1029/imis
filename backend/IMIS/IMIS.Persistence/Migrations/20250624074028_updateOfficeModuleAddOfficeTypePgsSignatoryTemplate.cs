using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateOfficeModuleAddOfficeTypePgsSignatoryTemplate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices");

            migrationBuilder.AddColumn<int>(
                name: "OfficeId",
                table: "PgsSignatoryTemplate",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "OfficeTypeId",
                table: "Offices",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ParentOfficeId",
                table: "Offices",
                type: "int",
                nullable: true);

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

            migrationBuilder.CreateIndex(
                name: "IX_PgsSignatoryTemplate_OfficeId",
                table: "PgsSignatoryTemplate",
                column: "OfficeId");

            migrationBuilder.CreateIndex(
                name: "IX_Offices_ParentOfficeId",
                table: "Offices",
                column: "ParentOfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices",
                column: "OfficeTypeId",
                principalTable: "OfficeType",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Offices_Offices_ParentOfficeId",
                table: "Offices",
                column: "ParentOfficeId",
                principalTable: "Offices",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices");

            migrationBuilder.DropForeignKey(
                name: "FK_Offices_Offices_ParentOfficeId",
                table: "Offices");

            migrationBuilder.DropForeignKey(
                name: "FK_PgsSignatoryTemplate_Offices_OfficeId",
                table: "PgsSignatoryTemplate");

            migrationBuilder.DropIndex(
                name: "IX_PgsSignatoryTemplate_OfficeId",
                table: "PgsSignatoryTemplate");

            migrationBuilder.DropIndex(
                name: "IX_Offices_ParentOfficeId",
                table: "Offices");

            migrationBuilder.DropColumn(
                name: "OfficeId",
                table: "PgsSignatoryTemplate");

            migrationBuilder.DropColumn(
                name: "ParentOfficeId",
                table: "Offices");

            migrationBuilder.AlterColumn<int>(
                name: "OfficeTypeId",
                table: "Offices",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8b1e1fe2-a900-4aec-89d8-ebc52945432f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "689287ed-707a-4b30-a195-38a70b0b93ba");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "83fc3db0-0032-4343-be9e-f5718977afd2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "8ceea30b-edd6-4315-a2a3-d24648871c44");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a2da38f-acb7-4591-886e-d859ca8be347", "AQAAAAIAAYagAAAAEOax/6IIp8/f7549uUVs0kQ63JXZ0trvya4+vI3CforAVqkiFi4INkuMLUnKLX+hHg==", "859b08da-7f50-4edd-956e-136eff323be6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ad3a4b3-37de-491f-9bf8-724d3491950a", "AQAAAAIAAYagAAAAEJDUNYFfgzVdPgIPUnaLaDXHHlt1Gv8gU0ArJQ+WJjo+Ewf4LSw73Vi5e0cFWUOO8Q==", "e0def2e6-7413-4559-b79a-069f6038760e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0867eca1-b14f-41e8-b670-abb56893cd89", "AQAAAAIAAYagAAAAEMXSyAjGdx2HzFLLJjZcq5cXRcjxbxXMv2T85gThY773dsplkXko1LsXLKem1tfG/g==", "ab9bdafd-5828-45c3-ace8-7dfd627729da" });

            migrationBuilder.AddForeignKey(
                name: "FK_Offices_OfficeType_OfficeTypeId",
                table: "Offices",
                column: "OfficeTypeId",
                principalTable: "OfficeType",
                principalColumn: "Id");
        }
    }
}
