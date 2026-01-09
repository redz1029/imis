using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedKraRoadmapPeriodAndRoadmapAssignedRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "2cadeb30-b27e-4c62-8bef-e92dce0a53af");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "b412d273-629e-4848-a5b2-5551ed3f1203");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "cbb587a1-8056-41d6-a6e7-39f4be13ad45");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "c226170d-5f04-4508-bb09-13657d7eed70");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "3e312752-193f-4d2e-82a8-c54bf20e324a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "48bb279e-a5c6-4b90-ab3b-c47b8a41eca6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "c8ced3ba-7015-4560-a20e-0901f42419fa");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "55f14289-0c41-4af7-9d3c-1da227cc1881");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "26023ced-335d-4503-899f-dfb59d4dd710");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b178ea0c-443d-4715-a22c-f4c6cfa95ffe");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "c58f4a87-2f1a-4774-8abe-37d362c46f45");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "8339ca17-e0e6-4055-b147-317814b7af81");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "d6c92585-1128-4aa1-a627-0896171538b8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "49866635-a2e6-4f7f-b9ee-b360d6496341");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "5971ffbb-e53f-4130-b9bb-7b9af1314dd8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "0e30606e-7578-40a1-86ef-9a9c36ba18e0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "dab0d8ec-96e2-468e-9e53-1ff97ce42ed8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "c0ac0213-210c-476e-a88a-dad520ac8b9d");

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "2z9f8451-1n19-4b50-8432-4e23c164cs51" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "399f5e43-93d8-4a28-b113-d23eccd2ea15" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "7cfd0766-f3d3-47aa-9a48-53d437d6c232" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "a1e10c26-4d1d-4f9e-9378-1382457c82ad" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "a6b59fd2-75eb-457e-90ea-d1d419da5f6d" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "b4d73e5f-f530-4a4d-9c3d-0b364236da6f" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "de17cb47-83e7-4a6b-b97c-13808e14a7ff" }
                });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7915cee-b9f0-467e-9b46-4d24e8c3082f", "AQAAAAIAAYagAAAAEHxoQl2QRbjWc3xcZ/m6/VUPKN0wSw0VRlSC6+Zsran0XphksNXUrwv5uw8SbzGkYQ==", "23b3fd35-f3c8-4c68-a0cf-796cf4b9f152" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5234557-063d-4706-9d49-cd28eae3ab13", "AQAAAAIAAYagAAAAEFqGjWdj95THN1UfV69aToZTVgd9BBRBwEml7l+9SVEEcQQcPoJ+GECaIekpMP8W1g==", "cef01349-f7db-47b9-8d9b-341480c2eb9e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c4605de0-3e4f-4d88-8cc0-0e6d0026ecc2", "AQAAAAIAAYagAAAAEF21dxBVNiSQxhnvJe5sHylDBAkiUM3xhut6r05NX/kX+COdPI08Sp59Q3RYVnPGLw==", "d8ecd63d-ae10-4e18-90a2-b39cc6a796b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30ccaaf8-401b-4c4a-b4f0-b24bd4e74eb1", "AQAAAAIAAYagAAAAEF7wikmkKVfo1viuRFr8UzGhW9Wksoe8AJ3HCo2wwTH3gnl+wheDeRsYIwN8Mjbm4Q==", "60884a1e-7744-46be-8265-5cc4292962e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0818ea45-2fa6-420d-9157-48bd306b8e61", "AQAAAAIAAYagAAAAEMVNUGG+YERyyp9LbKrcU7VNjBax/17hA6lplbu8eB94+fAL2UL7QhOHmZKy5KP5mQ==", "0f53f09a-f9fd-409f-8625-2f825575d6e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "400c5da8-757e-4f85-9dab-39108ca2be2b", "AQAAAAIAAYagAAAAEJrOB6HTzzYARzVEyxtg2r3LJaxnxUfljBQyoZwxzMqP4Di2xEio7MpksClOTo86rw==", "e07c6124-c1c8-4335-b47f-18fd04f2c881" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "305be5b5-d1ac-4990-86bb-1d85954ad728", "AQAAAAIAAYagAAAAENAlm8e2g0mJmp540jsovQZhP0/Q8WMMmu1yRP2pXVLS6qwj48gi9/HJeUB+YyLSxg==", "0c7f55ef-0156-4c71-9ef5-d99284bb77a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7d63b75d-554d-4bf6-b02d-7e4298369154", "AQAAAAIAAYagAAAAED11yBfO4JQlW62M47j13t/AQdtXqH8vR7QalKLJYTqLnYOYmkuG6zwIcGuNvpt3GQ==", "dc876aeb-15ec-40c2-a7dd-b1bba3a6f643" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17620d66-2ed2-46ec-be69-314662c300c6", "AQAAAAIAAYagAAAAEE7wAVEVqnhDRKngrSTDl7Q6cQesyRlUwBk4P4123O0rDHaf6jdfcJ4gx7T8ctoH3w==", "e56b1080-fdd4-408f-953b-64248007ab40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f685746-81ce-4282-92f0-2baf846213b4", "AQAAAAIAAYagAAAAEE5f+BM6yU+qATtqSv3l3oOzAyw/aEJMLmTvOQU/n19pkzK/Kj3HvWqU0xr54Et6zA==", "b2f0bd35-fe1e-456e-9dff-1c002e244ba9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "05c38052-fce0-4e55-afe3-d837d7f7612c", "AQAAAAIAAYagAAAAEB+jnf+mH+pyU0TgckqE2ih6Rzbb4hKZy3ILfm+XdVIum6VxQkJIUR/OkIFVWB6g4w==", "a3eae6c7-7203-4b17-8ccc-546ed83d293b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "308e89bb-16cf-4400-a961-90f8e3edec06", "AQAAAAIAAYagAAAAEOEyKnQuORMLzffvbfjX54SXfoXo5t4507wQNTW4vGKpZtOFqkAp1G2bteeaFi9nbQ==", "08bc4939-ea32-4fc0-8e96-0e8ac084d254" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5c1f654-c90d-428c-8a9d-f5533cdca1f8", "AQAAAAIAAYagAAAAEBRNcDWDqjMxawD5II3bWRFOOzdTg5jpgx+Ht9GcL/TKV2U9JWNl83WiPkRCNA2gGA==", "2909a795-50f0-4b7a-8b4d-975ce151b1b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a5543df-3baf-4463-96d3-9c28a4c21fae", "AQAAAAIAAYagAAAAEHYyvbHNhEi90h/a5u2XDeUUVdAKBjaf+gJ1MRVm1XF5TJU3l1uZjBEcrEL16ZRHDA==", "20259b20-1e97-42ba-bb3f-33955cf6c931" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e60a4a7f-f216-4c38-86c0-5272109ccf26", "AQAAAAIAAYagAAAAEMSyyJC0BBPnhqEqqk+wQiN4yWEiZPQPl93Ajis5wPCBFUm2CTgian2aluST8GY/Hg==", "aba099cd-0258-4fc5-85db-ee2d8b74a309" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ad64000-b6e8-4b3e-b86e-96f50c7fb019", "AQAAAAIAAYagAAAAEJxot0R7SoDtrtHGQONLBH2UJ911Ir5E7cGeaL2EFc1h/mcHLLqxQRBJxJuyFSN6wA==", "282c236e-4964-40cf-8d62-058f8fa7ceed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab9f2418-3fd2-4098-9079-c8ec6235b27a", "AQAAAAIAAYagAAAAEPKWrISN2TLYlJMuWDa5pVtq9P2e4FEePkLsztW/x8qShL8s2oiruJp0LWGtZlca1w==", "c10cbc17-5c2d-4752-ba56-feec7eebf470" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99bfb242-a624-4a2f-b12e-933f7b3b18ca", "AQAAAAIAAYagAAAAEHhDPjY9/TE82gep649a60QWyDlVI7V6xAPAMmJ++9U4iCWmNO1tsJMs4HvrFvRjDA==", "56d044f0-650b-4a68-bb62-f5c2e11727e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddf9dde5-a7ef-440e-aa3f-0b144a0e6391", "AQAAAAIAAYagAAAAEEepV/i5ATXATsKj4WU4cS/Bc1va+Y+jpnCbyDLYKQskC8bjQCeTx46/GxiSeEm8fA==", "f098ebc7-13e0-4091-9898-0e20afdb1f41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "503b68d2-7b5f-4184-9557-19d357fa823a", "AQAAAAIAAYagAAAAECQbFkd0tP7zqSIWfBQ3crjQuOT5YOkDHZFIrFTkMxYHc7xATrMhygVUz8cQ/XxWKw==", "fb9b7bbe-ed88-47aa-9815-c8b001b189a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c48b389b-fcb5-4496-b5e0-38980b1e7c60", "AQAAAAIAAYagAAAAEF/YuSLJgvSCLkhP/szoritc9hFnUOeKa1arctl6f4hjmjoimEdPCO2BcaNuASo8Qg==", "c63ab869-fd2b-45e5-bed9-99cd0f0e982a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "740b10ab-9146-44af-84df-8f6148090a5f", "AQAAAAIAAYagAAAAEAYqr0/B9DnSFTXWrEwQNsNUbIB9IVy2v+UZDkfsMEQmPmvdiW13ZsMVAH1z+yNHFA==", "d5deefb3-ad6a-4bc9-a8c7-08daa857c9ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e7814b1-de8b-4fde-89bb-130f25c68336", "AQAAAAIAAYagAAAAEE6ZzoT4yekuXYBKBUzD1YuPqYk8D4wJkOYzvFneilo9lbCczA9Fme8PadqYg0iUxg==", "667dccb2-5ac7-45f3-af74-29428312aab8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "116079f9-4632-4cb2-a05e-f892eb1038c9", "AQAAAAIAAYagAAAAEIhrA2qcVFfm7S4o+llskEITQiY0zluQiFFaqLX4ium8m1BOBL3Tt2NsBNr3Vd5X+w==", "328ec23a-6b2a-4ed8-8f1c-8c0f3b61aefb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f1ae5f3b-142d-42b9-9c3c-98bd95b82a9a", "AQAAAAIAAYagAAAAEGx4cThwlMb3CpT/SAH2x1PDdRwlnik8NL9KqF4FrsNqlpvbjC9ZuB+Khnc5iGzAnA==", "5742f14a-05c5-449a-a0bb-8996b04ef1bd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac2a4f31-f6d0-446d-9513-9d34408c9470", "AQAAAAIAAYagAAAAEFtgNXHFFTeAxbX6Z5zvkRzcALdJxuecrdXh5q9nvOzPyDCbWW9BE+JleaxPKQ3Iyg==", "8375be9c-0404-4fe0-ba1d-d50ed51a95d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f2ed709-6ef1-4117-9785-bb58d2f5a141", "AQAAAAIAAYagAAAAEJEWLT4bcSQqknZPq9jwwDehG4SbAsnFRidK1e80CAEYdkvVVUYzJ2UJrztMkgV4KQ==", "9916b9ce-76c3-41ea-92b8-537440b31d76" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69801c0b-bf94-4b7d-bd85-d8e791388b1d", "AQAAAAIAAYagAAAAEM4EeH7vMoflWjdYsnmuuMUecVtwiIJDWyEgHRb6uwrDBTMul3VNg5/Y+GDY+jMXLg==", "b7e4d57f-a073-4f11-b256-2859d665d3c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71aa4d3c-7105-4a6a-9aef-730fe0612f4d", "AQAAAAIAAYagAAAAELxEwsyC+nU7Ru1nfqwmuUuFZUsmPQRW7g6S7Zpp6/aZy1J/p39l1TfKFB/Djd9ojA==", "796f2b5c-ea60-4699-b000-fc66c4ef9587" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77be38ef-9a78-4bd4-9e01-8e7bff5663ee", "AQAAAAIAAYagAAAAELyCClsQYirKFEtjQeVAmUE5Ydp+WPdXcPcRUzFiQIIjaDe4T9PUy9TSlpGQwuWLtg==", "a8b9b4d2-7c71-461f-88d9-31df95ded034" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a92ed74a-5738-4174-a9d1-734708add79c", "AQAAAAIAAYagAAAAEKPgOWOEoIP5CcB0QHeFvPq8cShOc948mO43STtpOH2U1lerdYmJSCtbR9Bec4kljQ==", "f815524f-bc13-4e45-950f-d7e1077c8cd5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "01db5527-bde6-4d56-987a-857139ec98c0", "AQAAAAIAAYagAAAAEKDN/IoNkqPz5HMvAwGoEvNh2/+ObbxWp5G7XmlLd75J7h1nLHD/VQ63O6ZzDGy40A==", "12c57b58-568a-4e80-b8a5-7f068e00e7b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ecec222-23c9-4ee2-bdce-ee4eb6cf80ea", "AQAAAAIAAYagAAAAEENEMGkNRzHIupEjSnMcZYrfy9XmhCy+6L8WcZ7pKIFaruDBUszq5TLaiouTWrMvVg==", "0fded9b6-717b-4a00-99b8-8b33ce72393d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7856c7d-373e-40c0-bc9f-3000a3c91d4a", "AQAAAAIAAYagAAAAEC4zeY0AXhY1QjVD3xuQXmS3SxL1VkSm9teFwOUtHGyY2MvuxeHjQMRk/kPS/KB3WA==", "4aab3785-3c4a-4cb7-9d04-af8e774af738" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a868782b-aff2-4405-a991-583ec865bd35", "AQAAAAIAAYagAAAAEHhoOb2mzd4mT/RMeOcPEUmz2748oXlKsgEuT6MfYF3JwGzBbdmC4dLEdOSzmAVlhA==", "35c03e46-8d8b-4d50-90ef-ee1aab5e1a7c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0cafd479-f116-4b18-9263-03926f5ad346", "AQAAAAIAAYagAAAAEOQFuYmA+5yaf5vgLD+ME+bP0ZpxlqBDpOVTjHb7ifsngbkPxpOKseSrjLSrjb5wTA==", "2441670b-3145-4b58-9210-aeed3ba05b7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de244867-1de4-4aac-aa4d-029070dedc59", "AQAAAAIAAYagAAAAEP8XbaGYH5/GnzpXHQ33eitkirCrPnK1iFnESthhxCuktyTuwzGaQToKUng+fa/AXg==", "a3bd9057-9979-49c5-8b72-25c9d861a25a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "44491953-8f65-4f27-b1fd-f0fa27edc6d0", "AQAAAAIAAYagAAAAEKL+O8Oyjfr4teCVei/Vla7usoNIHm4E+yhpeOGVB++6a+KCDvEyYlHf84CJ+yNutg==", "06b5dd80-4c4f-4d5f-9ade-6989ac961bcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ccf87bb1-16dd-4588-b7fc-cfe2958b41a5", "AQAAAAIAAYagAAAAECIP+by4ULHX9aEd9vMNIsF2B2Ldt3e0b1DLpddLaAvR/BVIdlRKH1FIZ6bO5miCwA==", "0aad9aad-0ade-4edf-8e97-c657cbe7e58c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c76c579-da97-4183-a92c-183a7c8d2cae", "AQAAAAIAAYagAAAAEArW7rcVxm0fJYzzkZwAIFpUO87el2q8HlDjM8YQbxg2awNIyIniI0LhYJY6MKw+tg==", "aed5f577-ea8d-46c4-9928-94892b7d22c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e6aa7c5-11ad-4e02-b5a3-5aa57b8fc3b0", "AQAAAAIAAYagAAAAEB+olk9pbpWhAtnXWdXahUDnQy1RaPkdsxUCeOPhLi51AIToNPC1vpdoF3E9Z7gAcg==", "5bb2967b-1b11-40ab-86bf-8818bdca8f61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bcfed6b-3b4f-4f87-99fc-aa4027c127e4", "AQAAAAIAAYagAAAAEN4HCgOekl3kRye0IAswoM91z9TnU5znrRiLETrqrkuwazb/7M5RTqRKUrvJySF5VA==", "6fcbeb65-f4b3-448f-8bfc-761ab7069ab9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "03aee5f5-0c57-44d3-bb2e-f4056f5c446e", "AQAAAAIAAYagAAAAENZ/YXytzefBMWD+0qQyt6n3303ak9AEdorAa6RbT9ZUVFx6n83ZJJhPY5viMhPO+g==", "db8de799-b5df-4d4b-ad4a-cc2d4b795a88" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "045580c1-a6ea-4715-aecb-cff5b46960fb", "AQAAAAIAAYagAAAAECNcDVpn8+GcpBSqYRyGkdiGiwFqgWrKFDj2dfOXK5l+X6IT+DCvnN/z4CkVOYIR6w==", "2c4fee04-7fcc-4247-8740-88ea4b534c49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22b4b4a8-3b0d-45e1-8fda-cc33e9109e58", "AQAAAAIAAYagAAAAEJeVjTvCt46dY7Yx2wtUmMonZyMG4smq5e+UtsN2KSqUzDWgKEj4irU3yyxYGhoBYw==", "5bc649ed-0135-4190-9976-6479bbf5d2b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5b51b5e-7698-456d-b24d-682f3269edea", "AQAAAAIAAYagAAAAEC9PRjYvAx+uxMzXrnGt3yF2sqCnAaYqQdTIAQ8JndfWImhkDYcPeML/SG4PRLkmMQ==", "85f5ae0d-ba31-4c7a-9ac1-ed8dc43e1860" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21d7c531-2dd0-46e8-bdc5-1ea331f9fbde", "AQAAAAIAAYagAAAAEMnaJnXTCFiji7p4x0JA8c3/UjAF9/8NX3lvZfyMejFiea+nOlJaQpmt1BPxfMqLYg==", "4a07286a-858a-462d-8462-5636bf136656" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e9df6d59-2090-4e34-907c-ae3f32871329", "AQAAAAIAAYagAAAAEBd5Rp90+dYlK0FKCexCEzFDFlJ4xGlVsS650c0P6Qgzxl2gb8d9For4Mp7aTO+SMw==", "9aa2fd10-2b17-42bc-8b95-722b8edad1ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c0e60b0-6ca9-44f5-a873-5ef0df3f1c48", "AQAAAAIAAYagAAAAEIl8uvrLuVYjfTB8hMMcuj2NOxLlL7P0OUG7F8a0BnTBo4bkWzZjPYEzr46zZremLA==", "24b3886c-dcf5-4359-8ac5-66a6cc5d118b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c146f3be-a9b2-4920-b9ee-386b2a4b70dc", "AQAAAAIAAYagAAAAENkYbE+R87ik4HGYrg1AgVmI14Uulr75Zmi6aAHYw9TkqEv1GsKaC74uLHFWpldjBQ==", "b76fc81a-b636-4069-b66a-fad4408b5078" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3574a776-3639-4b8f-9b93-eafc040f7333", "AQAAAAIAAYagAAAAEBbAZ775Z2O/jP30BNXccwZNdzwuvJQGM/H2UNHTrI+zpPdA0wIYIaAbg8yKV9ApWg==", "808856ed-e0d2-4aed-b465-95c83550c6fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "010d8102-66c2-44c2-a747-bb0132aa2252", "AQAAAAIAAYagAAAAEFhFLdGG1EmXdndaZNggaBofS5foaXJBicJtHRf/xjQNS1Fzr/dB1i+f1Sdt+kzkRA==", "82faeb03-7480-4b02-bced-731d9cec881d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed55caed-8c95-4901-8552-d6d49d616cdf", "AQAAAAIAAYagAAAAEPc842dlltmunvdI6fDbGoVhz5HnoQi+RA/1i2OWezh8X7yLxUxG8U4PbMi72bIyRg==", "68dfb2c3-0e2b-4bdf-afe5-fd2f572110d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddae5c3a-000c-48aa-8d4b-92606d9b0d7b", "AQAAAAIAAYagAAAAEHMaKa7vr7LuB9djZUTpgvw+mx9nuLh+QcjRWZYwVMc8cseG1LhN9Mnkw3KP6nKPtw==", "6f92625c-8c95-4d57-adb9-517968e7ef60" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f01d341-04cf-4234-ad39-34be0b9b818a", "AQAAAAIAAYagAAAAEBOE8ZRi2f8nD9M0JuiX60siuEGd5rnYoNJW+XJDR8hjugAQfLn0WZHIcYPJuS5ywg==", "8dd08a00-9b42-4a45-9342-de3321ce9fb9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de66b6eb-5467-4abd-b332-b21e1011bdbf", "AQAAAAIAAYagAAAAEO0zOQrDAYGvWrefFb1dZeEUHNcdeN7UK7cdN3YxBQOpeXIPYBz0QIq5gT870eJTMA==", "fff378eb-7bf7-4ab5-837e-d52addabd065" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4fb542bf-a078-4698-972f-6620cf2c9864", "AQAAAAIAAYagAAAAEN/llZ8mJMG0FcmE6SVKNG3pPUZFmPd9ZMporiftBEFvVhocAqjCJNplawZYzi9p2g==", "500668f3-e330-44a8-a257-8a3195e6c958" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1a0d362e-0794-4e61-8f7e-04bfe4d94e5a", "AQAAAAIAAYagAAAAEDtoHxpRBVsxbtiy4VolY9Mj/qpbwe+bG45UcRQ8575s/bEppQnggek4OqCXzq421A==", "a5974730-8c81-4eb1-8b00-ac873d8e431a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ab5baea0-98d8-4c97-9646-02a9f04722c8", "AQAAAAIAAYagAAAAENjSt3am6xCd5PlXJTLgQBUfUgU7nsqIx23gXkGIFa1VIf7yNGJFz3T+yBQP5PLJzw==", "2491733c-119a-47aa-bd0a-36df3c62f0bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ead527f-9888-42f5-b192-22d519a60f71", "AQAAAAIAAYagAAAAEGR8VrI0KGHjY8spksG+O9wzazcL3eAI7oPlDWScGlgTiv8GGfnx/VeYn18qoXIH2w==", "1f7d3661-0b47-4199-8aba-66d9e2897bda" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7dc59c1b-de63-453b-84df-586d0c2c2839", "AQAAAAIAAYagAAAAENLZF+H/5laSyzZfLfqdfiWKwDgO4d8gCRE0Ao0NS3eKmMtX5Psymm+PesKoQXHGWw==", "f77bb8e3-0efc-4391-9ec2-caba093e524c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1f1b649-3479-475d-9989-ae68790d31de", "AQAAAAIAAYagAAAAEN/mWOIwTeAfrk2f7KgcyoayGm7U0fHWy5/LCslLTUdcsJGDOp4BTMaPOhHEi96huA==", "afdfd35b-9493-4313-b946-7d229a9928d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "507af054-cd70-4e17-bb3e-336ad9cda045", "AQAAAAIAAYagAAAAELvF8V29vZ8Z+qVb8eq/aDZ+T46h52Uo9C9IQSuoMQ8izx+R/pQAHsB5f/Bg1fXTNg==", "bfe20870-8729-4eef-b45d-c6fe3b72533b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5015210f-d85d-4c54-a49f-cd3edff2cd47", "AQAAAAIAAYagAAAAEP/UK5T6JVLjjSdu0Fp4pG7uhMqV1fDJp6SaAbCmwDutNzmlq5FfmnZlD/Q4b5bgEg==", "16be0e6c-dff1-45a8-b1d1-eaa18487425a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d048e22-be3b-420d-b986-9a4e3311c380", "AQAAAAIAAYagAAAAEC1pU2ySZJeFeXyQDK5ZZU9U68uBfdPWT/6S7k/KCMXyUema3Wkj7/6bOab9DQBfFQ==", "027ae38a-46a1-4211-b37b-e3556549cfa0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6e76de14-fadf-4e54-8860-99b960ab6406", "AQAAAAIAAYagAAAAEOFdkcH0JIyHwCcXSwqiuOHGe3pfKJR7GiM0703R/cMySbuiQiWRO5IGd+INHlvpkw==", "0fe8e366-8cee-4fad-8e9a-cfba1c247279" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d986bdfa-1189-43b8-8a4c-1c959f491abd", "AQAAAAIAAYagAAAAEDcZpgzB5ItM4tEoCrnTE/kcfHa5kyXim0rAX9LHRBpeF5OyDJx5G+Roy4a4NutvEA==", "910d5a26-609c-4da8-95b5-9839bd97c50a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "672126bb-5393-4a0c-9a21-06968c74cff1", "AQAAAAIAAYagAAAAEOeH2MzB48oe3j32Qs60pu4SrPTRnRGtTOOyFcU3ZD2DmSC0bCdQyXNcbjMOll5RZw==", "4e99c145-e778-4d0b-8404-213eb92f4767" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64c82070-00f9-4759-9b92-5efe436ab2b6", "AQAAAAIAAYagAAAAEL0ETj3s3HLgIIHZ+Ntwj5PxybjjR+o5fC6gHtrqE7EG+YLZrgR5MmGvvFqDUzig5Q==", "7859e1c4-9a15-4a5c-91de-b6276502a64c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d991703c-c76d-4fc0-a18e-32a84f916d1a", "AQAAAAIAAYagAAAAEKFV0j8cnybIeF36PJXionuwcbXK2lFR2bCu9mgqWPT9TkWwu4HZggU7Zd6Am+sa7Q==", "a30407de-9cfe-4f25-b1df-26f26961b290" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6e3455e-72b0-49f8-a64a-725488dc1a38", "AQAAAAIAAYagAAAAEES1R1ckyxTQB3CS/pPVLq851IWg/4TAaqPPMW2p9kPppZ65yN56g0LvqPPvEsIBZQ==", "711268a5-bfee-47a3-ae03-d0b672d4a190" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3955a175-2036-4123-ab22-e66884a3d3ce", "AQAAAAIAAYagAAAAEC5dAtCXMXdVczJmigmkZ/hn41hvgSIfs2T3L30gl4hJCDLY7efEa43Q9VTxKuIsRw==", "a33c0cea-d685-4e69-aa1d-7d152fbfe3ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d5d28f2-5b78-4b1c-b8d5-523d20755682", "AQAAAAIAAYagAAAAEGe4n413OV+jQQmXR26HrFqjuA8XOuedGM8GeOf2lQPKCGvWDyU+WTEQhvFP2fMVxg==", "4f46bc28-12b5-4703-a1cf-c67494ec97ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd953a51-f2ad-4942-a45b-b79b02c27e7f", "AQAAAAIAAYagAAAAEH+lrJn8GHFNgOQl0+xnQFPv/ie6FDHame4yQeTGEhEVohWN8/acaU2COCGYVdN1Rw==", "d61ffc49-0eb8-47af-8414-ab7bb9e6cb4c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d095ae18-e141-45a5-8765-9a36f361c6a9", "AQAAAAIAAYagAAAAEEFAddqULCSJ8/zF0X9BQRoyENc62nzCfCFml74UOBNVxTi7f5ZBVGFBfys5/l2IFg==", "fb5fd96c-ad17-4ac0-903e-cca6d04fb691" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c4526cdd-80e9-4c5b-b665-a908e1031d1c", "AQAAAAIAAYagAAAAEGD4HqLHKIioclGz6l5vC0UjHxk5AA2IPwxs2e6W5IOsbVzN8gkIqJAcAc4XWgVAFQ==", "d1a49aaf-6546-47f8-b88d-a2f7c3b7b5b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b32ca625-0f4e-4053-94ef-bc0903e9c714", "AQAAAAIAAYagAAAAENDkrNiqenMKBiYKRfUdmTduhMZg2PW2IOoilWbv8a1ho3PEOsU2WGQN7DjTMPoFDw==", "bfb009d9-4098-4607-8889-566947f9eab7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "494cb3f7-214f-488c-9108-ace96b1cc892", "AQAAAAIAAYagAAAAEEtmLcR9LowsAxiHoZ9Ta7MDJQEX+C9gZQX0vZFTgtjdlHm5ERgObs5y3Ye67Bs/ew==", "60988ede-f2bb-4526-963f-7fdaab61d326" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "273c457b-c2ee-48e4-84f4-3a7e58261edb", "AQAAAAIAAYagAAAAENO1WqVcz1pCH38d4T9O3P6kInks6673DqF7UdUsKKKE4SDwojePcs/AoQxi6IEN5w==", "c04125c1-1dc5-4760-a73a-d6080df0e439" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b06d46d-858c-4fca-b139-cabb153485ca", "AQAAAAIAAYagAAAAEDA+v5s0jSUNk07/hL1ah9X40gEaOFX7gzpeSopEdWe1ynHmEZ0oRtsTn9mVArYrVA==", "c0a144ac-88a0-4827-9a85-f2ac55b484c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ae77e66-5048-462a-a516-9c75f7185b25", "AQAAAAIAAYagAAAAEBIOB8g9t/oLL87ElLwwkgETSX/Y/26JLitAz39DB70LFJUO7dIaeVWnA2n/87PX9g==", "18fb405c-703a-46fd-b6b6-aa65fc8157d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "193cf606-d623-4ce6-82fe-07b38336e6dc", "AQAAAAIAAYagAAAAEFSNdfG9fJs0aCsr/h6ofgtDEdtZcEcF5iJM4Utugb/7OyfMEvS0xzbFnp6K0jwiXQ==", "17b10c99-13b2-4204-addf-d080aa1892dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d91a65e-87b3-4070-8a84-679e92c5ac80", "AQAAAAIAAYagAAAAEF9n+IZ2s1a+Z9/w1MQk24U+GPtJO3ek/GKOqB5ypF4wXE78eRGvGW2XUqLuUqGC9w==", "aaefdb2b-aafb-4e21-9afb-f86de68522f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5143744-bfd5-4863-ac49-851a8bf0aed8", "AQAAAAIAAYagAAAAEM4pz3ZyAs/6RecSwZQjIzdPEynjxf1Rb8u5Rd9mrKgwy6U0ImtydmFSiGE1+bfYYw==", "86950d85-ac7b-416f-8503-64178d80edcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a4f8de29-db0b-45ae-aaa7-e083cbb7bea7", "AQAAAAIAAYagAAAAEP0s6jnoK699BNeDb083xNElbRlX1FqE9jlI2+Y4AIFLnZ55ACvpuxmAidN7S0SrgQ==", "b061373c-8252-460e-aeda-824709d9dfc8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3fd2ef88-5ed3-4163-b4ad-745414e82334", "AQAAAAIAAYagAAAAEHv7y0OiMrmbieD5k8nP6XzX/Q41v7gdGk1p+lDRIvrpmYcf2O9lJ5vNXib1Se3C6Q==", "62159a79-88c9-4ad7-b1d6-1d2c3b17f574" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76facd0c-1049-4bdb-b4ae-91872426f3d2", "AQAAAAIAAYagAAAAEDOBRdNQuUtvb4cwa2Z6Pau1HZhfUhmaAdFHKULvxZJl4e04JCHuWXz1rKxxOFlUJA==", "70a7f99c-fff4-473a-9de6-eba26102254a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4335365-ab93-4219-89e2-c61e7be99964", "AQAAAAIAAYagAAAAED9luwByaJJGLVE1+ZZjtSZA8+vonKFQpQxDqftYH/iE2i7Jx/jKCj18cmTlmUaQ/A==", "9faa49d7-a0d1-4a6b-815b-675aaaf2ca4a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bed9a6c2-6470-47b9-bd13-a597ebb04aed", "AQAAAAIAAYagAAAAELNwO+TfrSmznIxsBNf2LNopxMdAEY77k5SU8JgQb3XH4RHQMWYxjLJMh6J2w+QWCA==", "9a92a304-673b-4ab9-b7f6-0d341459b326" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84fa7211-a38b-4b29-ab7a-5d7be15d4f5c", "AQAAAAIAAYagAAAAEG8Ueis2r10s4c0OQwVf5SPHMBQQCg3y5kKyDjdqeZOv0wP2929otCXZU8tfkAbPdw==", "ace4c392-5ad3-40d4-8185-8728607bd21e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72fe71d0-e477-4b40-b6b1-240fb0364c80", "AQAAAAIAAYagAAAAEKVCWfO9/pPC1VFXmxb5xsDV+B6wSdz3nbqKKfOwd2jVWFrugy90WbFeaqEIGR80pg==", "6f1e7b88-f7d4-4b3c-8a0a-297946bac62b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe733823-29c8-4f8e-b84a-d9d56e5ff82d", "AQAAAAIAAYagAAAAEFuySJKlwmfM2K521XJKkCn/bUeH0NhdF4Ltgfp3p1RmfODwKnnBrFBNUtzGqNTI2w==", "4e053d69-aedb-478a-95b0-2ac199bce180" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bddf92ca-2198-45ea-a378-e3078bed49c9", "AQAAAAIAAYagAAAAEF2+dfD9/qgBJ1tXcGmB4MRKoYrI078oy3IbwN0gTGstbSzmNblZ7sh6wPfGagGH8A==", "77d1c363-b470-4d6d-8428-6eadcf657f09" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98f701d2-66c6-451c-b77a-9b1bd96fe5df", "AQAAAAIAAYagAAAAENflYwDUdjYetQv5os11O7BEE8E1chWrcOPR80wKKPLpxYCxuuy83/dAjd62JDfDBg==", "7f7df341-259d-4611-b74e-c946a17c17b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb9334a2-b0ab-44e7-9d14-af8ec4a7f386", "AQAAAAIAAYagAAAAEDYWJjuWY/NXT9W5XZV9P+UG7hPrWRCfufhjmdZsy6XTZfJgRrd12Ag/QiAdUdra2Q==", "9dafb15a-bb3c-47ba-aa8f-6bf8d3d02bb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02d3f47e-6e2e-40da-9063-c0eeea7d8d76", "AQAAAAIAAYagAAAAEENoBjZjDx45aZIZEdkVXroTzLGXpq7Gpmf+3ko6g5n7cIjz2lJjF4LfmYBcXCHoaA==", "62b069f2-63fa-4e5c-bcb2-1c479c2816bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3bea1e19-e742-4da2-971e-b8b8cde4d6c7", "AQAAAAIAAYagAAAAEMNCKOc7N2huDK9gyz6jLJZRhjL9v5yq9Cv6coSSMDuu71gF/A65g3BrPD8ePcPtjw==", "e3818715-7417-468d-9e2f-3694ed02d3a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "PhoneNumber", "SecurityStamp" },
                values: new object[] { "176bbc42-944c-482f-93a8-6b28edb11663", "AQAAAAIAAYagAAAAEE8ySMiBbdvSrhNgTg7gFe0ipHwq4D98ifVQviMcXt8fHJjnBjw3laL0GosjIji6+w==", "", "c486518e-2c2c-4ede-a890-e4c3d3645e25" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ed5e9c2-2b79-445c-bfcd-cd0d0db033c1", "AQAAAAIAAYagAAAAEDCCUutH9fJsbmjiyqzoNpYCuOimljmibGayv+Jmxyqbasnl0TJYU5edqUxZ9lUHlQ==", "198414b7-89af-4b4f-aa78-0cf8f6036b44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3da9fb55-6a4a-4b90-adde-176b6911165d", "AQAAAAIAAYagAAAAEFCOlG0ymcOQh4dO/rzd3iF5NqT1zhk09928bb+U8XlPuadgw31PAdBEeVbVh79SmA==", "738963bb-6da6-4eb9-903e-69820835df2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2d9e284-503e-4060-b462-17e15179c66d", "AQAAAAIAAYagAAAAEGwDAgnyqm4lJP98al/UzdaYWdtVCQkEW7K02AQwPyZg6O9QILng1lXRXTfrKPtT2w==", "72b17513-ab59-4374-9ca3-55dd23fea751" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ede5dbdb-906c-4d98-a871-0a356483c9c6", "AQAAAAIAAYagAAAAEGmT5zDYXLAmOZGoF8ICNo2nJYjvHdhd/s1ZAxpcOpIfSCaqbj0uYG/LwQhOruq45g==", "f0687095-650e-4c90-a663-6eb9e56172f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ba3583c-b29e-4292-9882-1db5ef660a20", "AQAAAAIAAYagAAAAEBg/7ZUpqGcpgX4KB+r/z5gDgPluCe+w4zlpVc7hzMkOsFJgmJM4HKQuItl/L8ylWg==", "2357187e-5607-4a4e-b8ac-9d701709bbae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3382cda0-1abe-4099-9672-549c9692df3c", "AQAAAAIAAYagAAAAEHD0FBWH8Q7zxp6s2si9nhvXKRF8XbT1XKeedfL24xHxvcunJuITUYJJAaB5UGacuw==", "69969220-eaf5-4be3-a498-814b76d77ff7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0694656-21d2-4348-91e5-fb77a81b6286", "AQAAAAIAAYagAAAAECmlH3czBIzqzrN5JEcEgLoLrvG/uTtuKnIC9oLarKKqSgvD+b3yBEeARkHhOVi8WQ==", "3c859265-0fc6-4e1a-9985-af28d687c159" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a86a8d3a-ee37-431e-8684-e87a4a0f50db", "AQAAAAIAAYagAAAAEPkQ6H8fJ1qA+ZiojOx3NXQDiIdJcoZ/BWl4nNz7lya1hB7Asq9TilqOZ6YOc1upiQ==", "b02babfb-881d-4146-8f8e-88eb76c6484e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28dc5bb5-6992-4f76-8f29-9f702915ab70", "AQAAAAIAAYagAAAAELqEjUbOsK7rd0LHSyOw2tkASR0lilzSfOTcM54KpggSjJasExT+Q+W3GaDked54dw==", "ce7d18e6-fa14-4d2e-991d-1daa14dbe4a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2050e4fc-35ae-4c34-a311-002337569216", "AQAAAAIAAYagAAAAEPPYk8OWJ3vtUlxeeTZlHqj0S6MyyuDy/WF4PIuWmYHE738+0FahIsnGdAkK26vvPQ==", "5c7cf452-07c6-41a4-af8b-309d866a1c72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33060b66-bd47-4012-8c8a-2ca04852ed51", "AQAAAAIAAYagAAAAENa77FezijttvKxw1loUJnkF35/KackrEpbfEmlei9zjJnCWQLZ8sSe0NzLk4gOqVg==", "229864de-0148-4b90-a4a9-0db09063c57d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "054b165d-be27-4411-a69b-572b9d69eef4", "AQAAAAIAAYagAAAAEMotPAUPff/8JGLDDUjtli6sHKCRkdbYNWvP5JWvnyqfOUeEiwNwXw0wCQ6R68vo9Q==", "a9f05e21-75c3-4ab2-a187-aafbda038044" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp", "UserName" },
                values: new object[] { "5efc166e-0a5e-4024-aa35-154a09b0e7b6", "AQAAAAIAAYagAAAAEPGkyXhkU6ionPMBdV8p1VsreG+7V8ld/6LP+rar7+CELJODcWn7WRdbz44LFExizg==", "a19a22bb-870d-4eb2-b411-6637d7facfe2", "ortiz.portia" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "baa42752-03e5-4740-93c3-3f6e1ac29d17", "AQAAAAIAAYagAAAAEGdaX9c71ujNmd2Lmh71aTAsXnYmmaSdcnAeSCuhPRd59HIAvpiISShpAcae9ThG1g==", "003f709c-fbdf-40d5-a45c-399dded150c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d71690d6-f83c-412c-8fdf-1b56271b2b0c", "AQAAAAIAAYagAAAAEG95tV+Ww9vaQW3P3AwqgUUa56kvpIXmkc8avMRJh6D/wypeuA4Cr0jpIJVX/YcZUA==", "54bce4c6-a0df-4356-8deb-7a800f9df45f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb0cdb82-9b43-456b-83cd-d162aeca50dd", "AQAAAAIAAYagAAAAEOPZoliojqoxH2d1ob7n+spSRWIzliWfdbark8zVYNtVSJ3eH5WBfKNrmUOsQ60TiQ==", "fe7e9a02-dc86-4120-b33b-d9a804283db3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ce56638-fc7f-4676-b5e1-a29084b24104", "AQAAAAIAAYagAAAAEDubiqdYTKuhnkatGHM7zsUkqMjCrON20WSN/zM/ad/+chAIpHtIIfrd5jtpHktwdg==", "4b7ebb08-4fc6-4282-b029-92437e547532" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7ea8c956-6f61-4344-b30e-76516d3919ff", "AQAAAAIAAYagAAAAEPSjEXUOWR8nkvXsXjfk8GnzZWVAqB7zBPWYzXlXsO8wLyAOohZjMrVuBCelrixdMA==", "ed762e48-e6fa-4457-a309-f3f06e9f78f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2ac77fb-cb4d-4ccb-a011-c9acdcb03e2f", "AQAAAAIAAYagAAAAEJSVacXzhxjRoQoIkXfcCF8l5Z4enyBc9pRPpGi0lOyuoIjnI6jcFXjIkuZ6x0UL+Q==", "2a4f6f7c-5b30-4cae-a3d6-3e2ce3c07980" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9eb12e0e-a2da-4110-9c8e-ed0f4ce0c545", "AQAAAAIAAYagAAAAEGswh9qx2v5aNDPk5gsSHnFAnSpgMaDjVCJAI0t8IH04VF3ASTM836EVcOyObavvAQ==", "0e86f434-6c0a-427a-bab1-0d8d646aa16b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95258dd5-2969-4d88-881e-eabe88988938", "AQAAAAIAAYagAAAAEDbq19vJ8Ka0MOZQBesPiPfW3ObPhuXt16p2VaM34BYEXbAqCGO1ZWFr6ArA/KCT1w==", "ce6d5044-d68a-48b8-88a1-1595d275ff60" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "80cd9e57-a18d-4876-bfc8-23790af6323d", "AQAAAAIAAYagAAAAEE1FVmKyALmkY7eBhtNccDCkL0wmCQ7wf90VPIjGNIUu9K4TyLwMop/+ZsYoTyX0Pw==", "0733dceb-de38-421e-a612-13b1eea606b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "faed5046-2652-4acd-b3e7-ad0dcd5d3b59", "AQAAAAIAAYagAAAAEOU1MUNswF3XQhl87QQmvLoVhLg0KFHcWPU1j+D0E9/IkvP+Zna0zoCl23ip9zJ/Lg==", "b7718c55-799a-45fa-908c-f04dad2deca1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "459a9ee7-ecfb-4b13-a234-a60e4b6db214", "AQAAAAIAAYagAAAAEEwYhOrjwTJwTIYe9oMf7rXEXDio5+BzzUT2im8NO6AAwHNkUouDMbsSi5v90cpyiw==", "4f289d61-1196-4c26-9b9e-20656e3cacf9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f4ae4fb-2bb0-49f9-a809-2b37ac8fb927", "AQAAAAIAAYagAAAAEPQoG6EbamVPKWNp7HyzrvuDVna4cTjRyFk7kHpK+/XCcTBlU0PCEZZEh1gZZzzvZA==", "98d6bfa0-af7c-4400-b0b1-3f394e187b23" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "652e2cdc-9e55-4c07-82f0-30939568e309", "AQAAAAIAAYagAAAAEBKrwx4IlYFO7ZVR04tTUmhi+IwltKl/+SD4BvjqxVDVlhRqoYEERiSg8IsCkLj/Rw==", "37ba4123-db8c-45e1-af26-1921be76d4fd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b86be488-d330-4c49-9767-53ffa2951ada", "AQAAAAIAAYagAAAAEAtE2jrvTV+RmHJKssNki35kdT5Ek0oe+BbZLKNCZispDjCvm1HxTmjKynFzv8RCzw==", "b8ccd4c5-ac45-4836-abed-01ba422dd023" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f86bd87b-36dc-4554-85f1-1545c21da229", "AQAAAAIAAYagAAAAENEKO/3/nwtySNCEwN4oo/qPqqo5K3AX/MjbmYHDWNxRFeQL5ydmZNVGqblVz+JZzA==", "3d95ccbf-937f-4ca6-9f41-afac2b53cf41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eadd34ef-d976-4ac7-9b13-bd982734d65e", "AQAAAAIAAYagAAAAEFqm8fbLnKaXfmXdHdkyaudo9dfSQJo5HmWiGXAHRkBIgEPvEgrZpxcl92IzbUpxnQ==", "a7427a2b-e1d7-4d45-8237-9ed0f2598e7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9e64aa5-818a-4182-b1dd-812d1413b6b2", "AQAAAAIAAYagAAAAEKRHrTd1+332h2LZQOJll1jkUZLIm0dWmAFUO4bQ/56JP07B6qlpFbaMCnEFNGp2Ww==", "82a40cda-11f9-4f75-b395-09c2efdfb060" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff21cb27-e387-402d-b312-2d898d6c312b", "AQAAAAIAAYagAAAAEDQuCfBp+Hoe/nr2V3Qdme9UbUNgGFRoZSwkQy1EPZfW6WTDvG+NBHmmlN9YqD1rpA==", "265c6742-7f30-440c-a255-c59260d904d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df11f338-317a-4a1b-bc90-9d604112ad64", "AQAAAAIAAYagAAAAELamMUv83rFKy9lsKbJnDha62klwzmMpwUZ3//byKaEUPP4tGoNMKJARtemQf87NWg==", "3625b853-a954-4761-b376-b9b8017a16a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a94298a-4d7a-4fc3-bd42-986042e06464", "AQAAAAIAAYagAAAAEF4nAo9LgafNGKde/n60NnVB8EBwEYdZcN2dyYbYja6a7aD76MG0tXolYCFSE3EJQw==", "b02db070-69dd-4263-bf56-37a89d656d4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ffc0f68-3dee-43f2-a6b8-0589f1985b55", "AQAAAAIAAYagAAAAEHmEFRvd0lOUZ+aHB3/1DO1O1hYZtiqgUFWRBWO1q92oRg80Zig0AnHNpkbnBD80bg==", "398bd778-ad25-48f1-b1b6-7ab1924b9bc5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "91cf0e6c-b4a4-4f64-8c9e-f643af26551a", "AQAAAAIAAYagAAAAEBCF14ex5btlFc5yQCfu1knVrCThME4U9QoJvMfKnoXQK7TEa5SBR0y3cSE+8WC8Zg==", "1dafb78a-1c9f-4b8f-968c-bb3f45e5987a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99aa2c41-4bc1-415e-beb4-65d747a7bb1c", "AQAAAAIAAYagAAAAEPatFgSop4vzAFsj57IcSWSPYIVGEhICNrESFYrHNAyvLJeXU2/VRPY1nAHRWrcHnw==", "e9f23a89-920a-4b55-9640-1195d96a1327" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff3cb307-2b6b-471b-9a6a-29b1077861c3", "AQAAAAIAAYagAAAAEIEVFRnrdt0BifBTV6YhkV9D0g1e/1fVNcbHhYoOgeVbVTwKU49EYQgwhXa9VT/vdw==", "16bac832-efca-423d-a8d5-0df98635e1c7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08d6a46c-42b0-4d95-9ecd-3f4e4e88339a", "AQAAAAIAAYagAAAAEOrsN0MdQbU93TOf2y01yDCAPp9HBLDw+6k23JLNNapXLxlL+48CjAYfYuhxG8F2Cw==", "11ab2731-1b06-4a2f-922a-3b139e77d668" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "699dd8e2-7476-4ae3-86ca-ae1831234135", "AQAAAAIAAYagAAAAEL6foXAucQvz2elDR8mhaPZKJbVV6wZn9wwbag91yvUu1HE6CeMVM2TAB9S0RsRVaQ==", "3e297b7f-e732-4f0f-af75-948291f302cb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99a18fda-c8d1-4a55-9797-f1f94041de16", "AQAAAAIAAYagAAAAECWCehAxjUA1wNF0oF+suSQZU7YbyP/ovTet6bVvlmFGGbgfuyBQsQ4JsE0iCVdjew==", "6d07546c-79f7-496b-a837-f3ae70b176b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8c50dcc8-b666-483e-8852-9b7ae43eead8", "AQAAAAIAAYagAAAAEJPMGhT8RVAdPG/0g/l7Sm2v5V58Nh0y7EhicKHJPj2VByXIXxhXeoz8/CFxNdcQvQ==", "b46cd958-42bd-44ce-9f8b-b575bcd67d58" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55aa43cd-0c9a-4886-8d88-a50e1424bf53", "AQAAAAIAAYagAAAAEKrAsF0PvmqxtIlGTvaxBkIS81vZkFnxpkny55nAakICA3qYN4deYYO5iJvDxbRf5w==", "eb020bc9-8582-4fbf-b01b-bb011ec59322" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c230af89-1208-43f5-a127-34c7c8e6157c", "AQAAAAIAAYagAAAAECGvhmm4E1NYaC3kV/YvODjiHxhj/zQze6EiKuJQXMr5OyCQhyPInp95Ilv6qAsDSQ==", "01eef82a-ace1-4eee-954a-735b48b4834b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78cc9052-5f37-4d1a-8d0b-a945b61a96fd", "AQAAAAIAAYagAAAAEIWNFOo6+4o2/pBuSwsTGhRbB7x5SqfXaqq2eY18oscSrLWX1u0LwtMILKGg7FRFfA==", "d154ac59-c2a5-4cb9-8040-c8e2bea48b72" });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Discriminator", "Email", "EmailConfirmed", "FirstName", "LastName", "LockoutEnabled", "LockoutEnd", "MiddleName", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "Prefix", "SecurityStamp", "Suffix", "TwoFactorEnabled", "UserName" },
                values: new object[,]
                {
                    { "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543", 0, "be8bf33a-f665-4f33-827a-a7e91153fcbd", "User", "ramilramirez097@gmail.com", false, "RAMIL", "RAMIREZ", false, null, "LIMBAC", "RAMILRAMIREZ097@GMAIL.COM", "RAMIREZ.RAMIL", "AQAAAAIAAYagAAAAEKON5ZL9LURHSZXmpnJbmUWyoc4VEbiD6SY4w/vWCP6SZZvz8ULf43qnYIRBUgtsjQ==", "09065343887", false, "Head, Housekeeping Unit", null, "ccdc90d1-b7c7-4720-a586-5e7bfda51cc2", null, false, "ramirez.ramil" },
                    { "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872", 0, "01da3d8d-23a7-460c-845f-e4e0228feb2b", "User", "quilnetgerry@yahoo.com", false, "GERRY", "QUILNET", false, null, "APARECE", "QUILNETGERRY@GMAIL.COM", "QUILNET.GERRY", "AQAAAAIAAYagAAAAEDaBovDgky8gny44oZ14Lf9Xa744ICrE+gJTVdyF2numRQTFKsArZ7Nmyc5MVm5N+g==", "09273691473", false, "Head, Laundry and Linen Unit", null, "31c9c24c-204b-44b6-93fe-b70bec8d0fb0", null, false, "quilnet.gerry" },
                    { "123rliom-2akV-cl381-uwe9-kah8h3f98632", 0, "5499cf3f-077d-4d25-a47c-fef4909e349c", "User", "sonjaandsanji@gmail.com", false, "SONJA", "ESCARA", false, null, "DE LUNA", "SONJAANDSANJI@GMAIL.COM", "ESCARA.SONJA", "AQAAAAIAAYagAAAAEIJI2qBkn89WIqUQrnqG2pi9RSz+49b+LhuMry8S/1OmHbLncZd/5A7iUyJKeroECQ==", "", false, "Head, Infectious Disease and Tropical Medicine", "Dr.", "82c9c862-e82c-4dc4-acbe-2ef20478147a", null, false, "escara.sonja" },
                    { "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg", 0, "14a55721-8355-4dc3-93c3-08fd118ba6a6", "User", "honeyletchristie@yahoo.com", false, "HONEYLET CHRISTIE", "TADINA", false, null, "MAGHANOY", "HONRYLETCHRISTTIE@YAHOO.COM", "TADINA.HONEYLET", "AQAAAAIAAYagAAAAEDmY7gFCW5SjBYm3YhWkbbHlWBGxq8DjQJYna/elIUpiDppUaTBuLQHLyH9Fiq9lRg==", "09359763862", false, "Head, Budget Department", "Ms.", "fcfe9f98-b635-4114-96ab-b8348e94eb36", null, false, "tadina.honeylet" },
                    { "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3", 0, "c5aeea0c-9dd4-492f-ad6d-57d24025f0f0", "User", "alnazaer1994@gmail.com", false, "AL-NAZAER", "USOP", false, null, "ABAS", "ALNAZAER1994@GMAIL.COM", "USOP.AL-NAZAER", "AQAAAAIAAYagAAAAEPHBxGztnxb0ryVKgmPP/nVqoZwWBSkup2CyEByeP8CYqHzbVzL7Wv3fhjgnmDsPLg==", "09458250199", false, "Head, Infectious Disease and Tropical Medicine", "Dr.", "85acc56e-042d-42fc-a7be-0e3e0e31afdc", null, false, "usop.al-nazaer" },
                    { "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V", 0, "b30c4920-44a1-46b5-bdee-40f9b012db43", "User", "", false, "MINDA", "CARE-IT", false, null, "BADILLES", "", "CARE-IT.MINDA", "AQAAAAIAAYagAAAAEA5w4bi/XV4yDvPQK3ymPYfrsl/fH3rljhdSvbqlMyqMMtbodir5SuA/fpr2wUHgRw==", "09326564879", false, "Head, Planning and Management Unit", "Ms.", "a063dd35-1b10-411e-89a7-c8a138417f9f", null, false, "care-it.minda" },
                    { "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2", 0, "c8570daa-4e18-4a0e-a99b-88d3e423ab37", "User", "aprilglimada01@gmail.com", false, "APRIL AISHA", "GLIMADA", false, null, "MACAVINTA", "APRILGLIMADA01@GMAIL.COM", "GLIMADA.APRIL", "AQAAAAIAAYagAAAAEGrVMstwyvb9FFfh/A8U0toOOc/aBXUI27qGd8tVW1sWwevwXPiMN3GvpsAyHPjOeA==", "09171488596", false, "Head, Mental Health Unit", "Dr.", "cec8a5cc-158b-4bac-a42d-90497d1ce19c", null, false, "glimada.april" },
                    { "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190", 0, "712b15ef-4241-4499-8e0d-7bbeffb9232c", "User", "somairha@gmail.com", false, "PRECIOUS SOMAIRHA", "GIO", false, null, "ALIBASA", "SOMAIRHA@GMAIL.COM", "GIO.PRECIOUS", "AQAAAAIAAYagAAAAEB/x+cPNh50be4nXWNpYbkzgGntLrWYQaOe3rQr3NLZb5hTcAIz49lQaiFUGtUyD3g==", "09171237248", false, "Head, Emergency Medicine", "Dr.", "eb09c994-a260-446a-9273-8f40e093b327", null, false, "gio.precious" },
                    { "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24", 0, "232e0600-cd3e-4db3-9074-5b8efb269ff3", "User", "mtmadeha@yahoo.com", false, "MADEHA", "MADID", false, null, "TAHAL", "MTMADEHA@YAHOO.COM", "MADID.MADEHA", "AQAAAAIAAYagAAAAEOMaH1dj4yckwAJwKYkJ8Ss18U30OBJ6g9LQEl6x1r8NzCIb0mPNKQ2YFVeEldwV/Q==", "", false, "Head, Geriatric Care", "Dr.", "ff347ef6-1d70-49e4-bb9f-321a9edf3cb8", null, false, "madid.madeha" },
                    { "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e", 0, "6e544f4e-009e-43bc-b567-ff53d3a590d9", "User", "sherjank@gmail.com", false, "SHERJAN", "KALIM", false, null, "PANGATO", "SHERJANK@GMAIL.COM", "KALIM.SHERJAN", "AQAAAAIAAYagAAAAEEeFINWNZ2ZTYHnTKTplY0P4E4GtM2vg91YwInIfy16UkWaT0Dtg7apRBtOiMWTF3w==", "09179713201", false, "Head, Soccsksargen Regional Blood Center", "Dr.", "f28844e9-5775-4896-9d3b-e23e08b34502", null, false, "kalim.sherjan" },
                    { "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431", 0, "2ea6b2b0-871a-4c91-a003-629acbe1eea8", "User", "cpulauban@yahoo.com", false, "CHEERILOU", "LAUBAN", false, null, "UKO", "CPULAIBAN@YAHOO.COM", "LAUBAN.CHEERILOU", "AQAAAAIAAYagAAAAEMioFMQdxKYVt2yWZbZCKGtqHO3FARN+wLUpbVM4jLuGmK3RjA7q6F1baiLbSEVWzA==", "09171237248", false, "Head, Medical Insurance Evaluation and Reconcillation Unit", "Dr.", "966c1e7c-cf6b-4d10-ae03-1ce6c380e9bf", null, false, "lauban.cheerilou" }
                });

            migrationBuilder.UpdateData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 79,
                column: "Name",
                value: "Cardiovascular Care");

            migrationBuilder.UpdateData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 126,
                column: "Name",
                value: "Legal Affairs Unit");

            migrationBuilder.InsertData(
                table: "Offices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "Name", "OfficeTypeId", "ParentOfficeId" },
                values: new object[,]
                {
                    { 187, true, false, "Clinical Departments", 2, 3 },
                    { 188, true, false, "Critical Care Units", 2, 3 },
                    { 189, true, false, "Isolation", 2, 3 },
                    { 190, true, false, "Mechanical Section", 2, 4 },
                    { 191, true, false, "Planning and Management Unit", 2, 5 },
                    { 192, true, false, "BUCAS Center", 2, 2 }
                });

            migrationBuilder.UpdateData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 30,
                column: "OfficeId",
                value: 157);

            migrationBuilder.UpdateData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 95,
                column: "OfficeId",
                value: 188);

            migrationBuilder.InsertData(
                table: "UserOffices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "IsOfficeHead", "OfficeId", "UserId" },
                values: new object[,]
                {
                    { 102, true, false, true, 85, "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074" },
                    { 103, true, false, true, 159, "7cfd0766-f3d3-47aa-9a48-53d437d6c232" },
                    { 105, true, false, true, 172, "de17cb47-83e7-4a6b-b97c-13808e14a7ff" },
                    { 106, true, false, true, 120, "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e" },
                    { 107, true, false, true, 121, "x8wzlubz-1cb3-4c3b-9d0l-3ll9y81c852d" },
                    { 108, true, false, true, 41, "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg" },
                    { 110, true, false, true, 22, "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8" },
                    { 111, true, false, true, 66, "9821dbf5-0f70-4630-8c68-f2077a3abf08" },
                    { 112, true, false, true, 9, "eeadfae2-544f-4a5d-9027-808537e694b1" },
                    { 113, true, false, true, 138, "4e21fe59-4f5e-46b3-82b7-28df270038da" },
                    { 114, true, false, true, 135, "743b9807-3441-47c1-9285-5ff8dfd7acb9" },
                    { 115, true, false, true, 76, "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e" },
                    { 116, true, false, true, 76, "399f5e43-93d8-4a28-b113-d23eccd2ea15" },
                    { 117, true, false, true, 62, "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190" },
                    { 119, true, false, true, 74, "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431" },
                    { 120, true, false, true, 184, "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24" },
                    { 121, true, false, true, 185, "123rliom-2akV-cl381-uwe9-kah8h3f98632" },
                    { 122, true, false, true, 185, "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3" },
                    { 123, true, false, true, 36, "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2" },
                    { 124, true, false, true, 36, "a6b59fd2-75eb-457e-90ea-d1d419da5f6d" },
                    { 125, true, false, true, 71, "b4d73e5f-f530-4a4d-9c3d-0b364236da6f" },
                    { 126, true, false, true, 119, "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543" },
                    { 127, true, false, true, 118, "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[,]
                {
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "123rliom-2akV-cl381-uwe9-kah8h3f98632" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e" },
                    { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431" }
                });

            migrationBuilder.InsertData(
                table: "UserOffices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "IsOfficeHead", "OfficeId", "UserId" },
                values: new object[,]
                {
                    { 100, true, false, true, 187, "2z9f8451-1n19-4b50-8432-4e23c164cs51" },
                    { 101, true, false, true, 187, "a1e10c26-4d1d-4f9e-9378-1382457c82ad" },
                    { 104, true, false, true, 190, "576fc42f-b0f9-433b-907a-29d98ebf7af6" },
                    { 109, true, false, true, 191, "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V" },
                    { 118, true, false, true, 192, "cade94b1-d0d9-4ded-a46f-c8473d9fbc00" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "123rliom-2akV-cl381-uwe9-kah8h3f98632" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "2z9f8451-1n19-4b50-8432-4e23c164cs51" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "399f5e43-93d8-4a28-b113-d23eccd2ea15" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "743b9807-3441-47c1-9285-5ff8dfd7acb9" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "7cfd0766-f3d3-47aa-9a48-53d437d6c232" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "a1e10c26-4d1d-4f9e-9378-1382457c82ad" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "a6b59fd2-75eb-457e-90ea-d1d419da5f6d" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "b4d73e5f-f530-4a4d-9c3d-0b364236da6f" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e" });

            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd", "de17cb47-83e7-4a6b-b97c-13808e14a7ff" });

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 188);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 189);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 100);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 101);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 102);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 103);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 104);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 105);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 106);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 107);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 108);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 109);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 110);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 111);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 112);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 113);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 114);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 115);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 116);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 117);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 118);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 119);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 120);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 121);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 122);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 123);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 124);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 125);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 126);

            migrationBuilder.DeleteData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 127);

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e");

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431");

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 187);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 190);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 191);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 192);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "a46d37f3-51f8-4edd-b8da-ab70fdafdde8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "6a71318c-cac0-40ec-ac3d-b7c14a318ce0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "85ad7cd9-ff59-4a51-b372-92373e936f85");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "b6d71dbd-3970-42a8-9d00-a61799c13ff7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "261bb7e7-5995-4b1d-9c47-5f22b9bb14c0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "57d158a3-be29-48dd-a617-93252654fcb8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "8859697c-3039-48e6-9f86-2569e09e8be0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "3f5d67f9-a3d6-4c85-970c-73ead1faf5dc");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "4cc9c369-30e3-4891-91d6-3e4aa513c8e9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "e92640f3-3d47-4ad3-8a78-b0640c788508");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "e48d10ba-8d8a-41b9-b596-fa1ce99f8cb8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "f1c2b2b6-4708-4b2e-b598-c43d0a53edb5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "c5fefa38-e9ae-435e-acad-2b594efaa2de");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "77065230-da2f-4bc0-b0a1-56e96a0bbd2d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "ad0443ee-cf03-496b-8df5-16d4e88595a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "8786540c-90a9-4216-88c9-421b4273c383");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "f71533d0-f7ed-410b-a026-2a8702699e9c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "f2346fd0-5fcc-41e9-93e9-c6b9bc6ce924");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1308a6aa-eef7-41b5-9372-6193040b0633", "AQAAAAIAAYagAAAAEDsnhTSac7bALd4kNrf1DpNlZgrvVZhO0oOBbY3FmUJcnIZggajfe8SMCZI/blsVeA==", "ebe32e0e-3067-43eb-9c90-3e76b9fa1bc1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7eac917-5a2e-4b36-87ca-570f323a0812", "AQAAAAIAAYagAAAAECHTTMEtezs7jtL/RUbxA6sMhm1D/UPfV0PVwtm5E13h+ckdhcZUGH0x8hPMBKymQw==", "b3408cd2-ba46-443c-8390-22986374c53c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62a08415-9092-4bb3-8803-f435077d445b", "AQAAAAIAAYagAAAAEGqThiYST85UzHwP6oLxELeOO8OvocLmEsfaoqlDSuBdYRNgHM+8iZ69vP4jvJQhyA==", "c03b35d5-dfbc-4c57-91e4-5deb8211f517" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51a796bd-52b7-4f85-a386-33f434e0399d", "AQAAAAIAAYagAAAAEAKu5WiAUc/7rWxBhpZRHTxAUyEBWaL7bbfeU6CmvTrouFfJJ91iltDgP98xLjUI6Q==", "32781be3-4701-4607-9ca7-1712d75ae2d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64c3c6ec-784e-4d1e-b9af-7e3221eacad1", "AQAAAAIAAYagAAAAEPdJvkYJAkl3/RXCSQ8SMJlT3uuo3YTIDXjk0Ly2V19Wx93soi2V6YaJcoH6sxpQkA==", "96f62e79-e438-49b0-9434-f9c79df077fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "32313265-4b59-40e3-bccf-0b54420c0294", "AQAAAAIAAYagAAAAECdvyAagTrqLgj+zr7tinBLHZpQKDNMFRdgJnHya4f9tx5UiW8qcitfzsu8BAjKnBA==", "62ae088f-61f9-476c-b14e-ddce88f7c444" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9eb3b98-2c0d-4ea2-adab-4505161a6ad1", "AQAAAAIAAYagAAAAELBMtHF5rGJGyQKdvr3J1mCRYD96JT1bDIk63Rl36l4OZOK5R+OZTmvoAIt9DbOYIA==", "fb4cf77e-9ad4-4b89-80e6-4be83f343b5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ffe4ed9d-46b9-4727-9b59-1ad5e049742a", "AQAAAAIAAYagAAAAEM5W/XVX2/Wgi9cOgZOS4xNjEP5Y211JWe/6Ruh3u8z3vycBWv9aP3EVdygfizsF/Q==", "4356a67d-2897-45de-b6d3-d8872a71b2b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a81baf41-0766-4dfd-a6d0-bb7a47d52570", "AQAAAAIAAYagAAAAENyzFM+h43SYeZN7AMvzMdUy10FQLPi79MYECmrFPazHhx8uMkQHW1Ps6OJ4F/uIQg==", "a0760356-c7e5-4fb5-8d5f-7e2996f6d528" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54dc89da-6dcf-4119-9e0e-8f86de7cb9fd", "AQAAAAIAAYagAAAAELLdmr2sZjgZ/vAzHus6sj0RTUzrdeutTvzBrjxfGvO1JHrlyYao/7LDzU4tkM5YDQ==", "4255e706-6822-4286-a66d-dbf88682c6b8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3fea665-b7cc-45db-a66d-77399c333a27", "AQAAAAIAAYagAAAAEDoQ1tzEm8yt1Ra82tG2wnLJXvnLWv6yyMRaNmpc9xoOAX02GD/HhMJbx07crsZ2Uw==", "520cc703-e01f-47cd-a60d-d06096516315" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be66e37b-d7cb-4f1d-b16a-cf79bad8cdd4", "AQAAAAIAAYagAAAAEFQzigQajb3XwOLo/PjBttQchHD8rPLfzYDy0ldB7hXWaRf3ayPWnbRtBHYqpF2akQ==", "9525322a-c854-4dd1-b63b-4eafa3fa50ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7b03c5bf-85f9-4fb6-8a96-f33587c4ccd8", "AQAAAAIAAYagAAAAEAllTx7HEEe1ca610k1r+Mx1LIlR06T2J7TkOOy9D73A6bPFo2Ctu7VT/j+J5sw5ag==", "014523c2-f875-481d-b0c0-18888ae6bee5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5b90d26-220a-46e8-ae1d-1429e2ab2aaf", "AQAAAAIAAYagAAAAEN40Imw7AiaKc9w8xayZ/6yjHbeVSqtlQ8IovXS/VE/HIxz6zNyXfLdlI9qeVNeGbg==", "8008b772-efbc-408a-8d7f-ecee3b285b12" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1721ae4b-51d7-4338-8795-81622df7ad4e", "AQAAAAIAAYagAAAAEKlHsgNFYGx/sa/hNbHBNhcSqv/FfWkKMhOqMLet81Wi119bbbNmNhcP+t0ZeNbnUQ==", "cf07594a-48b5-49fb-b130-2f5e6826e421" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "214f6be6-e667-4a41-b267-d867cd71e476", "AQAAAAIAAYagAAAAEE/S3gIHuX6/jbjI/hbRu19cJqC4VGKPsbEGWkHIJ+kA6XnBxqNbvar2bTEJHY3Akw==", "b8c349ab-ba85-4eae-a4d9-ad2803f8d255" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e905138-c8c4-4c5c-a48c-f50f5d05b8b6", "AQAAAAIAAYagAAAAEAtoOVMFgahtuRPtFqdLdFhGOoOTiMibQ5pTCUWs0RMrgavNtYQ9EXUSOyoXHv9yTQ==", "7ebdc97f-1279-44cf-ad59-351b4f142ea2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb001fe3-5c7e-4b6a-9aba-b548128b4f85", "AQAAAAIAAYagAAAAELui98X8/YitHOWN6dTJSt+eoi3g1b3+EtVJDS8veM46VfOs3KW23lbuvTphSwhbIA==", "71b521bc-b5a9-4585-bab9-d8afc1eaaf48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8eda715e-8e3c-47c8-aaf0-70e99772402f", "AQAAAAIAAYagAAAAEBzeE+v+hVpTc0gBC92fl/fSoDqfSqJV6ipijjBqZ7d6fkEpc1c9EQRCCXKK2cpd4A==", "d3f2b676-e440-41ba-8f4b-d65f1bc2a345" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f953a75-4da7-4348-bc17-459ce7d7ab4e", "AQAAAAIAAYagAAAAEA2U7WD9lIpLJWR+yfap7B0qZdaIwRy5gBztYc5aOzepiwZgLTW4urJVS9RHvdXbiw==", "7b727026-361a-4e75-a602-87811b0588ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3771e613-64ba-4bc1-bded-6b98ab639024", "AQAAAAIAAYagAAAAEO7mgJgf8EGhbvWxkberbrcXMCqgcdlgxEj3mRiUOwdj/7jBE33eX7IZ0ZiQFjR7oQ==", "a7028e98-bfca-483e-955c-3b57e06f7601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "732ed52c-0508-4675-9b22-e251cd53113d", "AQAAAAIAAYagAAAAEDQ1bBG+8f6nXtTWDe58ERY0Y7iG4ErX9EfMIk/txnmxDYPu+9eHYckBI2lK2ooKjQ==", "9a1c9e28-c4ca-4f40-b95f-e49da014095e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5b68e43-c1dc-4945-8161-ec553b54b315", "AQAAAAIAAYagAAAAEEsie4YwFqRQ3MQvYkh/g9IRYpgDtG4GFX2W3xlB8ZNq6xKC+YrO/iWrEhRonra6kg==", "c065a4e9-764d-47bd-bbeb-09ceb823e0af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d8d96a0-786e-4be1-9c0e-57806ad64cb4", "AQAAAAIAAYagAAAAENzfjNRHd39yZhOEVDEODRucczBQyF33h5TZ3xhERgfVBoKMLBPCs2Gu2gMWPHGsnw==", "15e150e6-153f-4928-ba3c-ade3138d2572" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "05e3d7cf-51c7-4445-9849-6be6c846dd5b", "AQAAAAIAAYagAAAAEA/Ja681mbjn3qoxTOFhcy0Yopo3trmDdEHyOYzzDecnQHyiSmEzSKtE5U2CJHu5nQ==", "8faabb20-743c-4295-8811-2cb157607e9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "edd93066-85b3-4632-bf2d-bee7082a9327", "AQAAAAIAAYagAAAAELTKO9VjE9O4XkutQFP4vtcq6mPAMOJb9YhHaES6JWrfZax4beJs/cbKpE3H2JGHxQ==", "dce3d37f-e1cf-4361-b04c-0f890c94417d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbd13c86-380c-43ef-846f-dbfc6a834ba9", "AQAAAAIAAYagAAAAEFZ/4TL0mWglLXWIwn/Q7aO7wgqFfB3sxfE0mTQsUH3vmgeii6Tp/Can9yB18yohQw==", "f5b5f91d-a1d4-4f45-b7f3-cf24087490a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a224e28c-045d-4f51-b16f-0a536c2a190d", "AQAAAAIAAYagAAAAEJq1tNjgc1Z8TLueFWEkpHTNe/0nj5520ipPYM1ldsxhxtcFeApUXf5mXJWdBI/8EA==", "65e5c12b-0099-41cf-b8b9-a26b78e138c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "616a9935-d247-48a6-b8f3-87529781254b", "AQAAAAIAAYagAAAAEFpCtG6rP7Y0PjYAGeuF+JmFniOh11qPjQ1iNLRL0dV0/6bgWuiYNmf+FDVETMNdCg==", "0f98098c-034b-459e-aa12-ef353fa1eb89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "67326e4e-5b76-46c8-bcec-0c508c747798", "AQAAAAIAAYagAAAAEBD4M3dH5WQjTmzxQiKiGI2qGf8b3/ktdThgem+O7HxNxHCgvyKV+uTu7gsJA8pL3A==", "00975eac-7103-499d-bf67-92f1d0ed0066" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8419f10b-5f06-4cb4-99aa-32d2d744a3bc", "AQAAAAIAAYagAAAAEEbdrTYVtwwGyIEhlqIKJLItvMu2p7siyUj20uxl7mvJ7QzbgfYAbf3C/NNLKP9y9w==", "6709fc6d-7497-45e7-bc23-e92234b86dee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1a4bfb2a-74ed-4578-bf2b-39d3ebb91409", "AQAAAAIAAYagAAAAEFEeGcceMSWGNzGZAA/hEE2CiqhfmrLrAPrRWRN7ow0zOY7x03nKjrW9Ev1WxUqmFA==", "163a786b-548e-4341-ae0e-ac99db5ac6f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61b68510-4307-4541-ba7c-b72818b7618d", "AQAAAAIAAYagAAAAEGJOzRQTdR7XozJsJY4HQv9qk3jxKu0pdsNjNFIiLJzrL5//Q1TvzWsHZUv4HAiO2Q==", "13c5512e-59f6-4813-9bbf-dcb7261449d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "253e5743-117a-4f59-939f-75d4ec551491", "AQAAAAIAAYagAAAAELDWW50I7B02Edb53bqIf8YCL6Qq+ZKnRpClw4bWQ+oicqFOEdt/SrR+PXZBE1sxiw==", "24ce4659-a4d6-4f34-b4f5-520aea1edcde" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c280684d-5d0e-476f-870a-a2761e891fe0", "AQAAAAIAAYagAAAAEJEArU80cEoLCKeUWWNWAbsHHO390tZGD7S3vtpCsYNxm6zImvenjdP/EDTM2n5RrQ==", "8d1da9a7-b1a6-43fe-864c-bb64896f348c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68ae761e-f051-4e87-9100-3da125262d75", "AQAAAAIAAYagAAAAEC7loDfoA7K+58Q8MsRMgzfyga6kTlx8NzCLkVlAbW5r9Y9jDWuLESzP2sH1XmoSYw==", "6dc5fdfe-187f-4fdc-bb3d-1adbeebd3176" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7637a16f-0ea1-469c-8381-a409dd52e8f3", "AQAAAAIAAYagAAAAEN2lmlOjQMjsFowYJossKlUpCoHUni6gB+ilQSZ+TVzFUdgGXh03iqkI40akPNRK5A==", "1dcddfc7-080a-4052-a2c8-01eb16613ed9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7e7df6c-9bc7-4e9e-bd53-6845e2e69b3e", "AQAAAAIAAYagAAAAEBtUDae30zSE54AE6BeaaqUIsiXdbhsoXFzAQ123/FX0zj2Uge50gBi84iTuBkxX4g==", "845501c8-6558-4b1c-a288-715f31be38ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eeedd192-5724-4b31-8c7d-b53b7a21e47d", "AQAAAAIAAYagAAAAEN2DrmwN1PeMSnPbT2+bIGhAWe9y/gzte8N3aCdKVuvvTrqIlWQR6lYf55DKt3dmgw==", "fb00dbd1-f37f-48a6-b725-e71c94f50646" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca085a30-0fc4-41ad-b4a9-1a32d2fd3ebd", "AQAAAAIAAYagAAAAEMnruRwCTKTGqzxPZwVMDKFRC1XIOuEu+EKbW5CrLHEEOKs4RCt00Ax4EFBQIs1f3w==", "73b2f543-a963-4717-8b42-88039fa5fc63" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e30ce01-37d8-4012-ac7c-31faaec714de", "AQAAAAIAAYagAAAAEHVw3DIEtALxTnz0oDU8b8fAr/YmnL4EiLy22dQEy02FyLa1kgvgKSum48TN6WuDCA==", "052dbc06-cd32-4676-a9d7-15af6e89e6fd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6aa6ca5-2dee-4bf1-bb57-e6dfb30307ed", "AQAAAAIAAYagAAAAELhSRUseJAsDqvgItyri8C6xkdaE2FJ9WJQpSRM1vQC7uIpBWbVtc1vK7z9dQg2Vxw==", "ba26dd7b-24c5-4ef2-bfd5-d4a64fcdd75a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98339d10-fdf5-4a50-8080-96e2ba93f9b8", "AQAAAAIAAYagAAAAEOuNwi00BIOOaMVjoRXLUXPvisjZoQoM7f5WDeiluuVhAEDxB5LtFTyhZlfzMIqsoA==", "ac8f2e72-fbfb-4fa6-8328-de9dbe01d8c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "730c71b7-04c3-4d67-b6e2-50fd044d956b", "AQAAAAIAAYagAAAAENswzzQrWLBcHVX+pW+BsuSr45eiqtpk+jsV29Pmobi4TF3zQEHArvJ4k/C+mWXfzw==", "73565958-f20e-470b-89d7-f58ca81607cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35a0ebcc-e085-42a6-bf9c-ce3a97ab49de", "AQAAAAIAAYagAAAAENC+utJ56d8E5jfIpTM6XNq50ghqpLMt0LPN8aeEotbxLr5Jkx0G6FcrkbF4O5S68w==", "e5933269-0f68-4301-a06c-6bbe3d46e167" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "199719c2-0ffb-48f6-89e6-970b5122642b", "AQAAAAIAAYagAAAAEO2ltbnotkeU2NTBlPmlKgU4LnTMZNmNSoPnQ/6OSpwVwkUKmOloduxewOS0DbnEsw==", "7ff8b3a7-94af-4804-9418-cd8fc935181c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c0193d1-acd7-43a5-89d2-fb9cf084f064", "AQAAAAIAAYagAAAAEKWfqmfuPZ+aDVT4ebW2Y/OCQaEUwpxlVfQ7KbwcskGouR9W1jzZftRxVz2HVrjN6w==", "fbd38f2e-429a-43a2-a9f3-44de9aed68df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3b0ab3c4-8f78-4f2d-a3a2-b6e519b38f3a", "AQAAAAIAAYagAAAAENU/z3zKMWFcN/T1gUDw8pwfPKAjX0Q0TTxFYR5IbQCm7cDGDRNvSV4vUGlmBa2m2Q==", "1c422eb8-ee3b-4b0f-b0dd-a7d6ea7a227e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fb98fb82-6d5e-400e-b90d-df850d346bf8", "AQAAAAIAAYagAAAAEHD4+/aEVdSBFU4PfM/MTOZCTGlPJoskI95+Vt3tGjPELsz+czhKVl0jD09K2JFnIQ==", "be872be3-2f76-46dc-9559-1352c29f2df3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1a8515ce-b552-4b44-9bf2-181be7608286", "AQAAAAIAAYagAAAAEPMQo51F9ggzN0Nj+zPGBblyFQgbhXxl1j7dx0lTF4UqKHuSNtYwmbHOYJUL8oycNQ==", "1f2aeab6-8c5b-4d5b-9b3c-2797b455f919" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a30e170-5ee2-4f71-87c1-ccd88d363ce8", "AQAAAAIAAYagAAAAECtv9vdrYM8m7xqXO955hi9/hz3rvqhOrzPw6Lylc+sOyQ9kSEiQs3Q42GnKq8MKzQ==", "6eb1caa5-7535-4c38-b532-9f57ec234917" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4a80f1cc-aef7-47a1-9a10-a2c49f2a5ae7", "AQAAAAIAAYagAAAAEOtB3MXXjQ6jh5zxlmXX3ipgKfN1SdUnvDE/5KlTgZI2Fzc/QefRTeidRbYjV3IpdQ==", "1593a934-322a-4cf3-beae-adf941270ddb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a117f15a-96f9-4450-9cab-c33b0abf72ff", "AQAAAAIAAYagAAAAEC6phrTMUo5wQRIabAfSkIgnLv3hzHBLmb9jP2UFQOEYgCHotqx5HtjiDGBYKBgRRQ==", "7ace84e9-587e-4c32-88cc-7189330985f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd0ad621-af57-4600-83aa-c967757be5b6", "AQAAAAIAAYagAAAAEOYkLNB8PNbZSwCagpZIeVYRBTgeqgHBKUDWbHrw/zjWz/W/wUjdeCbi5maJmtLdxQ==", "b66fbe75-292f-40b1-90bf-99a92e9fa076" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7958e14e-d329-4c00-aa80-cc8cb2f7b062", "AQAAAAIAAYagAAAAEGBFkFcafENIWNCnwvXAfFffYIun0nRjRrrO8X26zPeSJ9/YqGacjXYwos6jjzik2Q==", "7b7e0a45-6d3a-490a-b683-385494db9648" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d753d77-507d-42a6-9b87-888fae63b94b", "AQAAAAIAAYagAAAAEMpUI67UoGaFi9cjmlEHxA3VddoNy8ouNAv3+8qmwcReoUwzrPZRhrnsj4YfyPbzyw==", "dfe32f6b-8261-418e-a808-981e42e537cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "293cabca-33da-47c8-9583-290c7efa4c95", "AQAAAAIAAYagAAAAEDR7x1juRnrsj7UjppwaNbI6t33hxNPtCi8fmEd4yyqLa2xAl9e6b7PVgJkNFGeRUg==", "21107b24-0091-4d80-b390-1543a3a0ddab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b3ecc8e4-8755-4fdb-bbb8-ea14ede875bc", "AQAAAAIAAYagAAAAEA2Crln+gAm7+RQ2EiA7NG+ptXOOCPS5HlkYOmyTnG/gJqwaYM/Gf49RcHptfAf6/A==", "c0276f95-7a83-473d-955f-e1be683d5241" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04e27e3c-ccd7-4879-bf42-aa66275dad11", "AQAAAAIAAYagAAAAEEtc5W8inJUOlZPCkED47bj7usi6X8f9gEVxGk3glxX8KrcB1LoNZXrx9DZOB27QmA==", "b6b6977f-729a-4543-8f4e-2894b6add51b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25c786f7-afff-4484-ba8b-9a13c67f2fec", "AQAAAAIAAYagAAAAEJWOX4tRalij/dlNRllDlMomseYPQvr46yzYZ5bFk8bZemLKHZXNxz7iUgeX7Odi3w==", "e9b86bde-c45a-4681-bb4c-a54f1a08983b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fde2cc57-835e-4069-b55d-aa01d73d4782", "AQAAAAIAAYagAAAAECX5lqygntRf53ArTBK4XzgmdD5OYAk7TPEnVCwz8VGSo7DCf5Y3gB023N57Zn59+w==", "0d40b627-5138-420f-8e6a-dd7b8d2f6793" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "942a9dcd-9ca4-4cb4-8fed-704d9f310837", "AQAAAAIAAYagAAAAEP3CgcKD6Ai2Bpv8MS7ZOmXNBnTNRo+r85uYx+dbrsGpTBDVXXmUg/uyupULZ4bE6A==", "893aeec9-784b-4c54-b787-2f06a7df0265" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6b83c63-0b4a-4c03-b21b-74ae6afcc9e1", "AQAAAAIAAYagAAAAEMezUbxoBuRaBwG4oQ2H02wxgjyrCMyK2osqTKr8NPruandDroY0PbOYEJ2DwI/BnQ==", "9a4a843e-36ad-4547-b6ac-8aadc0df863b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e3491b85-1304-457c-b5dd-27d3817878de", "AQAAAAIAAYagAAAAEJ1TBt/Rxy1Nh7PRhDYZuExkrBmAAvZdA5vxQXXw0lxFiQVlT7uYYB740FFKseM6Vg==", "887f37b6-eb7e-4954-af85-d2a4adbc2288" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ce489a6-480c-420a-955b-b96fc20a5c73", "AQAAAAIAAYagAAAAEJ1L2birbjzin3LtUpQ2qUFMm4cQv8jq/qsdExEE3p5IleNsz2pcyiMGLHao2EcTzA==", "c7741b04-61ca-4077-b05a-08d280c2213e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f14f98cb-8c4e-4f46-b708-0dd81b6c7664", "AQAAAAIAAYagAAAAEBzWPBE3MXNpFWjqANtB8wVZJ1By2z8ogEbpv/oevVeGiOklRfbysd4z25H6ZbY59Q==", "f6ff9568-e010-4c32-a1ee-67abed8b8870" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c97cfe86-4677-48b0-88fd-c7d950a4a707", "AQAAAAIAAYagAAAAEDvNSdAuloWy2dknvRmmgse1Em3Z2E8BAW5Dzl2i1yZzCxW4/2GAQCRL1pVCOh1T1A==", "68b68ab6-0985-462f-acf1-3a68ea7b548a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8b77b21-0509-498c-9fc7-3b43109d508a", "AQAAAAIAAYagAAAAECiVqry4Wxwq4GhLjoix4aUis0+Kdzv/WfPI6wNdl3tKz6y+Y9ypCnUwWeAnyafyvg==", "5f893a83-0717-4872-bb39-cf41fed2e596" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "256ad28b-c314-4783-94bf-78208ad92893", "AQAAAAIAAYagAAAAEKpelVNA4p5y0QfvlR3CvKpPXe6v1q5h/Estht5Sk88pnZW9YC6DbtipITx+VX0n9Q==", "ba4fade0-4b05-48b5-a1ea-e6c647b3605c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3bea9b54-bd6a-41d7-9ec3-30cd4652f49b", "AQAAAAIAAYagAAAAEIq8Hl9WNXZlTNdgWxYu3mzpWa4wFFKrBIG7gz7EwiZVgMio8/aE76LTochII1lzFQ==", "66d45590-2a2d-4485-b496-e3d25d9a6bff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4238e904-174b-4b58-b541-e98c29bcb8ca", "AQAAAAIAAYagAAAAELyJKVki+JUbTYxroEAjnfSaAHzOwORvm+JZWIg1GEnErQQk8mvstbql0Dq6kRNArA==", "6b9d4d27-58b2-4701-93cc-8ed808eabe64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c54af97-dfd2-4cb7-8061-3594e85f7200", "AQAAAAIAAYagAAAAEOknWDdK+tWTguF9I740n3ifeId5MH0gkLhoYyi0e+o0gDaJuFSzg5frkqCXv1/KCQ==", "e3af899d-94b3-41ad-ba0b-cb145564e3d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d3eecfd-f91d-484b-9ace-cd6d83724637", "AQAAAAIAAYagAAAAENaiVCwSXrr8aNovbyA32W8dFVtkxvmlZzpro3iSccNmo9lGg2Wh3ETxP4S83nX4Kw==", "b8cac9ee-15f8-405a-bc90-76fea32c69b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b13df53-c51f-47a4-97b1-9077672b8b42", "AQAAAAIAAYagAAAAED8evjmpIDYUbAZgVz50XKZSkyQlPD+eLAHOudx3h94eivqY2jv5PZ2tovp5D+oBsQ==", "28741e90-e07c-4e86-a2c5-f053f23db9a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71e52fef-6468-452e-960a-03557f98e325", "AQAAAAIAAYagAAAAEEOgA46zxwnYd9jjr7PE5UsAeTB5+l+RaEYnY+zaVAP86IO3uBAZlW4naj3hVkv7+w==", "3e140703-ca15-432f-a4ec-6e3a30de52b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7e540bf-00f7-4c77-8d88-c128512c3d6b", "AQAAAAIAAYagAAAAEPvg7SapblbkEd3Op5rQ7ROsHwnddPNlzdNQa9GtLugGJA25qKM6eN2QlkTWCOC+Rw==", "6bda0fe5-3569-488e-9db4-2a39501a53a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64d4a1e8-1bdd-43b1-ba5e-418a60ba2e18", "AQAAAAIAAYagAAAAEPtYKugFomV5/nFusXubULxnd8OVjtX/it4KOg+7fKagwifKB2T86ooIOPAjWgC1Qg==", "b25d863d-a932-43f9-8a51-d2f4b014a13f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "811e8cc0-1374-49a2-890b-cd7ac171c0b9", "AQAAAAIAAYagAAAAEC4UcAUQHbAXU/oMmUeeYd/jqMemvLlmlE3z9QacCnJxifQzFmKApV4MTNjQIZ2mLg==", "13c5a5b2-1ec1-497e-b4f4-91fa5c85f7bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3340e710-7877-4bb0-a8d5-bbb19bf2a557", "AQAAAAIAAYagAAAAELmUK72iZ1AFfiNiVY4Ll3odXwtoX8VOlV6FqG1uu3UF6FVt2IWgUtB5EZO8ZIU9IA==", "569dcf9e-7fcc-498d-8e81-a02a4c6e80bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e04f2253-a762-4c07-bce2-c0acf01c9efb", "AQAAAAIAAYagAAAAENqRUce++lB2yyns7XSUTMF/9NPv1M4abQMeF+ZtmQb5+4IyAr5nO3nbgIOa1ntt7Q==", "79cc97c9-744c-44cd-a030-778c686fffba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2029d4e6-7c66-4dce-a218-9e53783e8653", "AQAAAAIAAYagAAAAEG1IsgWiaFDTB8LNG8MWoaUsEyPisZZ3wA3KVJPRO1W3IJxdaVZ1CE0eNLO0tg5yDw==", "15997216-b342-47c5-978d-81ccde391811" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9ba2749-2305-403e-b6db-569bdc219da7", "AQAAAAIAAYagAAAAEGlUCKWeElkj/zghCPLKE5QR8meBDaeF4YJ5LVtYH6xIM76AX5OSlwAZW0aP6M1mTQ==", "09d22602-a8db-45ce-bc09-58252019f895" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e117618-bb4b-47eb-a638-991a4fb8455d", "AQAAAAIAAYagAAAAEDlkQmNGedgnTUAr81gSlaXHB5lHLObMD2sQw2tXFApcX3ViuFzFEOmT5RPP2c1atQ==", "764cd298-3644-4f81-ac1a-677256c6744f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d1c71b6-a789-44d7-bd36-336871d46880", "AQAAAAIAAYagAAAAENxpbCyxtPYAsyrwTA3Wbi5nl/UHyyH6COtm+HAn/sxI6R3WcL2bLjv+v3SM5yR3jA==", "d5638601-d4f3-485c-845e-9fb3881d0a48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "051c8080-8f7f-4a75-9676-ad5a9c3d9c86", "AQAAAAIAAYagAAAAEMuuoRMqv5KMRI91e/Eqk/YXww/EHd5XDNDomUAo+gS5aI9Eir3CTvnGRZh64mojew==", "b9ef00b2-ffaa-46a4-89b2-1696e731c0bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8abb02bb-56fb-40bf-bd57-19c5a7900efb", "AQAAAAIAAYagAAAAEHvJctuR71l8eQhe1qbXpAapiPPiIV/egT2FHL8ZaDq1E8lV8QPVusBRTgwqZ9ETpg==", "3180029d-0cae-44d5-b904-db88758bd690" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17e55285-5c76-43b5-8b3d-550462fafa38", "AQAAAAIAAYagAAAAEN4i/0B1lWm0BIJl/qh47Aq/UWPG4s5NZY3qWW0B5UN7zJT9JAb0m2sUI9TqVtdn2A==", "1757c5c6-7627-46dd-8a3b-cec2995ed3b8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6fc058b-c80e-4c44-9140-4797bcccb5a2", "AQAAAAIAAYagAAAAENbFRpoyOKhOfkT0Xu8Edf7sbJ0yRr3cOZ0UZS6c1NsmC7fFDCqckOJcmLcfqocyzQ==", "1579c8e8-c04c-4f5c-9f50-93510fe9f3eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15546179-16f0-41f5-8094-0eb71e43898c", "AQAAAAIAAYagAAAAEH3VHUREC1devpKx3EpUcLskilvlIH7OmA4I+RVt3MdXZ2UxDNNc+l7RDRq97L3fxg==", "b5ffba86-9988-40be-a13c-3f8aab7e4e1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82a4f8de-70b6-4222-b0e2-e44110ee8d57", "AQAAAAIAAYagAAAAEF8fu54QpYP2JOZBjyAEFcePSfvP+x6BNTlyOMqofGDZu94TR+fk6nPppwh0QVMGcA==", "a9e8302d-7b9d-4001-ba55-03ea4a52cf74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f856f1e-3fc4-456e-861d-bab88347dba8", "AQAAAAIAAYagAAAAENwepKZt0AoHgtPYiCf6S56JhEXuFZwvb0p3xqfZqKRVg7WTu1HE9Scjanf1C7rHzw==", "f1689b86-24bf-4401-9f92-a5f4bacf04fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6a7739d8-10f8-4a7f-865c-73f74d59d66a", "AQAAAAIAAYagAAAAEIVGY7l9dKG9p+hEGza1qlXM2nF+k4I1ueemmQst37km87xsAOyndVsOaxiJkeHiXQ==", "1f2f10b1-5b36-4d2c-aeb7-9ddcaecada5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22dcbf20-aa1e-4460-995b-c5353a49b441", "AQAAAAIAAYagAAAAELpOTLtBZEQQgf1Adgq3jC00pOvGDunWl4N3q2gL3IEHqBbMOEEOavqMaxFZiRHGhA==", "f1593b78-1994-44a8-998e-8cffa44e2283" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aeb9e5d2-9ef5-4d58-9055-1df89a3ac58b", "AQAAAAIAAYagAAAAECsHwnzuaqAzakjImZHoQD7V1MdLXBcT1auPUDQ/OpXA5qWPS6SdoR1DgVJXJ4pnzQ==", "9a6a9b62-e920-4899-83f5-eb1fbffcac49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc9c3c3b-2c14-463e-82b5-755dce56d9cd", "AQAAAAIAAYagAAAAEAWxXOvwhq9Nm/qCYbGm/A2AuRJ3t9VNUo+WFhFhatYd+ElhsqlfWBxb+dBYJCte0A==", "de1d9eec-ffa0-4b78-9af4-1df32cccd128" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5276d85-2457-47b9-9e50-ce310365dc0b", "AQAAAAIAAYagAAAAECPaADEneDsiwDqeYIAtBgIBrp5ZINeW3I1l9DrauutKelMB87UsE7Ex13byTVueIg==", "50cc7fbe-775d-4e30-bf42-c67d072b824f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60cfaea8-dfa4-4cd8-9c9a-e1dcd4557a0e", "AQAAAAIAAYagAAAAEPOKs7lwGw3IB+YeayYca16YmFCxmGNIhpBhlnh7N7lgnB0EKAfXU6sP7knHSQsl+A==", "9d05ca8f-3b5c-49cf-adea-b877358a7ef4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "PhoneNumber", "SecurityStamp" },
                values: new object[] { "5957841d-dcc8-40bc-a737-d67ce9cb09f6", "AQAAAAIAAYagAAAAEIykPyLOUmenLdrrHwXHGWRF+synSoR0/7Q4S4j2q/ludZ9h+AjmBgNgaheitLFetQ==", "00000000000", "4f487e95-0eab-417e-9eff-c6c3fad34ee5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "801645aa-96cc-42d5-9d9f-5c9a009eea98", "AQAAAAIAAYagAAAAEHgZkdh1kAEe77TkmC0ZROlMNe1st2BY/vreld2fAOSG5q+/c+CFGfoEGQ6+xpok5g==", "ba222fde-7ec8-4aa4-90b0-05d26ff2fca5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8bd4398-898c-4699-93a7-7055b5078ac0", "AQAAAAIAAYagAAAAEDkXnu6ZBqh8wQ0PQYIvogdIb5g3XuY515JtiJ7OH8BKM+57F5cSZvWgxHxHcmjQRQ==", "05afbe92-2126-4b93-8e34-bacd1a6b9356" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2760270-605c-409c-abc3-da919404b96c", "AQAAAAIAAYagAAAAELTLjHPhp3QQaALB/lrothFIKHkUNX+esr6tTNegnfcaUHua4tB0A/ydnumW9Yq65Q==", "92056a0b-aff5-401a-a530-494625a46867" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "594d1509-1437-4c47-931f-a21ddbfce3a1", "AQAAAAIAAYagAAAAEEckmWR8k5omWz7G5JGYB9mLecNJ+8c46FGAb3JEqnIF+B08p20n7VIg4ya0V1ys5Q==", "bae9b3ee-0953-4cef-915a-20a2e424cf41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a25baeb4-664c-42a5-ab81-ae59fa0f47cd", "AQAAAAIAAYagAAAAEK8dJA1g/fVaG2ryIo72aZinlgqB5cZhunCf8URDpX+6VSi8p61SibDsc4snqfQ6vQ==", "91f9c71b-56fc-49f9-9120-cc9d3b681504" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f9227a9a-0346-407d-b28f-7615f5082dee", "AQAAAAIAAYagAAAAEMmrryAaqQoNs0i8uEn/BlJjH/w7GxDwlQafxpshssGWC+162IDs79c4LYSnoNnIAw==", "03c5076a-62aa-460a-a769-111b02158a0d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7372907-f322-410f-a67e-13db41008a39", "AQAAAAIAAYagAAAAENWDoE5HxouAtlTqrCMcgM9XVCbbNruogYmvz237O0SG8OC9qwFjXV+p6ZehArZxDg==", "a8504e70-c1b9-43ae-82e8-c89fe2222cc1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70c3c21c-0988-4e1a-9080-fe3751a2f72d", "AQAAAAIAAYagAAAAEBDRapzDYkL+gbLI0Bi64jpfw93cJMdq5DChd8NFDlHzky6J+jpfgbOmhdyxF6aprg==", "a2c62ec8-1864-48b2-b5fd-fb13b1278a17" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa1fab87-ca3d-4042-9d67-166c2c44f6eb", "AQAAAAIAAYagAAAAEEAlfWr4DdVMNx4f1RxN5H0Dagc1MKHiAWGPJo+53eG5UqKuVDNlM7rsmFQWmgGG9w==", "4428b2b7-ceea-4d57-bd36-d91eedfc46a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "386f46ff-232f-4dc2-8e05-0e6754891ece", "AQAAAAIAAYagAAAAELDWaFzQyMKOwZ55LMaiswX6ag//yfORPQK5H+nQF9JYcV/9IHkasqIwutPUMRzJyg==", "220b5035-07aa-4f4b-9c68-dbcf48ea6069" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "162aa7a2-aad9-4e14-b272-33acdce9efed", "AQAAAAIAAYagAAAAENDcY+6ypj40YVyinXv3MatdUpm+gogjf27+YHLkoP2lWVVgo8bndhYxhrVglp3PYw==", "fe5f5c92-8952-4b80-97a3-557fbb389d6d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8621732-8bd3-48bc-9c3a-94bea18c8273", "AQAAAAIAAYagAAAAEIIvfKHZbwK3GINF2Wt83uQj50wi9L0YrfbhT2HAwbnhlYskxftWq+LY0D78bGZTWw==", "5e90e8d1-b444-464a-ad0f-f00d73315d01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp", "UserName" },
                values: new object[] { "9031d510-a5bb-47f5-987a-cc7793fdf449", "AQAAAAIAAYagAAAAEKBMnEUXIkGio/M3gYvA3/SAngd+tR3MSLtLgqyVkG8W770CCD67fuHqZ3RZqJa2aQ==", "d73f7601-ddab-447b-aed9-12277a8f487b", "ortiz.postia" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d45b95d-092d-417f-a0ad-5b3d6b08cfef", "AQAAAAIAAYagAAAAEHeiZZknfIyZcWN8n436VzyEgIDwzhF2IpHUFevaJbl7ywFKgEjU0aVg9HebIT8KzQ==", "92efaca7-8d83-4621-b77a-8cc064791e86" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "38b37d33-9daf-48d1-8ab6-9da8c61a6d83", "AQAAAAIAAYagAAAAEAW+7vmTg+OeRuDrAWILXsw+qd1p7NmAcnlYgLQan8P8O5ZtuBLgY9IMYJJhRuCP3Q==", "a6186048-e297-46dd-ba73-797ae8cfb133" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d548f6cc-460b-4455-8e76-2062cc746b3f", "AQAAAAIAAYagAAAAEJK9KLdIBAerTLwSYXAZTdTBisAGbbgaQiagD75zd9I+xCV6BDLgKew0m0V1nXpqnQ==", "33a58be8-19c2-4149-83ee-3f55884c950b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0459f238-9716-4b09-ae6e-15675f777a3a", "AQAAAAIAAYagAAAAEBvd0h0m8IesgB9+lKhL9qe+a2Rts34s/9Jqki3d31BLx7YZBaF3iFmvc1KZ1rbkkQ==", "ae77ca36-104b-48bf-b4ef-9bf8bf6bd44f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c00051cb-c348-4b36-b19b-d9d21cd3c294", "AQAAAAIAAYagAAAAEJs7NFKLwvE/0IzaIpAWfvwT7YjW4B9RFfduokUYSCf6lc8uCyV6Xj/NvexyuTX7dg==", "d523e14a-8447-4baa-8580-767508272f36" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7e0ae17-5f4f-4d44-8a54-d9b8f552df66", "AQAAAAIAAYagAAAAEIpkNxhG5Uiuk+ZjmXHgo414WbHWD1Fy4SJ31mzuWhR+6gR3DSWJ4w9gIUpWyEtA/Q==", "d786b16c-d1dc-4e0a-8022-85e84c237670" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a4e96de4-9ca4-4f1b-873a-338578e6bcee", "AQAAAAIAAYagAAAAEHcVO7PJgkcyVYKxyxxzztD4Gl3TSzdVmYvnjm5vWH1x/dQQtG/RSgRsocdwU2OZYg==", "6caac0ad-baba-448d-a155-ece06054dd8b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7984a078-3ca5-474c-8ca6-dc1b0d3bbf73", "AQAAAAIAAYagAAAAEErbMXl04ZNxPDf3y4a7GWpsgMyAjK/FU99bxwBfC7u/7FzaVD+Tc1F0sTdembeXEw==", "6f6e62a3-b0c5-4675-90fb-7deffd1fec07" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d9c818f5-c110-4b7f-bc6b-6ca9902d9459", "AQAAAAIAAYagAAAAEJUvBsb4tERhWS45klnglO0pjXTg1dQCTaDewoIVuHxy1/QhKuOafjFFVUjAk6Ke2Q==", "d5e3339d-c877-4e65-809c-c2250adc57c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "107886f4-f188-4f04-91f6-bf2266df1fba", "AQAAAAIAAYagAAAAEFV0z0xxu9U6Da8gHqBTilMmQ9y/5tIw0UR9qnwDrf2TOp3KoISyc8o9j0F2l6jpDA==", "6b64bede-0960-432a-bcde-5d8f16c26543" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8c0d0efb-ed50-430a-9378-d487f9ee3471", "AQAAAAIAAYagAAAAEKfqCGzEXb+Yzq6EBVJQXLg1y+uJ4p9hyGjCywWvQIXnNXfDGdyfARw0u4PsmOj5Gg==", "eab47a82-f7f5-492c-9c4b-0dfd84f3a246" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81299b0b-284c-47b8-825c-b50baac27441", "AQAAAAIAAYagAAAAENXj1FH6LQrLCvsAG40l7oBc0iWYC2xEjGs145Zpr6MxGQqfHCQKlk7OLHYChHBfJA==", "97be3e49-68db-4386-9e8a-9fc2ca730cac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55b5ab29-fa47-487a-bea7-f875b0cf6a73", "AQAAAAIAAYagAAAAEHpsN/nzrcBK/reVBO/9pJ81jVfD1Ild8Xj10c95ZFtIDOUpDtjIRuzfb8xgfiZ1/w==", "dbe706e7-036d-4ad9-a476-956068149e36" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d29a4f21-3bc8-48de-badd-21604bc428c6", "AQAAAAIAAYagAAAAEAbulO/xPbs+ojsHWzZ/on5aPoQV+2WX0QfQ48HVqO98cod6oUWV4BNv841P16+dAw==", "1e8ba252-cc55-4324-af1e-5d2354b949a1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e70d6591-67c1-4d30-82e9-727e28b8d76e", "AQAAAAIAAYagAAAAELnePKLHwCOUQuhvngw1hJIUKmrB/SRNVOvRiL/SIkybABB/QH5vEdEpL+Nocgg++w==", "43b0393b-ddd2-4cc6-99cc-d4c7756e8287" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "301b9561-4804-41ae-8e0c-ae79fe6814e2", "AQAAAAIAAYagAAAAEPqPNvicKBcX639sZfUH2OSBpDT70LqNomZrOW7NBndOknPtBlIawjsr+WF3O9P2Cg==", "9faa520a-7e34-4fca-8fc2-aba791b78ff7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "278ec6f7-36e6-4b23-a486-a34ed430f235", "AQAAAAIAAYagAAAAEKF2uEvtQTrC3hlkutAlBPls2KtJX5ioBd2/fIR1iUtw5W01pbMmkftqaW/0BpEWZA==", "26227e65-b73b-4735-8332-fe209db14b49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00ed1aa0-4677-4faf-b866-836d7ca987a7", "AQAAAAIAAYagAAAAELLwtVvo7iF0a3Mt5bin9HTGeaLawCErhSnJO0sZowjh6S8R8xgK2zcZusl6hjh+ZA==", "4febdf1d-8591-4d7d-a4a5-8fc3dfee7b3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "796976bc-fa08-46a4-badb-87d43d58dc5c", "AQAAAAIAAYagAAAAEODnuvlc0qI2SSfqK38rw6+gOurJo/+AWb/iitTGi6E4JCULPsBYBLjnSGbbHt8cKQ==", "3f181455-ca70-4afb-8418-d3e5732a9db3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9330080-e1d1-4f72-ab94-5f7035fec76e", "AQAAAAIAAYagAAAAEJc8s+Mh9rZ3t/MjbXLfOFsrzVlseWN7yUaqyJrTOvoBA+13+4JaCMkHipIJhG+NyA==", "8481ac81-d9d3-4963-9447-e5d3c88ffefe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "309607d4-6953-4a22-945e-12c8a93cd370", "AQAAAAIAAYagAAAAECMCOt9d8BzTonoJIKay+oo7jLsS5J4bXr+NNXV4wmeIGAL5MBQo00Quo/JjiqIHTA==", "e8599f14-a579-4fa0-86a0-84fd12ba69ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73e8c2a2-3cc7-4ef1-b883-4cd357282e07", "AQAAAAIAAYagAAAAECF/69SryGZdZUPpPYUHtxDwmUiwVjizYDC0pEzTyB43a6xn+Tw+5H+zCLhDPJSoYg==", "a54c5b8f-7a25-407a-869c-1c201d409ff4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7dd84232-a95a-4cee-ba60-725ce9c9df0c", "AQAAAAIAAYagAAAAELheNp4/fSbbgv88i9UwBBqafLb72UPiA+a2V68Voy+KSyM8tcqXWNzrUpaH8EKFLg==", "b63c6f1b-9599-43b2-ae3b-8bb4da774d45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "75609eed-c3d7-4a8d-ac59-a9f56f11b799", "AQAAAAIAAYagAAAAEJ4v5zCy7+9HC820WzWuPHRbXZm2xufeheE3u4h80uY/W4e7md6ssdsHaOM2pidLTg==", "ba21dbfd-76c3-46f4-b559-1ea4f1e8ca2e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7609e93a-5ef4-4cc7-bf65-e8aa3d6c6d58", "AQAAAAIAAYagAAAAEL8GLCtB80yyxDnLaJpYAU8GHH6a7568v+lEiUNgIW7CtF4KgThsZG0RMuyCBPcawA==", "0eb9c5db-58b5-460c-92d1-53c0aad75a41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6f96aa7-71da-4ba2-ae8a-d7962bbf2d14", "AQAAAAIAAYagAAAAEB3TpYiw9Kif8iXF43PJ87+5mkjDcENr5JV9PcJMKaLdTeiuVYIqnAcR56uddvVb1A==", "ca0afb02-7ce8-4c6a-85d8-01c8a02a7648" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6707018d-039e-407b-a514-00f2b483c9a0", "AQAAAAIAAYagAAAAEH8+F2PquigdR+Zm0kn0NyQh2nPGPmWAJj8KQzd1hOgJrJtdIcI01hi2GY/UMfGplA==", "8e3c4ea6-4eed-4e2b-bb86-baaf75959c1f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a258e9d-4891-410d-878d-1885f4c6a0a5", "AQAAAAIAAYagAAAAEDslfCcr4xvvZ/nHKQlKonfk5GusjsyUujv2TRIw1wxUJc0c2nNTpdMbGi5GHr+I+A==", "97fddcac-b033-4add-a135-6b7bf7cba350" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad37c12a-2a23-4428-9b9e-6dbce949c5f1", "AQAAAAIAAYagAAAAEBCX0rG1xDX9kkmp8L1YRv6p2a2BKR452gPm8B9IIpU9b/INCmfZNbUdaq/oseLqIw==", "38f4b6f0-0f79-49bc-8950-7bb87559c5cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e83821df-8b67-42e6-8d47-8e8c5f4ddabb", "AQAAAAIAAYagAAAAED+tA9Z14bEB9wUv3inZJbMF2x0dXqGEO0KSxvEyislfLUnxIwqzdSlgV+LWGPvc3w==", "2ef2af23-6844-40ea-a99e-2bf0bb9fe606" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51033d03-cb43-401c-b29f-ae504a757e57", "AQAAAAIAAYagAAAAEA4k8JIeN0Mzql9WHp1+vUk73O3zqKK/Jmm5yQPV4XlH32rW2Os3ARMrN/oxN0CZBg==", "117037ab-729b-45b9-a5f1-9dcc9e0cdf5e" });

            migrationBuilder.UpdateData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 79,
                column: "Name",
                value: "Cardiovascular Center");

            migrationBuilder.UpdateData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 126,
                column: "Name",
                value: "Legal Unit");

            migrationBuilder.UpdateData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 30,
                column: "OfficeId",
                value: 9);

            migrationBuilder.UpdateData(
                table: "UserOffices",
                keyColumn: "Id",
                keyValue: 95,
                column: "OfficeId",
                value: 59);
        }
    }
}
