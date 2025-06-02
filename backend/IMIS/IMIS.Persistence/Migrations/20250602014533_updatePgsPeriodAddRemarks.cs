using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class updatePgsPeriodAddRemarks : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Remarks",
                table: "PgsPeriod",
                type: "nvarchar(max)",
                nullable: true);

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
                column: "ConcurrencyStamp",
                value: "f2a435c5-5086-47dd-a08f-baddd6b5d5a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "f2699a74-515e-451b-a16e-6e3105445ddc");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Remarks",
                table: "PgsPeriod");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "5c6901a4-56b8-454c-9755-d2eb76785c5c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "5636cfec-335e-467e-9ed3-ef0b6595c27f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "73c5c546-9cf9-48c9-bf20-7d47aff4ae9c");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "925378de-58ec-4fe5-a134-2b0bd58ca4e9", "AQAAAAIAAYagAAAAEOY26+2SG4DVCEyGmFB8sKN/HVs8hWT7+NQ0UBVmv2Pk/cqiNbddVohEkEfI7PY9Bg==", "7f9f09fa-5811-4ad6-abdb-79dac30ed7b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27a08199-67a5-44df-b4f0-a560df1ec790", "AQAAAAIAAYagAAAAEB4SLF88slsmHG44GYNPHkJ5eznFHfatHY1pKS4nljcbZtae0RNaxGz5/XkNRTsrkg==", "8bc07c16-83b4-4a66-b9e6-fbce4ff50627" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6e312d5-ad32-4f29-890f-5d0f29223d84", "AQAAAAIAAYagAAAAEGBJMYfLtGdIdlLUwsMZ8dHl9hZO9W81mdTFhu/IoUJmEu71V5rX+obroMVtB2/CgQ==", "59f7bf5b-6c86-4d89-b6f4-46ec101aedc3" });
        }
    }
}
