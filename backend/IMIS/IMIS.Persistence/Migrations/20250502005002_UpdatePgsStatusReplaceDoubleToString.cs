using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePgsStatusReplaceDoubleToString : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "PgsStatus",
                table: "PerformanceGovernanceSystem",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(double),
                oldType: "float");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "e2e40d59-54a1-4e76-90e3-153501f9e7b7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "c339cbac-638a-44e6-bbeb-f564a27dcbca");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "f58aa53e-3b25-4b5b-bee4-81e4037ac634");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cb0c4b0-ed53-4735-bd9b-2c0d7a4c7015", "AQAAAAIAAYagAAAAENFQBb+dSmgfpKhlYZtXP0y1klyYbdLgUArK/2zVbAz4LSKXisva60A24t15ov90+Q==", "cc4805ba-bd39-4d2c-8016-815d60698000" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae7a4434-efa2-491a-85e6-6898b3591250", "AQAAAAIAAYagAAAAEAimFjxWNrxnAk4QnFD0tqQzEObd6wngHlMBrkOBKy6jAYWvhKRUUaMVRvPK0Izfyg==", "915736b1-4c4e-4aab-80c3-33cd8d3e7d25" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c4fb2e6-8662-43bf-930b-275039ddb932", "AQAAAAIAAYagAAAAEPMl7jEDIcZ925mrCnpZzaYMOLYsBaxukHPECMCm/gFtUeTnZyPT1OWUzP1N3lnZaQ==", "e56cb5f5-207c-492b-89c4-f0f45e8212bd" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<double>(
                name: "PgsStatus",
                table: "PerformanceGovernanceSystem",
                type: "float",
                nullable: false,
                defaultValue: 0.0,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d1fcb66e-73ff-4e46-8eb9-bbe05f088bfb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "571e8cf3-8f1e-42f5-a0f2-e399462ab75d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "fb26071c-684f-4225-863a-a3afb2d91a61");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f9e81de-eec6-42fc-ae09-0c2bb3333ee7", "AQAAAAIAAYagAAAAEI/hyZiT2Lby/wxTGzOv2rBOG5NJ9zdy/ZK+ZO+0XG/RCyAFNPeu5htjylZx8GgmfQ==", "f52f2585-a7cb-4c43-950c-251437c4d1ff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "623be09f-9165-4e34-91c6-2418ae1a43f6", "AQAAAAIAAYagAAAAEPGUWtUUGv7PuLcxFMrrhYPH2dZeRq30xchsRx6wQphxA4lAmAwzvl0pJ6+KnB+lRA==", "c067f289-5b87-4d52-923f-af707aa3dd00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b0c2d70-751b-4dc8-8cf0-1f4eff2653a8", "AQAAAAIAAYagAAAAEB57iAseyqaCpbs+Oyzo6dbXOxQJHmTVPrQ/AJuL9GmBUj//rJIiKBzNHFUEne1kmg==", "9298175a-97bd-4934-9db9-67dd6500b122" });
        }
    }
}
