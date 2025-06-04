using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsDeliverableAddKraDescriptionColumn : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "KraDescription",
                table: "Deliverable",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8ed2f590-8daa-42ce-aeb0-aff145c5453a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "40a7a351-2e90-4ca2-814a-b990e0a64837");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "0584e143-ec5c-456a-b3f6-3167ee654734");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "403d6cd3-638c-4740-b3d2-b36cd902f63d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6ef654a-e60f-4344-a47a-96a5a868eff6", "AQAAAAIAAYagAAAAEDxgqXhhsTyyfEGatdjJz4l/69DwCoV8IDF18APsOqjpnZZjtiG9KL1mLvcO1qVtEw==", "1f7071c2-c388-4436-a429-91e68aa8ec52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5cc46128-a148-4b10-854e-bc18b200751f", "AQAAAAIAAYagAAAAEPbF0vVB+FgCPa7wR4cUVGDtJRlZjZdPlVPXnFqv4/ECiQbpBCYOrZuQzUDsR+TdhQ==", "2adc39ba-1437-46cd-9a2d-0ac54807247c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cb3eba8-83cd-4b76-9e11-c147b89755c5", "AQAAAAIAAYagAAAAEA8MFngZPglnznJ7gcz/D2ADkyqZlJYZ81at4UnjDVOEwD0mSpheKVIx1a98t0C71Q==", "6dbcc4c7-f8fc-47f0-aa9b-e491c517db8e" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "KraDescription",
                table: "Deliverable");

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
                column: "ConcurrencyStamp",
                value: "61ad3862-3846-4d09-b5cf-59d554378d32");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "33c08eab-2c2d-4a5a-9bf2-944fdf83960f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "bdd6adfd-3700-4c8f-9dd5-966f6285ab2d");

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
    }
}
