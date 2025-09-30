using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedAdditionalUsers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "58508b24-030a-4e52-931b-df0a6cf8b5ca");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "2dd0be3b-8446-47a4-85ce-f1448191643a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "3d7371f0-5574-4bcf-a05b-7265141765d2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "1bcd85e8-4848-4d2a-b900-aa35213fc2ef");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "441b3c88-aec2-43e6-beb3-0c454395a818");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "84f5b009-da7e-46fe-8bfa-baa2daf5c120");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "b39d4a4f-94c8-4f70-8212-d8de634a00a3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "046c5819-fdc1-4988-80bf-0dd3c77a2795");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "77ee7ac6-6f1c-49da-89dd-6b48671820aa");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f0ff06a-5713-4a28-b943-72cb7e59cd15", "AQAAAAIAAYagAAAAEBMhr7A1utfCD5UyepMKF2miBmyX0tgJTzoBRv83y0//KaDqVHqozJw9FeiQICKfEg==", "4fbefcfc-110e-4b03-a9bc-21fa30613d77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cb6f0e8-a7d5-411a-8a9b-218d1e079c72", "AQAAAAIAAYagAAAAEIOnyKBLevnoAG3gNYQf8LrzSnOnBkMcRJOXOsc9AGYHs06QXepkEt9QpbFKjiYRxA==", "d9ef8357-d24c-4584-9ae3-81df88ed3b39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27746765-0310-488f-b8e7-09b61fb478b2", "AQAAAAIAAYagAAAAEGy6i3twTppQnzkYEYdWvHRohtEWYxZWMAh7xJnEwKRtNnOsvucPn9SLfDnzO+QfyA==", "51089b73-1317-417a-a851-fe2874ecaa57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2fb23e51-75eb-42b8-b2ea-b54aae87e236", "AQAAAAIAAYagAAAAELL6ZqsmHqVhcXo+QsOgPpixDsHnA4uGkjRtSYS+/ZUf5KjN3eA1jNPlU3UAGlRB+w==", "41c0e922-355d-41ef-9b76-ebbf29cf0484" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a34b3c04-f459-47f7-a829-4d66190ec90e", "AQAAAAIAAYagAAAAECwcJiGkN4hqBFHgT6OLI8n5q2C2ZuoQOMnl+nsCM0QKAG9RKMGasPvz9TXnsQJOnw==", "b0e04575-09f7-40f7-b970-95f2d56dcff3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8878d6a7-6078-4472-8f36-106e70aabd2f", "AQAAAAIAAYagAAAAEHXwTiS5ucmdcc4rzLhHHuVs8CHQRUWIXF4XlucRS2C5rDoP3KzHLga/gm+hRDUugg==", "35ee3392-a885-4269-b411-4c6bdaf4d8c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3252dc63-2a9d-4acf-b5ac-92c2048f57d8", "AQAAAAIAAYagAAAAEHfBHQjO49RMbRswnISdZJY0CrTw+7ZquDuUGeK+N1rTW8Es8ee27TN3KOOLbcXfOA==", "f193c162-0dfb-4746-93bd-298174f2bc43" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "081882b2-88e9-4a32-8038-89b8e0c068b1", "AQAAAAIAAYagAAAAEJtDLUdJdGbyuulIiMFXX1DEFnbiM8hSQiONuA7UqmD8/7owrIhORM2JOoZ/vmGUhg==", "32238e79-4568-4258-badf-ccba3f704320" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "Email", "NormalizedEmail", "PasswordHash", "PhoneNumber", "SecurityStamp" },
                values: new object[] { "fd8bcfa3-9689-40d9-8c7c-c212be45cae9", "scibrahimtan@gmail.com", "SCRIBRAHIMTAN@GMAIL.COM", "AQAAAAIAAYagAAAAEB0R/ehFfJq/CCq5Yf8BAsaALdbkASi6hshPrr7j7xFvAr/hgHjAwbl69uOLWcXJaA==", "09178663037", "6647a4a2-d9a1-4f15-97eb-b773ef10ea4d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f3f2791-ea7d-453a-9932-e0994436591d", "AQAAAAIAAYagAAAAEMTox8lwUzrP2u5hnmmN6hFOLJA6FCwlA6Hr7p1QG6+XWE9jbOYlfL+WBDgcQHz9bg==", "a7797147-1848-41ca-ad5a-01ffd8e870a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e735667c-0f5a-40c9-96d3-4ba189bc3ecc", "AQAAAAIAAYagAAAAELoyOrlomQ4Qk/ba7q7qlcs7dhaCGWbeWL75wX4xHnWu8GK0AW76E6JhVXevFp0V1w==", "2e7db86f-473b-4f91-becd-3b769f16826a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a3edb71-e298-4855-ae09-b8007dd67804", "AQAAAAIAAYagAAAAEHf8K+nyEFF3BET0CQjRtcJbRxqknGnl7ifEp8VgrtdGb33txHL0W8XwWzIZSehQvQ==", "dbcff388-4c39-45e9-bf8f-1492ed5191e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "949612f6-2b71-496c-8c2a-28eef9273519", "AQAAAAIAAYagAAAAEOGRPco9Zh5NajZZ51yCoL0yDthlZqL3QGnuIHZEGq3EgyP0bLHGqCFtx3AlZso+Wg==", "0c91b0f4-b5ba-48aa-8ed5-c5d28cadfb6a" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26", 0, "8e929b7a-3f10-4e6e-acbc-f1f96eced000", "User", "racsandamen13@gmail.com", false, "RAHMA", "ANDAMEN", false, null, "KALID", "RACSANDAMEN13@GMAIL.COM", "ANDAMEN.RAHMA", "AQAAAAIAAYagAAAAECb0vwIWbW281YP26Tq+9epzg1leAs/7DQ3hX8dsLgZjqCBganRcD/Ae3yBHN7oQVQ==", "09456829380", false, null, null, "49996dc5-8de5-4da8-9681-5bedd123c66f", null, false, "andamen.rahma" },
                    { "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c", 0, "b074491a-0ba3-4726-93ce-0091a0d034ce", "User", "amybonite09@yahoo.com", false, "EMELIA", "BONITE", false, null, "YU", "AMYBONITE09@YAHOO.COM", "BONITE.EMELIA", "AQAAAAIAAYagAAAAED0DoEa4eJBqVPGJ2oITs8ZkItz9lxpZop/vuP7/EQCyDOImjEXrjnMRjPQQiY/l9w==", "09055207141", false, null, null, "763f75bc-35d9-40a8-8824-5aa4c5a8a0a2", null, false, "bonite.emelia" },
                    { "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30", 0, "8e7f6f26-d8ef-468b-8ab9-e924897f36f6", "User", "abigailsaveland@gmail.com", false, "MA. ABIGAIL", "SALVATIERRA", false, null, "YU", "ABIGAILSAVELAND@GMAIL.COM", "SALVATIERRA.MA.ABIGAIL", "AQAAAAIAAYagAAAAEJYg6DnDc4nMh0RaXddqzDhObekW5opf2VZRNvRx0jD+v8brudAI9yjWVeqSDh5YSQ==", "09088931724", false, null, null, "978ff689-01c7-4018-95a0-8408bf0bafff", null, false, "salvatierra.ma.abigail" },
                    { "12183b62-26ee-459b-a859-88a94e86c117", 0, "a5bdb725-68b3-4276-91e8-962a5f4f676f", "User", "NA", false, "JOCELYN", "MOJADO", false, null, "BAJAO", "NA", "MOJADO.JOCELYN", "AQAAAAIAAYagAAAAEIp2tckbkS3M5qENOR4qFAjIhvBupvFHGBl9U9lTuDPXl67Mxm+EqD1vhmVwysixLg==", "NA", false, null, null, "d3df797d-ebd1-42a2-8828-1e964ba83b05", null, false, "mojado.jocelyn" },
                    { "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3", 0, "a4556fde-dd83-479a-a5d7-117943951874", "User", "rosalieluces05@gmail.com", false, "ROSALIE", "LUCES", false, null, "OREJUDOS", "ROSALIELUCES05@GMAIL.COM", "LUCES.ROSALIE", "AQAAAAIAAYagAAAAEChREbsjBSdkrZfaHjGJ4LjTW9iwpbbpzngqlMJLi5kE4b7zp9IsdaSaYP9/hflEyw==", "09109099656", false, null, null, "599ba073-25a3-4d82-bd56-3dfc04243931", null, false, "luces.rosalie" },
                    { "17793347-1bfa-4526-a0af-0ffcf374aa9a", 0, "7086a8ae-6b9a-44ee-b92d-cbc906063e6a", "User", "marjorenecorpuz@yahoo.com", false, "MARJORENE", "MANAOIS", false, null, "CORPUZ", "MARJORENECORPUZ@YAHOO.COM", "MANAOIS.MARJORENE", "AQAAAAIAAYagAAAAEDzv9cxtlveSt26oe0wcu9pMf3vOW46sLPlisxWZDYnw2sIlF+0mDvk3w/eNXWH9fw==", "09072856158", false, null, null, "3dd5cfe2-8707-491c-919c-149841057aa1", null, false, "manaois.marjorene" },
                    { "1a9d8654-1c19-4b50-9431-4e23c174cc60", 0, "ae2b893d-004b-4d73-80f7-0ba20c22deea", "User", "Silao1234@gmail.com", false, "Andul Hanif", "Silao", false, null, "B.", "SILAO1234@GMAIL.COM", "SILAO.ABDULHANIF", "AQAAAAIAAYagAAAAEKGSWG/9F8zDMGSTWDc2wqndF3VaskXWeDub9hE75UzydSJ+wATS4u0uc+UFGTO/5w==", "", false, null, null, "8d91b8dd-9382-42b3-b509-ed7af009f07d", null, false, "silao.abdulhanif" },
                    { "1a9d8654-1c19-4b60-9491-4e33c176cc64", 0, "406b0f15-7509-4fd6-94bf-f4f2e56e1a02", "User", "gloriacalubiran79@gmail.com", false, "GLORIA", "DE LOS REYES", false, null, "CALUBIRAN", "GLORIACALUBIRAN79@GMAIL.COM", "DELOSREYES.GLORIA", "AQAAAAIAAYagAAAAELi2ONooJxcQH2MFftfFgB63zyvZCN7/M3LuEndJ/BrIEZKvustDUkhaxGdoEz+ZWg==", "09363304534", false, null, null, "8fb02a4b-5793-4343-9ce8-ae04ac2c8a3c", null, false, "delosreyes.gloria" },
                    { "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24", 0, "a1e1f684-16c1-41c0-a265-27832848ffaa", "User", "maraguia44@gmail.com", false, "ABDUL", "AKMAD", false, null, "MARAGUIAL", "MARAGUIA44@GMAIL.COM", "AKMAD.ABDUL", "AQAAAAIAAYagAAAAEAdo1176M8R2LfNXALQASISB+hPl5PJHpOgNzfUrWxL70z8uLnjn8R4tF4AEu6Ampg==", "09209177429", false, null, null, "ea8e6348-fe50-42b1-a74c-f7ef6697d9be", null, false, "akmad.abdul" },
                    { "21d7b7dc-3425-464f-96d5-f6784b19b4cf", 0, "c8ede739-24f8-40a1-b5d1-9f5fac92924b", "User", "lenzkylu@gmail.com", false, "LEONITA", "LU", false, null, "CHUA", "LENZKYLU@GMAIL.COM", "LU.LEONITA", "AQAAAAIAAYagAAAAEHL4RKgirUJpkICbwvzEIm2LvVloz+veTxo9gyxDXF1D7xN2gws2swK+457nPffLtQ==", "09178732580", false, null, null, "4625b267-25f1-425c-a350-cb07dc261cd7", null, false, "lu.leonita" },
                    { "2489fce0-858f-43af-b82a-65ee42cb2e33", 0, "0da9dc7f-a7f3-4926-a7e8-65937c161d7b", "User", "aljazzerangas@yahoo.com", false, "AL-JAZZER", "ANGAS", false, null, "MAULANA", "ALJAZZERANGAS@YAHOO.COM", "ANGAS.AL-JAZZER", "AQAAAAIAAYagAAAAEAYetaaMp50qJ/I9H34K7YgjZl/jhtFsEwSSMjabQ4yOaoo06d47Cf5H05ClBlGWVg==", "09179755770", false, null, null, "97beb689-e9cb-4809-92f8-157eb6d7edd9", null, false, "angas.al-jazzer" },
                    { "28a2a313-bc8e-4225-b8c2-85c2935b315e", 0, "e0e2afcc-ae2b-4779-a64f-25bc5021ad77", "User", "marcrejohncastillano@gmail.com", false, "MARC REJOHN", "CASTILLANO", false, null, "BALLARES", "MARCREJOHNCASTILLANO@GMAIL.COM", "CASTILLANO.MARC", "AQAAAAIAAYagAAAAEFbbn+jCJUcVRlbpOGfVkzAG8rSN0GgP2pCtN4DMhMiuY5fuxIits9256m+tS3cLvA==", "09959283775", false, null, null, "c38be1a9-db38-4cba-936d-0f7a40c77859", null, false, "castillano.marc" },
                    { "2e889d55-159e-44a0-b9c9-44cc9f25c66b", 0, "faafa512-cb4c-4a05-82f3-89765145dc06", "User", "suzettetocao@gmail.com", false, "SUZETTE", "TOCAO", false, null, "COMPLETANO", "SUZETTE TOCAO@GMAIL.COM", "TOCAO.SUZETTE", "AQAAAAIAAYagAAAAELGOAEmzAzR+vR0djrCk+kEa1QC6iLg6UJeNaiUaskcv5sckxiCOg7Ox3VSRLln6jw==", "09219908520", false, null, null, "b67cb7df-806d-4d2a-85e8-22d5b9cc02d5", null, false, "tocao.suzette" },
                    { "2ec1e24b-50c6-48b7-8e9c-18c64a42e172", 0, "d6fabbdc-2367-42dc-b4bb-98e204aa9cc8", "User", "ashmatik23@gmail.com", false, "ASWARFY", "USMAN", false, null, "MOHAMAD", "ASHMATIK23@GMAIL.COM", "USMAN.ASWARFY", "AQAAAAIAAYagAAAAECIvWyBUMA4BTQO65ARZDiLiWq7Y9bsSPNrHubCE7kAiuU8ZG3JBOY0jG6ZJXWEYIQ==", "09173383890", false, null, null, "19342fb7-f891-438f-87da-4577fbd5b9c3", null, false, "usman.aswarfy" },
                    { "2z9f8451-1n19-4b50-8432-4e23c164cs51", 0, "fcb94950-aaa3-4924-9c63-f31a2291c5a8", "User", "Caoagdan1234@gmail.com", false, "Socorro", "Caoagdan", false, null, "A.", "CAOAGDAN1234@GMAIL.COM", "CAOAGDAN.SOCORRO", "AQAAAAIAAYagAAAAENiGkNLGn+l87NAATeaDySt2S7KDIpS3EW4xkQT84OGbxqKANTHSxGesVEyNmh3qYw==", "", false, null, null, "998fff33-75e4-422c-b4fc-595985073a15", null, false, "caoagdan.socorro" },
                    { "33a13c76-041f-4d68-8f67-41b7dd60c408", 0, "cf174ac5-9806-472b-aa80-7db837912c74", "User", "henesijesmundo27@gmail.com", false, "HENESI JEM", "ESMUNDO", false, null, "GAUDIANO", "HENESIJESMUNDO27@GMAIL.COM", "ESMUNDO.HENESIJEM", "AQAAAAIAAYagAAAAEDuI/0v9QUT3SN/wqResCM2pXcNYQX6ZXoeTUNN1UZ5fjpDGFz5dh5zkcPVV5tuoaA==", "09354975202", false, null, null, "eac41ac6-d8e2-4aeb-b77d-7a2d377721b4", null, false, "esmundo.henesijem" },
                    { "35159a7c-2120-46f6-9135-8a8469b9c7b1", 0, "2dd079dd-29b4-4438-a16d-e7c4aa29f1d1", "User", null, false, "JOBERT", "CASTILLON", false, null, "ARMADA", null, "CASTILLON.JOBERT", "AQAAAAIAAYagAAAAEK5isiAs+eOEVVa2bbJ5CLGII4hbG19l2WdSQStIc6xRE8x+oUt0pX91qPnRzG63cA==", "09395055897", false, null, null, "fe322db4-a1c6-44a8-ad23-5b0630b0d9ae", null, false, "castillon.jobert" },
                    { "39987409-6b12-4a73-a9a3-61c7f117dcab", 0, "71fb74d3-f455-4f81-a8c6-58ba9c212c41", "User", "claurencevasay@gmail.com", false, "CLAURENCE", "VASAY", false, null, "ACHAS", "CLAURENCEVASAY@GMAIL.COM", "VASAY.CLAURENCE", "AQAAAAIAAYagAAAAEMZ5HLbk1OIg16Up/90vaYXJKMzlO91XEMmTph9aVgAm+TQWFzBt/1nxQ8diErPZ+w==", "09555765345", false, null, null, "24944bbb-9135-4fa3-b1e2-3614a8c1a4d5", null, false, "vasay.claurence" },
                    { "399f5e43-93d8-4a28-b113-d23eccd2ea15", 0, "5807ecfc-b4fb-4440-843c-7eae110487e4", "User", "npmangansakan@rocketmail.com", false, "NORHAN", "MANGANSAKAN", false, null, "PIANG", "NPMANGANSAKAN@ROCKETMAIL.COM", "MANGANSAKAN.NORHAN", "AQAAAAIAAYagAAAAECVAqvi0/kug4cBeFWUJyD176aRK/llXGRFmlDgM/JkZZ0oIv2SWsZkJmgJesII+cA==", "09166629909", false, null, null, "28735581-c931-41e5-8038-2e3419d5b5c1", null, false, "mangansakan.norhan" },
                    { "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1", 0, "34bfe6e5-2dbe-4086-b516-67371813f570", "User", "leyn0426@yahoo.com", false, "AILEEN", "GUMAPAC", false, null, "SANTIAGO", "LEYN0426@YAHOO.COM", "GUMAPAC.AILEEN", "AQAAAAIAAYagAAAAEBkuG2dwlq9oCgjXc8PZwp2Ln6T9cKE1iLYO3vwgPV5HpRaI+5Lj5r6Qz5JzTgAPbA==", "09274449665", false, null, null, "f2496849-ac23-4dbd-bcf2-bc80ecd3c4a9", null, false, "gumapac.aileen" },
                    { "3db6b5af-4b42-4747-a3f0-3a60b3e36a56", 0, "60227aa7-e25f-40ed-a54a-6ad91bdcd7c4", "User", "omaldetj9@yahoo.com", false, "TERRY JANE", "SAPI", false, null, "OMALDE", "OMALDETJ9@YAHOO.COM", "SAPI.TERRYJANE", "AQAAAAIAAYagAAAAEPYblxG47GzWq6pKFRQY3wWCRkDUp642PmG5xeOpiMmYOiWFDBadXsYfk48B+IltXw==", "09458244916", false, null, null, "5f81d356-ade4-42c6-b46b-bf09a3fbdd5e", null, false, "sapi.terryjane" },
                    { "43cd6e17-9d86-4cb9-8d84-298e43a23450", 0, "9de0c519-678b-4a38-9b04-faaf856c6f97", "User", "jesryll.tupas@yahoo.com", false, "JESRYLL LEANA", "FACTORA", false, null, "TUPAS", "JESRYLL.TUPAS@YAHOO.COM", "FACTORA.JESRYLLLEANA", "AQAAAAIAAYagAAAAEFR0EoT4IRSHuNax9oNtyRnpyeOPsAcTnITxNIsS/MqO/6MItaerRjQ12Bf2g2TeaA==", "09176111210", false, null, null, "c16ca92c-80dd-4e0e-8b15-642abe9fb186", null, false, "factora.jesryllleana" },
                    { "43f6a708-995c-4a07-9e90-6d0a5efc32d5", 0, "0cd5096a-c39a-438c-bfe3-576f2d2f5a7d", "User", "baiyasminjaynonjuanday@gmail.com", false, "BAI YASMIN", "JUANDAY", false, null, "JAYNON", "BAIYASMINJAYNONJUANDAY@GMAIL.COM", "JUANDAY.BAIYASMIN", "AQAAAAIAAYagAAAAEH5ZrEx8SsmAO3ojE61CyOBdSO+JMriMnQGp9WBsdNC6cfQkUnUc7TVYdETYv3WWVg==", "09260474812", false, null, null, "46e0a463-c791-49ae-a988-619f2b717e97", null, false, "juanday.baiyasmin" },
                    { "49180f4a-cbe7-489b-8fd1-901e79dfe2f5", 0, "694f2c62-0565-4e6c-9b28-21aa0c67eb49", "User", "sacamaglangit.md@gmail.com", false, "SITTIE ANEZA CAMILLE", "MAGLANGIT", false, null, "AMAD", "SACAMAGLANGIT.MD@GMAIL.COM", "MAGLANGIT.SITTIEANEZA", "AQAAAAIAAYagAAAAEBZL2uPUNVhBAD9aqJ7NNC520/y+/Tks4A4OJZYXe+y7PyJaurxUV/J4SYILWrNixg==", "09989913196", false, null, null, "66157834-fc87-4132-b91f-fb5079aa1d95", null, false, "maglangit.sittieaneza" },
                    { "4f5b9c31-d406-4036-b8cd-37cb92d6b211", 0, "12de7236-4e14-4025-986e-02f182fffdae", "User", "yashou_07@yahoo.com", false, "YASSER FARID", "ANDAL", false, null, "MAMA", "YASHOU_07@YAHOO.COM", "ANDAL.YASSER", "AQAAAAIAAYagAAAAEJbQxH2TNt+duTYRySkIPgBdpRX2IoJbz+BEwBDhiNkV2yRxjg0aU3hxV3y8J0OX1Q==", "09173085559", false, null, null, "748ddaf6-f5b3-42d1-b287-59909083ad6f", null, false, "andal.yasser" },
                    { "50e3ff41-8195-4d52-805a-d55efb68f08a", 0, "81afbad6-cf6b-4002-9a7d-f8f23082bc66", "User", "lienocius@gmail.com", false, "NEIL ALFONSO", "SUICO", false, null, "VIRAY", "LIENOCIUS@GMAIL.COM", "SUICO.NEILALFONSO", "AQAAAAIAAYagAAAAEEuQokChiA/bmKCTHnzwgVfssKcpVhfCHcw7AZrsHO3ggpgC97VHe/J3Bn7/ulauLQ==", "09260398619", false, null, null, "65228f2d-db89-4957-9db2-39508140d1cb", null, false, "suico.neilalfonso" },
                    { "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b", 0, "e6439946-5b6b-4c80-a9d0-078ae749c2be", "User", "naughty_candao@yahoo.com", false, "ABDULBAYAN", "CANDAO", false, null, "BAYAO", "NAUGHTY_CANDAO@YAHOO.COM", "CANDÃO.ABDULBAYAN", "AQAAAAIAAYagAAAAENFYMlOh3tREXjHAeujWRUAsUWiWIKlM4ZgyxPDXTQ0KQFJKGQ8D1k7UiRrtGSiGYA==", "09564021897", false, null, null, "bcc07adf-6adb-4816-bdd2-bda2227d938d", null, false, "candao.abdulbayan" },
                    { "53ac9d08-f52f-4a25-92d7-10de53f612fa", 0, "fc3e06c4-38c0-4c74-98b3-8078e6a08a58", "User", "rodelynmartinez619@gmail.com", false, "RODELYN", "MARTINEZ", false, null, "CORTEZ", "RODELYNMARTINEZ619@GMAIL.COM", "MARTINEZ.RODELYN", "AQAAAAIAAYagAAAAEB/TwoJXEq7FNxfpKIGl+liuMwgJIr1VEHV9FF/Jnm/cf21f4fHsB/4HI38gQw7MDw==", "09177188038", false, null, null, "52f2fb28-be83-416f-b999-cc2a48511b93", null, false, "martinez.rodelyn" },
                    { "55c79a0c-4f48-472f-9d13-1801e2e5c167", 0, "d4973fe7-b061-4606-bc8a-1bcddf71a64b", "User", "janesuperales27@gmail.com", false, "MARY JANE", "SUPERALES", false, null, "ORTEGA", "JANESUPERALES27@GMAIL.COM", "SUPERALES.MARYJANE", "AQAAAAIAAYagAAAAEGHJv3s0rT2VpyE8U09f0TLAybcTOFG11Nfi+z7d2khnCh76BKbhKAQvxnXWGZbzQQ==", "09162424748", false, null, null, "d2bb80c2-36e8-48c5-be66-298c5ef8a435", null, false, "superales.maryjane" },
                    { "56731842-6b12-9a46-k9h2-61c7f212hyex", 0, "36a9ac51-2144-440b-9e70-0d6f223981cf", "User", "Silvestre1234@gmail.com", false, "Chrislen Lee", "Silvestre", false, null, "C.", "SILVESTRE1234@GMAIL.COM", "SILVESTRE.CHRISLENLEE", "AQAAAAIAAYagAAAAEKWc6JRqwcHLofpltukvYHl3Khr/pAz0FQNrzwObxDiXWh0hLEKdF22WxK2/mCGRgQ==", "", false, null, null, "a44c82f6-61ac-481b-920b-2085a32ecb20", null, false, "silvestre.chrislenlee" },
                    { "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b", 0, "b48037f4-66e9-4011-b7ac-39c8c636ca42", "User", "jomedellesampulna13@gmail.com", false, "JOMEDELLE", "SAMPULNA", false, null, "CHIO", "JOMEDELLESAMPULNA13@GMAIL.COM", "SAMPULNA.JOMEDELLE", "AQAAAAIAAYagAAAAEFBnQcmhGNqUyKjNa7jZjB3uSMuRZpJP3LxDAXShfs3ufb+wC45sq4PXyUYT3oPO4g==", "09673774366", false, null, null, "53692d29-0b11-443f-8429-f2f9b1da1aac", null, false, "sampulna.jomedelle" },
                    { "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f", 0, "e22ef712-5915-4934-b570-1a47290eb102", "User", "hor_he@yahoo.com", false, "JORGE", "PADILLA", false, null, "LAMPITOC", "HOR_HE@YAHOO.COM", "PADILLA.JORGE", "AQAAAAIAAYagAAAAEP79FyIAWXLWU4jUWdLKZurQzTIRuFIQ86xwZU+9SjOLu6dXk4JNvN9D7J9ZBswoWg==", "09177900470", false, null, null, "b5a6cbc0-cf3a-4426-a943-1e187a5ab924", null, false, "padilla.jorge" },
                    { "5d8a2197-b38b-40b2-940a-845e2a44b622", 0, "d69f4d20-3095-4ed6-81fc-4fa38f60db28", "User", "resildago1212@gmail.com", false, "RESILDA", "GO", false, null, "BAGGAYAN", "RESILDAGO1212@GMAIL.COM", "GO.RESILDA", "AQAAAAIAAYagAAAAEKuggGDwvxRwZLSC8LPri0pXhvF17IlYii0Zi4Nor6SM6mh60arQ+vRIbf0QSe5VKw==", "09062249400", false, null, null, "f109917d-6532-45fb-8860-6f8f5c2af0c2", null, false, "go.resilda" },
                    { "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d", 0, "b0eb0232-637e-48d9-892b-772f3c9f7db6", "User", "jettFTS@gmail.com", false, "JARRETT", "SABRINE", false, null, "DORONILLA", "JETTFTS@GMAIL.COM", "SABRINE.JARRETT", "AQAAAAIAAYagAAAAEJQU57Hf7uC/a4X8kYOdPEQhv0xgN44+SX43atzE0ii81oEj8xPzM5+CIoC0gX2CLg==", "09162012248", false, null, null, "0fac5428-612d-4ed7-9fe1-ece982dd19bc", null, false, "sabrine.jarrett" },
                    { "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621", 0, "2678eb15-232e-4cf0-8afb-d6d7267b37fb", "User", null, false, "RENANTE", "ARIAS", false, null, "ZIA", null, "ARIAS.RENANTE", "AQAAAAIAAYagAAAAENrsAu0qooG4jQiXcxAMyo5dPGmhUp2o8ucahKgGTkjoIBc8lxS0yFEhPEMclnNJmw==", null, false, null, null, "5c1d7149-216b-4933-b622-ebae7cfea69f", null, false, "arias.renante" },
                    { "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55", 0, "07447f50-e860-4ddc-8c62-022ef96ac917", "User", "rosarioalojipan@gmail.com", false, "ROSARIO", "ALOJIPAN", false, null, "DELA CRUZ", "ROSARIOALOJIPAN@GMAIL.COM", "ALOJIPAN.ROSARIO", "AQAAAAIAAYagAAAAEIDMTf0w1XgTzaSK8gQE/b8Mr9FTey64HTUUoe0eqrnJzJegNgS00SRpmvnKWxkFtg==", "09178202970", false, null, null, "672fa9e0-6ce9-41a8-9dac-8fbce03c5ead", null, false, "alojipan.rosario" },
                    { "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71", 0, "2052b6f5-4e55-4816-92d3-9eab3b12204a", "User", "anidaabubakar5@gmail.com", false, "ANIDA", "ABUBAKAR", false, null, "PENDALIDAY", "ANIDAABUBAKAR5@GMAIL.COM", "ABUBAKAR.ANIDA", "AQAAAAIAAYagAAAAEFWL68MzmuohKqkxoMDKK5FHCx9qxGRW75YGJfd2Yvz7Qw1c8v9k3WgBAMD+Sog9Ew==", "09177234338", false, null, null, "974ffd89-2e16-4f6f-8e8b-2566ac598f37", null, false, "abubakar.anida" },
                    { "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8", 0, "23b18bf3-e703-433a-aad2-c03b1bf72f80", "User", "farizahm@yahoo.com", false, "FARIZAH", "MAMALUBA", false, null, "MODIARAT", "FARIZAHM@YAHOO.COM", "MAMALUBA.FARIZAH", "AQAAAAIAAYagAAAAEJn/LT1Yx2tqAihF+cP4lUlCC/nB6lHO68UxVZVld17YERcJISXS8ECDMdcwwcL7DA==", "09168372024", false, null, null, "b4f0f097-714c-4aeb-ac24-caba2ba0d9e7", null, false, "mamaluba.farizah" },
                    { "74c35794-54d9-44a4-baf0-b8fa23e2d481", 0, "b558df9b-85e9-4129-bb74-8058822211f9", "User", "Mulcaldea@gmail.com", false, "MAYLENE", "CALDEA", false, null, "ULOG", "MULCALDEA@GMAIL.COM", "CALDEA.MAYLENE", "AQAAAAIAAYagAAAAELs8Ud20Ly2HaRJVeWvP5+DhjWUAR5QaT4PXW4QgVWWdC6yq3dr8bFEUPKFndAib5A==", "09953048269", false, null, null, "17d1b548-b591-4e39-9773-33b030e7b55a", null, false, "caldea.maylene" },
                    { "7cfd0766-f3d3-47aa-9a48-53d437d6c232", 0, "b4133ad7-a183-4f24-9e75-2829b0faf2ec", "User", "wahidamaniala@gmail.com", false, "WAHIDA", "ZAMAN", false, null, "MANIALA", "WAHIDAMANIALA@GMAIL.COM", "ZAMAN.WAHIDA", "AQAAAAIAAYagAAAAECJlaU3HSTRDJzCHjzOCxT8i+f1n/+TU7PdmF6Ux85On4RTpK/fCAGNEcHpfmTtatg==", "09065830887", false, null, null, "c16737b2-162e-419c-b370-e89655210c4a", null, false, "zaman.wahida" },
                    { "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68", 0, "0c0b564a-64f9-40fe-b020-958ac868dfd8", "User", "saliling1234@yahoo.com", false, "Floredliza", "Saliling-Alta", false, null, "J.", "SALILING@YAHOO.COM", "SALILING.FLOREDLIZA", "AQAAAAIAAYagAAAAEP5vLxrl7lqUvdBhSsBVFMZFQIj/VNJm87la/fi/AB6sKp6sQOoLe0XueSj3bLcb1A==", "", false, null, null, "3e23b8be-2de8-4f1b-bb8b-7574ae44e0a3", null, false, "saliling.floredliza" },
                    { "827e71e5-479c-47a7-8f91-16327825a02d", 0, "436a6eaf-81c9-439d-8c0c-239c17c67d27", "User", "faridaolama@gmail.com", false, "FARIDA", "MEDITAR", false, null, "OLAMA", "FARIDAOLAMA@GMAIL.COM", "MEDITAR.FARIDA", "AQAAAAIAAYagAAAAEIPpcXj0wK822el4P+0/9nqHlWT6+QP7X0i/xVkoa7D8tsJ3hQECcVWhDmrLF3U4WA==", "09606059079", false, null, null, "fa3e2d2b-177f-4c14-b950-c66b03c0399d", null, false, "meditar.farida" },
                    { "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8", 0, "3c451fd2-b2c6-4b6d-bec8-b050e47c722f", "User", "hamidadubali@gmail.com", false, "HAMIDA", "USMAN-BALI", false, null, "DATUMANONG", "HAMIDADUBALI@GMAIL.COM", "USMANBALI.HAMIDA", "AQAAAAIAAYagAAAAEKAwgEwpZKhKSsavdB5I69m20gJJPJ1mBX6mpVxJqg5/WGENbzGWvFUjSgNu1t7mGw==", "09368159393", false, null, null, "c42a6d6d-7db6-4bcd-95b9-934ee139d665", null, false, "usmanbali.hamida" },
                    { "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4", 0, "64629c65-3975-4b28-ae15-eb150b9edb00", "User", "tardz03@yahoo.com", false, "GERALD", "SORIANO", false, null, "VEN", "TARDZ03@YAHOO.COM", "SORIANO.GERALD", "AQAAAAIAAYagAAAAEBi7OKEQjNEu2qrHym419m6qhcYARBWULklBAgs+kWgWe96iJRvgE7s2rsukHVzIPA==", "09224339675", false, null, null, "c80c4c75-3cf6-4486-a6ef-5f3cf90777d8", null, false, "soriano.gerald" },
                    { "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9", 0, "21cbd068-d147-4e48-9c79-eb0f62bb7e78", "User", "dannyfherbantilan@yahoo.com", false, "DANNY FHER", "BANTILAN", false, null, "BANQUIAO", "DANNYFHERBANTILAN@YAHOO.COM", "BANTILAN.DANNY", "AQAAAAIAAYagAAAAEGd4KfTJUb1TFuI0z1ThAdfaEFf3pNrnwmxMxpEgC3yvpgKVW6fkRBpKLsrXymzYqw==", "09272727645", false, null, null, "6d420538-ce2b-4636-ae65-e2d93277e069", null, false, "bantilan.danny" },
                    { "969fb51f-26aa-4637-8a8a-96247c7a67a4", 0, "fc9af9ae-a266-4da1-8d9f-aff5da4d06d9", "User", "hasmiamdo@gmail.com", false, "HASMIA", "OMAR", false, null, "DATUMANONG", "HASMIAMDO@GMAIL.COM", "OMAR.HASMIA", "AQAAAAIAAYagAAAAEC1Q0gu1xtZtM9V8vPM5SMzi1Pas3MntYbhbeqQskprGpzN6h+w537A3HovJ5VNsMw==", "09365268695", false, null, null, "802073e2-9c6d-4eb1-8d7e-2c1195c9e462", null, false, "omar.hasmia" },
                    { "9821dbf5-0f70-4630-8c68-f2077a3abf08", 0, "952b8f6f-40a3-45ce-bd26-fc21054e4a7f", "User", "ZAMBRANO.REHABMD@GMAIL.COM", false, "JHOANA MARIE", "ZAMBRANO", false, null, "JUANEZA", "ZAMBRANO.REHABMD@GMAIL.COM", "ZAMBRANO.JHOANAMARIE", "AQAAAAIAAYagAAAAEGYu3luikJHdLxZ/lypEPzq5Xns3MWlIMhc0ucAP1GQ7cYwk3EXQ8Cy02dGQE0CZQg==", "09178470437", false, null, null, "381fe292-3c1f-45b5-9ed2-bc8e20dcf9ce", null, false, "zambrano.jhoanamarie" },
                    { "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1", 0, "c49b1df3-e808-40c4-b4be-dbbb6585be36", "User", "madz.karao@gmail.com", false, "MOHAMAD", "KARAO", false, null, "DUMBI", "MADZ.KARAO@GMAIL.COM", "KARAO.MOHAMAD", "AQAAAAIAAYagAAAAEEjru/VbRPXcqZR8cFlDHQLk5BktlAkNjss1BN2+p67TwG2amwEIoiyTsOetNy9fjg==", "09363769315", false, null, null, "4451a110-e106-4487-bc39-e4eac26f80fe", null, false, "karao.mohamad" },
                    { "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368", 0, "bca8d52b-04a0-4af8-bddf-72372b3c9c63", "User", "graceenlayo@gmail.com", false, "HONEY GRACE", "ENLAYO-APA-AP", false, null, "ROMASANTA", "GRACEENLAYO@GMAIL.COM", "ENLAYOAPAAP.HONEYGRACE", "AQAAAAIAAYagAAAAEJum4ZK1eSPWFyLjIK/5ts5SBnf1h4zwuMTpm8z/+E7H8h0Tm3ummkObdoKEsMxJ+A==", "09754948544", false, null, null, "0438b835-a545-476d-989a-c4cdf6f0f350", null, false, "enlayoapaap.honeygrace" },
                    { "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b", 0, "f8356d55-da11-4eac-97b5-fa78685bedd2", "User", "lailakaliaagting@gmail.com", false, "LAILA", "AGTING", false, null, "KALI", "LAILAKALIAAGTING@GMAIL.COM", "AGTING.LAILA", "AQAAAAIAAYagAAAAEHj6qeNwfG+aGfsqvUMAOn5IEHZIKVB1ywaJLx4r5FXVHhcSpJIn3Nu6lDeY84NzDg==", "09177124579", false, null, null, "2228642e-2911-4582-8912-eaf3965d6c2e", null, false, "agting.laila" },
                    { "a1e10c26-4d1d-4f9e-9378-1382457c82ad", 0, "d27adb38-6100-4884-8770-39376562eb96", "User", "beeyoupee@gmail.com", false, "BAITAYAN", "PINGUIAMAN", false, null, "UNTONG", "BEEYOUPEE@GMAIL.COM", "PINGUIAMAN.BAITAYAN", "AQAAAAIAAYagAAAAEAxCDfuZ7HlKI1hhMc4+CFebX0KsW1AdzYCBxMV0vlE8zO+rM0B472gOc2pSRGw8YQ==", "09056377715", false, null, null, "9bd2d794-2ea5-46ff-b644-8a7d13a85847", null, false, "pinguiaman.baitayan" },
                    { "a1f6d353-df11-4a17-b2be-49371b8c223d", 0, "9bebc693-3a20-42bf-91f5-f503b5584006", "User", "don_astillero@yahoo.com", false, "ADONIS", "ASTILLERO", false, null, "CHAN", "DON_ASTILLERO@YAHOO.COM", "ASTILLERO.ADONIS", "AQAAAAIAAYagAAAAEAB7xVIOIudoF59eA9m5USg3cB776ZdolPZRDVGQv6dC+Xmrd3ipVDRuRsfISSCjqg==", "09176261812", false, null, null, "f147d502-6b8a-4457-99fc-09fc90f1b8b3", null, false, "astillero.adonis" },
                    { "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e", 0, "4646de18-a5ce-4dab-beae-27b1f1c60863", "User", "mabangsigrid@gmail.com", false, "SIGRID", "MABANG", false, null, "BARAGUIR", "MABANGSIGRID@GMAIL.COM", "MABANG.SIGRID", "AQAAAAIAAYagAAAAEMomuabOxthIQSwi4KOLRktQxj3JIF9DeZm0PZ6+oXIO/ADOV2RLmt69ZhAVw3dlbA==", "09351488175", false, null, null, "a7cd0fe1-83ca-4561-b104-669a3e7242d9", null, false, "mabang.sigrid" },
                    { "a6b59fd2-75eb-457e-90ea-d1d419da5f6d", 0, "ff3792db-be0e-41ac-aa5b-750e8c7f5dae", "User", "hunnyresquites88@yahoo.com", false, "HONEYLET", "MANGULAMAS", false, null, "RESQUITES", "HUNNYRESQUITES88@YAHOO.COM", "MANGULAMAS.HONEYLET", "AQAAAAIAAYagAAAAEI2WgOgLuNHTW90ST1SiLsLjNNyUd5WJFscAMS7zw/4AsVFEyoUJTkJuXOPFWn7bqg==", "09776146365", false, null, null, "600e77cc-dec2-468b-b11a-bb7d6512754c", null, false, "mangulamas.honeylet" },
                    { "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83", 0, "4f222a74-ca19-4a21-b485-3a95c2c88ee6", "User", "ruby012770@outlook.com", false, "RUBY", "VILLANUEVA", false, null, "ELEVAZO", "RUBY012770@OUTLOOK.COM", "VILLANUEVA.RUBY", "AQAAAAIAAYagAAAAEBAF2R6Qv040uDr9kFezjzI2ZnT4E8BZQq3tMddfMAmMVGo08mTjAWO3BGiKZe5VvQ==", "09173510613", false, null, null, "a2f67f5b-d414-452b-a11b-ab6483016a42", null, false, "villanueva.ruby" },
                    { "b4d73e5f-f530-4a4d-9c3d-0b364236da6f", 0, "022dd6be-0bb8-4d3a-be8f-541379ea087b", "User", "jrbedol@gmail.com", false, "LINTANG", "BEDOL", false, null, "BUAN", "JRBEDOL@GMAIL.COM", "BEDOL.LINTANG", "AQAAAAIAAYagAAAAEANp908Fr3H4L4sCyMhwCzM9Ow3I9Vkp8A7oJOkibmDkj1dzyq9DJM7TTKw1b4RX8w==", "09226218394", false, null, null, "0fba71e4-363e-456f-8cf4-3073d20777c4", null, false, "bedol.lintang" },
                    { "b5870b06-0240-4d35-a6b1-54a76c1e09fc", 0, "517b9b5d-8713-4660-ac1a-34b2b32842ab", "User", "apple_foj@yahoo.com", false, "MARIVETTE", "ONDOY", false, null, "TABUGO", "APPLE_FOJ@YAHOO.COM", "ONDOY.MARIVETTE", "AQAAAAIAAYagAAAAEIM0FFWfuNoQArxYy5VflCoc4/lzy6sKxc7vrdhh0xvBbCeoKkyvhgIKTTDSmSmCaA==", "09177228527", false, null, null, "f221d270-8797-4888-8c32-f077d9dd6ca1", null, false, "ondoy.marivette" },
                    { "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91", 0, "55e2dd16-adfd-4be5-8f1f-fc9b6ebe9815", "User", "paogratuito@gmail.com", false, "JOHN PAUL", "GRATUITO", false, null, "CHOA KHAO UY", "PAOGRATUITO@GMAIL.COM", "GRATUITO.JOHNPAUL", "AQAAAAIAAYagAAAAEK8NH4bcBdBQONOaBQLfKbydRDuxIlKQvRgFhUFq/btUpxDuWRBtEhbpsDUdxxxu+w==", "09177027392", false, null, null, "a186f2a2-8cf1-43b0-a832-917daab45d9e", null, false, "gratuito.johnpaul" },
                    { "baf0a172-7e0a-4999-8c03-8f9bfb62150b", 0, "7d259d10-66cb-45a6-824c-9d915ebaf831", "User", null, false, "FAISAL", "SALIK", false, null, "ONG", null, "SALIK.FAISAL", "AQAAAAIAAYagAAAAEPHmmquaLzg0K9EbtOXU3vd95yMpwOgPb/3FUocihZvrTblByWmos+NpqoEDY7xOBg==", "09773262708", false, null, null, "c8954cd5-928d-4eea-b5d0-00cc5d31d7cf", null, false, "salik.faisal" },
                    { "bb22c692-bc14-44db-9a6e-5b0196c9a8c2", 0, "823d9b23-0044-4560-83ce-1cd1739b1bea", "User", "origmonaliza@gmail.com", false, "MONALIZA", "ORIG", false, null, "NOR", "ORIGMONALIZA@GMAIL.COM", "ORIG.MONALIZA", "AQAAAAIAAYagAAAAEPIRM5/pJwWApoYNooSIE50xQjG+eyWX7w5HOGTsB6X64NYGZsxoHG1VAKaC9e+OlQ==", "09274704538", false, null, null, "fad3f3e2-f882-4d27-892c-ec34250aaabb", null, false, "orig.monaliza" },
                    { "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851", 0, "e199324f-3c9b-448f-825c-3542caec8b29", "User", "jaheerhusseinismael@gmail.com", false, "AMIR HUSSEIN", "ISMAEL", false, null, "MACAPENDENG", "JAHEERHUSSEINISMAEL@GMAIL.COM", "ISMAEL.AMIRHUSSEIN", "AQAAAAIAAYagAAAAELG6/2A870OcfzRHaC9H3sfOTzVAPSsL5ADSNvEaObMKT1so9tCakPSDI7GIkySy4w==", "09564020491", false, null, null, "613194f1-585e-476c-850a-9bab1425d870", null, false, "ismael.amirhussein" },
                    { "c171e56e-b2e0-43f2-91f1-8f258417bc3d", 0, "f7f25734-3ee3-4ed2-a265-e8e35f441c90", "User", "shingdumama@gmail.com", false, "SHARINAH", "IBRAHIM-DUMAMA", false, null, "CATALAN", "SHINGDUMAMA@GMAIL.COM", "IBRAHIMDUMAMA.SHARINAH", "AQAAAAIAAYagAAAAEOXf5KNq3aFBqxkvJYHkvaynI59LZFZ1NqcDrdsvYdf0fTRo4heyUP0IX0NqbzX/WQ==", "09177263399", false, null, null, "98edbd85-ddf2-401b-ba52-9bd95c5269c9", null, false, "ibrahimdumama.sharinah" },
                    { "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de", 0, "4a0bbbb0-aa43-4270-ae27-def4ecc37218", "User", "bashegal23@gmail.com", false, "ALIBASHER", "ADANG", false, null, "ABO", "BASHEGAL23@GMAIL.COM", "ADANG.ALIBASHER", "AQAAAAIAAYagAAAAEEuVB8Wk/6+E1fqnEXKsCvL1gasa4OA0nkivCzT7YCg/UOIORNQOF7N1sggBnb6drg==", "09369833653", false, null, null, "9dc16bc3-0506-4381-bfe9-369564917ba9", null, false, "adang.alibasher" },
                    { "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074", 0, "24a087de-e176-442c-8f3d-2f480763e352", "User", "cherfer22@yahoo.com", false, "CHERYL", "FERRER", false, null, "MAGBANUA", "CHERFER22@YAHOO.COM", "FERRER.CHERYL", "AQAAAAIAAYagAAAAED7Os4fcRr4Un5L5JDPnWghAcVc/e4cI4ZIKW+TI26If9MKGz/9kE/1ia29uAq0uWg==", "09276048113", false, null, null, "438a9cbc-e979-4fb6-b9e9-ccad69ebff45", null, false, "ferrer.cheryl" },
                    { "c79be729-47b3-4907-88e1-0a67dd4e48b1", 0, "6949a223-271d-4af7-b021-9f0de9b90fb3", "User", "zahidabationgbassal2018@gmail.com", false, "ZAHIDA", "BASSAL", false, null, "BATIONG", "ZAHIDABATIONGBASSAL2018@GMAIL.COM", "BASSAL.ZAHIDA", "AQAAAAIAAYagAAAAEJi7DCx5EQJvicWfW/9d9XHqOHIzX0VWhfULZ2KlBSqTyA9SzsQhqK12h3jXSOO1Gg==", "09161012599", false, null, null, "474ea592-9d37-4dde-973c-03a091625505", null, false, "bassal.zahida" },
                    { "c79c6433-d1ad-46a3-ae87-84edb44476de", 0, "bbe301bb-0781-4803-bd46-d523c3d662f0", "User", "rendtesy0620@gmail.com", false, "RENETTE", "GONZALES", false, null, "SUDARIO", "RENDTSEY0620@GMAIL.COM", "GONZALES.RENETTE", "AQAAAAIAAYagAAAAEHDl5ZTxICAd6DewM4wjo8bLWzQVYv+rgDw4OjRiFGKhBUM38bGhqjEs5iL/W2HC6A==", "09166248783", false, null, null, "d15d1eb2-b4ed-4141-af55-c1250ab2ce25", null, false, "gonzales.renette" },
                    { "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4", 0, "b4d15500-d065-4c13-837a-6034586f040b", "User", "holy_voltz771989@yahoo.com", false, "RUSSEL KIRK", "VILLA", false, null, "GUALINGCO", "HOLY_VOLTZ771989@YAHOO.COM", "VILLA.RUSSELKIRK", "AQAAAAIAAYagAAAAEGYbZUo2USNS1dxcvey2STZDC1UDmQYGcz2JXvB09xZ5VVnHKKTS6YiKxgW7/JnW5Q==", "09095412351", false, null, null, "f447a576-aa4a-4898-9f45-ce8177f8d01f", null, false, "villa.russelkirk" },
                    { "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f", 0, "f7654686-263a-4b03-80f7-6682e8ac76c4", "User", "rbmaputi@gmail.com", false, "ROWENA", "LU", false, null, "MAPUTI", "RBMAPUTI@GMAIL.COM", "LU.ROWENA", "AQAAAAIAAYagAAAAEKId0kFtElCOybo0NbC+ljgQYhOKGaEBJed+6NHA1IOA9e+v85JSz8duTNVukKkM6g==", "09173000155", false, null, null, "be6303fc-5669-4cf0-9e37-0ce96ddd785c", null, false, "lu.rowena" },
                    { "cc505df2-3586-41a1-9d44-b5fc8f28e3a9", 0, "43f7d7c7-675e-43f8-9198-a1b07aa30049", "User", "shiedhe@yahoo.com", false, "SHIEDHE", "BANGEN", false, null, "KEMBUAN", "SHIEDHE@YAHOO.COM", "BANGEN.SHIEDHE", "AQAAAAIAAYagAAAAEGmkkrONMKucNmqmuhmJNFhB53LG992aI3V/GOGtcX9cTNK+IzzHfpg6go8NHLmmrg==", "09396526665", false, null, null, "6ad6b38f-5764-4d20-924c-8a5d12d504c9", null, false, "bangen.shiedhe" },
                    { "d65e3f58-b23d-4b83-8b15-15e66565d29f", 0, "77c1d0e4-b42a-4065-a802-32ce7875fcb1", "User", "shpagayao@gmail.com", false, "SANDRA", "PANTARAN", false, null, "PAGAYAO", "SHPAGAYAO@GMAIL.COM", "PANTARAN.SANDRA", "AQAAAAIAAYagAAAAEDtnDJYSYW3pZZ+5YM0eM46cugvHKj+EyjDJ9X2CtppfseCy2BAzgF+F/RnSbXsBPQ==", "09163771505", false, null, null, "b7598033-fb73-4631-a6d9-da74e2f06e0b", null, false, "pantaran.sandra" },
                    { "db7fba3d-88fc-47cf-b119-f868d9196f02", 0, "026ccbc3-2ee3-4fad-a450-973c201ff2e3", "User", "ronfaith2003@gmail.com", false, "RONNIE", "VILLAROSA", false, null, "GREGORIO", "RONFAITH2003@GMAIL.COM", "VILLAROSA.RONNIE", "AQAAAAIAAYagAAAAEGuugtDJarNy28/cNTQUlxamt4GsityXJYBCF+tvgrAipKdtAGlwhdpvMawV6PVqPg==", "09956598896", false, null, null, "8bd1bbd0-0a32-4e7e-aef6-a73191127667", null, false, "villarosa.ronnie" },
                    { "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e", 0, "5a9a0477-f9a8-434e-91d1-1e1b46619c76", "User", "jayjay_malana@hotmail.com", false, "JAY-JAY", "MALANA", false, null, "MALANNAG", "JAYJAY_MALANA@HOTMAIL.COM", "MALANA.JAYJAY", "AQAAAAIAAYagAAAAEDpai+2x9D9z9Q6L5S+kplHdhO6Ls8qJc+mbichcNtDkOYwDoJ/ApjIitILtPLOEPw==", "09274171288", false, null, null, "a178c770-8d4b-47b1-86e2-bdfc9232e898", null, false, "malana.jayjay" },
                    { "de17cb47-83e7-4a6b-b97c-13808e14a7ff", 0, "16b8eb8d-84a7-4a6b-8a07-ae02d86ce42c", "User", "acocalbo@yahoo.com", false, "ANABELLE", "BONES", false, null, "COCAL", "ACOCALBO@YAHOO.COM", "BONES.ANABELLE", "AQAAAAIAAYagAAAAEALOAPPZg4cblPSEERyi3rjct8nNI+dPzZApXi14WxR5i9KePIpTkqxJ7NQKH0lBQQ==", "09483207824", false, null, null, "2b5c40f6-ea9f-44b8-b4d2-5b2eb0f285f3", null, false, "bones.anabelle" },
                    { "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a", 0, "6e45c65b-3e28-40d0-b21a-03b272906280", "User", "midtimbangbebot@gmail.com", false, "BEBOT", "MIDTIMBANG", false, null, "USOP", "MIDTIMBANGBEBOT@GMAIL.COM", "MIDTIMBANG.BEBOT", "AQAAAAIAAYagAAAAENOALj6WWnzrk4I/nDOcX2//wP9qFzW+Ty2Td+PMB97RPjxwoqDH3YoCp288T/TkBQ==", "09755272044", false, null, null, "f8d81af2-2134-4b24-9f93-f40feea3a98a", null, false, "midtimbang.bebot" },
                    { "dfc40941-0cfb-46ed-8991-e285aa08c20e", 0, "8965f1d7-50d7-4bb6-b1c0-155a6b984e58", "User", "quinto.jennifer82@gmail.com", false, "JENNIFER", "QUINTO", false, null, "CATBAGAN", "QUINTO.JENNIFER82@GMAIL.COM", "QUINTO.JENNIFER", "AQAAAAIAAYagAAAAEF+k8ImErn+wfN1reCLOcjd/a6mr6esIDPzzeW0SqiruW8bT6xWgoEaCtUebQWOBWQ==", "09272708149", false, null, null, "953e366e-4101-41c2-a26b-71ade66b9d23", null, false, "quinto.jennifer" },
                    { "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420", 0, "4c38de75-84bb-4456-a15b-8329b0c88ea3", "User", "nurlinda_06@yahoo.com", false, "NURLINDA", "ARUMPAC", false, null, "PANGILAN", "NURLINDA_06@YAHOO.COM", "ARUMPAC.NURLINDA", "AQAAAAIAAYagAAAAEPFoXPiuAGUMwFSi3gC2tzpDgZH2XxumOzVn3f7IgxD/Ha59qgymB1hc0mGRLIclTA==", "09177266885", false, null, null, "5f085454-ca0c-4ff9-adf5-c6046a130f28", null, false, "arumpac.nurlinda" },
                    { "ec4219b7-dfc6-4966-bf2a-3f1eecf17391", 0, "348b95b9-76fd-47e3-be3d-950ca6f4c5dc", "User", "rndmpa@gmail.com", false, "ANTHONY", "CUYONG", false, null, "CULAB", "RNDMPA@GMAIL.COM", "CUYONG.ANTHONY", "AQAAAAIAAYagAAAAEFHzbATRegIUwIZVZX1d9e1JVRh8B+wQV0Mf5P0sqmwsbTcE969PampAuV/jpiK4jg==", "09453040405", false, null, null, "64a68eb0-1fa7-4b7e-a1ac-227b4f95afee", null, false, "cuyong.anthony" },
                    { "ef529a6b-b381-4db1-a204-913ba73a6721", 0, "ef996f9c-87cb-4072-960c-50ac0bcf0c84", "User", "iamarielolivo@gmail.com", false, "ARIEL", "OLIVO", false, null, "MELOCOTON", "IAMARIELOLIVO@GMAIL.COM", "OLIVO.ARIEL", "AQAAAAIAAYagAAAAEBHmZ85TeeYPodOPIuPVOqsxP6L+fvUID61IzNu0YD3W8AxeOiyKkvl2CM1KnzOizg==", "09084724708", false, null, null, "775b29fd-03e9-46c7-9dd8-e6f39731d30f", null, false, "olivo.ariel" },
                    { "f03cf528-c2a5-4820-91a5-6821dc5350f8", 0, "0f2f3b85-9e86-4e93-b910-4beba1c20433", "User", "espurakoy@yahoo.com", false, "GABRIEL", "SERO", false, null, "BLANCO", "ESPURAKOY@YAHOO.COM", "SERO.GABRIEL", "AQAAAAIAAYagAAAAEBwCny9mxlNq0gbJ2yBcAWZ6oXm2gRqfZY39LHvD3AMwHJP6MGGh2LcUps+aRbWtQQ==", "09177239443", false, null, null, "750ee88e-1ccf-4fd3-bc28-0aa9699cec65", null, false, "sero.gabriel" },
                    { "f23ac0c6-68ac-41c8-94ff-383acbfc3e41", 0, "18eb6bbf-dd3d-40a7-b691-1b25868d211c", "User", "estrellavsreal@yahoo.com", false, "VIVIAN", "REAL", false, null, "SARATAO", "ESTRELLAVSREAL@YAHOO.COM", "REAL.VIVIAN", "AQAAAAIAAYagAAAAEN3yCOp7OZlCKVGYR64D9q3QLKNVqRCBPQXTi6XLrRPd8R6mhSyZUkipHoPcBMoATQ==", "09171027173", false, null, null, "37bf1688-2e0f-4248-a451-9680b8d4e5e1", null, false, "real.vivian" },
                    { "f2b28c8e-58cf-47b2-8245-33a7a98a7344", 0, "57cffc08-fdca-4fca-b9fd-39b56221ade9", "User", "abantasfaizah@gmail.com", false, "BBGIRL FAIZAH", "ABANTAS", false, null, "SHARIF", "ABANTASFAIZAH@GMAIL.COM", "ABANTAS.BBGIRL", "AQAAAAIAAYagAAAAEGeaJGRc7huW/Z+gc9rLfazXpJjA21v1KMirMxDy2mKWXccDJKFaRu/1eKnU/TUeJw==", "09618235949", false, null, null, "e653ec35-db62-4f8f-983c-f580ed4ae9d8", null, false, "abantas.bbgirl" },
                    { "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c", 0, "31a39294-dea8-48db-9e2b-b28beb8c6657", "User", "miemarandakan@gmail.com", false, "AMERA", "AKMAD", false, null, "MARANDACAN", "MIEMARANDAKAN@GMAIL.COM", "AKMAD.AMERA", "AQAAAAIAAYagAAAAECHfX2geb6rfEEmsUGAsyLo/PawsGMF38Hf+oR9ApTKoacmS0p6OtBOzK+Umw/d/GA==", "09560537326", false, null, null, "71f520a0-c6ff-413f-bd73-6ee10c3fd82c", null, false, "akmad.amera" },
                    { "f8a17354-91b3-4c0e-9b71-d6af05f4e11e", 0, "eac0a1eb-104a-468c-878a-b892cf3169c5", "User", "rhkadil@gmail.com", false, "RONALD", "KADIL", false, null, "HIPONIA", "RHKADIL@GMAIL.COM", "KADIL.RONALD", "AQAAAAIAAYagAAAAEE+i3OjeaRHg3OD+FUpPYvj4B1ZttIP105BMepH5qDbkjA/Ikb/u4C65/g50xarSHw==", "09175333922", false, null, null, "c32bf831-4675-4a3c-9245-b1a6f434beba", null, false, "kadil.ronald" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "67904251-3467-4eb6-9b4b-458b6027451a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "87b0bb83-3831-4924-8fd5-39367f5d30f4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "5a08fb93-cd76-4d4a-a681-4047bab74b09");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "ee376011-9f30-4ec5-98d2-8250ac9e5f57");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "f1548c47-a041-4eee-9806-48206f3d3d97");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4e51ba95-7cc9-402a-ad64-8aa75aae4ca3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "c5e67e51-bf9c-41d6-bdc7-997395606fe9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "95a14727-7113-42cf-9a5d-cd85d94b43ab");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "83696ab8-4bbc-47ce-9c30-da1d89e1acf1");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d195aba-6b3d-4f79-ba90-40fcf1e089a4", "AQAAAAIAAYagAAAAEJRhKCZjYf7Gjda8oOhJFvBIxyyN6AaovR6tS3qgAlQ0icN5WIttb2HzIgX7HfoA8Q==", "84f9122d-b6dc-4ef7-a734-ea11d2c7baf1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e88caa0-3d43-45d9-a6e0-e6b159127c69", "AQAAAAIAAYagAAAAEDOrTnFeG3XAIUnUye/QMdKLWNvsQfGS8Cl+pksVkkLxNA+yvUEo12QN/I2rXWNQuQ==", "9556fb93-dab4-43d8-a753-9af54eaf5a6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25e52971-f6a4-484c-a07d-c424a05ff17d", "AQAAAAIAAYagAAAAEPQ+ztpgh63FRCKVTAxlwBp2rBe4EzXsSTzB6U1yYAOu0yY0+ncokZ48WzztW5SGxQ==", "f88bc90e-736b-4cdf-848e-96c0b6278a12" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e5ca66d-a066-48a3-8520-51b1ec2592cd", "AQAAAAIAAYagAAAAEIGipeLF1J2ydYf4/e2TUk9Dc5oQLlRXjWMyWZJGeXRY8l0WpvNpggkVnM1ZI0B0CQ==", "03a15ff9-ff2b-4ec8-aa27-97011143de4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07428fad-9303-47e6-ba52-5ce6c76ecbad", "AQAAAAIAAYagAAAAEOm3520ndqc+smlzVpr/dDhK1ICJVCSvkOI66RxgRJkvy1pp6QJ/jOdtp9q9L8c/GQ==", "2a0cd2c0-31cc-41b7-a068-bd0c997d8b1f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06566da0-e9f3-45ea-b7f8-df36ebec0938", "AQAAAAIAAYagAAAAEEXtGzgYK1ziqPKEtLWXxEdxKwHF/ffnb0E+RZg4wMCc200CEDiBN0OmN7FIZl1BRg==", "34da5cd4-a4b5-4a5a-813f-7c36d38a7435" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fc98319f-b54a-483e-9442-72244efa174f", "AQAAAAIAAYagAAAAEDPNHL3glsdmzLH45Sv8MrNb4+3r7SoxkVK13hyKErmrPo1ZJvh9pYLUFRHdJkWHYg==", "04a88f82-80ce-43a0-a70a-b758a4fe8cad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b42acd02-b733-4759-8d61-6139e7e3f5fd", "AQAAAAIAAYagAAAAEB3fQLTE44h4LxWN4LZf8O1AtHd9iY7VrIhWgVk7opEvaDI/lI0EVQAvi0cPMCPtJA==", "1610cd42-2f22-4234-af2a-1fcc9f122ef2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "Email", "NormalizedEmail", "PasswordHash", "PhoneNumber", "SecurityStamp" },
                values: new object[] { "8f995ee3-971b-487e-8577-cad3e9ae2820", "Ibrahim1234@gmail.com", "IBRAHIM1234@GMAIL.COM", "AQAAAAIAAYagAAAAEBSFoEa18VqmJ5+7c/ASayrPzwLvJZb1x/WQR8mCMOgHWtXe1InebUfJ+YnmnL1UPw==", "", "d1dc4d9c-2a78-4c50-9864-713a3ffa7b69" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "839fa086-abf1-4060-aaf3-9ccc70db28a2", "AQAAAAIAAYagAAAAEMATfAAqo5rSNX23jFNqqR4zx+zmyoQQm2IwYZvD9eBC4VYpbXPE84taKJMYBAyEhg==", "f148b759-05aa-4582-a6af-ec24232bd945" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df4cbbe3-faea-4a57-8782-fe55cb691dcc", "AQAAAAIAAYagAAAAEJv9TlFC5bNA2l6cDeJ6E1TbfbrEPJ3XC3Q1fuVYW0jJG0oedBfe9BX2Qo1I885wow==", "6d93526f-907d-475b-b70b-934a9fb0cce0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58c90a7e-4602-4748-86b1-a75054e58fcc", "AQAAAAIAAYagAAAAEBPSBKV62v+x5jLmwJkBf0OTaPmdiZ0nXb5UdfEkgCPeYKSPlI0n2NdGyYcv1xjsEw==", "63b995e6-3110-4021-94e5-ed08585011dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff31bb8f-7208-4f52-8e71-0aa716840cd8", "AQAAAAIAAYagAAAAEAkGiMN1KJcyAiGR41a/a9oy8HAMIHqU7ydyJqK9zQ0UORYWo2XO3kidLHBHiLWjmg==", "152dfcef-72af-47e6-89dd-671aa65fa4e1" });
        }
    }
}
