using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPrimaryKeyIdForAuditorOffices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditorOffices",
                table: "AuditorOffices");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "AuditorOffices",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AuditorOffices",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<byte[]>(
                name: "RowVersion",
                table: "AuditorOffices",
                type: "rowversion",
                rowVersion: true,
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditorOffices",
                table: "AuditorOffices",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "40012e96-55c6-4dba-901b-40c50991e18b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "ea8a5461-30b8-4b33-803c-08c601168aec");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b30468e5-537e-44d5-9c27-cc6d1a2c022e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "76d5aea9-9056-4131-bd61-e271f06fe7fc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e358ff6b-e3af-419e-8fc2-31a872147213");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "a4d92d40-3d83-4ca6-98c5-e32acb073116");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "be1f7b52-f2a5-4b87-b8b3-f9058c686a17");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "aeb38fe7-2794-4c88-81b4-52f60d9cc542");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3bf2ec8-faff-41f7-b93c-09be789bbd30", "AQAAAAIAAYagAAAAEImeUvdoocYWhjQkJNzhMuHUiQckWQvxhIBROUd9EOKivJbKxn9WTQs/qT3L7HMgoQ==", "89421508-3114-463c-aa11-912512872b96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0215289e-2d58-4cd5-a6ab-c57f11b05a85", "AQAAAAIAAYagAAAAECoXcG14AwmsJbdiaASgIUOJRPHGpYlVT4OVxkcNtS36J6EO2H20sIi4ymembA2Z+w==", "32c432b2-ce11-4322-8cd5-361de15cc74f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01aa752e-99c1-4134-83b1-7939a93019af", "AQAAAAIAAYagAAAAEMB2Jq7QMTGjODdXFkbnBgL0ByfVNT/4/2sP2tknyaJYzJ18FIkn7WIXBz/Fiesj9w==", "0eff7506-1bbe-45b9-9d9e-a2cc79d33c39" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices",
                columns: new[] { "AuditorId", "OfficeId", "PgsPeriodId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_AuditorOffices",
                table: "AuditorOffices");

            migrationBuilder.DropIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "AuditorOffices");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AuditorOffices");

            migrationBuilder.DropColumn(
                name: "RowVersion",
                table: "AuditorOffices");

            migrationBuilder.AddPrimaryKey(
                name: "PK_AuditorOffices",
                table: "AuditorOffices",
                columns: new[] { "AuditorId", "OfficeId" });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "a3e44b30-feed-494a-a94f-e230ba4a4258");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "d256ee88-31db-46ab-a2a1-f4def68eb83f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "15ac88b2-4763-4127-b489-d237aa812cdf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "ed5c871e-5737-4d76-9b63-1562d32122b1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b20624d2-f17d-4de0-97f6-2082d6fae5b0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "ece9fc78-8b8c-4787-9fd8-285d41cdedf6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "f31cc8ca-70e0-4645-95a1-5824e563e917");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "02c0c5dd-49e3-45d6-af06-3ada89d49086");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "656406e2-4446-4553-9bc3-50cd705e9005", "AQAAAAIAAYagAAAAEH2i5pN9hSedZRDx7PRGL+lfZ+/1rMLBvUxexLcHEWf0KZmal7dGwtQ85q0L4svS+Q==", "df066198-2548-4a49-b587-cd5847f12543" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5934b56-4635-43f2-9df5-0c9089aeecdf", "AQAAAAIAAYagAAAAEB4Kb205VevrnexcWlf3in60NAes0hJPXfX8p7FtcMdTgg7JTkmJgOblP2i5hXoLBA==", "98d3abda-6c52-4789-a1b1-c5fa3b5bcf1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76ea1e16-dcb6-4f73-a3f8-ea4afffcef00", "AQAAAAIAAYagAAAAELg+QiYFlYRJWtgCL1TFq7Nb9/+8jmoym9yhoOVIFNwR3B1bTUHOYjzLq/sULw5Nhg==", "6940c0ab-1c42-4a53-8e1e-8ccf7e95eda1" });
        }
    }
}
