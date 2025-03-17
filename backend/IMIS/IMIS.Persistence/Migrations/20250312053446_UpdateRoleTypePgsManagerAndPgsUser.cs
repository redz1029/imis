using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateRoleTypePgsManagerAndPgsUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "7db08584-bb44-494f-ae1e-6eaddebd4a43");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "8013d560-f709-4752-a502-fa08b12be221", "PGS Manager" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "003c5b28-6857-4e4c-97d3-41f2e8deda35", "PGS User" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04be229a-dfa4-4491-b35b-250d5ddd7d31", "AQAAAAIAAYagAAAAEBvFfsr8jVyLhmRSbXaoQRdB3eP/xpwWmxX73o+KwXPD/IaLU2HQY6UpDsxJaNl8hQ==", "95714f35-2814-4c3c-acf4-8833f12bd28e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0e56ece-cf61-41f1-a1a5-8c53af03112e", "AQAAAAIAAYagAAAAEEO8udTCynUIU0klTVLzgQEEN84vXENfZ9ObEx6ntdYvkfoxzaRZDIYfg4/Ld1KnyA==", "c5e9ffe9-97b0-466b-bf99-5846392c5bb5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ad20699-94e7-4fa1-a926-8385f0d550a0", "AQAAAAIAAYagAAAAEC4Mi9RxBzNHT8QUJl9Zo7NS9QP7kVmedjc+7XjPMVz/u1WujjWRCSTpidM2Khd23A==", "3733b2ff-5912-490b-a7fa-4c2eae940a8b" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "0fcd4192-df8c-4123-89f9-cbf7998434d5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "5852282c-953e-4426-9715-d4e8a99a270f", "LDNA Manager" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "Name" },
                values: new object[] { "d833f27b-cff1-4c0a-9a06-816f5b860002", "LDNA User" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b7a28aeb-4eec-432b-a602-c623cf340805", "AQAAAAIAAYagAAAAELNujDSxTolqQQIgyLFZpkxG4ylORas5c1ShDXjWTi58n11ZqHlfDAxwjRGJ6mJQVw==", "9a0456f4-b3e0-4093-be54-bfdc4dd7873c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b9b414c-1e72-4a4c-9fbf-97dfca9c0061", "AQAAAAIAAYagAAAAEO0vyQtbhI8HxsXfGLsjrKdlFTugXEVxmH/35ZFdkfOTz2cLOt2HYn2eTSlthCUePA==", "5ce59748-dff3-4cb3-b25c-30e38448ab5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce67ac36-9a37-4297-9309-2ad0d82f4336", "AQAAAAIAAYagAAAAEI+ZQ/GCcGUiXwlT7VdSP4oaNLAt4WrA7x4qIgUee1YkioP08/X0+1ys20JrBkcp1w==", "cb18d546-07e5-4ebd-984f-1d95082c6948" });
        }
    }
}
