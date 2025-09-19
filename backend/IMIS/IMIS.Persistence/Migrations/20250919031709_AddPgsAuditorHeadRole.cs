using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPgsAuditorHeadRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "4ef682d3-1410-4f5e-85e8-64d1bd1ee0c3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "865a570f-935e-4dfc-bfb3-bc89c1d709e3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "eadf59d4-5877-4bbc-98b8-b9977dc7bc7a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "bb2e44d4-4572-41de-8f89-c2e900e55ca7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "37c311ef-f84b-4d83-9ced-3f6255c9461b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "0a6c556e-c6ea-4ae5-84c6-e067a4d40e78");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "b5f0269a-3cca-499f-abbc-1bc8d4271aa4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "96181e91-26c1-463e-abaa-d7158c43fefd");

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "Name", "NormalizedName" },
                values: new object[] { "18b4151f-bff9-4525-b787-7a7e009757c3", "ded89bc6-e152-47ab-8948-007545d40cec", "PGS Auditor Head", "PGS AUDITOR HEAD" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46a24bda-53e2-4f83-a0d2-7deecd563c06", "AQAAAAIAAYagAAAAEPdvgwr1ekpm9qtzbkSoMFFRjeq4Q7tictuAMRI6krN87YT1vxn2fmmKYELAyus/Bw==", "8247b0ae-47a2-4b69-8890-938dd817440a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3613321c-1023-4ff0-80c0-1404e29b8fae", "AQAAAAIAAYagAAAAEPJSc2cYjUP2hw9PVVc6qyqHl4G7cCttSEhoxE2UivIddj+wARG60jpqw3BT7M0mtQ==", "957a1117-a677-420c-900b-5f8e46390dc3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06502db2-974c-478b-b143-e46c665dc45a", "AQAAAAIAAYagAAAAEF0k7V8rx/jI91nQtlj2m9+SBPap770R9RYeybqwAPAnSVIS29tSvcVdU7Nns8g3Dw==", "edbf6c73-3bd5-4640-9c3a-9df217ef3bac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de39bf9c-13df-4085-a968-957558001b05", "AQAAAAIAAYagAAAAEJng5FMD+W91sOsNGm21HG/vpT1w1bqd1Fdaf2LA7ekJ3bQImQbdzrVw4gmmRkmOkQ==", "d733eacf-9516-42c8-bc7d-6fa5d3e94f92" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14f994eb-e7c9-43db-a716-8fe183d7037e", "AQAAAAIAAYagAAAAED4B3wnrgd7kwy/fdJKbgxO57+r0jfe4ApB4XQwF2CoOcNfgwTxWXwSxU8BJVIueEQ==", "41e89bb4-dcec-40b0-bc29-a28fc78d7fe0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73633747-d81f-4c7c-ab10-1a9be245de73", "AQAAAAIAAYagAAAAEDRFLLlC7nJGnHFLn9MAd8kSh6Qw5IW+N4vET9NNaPhNEaldW1YVV0APgTcDgJobeg==", "15a9dadd-760f-4f1a-98b5-7459e9396518" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cc11fa2-32be-425d-9fde-34cdf9c3cb74", "AQAAAAIAAYagAAAAEHbwWrxxsdBE2wE563LBXbLkDsDnx+l4OXWLvrxrhqVIDpQtXFHpjlaO8Gcr5FYkNA==", "3b25f262-d164-4ccd-b5e2-60f10ed4cf1a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c4bb77f3-0d07-46aa-86c7-f7fa3682c4d6", "AQAAAAIAAYagAAAAECJtfRnw91UbR+l6f4Rb477ebTFaryhPvn5a5SbudEAb62GdbALc1vqc/HrEZWy5JA==", "488231cd-2599-4208-a85f-98a8155a38f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af081f00-9202-4b58-ac74-e5dee21e2f7c", "AQAAAAIAAYagAAAAELfkmrtMhtiSqFOx2LJTYp6Upj+G1CBzio17Dr4DBgHD1qsSHDqhfl4PXVqAuM750w==", "59dccf34-b9d6-40f4-9713-c2ab4c9c8d9a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "169a01d6-3f88-4572-bac5-3ed7b9e19422", "AQAAAAIAAYagAAAAENiM57pBrYlx72s0JCUU6ScvuiUZhUH/XaiauAQg96dE66tvrGmn5ylCH0RSFn9ovg==", "861e76ca-b3ed-4e18-b6f7-c619c53c467d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "66a220c0-9f30-43b6-b163-0323783896f4", "AQAAAAIAAYagAAAAEP59WF90sXB07K/OlWAu1nVJ1wUtPIux1GiP9BN6S7i/ns6CdzvZUuqDeKOuioj8tg==", "6df020b1-4b02-411c-805c-eedbcb044a38" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62824dc8-64ba-4241-ba87-447221bdb923", "AQAAAAIAAYagAAAAEAbR3HL8gjAlJkbXHOxtWt7BMz/cXI3Qr2rLkx2nRYTvCHMEdX1wlMjiec6N8g8L8g==", "88091214-48d5-4fe1-90b5-a28a9853ec97" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[] { "18b4151f-bff9-4525-b787-7a7e009757c3", 0, "82745622-5347-40c0-a626-20c958fd1883", "User", "Singgon1234@gmail.com", false, "Bai Samirah", "Singgon", false, null, "A.", "SINGGON1234@GMAIL.COM", "SINGGON", "AQAAAAIAAYagAAAAEPZVnLSWIWQWFrNLdyjZWajW5mQ8JCa9kmmJPIx4t9aWPtu2xL+N9nVR8rQwicx5aA==", "", false, null, null, "f5569c9d-1f92-4bc5-a548-c095f45e39db", null, false, "Singgon" });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { "18b4151f-bff9-4525-b787-7a7e009757c3", "18b4151f-bff9-4525-b787-7a7e009757c3" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "18b4151f-bff9-4525-b787-7a7e009757c3", "18b4151f-bff9-4525-b787-7a7e009757c3" });

            migrationBuilder.DeleteData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "f69e8715-c92d-43cf-b0b4-3308ba553808");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "9dbc1053-736f-4c79-b604-d767632c2038");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "d4004f00-82a3-441e-b474-db7cebba8d6b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e1a8aca4-5b40-4244-a643-d9735407fdd4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "719e87a3-259c-4eb6-b5a7-56afc47f2038");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "23a6857d-1d7d-47f2-8262-4a03438d51df");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "66b5c958-26a9-46ef-a659-1346b40b53a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "18efe81e-fcc1-4356-83cf-3d49678e714d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f698c1e6-44fd-44fe-b9ad-e4f424921e1a", "AQAAAAIAAYagAAAAEP0E4R5BoLUAU0tCB38lB7yeK3dDcjszbZ35mWdDEZ4yxVyhhKteAW598NtelYjj3g==", "19f7eb19-426e-4a38-ad05-6cd57a6f083c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da68b02a-8812-4b68-aad3-3ab9dee50130", "AQAAAAIAAYagAAAAEOHrPDn0MAByMEb6XD+GRSQLIm+oOHEnzxrQJ6lZFRD4wRtQp7EqfjIniBFkiJhvlQ==", "d0dc0240-a3b7-4961-9340-da21b83d9a07" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d6bb29e-6da7-4730-aedc-d53eec624074", "AQAAAAIAAYagAAAAEFBiaTL4uKQ3riqNXNR+PaC/XGSI8qUOWhKWWhEIVCXKLeR978VT20iARNtf3OynBg==", "05379d9a-7781-4de5-b703-76f8c78727bd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "80b47d1b-dc08-4b4b-8a4d-bc25bb5d2244", "AQAAAAIAAYagAAAAEF2eEE6Vb5wJOsdGRXJa3+xrgR6Q9kg6TrlRBr8zfwKZsSg0k5DIcq3CmrwwJ7BSvQ==", "bb6e71e5-3118-4631-803a-f1df8bc4120e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76d5f225-7433-43c9-9b6a-9e24bef48271", "AQAAAAIAAYagAAAAEBkVkDZmDoAo8Iiw4sQzGDM8nvm1hYmQdLiBeEGXMgBX9uj+xZhF9yy9F5vO9eog3w==", "b8b1952d-9d14-435d-8332-fc6d721a6140" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eae6c4eb-3787-401a-b3f6-f9a5d0517a7f", "AQAAAAIAAYagAAAAECCYlofcZyW3weFp9Ir+yOQEULjagzRGxj+QUYqWD2kty/5zXhPaLyEAi/w556kkMA==", "71a3ce9a-8681-47ef-bc1b-dbfa18f3b303" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcbe9cf7-dfe4-444d-a456-37051778ca98", "AQAAAAIAAYagAAAAEJRAwHEhE/nRYXB1kz3f4VwzE/F39v8oDzpkTW+n3LZuABqJnWkKKwl5vXD3cG9WvQ==", "c6dde925-ee0d-4802-9821-c1183730b3b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "557b607b-3961-4a32-8242-c41f45ad4a4c", "AQAAAAIAAYagAAAAEJEzvwGGWG+dr7zgO690VUxEgR/2LLQWg85PmLSdQy04fWLQAHGVduRBLJaJNtmRfQ==", "ad8fa1c0-66e7-469e-81c8-27f0d1e950d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fad8e35-b710-4503-a414-e7396f7da5d3", "AQAAAAIAAYagAAAAEDcuTs7Ui1jV6DKarJUz/QOEgPbOPWJBKZvh8Dum/vm3TI5qNWOexZexevybEyrdZA==", "1851b072-683b-4165-94e0-599222af4290" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7a90942-b5b3-4f40-913c-0b992834d4ec", "AQAAAAIAAYagAAAAEFPKb/0gS63lvYiWwbpxWtxMCLP5xLdXBkHT+0b7raG+QtimyZO+kJ6GLaVUwAHazw==", "c68d24d0-f9c3-4f51-9b1c-c96b305e6b6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a508425e-6b03-42b1-914d-5def3da8d0b6", "AQAAAAIAAYagAAAAEDLl7mclBGaRhYWzc6Mb3NGTT6umje2L9ug/V+IvtRvqEf6bEPk2iDzQG8wic/J5QA==", "4192dfa6-a823-4f2c-a554-baf7bcc9aa93" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e355c2d0-ca7c-4699-aa32-f95ed04e2ee9", "AQAAAAIAAYagAAAAEIZk/KpVXzc6+lTYqLmj7bdSNEAmYtcz5DxW4YnCmh+0DUbXI1GDqMcQfW5k8zMXcg==", "5acc9440-d351-4502-ae01-1d8ab6565a30" });
        }
    }
}
