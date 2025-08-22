using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUserSeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "8334fb1f-bcef-4fdb-9058-57839eaa1ad0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "d2928e9a-7050-4d08-8f88-f4503f25cd0f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "7217a627-8d7b-408d-a43c-ba3011839b27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "b3dbb8bc-024a-4fa7-8020-470aecefc3ec");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "Email", "FirstName", "LastName", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "f0c2fd4f-a880-49d2-9eea-cb47f442f929", "earlmaerama@gmail.com", "Earlene Mae", "Rama", "Gallos", "EARLMAERAMA@GMAIL.COM", "RAMA.EMG", "AQAAAAIAAYagAAAAEP8m1SmGe3PO1PjnCUnkqnaqtQTC/Js+L4gqG2WCMsc8UF9Oo+23re/2I4cFjJgpcw==", "09128293036", "e6170319-560e-443b-aa15-e9bb95218333", "rama.emg" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "FirstName", "LastName", "MiddleName", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "997538a2-8fdd-4e64-8f04-f51f431b3125", "Marc Rejohn", "Castillano", "Ballares", "CASTILLANO.MRB", "AQAAAAIAAYagAAAAEFJYhgRplO1r6QxOtbuat/B2nOaxykpOLrN3SjtMK5VcKi89AcS+POljkFazm1Tcsg==", "09959283775", "26de5e35-e66a-4840-a687-a7bb046a1063", "castillano.mrb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "Email", "FirstName", "LastName", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "89d9349d-7c38-4a4b-8d17-ea81da89cec1", "wilburpimentel09@gmail.com", "Wilbur", "Pimentel", "Belli", "WILBURPIMENTEL09@GMAIL.COM", "PIMENTEL.WB", "AQAAAAIAAYagAAAAEGA5+xklme1JB7x8KrMXs1kk16bfcP6azBsIjFxSoy1+vNDSwHwr3Xmv/jzqNw0nOw==", "09069043375", "5ef9bd4e-7780-4c99-94a0-5b460577a9a2", "pimentel.wb" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "Email", "FirstName", "LastName", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "25720d8c-1657-42f6-88ed-55b79d6e3fef", "alondealexa2021@gmail.com", null, null, null, "ALONDEALEXA2021@GMAIL.COM", "ALYXX1988", "AQAAAAIAAYagAAAAEMSolzltEl5tknfg8jVuOiyUKgqw5VCf21DuxBJ31dWgh5ZMugigJW0EjcxEly4ZXg==", null, "bcdfb095-8f23-4509-b580-603d3279850f", "alyxx1988" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "FirstName", "LastName", "MiddleName", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "cc3e73fc-0b92-4f46-a284-e578fc4e3be8", null, null, null, "REDZ1029", "AQAAAAIAAYagAAAAEHHeTOfYAZAf6wkxk7rltsCNCQMoVrbCcwz/sXl1ixMuHxOnQTfP9Vct0bUyAMqykQ==", null, "9bc99acf-ae7e-475c-8d53-946a7a2b666c", "redz1029" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "Email", "FirstName", "LastName", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "SecurityStamp", "UserName" },
                values: new object[] { "a869afc0-d954-493a-ab0e-74538e0c1377", "CrossVampireNe0@gmail.com", null, null, null, "CROSSVAMPIRENE0@GMAIL.COM", "DARKWIZWIZ", "AQAAAAIAAYagAAAAEJD83MZdZatjxrzVwmpntZFitkhfEAor/UlDGQD1G9VH7/lom5AppuwitpOosfWZbQ==", null, "cdf661f5-749a-445d-b68e-02e7fd0390c5", "darkwizwiz" });
        }
    }
}
