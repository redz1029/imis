using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class RemovePgsDeliverableScoreHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PgsDeliverableScoreHistories");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "5be14270-7f7c-46a4-8691-b3b0e07ce7bd");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "64daa6ef-bd19-401a-bf6f-2cf8af2fafb4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "0a674c0f-d584-4fc2-82b6-d0a5fcba255b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "c38f89e5-f852-44d3-a0c0-c728fe0eb2d5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "9452c4c5-7094-49d5-b5bc-f3a210540f45");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "be3a21ab-dc21-4835-8d59-6b5b2e80ddde");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "dcbf0fe3-6116-4c1c-8be7-56e0086261fb");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "582e0c89-9e78-4524-b655-8c86f3049fc6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "dc1b9616-64f2-4d75-b3a8-5551068896a8");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86d92f07-1b59-4e93-bd81-0cd8e64887b7", "AQAAAAIAAYagAAAAELWJ9SLqny37ZU8QErCXZOSkBQT73vh8HVDtjgjbF922GP8wj9fdXTLGfqd22XWlOQ==", "0ea0ff78-c46c-4342-92f8-e39de8aa6779" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3693b32b-8f47-45cb-95ac-ba1744d08f9d", "AQAAAAIAAYagAAAAEBujtDfgnMG1nTO48OlUo1LGWoizUlzRAvSa/bWWxJEVTaqZyuxb6AxP6D2Fs7SPlQ==", "bbe6be17-0fc5-47f2-9674-e6b81293b4d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38ede420-a57d-4832-bcdc-d289d13bba01", "AQAAAAIAAYagAAAAEEp614LP4o/aTYYkoJ8TOxgmnmULZvk+jAK9R60ExWTnljgi3RMYVNsgvSnkwJ/xhQ==", "d3605fd5-9f51-488c-ad3a-e5e23487e2c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be8207a6-3592-40df-a4b2-82829cc7d685", "AQAAAAIAAYagAAAAEBrMf+qYMWxP2iW6WlIgLc+GjUhjGuTidXHl+67hVCCW9xiQ300IWxWCXAusWRfV7A==", "1a495386-b58a-439c-a411-b06bfddcc2ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "267f298c-931a-4ee9-a6e2-41962ea81beb", "AQAAAAIAAYagAAAAEHtQf+J6fsMJ3PTgg1d4oyAcMivjSAtvjkIbHVhk1smHmrfaHSlRqIkeVTQSuDBg4Q==", "1b744bd7-3fda-4abc-9b12-feea83b669a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2aa6263b-fe34-493f-99ac-7e13fcd75d7a", "AQAAAAIAAYagAAAAEPDEk/bKbwZJeo58NhE/r+CDKkPOajAfPDslVYSb3OKBFt1MYKCLby6Di4B2rs47PA==", "3e340a58-e6b0-420f-824b-7d8fa74df41b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e06e2c6e-2e8d-44ad-b004-2f104a4920d8", "AQAAAAIAAYagAAAAEOyt7UMbqCqAzXds4SspU9nJYtusgouybp1gRjMpzaICjbCr46/rIun5SOx/wnpz3g==", "c4437b77-11aa-4631-9294-664ddf7714c4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6232341-b3ea-460f-8c19-f4717ff32791", "AQAAAAIAAYagAAAAEJrQpN15VV0TrJfuCLYFsvJatu4UAPsqxsIZ60E9sOsCK66NKUJl+dRkZk8jETcOGA==", "cc5344bc-7f5e-4893-a0d5-1dd294bde5a6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73731a4a-9d00-458e-b716-c887692eedc0", "AQAAAAIAAYagAAAAEG+hBtKva5VCmrNuWlMV00xhCJqE5SucAO7NJeTAO7C2aXDDCN3I81RFsFVtdb6pbQ==", "de0cd7d6-0eb7-4747-8e85-c5cbecbc175a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98633fc3-b91c-4f33-9b6f-13abf83b9e6b", "AQAAAAIAAYagAAAAENkpInjfjlgxPU0Wwc4fIeE3kaGPJr8RJHPpzizpmJozK5pvsZGEV5YV+IkTvzTuXg==", "8c165ce8-e45f-47ed-8fa6-f56d91f90666" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ded988d7-f2fe-4d53-893a-db00de547d7a", "AQAAAAIAAYagAAAAEIhvR2OI0D6HtMeMZJZYekWnoReaSvvIATAvHvqpxRmeemI/1r7M8G7BdYgsmlhcXg==", "3bf11e67-a3c3-4003-a4b6-717f1aa11bb3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28902e0b-7a94-4abd-b40d-881fe33ea003", "AQAAAAIAAYagAAAAECAu/J+q0ANqx20bF8JRAI1p9+Ze7s36KYq9HkwCg4qsHopz3VmhU8mxF9BG7kQNAg==", "925a7ac0-e869-4fd9-a8a1-3730805e168c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e473c44e-f9a6-41f1-88f9-9dc0dddb79f1", "AQAAAAIAAYagAAAAEO5Cu8iMLV+2NHuhDQ17u7CtVKwKOK+OCFrJsYAcxNLnJEEUpObGcSG0GC2lC5JgWQ==", "e44d9324-822f-4f16-90af-3fc13159169c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca9ce5e3-b105-456a-9b64-6869d2a21cb2", "AQAAAAIAAYagAAAAEJNLJkSOOCuM+uzxEfLOqZHoj9ln7HAtqtcw2AfBDpZTaApwAGR7nXa2FTpYEd4kHw==", "38b20f6b-50aa-48de-b6c2-4aca60db932b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27f8646b-d428-42b6-9a51-da65ea250b1c", "AQAAAAIAAYagAAAAENGReBphXL+irC4GdLPycrj0X+rj0M8ZUGOApMGcPKXtKM+SME7dfAcRNm6vpVF5bQ==", "2834d618-a234-406d-a112-312543e2fa9c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bff874f0-bd46-4cad-99b2-d9e5b3bebd71", "AQAAAAIAAYagAAAAEC86lKZfwE4Jde38luZFQHFy66vW1UxoVJltgY+2EPqMwjZur3adfFoX9VI1fFBPqw==", "21591df5-a74d-4889-a1e8-c194c2863e72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7590e9e0-c9f9-41d1-ae94-8cfe475f0064", "AQAAAAIAAYagAAAAEPi07BYoM/AOL5+dltO5tro/dpMuctJ6T91d+ANuriRK7QAO1jHiPV0cjXjTjPtmqQ==", "4b36d73d-13ba-4a83-8347-26dd583b1183" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a2b6d8a-6f91-4a44-a6e5-e29a4bc8a6ed", "AQAAAAIAAYagAAAAEEV22pJWZJX2QahBMMDWLX/qs+UORpNiNY68/nkl9zqBRag3Xo4DeFKlg+goal8lbA==", "6bc5f9d4-7b5e-4f51-a988-a6ea109bb796" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5325295-a2dd-40dc-a761-c031ccfbc757", "AQAAAAIAAYagAAAAENt54PdrQofdiYVrIhKKHyamqGxbjmiWgRgAfHG3vKtH5BMMj+fqulqLH3Q6q2fPAA==", "29fbb230-182f-4061-9b3e-013de8ff260f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "deac9ecb-65f3-4c1e-860e-55e6d7ec6042", "AQAAAAIAAYagAAAAEJqAY+LZa9a/xygslEdYZ0AJiXa+jag06EtRr9zn0t/aGzotwBn+fKIUJivoz8YfWg==", "01d2c68e-98b8-4426-9c50-96e00fdc728b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1da7e44-f52a-44e0-911f-fbeef118f570", "AQAAAAIAAYagAAAAEB+/bbPCv8E1eH4WuDwrW3ClzI+QopsQGxE0KZI7wh2YG8CTRbc1dDliWv5UYI5sSg==", "4f654cc0-4023-4f60-87ca-f531ca810338" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6377a1f0-47eb-44c1-8bfa-076af5f1caff", "AQAAAAIAAYagAAAAEB0C0khryhf6lJf0L6dztinz6Waqy4MYYCDvvFf5aB44uhaRPoQxYEskzPyBYSepRw==", "83d61b3f-243a-48b9-9956-a672b997cd2b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fd3e1630-0653-4d7a-b02e-880e41a75599", "AQAAAAIAAYagAAAAEGZiEQholHhEIns9VwByLY/r7R12mixTphOwr8F8MM+5D2ysxB1wjcVrxHlTlsB/zQ==", "15540aee-5163-4e4a-8744-c2be79adbd3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88111ef3-3785-4c06-aa68-af9bc84c615c", "AQAAAAIAAYagAAAAEGFrPcd56pTzC0PcDZSpAcawU76t+O2IjHnryVfdCcZxO+zQ5JI5In67Ptmn6fDPjg==", "df3d9000-4750-4c14-9c65-294edeb3e0e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a50b6fbc-5170-43de-8aaf-2e4b693dfeab", "AQAAAAIAAYagAAAAEDeZAS843NKhDFwCCExq+K16I30851fBSXzV9cGjIGwKz3gqU/3yppnwZFl8vLmo0A==", "7bb80ccf-482f-484e-b83b-ff356def4b9e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5680f7f3-eb3e-4661-b9bf-0463a09f8165", "AQAAAAIAAYagAAAAEGqT6ME3KjVpydNBlws9/dhQeVwk4R+dwmzZvdZL8MalgkmM2llCcGI9NO3eG25n0w==", "1447b8d2-d226-4f8b-955f-0febe0f07dcf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e67a3052-c0aa-4aa0-934d-82efa28efc88", "AQAAAAIAAYagAAAAECp4qCBpvN6FY+pyelaE1DjNHDk9V0K5JV1YaQKWkq7IMdtr48xriT0/HbJzWrZcOw==", "02b80bf6-0bf9-45ec-8b0d-be8673796c79" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "519b7293-02e3-4274-bc10-ea6409cd530d", "AQAAAAIAAYagAAAAEF9xmd/WtjHgs53yQv1h2Lsibwkizznn4QEDOSH2VizaL4Zkke+i72gwRQ370F048w==", "455039ea-07b1-444e-8577-b1bf1c4564b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "36fd5a38-274e-443d-a2dc-84524309a6d3", "AQAAAAIAAYagAAAAEMisCTpr7/VIh5GKIGJW2R3NeOfN/cRqjU7VLvv3Lz7t2ql/mZTU6LgYUTWj7dCwgA==", "959c83e4-4e12-4607-874d-859325134422" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1b46783-c631-44a7-a530-0ffc2180bf8b", "AQAAAAIAAYagAAAAEBqrsHUYT6VkODvX25IlYXNox/siFmcfabUKo1YWyFNBpaUbL+ro1W443sOWPRHRzg==", "619ab588-4f15-446e-82bd-e94848f656ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dfe7098f-c00b-44ed-ab0d-d82b70937a4b", "AQAAAAIAAYagAAAAEES+Y7p2NuxvZeQAG3WE1OoF597UtA1Xq/W7P/sFko3Ro6Xly+1C4V34W9/o6Kvsrg==", "5b762f12-9408-4717-9916-e1f83f425980" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc40826e-6a58-4bbe-b805-d95eea3a5b02", "AQAAAAIAAYagAAAAED3Di7i5h8odIlRr6J7U0YmVrmDM1qv8T5T6y8dIpYCrdliPO6pv+o15I/HdykF8pw==", "2a90ae87-ac90-44b8-bb8b-5d6ae3ad023f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c19eb11e-94bd-4c8d-9ca1-dc13b2abd239", "AQAAAAIAAYagAAAAEE66LMP4wyX1d8NlcOxa8FMPDrdAExBkmdwsw2AnQ981mfGm9q6fMF9WKUTTii1qDA==", "1fc09d5d-c490-4946-a194-5e3c61e79b22" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b44556e8-a2e6-4a19-803c-c3e7188bfda0", "AQAAAAIAAYagAAAAEP2Mqr2JBXp+FEIdxmd3O0RPvONAD4n75X2JHsKuIZFlDB4RNNTQAd9QWxKbHXQ1Xg==", "d99a4df6-3768-453c-9315-977d7c8ac177" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b9c387a-2ce4-4b3a-aead-9d21e6241ad3", "AQAAAAIAAYagAAAAEFKjmbtnZ1WoRUrc1jXN8DsA1HybLQNVLANyIzr3MsGE1FDrufb3f0C3KXwr04jo7A==", "e6513132-c76c-48ca-bfa5-a9d50e04fef8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c6bd8903-cf38-431e-be36-cf964a856e7c", "AQAAAAIAAYagAAAAEPxU8yNd09rYxc2ZpAW7BFAxRuSX0gVt7tM2PZRrIuk2XRFNI9iu8Pe+YJD/b+wYiw==", "a0a00a35-af41-4edc-b0b6-86aaf98875b8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e06cc4b-469f-40bb-a4ba-775d7df78afc", "AQAAAAIAAYagAAAAEDC0BWRgAf8nphTdVLPglHTAuAB7NKjm8b9I6/W+Ojs4Xj0I40AztQ86JBM/LzD4Qg==", "8c47ae42-cc61-46e0-a163-ddc27de55fcc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "157fe5f1-56f2-4e72-aa5c-4c8fcc6f34e1", "AQAAAAIAAYagAAAAEEksGDhnm29IdeS+BlgkyNWcfVvGEG6U3VP9XcPSmaNZ3hzokKE2GTHT6AmBFHUEOA==", "cd5f37a4-a6ac-4e34-b1ae-3b7c4f43bbc0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2eff3af3-8171-409e-ad57-efdd0793cf51", "AQAAAAIAAYagAAAAEMWxEx+roATLhxoghbGQwMCSMsSHwyOB5BOkJHA+8peiny4PJH94Lb/r2hF2Y4i09Q==", "91f48b42-bc07-48a5-91c6-01e957c99424" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95e12806-dfe3-4a5e-89cb-9d60ce7366ef", "AQAAAAIAAYagAAAAEI3IbJJR+INRr36CQM1uiG1rzT+6JhcOKM+TnS6mVaBjU6x8MKby1EIA5riA+S/hfg==", "6418245b-1ada-4e4a-b5e1-f7546983929a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9519af98-3434-4c43-963b-41bbc76f2650", "AQAAAAIAAYagAAAAEHgzBX/ecOEcYpaRT2QePAM7pGDnJ2qShNqFkyylx714XHIsXQ9bmnoBNdnUqKStfA==", "9677851d-9e40-4640-909e-c54c28a625d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7970681-1b65-4010-929f-92726b2ef5d0", "AQAAAAIAAYagAAAAEEOg5q0kwMZ3AOc4kD4zQZnYB75uRFp0VsCsrRGRxHAiJqVL7T8xCOzEe4UB1JbpkQ==", "52ab1780-d3d5-46bf-ba96-6cf934b02922" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df56e9fb-f19c-49b5-bd9b-181a782d79a7", "AQAAAAIAAYagAAAAEKuT26N6sM7O44wT2VzL83YaX7XiUBIfFt5U0fYZv2a0buxKswCFqizYAjD6Okav9w==", "db2c063d-4a23-4828-887a-35c37985232d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe231f9d-86c8-4685-bc7c-aab7e782ee80", "AQAAAAIAAYagAAAAEEjoPj2tLrSxIwYIfWySDRJ/A9SrX6AmUXpUEst0rfJvgh64eiiK0M5Jyk/PiLCTtA==", "afe2b249-23d9-4693-8f1d-4dbd9a1bf319" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2e9fb640-8d2f-490d-9cb2-b44dd0bffa27", "AQAAAAIAAYagAAAAEFThHid2g93l/ZCTszzahU7qyPSur3+bmx5KZtsPGHq7su5vBJyf39C2RAhPOPPYOA==", "6b4201fc-e84b-4c84-8215-978290b0400b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a04d60f4-9d08-454a-91a4-7d8fef511034", "AQAAAAIAAYagAAAAEOg+WcgJb+DlCZQTrK/wb/F0jWF/Nq0ROCTPCmeqZZC+ZXaedcmbo8zfJV9bksDBCA==", "6403faf4-91b0-4c45-b1ad-2037b26b0bc2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2e4d1624-fa4c-4f49-bf99-819df64cfb96", "AQAAAAIAAYagAAAAEPxtuj6UIGtZxYu/8y+tZF5epoCxZAFyMma0qpWgZPtTlISEXmDysMz2AsK5CPexjQ==", "3ef48898-f641-400e-b645-5c4e6af04b83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc776453-0225-48c4-b7d8-4045b146bfd0", "AQAAAAIAAYagAAAAEEvZmjO9OXIqk1xVZTbAUNIEzyiU7K5yHC+buEFCnwZx3TVPhnwKZryKCkO7MXorCA==", "4cbb57e9-60b0-4118-8e08-8f7465d4149f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6b07263-1d70-490a-ac9c-832eaa821bb5", "AQAAAAIAAYagAAAAECRSowOpN4W7zA1WS028fltF7VOIIzy9AIKAkWY7hIPRQodipqcZKQY2xngeKo1Eeg==", "1211fc7a-7396-4989-8fb8-4e8fcc55e319" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cf8c6ae2-ba06-40f6-a4c0-c283b203341f", "AQAAAAIAAYagAAAAEN/8aqXJcpqnNwk/e1h1CyJ5Xe9VQ2Udi85Cdmj8tMJVqKtMWsYCvgIml8mfmnyHaQ==", "7e0d3fc7-4459-4548-b7ba-878e904b4b06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9aeb0a6f-9bc4-43cc-9330-2deb9b84c2c3", "AQAAAAIAAYagAAAAEEXf0l+4s0PcLBmCvIJnp74GZq1hPisoHiTkxytFNegi9OXymjrkuMeaZcy0yw+YJg==", "5aac501d-c353-4dee-8f14-8bdd9d4d11fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eda22cde-359a-43e1-a1af-270b2a640019", "AQAAAAIAAYagAAAAEKmTipLzCgqxVyT/Y3VAZ8DfZRf0ZH1oK77gTOhQjkLs2TzjxVGuNeQVjBiHKVLR6Q==", "23382b1b-ac85-4490-9b3c-704c69ca1e4e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5de701f-1ecc-41fc-8c38-e9c507deb2fd", "AQAAAAIAAYagAAAAEFjRknveHVxLYdAEpsVfrYhRCaOlJ4q+vG0++hj1pYn0t1+EeY0Srgx6FLjYAkFZaQ==", "f60e2af3-3b94-4388-a73a-0cbb2ff31f4b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e1cd48c-d43b-4511-b7e4-6384338cd814", "AQAAAAIAAYagAAAAEMnxs2EulajRKxZavLyfXEKXCNXRfQaCXKsl+9SH7vv4lBxGAn+yl8/9h0T8K3+5aQ==", "823b8c92-f050-4788-a8b1-15ae2c940452" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1754b07-5e13-4b5e-a334-df4a677d4733", "AQAAAAIAAYagAAAAEOO57wo6nXc/5CHOuNne4EFwmv/f6ENT5gJhGyNfrrUCgFqwgjM1WmkuglJvzuGe5Q==", "f85ce913-eafa-4fd3-b572-abbd742c7c1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "58aac2e2-93e5-4de6-b7d8-6573c5391b89", "AQAAAAIAAYagAAAAEHBLRRCERIMtMc1cIRMYgptG7J+z8xk/4Q+Gep0MwvjZbD11l6n08URSPfmdZa+tzw==", "5aeabaad-a6d5-42f9-9ccb-e67123c8ae6f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "abbf088a-3c02-4943-8851-c9d4c240ee5f", "AQAAAAIAAYagAAAAEBHIDOpKUxZDi2l30S/aAiiBZ6AzTnLCswZ11Ika45WIr/6cK493cEmIhs1vtPXyzw==", "11770da8-5b5b-45b2-b3e6-788439d2cedf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5292d96e-3304-4107-8611-1752567bd029", "AQAAAAIAAYagAAAAEN6PF1YW6YJJstQ4mXAqmt0YcJmNyNb2+/w2pqq/79gZ9atbu6n8pkyHvyfa60f4GA==", "da58d312-6fee-453c-af28-8018e175aaf9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c953c09c-6f8e-4c67-a826-7205bd79a458", "AQAAAAIAAYagAAAAEPpGGtyz1+41qZeVGIIUZP4qDuMsWcDQPwaeLtDNMI2TLp8ncFmoWKKJoWrR8soblA==", "ccd6b399-9009-491e-8627-6a9a9b6a3b67" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "381a8ef7-310a-4e85-83f7-4d3d80989874", "AQAAAAIAAYagAAAAEEbhvCMt0GF1nvG+FFHBPZyfiuz+XPW271kPCU99ZbduA/FSHPWOVAbFhM7xWpM5Ow==", "758b0f8b-c0e3-4a61-9bf4-f35b6dd7162b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6130b464-16ca-4f1f-8370-67e6866cf085", "AQAAAAIAAYagAAAAENlunw6CVAUDEPo1H3aThUL9R80Tn4VKXL9PoDJADjrBHU0esR4htJkD+aaiFdX/Nw==", "127a520e-ff1d-4b3a-8788-1ddb6350ece2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0aaefe2c-0888-4c9f-8d30-d089527932cb", "AQAAAAIAAYagAAAAEFDkzwjmfINKOKPa5WAOWh6a1met5TfVG0GZglw9kEIJ5Sj6GHiFFupKKquAIn7zdQ==", "ae639229-416f-42f1-87cf-186e2300d9db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ce4ed26-61f8-41c9-a5ce-2cdb3d45e86a", "AQAAAAIAAYagAAAAEIZLbbxAMoVPyGHzprZmjQjWAjVDhIpY7aDaJTe4tyuETomxM+qGVs4TtKh1QsBv1w==", "6e6193fc-00da-4678-8533-73b8fab08650" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4dd94b7b-a685-4655-b9f5-6b7d49ac51d1", "AQAAAAIAAYagAAAAEFh5scmGIP4X0xqoQSGouiK9Iebb5RZKSdziWIjbPedLsYDxKuHyNe4QUtrMPYxQAQ==", "e6d57322-5dec-4c06-a680-48a99dd0b151" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1dddd202-f07e-4120-b6a3-c7b49e23020a", "AQAAAAIAAYagAAAAEG6dtxczBLeN/p4nfJTqi7VLpYu6zpmWfkmeu3HuzZb8lyLRCfREk+9Kta7Y/8exZQ==", "6353182e-9497-4bc3-bdc3-119b47d1e626" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bdadbf99-7894-44a0-8182-973d15ca8141", "AQAAAAIAAYagAAAAEIPSZs4pbzDEXEheybKpSI/HVpRnGhBHzZnjaE2dXKbBd4fA4wNz2xWqQxfc7FLdGg==", "c717eda4-d2de-4ef2-88b9-89d451a5ece8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0b7cab4-8c11-47c6-939c-580fea9ce80f", "AQAAAAIAAYagAAAAEAdfqWjK8DmJHORVaKg2InJtiB8CmVIrXB18HS05bG52KIfv/CDyCUVB+qhQOZQFhQ==", "3367317b-d428-4885-97f1-228ea78375ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a434dd90-c62f-4e59-8f2c-f4756a0b51f2", "AQAAAAIAAYagAAAAELWIOT2HRGj0vpHPCQvHkEYr1sRzGv0zqQbkuCEd32/P7htkRAlU6ciP1JpAERYARA==", "210af34a-c749-4afc-aece-7bfceec36554" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2eb30e88-44eb-43f0-ba51-d08b4059799b", "AQAAAAIAAYagAAAAEH2HLD8KNqvLWsUx4pJPumQCEhMuqe1nY/Lkw23bU4vKld6wrW4H/WfiCn1ChPSf7w==", "60a47340-35bf-48a6-a79e-754b74b0b724" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3807b13a-4e24-4516-8253-3faf631ae1f1", "AQAAAAIAAYagAAAAEGwH/SAqVGy6sWuQ7if4WlPlPKfYI1eMIbqJUT1R/7SXfsD9c0auZwlM9iHf1X38vQ==", "e7fa06fe-5746-486c-ae7f-dc55432062fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21399c00-87fd-40cb-bb9e-a3853f5ec99c", "AQAAAAIAAYagAAAAELgFNMOkrgA5EpLPo+CdeSZ14hTVKjnFtdQFEJCzIoJWnjz3a1gU14JCN0Zm7PlIjA==", "6200598c-a6f4-47fb-8c7a-b9ed7a9496a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "838ea9bd-3c7b-4244-a637-36384828e882", "AQAAAAIAAYagAAAAEFl6lw4tf1DZEd9sR1HqEUmEO4IuxSeDi7WlJJYSvNDMu/lXbzeyPjntw1cx8MEloQ==", "c57fe557-79c5-41a5-87d9-57911afd5f35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a568b04-be7a-429a-90cd-7c6a665de56f", "AQAAAAIAAYagAAAAEB5O8zdGHaVkjrmjlzfDC8f08XjI59CgLGwhxKwANkXuFdUyPEx6bs6BWuTfVYoVdQ==", "1c8cf505-dfcb-4163-b2fb-43de7fec4139" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3c6784e-0027-476a-938c-53a6f156f62e", "AQAAAAIAAYagAAAAEJyLJ6r6oiaxgj+KcJS5lg8BcleNFzX4UwU+d4JzFK9Mgroel6ZUEvu4NsT7fiTAMQ==", "62fb3c40-8eef-4895-892c-e2e28d097ffb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0098dc37-e87e-49b8-b16d-647480046cc4", "AQAAAAIAAYagAAAAEJiozG8stOFqno0UFcftzvXA+71F1B4oNNGPUQ6l6PUl6nJ6zghDcqsrkRM7w2ynjg==", "8232e074-8c61-40a2-9107-595c6752674b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ea8b8e8-6997-44b3-973f-2d5c17c5be4f", "AQAAAAIAAYagAAAAEE/SJLbywiXEVWBAp/4uoW3LLCch2O9ozOlV55QXi6QtsMycWMwErWcPeiWDuJeqUA==", "948b0b81-d919-43d2-9ee0-befaceedfb66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f82046d-339d-4ba7-aadb-46825347efb3", "AQAAAAIAAYagAAAAEPVTL07CMrLoEd0Vj8Axmtkcx67SElpAUpMyhXq/UtXIrqzyeQ1AM8Fng6S0NoIxRQ==", "3b0cc342-5b47-4351-913e-ff1d51e15647" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72f819a7-b96c-443c-9b69-7e988645a064", "AQAAAAIAAYagAAAAEEPwJR4PrGNwGm9KIFZs1in5zGVIDG3IKlP9usvPJKWcNZ/Zy3lpIu95+UQ0Kc2GaA==", "e9fe496d-6ae4-44cc-bfc7-6c5021d02265" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c7e29bf-6d6e-4527-a6d9-ccb63e95b2c9", "AQAAAAIAAYagAAAAEJuMyBge/a4mgQR5vq94BLT0lIi5U5+cFl/1nGoslWI45+GuI/TiSzQhgA9doMWoYw==", "eb88d8d3-55fb-491d-9f30-ed6320dd0c72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0138ca94-1b80-4d46-ba84-239f90b14335", "AQAAAAIAAYagAAAAEFPhjHgsBXcBP4IolZ3Lq9Aqf3g80ryYJPwTbCN8vvSfnoarFj88x2a4Yl1XH9xihA==", "54f5a7f1-5fa1-430b-a9da-b52d0809fab0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cc3a7f03-ccc4-47f8-9d09-6d0f6e34d5ac", "AQAAAAIAAYagAAAAEHA8kp20UN8MVfQfMdqth3acG3oLzRpRHeUp6anvDJk1zyIqbg32heJrFc64AmSm6g==", "a1128543-99f3-4cf0-b4c0-a974ee01a286" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8dd601df-9909-4fc6-be86-b06528c1f8d1", "AQAAAAIAAYagAAAAEHdBiT3bqt/zCN0rtDBdr+62ZaV6KSVSHEAqD6czr9OLxv2DcJoCaaWjsPyAn0nMqQ==", "84030e97-ee45-4c13-a132-871e79f74d7e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96ce0854-6a5a-4eed-8b73-31c7fe4fa2f4", "AQAAAAIAAYagAAAAEAEQZRf8zNu1vNpm8v8HxzR7NWYm6Ec06DNcyALsIyVusE9L2dpKAJYFoSZek8VpwQ==", "68792248-94dc-4026-bfdc-9a22bcc3d9df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "586690db-c436-4f8f-93bc-d56a6a0dc188", "AQAAAAIAAYagAAAAEECeBmB2TXlzLJvw6PyFjl2cfa5GmwK6pgZvJ78h58g2dEEOCC0HXeUXviiq+MS6WQ==", "be95b5b9-0086-4536-bbb0-87548f87a6f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7468fb2b-a097-4b7a-8463-990ae2c32911", "AQAAAAIAAYagAAAAEPIlhDpPprhc+aKXJF1H15YeuASMZ2KFpPKKsDcgHXARPjhwv/uVLMWUn9YKiDTj3g==", "a5e3b9b5-446f-4e4c-8668-b2168d3eb281" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5eda3f58-1fb1-496d-9743-f35186b55a28", "AQAAAAIAAYagAAAAEHVBxorlDtJrQvpRydXjPG9RTVrK7NjLUA94DUG4iUxbvxLRQ/ysUANzW1cRDWs27w==", "56fe311b-4a78-4ce9-823c-539096c83af4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6abbc8ca-3c8c-4bed-97bd-b9bdc1c467e9", "AQAAAAIAAYagAAAAECFDzLkr7E1NqZzmDSnA0AySYmqBb+lTgZU3+oh1ykN0Q7ebwTWGXuwRvV9AmKyLkw==", "b231fbee-6070-47eb-b230-21ed055ddfcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c2c082a4-d608-4c77-9941-e2522cb3fcc5", "AQAAAAIAAYagAAAAELtoHekKxuagn9aNai6fk7eTMXCCjuOWlZxQG1VivisV7rnnW1qVpITT0gRzc3HkZg==", "91c1171b-6f8b-42c3-85cf-0aca92596ac8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "826d0ffa-5d31-4a33-a3f8-ca8863757239", "AQAAAAIAAYagAAAAEP+Trqg4OiKj34Ijsq6ya8+oM5QpDMYt11MIqM58eqmLLeBfxyH25MVs7Mv9IjxawQ==", "e36ece71-76fb-419f-b26b-2109fa036a64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "784a295f-31bc-463f-9762-67d323e43c7a", "AQAAAAIAAYagAAAAEH0QC/wyoxQgQ5kMs8PbMebN/myAMwuWVI+Ds3SlLkooXYDYSW94kySf4s1lyyPgBA==", "c025297b-c11d-4306-a6e0-4e22f6ca1f14" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e730607-2529-4be5-b49c-0e227b6efbf4", "AQAAAAIAAYagAAAAEN9XWXkYwQHXB1jF9QIagMw/CjpU2g+k1yn9CFCqS9fKp7tLS3RKxbupA41V1Pne7A==", "49d115f7-39f7-4ecf-8142-6249c2fe103f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a34ef463-0f26-4201-81b5-9d3fef6ecb8b", "AQAAAAIAAYagAAAAEMyVo+Txl/bYQej2c0xfU90lw+fvCeBCk49lnu2lb3nyv1bD31pI37NmYDS+jX9k9A==", "14f4e3e3-7650-49eb-830e-70b6ef466eda" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4273d058-bcb2-4920-822e-5a3d42e8bd77", "AQAAAAIAAYagAAAAEGyzws4ukxdlxlW6ckko53pUBUrjKJTF+QFH0widhpw/D0Cz2g8yAIn8Ig2h1R5qTA==", "c159304e-2469-4632-a76d-0b20e7ce40b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f362e757-bc8a-46b0-95de-d4721ffd9301", "AQAAAAIAAYagAAAAEIjyFZUtspjwt4QIUeyR/OICiWaRxJTdGwZPAU8au3pSqJbaMeSdWsN+Fogcn6Zb9Q==", "f9cb1069-2511-4e3d-a186-c011b54b24ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b83955f1-f389-4ae9-ac52-bc910b1283ee", "AQAAAAIAAYagAAAAEDfRsOtah7FGWxuQBFwtCd48WPK2Cx8cIGqgWWKTzEIfuD9mi6xPvO/FWrM3JPJQbw==", "8af47b42-cf69-4a74-9435-6f935dbbe51c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4e0731f-abab-421b-aeeb-3da5dd3c3629", "AQAAAAIAAYagAAAAEC9I2sNFuEVmg/bPI2gibkWPiL8usubAWI8YZLYGneJsUV7MCreSPVvoq1NVCr2VsQ==", "1693b8f3-127b-45bf-807b-80d3358502a7" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PgsDeliverableScoreHistories",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    PgsDeliverableId = table.Column<long>(type: "bigint", nullable: false),
                    Remarks = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true),
                    Score = table.Column<double>(type: "float", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PgsDeliverableScoreHistories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PgsDeliverableScoreHistories_Deliverable_PgsDeliverableId",
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
                value: "f14a3338-5aed-4677-8966-02a9102ff80e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "22cb1711-4302-40b2-9ed0-61af7c32c074");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "fab2e6cc-ec0a-4fde-9a66-a142449ae11b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "c018a4f1-00ce-44a5-b834-41da3e87de2d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "55c9f3ef-a2cf-4a54-8ba8-69bdbf88459d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e3bbd1f9-16a0-42fb-8077-3658fe637a69");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "503088cc-eba9-41f0-be88-b3b6b199465b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "d0105966-e005-4855-a905-1803442e6d10");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "2aa865e9-2c52-4f49-a290-5aba58a44177");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69a14b13-bfb4-41f7-b7e5-6e37074b0064", "AQAAAAIAAYagAAAAEFNYNZTdnSPEoLc6BNSauC8aCvujY+SP2f6QG0R8V7qvouk/FPkPoBVROFQJFPi7/A==", "cec61f0d-4418-49c4-9f57-61b20fd1a8f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5bcc568b-dca7-4d16-992d-51b29e129d1f", "AQAAAAIAAYagAAAAEOiaQjMVmbHuOPf3FsfjatIfqLM/md4olK+ireLi4HpJWiw2/9hg5Vv2Z/9ar1Rd4w==", "f4a9407a-1e96-4796-9048-8a50fbc2b5eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b636654f-0ef3-477a-b623-442b8e69b32d", "AQAAAAIAAYagAAAAEDwoL9ekLTWvMwKNlsMpa7v7ZBy2jIvA7RXbzuIop6bN6bDDLFSgx7blhesdHoQj9Q==", "62f33c8d-aeda-447d-ae8b-3458c358b351" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ea24026-81d5-409a-9067-947deed68af5", "AQAAAAIAAYagAAAAEN2J8sCwDJYKhVz+OniJ3l0p5Mj3gsTdfoqz62uXnsiC04ZbQ5eZ1OuSyqzfs4XZBA==", "b254ccca-8801-4886-a1d1-bc9b6accf2e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62506dc8-59d2-49a1-8a20-64d6a6eb0efa", "AQAAAAIAAYagAAAAEEE2QIaszXjkPMys7rrUbxe0NfMsJvWpm30GsEZKJoruEsp/MTQJdKc8oSTjijsE2w==", "1ae90dea-0008-442b-afc7-156d83c4f88e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b5f1327-c3e9-4fb0-b794-693191bc23e4", "AQAAAAIAAYagAAAAEBsJEyKyXvvH0MG3daoqCovCv5ByzGx3Zk69ZpJ3nblj2ucTzN9xxGHlNypZgxskrw==", "6ac3b3d7-c369-4eba-b64f-81f217c95ad1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7073abb5-f2c7-4928-a9a2-3aee22f9cce3", "AQAAAAIAAYagAAAAEPqn0JAW4PMbxedUU+3o/fyOSBawS7NpBlg+bWbb0u9Xtno+qM21RU5w8W1WZQNcYg==", "047caa38-a3f2-46f4-9f01-4e2ac59b152a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "386f135b-0ce3-472f-9153-a6ca9343fe4d", "AQAAAAIAAYagAAAAEGiXWd0a4TvvtQ//8giv8CPcGi4wyvPepNGEvaniMj7zjJQuSnzlAov+5XgeOqe4TQ==", "e1ff19c2-4e35-49ea-9900-8de4e7405d07" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "903b213b-1daa-4948-a7cd-7a6ab24db875", "AQAAAAIAAYagAAAAEJkOoNkKqpniAzvGJfeR7t4jKnIm1vcU3pDnow3nHzVYgLolce3374+Q6C4V2u8ehg==", "e504df11-79f5-43ac-be82-94ebc10ec89c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f453ac7c-e8de-4b72-8e0a-8251cb65b4b9", "AQAAAAIAAYagAAAAEKEHEOIdcNdCZ9p0X4WKhIojpKDDPGhyOlQ3dOOp6hmARC9QHNATeYU4uK840taM/A==", "d2df1f15-45a9-4fd0-9729-e09fafe32c19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f825676-b049-4b5c-8271-6612fe0b67a8", "AQAAAAIAAYagAAAAEOdMnOjZ7w3ItoUDfrazj36/LeBh/liO/dVTavBepSpHgzJ1Cz6btFy77azjIWP58w==", "bd5cf5ac-bcb7-4ca7-a972-afed804fb72e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "706ee2a2-353f-4843-af9e-69ade9184087", "AQAAAAIAAYagAAAAEPh7hxHUXcsb03XgErZwAE4jyCmS5MZkx8J36XaGk0ndYgJ/z7XcI1vZBFEuZK0m9A==", "2ae02350-cf8e-4712-a808-54581f57c5fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96a91cad-2164-425e-9d75-d97673d64d8b", "AQAAAAIAAYagAAAAELEK3VW2c0uWxsxtQrLwM/PNLrID0QazTt3/t1yXlmIt8K7iEjjsUEDwQOF8BwLomQ==", "cb86d9f8-9910-4f7e-b7bb-5774ac24961a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5f491b1-7a66-4563-b852-4c8f9e3b0c6c", "AQAAAAIAAYagAAAAEBStbPwxxlKAXouiWTgsFgDNvJ7Ym4MPYPTqn4Lrz3ucNBLrPIy3s2T3XB0SYDCrtw==", "fc411d7d-346e-455c-9582-ee60fcf62c23" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5142273-285a-4c5a-b073-27b6e79edf76", "AQAAAAIAAYagAAAAEM0hib3lPNUw6/xjBkMv17Vh7wh17c646r0zvjGixs7F1xsvN9T0oV49wRwPX+RU2Q==", "273b7c93-17d9-4f61-9bd3-3554148ee616" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "570e0cdd-4372-4bae-967c-cea6c8c23d33", "AQAAAAIAAYagAAAAEA9HJBCMTS4IhLv9+Po6SXz4NsyT/sltBLKPZqJGB6qI4pTOB38uzUvLHjmzu3WTaQ==", "7c9fbbac-4ff9-401b-9be8-50f37f91af47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e191870-815d-496a-9e3d-d192d67ec701", "AQAAAAIAAYagAAAAEPhRj4EoWSkv2LWVCQLFH/8vJBDGRGr2POyZR54WKN6vZs/oLqPWag+K3GFqe2x19g==", "6ffd9299-5deb-4d37-9b1a-b1994a75ece4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18592987-ad60-4b7c-9725-ab8033d23591", "AQAAAAIAAYagAAAAEGmnkSSsEjJScOjXMT7C2Gf6dC+4IylmEjI5PYAkPPkmpDHkTObqIqSwigWjq9nBDQ==", "af6c23f7-74e7-41cf-8b84-d449d58cc778" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2106cfa1-8194-4662-a275-1c1f51097976", "AQAAAAIAAYagAAAAEB1htU+mLVxDLemmAXzFHC5N+lx8Yq00jHMJdWCa7+3s/3Nk8JAtUOzSmLwazO1H1A==", "4cbf3f0f-7a24-4b0d-90b2-66c8f9559ac2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0c4049df-695c-4254-84bb-ed45d4e44328", "AQAAAAIAAYagAAAAEOXQaiG3wvBR5+KcJ4n06fcHAArYczjxxnIDn+MtUiygZGoLGHT6Dc4MNnzfjBWkhA==", "402468e2-6b94-4812-9d78-8cee5a0b6448" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2840efe7-3318-4cf8-8364-56dd1764d548", "AQAAAAIAAYagAAAAENktJcgUJ4CDoQR0WlVP2zrNJmoGzfvHv3EFuxJVd3aqtlaZUxO6xdqWY3FjS2rRkA==", "d132e4e3-d770-4a65-9cd9-a96ac75d9e44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b9935a9-e42d-4d27-b384-6079ee206f3b", "AQAAAAIAAYagAAAAEPMZhMK4XiXVjhzlSVufPSr1OwGQK3q8KPrTl/5OSShjUoY2eZE2jGzfbm1xGEz/Kw==", "d9b26456-be22-4387-9d69-794051809373" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06d3118e-72d5-4e5c-8aaa-6c9b28e28ff0", "AQAAAAIAAYagAAAAEG2aqclNumvos4qSYFDLpVo8pKZtepKR8FVCJtVMIAZg8xYztNqOdRn06vRwZM/6GA==", "7da1b2b3-1c3b-4de6-a69e-b4aa62a3929c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "65528b69-5281-40b3-8b74-a2e543252eee", "AQAAAAIAAYagAAAAEGiFhLr8fqhBwmR/lUBYMiJJauXzLmH4bf7Thgc1Fvtw2rr+kz4Z/1EcuzJf62dkZw==", "5da3531e-5764-4954-9ad4-8c55143677fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c6ba801-0319-4441-b85f-e678ce16a218", "AQAAAAIAAYagAAAAEDnUfRWUjD1c9eX4rCOIikIZsMZSnqeRRj5ek5ynjRQY1k82afUOx0ZOF0fD7NwBMg==", "a9ab162e-687b-4b31-8d94-0d8ed0ca1e41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9670d32-c7c2-44ec-90dc-9a98088d1dfb", "AQAAAAIAAYagAAAAEE5nKXytT6juQHw08XvWoEXEbWrJPHgdZ568+mh935Csu+rJnUf0igpAeXDmy0NpQQ==", "81683aef-8851-40a9-9916-90f00b9c0ca9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "85a01386-c09a-423b-886d-dcf941bd20b6", "AQAAAAIAAYagAAAAEMCS62IkHMBRirJuDolGVEvvn5DzZpZE6gtvLvBXuLW7lOwTNnX4tG+OQwFW+Mp1JQ==", "bc34b32b-b18b-4a52-88fd-efd23b31af26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17219122-1bb9-4a64-a4f1-7aecdfcfabe2", "AQAAAAIAAYagAAAAEK86d49jmESwJPppMh8QvKZMjQOlz8DNNKlmI0dSrLgwaDj2KjQ7jw4s7aHqU0nUfA==", "0920430c-fb98-482f-bb25-425d8f0e5dbc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06385268-330a-45ac-9725-c86241da4d16", "AQAAAAIAAYagAAAAEBJTGZS0Br3TRSWCZ0dm4Imzi8+1i8MjenCVuTcRk6Ss37CgMA3oCRSVgyxFAf/+Sw==", "271fad18-5c6a-4d8b-811d-624dc236343b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f9bd6cc-f0fe-490b-bc98-2e10c8185e15", "AQAAAAIAAYagAAAAEOfLGDdUFjQFW+ZDlYQAwK4NzitQlj2IZpn12pY4eUu1pNOz5wjFA+q2mwMBXUB3xQ==", "0799f81b-c3a7-4ed9-83a2-d800494713e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae38eb76-def5-4459-88f7-ea2cd5d247b4", "AQAAAAIAAYagAAAAEDkKoZix8kfHgkUZWSYXE4X8XBiY67Z7NLaGUlm00Kg7CqhSjWvOwBr58t7bqipU6g==", "71d757b9-ded3-453c-8459-47b191551a5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dd68c635-c1f0-45c3-bfab-4ce254feeaa8", "AQAAAAIAAYagAAAAEIzge9G19y/LjqFLWoXs0bguzkBMCJFj0oHLGz2fAEZNC+D0QPhoLGyvPboTFH9a7w==", "ddcc6f5f-1587-4227-92a7-1c09936fba80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1681602c-73d6-4f94-be6a-6d6ddae3ee18", "AQAAAAIAAYagAAAAEEI+K/ijwSoaYm44P8lzQnRjb5HCBcxovhhaPRqC+sfqhYohaos0bqlIFn5Ag0N0BQ==", "7b2fd3e1-58bc-4a3f-965e-821adaac8f06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11c48f14-3487-49b0-81ad-3b4d6aa34644", "AQAAAAIAAYagAAAAEEBmbF1bTvEWMikSFu2chWTZkCK1JVY5WOduU6z1Cd6bJAPJoSOSXa/5S7MR+OwC4w==", "6c0c9522-ab17-4d7e-8293-a04bef902da4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97d0b02d-73d8-44dd-a8d6-b29ff977b46a", "AQAAAAIAAYagAAAAEBFKBrtVp1NA/MLLt34Egxz+i8ritp9ZpLDo/Dz3dZyL75WEh1ifE/E4nrYRiU25Gg==", "7cb1f939-c57a-49d8-a34d-60cfd8a69133" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "684ba7c7-f5ef-4a17-8656-e8f38ce299d1", "AQAAAAIAAYagAAAAEHQlhiEIeXNmx0pXPr7PvdfB09UDia0KtSUdHU/YRF3RRtvbI8HeDIGQdcg32a+sOQ==", "7ac7c0e4-ccae-4387-b6e5-abce029a64ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27f3b58e-f4f3-432e-8a71-8346154dc023", "AQAAAAIAAYagAAAAEJjyMW5BNbwtI62CKM4L9U4HUEaiceAM8//T8Zy9eohibyS8rjCt4JUcYb0uYIwXUw==", "c5dd5af1-9d46-4b46-b735-9374074cae84" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38b290e6-5e45-4aa8-ba30-f7758c66461d", "AQAAAAIAAYagAAAAEBM8+rp1O7v51qJXUQ07P2PS9vWW1YrtEMd2UWmPIAp0hKTu1iQXE6zM0v1uK/fdXg==", "6569b9b0-0670-4581-98f5-b36a5f60b2a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30aa734b-c6b8-4577-93f4-703559a9df1c", "AQAAAAIAAYagAAAAEO8NJJUBr3G33Pup18sJdfcL164EHGJHR9u03bxERNkT3loMUKncKA8l+4TfXPm2EQ==", "7e0668c7-703e-4dd5-b6ea-cf9ea156d57a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6611389e-b468-4b63-aa7d-bc1011c232b9", "AQAAAAIAAYagAAAAEK4pxdAGrPLy7YWdlfNbHeGO2DnklkpSgTVdR7o75/jnD9UnP7ZjEOPQF730xCp1Ng==", "a8d01165-3436-4f0e-86f4-93710ed77738" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dccb675b-1af6-4c5b-ba45-f4b5178bfa87", "AQAAAAIAAYagAAAAEKauAvfVhxT8PbwTferTX9hvTUlfycU+axsEIOQfSJw9F12ZtQ2qz+MPib/aW3ndXQ==", "68bf1712-18e9-4cd9-b82f-a7de6621f314" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23c00300-6a16-41e0-886e-8a99977c16cd", "AQAAAAIAAYagAAAAELVIbDWi2SocA0SL/pW5Mu0wH2QvTmUMm0Dy260N9I3E+SEJawz+bLuFXLAuRl2Fcg==", "96a6eff7-d77e-44b5-97e0-3ccced07e72d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe0bf45f-5357-4e33-8974-d8f209981d86", "AQAAAAIAAYagAAAAEBgHtZ/h7Lb/OI0eybZbkA+uaB3IgFTo4GMNtyhzOu8TBxLonc/rkBfPMKZkBvB5Lw==", "b995c43b-d050-4831-b204-a1bbbcb25261" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "31a1d829-aa18-44be-9b3b-857a0e0ead09", "AQAAAAIAAYagAAAAEKSShrIYkCLjcjOFI9uhFLtMZbD1qZI76dR9O1Axa2QxnolVxbHBa28Cq0B/BmJ9iA==", "581f50ac-31ca-47c5-a596-24016e0ad6a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91dc8122-004b-4e84-a513-26cd3e93a0e6", "AQAAAAIAAYagAAAAEGzFt61RRr+9h8NwlVJPfjOlMNQr0ohnM629pYSpoBzgQo02vaHEIBPDqNa4LutLWw==", "c965f5ea-86e8-46d9-a412-2d1235bd1d54" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bac8c04f-c34b-4525-8967-bf52177f95f3", "AQAAAAIAAYagAAAAEFI8+TEjs+OXkGVHucQ4/9++fFcLThOsl62lrZDo+mUCT/12Gi/VyKlmAZ6hrIsDvg==", "352dfd1d-fcd5-4936-8282-8ad7c99696cb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df456972-50c2-4dac-9de6-f763ec46eddc", "AQAAAAIAAYagAAAAEEZ6KvKo5mwZHs51IwoadNqTHeqchX5+E1zVhN3B1DO7c/hsBIzyXs9DU6MvaHJlQw==", "409c8ee3-bfe4-42dd-9b9e-67c1b94c2449" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b19db044-f3e2-47ee-9c29-0706cecd798d", "AQAAAAIAAYagAAAAEPbflE5G6tMdg/9AlYaFIlPfT6ZMyhoz2ow0puasFEzp56PzSpo26Lv6kgl9Ahj0gA==", "0ba2c9ce-685f-4aff-b92e-cf3b51edceec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b714d8a-fdeb-4161-94ba-5c5e816bc8c2", "AQAAAAIAAYagAAAAEJHRRIhyO2GhzFZYnpnES/tCUeVwi/AIWDcQL+n/V6yGVUPK2FExxSsYbj5SXP/LiQ==", "b578b075-032a-4911-aa38-f57e2bbeaa86" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4362efaa-cb68-4041-b76f-f0e7a39d0593", "AQAAAAIAAYagAAAAELQrbXdcCzza+QzQPYCRLdNdw/L3Cd+KivaBjWrwf3tnWrpMi8lLgBnLvg57m46jqw==", "7d953cac-b72a-4af7-a307-fc00f69ff15a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71b1dca9-5a64-4a32-bd68-c941ebf4abc1", "AQAAAAIAAYagAAAAEMYoF3MvDiUK9CYYUVDW7dj2OhIhRG7TBGKhwFxL/UyJTX1N4GheIyGVzQUVcasCCQ==", "a05971c1-6798-43ff-8eae-3cc09e12ea94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e534bc3b-9616-4984-b14f-acaac69c73b9", "AQAAAAIAAYagAAAAELevOFAE5VtJoN5O/wZckXo1nksW7piGrjeX6wbZZrhxJxuMoDHvOGUbYYE0L3EkEA==", "95d451b9-258b-474f-9e9e-b981704d2adb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "943510ad-d437-447c-ab0b-32956b03cc9a", "AQAAAAIAAYagAAAAEAWfnrke4M4reGHHTFs5LbmizdAWoj5KGNaM6pi+kZNMlV+h0jROU+WnIIW7grQZiA==", "85cf4e7f-58f4-4b88-81eb-c422a14eb426" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "906738aa-168b-4b40-8b3d-5635ff1ce551", "AQAAAAIAAYagAAAAEKjAu2feigarKdYJM10yRDhSG1yZH8BUzoouoVxDtXPXInA1yq11Nhq247l2JFP/Rw==", "394646d7-7ee4-4f49-8367-a07937a934b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24480345-b2d5-48e4-9e67-24dd130c868e", "AQAAAAIAAYagAAAAEBL1cNgLGSjOM7gw0i+krWhK+dWdi2H4AA/RlfSyaMdWiNhMjz/QUXFy71LpJxqHLg==", "e85de0a6-cd1e-4d16-8dbb-3d442780e612" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a60e9c3f-d0d8-4628-a6f3-2e6477f4cac4", "AQAAAAIAAYagAAAAEA4c6oPQGxpeaRRM7k3ajysdXCLT8siC9q/cfbsDLOdt0Y05+pbzLa0J1g1MRtPJMQ==", "baca4a1e-0d17-451b-abc8-0c86344cd5f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e00ee55c-fd1e-4a22-90a6-a5a6db5fff0e", "AQAAAAIAAYagAAAAEM9J/Bp/CsSHoCGjKov8tEmDihv700qK08GJSubgcHp9ykJyAK9socDIuC9o7nu98A==", "daa5b856-b456-42ba-9a0a-a5736f4e2a74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f793013b-4e25-413a-b61a-bcc1c017f63f", "AQAAAAIAAYagAAAAEElnv7R9kKVQCoBil70G2OUB1DgWCAWGSAAWTBy+lpQ9mLBx6cO0hoIk5EhwW+2PUw==", "4de8e10c-9596-4783-a473-1f72d7cf010d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "05ec4179-5da6-4698-a5c3-304a45a04df7", "AQAAAAIAAYagAAAAEDundAB2cbudwjQfw1wbyEgXw9uMa0DVqQk3EESR5KDt+252PAE6s79TipWnZFagrg==", "985234aa-c263-47db-9731-1303fade4a94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49ea2f4a-0694-46ec-9cb3-8fddd1e7f783", "AQAAAAIAAYagAAAAEPUXMOMPvvRpqP249fpHjeY/rVJblm8j0F4MXi/fdS2e0yq7uair9HdNeh28dArJiQ==", "81921b2c-c9c6-45f9-9c4d-cdac75eaed0f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f5b37e8-2b3d-47d9-b671-2ce683ae3917", "AQAAAAIAAYagAAAAEKZnU7hqZEk5r03rAaRIPBJ7BJek5Bg22jUXE38/oA3yj8ckE+CmhvAi2SPwNGYE8Q==", "68487163-20ad-49e4-b680-2d041aea1e48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b9d5848-0ca8-4b6e-bd8d-f01959832089", "AQAAAAIAAYagAAAAEMn6ZePyD0NAdOyVnhd+5nKccJObc2L2U8XKImM5PnZE3Of5OcNVkE8jxltR6wC83Q==", "042c9cc9-3c41-4894-ae87-de324fc2dab6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33621023-0900-42b4-8b42-739d8671b927", "AQAAAAIAAYagAAAAEMYZ/Ev3EDQIHXKjXoXEhwSPt/635IfEWD5XJLOfKtxcG+j2Dftbjq3BE1iIErIaKQ==", "4784c7e3-0678-43f1-abc1-5da7eefb8a20" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba439b50-bb62-494f-9b21-2dbb3f39cb4e", "AQAAAAIAAYagAAAAEDLRZtyPaftGuMOfGv9fJulY8LiQi6m091verdnbM6jJEKkc9uMPJ3I00E91IanWkw==", "a3df0729-0ccd-4e08-9ac7-58e091a39f01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4cf11710-eaab-403b-9bb0-3094b678aa27", "AQAAAAIAAYagAAAAEP87gQXZ4qAu6TNNyhJfgJShpT3EjVBJe48DUjK98SGCSOAgwMPAYEqbkCFB1fewuw==", "733232e7-12a2-4807-bdec-6ca73771a3d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d2b32f1-b71a-47bc-984a-27beea2e1bd1", "AQAAAAIAAYagAAAAENijN5NQt9HDMvntjblrEnFDH66JQti1iuQ7AiG5Rzyb5Kr7btBtY6YW0FMfxDkxFw==", "3e1a17be-a4d0-4f42-a6c5-4ac5dad9578f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3aa566fa-24bf-476e-90ef-fdb5fc2a1d21", "AQAAAAIAAYagAAAAEFFcTnDi/K3xPceG4iszredNwx1YxK1Fl7bx7l160qTVgyc39HOKzmovigbcmqWyug==", "96626c33-e21f-4646-ac82-f76ab5cfe6ce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e317be98-22c4-4d78-bd4e-7fdb6ec7eaad", "AQAAAAIAAYagAAAAEIqVTBFNrMfB/IyG/Zwd0u+KrpCkQgcVhYFUrxeCWOK02rtsQf0wi08xu0dWkF7C4g==", "629948a2-8632-420e-946c-3038bb08e32c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d86c8207-08bf-4d30-a96e-8791546b4bd4", "AQAAAAIAAYagAAAAEALp2jh4Lole79svwKjCBBiIQva0RrW1j43aJE+/G1WYAOeK4yAjS00xynBkyS7kJA==", "0dd6ab61-abb6-4140-b413-f523ee0e8a97" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d98fbdc-caa1-4c9f-b797-12c27aee7eee", "AQAAAAIAAYagAAAAEMdl385HnvhSB1td4y6ImBQBoZl46Zcw+OFaWl0ALg13W1pYNeRsQyknUmCCvm7PVQ==", "6ea07b05-b6ba-496d-a536-0398345884fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "efad0185-2204-4570-8618-7927da3619b1", "AQAAAAIAAYagAAAAEMjAVJOauhisYcg1ZfwnzuFGpbE85e/2ANZdU+SMx/8zlZx4DQmTqJISkqwt/DX29w==", "47157b92-a2e6-4f74-afb3-a7215e02e545" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "820238c8-ba08-4790-adb3-625e4b56c01e", "AQAAAAIAAYagAAAAEHPFzOyxSKEaMQ8HiMx3IDGI+9XlMQcPK/7Yloupq3N1/croR57eA/s/NmfVEC8JTA==", "aceb8137-a810-4cf0-a37c-b4b59cd4486d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e50e0376-9f84-4562-9a10-92cdbd00e585", "AQAAAAIAAYagAAAAEOJt4D4A3OXh0XeMpQfy2Tz0n6TUhIhOn9M0gPKY2lb8kI2FzFb8M/wd3Mhexegpxw==", "cfcca9b6-280c-4375-901d-08d82548da9d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1665b12-4990-49d2-997c-766ed1f2c66a", "AQAAAAIAAYagAAAAEGmirICtLj280wl8EL1OKxPNBN5UpCHykIxAObmt3k4sqS5wHLd8a7PFQqInIUzMag==", "7981a4e8-c0f6-4223-aae8-09bae15611db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d960c4af-0381-479f-b9f5-9c163051aa9e", "AQAAAAIAAYagAAAAEJbOkScfUOd0MRNRkVCOINaRbr195SUkRI35jse/c0mzs3O3vTYyDnb8plEq4Uz6Jw==", "0a574d7a-8435-4d77-973a-1b1733c1f033" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f45614f6-7b6c-49f6-af83-d7b1d92bc173", "AQAAAAIAAYagAAAAEK4CkFeFyRaX/clNnS3QWlq4KLQoQfvMtxVS1CH8oID9WQMU2bxe4PTZ9UvbayGVjg==", "20661543-d262-4ad3-9b76-718ac0cd402b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cba573c1-23ae-4f96-9f55-70882c704cc3", "AQAAAAIAAYagAAAAEFxo/D1KS7eUsRQIq+xa9GlyXIBA7aJ1D0YN9ZjrUWjYDcRJ0oIig0z5J23O3sq8lw==", "a439f69e-a1cc-4146-b5ec-9bd18feb05e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "057028e2-07e7-4491-b099-6e519e1213cc", "AQAAAAIAAYagAAAAEH0ZoG+VDcorq+S8sDf/wkAhKV36sBuzAzlwiOjza09mFRALHl1sn7mj66xr7nf7jg==", "9a9b65d9-5b76-42eb-adf0-4c842a89cf77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9bcc4a7-d59f-4f77-aff4-ee30ae3b0f51", "AQAAAAIAAYagAAAAEH6TIgjDvIqfUSI7PsxeoCMziMmg1EHValwss1omRa7KIkhR27gLj0si6krjEuGD4A==", "3fd14edc-b855-4728-96ab-b3d359e45b1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dfbaa480-ee27-44a8-9206-6fbb7737a797", "AQAAAAIAAYagAAAAEB6GIDLuvYEUgEBfShIIetBaodeGBnUWpbA+jTZQ4x6HnF68+FQSUmG8WmfKTy+Txw==", "d4117358-1562-4bf4-bf4f-4b28f983e349" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ccb5e7dc-9460-4b68-ba0b-6255947b08af", "AQAAAAIAAYagAAAAEHevg+1xKHNervpI7aN3Tn7Td1YoCEgoNWAT4nnWTrdOrD5aiJT7i3ad83b+U+KTEg==", "12931a95-dcad-4926-a5fe-978e87389520" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "748444da-4041-4c89-982a-c666973c4681", "AQAAAAIAAYagAAAAED4ZM6tXzPyPPeNHCfphSJtYnwFssXdOqMnIqnmxGC8Qq5RQwu5Tsf9lAbYBzDaM2w==", "573ad233-3621-4408-b66f-a58e50a96c68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a57a8a4-32b9-4757-ba29-a0207592ba3a", "AQAAAAIAAYagAAAAENDjT+tVWeOVu3nplWdkoACNZGLgjPw4xWZsRnzVOmZ47sBbUy0aA0COVAzHkHmjoQ==", "f9e324e7-df70-41cb-9723-966d182ad110" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54f2a03d-dd4b-4532-a47c-9e202ed070a2", "AQAAAAIAAYagAAAAENAm4/+SaTJ4K5pEaa7FImMLDGKJ/LEbZi63MuXefgWYQB4A/K2BJU5ahr4ozRYQfA==", "35b994cd-4549-46fd-b09d-8650a37096ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1518288f-3c3c-4a37-ac47-79e3ba52cba9", "AQAAAAIAAYagAAAAECQsf8zKWaq/ZR6WnYDONfuBVlPVz8IcJLwX2MPUkQ76VViwPoF0Af5fGbZjFvB6lg==", "151a20fd-e0df-4e5b-92b5-4669ea750061" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d59f314c-5a5f-4810-a260-bcafc6fa3b41", "AQAAAAIAAYagAAAAEOqUqN24nftNwHQujL7fMnNDCYmduFr/CGspf0zz2kfPvrB2NwiBlKxQwdvEVeRwrQ==", "0b249287-bb8d-4d14-93ec-4b2e72b8ebbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6b6be65-e5a2-433a-af95-7a0690bae120", "AQAAAAIAAYagAAAAENs7oPZOot9dDVzokx+tGDjuexHKQG9bnkU9/gAXxwJWFHm4o+iyC9Mt1rLRKA2Upg==", "e25f0f96-f145-4661-9a4a-601731c1c5d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a382a1c1-5c8c-4852-8655-6f48bafdda4d", "AQAAAAIAAYagAAAAECEcPTllr1Q5tWfBfKUOOVR+nEAMQfB2uVA+9Gg0uu4Pq5ZBund56Gv0MKd2wplU3A==", "d1c8494f-e68a-4cb1-8f8c-a88345474c71" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75b8d607-3fc3-4c25-a95f-4d7599bc11d4", "AQAAAAIAAYagAAAAEKxx3tu1tdanrEw5cMef6Vt92Z1jI2Kkdi64u6k5Rb1u6hanLmUq38Yt/w+Vc+h6rw==", "2f9bb62d-ce4f-435d-828d-2cb4466548d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf74010c-76c9-4006-b5d0-09e0d5f29e54", "AQAAAAIAAYagAAAAEBBz22eOsNob9UrlaDaKfAIaIcZi03WlO/WILUUZETj8SBCYUmLl6p8M3Fyz76fc3w==", "f979d45d-cc9d-4f25-a15f-8c93ea352aa8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb2c0c04-9188-4d6e-93b1-58488dfccdc3", "AQAAAAIAAYagAAAAEBV5HMCxoRotceH+NAsIs989/dTypBnBHw3SyYms3vWHLMSF+YluLqhz7KDHSP78xQ==", "b1d470b7-2891-4bb4-b894-df5f2646d200" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "175769c4-6e23-4f70-86f4-18e09693a2c8", "AQAAAAIAAYagAAAAENgexf+BtHjjhvapKKLPZ0bOpr1b6+PWyz1QrchwDMmP3llxkAx2lMV0jGRNP/Vp3w==", "27a3ae71-4c48-4ff4-98f3-15cfa8a0b585" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6883f78-bedf-4b50-a3ec-a1799848efb7", "AQAAAAIAAYagAAAAEEZ4ujcMoMe51JBFQEhvOY+ZlVbnOl5pzV5WB36sBnuSN9Fg894qXZJL2/izV7UxrQ==", "281135ef-221d-4625-af55-9255d2e096b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67e5f0cb-dc68-49c0-9442-88e2786fbff5", "AQAAAAIAAYagAAAAEM8vOFfdVaqjxSGmfzoA0U5+URfY6algSMmtfJ/yU4IJY/p+qloCgVfCV/aXGAWKOQ==", "eaa84608-5b27-46f5-b227-a035376c26f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f84fdda-38d0-4e76-bce7-bcd14698eaff", "AQAAAAIAAYagAAAAEI6VbENb9LmPJNtDx3Xevm5w97WjjNRvrw/au9DeyBYtHy74iP+u726oXz6fT4fNeg==", "1de45231-0799-41e8-b2b5-ef4021f355a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c76eead8-e205-4ad2-b59e-64f82e1f33c8", "AQAAAAIAAYagAAAAEMTsdc52oWXNnBhOU7q5JSRF6jbPMeBlc/hX1XBcy0RjRsYCpSLegFsM5z50cDjfUw==", "2bb35654-e68c-4158-9888-931e1fc919ae" });

            migrationBuilder.CreateIndex(
                name: "IX_PgsDeliverableScoreHistories_PgsDeliverableId",
                table: "PgsDeliverableScoreHistories",
                column: "PgsDeliverableId");
        }
    }
}
