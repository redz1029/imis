using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddOfficeIdinPGS : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "38564aab-7024-44e4-96c1-0c7f87abaab7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "b9e0879b-fbef-4602-98f0-4be40fcda952");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "2ad04573-4f88-42d0-8165-5096efb6292d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c507e35-d95f-4ecb-b9d7-30d497bd5f63", "AQAAAAIAAYagAAAAECpHQuYUqnkXlS3LaVfwX8MC6GTEhIBcNrJuI+ObIb31uhSJvKUG1EJWcUSZdWvy+A==", "f95a3d40-699f-4a7a-b4b3-75d6719c81c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82cdf88c-fa79-4abe-97d5-4c8cea88c7f7", "AQAAAAIAAYagAAAAECgtdBCXEQl/1XX6HA0nnFTDQp3nEhjglvulHQm5EV7Jo3JqESEP42E87xE/ruENJg==", "532cf7a2-71dc-4140-87ef-5d141e76b636" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6174824e-9017-478e-aed4-dcc324eb87ca", "AQAAAAIAAYagAAAAEEJI3IPytqC4t4EyJsLBdO1LB8D1NcXSCWawOHrlECSSoBNYsFIcQ7BPD5wb2qjlAg==", "de808cb1-e45f-4fff-9aea-ea52cce9441e" });

            migrationBuilder.CreateIndex(
                name: "IX_UserOffices_OfficeId",
                table: "UserOffices",
                column: "OfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserOffices_Offices_OfficeId",
                table: "UserOffices");

            migrationBuilder.DropIndex(
                name: "IX_UserOffices_OfficeId",
                table: "UserOffices");

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
    }
}
