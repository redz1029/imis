using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addDisApprovedAndDisApprovedRemarks : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DisapprovalRemarks",
                table: "Deliverable",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDisapproved",
                table: "Deliverable",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f9484918-d02a-457c-a802-9b56403a4fa3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "8cc8865f-d91e-4baf-8f8b-414b70d7f384");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "f18b12d1-6793-40a1-9951-7d7926f5d8a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "115d27c4-e522-4404-b98d-80ec892729ed");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a7ff127-f2d6-40a9-a3a4-a88e31f84d63", "AQAAAAIAAYagAAAAENR0Irp8+1B+IBvzu5sGxN+CaMyMCtHzbgtkgUyYBxAsDn+w9LuHZcOAu1Cw/E9kiw==", "4a75c403-4dcb-484c-b6cd-a2be66fe044a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c55b43c8-9694-4384-b9cc-0ad910ae43f6", "AQAAAAIAAYagAAAAEF4SWPXlJu+zOH02/+gJLw0aaN+GH9BjV8/0ALc8h6JSiiTX/2kp7tPwKZFABTDxmg==", "9ba07d52-1c80-4379-9724-01849d26d5a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6a2bc2c-aca9-4e8c-865a-6c8bb5fef6f9", "AQAAAAIAAYagAAAAENZcnUCQ2dtSY/D2mjMOzrpDP3bIzN/agS/vEGGlihZpoa7HxxLqCc6OQwW+GbntKg==", "6c189bfc-753e-4cc8-86d1-ab6724464472" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DisapprovalRemarks",
                table: "Deliverable");

            migrationBuilder.DropColumn(
                name: "IsDisapproved",
                table: "Deliverable");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d7da037b-ab9f-4f98-84a4-7d0079a3df0b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "205ea5a4-1708-4c31-9d5c-ada866cb2c4a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "324630b8-3833-4298-b42d-7ec4c11063b6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "21dd1934-6c36-431c-8b5c-79265c6447fc");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7879e496-2548-495d-9652-c26309b30d8a", "AQAAAAIAAYagAAAAEPrKs7IMN12/lV5p6ybP9GlkTTOmmlexDlKmNyDj8badLqZ9JLabo6vVMb+EU/iFFg==", "ed8ab9ae-1ac2-4f17-8400-8c29936d228b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa2377f5-15cd-4d72-9d28-4de159a03847", "AQAAAAIAAYagAAAAEN61JwylqcI82aLBTgMdQyqwpsNRIktgf3QlRN663w7YVKgl+AGVRmNOjFZRDs9uaw==", "132ae571-1a18-4de9-8fdb-5076e7231759" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9aefb81-c46b-4d9b-b943-6b1a6b1bc1ac", "AQAAAAIAAYagAAAAEJ3zUVpRJCLBpBQk2pg2HbRhHPcknxmSS2LpB3e8E8yVv1exwQObDGiezTwoEyCZKA==", "8f7a4cc2-1af3-4124-8b4a-5e747fca0a5f" });
        }
    }
}
