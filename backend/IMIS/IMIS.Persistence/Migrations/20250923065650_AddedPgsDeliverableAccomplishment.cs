using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddedPgsDeliverableAccomplishment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsDeliverableAccomplishment",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PgsDeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    PostingDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    PercentAccomplished = table.Column<double>(type: "float", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    AttachmentPath = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsDeliverableAccomplishment", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsDeliverableAccomplishment_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PgsDeliverableAccomplishment_Deliverable_PgsDeliverableId",
                        column: x => x.PgsDeliverableId,
                        principalTable: "Deliverable",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "b9addb56-4f9e-41c3-8371-0ed722fcfd87");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "b096373d-4b01-4f03-81b4-c91a7ec5c5d5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "39ab6c5e-e000-4b53-a11f-141c7fc23b60");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "fad15400-e67a-4eb1-974b-c3f04bdc08a8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "6942e057-3920-4507-9bdf-ef35de84b88b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a56dc9fb-58b7-4ced-a73a-b5f79010e41b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "b01692ec-e036-4de7-81a0-97f04ece9d03");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "576ae643-662d-4435-a407-3aaf9d8cc9bd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a8abdd1d-f513-4fdf-9c62-10db64e2bbed");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "367fa83a-5093-4a95-8c08-5ee9225cf327", "AQAAAAIAAYagAAAAEPbWxnKiU3qvTmBjeBM9/VyQDcZNG37n1wQ1dfkVjwV3s22nZbP/Z3p1qTP0OdbeOQ==", "7f2bb761-7018-4759-8f3a-e5000e74bd7e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf95b1b9-8d71-4d42-8fc4-9cf7383af897", "AQAAAAIAAYagAAAAEPYUBVhJEjzJhyYSGeFS2waAyj78rIMStP+GO3P8wmuPhw2bdg0BIKc7GCY0ocRKtQ==", "bfc55a81-dbaa-46a5-9177-c8a4b076303e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc59eee9-970a-4eab-921e-10fa0871d651", "AQAAAAIAAYagAAAAEC78WXut9KKUwKiPO/WG1n9ltTYUbJTJl/8WN9eZybkqhzNnltIhOxc1Glot+25tkA==", "6c1ae287-0ed7-45c4-b2aa-b7c1f34d4ef6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb96c1b0-fb12-42c3-8c39-dfbbe6cb3540", "AQAAAAIAAYagAAAAEPqEaOnbrK90Art3zw5FI/P/BzCZztSquZpzf8gQTCSmyQrYaWs0PmyEY4E3amq8sA==", "211ea789-46ef-44d0-8c4e-14dc55d71641" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "90dbf047-3a31-43a7-8492-4971bca517db", "AQAAAAIAAYagAAAAEIgiXBGpeESTHE05Q7NeT84gdIMCc1ydndx0VrhfD/m3x3EGdDdLbMChwoybq3DvyQ==", "78cd7c7a-cfe2-446f-a6b5-91c5352ce59a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75ae6b3d-0fda-47c7-93e1-1abccc06294f", "AQAAAAIAAYagAAAAEMlvPxv8Gui66hySU/tvWsak063nNVUUfsA1xJtjrxBkRATGt9kaSG8fiKZvYre2bQ==", "01a9ba5e-d133-4310-98e5-01716b70944e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0583ede3-6700-40bc-a60d-8d7e6027c9e6", "AQAAAAIAAYagAAAAEIIGQp4oqcv9Al9AMAJoDqYzvq8+jJeou4bghAfOBNa8LUlubtjXJf6EQTuepUu0mA==", "eb2fc491-0000-4fc9-9668-401eeb6b18a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6db8606-25ee-46f7-94f5-0eca450a1a2e", "AQAAAAIAAYagAAAAEG59I8vqIZVaeZSxzIslvwVAPNr90P4lR8cliorlN9OOJkehf4nKcuauXWCQa5nwBw==", "17545ab3-a104-479f-aa61-1dbf9b362f54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c053c446-40b2-4698-bec0-8fb55b5ca01f", "AQAAAAIAAYagAAAAELD9xlN8uxrFh5ecEJvRs7zYUdWHaQS8cs8mycsfr+m2JAdsjXE8uUtn9D6D7/cnDQ==", "eb53334c-8d28-4088-a982-ca32ae14c621" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3939cb1a-4fbf-4068-8eb9-2c574a3b369d", "AQAAAAIAAYagAAAAEM8oDLWUDSerFHNLllvT/3lsIhYzQWZNxR1mfaDxCq6dtfroRxvmISe7zThpzXOLvw==", "8a80e7f0-814b-4d0b-9d8e-80ea3dbc7235" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d84a1635-8c65-4665-a697-98ef20180769", "AQAAAAIAAYagAAAAEJWi700tIkoA6Y93qqaxid5CdlyDa8a818Xw/mvNO5Vo5mAeoQ2Di47tmWlZGbyfBg==", "c35c8af6-2f6c-4474-92f5-afde4cf3eb55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e09580d3-f4af-4dfc-a793-8aa433713321", "AQAAAAIAAYagAAAAED56lfq3si1SN+8VURY+zOBBA9hQLSW3mJxJ4gTTrl705Qyr5Y4cJqYBxs0ajJZ+rg==", "f21fc909-d5ef-44c6-98ca-30f3b51f2085" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ce377c9-9256-4b54-88d8-43987925e72f", "AQAAAAIAAYagAAAAEE7HBdG2tNzNfHYX1jLIzbfaPHqklqSl4X8ZwPLUTPyJjRThyT+CapI5MxQNc82imA==", "07c1df97-abd0-4111-8b41-81b7da7bcb61" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableAccomplishment_PgsDeliverableId",
                table: "PgsDeliverableAccomplishment",
                column: "PgsDeliverableId");

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableAccomplishment_UserId",
                table: "PgsDeliverableAccomplishment",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableAccomplishment");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "4db61517-9947-4bd3-8b9b-10a867a788c9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "077863eb-9339-4a69-b47a-42f5c66b6f76");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "44f6bdbd-6ffa-42bf-84e4-0b70add9b1ce");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "e1f87af7-947e-4908-8a43-cf398cad18c8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "8322c03f-1a16-465b-b38e-3d1687467ab9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "218bc331-9cbe-476c-84c7-52d8b6cf911d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "90727a1f-5ae0-4ce7-8621-566970610b4b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "383053e7-460d-440b-a2f8-6e69b795347f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "7afdcb2c-8cd3-4eb0-bcf3-6e072974add9");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "babc2c2a-c84a-48ee-88f8-9b5ff30ce968", "AQAAAAIAAYagAAAAEHRlBz3UzZzp/2trcq43AqMWJMvDG1CdHFdGz0U+6SVLZBa+rDov+MVpulwYWFNR5A==", "3f844640-1ecf-458a-aad0-6607cc9e502e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ec06330-dfcc-46fe-8c62-f0088296d4ef", "AQAAAAIAAYagAAAAEIxGrEdYBRxx87pKMPBJgm/mm2kmrKQQ7OkBQ6I5+0mz37Uwh7NW9JvqxbnW7TEYog==", "06569e0c-5248-45b8-9a09-371fc02a7ed8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82ba01c3-b6e9-4091-9a2a-ef8f8dfcfe34", "AQAAAAIAAYagAAAAEN6QGREx5Ro0n8XFOWNJuNI5nb2xe/+YybJ0dyC1cyqRCHaif0vULwAzj1/2VQgDFw==", "2f66ff5a-4b51-496d-a0de-da6fe789f566" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5072f4c-3533-42c3-870c-0a30283ae193", "AQAAAAIAAYagAAAAEIyAi7leSF7FYWXbe9Hg5ohK50CCJ43qNLGlnLr+NdV5mqZ8oOELmZHUkcnkhsEmxQ==", "f9ce3b84-0ee1-420c-9a3e-3b28d207c801" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbc5ec06-3efe-4f35-b804-ad0f28191764", "AQAAAAIAAYagAAAAECYRBHkkSY8J5ZI77v8GmJJ02tqdJtskrpowHNEgy/prAAss/t0dKGe+Jwx5yw5kaA==", "9cb703ef-6834-459b-96de-94a84c26a9bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "962ea9bf-7b4d-4e5c-96df-c33686fd1eca", "AQAAAAIAAYagAAAAEMCLDwHcpKqNtUe0MPCM7VgdFerQAnuu2Jly/OiEVRKXkL1XDjIg8QE+In4oWsOZqw==", "9f204cc2-06d4-47a8-8728-618e7dceb672" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "319be0a6-c2a0-456d-8d42-99704ac96ead", "AQAAAAIAAYagAAAAEE7RwV0IE+lVw7Oags17bVJ2NDBrsv5+P52EKTETjlfK+CO0vsfD7vkKDS29qtPSJw==", "3f3b3d29-d3af-45c3-9dca-69c5c62a6c70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17fed32a-6a65-48c1-8040-2c602a5a6188", "AQAAAAIAAYagAAAAEI8UL+3os66xCfH0EGAXMqZKL0NROBW1dcHhm3pjsTIyzdGvGOczx1/n1tlKefptuA==", "007044cc-c234-4407-b888-f1da1d559ce2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e23c2587-527e-4b0a-9e4d-1a1614bca320", "AQAAAAIAAYagAAAAEMUMuzOqWWVGax0Ev1/ZFjnKdHhX2du1QVxC9tSISp9ECwBMNCFNnzgyKBQpDRSY8A==", "2f0ff9fe-97b6-49f9-91e1-ded379cabc25" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d932dfb9-2417-4efe-903c-bb7b856d18fa", "AQAAAAIAAYagAAAAEFMzq/ovb8e041SQAlont2USqeYQ147PUe7qs49yVXqEUksIFn4m5ZRL12knlS21mA==", "126932de-051c-4864-92f0-6663f3b5e947" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3044ec80-c877-4055-8840-6a9a24d10bfc", "AQAAAAIAAYagAAAAEC2zUTXl7R49yAl8McQ/CzeKrkiALUznOLVP4S7tHZtQ4M0XDWQT8kDYrSqqxoVODQ==", "2450e359-b9a6-48de-a39e-b6466994ed99" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aad62b59-a230-400f-a93e-51152d11f43d", "AQAAAAIAAYagAAAAEF2ckG587ALFREbix/hC+g3ltlA1i9LHJL5P68RcDVoAmd+8Ca9heIHPnsSBvM+NxA==", "f6ce21a0-66c7-40b8-a7ed-80821601c132" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf808c00-4a4e-41ed-8ea2-889a098c8981", "AQAAAAIAAYagAAAAEDOpgCjAP2Tphu2Ffy4TX139RcROgVL/8aLleSwrzZINemn7UdeB28UmUxBfv4LlTQ==", "760656be-e1a9-4109-af59-a3faed215f1e" });
        }
    }
}
