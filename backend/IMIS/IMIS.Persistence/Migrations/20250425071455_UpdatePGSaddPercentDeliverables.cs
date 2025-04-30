using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdatePGSaddPercentDeliverables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "PercentDeliverables",
                table: "PerformanceGovernanceSystem",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "fc148221-ece0-4287-b494-6ad2af68428c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "c321c522-a8fe-4c8a-82fe-c4acae26b7a4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a93867ab-9412-431a-86cc-c585ce1609a0");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c65f45fe-d746-4579-b240-46c09870d0aa", "AQAAAAIAAYagAAAAEDYo7FE9dC5I/oFimewtErN+gF1xq1+BTZuftvr5NZ2g+LBQO52akGBnS6MmRkNkeQ==", "761d1e4c-f85d-457e-8eb2-164d631cda56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8cdc860-e980-40b2-b7f9-4dd0048f3cf5", "AQAAAAIAAYagAAAAEHhJQFgC5W6YN5naOwtu3aFq9Tcd7CGu4lfY3FocsY/yWFSOybI3/1uoX5p8CRtCRg==", "bdf336ce-1ba1-44d8-b7aa-bdab5969562b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a9c6a3a-f5df-4aea-9569-2c2ff0843a09", "AQAAAAIAAYagAAAAEMY92zMqnkVBsqeZoj9Xwei7wZTR2EVEYkb9rb/ilavaGuslM+cLLblO9TjStLMbdQ==", "1ac14aad-52e8-481c-827d-d3a1f81fca48" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PercentDeliverables",
                table: "PerformanceGovernanceSystem");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "4c0f1f1f-a5be-44a9-9f40-b6180a1d13a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "f90249ce-3330-4d75-944f-e41b83b75cdf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "c8b730f7-80ec-45fe-8439-f10727ce6541");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5a7d8e5-81cd-443f-8ee3-5c6d336c3891", "AQAAAAIAAYagAAAAEIeF4dr7I/Kz1+a1+U1RnGpZjxeMjfdLCud7A9tiseREo/qI5nkbk6OknfkWN7VG7Q==", "0e8099d7-0b79-4713-8df7-0915a532e263" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab783957-914b-49a5-8b89-539051b35022", "AQAAAAIAAYagAAAAEF/O4XRS8mCITUC0J1+ztpYKzQWQAl/oi+GljDGlT7DypWi7DEoEwfnGS3U5kRWKOw==", "cfb83ff0-add7-46bf-b6c2-aba6db62ceaa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6aec5276-201e-4d9f-8dcf-22f5a48e78d6", "AQAAAAIAAYagAAAAEBLd5aeg6n+cu0rRWee+MLVjRB8ZvuxmpEore9OqCM1DKDSq5hRoBLyNwjo0Ic3N3g==", "3c89d6fe-f444-46a8-83b3-444a6e702627" });
        }
    }
}
