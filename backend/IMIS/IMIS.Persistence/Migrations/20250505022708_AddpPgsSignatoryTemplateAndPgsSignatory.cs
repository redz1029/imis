using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddpPgsSignatoryTemplateAndPgsSignatory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsSignatoryTemplate",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SignatoryLabel = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OrderLevel = table.Column<int>(type: "int", nullable: false),
                    DefaultSignatoryId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsSignatoryTemplate", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsSignatoryTemplate_AspNetUsers_DefaultSignatoryId",
                        column: x => x.DefaultSignatoryId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "PgsSignatory",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsId = table.Column<long>(type: "bigint", nullable: false),
                    PgsSignatoryTemplateId = table.Column<int>(type: "int", nullable: false),
                    SignatoryId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    DateSigned = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsSignatory", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsSignatory_AspNetUsers_SignatoryId",
                        column: x => x.SignatoryId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PgsSignatory_PerformanceGovernanceSystem_PgsId",
                        column: x => x.PgsId,
                        principalTable: "PerformanceGovernanceSystem",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PgsSignatory_PgsSignatoryTemplate_PgsSignatoryTemplateId",
                        column: x => x.PgsSignatoryTemplateId,
                        principalTable: "PgsSignatoryTemplate",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

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

            migrationBuilder.CreateIndex(
                name: "IX_PgsSignatory_PgsId",
                table: "PgsSignatory",
                column: "PgsId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsSignatory_PgsSignatoryTemplateId",
                table: "PgsSignatory",
                column: "PgsSignatoryTemplateId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsSignatory_SignatoryId",
                table: "PgsSignatory",
                column: "SignatoryId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsSignatoryTemplate_DefaultSignatoryId",
                table: "PgsSignatoryTemplate",
                column: "DefaultSignatoryId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsSignatory");

            migrationBuilder.DropTable(
                name: "PgsSignatoryTemplate");

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
        }
    }
}
