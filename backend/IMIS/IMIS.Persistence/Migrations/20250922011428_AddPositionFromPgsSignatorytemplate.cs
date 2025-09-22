using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddPositionFromPgsSignatorytemplate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Position",
                table: "PgsSignatoryTemplate",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "ca53dedf-5820-460e-9ead-2e58ea745762");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "969a538f-5287-4ee2-a1aa-78dd34e0e2f3");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "3032e6bd-f0a9-45d5-a671-d85f6c26a21a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "52c07605-d559-4bdf-ac68-6bf87a40c1f9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e50e7f01-dea9-445b-9ced-181bf380a6e8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "cabf01cf-077a-4648-b43c-cef1e64648cc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "1b4ed50c-7618-483d-a0bd-4dfb40b97554");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "f33777d3-616a-484d-86f2-1a3416a51851");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "30488768-78e3-4821-8002-4f379a6dd84a");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2adc8bab-05e5-4cf3-8cca-4d549f5aef34", "AQAAAAIAAYagAAAAEPqnprlUcyPrEepSvpYJSe9wrDXG+57UvAQFePwbxAqOsjMYJQDJagksWBqchwSM+w==", "117ce292-d002-4b22-8022-be416449d3b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cc605a3-3e31-40b0-81bd-3a0733abe0f0", "AQAAAAIAAYagAAAAEKZKA1iwsUV04KKhVe0YcLjiZdW8nYKS6zAdPzGVQotPzng5iigoq0aN7yGSzWhAHw==", "d20524d2-b6ad-4317-bbf3-aefbcbf22e7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ffd96471-5b11-4fe5-a84e-e209f2f7fdc1", "AQAAAAIAAYagAAAAEEWcM8ZUreOuGLAmLGiMADgev17DNul8MtCcFR+nmcr2NShWDoalLJxjkdJPWEQPew==", "d5b529c9-2b39-43d2-b618-c9fadf04d9e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab8ea099-1e1f-45aa-ac32-80734c15e5a7", "AQAAAAIAAYagAAAAEAtY7VJUKcAwNF3oHLieik8rVFhGMTLRqz79ft5gmGpI/UOgA41nWpMKk1o52ZyGfQ==", "f9470f3c-6e61-43f5-ad16-854ad8ea181a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77e5ee17-70f3-4c03-9be6-404611251301", "AQAAAAIAAYagAAAAEL8yP829eQYgGdyyMwz0IviDCfAIun1cPjlIjUzl77khmTOXapfhAzcb2c1zdbeBTg==", "bc5d99db-5282-43a7-81fa-86718bcbf1da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2462a30-80ff-4884-b1e3-f042ac4bc6da", "AQAAAAIAAYagAAAAEA+OjfkHkYwLwW2X/wW9ENftHCQfO0BC+SEDbYuZLA0DfQwzI4vdcu16/w/7zaBaUg==", "15b8ffd3-a174-4e1d-b60a-6b84d3b65455" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d650251-e171-4813-8898-89b64ce0de4d", "AQAAAAIAAYagAAAAEKDQsv2fykQ//d2nNEHCBbIvrqTJzNsdWSKtLsQqkulEw6V87sx+7vn2QHSk70Rk9g==", "1623aeee-e768-4229-a3c9-a12f4e6210ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b60bc96c-6fce-49dd-8e15-b4efbe0938e3", "AQAAAAIAAYagAAAAEFLkNKcghtRQbydwEhjzAeIupw7Ncutr+5UPdhcrhJtE91w98ahSBwBqAzMllIaVLA==", "81023594-83ac-4ce3-914b-8cf9f7adbea3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1dfdd77c-793d-477c-bbdd-201f9c145812", "AQAAAAIAAYagAAAAEMHQehQUix74rJ3KkCDysIq/7aKw+B+5oDD6oBqxHk/HuoBl2+JuZKrYWq6xWtEGqA==", "9b5837fa-064e-429f-96d3-fbcd82d15282" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93bba06c-ba95-4ee2-8bf9-84d2fca75680", "AQAAAAIAAYagAAAAEKCEjHFuR/cn+lYaguyVRERPfHq06hW8YMtyQsxTbVZr/8B3V5/TDsEQrEE6jncjVw==", "4b6b4860-8299-4965-ac63-a47970859b7a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67046528-d38a-4ba0-87e0-967b6cee9cc6", "AQAAAAIAAYagAAAAELao8PCNMzckD4lHbyJ8dB5H0mx0F7huADivO8WqRFbtvCPyzveMpq31GQSuR3fXbA==", "bc0e5a86-0d20-4ff0-bac8-d320dc16e328" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "284b9e27-b715-4155-a61a-f5bf245f11e2", "AQAAAAIAAYagAAAAEAVF+RFo27ksNhYt2gXfeTzVlf1hWcbS6mq+n2EWUVaQv+o8pW3WbTDk+7QYC+Uqew==", "8bdbd99e-dd1d-47ec-a077-27061849c787" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75196c96-8df1-4e28-92b5-bff04cf84e6e", "AQAAAAIAAYagAAAAEDT2fILFTlmUCYTS0MoH+B05q4BAp7goyerBc1QVx/X4V/CMf2JFXg/R5s7IWm4/Sg==", "0a626704-d770-49b7-8b5b-00f1d5daa4f7" });

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 1,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 2,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 3,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 4,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 5,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 6,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 7,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 8,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 9,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 10,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 11,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 12,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 13,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 14,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 15,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 16,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 17,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 18,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 19,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 20,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 21,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 22,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 23,
                column: "Position",
                value: null);

            migrationBuilder.UpdateData(
                table: "PgsSignatoryTemplate",
                keyColumn: "Id",
                keyValue: 24,
                column: "Position",
                value: null);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Position",
                table: "PgsSignatoryTemplate");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "ded89bc6-e152-47ab-8948-007545d40cec");

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

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46a24bda-53e2-4f83-a0d2-7deecd563c06", "AQAAAAIAAYagAAAAEPdvgwr1ekpm9qtzbkSoMFFRjeq4Q7tictuAMRI6krN87YT1vxn2fmmKYELAyus/Bw==", "8247b0ae-47a2-4b69-8890-938dd817440a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82745622-5347-40c0-a626-20c958fd1883", "AQAAAAIAAYagAAAAEPZVnLSWIWQWFrNLdyjZWajW5mQ8JCa9kmmJPIx4t9aWPtu2xL+N9nVR8rQwicx5aA==", "f5569c9d-1f92-4bc5-a548-c095f45e39db" });

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
        }
    }
}
