using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class addPgsStatusInPGS : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "PgsStatus",
                table: "PerformanceGovernanceSystem",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d1fcb66e-73ff-4e46-8eb9-bbe05f088bfb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "571e8cf3-8f1e-42f5-a0f2-e399462ab75d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "fb26071c-684f-4225-863a-a3afb2d91a61");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f9e81de-eec6-42fc-ae09-0c2bb3333ee7", "AQAAAAIAAYagAAAAEI/hyZiT2Lby/wxTGzOv2rBOG5NJ9zdy/ZK+ZO+0XG/RCyAFNPeu5htjylZx8GgmfQ==", "f52f2585-a7cb-4c43-950c-251437c4d1ff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "623be09f-9165-4e34-91c6-2418ae1a43f6", "AQAAAAIAAYagAAAAEPGUWtUUGv7PuLcxFMrrhYPH2dZeRq30xchsRx6wQphxA4lAmAwzvl0pJ6+KnB+lRA==", "c067f289-5b87-4d52-923f-af707aa3dd00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b0c2d70-751b-4dc8-8cf0-1f4eff2653a8", "AQAAAAIAAYagAAAAEB57iAseyqaCpbs+Oyzo6dbXOxQJHmTVPrQ/AJuL9GmBUj//rJIiKBzNHFUEne1kmg==", "9298175a-97bd-4934-9db9-67dd6500b122" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PgsStatus",
                table: "PerformanceGovernanceSystem");

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
    }
}
