using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class FixedUserSeederConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a");

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

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "176bcfeb-f12a-4d42-b790-5d2312660801", 0, "25720d8c-1657-42f6-88ed-55b79d6e3fef", "User", "alondealexa2021@gmail.com", false, null, null, false, null, null, "ALONDEALEXA2021@GMAIL.COM", "ALYXX1988", "AQAAAAIAAYagAAAAEMSolzltEl5tknfg8jVuOiyUKgqw5VCf21DuxBJ31dWgh5ZMugigJW0EjcxEly4ZXg==", null, false, null, null, "bcdfb095-8f23-4509-b580-603d3279850f", null, false, "alyxx1988" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", 0, "cc3e73fc-0b92-4f46-a284-e578fc4e3be8", "User", "marcrejohncastillano@gmail.com", false, null, null, false, null, null, "MARCREJOHNCASTILLANO@GMAIL.COM", "REDZ1029", "AQAAAAIAAYagAAAAEHHeTOfYAZAf6wkxk7rltsCNCQMoVrbCcwz/sXl1ixMuHxOnQTfP9Vct0bUyAMqykQ==", null, false, null, null, "9bc99acf-ae7e-475c-8d53-946a7a2b666c", null, false, "redz1029" },
                    { "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a", 0, "a869afc0-d954-493a-ab0e-74538e0c1377", "User", "CrossVampireNe0@gmail.com", false, null, null, false, null, null, "CROSSVAMPIRENE0@GMAIL.COM", "DARKWIZWIZ", "AQAAAAIAAYagAAAAEJD83MZdZatjxrzVwmpntZFitkhfEAor/UlDGQD1G9VH7/lom5AppuwitpOosfWZbQ==", null, false, null, null, "cdf661f5-749a-445d-b68e-02e7fd0390c5", null, false, "darkwizwiz" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "1e3ca4d4-fa38-4f75-aa1d-8558c16c7bc2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "da0752d8-54ec-40b0-b0f7-6c5522d1ba92");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4676786d-2cc8-417c-9dd1-b5faea3d824d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a72f1e53-5aa0-49d4-a65a-1ad67307d118");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "176bcfeb-f12a-4d42-b790-5d2312660801", 0, "ff37ad51-ed10-4e8d-8e50-eb2a6b7518ef", "IdentityUser", "alondealexa2021@gmail.com", false, false, null, "ALONDEALEXA2021@GMAIL.COM", "ALYXX1988", "AQAAAAIAAYagAAAAEKGZx5J27XTx52MhAsWaPzSjyEBMXsZIWw6Ld8OjQn9St+JUcU22w0ktMDoHkUtHTw==", null, false, "5891e080-23e8-4426-81e8-72772cafd340", false, "alyxx1988" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", 0, "db3675eb-3d80-432e-8385-21acd295efa2", "IdentityUser", "marcrejohncastillano@gmail.com", false, false, null, "MARCREJOHNCASTILLANO@GMAIL.COM", "REDZ1029", "AQAAAAIAAYagAAAAELZbijW2azgrtjR65o8vug3rOLPNMW+oe627Vwnrz0zD+EwzIxD3tQWNigE9YKqxYg==", null, false, "15988ee4-194a-457f-bba3-9c4a697fde5a", false, "redz1029" },
                    { "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a", 0, "b006eb28-7570-4061-b142-814276e16c8f", "IdentityUser", "CrossVampireNe0@gmail.com", false, false, null, "CROSSVAMPIRENE0@GMAIL.COM", "DARKWIZWIZ", "AQAAAAIAAYagAAAAEFQLWbBXdrFPLBwOSw6Xv2O9g5nFIMX0nRvuq83RXjnXKz5gIQ4EczsrHl5H+xrTAA==", null, false, "4a66d7a1-88ea-4cd1-979c-a6406992a09e", false, "darkwizwiz" }
                });
        }
    }
}
