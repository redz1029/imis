using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class ChangeAuditorTeamsPrimaryKey : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams");

            migrationBuilder.AlterColumn<int>(
                name: "AuditorId",
                table: "AuditorTeams",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "AuditorTeams",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AuditorTeams",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<byte[]>(
                name: "RowVersion",
                table: "AuditorTeams",
                type: "rowversion",
                rowVersion: true,
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "1322a11d-47bd-43ca-85d5-79f4cfa124d7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "3d866dd1-33d2-44be-bc4c-33edae33450d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "0ff3a959-a5c6-4cfb-96eb-a6258488d8e9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a1c66729-63ec-4d7b-9d9a-4685b4edb1aa");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b0fd635-400b-4643-89c0-9852cca41699", "AQAAAAIAAYagAAAAEKUvv/5HUHC5fQMfxC34qEwHbYE3vUBPOXMPLFr1z6TVk4P1e26LOqTfIn8EZrPGBg==", "466a7cd2-f65c-401d-a1f9-07d61428e8a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98005603-392a-41f5-a1f6-a56310825e42", "AQAAAAIAAYagAAAAEI0wi6sGpz8rwVJxkD5goIhIciI5kUc15XWVGGn9+z/hMk7/OXmb2Y6JNOBdp0xlaQ==", "52a6bd32-8137-4915-953f-dbbdb50bc4e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9754ce4-736c-4f7d-ae4b-b8cd364689ed", "AQAAAAIAAYagAAAAEMFeSVhWl0Fc8VU5ibhLdR/+qzQVpnfD+7RNOc7RULuJ5PK2IB8JOO/5eNq5SLw3eQ==", "862dd5ee-4bfc-4ac1-9cfa-270ba628bbf2" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditorTeams_AuditorId_TeamId",
                table: "AuditorTeams",
                columns: new[] { "AuditorId", "TeamId" },
                unique: true,
                filter: "[AuditorId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams",
                column: "AuditorId",
                principalTable: "Auditors",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams");

            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams");

            migrationBuilder.DropIndex(
                name: "IX_AuditorTeams_AuditorId_TeamId",
                table: "AuditorTeams");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "AuditorTeams");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AuditorTeams");

            migrationBuilder.DropColumn(
                name: "RowVersion",
                table: "AuditorTeams");

            migrationBuilder.AlterColumn<int>(
                name: "AuditorId",
                table: "AuditorTeams",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditorTeams",
                table: "AuditorTeams",
                columns: new[] { "AuditorId", "TeamId" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "bc27cb6c-9564-44e8-b6a1-abedbe663803");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "87fb1a40-448b-4a3a-8170-4b166be93182");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a03604a8-ad6e-47ef-89e7-d5731770409b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "fa86447e-c8bd-4f4a-8fc5-55c70127cd19");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50747c16-f270-4dcd-ab95-dfd29a05bdee", "AQAAAAIAAYagAAAAECjt50vHfu7mA0LpPz6yecGvOvjyXu5fwWDkACSeNQc8AicI6rOOtMEay2zB0QYIHw==", "95760211-4ce1-4002-99b8-4c04a40843d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0efa3e0d-90ee-4409-8f48-f05774e2b9e0", "AQAAAAIAAYagAAAAED2+gt0suo80SdLT7Xo+EJNI0MLT2rgeTtCFqq/TjRTCBCWbqKTTS/+soiLDT+QloQ==", "554e7e56-7d25-4c0f-a30a-7323e81030e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30f992c6-927c-4805-a1b1-cde046a4ddbb", "AQAAAAIAAYagAAAAEBkmpwG5UdewvjMdC9XWZnE25T/X13LmpM9suvbzl4cOdiNNcF0xkuyUKigI/HbNHA==", "1f6bc2fb-fd5f-4a81-8bee-d623758dd18f" });

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorTeams_Auditors_AuditorId",
                table: "AuditorTeams",
                column: "AuditorId",
                principalTable: "Auditors",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
