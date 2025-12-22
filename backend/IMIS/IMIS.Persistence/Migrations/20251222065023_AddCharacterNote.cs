using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddCharacterNote : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_KeyResultArea_KraId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_KraRoadMap_KeyResultArea_KraId",
                table: "KraRoadMap");

            migrationBuilder.DropPrimaryKey(
                name: "PK_KeyResultArea",
                table: "KeyResultArea");

            migrationBuilder.DropColumn(
                name: "StrategicObjective",
                table: "Characters");

            migrationBuilder.RenameTable(
                name: "KeyResultArea",
                newName: "KeyResultAreas");

            migrationBuilder.AddPrimaryKey(
                name: "PK_KeyResultAreas",
                table: "KeyResultAreas",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "CharacterNotes",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CharacterId = table.Column<long>(type: "bigint", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CharacterNotes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CharacterNotes_Characters_CharacterId",
                        column: x => x.CharacterId,
                        principalTable: "Characters",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StrategicObjectives",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Objective = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CharacterId = table.Column<long>(type: "bigint", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StrategicObjectives", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StrategicObjectives_Characters_CharacterId",
                        column: x => x.CharacterId,
                        principalTable: "Characters",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "81d74b60-28e7-4a7e-bba7-b136b7cba3b6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "e846e1e7-168d-4a0b-b112-0b4b1261600d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "27f35b5f-d674-48ff-90a6-b117a4d3dc4a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "afdb4870-a276-4264-8177-e185b7eb2cb4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "23fd5f1f-91c7-40a1-8340-1816152ea3c8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "5be0fd31-0dbd-40af-9610-855cecaf8d50");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "4ae8bb7b-4eb9-4f03-8e04-0e018193ee08");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "9b219c41-ec8c-43df-b6d4-c481bf9833d4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "bff67e8e-019c-4712-899b-637245c56d92");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b54b831b-926b-4464-91f2-5a92e6b51588");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "c99c0b8e-8579-4c52-95bc-422018df6325");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "89652ddc-ddbe-46a1-bc25-4b510771e981");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "ef05472d-7a83-48d9-8f5b-8576e115e5d2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "7ea5fb32-22fe-4a29-a601-34b43b3e5872");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "38073a36-b001-4d8b-a018-a9f924931456");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "3f0ace67-ef6b-4390-a515-1af9a2169e0a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "e4eab8ef-0189-47a2-99a3-ee38738dcc32");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "19f6abcb-9de5-4e78-8cca-13002fa8b6d9");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73ee31f0-e91a-4b2f-9172-5ac4767de829", "AQAAAAIAAYagAAAAEBlz/MtW2HqRyxxPRW7nSf4TR373nzKzLmyIoTxuQpubiO7rsat6vBQibwksTwF9lg==", "06f93bfd-b4b2-4179-be5c-5b317639f819" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8518d550-24fe-4c28-906d-ae3730e76198", "AQAAAAIAAYagAAAAEEUJV8gDMur1TdKA+R42Ir/1uDUqbKNk21dcBta1iL0kZmx7fYgApHMpv/UfTrxH+w==", "eb2dba7b-3821-4b69-9f9b-ff00d8053019" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67374cb6-acd9-4d8c-968d-30830dab01a3", "AQAAAAIAAYagAAAAEC2oVVMsO6eYAJ2hE+4V83EjbHaMoqp2AyiZ/5gqVBICL6S5/pTMvB73LJRmQOGQhw==", "366c6dc4-005d-4d4b-9774-c981e53b5243" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7e9cfd6f-4c5f-4213-be42-d23f8e853291", "AQAAAAIAAYagAAAAEBcPSZojxJFPFTLUCVZ+ep+07mVLbvMHWOrjy+dlWDZB96NoV4AKQDgQJu34Xl/VQA==", "f32898d8-34dd-4887-a390-03621ba25d30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7acc76eb-c739-490e-a5ac-8500026de718", "AQAAAAIAAYagAAAAEIYET8nNcLkYwMqpBHuvZ52wcOKzi4Agt1Li/Kt7M+EyQimvLfZ9QOZaAvfddssAnA==", "fc0e7623-4b3b-4790-abb5-43a2936aa2b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2bdbebe3-24db-4f79-aa56-f891e3d89088", "AQAAAAIAAYagAAAAECVay33W4DNXgMc4r+DoDjYzlJEBB6TF3LvMrix0Dblh7wRZKDt1h9TlcTPp9jJ2Nw==", "755a2bd1-b5a1-4b1d-8595-f624fdec90a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd82238d-95b5-4fbe-903c-00bf4d2d93c0", "AQAAAAIAAYagAAAAEJXme9jxS23pP9U/so3DTvixOpTg2yJqx5BvFkfZpE7LgXK6UZNNOIdL04e1e3bx2w==", "2a2feb03-a4b7-4964-ba00-751646d01673" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e935669-c3b7-41e4-998e-a943e4b720f0", "AQAAAAIAAYagAAAAEH1ApHig7QNbu7VlLfIF4B3ReR8BAYWVmPxIJ7DRQ8aOAr2IRkBy1nV4hloBFcli0g==", "bbacd52d-dfd6-45ab-89e3-9fa8ec40f8f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "05be3dec-92f6-4541-9a14-28b6bc8f8eb9", "AQAAAAIAAYagAAAAEHhwbqYq/6jAzjb8qDlr4yiOvuaAWXMuj+nrHTB5Knub7a6wN7wKceDw+N94c/ymVw==", "95d3107a-849a-4b8f-ab07-1fcb6f6371e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1895d720-9923-4242-9a2c-d018ec47a5d4", "AQAAAAIAAYagAAAAEOOuoQdRGfJyT1axeL6lQl5Ru56JL2Hv14LUhhbBvJRRNalsli3eJtwSkXRJgpTs7w==", "b66a15d1-e523-43f7-b1ba-c63f81e6e620" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3c6a679-e43b-459d-9484-b01f9c72d1f8", "AQAAAAIAAYagAAAAEOk8TUV/ex/A7GAXcpPAgmfHVxtMIgwEtCap2cgvPmNkS/LoIVizwWqI7G25W+CJGQ==", "16e907c0-a594-4cc8-a26f-0e51f52f4454" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e79ce72-86c2-4130-a55f-5766a545676c", "AQAAAAIAAYagAAAAEDlPY2cW9QkP1/W+uEeYzTuj9/8ghr8EILSQpgKP7WQPtRy/sXWRjCaDm6zJoyia6A==", "302a6461-208c-41ee-bb8f-2b7d4abef851" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e3a37e1-8690-4c6a-9f43-70d3cde77671", "AQAAAAIAAYagAAAAEMcfmTuniWMF1ZfwXsmpe0AbtLL3T5dtjSyMXDnTr3AVl/BY/j7YiFXEmFanJI5QFg==", "9ce8abb3-7906-4d63-a8f4-a81296677ddb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f572f50b-6cfd-40a3-a627-86f5aae3f057", "AQAAAAIAAYagAAAAEO2Ti89WuKoQLGUPa+2wwBvHROdpv6PkVSgh8eoz4ffzUpe3gkX+vJd2OfxOM/N6tg==", "bfd3083e-a228-4885-887c-15bebf4e9b8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0983327f-5ddd-45f7-a02b-00827b618d7f", "AQAAAAIAAYagAAAAEEDje3Ow8LCZLV5Iu+593YgjmDqilpOh2GxEO24IV7cgHxwItz5rB56C5mGQvLLhtg==", "41c8b813-5b5b-424f-a11e-b068c6726cce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "baabb7b1-80f0-4f72-bdc2-ef560d0ed1ff", "AQAAAAIAAYagAAAAEN/t7FRJ71Ec0R/g7nuo6KLzac0jIRqFWxvbwmp4FK63Q6OWubWwTtoAtmkNpOrdcg==", "491c0868-bd7e-4562-80b3-a73cf40d0956" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d533f3a6-518c-49e1-a828-7ff14139585b", "AQAAAAIAAYagAAAAEBF2zVlwMWkH6Qta6GSu8ZkITucs2cNxAZ45KtMpP4gVZnmMY1u17TWauBVgzf1kFg==", "6328dc91-6845-4c54-9f89-78529e21c89f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "233cb2ac-8cf4-441f-8ff5-75524fb164a6", "AQAAAAIAAYagAAAAED/Y52xOfrcqRUmh2lpd2d6OJMIHYxf9lD7ZS5xWmyfHbMK0s17zkm0v/9V6FbTHeg==", "d237efb8-da45-4e0a-aa56-34b312085614" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be244a75-e67d-4564-943b-70a187e744f3", "AQAAAAIAAYagAAAAEL6Tp/R/BxjWjBgN2OAIP8JoE4J6yn/M7P5iOVDaom+ZUY0WdkU2ptCCAcvhxZ/dAA==", "5f814274-6957-471a-a50d-7a05d54cb421" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64928e1e-fd3a-493f-b7b2-571a074f065f", "AQAAAAIAAYagAAAAEAjF9QaM3oMIcZXqyZ0H994OBZC09e73qb/rejj1oSybhJIc8jEQPfmY2APCrM1p7Q==", "f24df9ad-c13b-4c41-a58d-4f8cca3d2de4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4398fd84-4a56-4a65-8fc3-1c2d3c957526", "AQAAAAIAAYagAAAAECNkIrzs3b/FrQRaQAeqBfAAC6dncJmPK88v6Xv8dZDTtSXrMLBHZDuuaJOt2aJSvg==", "6122f309-ad94-48d6-8cc3-1c9cd9479c3a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3760208-785a-496d-bfdb-cfe372681d17", "AQAAAAIAAYagAAAAEHoTsJuWbEuLGU947IyeVHQOz7zIbGVpimLlnkBQQgjo8DGudWPNkWonQdqqYXuAlA==", "fbb09ca9-989e-4c68-ae0a-1efb6dc4a5c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "12775d9f-3f5f-4c05-9361-af33c0112167", "AQAAAAIAAYagAAAAEIjOKItAx882J32XgDODe0pploSUHw6ONVD0eXRQmoOm7dO5SZlbqW+VZU5DLIFRQw==", "86825016-f86f-4d70-a2fb-67649811a9bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5626a90c-f172-456d-bfca-745df6524441", "AQAAAAIAAYagAAAAEE6Gj/D6Pndc0z/SfG5vUm4KQz0CFHK7lAp9f8ml3i73uuM3kw9MESRAvivNTxnuew==", "e32a21ba-11dc-43e3-882c-19cb3f76fd50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c41e8f6f-7835-481c-8301-ce8a729c9023", "AQAAAAIAAYagAAAAEGlkHIGitWCUQosDEyAMCWpegBF9VTad1kjol4jyeLKc/PPE1UohR4ofseqJVAjsBw==", "a4597eb3-5504-45a4-8a96-8afb5ff9dd03" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5571a63-a70e-4597-ac88-ec68271efca2", "AQAAAAIAAYagAAAAED+2/4uDzea9oKLfVd86nsDrCrmoz0bE/2tQ+wKcjxZKWikyePq9XtnhATI41YiziQ==", "32c86f61-cdb6-4955-baad-e0a0a83cb02e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f904f6af-f96d-47cc-b49f-0c4a703245b0", "AQAAAAIAAYagAAAAEANclp+hYZxP57ji9N8fY0DjhF45Pi3u0wk9X+uLN7N80W2kdEXA27WvTtXZZOGicw==", "b6510355-1dae-4d23-9406-6f5d82cc94c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b99ebdb-6394-4912-9692-7209fdec9fe8", "AQAAAAIAAYagAAAAEN7M5mFQ8RKd4+LaJp3OFv/i4/z/+WZGsDNuwBxx/IvzTsDvb3Z1IIKkLwJw7srwYg==", "f9311c87-7bd3-40a7-b5af-143ac967862b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "041d6ae6-c8c8-4ef7-abd2-6e8ac969cc68", "AQAAAAIAAYagAAAAEIu4nIOsj1CDfmVZUgXx/wBUN4HjDxzf+wMFh/px1Qz6xn5Qt111DZCWe19SicIXlA==", "660d5536-e988-4ec8-a3ec-3bc2d044fcdf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19bb6407-87f1-475e-af1e-d5848023faa2", "AQAAAAIAAYagAAAAEHlFsmpoap2BkZH22du7h4V64jxbm8Dsr3yOYFZIbYUm1Ky+yfW1bFiAx2dNBo3rmg==", "0663eb4c-3233-49a0-8d20-81a34cdd5eca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3490bb9e-c0cf-488c-9748-dffbc86254bc", "AQAAAAIAAYagAAAAEHgT7CpEbPvC2hkjZjWogv0SsvUmcDMN21fjdIQW51JL1B7BP/suk5deNwdia6mRVw==", "9ad64fee-7fdb-45cb-be30-078c2e2029ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb428e18-a9e1-4452-8245-35802dcafcf9", "AQAAAAIAAYagAAAAEHGmJbj+4cFzLOnn/VXLuZF+rTRh8fKchpdW739XFZOkfJQTi8+X3AmywIZsO+cDog==", "a72f9874-11ba-4bc1-808c-12cd232a55f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "83a99752-a7d7-44b7-b2e3-8493ef16e9a3", "AQAAAAIAAYagAAAAELJ9ZP7GMUP3V3syQIdWxVW8YuUGILRcBTnKZYVmuNXeX3Nu2dHfq7jVALPGq9Fuug==", "d3505202-0339-4e3f-aa49-8f40dd37f366" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b039a672-7991-45bc-bbf2-9e116ef814a2", "AQAAAAIAAYagAAAAEOgCohW99ShLQJROzlIdtDeLQFi0IvcGkYNZElvkCI6GMgKl7RlaL7GyWxTM8p/0ig==", "12f1ed8d-781c-4ac9-af2c-d61d9bbba5b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f40534c-1495-4891-adac-54d94a3c11f7", "AQAAAAIAAYagAAAAEEbUybrowkBaxYXtT6SkdM6Xz7iW9gx9ww7Gow4+zsjl28hbwjSqcqvMBgQ+yMfJtA==", "524206fe-c98f-4595-a8b6-b7e20ed0f232" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6ef8b63-d484-4c66-9bcf-f170786a4e6a", "AQAAAAIAAYagAAAAEBqM+PHRr0v5bmI6J3Wpc0R+NNahE4OmHR/dvvPHcriv6/8gbOHZZUvp1i/XVlEG+g==", "a312a6da-72e7-4939-9344-56045df63aec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea394fb1-6429-4c7e-9842-2b7868a08e79", "AQAAAAIAAYagAAAAEDDr8gYlIb/sGFFVlWO0FZKUaBsKV3jzt+suVTGpToFBj1SjqN6qB6zNROga7lYZhw==", "facacff1-ba7f-423d-8059-49a7fe300700" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9426345a-f6cd-475f-bb59-d3b91321feb4", "AQAAAAIAAYagAAAAEDIO2voomvOAVIxFywf8b9hHXwyi9Jx54hExLfvymvs+ncR0dV0J56xqXyEfV3z7Uw==", "ba6725b5-6bc8-4854-ab90-81e860134e5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f1dcce4-526b-4632-8fac-18d52b75db57", "AQAAAAIAAYagAAAAEBUdE7I2f+i98OutsiNPEvKa4NLqDdjObT4AzpRW40MRtR3TN/33Kw4gyp5Yii//xA==", "5a6884fc-efdf-47ae-907d-48e869fa02a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef020d5b-10f9-4df8-a500-adebe66d246c", "AQAAAAIAAYagAAAAEFXjlQH7wI/WHQZAkoqxYAhDvJDW3Z+tERSR2oSKXB0TPvU2ZHO+MF2gLi7FrcmF0Q==", "32f31b0d-40c5-4dbf-9918-786a00ba592b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f8d7a4f-2c9e-4179-8c43-2aa8c65fa32a", "AQAAAAIAAYagAAAAEE2d9HM0TXVPHfgb6Kfh61/UhoDFsI5ZqTGijaR1DQCmuT7R7flV3F54S6Lky4m2KQ==", "dcc5f5b7-2013-4b22-8f92-b9ae5ff2a1cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e874511f-1b83-463a-8dbe-aeef4845d9cd", "AQAAAAIAAYagAAAAEE+ELD9V7W2fpC/+ZEX2bf7ZK6N3n8EzChcyV4m1SNi0PBj3JTM5IdWH3dDE8Rosjg==", "bfc7b189-1fa0-4214-862f-6651c1c01d54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "41fa15b7-36aa-4172-9289-f0098c38a364", "AQAAAAIAAYagAAAAEJxWjcGh4xv4zRmAzJjdAD/l2+FljbgymzA/gVXP53LT8qbtObaLCHSuYpbJW+EI7A==", "bd7c021d-75b5-4755-88bb-4ace0d05947b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5342c5a7-0ee9-4fad-973e-3a4629ee7449", "AQAAAAIAAYagAAAAEKoX+N8BEE0nkyl2UsUvwyA5kzvVt0N40fq/cJfj9benPSHsiCeXG1zcNyE74HcDiQ==", "2e57513e-4624-4030-b498-42709edbadbb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b50071f5-e27a-4fe8-ad50-2259fc9d93bf", "AQAAAAIAAYagAAAAEEZa4Em5trffwhAUsOS6nLJcX8iyMGih4CSKStj9NVNPtyk2E9PjlYxUp1Ja6ddAxA==", "ac871800-dd1f-4a8b-a520-3b1b1d76fee9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b96b889a-5b26-42f1-b155-bcb00d3fcfce", "AQAAAAIAAYagAAAAEMYUYFfZ2Y81XTaulvUnUZ2WZ4UVIYpv2N/m76YXLFLEAZWRgBIiumo7BSJ88oiacg==", "ed8e45de-bf00-45de-9eca-4530d0256979" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "baf9f0cf-22a1-434e-9bc9-c2ede5adabd9", "AQAAAAIAAYagAAAAEJf255q3TCPkDAbRNvcovhx1H/sbVpBFOm201q+Z89YHUYjVJelrwxytPSWgv6Cn6Q==", "fa445571-f53a-496e-b9da-f8f2feddd815" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d98870e-5ad6-4e44-8408-4c7941f10958", "AQAAAAIAAYagAAAAEJFLd9B9wSQUM5lfi0ZohZp85HjV5+EVcNrIUvyrPxFGryO6sMCRZTcWsG2uL1wWpg==", "eeb3f856-35cc-4ee8-9cb7-15fe9ac2c0a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5ac66c2-584b-4fcd-9b41-2f0e88fc5287", "AQAAAAIAAYagAAAAEA5bqJjl7Ipu1cRyqYFWGvaVuW61TMjhDD5oZ7Vk+6QIRxptjLmx+NNbRI0cXlWdUw==", "d92f330e-e938-473e-b24b-b2f2890e1070" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b7c43d65-93c6-467e-85a9-2a9489a6006b", "AQAAAAIAAYagAAAAEBKy/fTyOBCY37njPaELVcRUeRK2YuqNgUEX9ELtqbLUOv3GzsI+99oLOM/T6FKDWQ==", "462f00b8-5d68-4adc-8b2b-c128b4b09060" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "37c55941-d470-42b3-b0f1-ee80f22efeef", "AQAAAAIAAYagAAAAENJarBPZRyvTCViJVWQBBwvF+Dng96vrAeQ0Zx7gXJnyRyhFnETtQEmlsL97MfJb0g==", "9af62542-bc69-4905-b879-0bc3172e82c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b389cc8-bd53-453c-a219-9209c8c8e93e", "AQAAAAIAAYagAAAAEHgiEbaK0Aq9xFoKJuqVZsweI0stinHYT0gHHCeJqWQGLId+y4SX+T89zydxa8b7QQ==", "d585631a-9878-4ed0-82dc-75c44da8191b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd3fd909-cb14-4c32-8839-a343defc15e6", "AQAAAAIAAYagAAAAEI2Btz/KZF04G9oumccGuaIfjh16a2cVVJee+WjmsY/bRtKNakZR45aRF0yG2u4UUQ==", "858db05d-b9b4-49da-88d7-4408e5995f43" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97950b18-4347-4a97-91ec-d359b8c99555", "AQAAAAIAAYagAAAAECVdI5HJrEscDOooCpoQpNeAvSUSAV5/Y8Eloaq16kgTXDXEWJcFoVV3jgbocfzqqw==", "91cf2880-f718-4185-ad8f-dfadb8fb22f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c6ef53c-98e9-42cc-867e-848926b4f1fe", "AQAAAAIAAYagAAAAEATRBd2vOTANFBL/OeEXr3k/0AKj0IjTOqaSfnPxr8FvsaRMjDcLhP+8aox8dKQfnQ==", "cf72909c-905d-4238-878f-04969fc17fe9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "615dec07-0593-40a6-b6ab-1b33e83ab3a3", "AQAAAAIAAYagAAAAENR0J93Cy88jJ7QPHv4xBmbPpY3ZX26wBoueThBBiY6S/px5my8AsJNGgmfsfjYzsg==", "c90eefbe-ad99-498d-b773-7e98276265e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c11f73c-b2b5-46ed-969d-af3174bd7eac", "AQAAAAIAAYagAAAAEHCYRlEeK5ODrFOgr/iE98xT8QbAxRRSP9YRz4p/tTgPqZnny7GKYD36MOpWDCR/Bg==", "28abaf1f-c173-42bb-8ce9-fa6cbca8d0a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4359ef26-b61b-466d-9f3a-73f436f645ec", "AQAAAAIAAYagAAAAED9mfL2YEPCo8k6+SOjjXPr295at0qLEpCumkheo6OzjViKUxLT0YIWiMR1reGPB0g==", "1a5a0b69-1fff-4cdb-9150-0456e11a75b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72566c48-8d18-44e0-b380-4922c5010036", "AQAAAAIAAYagAAAAEBZDelsjr9OlfwEOA4ESowVvdeY1RykIl3bXH5/0rzRanupq0xq0lfP5BioVdmc1Lw==", "66cb50d6-81aa-4c25-ad42-f5dbe97bfd4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "acd53de4-758b-47c2-990a-6e00cfc0fdc7", "AQAAAAIAAYagAAAAENo5MbiuJqN0zKWl+PwpsQ+dTqE1fHxZytFLpIyfGfEEgX7W4A5nMOfXw1cECx/15Q==", "25a5b0d5-e8cb-4baf-84dd-c31d855a6a20" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "39a5e108-d183-4652-8025-383bc57b7514", "AQAAAAIAAYagAAAAEDHHjVggyC5ewpBgFYHE1vRMmU156S/L/ypfEkkZeWY+QiQ1wqI8rLPocxfnrz03Dg==", "a78cb501-7177-4fd7-bd36-2c992c1fcf48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7c60813-a9e7-4786-9102-e755ad557008", "AQAAAAIAAYagAAAAEPvEdvj6n2IZip8erACgiyW+Ci9eQdKQ9fLLmE11d139Ugdml3brZJFYMUav1U8yZw==", "ea1f84c6-93f8-406f-9fa4-e375d6e3a785" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dabd81b1-0e38-4ee4-974c-e2a04d44f28a", "AQAAAAIAAYagAAAAEIID4OKGpsE1scQ5ULIRpYFMR22KkYMgvOdPxgtOJZ8nkgy1O/mlBA8880NQxLsIDQ==", "8f66c829-a08e-48b4-8b16-8902deafd2fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20591dd4-f8d7-47ec-8dba-60d137dfa0ee", "AQAAAAIAAYagAAAAECRnNfKWgEuT0TsOkwDAHM5Ss+15jvlhnnOwaa7R4lfeBXiz5Wfamd9YmiI/Yo5pMQ==", "5a3a3114-bc1b-416e-a8e9-21bec1298225" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f67acd8d-31f7-4b82-bad2-d8eefabec2dc", "AQAAAAIAAYagAAAAELYPQ7sho/3LLtHgliUxSTIeZtJwmOROxmvHzsl+v5BzsBM9vTL7MUOcYNJzEBqt+A==", "6746ab82-569f-4d94-96ef-31c56816aa80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ba17df3-1ce7-4390-b143-7d2d1065c784", "AQAAAAIAAYagAAAAEN9R46ovSBC6KbkqwPKT5HuZ1TdrDUhvsy9RM9RIvZNY1xEESFpwauNLKdKCt30YhQ==", "0df366e3-0f81-4c93-99ed-f98c78b3b101" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b583fd06-f69f-47f0-a666-a2add51fb475", "AQAAAAIAAYagAAAAEOA53jo6daikPVgW06j9JsGNIBsEO9PU40rto/+fzNU9d4wAl/Le9D5hlEMVJSdnbQ==", "6672e0d5-a32c-4fc4-8aa3-7842a800e4b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e19393c-7e63-46ed-b042-fdafce117830", "AQAAAAIAAYagAAAAEJhuc0HOZGpfKDd4rEi983z8exZ1emaAqTJD3JvdHihJxt1pXkFNrhLdFXo1kExApQ==", "e11a8f22-b4e4-40b2-a33b-8039c76cb94f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33d29c10-f20d-457c-bb78-74c5e8b9a304", "AQAAAAIAAYagAAAAEPup6Y/xEcvCyeuRSJUnr3A8Rtdv4Wetmbtapuc0FN5HLiCC7E3nzJ88fJPfTQaQYw==", "5d839aec-df4a-4aa5-9c67-e8dbdd317a24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89b8a69a-97d4-4a01-8c6a-c34fd05c3018", "AQAAAAIAAYagAAAAEKLWieVBcI8fWu7LxvARD629U14Y1lqY+M58XjJrv5A8hP3maoKWmal0qND67h5ykw==", "95c33a1a-aa60-493e-abae-2db9840bb810" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6fc2f43-0ec0-4147-b206-520d9d2c12a3", "AQAAAAIAAYagAAAAENry5AyLLTyflR86CqHXNW4NWXvrVhCr75iplRairgwVnIowz0TJ0NdCqioDx70Sdg==", "38122eb0-a257-4358-9325-8c7428b481e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbc57507-2a17-4785-befd-83813e62df93", "AQAAAAIAAYagAAAAEIuu0uQvA/aB7wrrAstpJ85lFEk0/lIA1isQyvO0hGIs2qzZRG/2bW9zqnWYU3SglA==", "41387a25-fb40-4882-add9-af22514d4f47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78595620-4d85-4a37-9fdf-74c82d8b8dc6", "AQAAAAIAAYagAAAAEFWtZtgJEeegheghX+LL2UMVGpslfDfY+k2jJow4RXvQCC6hNRixK3Tf08df3s3brg==", "be5804c3-9330-4f46-84bd-06b39130af63" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f38cfd0a-1843-4301-861f-f311a929ac96", "AQAAAAIAAYagAAAAEG5GPk7XGSJP5yPuwdaYKJ2+S6zUZCO9BJAWG9wTLOYa1wXDOvKaL1lWyqd0/h58tQ==", "f51f345e-92f7-4b0e-8737-9ccbfd0fb2b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b741cea8-8b72-48b7-8f69-694343e61aec", "AQAAAAIAAYagAAAAEMahdEYjl1wugMZfWxjh6uqYuwQr4eYUr61SpLLfOTJWNCmqonskKhY/CezeTBkn+w==", "16a5f400-05f9-44b7-8bcf-ef58a9eafa40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5ecef1a-0ad0-47b2-94ce-12bcd71b4dec", "AQAAAAIAAYagAAAAEHesz/OPfkRfwapILndw36hMTZR62Ffup8c0dmfZxqMg4i9ADp4GUu4BV8fjPEQCRA==", "43c5466e-f22e-454e-9f09-14341df760c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4ace8cf-7786-4669-97e8-0464ee5a00dc", "AQAAAAIAAYagAAAAEPanwZLE7jURuqvxPrBj0SYA5chI3OGE2QfVaymvVw2tajl2ie8+Qs9wsIHrwr0kkg==", "b436fb3d-b88c-46fd-b300-c2ef2224a8dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09a0d386-5576-431e-a9f4-1e42a36e9491", "AQAAAAIAAYagAAAAEPQa3h+lt1raxctdhFmgMMa97TjjikQGh+WDiVfVNyPVclHDPM09DIgvMsWy6Z6ZJw==", "334f9e5b-6b4d-4e45-a46f-00dd3025ffd6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3d5054a-7460-48aa-9edb-de557ac8e6af", "AQAAAAIAAYagAAAAENy0hRsRlncTGRl/RJgv/9zeQd3K6MLHa/KNNR7ftOgNhIK9gHBY+eEen1Ij50zC4g==", "3280c853-74d7-41ef-9a11-50e563e77297" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cac9554-70f1-4212-8cdc-af54a3c9892a", "AQAAAAIAAYagAAAAEKP3b1adujl7L3w890CcqlBkVnwFV3/R2yOf7mvA8Lv74wlI2fjucdAjo09hhBAKUw==", "0b4c9098-2012-4826-9422-71d9fc559b94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91acc233-53e4-446b-aee6-fce14d47a403", "AQAAAAIAAYagAAAAEEx5gyNJoe+30VeDJhcuwWe5bYTvbHurEWa5UqTUXW0SsMCYhe21lFYZ/VuVEekGPg==", "9faedca2-eca3-44bb-89f2-81dc6d7f6efa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57546a68-1339-449c-8864-d1270590fb7d", "AQAAAAIAAYagAAAAENhAXxu2aK+LdxkqQtRActiSRzlkbPpIXRHqFeXw1rbTQMjnbBR4Q4PAHHRMdWhk0Q==", "7aef3dca-1dd0-4523-815c-19c4277f0cee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7dcee31a-17a9-4c5c-abe0-56bb7038b012", "AQAAAAIAAYagAAAAEOv6R2INaX5IpNzVlPH+Pkd1htLxANyDcO1+OSqb8XPsFhmmsA040rZ+6NecAmskJA==", "95bd7b2f-7de1-43c2-8a47-0a1ac9ddc513" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b945fae9-2faf-4992-a394-e1d1d2ab1605", "AQAAAAIAAYagAAAAEJxB+DE8wGEknt/SZZSxM0aXiFD+tRMkNgcvLbrIrU7by1qxJLAC9xc+gYJ6criKSQ==", "e28609ae-349c-44cc-97f8-f61e383ebcee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "601fde05-0b47-4737-a9b4-04d9891086bb", "AQAAAAIAAYagAAAAEHFz7WIkpx4i70jIalBhkdn6XlklPobMzhebTqA/8KRoUh74YsyaGnIEv40eHYdIPw==", "a71a6d15-b9f3-4085-bf76-7cd6d79d5410" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33b292b0-90b3-4124-af7e-7f3ff732b268", "AQAAAAIAAYagAAAAEP14auASrY/Nn+HEz+wKdTEoCSGauloaTS4k/iDGwPj0blahI07gMupDtbl0pnM4xw==", "4365a4a8-3212-463f-b5c0-e692de676386" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4411d256-52e5-49f6-ac82-61f58592d462", "AQAAAAIAAYagAAAAEFY6jJbrM1wGQHxc+zHR/EkQoUVWkzzw069bJArhdTA2KTzRN6xBGZ6cxMTUaiAMFQ==", "628234fc-7b6b-40aa-b8f9-9733e849ac8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18e3e4c8-9673-41a2-9c72-e6896af75c80", "AQAAAAIAAYagAAAAEDDMRpWvD6h4+e5NvU0ExX3rT2HZmJeWim+BGAOLMLG5tH3HfMMtAPnWSMdbvgvIGA==", "fabc4a99-dd17-45ca-9219-ba4e34f93428" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "adcb9e6c-a3b1-4664-b20c-90df7cfa0428", "AQAAAAIAAYagAAAAEOLZHpr5wTzFW4ck/CxhPSst+2ID2Wzp8RB1SN0VjPptHks+pHHCMI9IaqlVUSYWHg==", "26c3b9e2-f340-4963-8229-8be9ce1f30be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19bd03f2-3926-4ac9-86ef-17b91aa448e5", "AQAAAAIAAYagAAAAELH+zThUXHcmpVzFNZBiYNXF+/wNipVb1yXPTq1lFJplZLzmUN/Oh74Hn/IA9YX9rg==", "7ca5972d-fb18-47bc-9cbc-c486b15c6be9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63f822ed-f0a4-4006-86ec-a560c8be06a8", "AQAAAAIAAYagAAAAEGqUJr70saYS7CkNQxMpK7Q/k5Zzyvlh/ipcltB/iNql6YAYmMtaSyKY984WqCu5PA==", "728a2bea-03b7-4f19-ad21-2346f873708d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb588170-75e0-4a7d-835f-7556bd97a337", "AQAAAAIAAYagAAAAEBPUqblI66pEKELYpAJo80DWVTTDHRL+FAp40ZyxIuzYmNjxg2rBv5qcrLs7lBNYJw==", "d265d760-e552-496e-9c8a-d9f7cb695822" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ce786f4-5a20-41a2-8acb-8703a0ab839b", "AQAAAAIAAYagAAAAEIcQBTFaTTblVZiYtjqS/2BAWdH+WEE7YlwXP4aH2LkopYUBl1uWqGELalEWczfdjA==", "32436615-a8ad-42cb-8096-5ef4405d783d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b12471eb-8172-4177-ab60-d1e439da2555", "AQAAAAIAAYagAAAAED3yBa8tP3iiT4xRYDUasUyRkAVKQUEmFwYSZql1qw+6cSvTVkuPD/cCp7K/oBr3VQ==", "1d55cfc2-b7ac-4a33-9ad7-52664750327c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b513017-7ff0-42cd-b0ed-183c6ddaf2c3", "AQAAAAIAAYagAAAAEOvPQtZSEuiT+djA8jR97fC02qhSosbQFEYidoBoWgKHX5c+nQNwYLf1PVjBDNj3cA==", "8662d5ed-fedb-4672-af51-c48f6918c561" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f97e6ea-b989-4ef1-be61-3e59e86f66b4", "AQAAAAIAAYagAAAAEPx0DnJRouU00+/eS5nqjQoDQmnFcB2wPWJmdkM5couWp7l68B+Wj3PwbihWtE0Fsg==", "1b5eaf55-eb7e-46d3-bd59-8d114c50a218" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb9a4251-b3ca-4bb6-bb6f-1664fcce98b5", "AQAAAAIAAYagAAAAEOdQdqLNfIZgu+0kG73VtjQrbWolP7iy3IM/6RV+GmDxGPEV4HpHwJYxEXs5aGt9zg==", "bb5478d5-08a6-4f1a-a294-99eff06a64ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec32213e-25ff-4fb7-abe1-8f2785e403d3", "AQAAAAIAAYagAAAAEKarYN9SKhdajcXzPqvzkNNLqZHnpTTIXmDV+cIfbjORDA5w+5rHnH1oKVh07AChpg==", "d35f43a2-0758-42c1-9b35-a4a3417c1365" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "42f2df58-96fc-459a-8628-781b76e6a823", "AQAAAAIAAYagAAAAEMwzi7QpnKtiZweDwOKGRr1Ry1VBxRnVmtdB8odm9nWtCNl19xk+sUdDKy51ZtNMUQ==", "46b34c90-fb3e-4fe9-8309-3eb8814fe9d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3081704d-406e-4734-967e-f4429eb9f873", "AQAAAAIAAYagAAAAEPchE4JapQHGAcxo3yAbRJzAa8ZKP0kVVlTFp0SSgVb88dfvr03S49eunqLc1m210Q==", "f0466977-ba6f-4a92-9de0-d616893f13c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86651d84-3088-4532-824c-83bef864f4ba", "AQAAAAIAAYagAAAAEG7aS3cfBTMPiH3kV/FekCBUyfcsOTxMrp/LHmrmo3Dh7fFJrne8FOLoQkrsgxi5Bw==", "ea6357c8-1e3b-41ee-8904-5602885310dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f61097df-70d8-428d-8f71-76379e031e68", "AQAAAAIAAYagAAAAEFLiFInCSXEelBkeRz/fJpv9yHkQjx2ThGRJBU99JYfHrbuZk3DagjofxKiokY+cig==", "10b0494b-a4ce-4e6d-a3a0-6f1fee90643a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "970bf8ca-1f46-4bf6-9350-7281ea7660c5", "AQAAAAIAAYagAAAAEB5DVTaGTPfcxar3DQ19pSb0CYJtt+/TFTlYjyuHTi/kWg4MqAjqEWQwMcR0MibR6A==", "3084eab8-6452-46b0-8981-f77897ee7c99" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f076d569-ad58-4cc4-a3cb-6bb831fd3869", "AQAAAAIAAYagAAAAEEgxtp4OXBdr51i9RH3cbMn5cOPCDX9TGSrco3opJmein8/O8Xo41w6t/709I9rePA==", "0a4f2b68-6713-4dbc-a1c8-ae81db161dd1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "05f8fb0d-ad63-4179-a992-343e3280c1b8", "AQAAAAIAAYagAAAAEEOnZ6b98CjtlJhWqSdQgXtIy23JSZ/r/uEPV0aFG0uVLYmr25ZyFBYKYLnGyizDAw==", "14ef8460-d4bd-43ee-b413-f0b910f5ffb9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e53b3fe-49a5-43db-9d55-1be864ed656f", "AQAAAAIAAYagAAAAEL/uPnAeaSYJtr/X0jpqsWBW8RRqqb77Hdvvsj+L2AcZyGEVQsXrgMJJVptO/ZgJUQ==", "1e7d1774-37d9-4574-8098-ef0ed1403998" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1f11af8-44e7-49f8-9db7-82b7af4f81be", "AQAAAAIAAYagAAAAENVLmT+rbtPo5dcKw2aHy2uGLqkuAyJx5EHZJ5RMJIZ3PoKrXP8eDLsoDIIpDEDB4w==", "181eb695-616c-4486-b459-1aa8cb1892d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9c4af58-c7e8-43f0-9f71-1b9b4f563f36", "AQAAAAIAAYagAAAAELHiEtcEw195mD9o+uNmK+rJbg8HDjHnpO1lKRWeGZU/bEZVnlxTPq0Sz6E9TAGINw==", "cb8390e4-b904-43a9-bccc-2d8c85f622fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "871eceb5-1a1a-4766-9115-7b254b4760d3", "AQAAAAIAAYagAAAAEFXCcnEdeEFdh57T1dsbJSr9qnBhH8JRUQsPUOsm8ve3FvCi2S4b8o7WhEnhzGOdBQ==", "1ce795d5-407a-4160-b7cf-4abeef3a02c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9955f66e-ca66-4c61-ab47-1aa01035b1e9", "AQAAAAIAAYagAAAAENbckgOksua0Dc+i4It4+kAX0yFEnUylKTAky0geWH47i9Uul6s+gXPqiYs02Kt5gQ==", "c1e21eef-7374-4372-a967-93476bf9259c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "121e049c-1b0b-48f6-926f-55e5836c5c3a", "AQAAAAIAAYagAAAAEFF/aayZyPJ4Nrv1dPfxVeQu34EymDi1ArBX3LBZdwoOQIviGDMwlnVeVj3M/wb0bA==", "4201ad2e-fa80-44ad-a9ae-f32ce28956d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bad8da6-36f2-401c-be7d-23f3771e6b37", "AQAAAAIAAYagAAAAEP/CKc75AErPOXHU0ejdEjVAdSLAy3TwdtlAuz7YtbQT9e41SWG7Z7uFDozs1gmmsQ==", "edf3feab-7349-473b-90e4-28d9c4268fed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b734b2fb-6a03-442b-bf5a-29f74edc1845", "AQAAAAIAAYagAAAAEPBdCtZpHMg3D1xGNPzh/3KU2wnVkM8rD3VP0XxfKk5d6TOTZrsXARjWNccmkRubhw==", "022e3cf8-8d71-4622-a37a-c1cd6a6c8e30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0761cab-30dc-4358-b3c3-d652c9288dc9", "AQAAAAIAAYagAAAAEFM0YtV0s6cvHhjCkdFRwFUK+shQ0p6W98RSzUlBTkJkmtro8BkkWaKvpeWgHG0fpw==", "ce452dff-be4d-46b4-a9d0-2113bc0e5fb2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe5a6dc9-b8b7-4637-9597-9874fe8ce8af", "AQAAAAIAAYagAAAAENdY24H3MYNxSsvjYlZArR2dLFXsrF98lrzE9INbUiOCiGCjTHxied7ASsvbJSNb0Q==", "caf87dba-4d5a-4c00-bad0-74640c73acc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "34042eac-6ea3-4cf6-a078-5749c5dc69b4", "AQAAAAIAAYagAAAAEN0S1sBlizdRL4KfCJj43N65UPJrFpwhRdYnjHd7GWyNgSj6V+CRhs2KqLN6uGxA+Q==", "c8499428-67e4-4e6f-bf3e-a85c3ba8396f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2cd4673-4aed-4e64-b90d-c054a5a3b1d4", "AQAAAAIAAYagAAAAEJQc7XAsgMrGfaJhZ81vLeVN+KswAvr6DVStjPpAOqvNY/2hMBkuT7EGUtb1jwunkg==", "6960784c-f42b-4f03-a559-97e309e05a39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "130312e7-7ffb-47ad-8854-62a3ecc034e5", "AQAAAAIAAYagAAAAEI+a8SwgTUV7H/90kgrnaEda0eTwqsN52T2eohLbSqXeapyCYX5uuOqrs6WJNw4Evg==", "9eb59635-61df-4bf1-b887-dc9f1653c325" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "abc68aec-2693-4dbe-aa35-c74e96b3f702", "AQAAAAIAAYagAAAAEIz7ur0dZemQPc8PWtRqEL/ri71qleRz6I5B+AQxiNs5Jx9M21QSEV0C1fA/x5Kp2Q==", "ac3df759-a709-4675-aa88-d688123d7826" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d6b207c-1cf4-4bbc-999b-4fa4bea793d5", "AQAAAAIAAYagAAAAECbJe8ejXU6Sm/n26mgL+QnNrK40CLOkwiXCgxv1UlgObVtJtcHhyjO07nDQTpuskQ==", "5c614a7f-b02f-4126-a14b-eb3bc2934e8c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "010350a9-5ff5-446f-9047-89dd486306c1", "AQAAAAIAAYagAAAAEOVVUlAoyyzOx0hI/Vkk8KWa5APoJTBlIxXZa5XUoQsI2EWvfKylIzhGnmreIe5PQA==", "6c840377-6b73-4727-b89b-55b420f4c15e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8107ea03-904d-415c-8633-6223b63c178b", "AQAAAAIAAYagAAAAEIzftmnPearHhFnPO+zk352TMyK+btGMxrBH1VYlZJ+RHMQFn10KKoRGu1hJJT+qsw==", "f3a58d81-329f-44a8-8b3f-30c5cfe7c100" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ebf7441-c86f-4020-99f1-2cdac3b3450c", "AQAAAAIAAYagAAAAEEAFNeUMu1ZL8X0l2ZdU1bcOjhC+XkhWzQBfYwrsLEQ2FOKUq2aBJKnoChv/tW51iA==", "78f1e771-533d-4aa3-9330-a3ebe162024b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e9a992c-b9d9-4a74-8986-06feed6358c1", "AQAAAAIAAYagAAAAEEC7MJZIEF7uA549LQiWSiPzpZHs4F28JObEGs/43bvU/wj4H8QJlnmPmLyHw8qr0w==", "a9e9b9a8-efeb-49bf-98b0-5b6fbfdb529d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5712700a-6ecf-474b-944b-1115d5c36678", "AQAAAAIAAYagAAAAEFLg6SUlEpDcWcQTeerRtuSPA/rL1SvQS3QLGIP7Z8LxqOMTFH3/ki9OhkMMn82F8A==", "f845569b-5642-419d-8fb5-5730c2e60217" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f730c3d-1d90-44d6-b817-0a14e613e7ea", "AQAAAAIAAYagAAAAENF0meW3W6B2kgQ2amr6TUAV4LYw9hwOufB/ZlgahTKTpJhwLA8AIvdRUM3DbXwSfg==", "08979907-94d6-45dc-a125-39069b901dcc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7df36de9-582c-417c-b026-82dd4e8493cd", "AQAAAAIAAYagAAAAEBp5pB3Puei0jb80wf1IUACk+MnJIoCczdulwoiPSiREhL+I8nWa7n8LwoF33WyffA==", "b22a0963-46b2-4746-ac29-2049a7b93fec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93c5518b-61ad-46df-90f0-ba42e67b4486", "AQAAAAIAAYagAAAAEA43Aa2WGmKi12xiHYBDro+uAmIp6PfN6EFLP4lM2mPpO01TrBo5GiUF9k+iqHbfJw==", "c785ddcc-a7f5-4d72-acc5-3c98bb4e346c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbbf7f37-4319-479c-8ea9-dd6448d8e91a", "AQAAAAIAAYagAAAAELFyi+cdyJ4LGbk9BoTwY1Rgq42E1Luk7PQthLqJ2o88gj2kzwCf3+E7vrL0X28x/w==", "64453edd-f4d3-4a9c-b612-c87ba15a2551" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d236317d-9f7d-4595-b068-02064673d555", "AQAAAAIAAYagAAAAEGGjRGw/SeSjTT76C3DbqfOODVfq4pRdVA3ObHaSG/H1BFYrtkr4maQg2bWBKxfUFw==", "29d55af3-f397-4fa3-8fa0-bf5d04ed484f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18b21451-f673-483e-a2a9-587931696d39", "AQAAAAIAAYagAAAAEK7GwboqzIzjGlQpWOuOScF1T74IngJ4Q0fhu1NPyMvGF/zwUWGZdjya3SWMi+JehQ==", "ad0f7c39-d543-4c2f-a2c3-6d41018eedbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a042ee8-af5f-4648-83c2-ec84dc406c94", "AQAAAAIAAYagAAAAEKqETT3/wAZIcqtzpWPHEgwcZoj7xW63xVHNwlk1tjxAD8y6tfQI0PNDOQuvBtV8Mg==", "01218f08-e1fc-4147-8f61-fbd9b867a384" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20226445-4bb5-48df-b5a9-97702491544d", "AQAAAAIAAYagAAAAEL/Cpc+8Mf28Ey+sVxGo5RZKxmsIeBmMam3Ejby8H60Vpcrz39ssc4ec/JoqtAFeIw==", "407ac657-a9ac-440e-a131-8cc772207c77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64b5fa62-a05e-4c37-93f2-1622ce265c80", "AQAAAAIAAYagAAAAEJLhOURhr/wYRqWpQItnyTOT8p02rB5wKcGxQKek0kDV5rLmIsNo4FIaPi5/6fLgAQ==", "a438cdda-e338-4c50-8a79-30b7b768e574" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b31f03a1-f5bc-4592-abda-707f4cf5c238", "AQAAAAIAAYagAAAAEJjTPvkaJVYRFiiXcGe6IcQm2jXcaF+L4dhWwIMD2Ii8QQfhr3L3swhrDEAKbZesoA==", "53138154-b23a-4299-9f16-ef5b3fa9cf04" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61639721-9b35-4048-8aa6-8f8b1a2780ad", "AQAAAAIAAYagAAAAEA8FncdNSm26QSx3eNwQz17CnZ179pKEDNMaGdJhCAmuGRNM6eVQx9lu8FKXU0knpg==", "027e0438-6944-4b42-be3a-b8187cdeb1dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2888150-11aa-473a-ac48-8404889fedfc", "AQAAAAIAAYagAAAAENQYSf8OZe1bJzg154dVP8IsXBTzv3Cv+XSrWFT2PFA+q57vzZUd5+9X/JqciSYUIA==", "68cabb2e-5871-4cd7-98df-069fcf489a7e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "90c85fc0-2643-4383-92c3-a673ce7de276", "AQAAAAIAAYagAAAAEGB5Ycw33AQFgiej7kdBholDho/LtANzWx69ZyMxuZy7D6fY0NpSE+L33Io3FfvLIA==", "87993080-6d24-4e87-b5d7-06a768cf80e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f502cef-3a80-41fb-a98f-3fa42cad80f6", "AQAAAAIAAYagAAAAEF3Mzu0YdjS8TC+7oVQ6Zvwtj/p0dvHcoDh6bpoJNlyXaKbXEA00exP7QN1sG8CNpw==", "5810fc9b-5736-4fea-a772-67153d87ee28" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45ad4a81-c6fb-44e9-8903-d3e32967a572", "AQAAAAIAAYagAAAAELgbQpUCgWb3NpRvRGsjmQ9cDfRNwX/DAmqju+lP6fKZIh2Hct6J/axjkWG6M0/EpA==", "26c1f9f2-c79f-49fb-a4a8-aef6b2b5d33e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e467b070-05be-4342-b709-6a6064e17eec", "AQAAAAIAAYagAAAAEJGY/zLxA/+coGKizftzgwFqwHQfBKIwJ52LNBDjT6IAIW80yzdf4Ug0MlqYfFuq0w==", "ea698a34-670d-49ea-8784-287e9eb102f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9816d1ca-1d0f-428d-b4a7-535ce5e2e097", "AQAAAAIAAYagAAAAEGpueef2DObRc/+Y5biry9eq7DtzVnKDhvAVnhgXV843EfX5AtiuYZLv8PVacmuYQA==", "4794b865-b358-420a-8c2c-648b5b3df7e5" });

            migrationBuilder.CreateIndex(
                name: "IX_CharacterNotes_CharacterId",
                table: "CharacterNotes",
                column: "CharacterId");

            migrationBuilder.CreateIndex(
                name: "IX_StrategicObjectives_CharacterId",
                table: "StrategicObjectives",
                column: "CharacterId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_KeyResultAreas_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "KeyResultAreas",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_KraRoadMap_KeyResultAreas_KraId",
                table: "KraRoadMap",
                column: "KraId",
                principalTable: "KeyResultAreas",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deliverable_KeyResultAreas_KraId",
                table: "Deliverable");

            migrationBuilder.DropForeignKey(
                name: "FK_KraRoadMap_KeyResultAreas_KraId",
                table: "KraRoadMap");

            migrationBuilder.DropTable(
                name: "CharacterNotes");

            migrationBuilder.DropTable(
                name: "StrategicObjectives");

            migrationBuilder.DropPrimaryKey(
                name: "PK_KeyResultAreas",
                table: "KeyResultAreas");

            migrationBuilder.RenameTable(
                name: "KeyResultAreas",
                newName: "KeyResultArea");

            migrationBuilder.AddColumn<string>(
                name: "StrategicObjective",
                table: "Characters",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_KeyResultArea",
                table: "KeyResultArea",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "b54b4a93-8abf-4551-8ee6-cacea1ae43ce");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "f550a60d-18c7-4caf-b7f4-68e71001e49c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "6025a0ec-5bab-4a45-b8d3-db001cd959bf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "2616dbd7-ab8c-4aa3-add4-a885095b7782");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "611062c8-472d-4b7a-9e03-4d0a9efe7ce0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "27feff2d-1d23-44ec-b267-0ad219a69d89");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "5a386f26-6200-4389-b821-00a8257e8291");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "c9f5c3d2-c960-464a-81aa-771078abf809");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "6703e08b-17f7-4d16-9fc3-77d3aed3291e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "051c5a4b-7575-4413-ad2b-d15fb893d3a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "ced752f9-b416-4376-8ccb-1ae1ecf15fbb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "ecfa3b5a-7f39-451c-835c-a04db4ec3db6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4223c590-9010-42a9-a52b-b31e21401a21");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "be702c25-da76-4cb4-960b-0aeee79b15d5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "fde660cd-7e48-4cf6-854b-eafa4015dfe7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "b5dc1032-672b-4d85-a7ce-3c604c9c47da");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "b83c3bf0-043e-4a3f-b880-50bf2d3f64d5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "b3ef8712-05a0-4bfd-9576-493ba142dcdb");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a4e53a2-7f6e-4f2a-a94a-be0688148f1d", "AQAAAAIAAYagAAAAEMy6rkhbm3hVJfNuKg3dT/EpXHPmWotKLEJxbikVlrC993ytpYuQy2YNMk/VoXN99g==", "9cc8272d-c2d0-4356-ad0f-5a512b5b4f93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc1c46de-b632-4ce6-91e3-92fbfbf8d63a", "AQAAAAIAAYagAAAAEGceuSGSGqqErnC5vCKDlzeFrdYGU6NFkm7kYBMvCMFY4tB3WCDxR3k9M5J27JlCEA==", "ee281c14-dde9-4ff0-81b0-20e52491e91e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f789b109-576b-49d7-b143-c307e99463a0", "AQAAAAIAAYagAAAAEEZjNSqQ/03ayOcTtsAd9QaPzyeWgluH8r1b8qXGWzxIdoRt+U70hYcA3axinMxInA==", "18080ce1-508d-4597-9453-921f81fe0d41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e393aed-3f1f-447a-a70e-371b0798e6a8", "AQAAAAIAAYagAAAAEJbg1+hHRxoXZPnfh+6uvJfLJ+dEbIkhNp36WZ2zlNpaQGk5vwdcVIa8Z69pJAFTtw==", "96fb3fc6-e134-46d8-8cb4-eb9e02f120e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09043a01-aa39-4315-a251-727db7518835", "AQAAAAIAAYagAAAAEIc/Jxi5+jDwf0k3p7dvDNVaYZe0YbacmrHuxzxUeDPV921FLNw2XVLDbY6Z9pkDJw==", "5f591005-ab53-4d9a-ad00-e29f095ab9da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "740e7bae-11ac-4adb-a0ee-9d05a571cce1", "AQAAAAIAAYagAAAAEPtL5WIa92LwJAYxBvojyyuZqVJjnhtJc5tPP2adQMnd+jbR8cnw28XYD0ANXE1h8Q==", "b5ecda48-89e3-4d48-8c2e-d9e70095d4e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "102866ea-f1a3-4b41-886f-521485d72ab7", "AQAAAAIAAYagAAAAEGKSU9xvsVt5KRAgpYg1+r6Pa4fyvgtFnKZmZjoTERfVAJ+/WlEO9Z1u3E3YVLleCQ==", "3f1456b7-b38a-41a7-af9a-1c279bfe383f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a77d699-37a5-4cbb-a23f-572cac9ad2e9", "AQAAAAIAAYagAAAAEFFLsfgLguXra9BwFWbJEPRXwCFm/Ugu+cz6O38C03J7kp2gkQ7vkj+cg6LVVGYMTQ==", "3a8fd96c-97b3-49e6-8500-ddec83171694" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "479779b1-b5c6-4c25-a2e7-c35c62ad1d51", "AQAAAAIAAYagAAAAEJN7FiSyS/uZuNGbeGHPmjDAfT9ZZWWXHRsSZx8FuhKS0hmpqhGbDgL7PaB0jlC0qw==", "1abaed57-49ff-47ca-a24c-7f73bd9f4b8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8205e6d4-ad67-462e-a62d-0693af47cd53", "AQAAAAIAAYagAAAAEI/JKwq4ZV5gBZ8byrOruyuTrqZyz5rsU1ZiQteK+xNhmmyoBsccCHWFc5rvdFnB0A==", "868f5215-dc8d-47fa-a7c8-d8278a57451e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99bdb972-bfce-4901-a02b-e4d039570083", "AQAAAAIAAYagAAAAEO5OmJ4PTJT3dDEYFJ/8SjQdX6sQeNEAYqG+1RepQbDSZ5xV7tsR5vUmtKmRsAh8Rw==", "2114543f-0f96-49ef-b59b-d6409523fb78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1448e233-876a-4a9d-bf3c-60230e23cd91", "AQAAAAIAAYagAAAAEDvq4HZEQGJEwmJ4hm5rY692C8g3TUmGlIFzVOQyGY48lZyvYoGe36PFoIXR2W/pIw==", "b1dab013-0019-4499-b102-6af656453f08" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0621149f-b450-4fd9-9495-1c868e7b51be", "AQAAAAIAAYagAAAAEHF1FanNlTzyEzlj50ddGr5J3Wb/2UV7pXwPBR+qQDpaOfgB5cvlgsU/lQ2ZcLC2pA==", "191334a4-c75f-4e02-bbf7-61f96e0eab17" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3eae4f25-b46b-4091-b592-850263dfeb36", "AQAAAAIAAYagAAAAEDhPbTkFvHoY82nsvaHz5mkc4UsayU343pvcGFnpMnVmyO+S7sKqlRV6TNQ8BiLYgQ==", "54312928-6d1f-49b1-ad28-5bb7b4a39a93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb9d8f27-077b-495d-a9ec-a983543d6e93", "AQAAAAIAAYagAAAAEKqRS4qAqlO+B18wgLW72Fdfs7hrLcEYUDP9vHOla5MRwM3ffauI9lpfmip35Nxoig==", "5ec3f5aa-68fb-4162-ae75-c649ef011b6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a98cbf54-9b69-4256-bafe-a1020157b490", "AQAAAAIAAYagAAAAECXwIgFhIFIV2HaZsRUqrmtzH8R4iC0tiV5wz3fZPoczVllLhcexqXIJAc5cHBs3ew==", "d98dd147-f5f7-42a1-bf9f-7a0f4d7f8780" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07a5a740-33f6-4f64-8738-f47bef366541", "AQAAAAIAAYagAAAAEPMoCeFe+9NgT9SGElrQPVp1z1Nu9/hRHe3xwg4bJGX1E7zhoS83E0U5AcvKrLH+5g==", "33e4ee5d-373b-425f-8f25-e826cfb81202" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "402e2273-f6e8-4600-8284-d560598f136c", "AQAAAAIAAYagAAAAEHAvkT9yX9+ee+6N2/HcjoAJBIrVmi8QF9QQMXms5JR2Ji0vuhOXO4ckdwsa/VqEBw==", "5db5922a-5dfd-455d-ae72-de41988564cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6bd15fe-eeb3-4c66-abf1-38ecd36863c8", "AQAAAAIAAYagAAAAEECkSsHOyY16wU3i1roK/mBZDj/8JFy9j6cyfKo2jTvGZSd7Yc87Myb423/shb4AiQ==", "63330b26-e9b8-4766-a84c-4cbbd12ed584" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b192b384-28c3-45a8-b020-8a2dee5c7a03", "AQAAAAIAAYagAAAAEC+Hu6DP6aEsRIn1H33n7uU2IYtGCfzAUsSz54nsgc5kNYcrpTo+sJV+LsiE9qxhTQ==", "1e3a8c7d-ef64-4d4c-bcbe-17983e798e78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "680222a4-fab5-4cae-8564-67e3e0c6874a", "AQAAAAIAAYagAAAAEMY3PhNsRsK9wYE/aRo3cS1WWCKLbbt8d097J3bLgVKD4P52wsaGECeh5lNdEJcNyg==", "344a868b-66aa-4e48-ab64-b96d5629555f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef1866f4-cb7e-4e72-a91e-fab225f84f5d", "AQAAAAIAAYagAAAAEDkIgORjhDuv1TzBUBQar8Yvdx3+Eul2QpxZPA1xBOXM+G4p/PmKpl340loLooLfqw==", "7014ed00-1779-4416-8011-bcb7272e8875" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a64de1d8-4521-4d11-aa7f-484f4c5e6317", "AQAAAAIAAYagAAAAEOHRPjiph+RwDGuznfBe9xxzMmLjEDFSFPHZ0JFAksxkj1ndL+9Z9A5G0wLXmlE+CA==", "cf425e6e-6157-4bcd-8dfe-51fc0887d144" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02c0d4e2-d824-4e54-9fab-1001b2b9f297", "AQAAAAIAAYagAAAAEMk1Vy5vxg74o8q/NDjhE8ehydVeHXTBCOaq2vcDeaUdVgx+ieXNrHxJC8DBALMabw==", "f5a63ccd-4222-4785-bf0f-60269856a569" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff9b1191-5c57-4b83-9221-6daa148436d0", "AQAAAAIAAYagAAAAEIPj3KKEAoUJLBmLFZO9Pg9ezHuFYyjB1fu6E2K+hzfunLyKKXUiT/Oq1WkfmmO+JA==", "2dc6ab3b-05e4-4119-88b1-02ad83cdfd81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96b504e6-ab91-46a4-a853-c5a6a556988d", "AQAAAAIAAYagAAAAEMKPg7XU3Md+DhSTA63jskNy3r2IJ2WEoTBLcUHQFX28azEcIFPlf51LKQlgL8rpPA==", "73c9083f-507d-4969-aa35-acf9edf02dfa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "edc1675c-77e5-4386-a089-735f2c078ab6", "AQAAAAIAAYagAAAAEDzjqJIDfItv5sZ1R7mWaQ0UTkroGOZxRwwAp3RZAECbSX/elfg7NeqbtZJPNsRtPQ==", "5932ba4b-37a9-48e9-a63a-ec2a34bfa509" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35f3aa22-dd4c-4c83-902c-0fd7ef80559d", "AQAAAAIAAYagAAAAECNeY0ute9Pvmivywquohp9F1n/WCej5snGm6eGd6bl0U07O5+vR8/9xijp6y8fv/g==", "4d372448-5f5f-485f-9565-64165c41be66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e472699d-1ba7-4964-bb66-42b114c76b63", "AQAAAAIAAYagAAAAENKA5HX9ZTXvYByCKVlwhQvDbEpD3V0Y3Bop7VqxrAACKm7q1FRiqt7oVhFgHQmaXA==", "684ecf84-3690-4368-8f52-d86497ae6b85" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e3418ec-45c6-4390-a474-211105d0e5f9", "AQAAAAIAAYagAAAAECnpfm3y00c67UpbtI1Gh+F7K+UiYqaOJ4nfuOc/cWptCOR84NbUHdc5uMFPc/eajA==", "23421b19-ef48-4aaf-871e-10a7f99274ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed517976-0427-4909-9b31-734016c39330", "AQAAAAIAAYagAAAAEL24ouqpDox/a5IyMIv3TMr9C00J0+eHtMPulj7hVKNzmnjwqrtRCgS23/Bet5aEdg==", "44eee66c-16fe-41ae-a44b-fa8671c6d83d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28c1b979-7ba5-4d87-908f-2826641c6e09", "AQAAAAIAAYagAAAAEOi1fhqYneF+IiBrifZf3Ie1yR4jPcUKe/wF490dLydvH4ttWh7z5IH1iqqEn+4cMQ==", "d4f84c88-5f90-4a0c-9fa7-6f377ddc53fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbb7e726-daed-4540-bfa7-ea37512adb26", "AQAAAAIAAYagAAAAEF6MLblkG4WeXzRtHpfEN5zaqYw4gG3bmfS9TK/LStPla+lzKXeSHSGQ8GLI59sSow==", "b13557d2-f69c-4b58-be7f-7b9e7e80fc85" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4fbddebf-4b1f-4fe7-a53d-7db48324a665", "AQAAAAIAAYagAAAAEMBsx3LgY85DzBVWkC9kDdJmeEJNpC5lQiDhEE3xvlkInBVE2ZQ5BYS8YaNVB1DHpg==", "49e61c4d-8fd7-47ca-9d96-0c0849c36888" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0fd0d59e-7706-4dbe-ba55-bc0b51bad576", "AQAAAAIAAYagAAAAEIPwjuZj1ZjrndpPkSfXdyrqOzcKo950xhHZT+e529gR9dQFRkNc0VR+qJhQauqlug==", "825ce1c5-652e-4194-88c9-15d2c56bd203" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cacae71b-514f-415e-8470-2e3bb4581b8c", "AQAAAAIAAYagAAAAEFVMr2ByEHauA3e7vR9mF9dSxN0NXRcVq+A+tDnKOcOXrGBsgks83NZns4Wf0PTmAw==", "00627618-a6e2-4689-a3d7-2793144a6986" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f01f8e42-6740-4ccb-b6cf-23eb11804145", "AQAAAAIAAYagAAAAEP8T7fCXEHOa1O4+MP6MrD/yQ0WV5MQzdT974YA8L+GxMDxUtYhaEKvkvXUxI59Xyg==", "3cfc1e02-8525-47a7-bba4-3c603b78592c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61176f6e-b162-4e0b-a627-0268b7983d42", "AQAAAAIAAYagAAAAEPF3Kiv9rB+0Jy4uIjM/l7dmQWakn6oU0VSJtBkaf67S2LuPtDnGkJDu+KqHRoBkGQ==", "e8a58a88-4857-4567-87bb-a9cb23f8b828" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7e8d6f2-684a-4e4c-9cba-8d6a85d86c58", "AQAAAAIAAYagAAAAENZdS2kRmwNeo4O7sW8osjWJB0ic89oRZ7pewkmm7g36D80saxTg6FYR0+p7wHQFlw==", "6efcb475-8c5b-4ec5-9bf5-be670ba2a572" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b02c4fd-52ea-4fc2-b9b1-978c8241deb2", "AQAAAAIAAYagAAAAEOy9Y1a8JBU8eSD7NszrqtgB9vV+CEv7QIlkgVUoIzF9RSDm8MYSucJH5NZscJKPhA==", "ca9b7193-5c37-45d2-baf5-a3f1e70e2c81" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88cffad3-5d25-44ef-a615-9e0cc59a02b1", "AQAAAAIAAYagAAAAEBR8mYp8QHZGzjYBGYYp1Bt4KxPMT3RPkKNasZ3k/mZU68Wps3kYGZ8kTTSQlNxZ0g==", "8f84fe4f-855a-4529-86b5-56c9bed59f74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "913ff357-1e8e-4cb0-9c6b-aee51058094c", "AQAAAAIAAYagAAAAEMmcwf1LzCvUPogOtXM4kB0UK+v0CKdf/MU/56pZY8OERYHgLN+3z91VvYadBqNTLg==", "e62d4330-58d3-467d-985f-765e475554c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9d64f324-57ce-4594-a454-24d0279c34c8", "AQAAAAIAAYagAAAAEDbiVXS+3tEuI/xR5nqwBiyLoxBj/54HVUwF9OdU3qoAlra5KBWRY9zGMQmuMcM3pg==", "519e9140-1580-401a-a9df-9fdd406cf978" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b5fd57a-8674-4ac1-b5c1-abd3d3f7bf50", "AQAAAAIAAYagAAAAEHhOsDjumxhbJNnQPKjbIAXFWvSAnrjPLvP5RKkDtMFDsJOXKPtREqZpXpty7JU7Qg==", "fc18b06b-e28a-4e64-a0f9-00f8e2836808" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b3ee99b-3adc-40ee-9222-f7d03e3339f6", "AQAAAAIAAYagAAAAEOZN0oR+nnwc3JPn+a8PQrOQ+PzfxHlcnw25d9DFopj+Ff+q5eYj77vxGQOuzKzBpg==", "b846008e-4dc5-4095-a274-92e044e957d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74bf0484-a98b-4fa2-84b1-9f905eaf4c43", "AQAAAAIAAYagAAAAEBmhvDdHyvX+iUiw2/L/nbhdqnGtv4NBFISGuyxnVOsQSKlzqykCgvueEaG/gzDSPg==", "7123ebae-4a72-4dde-b0f0-695e5f9851b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75ae4951-07b4-499d-ab68-20582649fb70", "AQAAAAIAAYagAAAAEJpAPYevvqNXJprmRjNJQzuBGyuKtC8IKzUsVO84dUWxx0yXW77QbYqgBoIOh20XAQ==", "e87de976-2419-4671-9609-4499394fc8df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f33bbe6b-ef78-4cac-a10f-a5310b9610d8", "AQAAAAIAAYagAAAAEEgVuh5DtkroBm1klnA5ST1W0u8ZbWLdZGMVSVO9DCIYy5IMnGBjAWAsThDtTraLNg==", "6146ff9f-f6ec-4963-89bf-ed3b1d351825" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8b36e66-f5aa-411f-8ccd-7881663a8a86", "AQAAAAIAAYagAAAAEBY391Lac4dZ/ZthQrL5NgvjoHvO9Ril4cJRUDLWxtncEebHMbSY3dU7WdPnE0Tp7Q==", "cf690f5f-2e96-42dd-b031-f1cbb9e1c42b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6bbf0903-446d-4097-8036-0c3eada35928", "AQAAAAIAAYagAAAAEAdtsg8KdhMgdqdMrrliQCyCP+MdoNcCzY4OGJE9pYga9OgLIsgmSO1pfM3Nmkh3zg==", "48a7e38c-b2e6-43f0-a957-8bc5bd8c820d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "454509d2-ce30-4408-874b-4e5c993066a4", "AQAAAAIAAYagAAAAEF88Af3tPVI1Z4Y1fu48GZzVRqwbxc3P50lqUZutGnCC68CahTgdNwhmq3UGDgi6+A==", "ed6f4327-7466-42a9-a200-114b69b2b116" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ec7e588-5fd5-4b3b-83b1-c628f97cfe5d", "AQAAAAIAAYagAAAAEBXY5jrcOZWlYXd+Rky0KhQ56q/HLHQqh5ggtpOLhPC8m5Zf+cfBxvm1HNPXVzGu6A==", "d24d2456-a3d3-4491-9a32-f173f5eec887" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04256458-1939-4b42-88b4-bf46cb4da451", "AQAAAAIAAYagAAAAELggFxhcRvZTXNpCd7kmO2Ef1dQs6pqizAjvymtWjta0oyR9b1t+vC5zOvW9aAtROg==", "be5e061e-a536-4eb2-9925-32288599630f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b13185cf-2b66-412e-8352-e024797c2d0b", "AQAAAAIAAYagAAAAEAG/0IRdZaVrKf+ODjtPa02HuKLKiYT9Viloy9/zU0jX20YBUp1tyMUE13rUwpgPow==", "71f08d6c-3b34-4e5c-adba-ebcb4de44e4e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6481a49a-1ad0-4ecb-a19e-f09f92d5d691", "AQAAAAIAAYagAAAAEGW3HfAHCZ2/dAA4EyKRcp2DWIBxhd44k3pkMMKM77+qkafKOkCPn9tbligeHh8v6Q==", "85386838-7d02-4901-ab5b-c50a6687c192" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "89b4a3dc-05eb-48aa-b286-315975062bca", "AQAAAAIAAYagAAAAEGH1vXlFgsBLAU+d25CHy/iG4ZsJtZ2ySZ8oQchyozkbVMS86aSpwhy/i/e9lvyY9w==", "bfac5a58-3869-4f50-a9d4-ffb43dc77c77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cece9c2-d0c4-4993-ace3-04cf9aed0188", "AQAAAAIAAYagAAAAEE+O4l5DTkFSvrGoakjdqxwwaEPzVizsL2M0E19FiO/OCIgHWCn5as2uSt6A8yho+Q==", "6d8fa451-9d4b-4a94-a32c-a417d20f3afe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "895c76a8-5285-4bab-8091-4c2cfaf3a5a8", "AQAAAAIAAYagAAAAENFMtZUTh2dujqak8EcIVELdDhAirsHglMxqwk+aGhI0T0Zf2pGbIgJPjri6FrixHw==", "4e18e38e-8896-4cfa-8ecf-de5851eca034" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1722038d-a34f-40d2-873d-7e62056e5e34", "AQAAAAIAAYagAAAAEFUTtbw92JURerhRUoisKMuYECh63jAlJ6z1JK68AWA43EU4vQbmJZLs8BZEzwLcVw==", "712701ee-281d-4e3b-97df-651c795a170f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8249b067-aa51-4743-bff1-b78a29048ca0", "AQAAAAIAAYagAAAAECDC1/YYBfl4j2+ZMIqGCl5D09KCHdg+3t5oUvEYG8zlaJyIm+TI80ymRVf+gDfFvw==", "2c276af7-5e7d-474f-9b8f-a3b31bf70386" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5048781-0f1f-448a-b604-ac94a79192dd", "AQAAAAIAAYagAAAAEAvMo2DzNNQV5IDyneg+v59bW1qWuu7/6Nn9/ftmLzyfC82FpztHScs4V6MFwry6Yg==", "8cff6361-d4a4-4bd7-bbb8-2de3d2c56446" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "41370e1a-b1ba-47f0-968f-c021fa6de84e", "AQAAAAIAAYagAAAAEH2NUPAgyIc5jAsMZmIFfkimHHjlhSu/qJrw31pxSAqi9SIKEYYnqw0Td1Yb79VVUg==", "dc89b525-7c3f-4b50-b5fb-ae91babcdd30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7841b89c-89f4-482f-99c2-cfd1f73d5e22", "AQAAAAIAAYagAAAAENiW4lB7D2rZF53dbLnqDRUVS9+HNOuSQn/SwlrTyAqGEEmEdW2bB2jr5Y9ELYlKSA==", "4c22b8dc-e88b-4bc8-a127-03be07d1d2ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6bd3c16-0056-40bc-b434-c7a95897ed02", "AQAAAAIAAYagAAAAEOJM36zewP9OxZmNSiXjiz7i8kojGw5Tvb21Z/4rQDVyyPeq7WPxLRXthzE+z+qsCQ==", "82225676-2034-49d2-b1ed-5a45b9c4e865" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6072b5a-1b68-4c2a-8973-c3dc3225856b", "AQAAAAIAAYagAAAAEMtWomUY7NOyQPuyVJPCQFX83fK6TNLfuDR6U6KxyV3lWJzDjwNvGQsNJnJ2qkwVZg==", "7f172c03-fef2-495d-861e-dba68f6a8e7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07f33ac4-6d40-44cf-8389-00fc563a105f", "AQAAAAIAAYagAAAAEMRD4RiPrB4KrhLCLg2TJfB6jAWft4h+SmGRoYwufuJ9npwK+SoA8hhLuwW1Eqv2dA==", "bea17fc0-3509-4e71-bfce-cebf8b652abc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9966e662-28b4-4f98-be08-f32ae08140b3", "AQAAAAIAAYagAAAAEMc+sFH6FSp6RSmv9Wizti/A2pvrkxiRZTF3RuF5YYlb9MIpKrLIYGG6+v6y6PbnJw==", "f98ea680-621c-47ba-bcc6-bf0973fbd3bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6ae2d16-9e22-47b0-9763-ab8bcbefcd89", "AQAAAAIAAYagAAAAEAVm5Dya2kGQNbG+FAMgOFxUKUQ2OdkV1nvBXq9EToRv7VgFIAfyF4ueTb8ZqG8JFQ==", "3fda646c-d900-495d-86db-c7a88b8b9579" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "370765dc-772a-4c4a-8d95-8ec4fd9e0159", "AQAAAAIAAYagAAAAEEx7YQTIrRYPTy/PAX5coVdxUR6LZN3NSZBtu5sGVJGqEgVj2YTZEYExnE3VGDz4tw==", "2525bb9e-346d-4083-8aa7-2ca7e4f58e4e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "31e75a54-9630-4d11-b862-171d20ad3c97", "AQAAAAIAAYagAAAAEJfYgjBKqF+IDk0BCjeMh4UxQR86uFdbaMJYG7F1ztSg165PH1UQZpqA2YI6yiuf2w==", "8471fc84-b4d5-414d-9f63-35b812df248a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb895171-77c9-4569-8a31-acc181a09705", "AQAAAAIAAYagAAAAENrwq73d5HiFD4gAAL2QdQjySZRXLdFH2N3do0xPUb43cITrimg9j+mPvUWU7VKwHg==", "f1aecce4-b30a-4f21-81fd-e7add66cb4f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1b6079f-52a9-4056-b8a4-e3f36018137a", "AQAAAAIAAYagAAAAEP03PDuPBvcWPoK8oH78gDB/+5LzCDMTHp231rxxNC36YvwQrAOoVzXGtTdJkV2GHw==", "2bd1101b-7162-44bd-aad6-a66e43f8c8d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aaa72fa1-cfd4-4663-9f2d-5c2058093313", "AQAAAAIAAYagAAAAEEKuAOyaRi3QhxCRz5UapHz3BtqCthq/rFMHdd/pMfISzuxxFwrokeRzpD7nAZpdBA==", "190d5e44-1d87-4a7e-a118-809f0d5f3dbf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b133e64-4941-460d-a272-f0900121d457", "AQAAAAIAAYagAAAAEJ947Us1jby3oXbnOS5gT7f3zdBhqZjERvwUnW7upS8z5k0yn0j4AqN6a3D8vv29WQ==", "005d10a8-cf5a-4d6f-b46d-222a25303f23" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f11ea9cb-6848-43b1-a12c-4291b7979fdf", "AQAAAAIAAYagAAAAEL6L0TmanVxih4HdkGrP8HyiyKMFaryjB0nrVtqgkcVSHzNYFiofFwRTL3EOe5n50Q==", "0465cfa6-8587-4c1b-acaa-9039d5fe4214" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b07ee921-7270-4d23-893d-2e591dea6d26", "AQAAAAIAAYagAAAAEPPpNWkx5jgWdfErbpaBWsxxEnKyg5R6nMGwz8OyMRn4EIvlRJkpHVb1BctIMRXCFQ==", "acc03fd8-7b61-47a4-a1cc-cc259ff6d6d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c97a632a-892d-480e-9f63-ca98b3ca3064", "AQAAAAIAAYagAAAAEMBg8+SN45V7sCflraiajvrRnl+YgOO3YJbVFDNDVkzQT2pP4SP5ddCNLGX11nbHJQ==", "989ef5ae-a41d-44d1-bf97-d30aea35f50c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2bd25a6-2fc1-43bb-9f50-d0d0ce84967b", "AQAAAAIAAYagAAAAEBVdyuAwepaaUsQotUF02cuT03JLgRsgB3sp5ibOhRTcqmuKdzvFp7Bhadiifw6xaw==", "9034832e-e1b7-44bd-bb47-2e89bffa3f7d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "854302d9-e42e-4fb4-8a54-70a36e0100fa", "AQAAAAIAAYagAAAAEEKgKHJPXIaseSh1o224kOze8F7ApFQhxAST5uDwDl+4pqZqpA4fhLzdTPaTR9knZg==", "aba5ba65-d372-4f87-adb3-0cff502cae72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be463318-ddae-4797-9c76-3d144d2adbe9", "AQAAAAIAAYagAAAAEH6BUKfhK4tTtVprQyUTespUKG70WXtINzh5dJrHPYvSXd4Pr1CAaBZHritouEenvw==", "a529c95f-f55e-4221-8b00-5c09d3840154" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a6348cc-e4aa-4f2c-ab2a-80a3d9a622bb", "AQAAAAIAAYagAAAAEAYs03t8cd5JKMPoZHXn92Eg2z6RABl7B3YSBhTKILyPi35QEbK0TAtVrggQwGecBg==", "3047ea0e-a5c2-4284-8037-9f0438856849" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5bcd9a9-525d-464d-9dd6-9c8ff92171a0", "AQAAAAIAAYagAAAAEGXgTBE2f4myFYaYyS6r4qdxPPd6y3nISsxbuDfITU7m4TfMLac4UFT7Bpgp9cQaJw==", "0211f9fc-a29a-4eba-b94f-193491cfb354" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1492e56-43d2-430a-b011-8a3c8cc4e3f5", "AQAAAAIAAYagAAAAEFazeadw1JFo2vpdMveqKFg+X6rxh8Fo+iRHyJrEuiJMVuQ9TSg71Kc1hKdOzgek7Q==", "7141aa2b-63f8-48a4-af43-e95325d147d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "375fcc3d-5eba-49de-af79-c3a821c906d6", "AQAAAAIAAYagAAAAELHs4mDWG744reenS/NHo4r7T/2C81EPZXTaNbKrsV8v4lCMjJZGdSM7vacIOuSypw==", "8457fc21-49f4-451c-8c74-95299a8b828d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5740eb0b-7ed4-4f69-b38d-13a87e47ed2b", "AQAAAAIAAYagAAAAEBDjquI675EDZvvV9FvgWjitf0Tbhzmu7vQ8sYFjSfcCOjlyvz0vRzU5N9L/TIhZJg==", "e892247a-0cbd-4524-aad6-876115e4026d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f57571d5-d057-4deb-99e2-7084607f8f51", "AQAAAAIAAYagAAAAEDnb4aDEYPYA44xyro18ogBS5PLojVge/Qi7tUAP4eryq3j5ny5om0awZBDYJnwuqQ==", "1308d77f-c3b6-41df-af78-e156237c7b41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e3d315a-4951-4a9d-9823-2688168c9147", "AQAAAAIAAYagAAAAEBIHxKCgxYuqMRI9IWCPCbS/V+WLPoGR+hd+YqCa/IjPDXdn6ycc+wX7qY7h/HBLMw==", "c0392361-4ead-4d81-911c-54557c382d96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40247cf8-2122-47c0-9860-83cc98ed6282", "AQAAAAIAAYagAAAAEEyLToxF/9lmnnS04XawrZXiMqmfqPZVwmMoL/73YOrlhY1Ttbh2UibDSuP2NkexaA==", "de4ec257-9ef4-4aeb-8a5c-abc761e9ecf4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e2432d4e-e07a-438b-be50-65e95398baa3", "AQAAAAIAAYagAAAAEL2ew10tiwh1uhO+Hs7Id+tzFk0HDJshVyJ24C2NKgzrhbgoQ299cYKn1QjYB/YBFg==", "27785eae-6ddf-4c06-8f22-afe258b51fa6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72753a97-265f-4598-86a7-2389be0cd42e", "AQAAAAIAAYagAAAAEMXLeTfb9smYnP5vX4LHATz/pUxNNyADSN6lmenADeCA+FD9wSUwLSp5ksw+OUJQgg==", "033111e3-9f12-49e1-8e02-383e70536472" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b2f0fca-6d31-4a8c-809c-25a62469b5ab", "AQAAAAIAAYagAAAAEKwFFKtOuPCkvdtZCCu3uYVV4GDzr9BVihFRiOU0mJCKlJ1mr3ppKB0gBukKzQF0ww==", "e1cedd41-0978-4175-957e-bce523530de7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc32febb-8bdf-4b49-9c1c-6e2b12835023", "AQAAAAIAAYagAAAAEFIKVXfltVGOu42e2rHrsN5o8qR39bASPSiZ1mdohzYZB+XkQTWgfCz97Lx8HffSBg==", "fa3b1428-8e06-46e3-9fa5-7b33a02f3fce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f7d536f4-2883-4c31-94c3-410679dc9c17", "AQAAAAIAAYagAAAAEDWOwWOtip4KYElUX3WaTyoif628/LHd4iJxnEtCvIUxJPJz26lnbU4Ec0mqfTaFnQ==", "564d1063-7288-45d2-99ee-f5a9d683b6eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d96fe1cd-2497-4194-8d7a-6116ca033336", "AQAAAAIAAYagAAAAEPSVqgpVu3rCs30BB62JXJ6tnFzYGWuKBN+7Dq+MwgZGEnT/WMc5H5lv4YLlyzP5uA==", "12717642-5cd0-4d50-93a0-1b35ea3519e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4448279f-6c01-4345-b83e-c582e6a4e4ec", "AQAAAAIAAYagAAAAECEOQjItl0UuPyM+lqgSgtWDtOVUb2jVRLKj57aivb//VVmCUMhAy7gF3kVuJKzPQg==", "b340552f-a4ac-4930-8e3d-3c2326e6d4d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fc324389-8b96-4bff-be56-700d69f403c2", "AQAAAAIAAYagAAAAEP7A1+RGukoucw7QXJxNj+XsUxstiFk+CoWxtSJqOkigAWLs3nLYrOBWqEoiZrhmiQ==", "2facf495-a3e1-4bd3-b712-9e20f657d18d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f4210b1-3e59-4f1b-8297-91d95b93dba0", "AQAAAAIAAYagAAAAEDcjn5Dm3+Zl1WCGbR+WX4YhbUm+ZHXGP3KHauYPZinXTl5hKNZkqnBaYeh4j3peUg==", "39a49977-adcf-41a0-ae32-f8c524bf0ff7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b344ffad-d05e-4513-9af5-cdef78d1cc2f", "AQAAAAIAAYagAAAAEIXUiSaTmin49apw4s8Z92Pa4fyU0Gjq2nHqBhHpcspmPuqOIxhfQ7DoaA+d0br9Kg==", "e5ce25d6-b646-40b8-a55f-810d57190d29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad41d2dc-0a0b-4833-83b9-bad8eb3e68cd", "AQAAAAIAAYagAAAAEMqaCewE4hf7CDyNXUHAIWSS9w56X70re8Mz8WKE+9JK0g18lTf6hWCpWQHIB5mjag==", "57bf0f0f-114a-4699-bb42-05f95e24d0c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5055389d-41fc-452f-9367-df0d8bc396ac", "AQAAAAIAAYagAAAAEEt7xrtfk8hQfGr1FW287Zv1UKhb/356JDu79yzAIXgVLxp+1Df89CZc9P1PYqlK3g==", "336b23b4-ba79-4b86-abb7-16a46930c6d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "daf782f1-91e0-4bfc-a06a-80e39113f3ba", "AQAAAAIAAYagAAAAEKmgjBfvowZXOES6aEzkfg+uWfAGmDQs7KmTyYkGtAPQtAuxzpwWxlM2bXyb9Epv+A==", "4e86f098-13a5-4ee0-b3a3-f88545193352" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c6c1010-d9b5-4473-bc19-0975dc194991", "AQAAAAIAAYagAAAAEE0J+3/pEr1NSX5NkRmSMH8lzWyPZfja93NC1VRsXm8j/xL9ARX6BFJTsM3q4fiF7w==", "6ec3e308-6a7d-4cfd-80b2-c45e51eb8682" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a62406e2-9c5f-40d4-b0a1-837e064f2523", "AQAAAAIAAYagAAAAENC0U7Z552yIGXVx/9RqbtqXFIVHEQqx2z5y/eP1H1LQBAnchDdVWIWZBnSqLLAx1Q==", "a3c864b2-d6e2-4727-8d0f-f63792dd07e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8bc7e3f-6274-4dfd-b20c-b3aaea6d8bfe", "AQAAAAIAAYagAAAAEGL4aqOFeZ5grMn0EyUM6KQ2kBm39UDLm3lxgCRYqVBNQxU2Mrf7IqgGPw3mx5teOA==", "ac07e7dd-9192-47cb-9a4d-a47087f41528" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e927aa4-befa-468c-a807-2d3dc11a2cc6", "AQAAAAIAAYagAAAAEMpcRPkNOyPbDap5/tzgg7BINB3idlg+qj0ny4uUd+Bqb171OIorOlmniikZ+H8uYQ==", "b248422a-12ab-4b5a-8844-e3289005435f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75b9b2e8-c580-4b46-ba05-6015c6662c45", "AQAAAAIAAYagAAAAELYUON03hrt2qf6OjrO6BcHx8uPRTmO4/nnzsQ+LjzFgaTjp1XXMhaU2KRFOEAcZqQ==", "1f513224-a130-424f-8c30-0daa4a1086ce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db6815cd-a8e2-4e81-90a1-5888a9ede845", "AQAAAAIAAYagAAAAEFIVFyP0odOu38d1M7F7IjEfldwbOkEq86zmNpzA6XgO6+2QGctulKCh5iIgyBOB6w==", "ebe849a4-4974-4a69-8fb7-efe62e1280cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94f0fae8-37c3-4ff0-b1c0-7d23782747d9", "AQAAAAIAAYagAAAAENzCXaplrncooprBaF07QWkEai5co7yjYjZQqAU/BlsWRTR6tsiLlA6gBzz71ZZJyg==", "69384c6b-66bf-49dc-99ea-168bfbbf10fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f27dbb4-26c3-4fe8-8662-532d190a8c29", "AQAAAAIAAYagAAAAENMJRff3XnfIT9Tko4yI842XXfhILfe3/qOUU3iPwYBxVShSnMI5S5ICqILg3d1/mw==", "f7f70c65-8f59-4064-91d1-46b82e50fc6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "834fddbc-d67f-47b5-8565-21e8c3b82f86", "AQAAAAIAAYagAAAAEBpFQdtVuEX643IzSnfkOji/EmqLXG04IWK4sqkmF0ATTGa/W8HJ34h/BYa/NP5Ezg==", "f5ec63f2-e88c-4003-9b1f-0bcae1a8aa01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a85dd20-1f88-4d69-9bc5-0257641fc178", "AQAAAAIAAYagAAAAEJEDpIKu/Tqh1GkOAko76WNx621Wuy0LOQQt1selGZKH9xF8s9E+VfIWOf0tJnhxoA==", "4b06b985-719d-4c2f-97d9-9abc68360af1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52a69316-25d4-4c9d-8845-7471ec35a363", "AQAAAAIAAYagAAAAEJWPX/WSZDajISipaT/jseuZmffiMxamkdh41U4VwifpNwY4lFgYEa4H5qTX2mRILA==", "1002bc83-4619-4c48-a73e-717c7deb68ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d456905c-cce6-42af-a5fc-ceac20082efb", "AQAAAAIAAYagAAAAEPcBeUqoCY/JQSoJoFxkpmT4PRcuKmnj7HFy1TJovEjlEx8xK7n/rX3U+T3cZAWypg==", "9c635635-ec44-474d-ab58-abed3574756f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4418960-3946-4643-a399-5c8ff6ec40eb", "AQAAAAIAAYagAAAAEIhiPskzGHEm9yyd5Ntfi2uLxzb52zDxEQ168N5164z6EwuVFRg2hcDD67oOxv2BjQ==", "cc30eacd-7e4b-4faf-a07c-9a5345a95a70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "269bfb6d-96a6-4241-a511-981387224a31", "AQAAAAIAAYagAAAAEFcNGzgrCWiKgxo12BdgqlSexO3hvIu2mPx29ERE1mVmbm4aRea3U+j9auVTJheeNg==", "4097921b-3958-49fc-8b0e-435ee0105d5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9fde18d0-dd6f-4593-a68a-b1fd283ef162", "AQAAAAIAAYagAAAAELFOVCW0HpCrn9JrRkJu5VEyrfpMK4Y3Tr13zNErLE5NPDy/1oa/FhzqHNa3IKDb+g==", "5c5b0c7d-4224-4e23-8ed5-45c73dc63178" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a84fc2e6-525b-42ad-924a-8cd642864539", "AQAAAAIAAYagAAAAELmLCXjcT7AZRq2Djil19Bpp8pPPmBx/uqAC5twvuUPgaMtv/6Q8p0pAqR5voBjfkg==", "f31902ce-cfb6-448c-a2ae-6d851a8c11ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0a29f4d-6473-4f3f-be04-8d5b5a39b927", "AQAAAAIAAYagAAAAEJGkF++idZBn1yzbp+3K4is35RxrP/mnYgp/mAOdroSLUMdlA5Vczoe3Z+T5YWw7BQ==", "fdcd2726-987e-4659-8fb2-30d1e0f583f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee28b732-e1b2-45b2-92b3-e68cacb56b36", "AQAAAAIAAYagAAAAEHOmi4Rk+xjIwe6F9Xa3MMRgkXaBJXli2N5w8+AwHueK5rYVuxA2Lv8i2SUDVp2WGg==", "cbf29705-ff27-4858-86f5-4098cc269614" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a31f07a-5cca-4e63-b611-e41765fbf714", "AQAAAAIAAYagAAAAEHizeORn5l85mN20vpoNH7SkhmwsvHjePkQP9WUJzabxs1gIZENG2ymUPbzZ7DvUbA==", "8fa35f22-3a8b-4755-b1a8-c9c3eb4071bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51b75e71-00bf-482a-a712-64ba145403b1", "AQAAAAIAAYagAAAAEOUxul7fuTJnmW4wabhjj8RFJSMTYgoN40gHfEHqT4iLi4+VbJZ3YLz5d3J9NpOcNA==", "5f04edef-c6ae-49f8-94c0-e39256e38faf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c54b94f-ad76-40dc-9770-8be74c47b19f", "AQAAAAIAAYagAAAAEM9nNDLoOn+2Ro9bZjpF7VoiERS+1tnBcfcTo+9YR6Hc+3l+/8x6hj6lrQSvVSNfQA==", "6e7febf0-e7cc-49cd-80da-2cc95c6b9d95" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "336fdb5a-510d-4d16-be82-9dea91f626eb", "AQAAAAIAAYagAAAAEGrtJ8M8n+vjf5KgA2poc/rhrFA6Dv4boVUIDABr5NuSqfKhtWDnPUPRkh+0phD3rA==", "0b3bf907-8325-4b05-a852-de118d4de9d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b9c4c6f-3305-4f65-95da-2b2cfe4ecb9b", "AQAAAAIAAYagAAAAEDqOSRDu+uPDD+XOFshDMO9ETRNFQ/o/UQWR+eQw7aBz0d7bAd+3nlRQhlUkQRgAeg==", "8a8d3159-0c9f-4ccc-963f-704be40c7d70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b56618e-740a-4e2b-a6be-029f19a89bf8", "AQAAAAIAAYagAAAAECtHJj9Agyu9fd7ArWx4W5wcM3iiW7zAYJDJz8UvzRm47enTqI9zNeMYTwePQs3zdQ==", "1e63a1c3-fbcd-4dd7-ac6d-259d0f4d8c31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b1c5b0e8-154d-4271-a62b-d42eb7b5f6ca", "AQAAAAIAAYagAAAAED8AdOZxyE3FcO9BkFhI8z/z1WeX3/rbCMvSp8gx13awwquku425oyOvnQTwdlBfjA==", "2ef97727-3f95-4fa2-bcc4-9f68e41b426e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c721b82d-ef7f-4081-b840-41ec835b6c4c", "AQAAAAIAAYagAAAAEOBqXYALkEWWWxT471DMGcJIVKaPD04+mqwPtp5aqibGr4rjsDiNZVWntJn4AWaWDQ==", "fdfc871a-cf69-44de-bcf8-3cf8fc82d792" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcc6e1be-b7a8-4411-9982-ad7bf7abc9b1", "AQAAAAIAAYagAAAAEEa+wdoObzhv/arwum5UakWtZ8mRUBI0zfqu+1mZgYypf1TE3hjJJBhNG4hBbnSOig==", "e5184ea9-0b3e-435e-89ea-277a4f13b205" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b254cd9b-d859-4a1a-8a2e-eeed611311b9", "AQAAAAIAAYagAAAAEFPIKj9/pLUP3fT8weR5xz6SclDWWFfuT9B4V1s4uO15gz+xpPsjCrHc2uWtrPtcRw==", "5f2dd8b2-187d-4975-b4f3-451048932054" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb1b6b33-00eb-401d-90f8-1dce3597a22c", "AQAAAAIAAYagAAAAEAQG7dR9koS7Dprk8mzNXnVgNbVkZj0z7nQUoR7FkA0E0Nzaknvn9fp5qfChC+DU7w==", "c271c1e3-6f99-4727-9334-80348be48d26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "252d0867-190a-463f-9b93-6d5030a38f9f", "AQAAAAIAAYagAAAAEMkx05STakUFvU2xtcscpXtYgiuzGnfv2ylyJQWMCIvSHA54zLZxNxZ31OT/XE1RuA==", "0d7cd777-6b84-44fa-a329-533da4963f8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "555b1f5b-ef7d-47b0-89a5-47b65f4b8e64", "AQAAAAIAAYagAAAAEMCxmnUUG83x2jps+J8Y7K5OJ7WCLh3ZHUZiudwlWSH0H1wFsfms/cyemgnbrqwkXg==", "f19ddacd-907f-4163-bcdc-92e985d18ccb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97b630ba-8755-4954-862a-a237fbff4a3e", "AQAAAAIAAYagAAAAEAL3onmCzxTfWKItPmX2h0NA2XmqdWGiw8Bhg5p/i7UsWWdnArmc6q5bqLpSGvbxKA==", "580c30e1-ec0d-49f6-b558-90fa89a7265a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e49d7a22-6571-4c57-98f3-91aebc7b4f3b", "AQAAAAIAAYagAAAAEAmqqEeRHsLlGSe3yHqFa3Vmk0bmw4UuT2rK0WUk6qCh7mmYUuz1K1IEF0y1Q4FgTw==", "1b4d97c3-33c4-418b-9df4-a2facfb29508" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3488cb3d-5fc5-4b6d-9e59-72ece6ad9bb3", "AQAAAAIAAYagAAAAEHnmIjAQjRbCEViBFpfKZJNXEzfVFNAsSerRUSF2orWOIHZHbzN5hrkyHn1hLVAgUA==", "d97780f0-ed21-4af3-8efb-4dfdc4f1bd78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f41ebe16-8092-458c-82ec-fb281976a648", "AQAAAAIAAYagAAAAEB6xoQ5+ZDXo2RujDlOpRIHfHx39j/EKQRI0pWDcRSF15zhAY7bmUnmKFY1rgTO1XQ==", "a61ec427-f2f0-4d63-9145-fe5d51220a56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbf9a495-d324-4925-ad6c-3d8783c455ab", "AQAAAAIAAYagAAAAEPmngBWaPUFquAsnKBVqUcI2oQ0JX3kGwBlttAvVB6T8WCeZlp5waXLXEdQjqc0jdQ==", "cc49a3a0-8ab0-4672-b5bb-d2ad5ffc7a6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9d9840f5-4d73-4da5-93c7-d66411f7dea1", "AQAAAAIAAYagAAAAEA/lUYTXHChxLZkGn1YpDXP76UHwpBsgwOUkZfPoXjztgfNkDDK1yv8wuDQlmfF7vA==", "fa99955b-531a-44c8-8b29-1e77eb37f34d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9355085a-62b4-4460-a3aa-ad4806acb9ae", "AQAAAAIAAYagAAAAEDadhJKEzvFy4f6JKuS1I801jxEBvCpwPwLad6zINixWamhWPUEXow8eYEEAXlSDAA==", "e2aeb9d5-9d39-4d81-a202-5cecb4a39e34" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "680c2f60-9cd7-4454-a064-e7046785af78", "AQAAAAIAAYagAAAAEIHPlpQJplz6VY2XD/Zbv/6ac5Tmz46g5GJyM2IqoV/RnZLZDJoBYtoa7d7y+apYVQ==", "aac93390-5b69-43b7-9ca2-0897e36c89e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a06c916d-5f2d-4301-a70e-696246a0f55f", "AQAAAAIAAYagAAAAEE+GslB/g65pf0RrkvxoUoz04KPUoWVt2XO7+1V8BoX1L6m6SnbBwJ5L6e7Qferkxg==", "491efdf5-09f0-46ed-806e-709d5b6a10f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "835645a0-5703-406c-98a3-00be310b5773", "AQAAAAIAAYagAAAAEN6FNGgp9TOKesBFqarwMVUFGT5h4OqkOX450fX8lyHZGQQIGwUdpTa3Ks1Amvl/2g==", "0fdd61ca-c345-4cbc-ac64-4b017788b921" });

            migrationBuilder.AddForeignKey(
                name: "FK_Deliverable_KeyResultArea_KraId",
                table: "Deliverable",
                column: "KraId",
                principalTable: "KeyResultArea",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_KraRoadMap_KeyResultArea_KraId",
                table: "KraRoadMap",
                column: "KraId",
                principalTable: "KeyResultArea",
                principalColumn: "Id");
        }
    }
}
