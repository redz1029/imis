using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updateRoleTypeAddPgsAuditor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "b042cc0a-77a6-4211-9b4e-5b3a9a7ebefa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "NormalizedName" },
                values: new object[] { "61ad3862-3846-4d09-b5cf-59d554378d32", "PGS MANAGER" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "NormalizedName" },
                values: new object[] { "bdd6adfd-3700-4c8f-9dd5-966f6285ab2d", "PGS USER" });

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "af7b586c7ee6490bbd878f46f6a47831", "33c08eab-2c2d-4a5a-9bf2-944fdf83960f", "PGS Auditor", "PGS AUDITOR" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68ac3873-3e81-4a57-aacc-edfcfbb26346", "AQAAAAIAAYagAAAAEH3wRfKkt6pMtvpuQvUI698hZMDl2XAzru6yyHFLOXqIks3bfqMZoNU9n8ZMLJkuMA==", "7fc0f803-d375-49da-8116-51e6b1564c4d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35426c51-0d56-444f-9f4c-145c0d8b1c64", "AQAAAAIAAYagAAAAEJChTp78d1scWhX7IWOLmyN0wXjVtqvKJ1D8sLnbw3d4wG4u3uQ37AxXPqkBgD8I8w==", "185bd674-0edb-4abf-87c4-a8f3b5e7e43c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48dec410-07c9-4532-a45b-c2d9d9b775e2", "AQAAAAIAAYagAAAAEI0SRv9AWP3/8bk/M4zkUCbfaSvsBCduZb5M5np5HlBm8A8ETKMUK2ylFkSn58/Z2w==", "d5b5074a-f3fa-432f-b9c2-edb8b8becf01" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "c14367c7-5c07-4aa7-acd1-e3e29f0d692c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "NormalizedName" },
                values: new object[] { "f2a435c5-5086-47dd-a08f-baddd6b5d5a8", "LDNA MANAGER" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "NormalizedName" },
                values: new object[] { "f2699a74-515e-451b-a16e-6e3105445ddc", "LDNA USER" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4aa7d9d1-7c33-4b93-8be9-20a0d2564a18", "AQAAAAIAAYagAAAAEA6wcC/ISOizuWFRifF06kqeH0qVaER7Xyt/iEd5gy2nlACUOa5+v+E9CFo95S0XDw==", "8f096102-4d96-4565-a21e-935c9d502425" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a25d9981-d621-4843-b459-b4563740f33b", "AQAAAAIAAYagAAAAEOT6xo/eC202i1nqYddx8kRH270mPoCoVG27KtOHToYZAM0rek73oifzs0B+o++LPQ==", "74712faa-ab4d-494a-b244-3ec637ef4881" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a588616-39f8-42e3-91d5-3c648c49cfc9", "AQAAAAIAAYagAAAAEMfuZAY99WlqA4hdqMeCpWIfYJuiarlGeigTWtqX/UmKWICOUIFunQ1QE/Ju+rFdtA==", "55cffa88-9758-4f29-9656-39048313aee8" });
        }
    }
}
