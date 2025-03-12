using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUserRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "b5fdea0d-3825-4cba-82f1-e1f570c00edc", "475e45a8-4dd9-425c-b405-b6598ef700fd" });

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b5fdea0d-3825-4cba-82f1-e1f570c00edc");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "475e45a8-4dd9-425c-b405-b6598ef700fd");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[,]
                {
                    { "56996e97-9e8a-4d22-a693-c865144e9b96", "0fcd4192-df8c-4123-89f9-cbf7998434d5", "Administrator", "ADMINISTRATOR" },
                    { "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17", "5852282c-953e-4426-9715-d4e8a99a270f", "LDNA Manager", "LDNA MANAGER" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "d833f27b-cff1-4c0a-9a06-816f5b860002", "LDNA User", "LDNA USER" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "176bcfeb-f12a-4d42-b790-5d2312660801", 0, "b7a28aeb-4eec-432b-a602-c623cf340805", "IdentityUser", "alondealexa2021@gmail.com", false, false, null, "ALONDEALEXA2021@GMAIL.COM", "ALYXX1988", "AQAAAAIAAYagAAAAELNujDSxTolqQQIgyLFZpkxG4ylORas5c1ShDXjWTi58n11ZqHlfDAxwjRGJ6mJQVw==", null, false, "9a0456f4-b3e0-4093-be54-bfdc4dd7873c", false, "alyxx1988" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", 0, "0b9b414c-1e72-4a4c-9fbf-97dfca9c0061", "IdentityUser", "marcrejohncastillano@gmail.com", false, false, null, "MARCREJOHNCASTILLANO@GMAIL.COM", "REDZ1029", "AQAAAAIAAYagAAAAEO0vyQtbhI8HxsXfGLsjrKdlFTugXEVxmH/35ZFdkfOTz2cLOt2HYn2eTSlthCUePA==", null, false, "5ce59748-dff3-4cb3-b25c-30e38448ab5a", false, "redz1029" },
                    { "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a", 0, "ce67ac36-9a37-4297-9309-2ad0d82f4336", "IdentityUser", "CrossVampireNe0@gmail.com", false, false, null, "CROSSVAMPIRENE0@GMAIL.COM", "DARKWIZWIZ", "AQAAAAIAAYagAAAAEI+ZQ/GCcGUiXwlT7VdSP4oaNLAt4WrA7x4qIgUee1YkioP08/X0+1ys20JrBkcp1w==", null, false, "cb18d546-07e5-4ebd-984f-1d95082c6948", false, "darkwizwiz" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { "56996e97-9e8a-4d22-a693-c865144e9b96", "176bcfeb-f12a-4d42-b790-5d2312660801" },
                    { "56996e97-9e8a-4d22-a693-c865144e9b96", "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd" },
                    { "56996e97-9e8a-4d22-a693-c865144e9b96", "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17");

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd");

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "56996e97-9e8a-4d22-a693-c865144e9b96", "176bcfeb-f12a-4d42-b790-5d2312660801" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "56996e97-9e8a-4d22-a693-c865144e9b96", "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "56996e97-9e8a-4d22-a693-c865144e9b96", "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a" });

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96");

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

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "b5fdea0d-3825-4cba-82f1-e1f570c00edc", "4b8606fa-cf96-42ed-b9dd-e0679bfea2ac", "Administrator", "ADMINISTRATOR" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "475e45a8-4dd9-425c-b405-b6598ef700fd", 0, "763c74c4-5e2f-480c-8aff-ec9e1de0ec58", "IdentityUser", "ADMIN@MAIL.COM", false, false, null, "ADMIN@MAIL.COM", "ADMIN", "AQAAAAIAAYagAAAAEJNIMKakk4PwH7A/D9A1H/wt09RaO88tzGJ/QCg6MV82SUK+ZFwLQUk/bc41JaMa3w==", null, false, "a7cf8a31-e4d3-4c50-83fc-732581748e2a", false, "admin" });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { "b5fdea0d-3825-4cba-82f1-e1f570c00edc", "475e45a8-4dd9-425c-b405-b6598ef700fd" });
        }
    }
}
