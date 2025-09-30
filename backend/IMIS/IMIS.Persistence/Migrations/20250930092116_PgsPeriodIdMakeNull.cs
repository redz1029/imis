using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class PgsPeriodIdMakeNull : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.DropIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.AlterColumn<int>(
                name: "PgsPeriodId",
                table: "AuditorOffices",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "ae11f3c9-0a7b-4911-be07-6f9db74edf98");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "d8e2f547-499e-4c93-bd39-c8649c331dd4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "202d4a3a-6fb3-455b-bfca-d5ab39cd349f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "277b48d8-0b82-4980-a12c-f7e14e180654");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "8cc0586d-9e9e-4a51-b0c6-de9b9eedd31a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "99e7bc35-fdf6-4295-85f8-e4765fdc3420");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "971774aa-cfe9-4335-ac3d-794b90bcac2d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "aca47f59-7952-427f-98c3-cf8f5f22ad58");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "54c4fe0c-6bc5-4ba9-a720-451a1406a924");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c76b7929-dd82-4ec0-87c8-e88be1cb48c5", "AQAAAAIAAYagAAAAELmN9YX/eufPipKTNSBuvqqWMO/mkY0c7ES4m9VwvzLzdCgqo+vcEntqkODkyvG6Yg==", "2270bc6f-e76e-4ed8-a9a5-88ef9d6cd931" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5728d44e-5e8f-443f-87f7-d4c015bc1980", "AQAAAAIAAYagAAAAEDByDC1d0yqv4XWHXXcKYBUlrXr7UnrLHkSAmtA547huM3IyS+1zAPHz8w4Q8/eMdQ==", "c1e6b889-ce71-4c93-8b35-c5443defa8a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9de79220-7b01-40e6-b680-74ca16d06a35", "AQAAAAIAAYagAAAAEEeRoWg6oZqR1BWqwO8pToghdpOeWd8dN8jPQXxlXT+rqD5ntKTEVDdhzb7SmlqZtQ==", "3c94f996-ac7f-4ba1-98de-81348fb68622" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0bae4124-803a-4212-9089-b3f19cf691ca", "AQAAAAIAAYagAAAAEDtDfzqfXwoQz5/jsAWPTxuYoy6gTmo0QadtM/8/Wl+4vXFV9Oua3OABN2Vd30tAYQ==", "3a8a33cb-879b-457f-82ec-324ff8e7225c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c90f8412-4e48-4671-9146-d82b83970c64", "AQAAAAIAAYagAAAAEE8nbb9FX1PJZX1OeD/NZJ6OeDkdhcYdkywNBkrNhhBvmxGnPO9vq+NG0XLJC1bnTg==", "2dbda3f8-3c39-433d-908f-f971a46b89cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a9cfe0d7-fead-4ea2-80d3-e9a1c1ca2bde", "AQAAAAIAAYagAAAAENXk/0gA1cn+/31F5QJl+yvvPeXmgzRu5YlDV4WSw94LCYlE3nY/PKVKTkw8lVacSw==", "5a9d0dda-ff13-4e47-828f-958a8c091ab8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba8e347d-608c-4c7d-9a6a-996b17ba9297", "AQAAAAIAAYagAAAAEH/JjvHwvqfj1dhCuBgm38kCLvozhCmX515a/HDoocDrf2oo5MCBcPURo2VVH5hptA==", "91c9d683-f8f5-4a66-9f9f-471d81beb393" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4788a1fe-b7b2-41c8-b810-c2ef615164c6", "AQAAAAIAAYagAAAAEHeBKb2ynIRcylT2yXfmZ2MZoOsnP12wE2dhCcMf/UDfgZeauSoXRPXCxY9i4r3qSg==", "2b1720a3-d290-40a4-8895-d07ac7a1d875" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f5f6c612-9e08-4eb5-97a9-e1dfab2286b6", "AQAAAAIAAYagAAAAEMsCC6AFnSqCEjiBtLCLEOZE/rdNMfwKP97Z7DuDXENubKwwUe8/KCfJVOBv8j6x7A==", "1200af7e-7be9-416a-ac37-273ce8d76eb0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54c82190-5923-49b5-aa7e-581be3f4013e", "AQAAAAIAAYagAAAAEGfideX1vcBLJvruq42fEGAaiS7cSXrv+xLX5hpwhtybB8PEl+QdSitUTVhhyCx69Q==", "239fa11f-19ff-4b04-ac61-f4a8a565723f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db72ffbd-6f96-48ae-a590-506bde30d832", "AQAAAAIAAYagAAAAEESG4SCH8hBsSy/0ty5iN0EaqcG4vTy4PkyH+6uq4kW0ByYWVloVIDgtwJlSwqGCYQ==", "0b6ebc59-2147-44fe-a63e-cf30da3868c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0476bb78-3c3d-42e8-a0c5-0137f3524c84", "AQAAAAIAAYagAAAAECbLQGEqDYI5kSQ4Hh2C7EH6ZvCIRGWIExRYLdkxDqPGxCZBUNJU9LHOse1N7FPcBw==", "3f9ac597-1c7a-41eb-9422-e479c35f251d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9340dae9-2ff9-47a0-95df-0f634d4a5f69", "AQAAAAIAAYagAAAAEMQqsW99KW4ESAY1sXHUl2rc5wDKVdT9eHCivsF/OOMeLjtOlP22ku+DEDjNaSVf1g==", "ef14f580-f077-4600-8c94-999826889dad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1234e2da-8a83-45a5-8a0c-c61494a0d4e6", "AQAAAAIAAYagAAAAEOuFn4yVRf/pci6fesnSI0oRlJqy9FqX2LBGW7NayL/y7M9U2lJ9HgFhW2DGd9ow0Q==", "7bca83b1-714e-4e1c-80c8-b4e2d4878e55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a5536bb-c2ec-4e7e-8200-0393fc518e5f", "AQAAAAIAAYagAAAAEAwTV34GgxSVNLYlQ7H35+Ez7j5A/v3tnJNmHdIZmq73EqImGw7C0BIx5I+8RM7s3w==", "a79eddc5-6cca-4a07-b22c-d52eb4f91184" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de670e75-11f9-4388-a3f1-f4af94f94096", "AQAAAAIAAYagAAAAEGB7oV3ZVSW3REFuy4qBmX3OzCqgNSF9ctS+FHsvt+NxtOkFvD6dHQMq3jwbAt+FQg==", "537691ea-e36d-4c67-8790-d6738f36670a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "669f083d-eda3-4c91-bf4c-afbffeb0564f", "AQAAAAIAAYagAAAAEO5GfTb1AuMZ04ztdOE5cKyZN7R4GlwgqAObZLn0/BRVihFFaJqp+8SYFaXtiTsvnQ==", "4088b64a-bd2c-4265-84b5-cb8fecf6f3e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1381b80a-69c7-4da7-a9ac-e8ab8a2804fc", "AQAAAAIAAYagAAAAEBaFKO+s4egfs2HVpG9/39icMvoxiRO4gFkBGJzHexcCxdjX6BaE5+pOMTroDWKO0Q==", "d7b05318-2118-47a8-9851-4463707fe052" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0ea4f52f-2074-4a54-a09e-8d36d7a76911", "AQAAAAIAAYagAAAAECDJ8megJbXeggQ3PA2w7qpxG7NwWGaf8vcFLXQOZALZFYzxDnQY6t7m8WvqOtOfmg==", "919caa6f-8a0a-4612-9e5c-a41fd8ee50f1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a147d079-5988-4ea4-b3a8-e4de0a6d9641", "AQAAAAIAAYagAAAAENh2kWBQMDEZi5i735as31nga3gABckz8RmaUbkLmSKj1/ogyssAiee8+ql+gLhcQA==", "6a28bd18-6902-4fbb-a9c5-d2d052ff5915" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "761dd8e9-50c5-42d8-9abe-76486fce204f", "AQAAAAIAAYagAAAAEP4an87Lvg9qTJYRiDhYSV9vf1QKx5UB9Nau9uwzb7XS5d2QQz7q7kqKMyPQXfB+GQ==", "3d12084c-e528-476e-84ae-45519f2f8fd7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "275b10c2-9515-475c-8322-a1e7486f3ef9", "AQAAAAIAAYagAAAAEMI1rcST21zY7AsEAGubpv3Lis4kWRLbke0J4m/hxHshErgcH85UHeNPOOkQRCLitA==", "6684f029-2091-41eb-9918-c1b3495cfe5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "51ce295d-38f9-48d1-8b0e-1a8a96b76c7e", "AQAAAAIAAYagAAAAEGJErlDcNUSvXbz+cCq62WgR4oV1mM/O66EDm1Jm2rJzzm1CpJ30PIO6ID8mfuJX2A==", "0d15e023-bc1d-4940-a5f5-06222106e8c2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21367664-b49a-47c6-8b06-be76f1f6e19b", "AQAAAAIAAYagAAAAEKgfuu5X4pzWhgkHIrpE/6hCHGNk6Wzl0gaeCXxdVXFMYytEdY7TgSunhaBL/AhlCw==", "40b2ebf6-c3f3-44d4-8e28-b7d9681e6230" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "918b82ef-2580-4e88-8123-22617091b3da", "AQAAAAIAAYagAAAAEI1lHaxwQTPculRPYv/LcElLrDHJ3KYpVMDcAnxix4IaAsVW/WsL+uRaKEqNiUDGHw==", "6e55442f-c6ea-4a2a-8c38-6715f133c359" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "239f12a9-4861-456d-99f0-7ba0866987bd", "AQAAAAIAAYagAAAAEPhow6JryStfFofkg8HVGspd4euACUDQlesRDea1lMUPa2R5byDT0eWw4HOdFL/qQg==", "f866bfca-4d0a-4989-a0be-9639130d682e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ffcdbda-5c66-43c5-b1a5-9728e452e4df", "AQAAAAIAAYagAAAAEFUuFNrQOlPppq5xV7ziA/BopUTg+JO9H4OtfICso/Oeq7z5nre23KBMVGlHgpP/0Q==", "709cc9e6-fed3-4397-b4b0-a2f8370caba4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac94a220-84b3-4f5c-8dd1-0c3cd977ea87", "AQAAAAIAAYagAAAAEGwEKo3zEjMxKZz4NxnGYz3tgYKvt+HAumeNkmqzamugWUlfmzaiBlS52ErrfCCJtQ==", "931ade26-a3df-4e36-b6b4-a1a0a81c0eca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "180ce698-2d19-4f3e-b24f-dc829adc9fd7", "AQAAAAIAAYagAAAAEPk31YS+FJvHAodZCogXiJwyMel45BYv8Fx7fkYHv5zyjiUR0KHBeWws5yrJ6RpPjA==", "8c16d64d-8837-49b0-803e-e4d2a44c0477" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea2f234a-c777-4cea-ac8c-c7ccc2ef2c3d", "AQAAAAIAAYagAAAAENCNupmFp2AEz7SB713FJTFZgfCe1IRtrtD23dW413QTIwF7E5OVrUGkyWURpa+6RA==", "79c39fa1-0691-4b09-81e2-5739e70b87a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5872c3a-06ec-4b0d-bf37-ce81fdbe7d82", "AQAAAAIAAYagAAAAEImSR2EfBb4hvx0s2TA1+Btzqjv2hlyEQgwso9bV+ivuhqH+u2CP+74UEvJaw7nwqA==", "52d94826-af0d-445b-adb8-1f46be325302" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71424e4c-9dab-4b46-90ec-e8f1dc2cc44a", "AQAAAAIAAYagAAAAEMQ7Ls7d9bRwNfhBnicV1qjfDJakKth5AiyrFsha9dKjoB3izTCca/QfKSSiqPdvDw==", "1aa3f2b5-9de4-4b45-a074-0879b5edc41e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f06de4a-effa-4b63-9055-9d74933a3370", "AQAAAAIAAYagAAAAEEdZhIj0bk5Okdq4qrWvOsmF9Z2aaYtEaKaTOOvl5aMTz7bsF4sTR+OHc7tonRLD5A==", "ee23f612-adc1-4a62-ab53-4eb51ad8a51a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5add5213-73c8-43cc-88cf-132c66b5b3ee", "AQAAAAIAAYagAAAAEGUwmkGo41be+pjC155LUN48OhTzP2uSpmkbL3ZBG6MyYRaF5cyMutdfny/TCysUzw==", "f28e1537-f0b3-460a-b948-66142f766f77" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10ec6024-f216-48dd-b130-bfcfb3f3096a", "AQAAAAIAAYagAAAAEEfarzAtQR9Xx8jINnMtKpU4k+GGx3hDHegfajD8sK+UoR6xmlvdtXFMKVwC/s+IIg==", "76ffb742-f8d3-4c56-84b5-5918a41b17c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d53ee12-61bc-47d9-987f-b2e5fae21aec", "AQAAAAIAAYagAAAAEHIQdO5QLknBuOANVesDgLtxIF+m0/8nS3spxDfh6D0bAqvxVmYSUKE71EtLUdpDVw==", "2bdb0e01-7f6b-4335-8362-df20ffc982b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1ac1e54-8f7c-4114-a68d-400c7645bcc7", "AQAAAAIAAYagAAAAEIWDuzcrjjjyADFvIuz65LUL1F54ng6XH1EZnbsLKEOhQm2cmuQuF9IJq7yWhgQ7Vg==", "bf9b5b51-7436-4c45-ba87-2bcb6aa55ce8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ea4be95-cecf-4f64-92b1-c1190e722b00", "AQAAAAIAAYagAAAAEEwoKgk02RH3xK3dLz+/UjXJqEhl1sjioNtXcrcjZrQjT26XbwwfmyuEAbL5v/xBKg==", "62477e11-4efd-43f9-84d0-5f640e550f8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "116f4493-2203-4661-a585-411d316ef963", "AQAAAAIAAYagAAAAEHCGnfcy9Lpvj+96d8HMo8q/YUHLCT7DZXNbQLGCDBmjdbnzVFA9PhLNFdBxDV1Zpg==", "4d7cf1d6-4e81-408c-9280-a2d0af5b5d11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed7dd4fe-3912-4957-a74c-e5d62e60d4af", "AQAAAAIAAYagAAAAEGpxUoWWxY+roWsflJC3Kb284YAVPIIuPldlG3G1Pq9GsEdSLr/8P9lPs0xHWpmR9Q==", "53b5a2b0-d8a8-4494-92e3-25ce1eb92b8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0a33574-ac01-45af-b5e1-890f97ecb88a", "AQAAAAIAAYagAAAAEGTTQPP9Mv0kGXMw0oQh0cabUGWi4txjZCq+ggEmhbGWM9C1ffFCqKwVJm0E4wiN1g==", "9a01dae2-e907-4060-b036-2476f747ee15" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d32a62b-6c24-4445-93ad-53f470c8170e", "AQAAAAIAAYagAAAAEJqu6/PvLUY+oh+0kJxFKUv1cQsVGkOMjw37XhBjuzE3dKRzSR0dr7VM7GdpB/XySg==", "3fccaba0-3fe4-4525-acb7-9bac442e637b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6ea9478-73f1-4944-85fe-0872d0cdbd85", "AQAAAAIAAYagAAAAENAiss+HTQFPqnwZO3JXHzHoCWgROFZspCaLNV3H0S0oIPGUObDLBYqSYg2A/hiPLg==", "044acacb-70b8-422b-985d-9f354e756324" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9eed11f7-8714-4745-9377-665f3d0eb3a2", "AQAAAAIAAYagAAAAEFrq5KEQUs25kd8jH6GtH8Ss5sTraLqd8y9TjAxCppGSLUWWofLeioktV226V/tG8A==", "4174c9c3-b6ea-4dbe-a8f2-3a93c14482b8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d5ea076-80f9-492d-a458-fd3f5c96c4d5", "AQAAAAIAAYagAAAAEA3rL15Er1TBryHV3KGy/XWaPYU4W//Bx3TmbpPRHlBGAzjEOSsSSPy41vonsbGJJA==", "e3e61436-d12e-48d1-99b9-09b0e26e2113" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e5d4931-46a8-4375-bace-31780f42851a", "AQAAAAIAAYagAAAAEAk8RIxpVBH8Q8D9v1Vt5voWDfpNeaTrCFWTddp5WCh00vcaqJU+1Y6gvOCEJ0S0qg==", "9fac9fb4-f324-4d78-9103-58d9b319e2cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fccc9965-7eaf-40ea-9601-319c7f426988", "AQAAAAIAAYagAAAAEJM+s0qYRhyo6xRjKZqXAqCwhbNWJBouC4yA5D9Q1AktXuuZdmJKh8L0UObdZRqHbA==", "30dfa823-22b0-4560-aae4-f39bcc991510" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "111d27b8-433e-48f8-867b-f9f61990cf00", "AQAAAAIAAYagAAAAECyrTT535sJm+rr8XOM4gImv7mgU2SutP/Ma2g5zMb/kUjv7PE1hBV1Uve0Oe4rq1g==", "888516ec-7e89-4d4a-b6d7-bec299307ad5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b641887-73bf-42c2-9349-a999109b42ab", "AQAAAAIAAYagAAAAEDgNR7jS4q4vUPkZcaKCdw6n66QUpHx/tnNtloyBkqoXDA72b62V0tZ+Ti5HLYsTyw==", "1af45af8-3de7-48f6-9cd4-716c887aa8ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f1b7b01-e7ed-49de-a6a6-8186a34f9c22", "AQAAAAIAAYagAAAAEI15ydcetiNXLPP8coKyjpanNa308VhbRxqH8y2p33Mw+r/pz0/CybXNik3g8ZOH3Q==", "8441e884-6177-493a-9dd0-2be6ea8700b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "925dfbe1-67ea-4647-86ff-70d7d53531ff", "AQAAAAIAAYagAAAAEBLEbQfflesFsZeMXYn/eo0ftmvK1jvvi5nEUaZK1bWl6WSoaNIJOO9ZSc6g2XrluQ==", "bb4c4491-ef82-4dcf-9c92-74040f4b4a3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fad6bb60-ed55-439d-b039-5d60bf48a4eb", "AQAAAAIAAYagAAAAELbxiTh2/KI6TclnZDCnxeVijHy+KV//0XMg32oFO6/Mrf073jpTXAePKe3/bkkDqw==", "ea4f394a-54ed-4aa0-a5c9-b8fdb80aaf67" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f9553b7-fd21-4c8c-88ad-988b561fed28", "AQAAAAIAAYagAAAAEPjXfNjF6T03lDOQP1Ast8vqDMzcg1DP7xltwim0flRfqdi2vgDQbNAUyfHxnpPY3w==", "87afc689-6e43-4b10-978b-0f4ee56e91e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "853da466-e4e5-429f-ba52-4bd689b993f8", "AQAAAAIAAYagAAAAEMDc77ndJB9rsonuJjujmbtgaMWyrYpkKLJORqwhLgheTx/9P90UPReKp4M25qNk3g==", "dedb8294-dd05-4d9f-8077-0a8b07848507" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74fd3412-43eb-4233-8d6d-1d016eeae647", "AQAAAAIAAYagAAAAEK/KUHEq3y9oQDrwF9HtpU+YOjsvl+HNnFGaEvEgGYqDXkSO1aKGo4Ha1auqtvwLCQ==", "b85cf27b-a319-47a2-8121-ad0b00fd2e1a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9c12798-054a-4ca9-b8ff-7d774a1338b4", "AQAAAAIAAYagAAAAEFXKezR8RgmiwUzWTJyGESTmK2owvMZgco1vMocLMZkZUlXSOrna1Hl3QiiEyOLsMQ==", "ac7aabee-b005-4a36-9642-7840608e5c8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09f085bf-41f9-4b55-9dd4-2bb498080917", "AQAAAAIAAYagAAAAEDKr2qavXsXPmV0ByhXvOUzREzhtxNeKm7lD/MD4bcU8COFzEUcEZwSsXxI2iaEjGw==", "d8fff2e7-a32e-4132-8b9d-264db78873ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49e8c8a8-3d6e-48eb-b197-01e2bf57db1f", "AQAAAAIAAYagAAAAEGSfHfUs4SwmWyUky9jHj0MIPy2OFOWlYRs2CIBrcFTajY3mZL7sRlsOLQ4+lgfvJA==", "5288b6e9-df82-4887-a960-f8b9b218f370" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f971ad8-d02c-4abb-a48c-f24c0b1003d9", "AQAAAAIAAYagAAAAEFTxl1GuL7PMYMGGIcTYRPAjaWUY5XQrLJD/SjIxy5v2QbfyM4ai3lRAV9SBSJArSw==", "dd283df3-e9cf-4b90-bcce-cfd202199db1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c222a37a-93ec-490a-b9ae-877a310fc58c", "AQAAAAIAAYagAAAAEHU/MaXCpGau8wdfwoTOA75cfyZZEvk0ZZ2nUxzbtP2dp4sPIjMQHl/4vsEFOpvA7Q==", "67b5b2f2-bdc3-47b4-a33d-f8c1c4f78cf5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19f70a33-0ac2-48a7-a073-ae21bd66357e", "AQAAAAIAAYagAAAAEGLtPo+XNKkASdVEu03f2x3nBshabhJ70NGXVHxATmDh8o07fg+CwMNm+mCdsCVBPw==", "5945dcd5-7ad9-4c90-a3cf-a0674c6efa06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5a99989e-6a21-4cf4-ab63-53a49ddf335a", "AQAAAAIAAYagAAAAENFRS1SuXVtiyXiSZohnuU81w5NADBzOliSM8mubx6dlk11mY4BqqSHTEj3WSFh5lg==", "dafa0286-1f7e-429e-b14d-032d33e5f744" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49298ac5-ea78-4bd3-89a8-07965d1bef0f", "AQAAAAIAAYagAAAAEL5S8HM+rteceMYmmXlwTCKXlzWZ8plJzQm8o0yZPS/et2mTItX5fGjW70szxGAKTQ==", "772bea54-345b-4774-b66c-3efcde46fa2d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2a79d66-ca33-4552-9172-6d8ab928c381", "AQAAAAIAAYagAAAAEFKeE5SBh0hTsBkLV1bLnKQPePczKxJared7cZTCiCnVjfRKloyptJWqzAtxKcZKZQ==", "97a37abc-97b5-44a8-b68f-258bf983b208" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cdd3678a-dc7f-499f-bcac-c8a189ace04c", "AQAAAAIAAYagAAAAEFKedvaudz5FqlmZmFGAJlBIaA98atiXBf/DD5c9aILMJhTfIO1Sx0lRZ7zQI2/FAw==", "36971d83-6913-4f48-8876-b3221ea50ffc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "72d711ae-e8c9-4363-97c2-7a04f8b09a98", "AQAAAAIAAYagAAAAEO7Qgvs6rIE61/auVeDFLM0/kFf1HC2qaRJr+Qq5+HAJf8G0+yq9/0OYnU3up75pew==", "0d5e17fb-aec2-45f7-880f-0e5bdb922d94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c68d6fd7-33b3-4dae-9794-ab91773d39b5", "AQAAAAIAAYagAAAAEHXIgycC0C//FNBuChzI/muoiueVzSCEDcacUXfy7FZqAjJadbM5CVkKIsfyfVU0uQ==", "8b3fa316-85de-4024-846d-629594a7ca9a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f194cfa6-6c25-4242-9ece-c55a03636561", "AQAAAAIAAYagAAAAEFZFVAeGkELiNhyv3H0hEt4Omykb2DPP0Z+PrYKwg95I/cRaSJCD6eK5u5bH2eN3HQ==", "843e0fa2-fa75-4973-946a-9ba8c38abb96" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d678efa3-11ea-40e1-a9e5-453ce89bba64", "AQAAAAIAAYagAAAAEDK7eV1i76m9wtslhqxKdxYfiqKJyqBOYzi0hsUYzD+qqDq2HBxtE+mFLPDt35uhkw==", "d156b29e-af29-4c97-9e4f-bcef58fe5601" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1394ab15-353e-4581-9f6b-d5ee40acecd6", "AQAAAAIAAYagAAAAEMr94ZwdBarietDbt1qVtWyHXvGiBgy0y0xEh1+9mAU6q65Tbpcu7Vh7MrUbTUCXng==", "2b70057b-78e7-47a6-91d9-479ec974b999" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d24f8589-f9d1-48b4-a7a2-16f7d78daa16", "AQAAAAIAAYagAAAAEKYQxEHze5DV1OrWcVHyVihsm5xt2/CdBxE+dpu/gQZHz3r+f3oGrM++WcIQP5XH2g==", "e54b26bb-b0d4-44fb-8fc7-d99ea40c77d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "618e6b04-501d-4456-a3eb-43741e479408", "AQAAAAIAAYagAAAAEH8NbiCdJ9XqMO+AF/QV1VnWW2lha8Y+4xD4/jdlUmhuvwPMZsqWNeOaIHjNg79c6A==", "0d00a062-68db-4547-97e3-78805051f871" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c99cb823-c34a-4c24-8493-5b600aa90bca", "AQAAAAIAAYagAAAAEAcbvGaMpcbLrN8fYbMMeeI2iGF9di62QcMUG1rxrR9HoRVnWJHQr+qpKp9seVohzA==", "266e8f10-6c75-490c-bb78-df87ace9a6d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2125996f-d0af-41ba-ad16-64adab619242", "AQAAAAIAAYagAAAAELDz1EbQ30ao655Doh2b5X5KgkJOnBNgy4F6FJBl26By6NRXwmcLmvvVMW91BbU8JQ==", "34dc22c0-a053-49fd-a727-33021008ebc4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57dbbf76-1271-42d3-8ed1-f6384175b24f", "AQAAAAIAAYagAAAAEKxUcX+/GCmGxHBvTPqdwnFMWT4GrSKOvXX7nQjiZPvOTmmOFJpubqI2+AnHEXKZyA==", "5f26eb8f-adf0-47a6-a8bc-189ababacca3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6e886bc-1e68-4290-8dc3-a5924464e829", "AQAAAAIAAYagAAAAEL9ZV3c0A1UujV5mR53wL9OghyWC1lS06UXV52XeW1q2iGbID3Vwkm3A1OhZC4xf6g==", "3126af21-76b3-407e-9d80-30e1dd2dd9f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d3462c92-1ef1-4dbf-8a44-e24e8e99fda4", "AQAAAAIAAYagAAAAEKKCv9TnegmeCi5k2h615I/957/S3qKpzq/AxQOdTVVCmf9JSBsIZWhgR9lylSDJ1Q==", "c7d79617-fcc5-4908-a00b-ce18ac17495e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f554b68b-c60c-4b93-b947-f4f94b5aa0c4", "AQAAAAIAAYagAAAAEIecKo7A9A6Z34D/wmIrKM9bE8raSuq7+h8n5tqMh3nlangQK81s6kl8ZOH/cmcX6w==", "41d51afb-c9bc-4081-a918-7a50c57973f7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "160bbcac-2d62-41e4-984d-f557e49b92c8", "AQAAAAIAAYagAAAAEAvfS7PQi6a7PbHQfdtocs3H6WCe2JG7r6Zo66jSLt+NAtV9SowWXFQmn3UU1IVSxg==", "bd0ed8f2-abef-452a-a457-1a8ab4fb0bd3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10738d64-cd26-40ac-a018-4f669f4a6d41", "AQAAAAIAAYagAAAAEBWVbDYTJ77saxJLo6W/iMefg+L/LbNc8bMlzoivQszyHyM+GOIMKtuExdKUFdsipA==", "452844c7-d6a0-4621-a869-805438f1d961" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0daa513f-dc24-4d47-8685-a63f4b20af49", "AQAAAAIAAYagAAAAEIT1nlDXeQ94Y0WIWXC/X0AKL0Ik+cBIxHkIn7QTY6EaH6OGqXYhP6/lGSklchRluw==", "e857611c-11dc-4419-99ed-80f36b311c70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0bd6d23-f990-445e-be81-f21d5539e3d0", "AQAAAAIAAYagAAAAEDyVUMWIYM9HSZzbqcyHCewktvo/l9X4q+vLiIeL2NA3xM/VmF48ruBVZ0nUJBheeg==", "612126d4-23ac-4c8f-a7db-d2f83c1b8e24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db634efe-0f74-47ce-a93d-5a47307051b8", "AQAAAAIAAYagAAAAEBgG5qTIVo6Rz0iu5yReHGpryQSgSF6F9OR7LW+h7+3sCwU6XhW/nZGy5jzkTZg1Dw==", "02152fe7-00ed-45fc-be06-e0922ae0dc5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "648d761c-a39e-4558-9484-4aad16ae8c3f", "AQAAAAIAAYagAAAAEEX5y3eqMkA8OYOxzYrtT8rBY9M7cPq2A4OnsXoNL6n3qOR2cTg3yPaM4rZauYGkxQ==", "be177433-b4f6-46d7-b5b3-c1a7970eb92e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8eaddd3-6c38-4c73-9ae8-d79545f9ac37", "AQAAAAIAAYagAAAAEHJUxD+pjdM+Q7ro8rVUOG+xeGzMWnpRnnOqu4cbB0fKHfMfZT/vYKzNW0LJnV/paA==", "ed91715d-0a0b-43b2-bac4-cd6c43dd1e72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce8f2206-9d9e-4462-b1bd-3388b33ba82b", "AQAAAAIAAYagAAAAEOwzQ5NdOHEbWHpeu5tHegqVcRp4Di7q/pQNQCXCjqdazhbZqvlyFpk0SxUC9s8KRA==", "586bf601-2d46-4e88-a67d-ee48ba8602d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d356ea70-0f2b-497c-976a-3ae176ae6986", "AQAAAAIAAYagAAAAEOK6UqFK1nU4VIPIw/ZAakN3LbllEhu3FivP+LyNPbBZM7k5SRO0iSIx85rbsWsaRA==", "8e2adac2-1a73-4369-8066-42693a0ba89d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "80dd082f-1647-4dea-bd48-edbfd4e0618d", "AQAAAAIAAYagAAAAEMYOMsT8kMaVBr41PaAkaXnX7JXU7FFOvyls1lABv92BWVK0gOxtAZsMF13xlWKUvQ==", "18ac370b-8ac0-40c8-859a-f00d5cd968d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c14ba4d-9e94-44f9-91dc-8242d7a15747", "AQAAAAIAAYagAAAAEBdqCJCBOX+Nblb6JdpSqkVeGZOL9N/jETIrLKcr7raSbanbscoJGRrnFz69wM3ikg==", "502495d6-0524-48af-ba6b-bcbc35e1b733" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f2a9ece4-2b0f-4e05-84cd-0a776d58f4f1", "AQAAAAIAAYagAAAAELQ8YhsI1WJPi7NIMkGHjHJUtLp0w6WTVNWsy+uj27fsK3nWwmHdJcvLCApx4wJ6BQ==", "9f6c7c92-95c9-4611-b73a-77749e0ea1dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56c8bd1e-2893-42fc-946b-48dd85a038b0", "AQAAAAIAAYagAAAAEFfMSIPQz6y8pbtWaQuhxk2t+yj5b9nbBkrlFaa7zXJVBT6MlpVdL48H7qOXXiKURw==", "d58b81a4-9d1a-4cb9-a8df-e8fed31962f6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe7f49f0-a5f4-4602-ad62-dc7e312d83af", "AQAAAAIAAYagAAAAEFO5ZxdE9AxsB9XabNvTDVeGlDXDtyDw4UDHSFB7VzImzm+qejpGfrBk06W1GRecyQ==", "c043c45a-308c-4a40-8afa-cf7214c5db19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df639d41-5bec-474c-84bb-70395eba9284", "AQAAAAIAAYagAAAAEIFv51BBkjKFx5puEb/o/boqsWon6ZgwpLyoPlmBlNrnN7Ao5f4oIsRqXFnudfiFaw==", "a381654c-bc5e-43f3-b3dd-c042233215ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "693bcf4a-6b3c-4feb-9f32-22ef05c0fc20", "AQAAAAIAAYagAAAAEHFfdSP94vswRqt4SV+c8EjFYhBOsNCc4kMv1dniSQvRjZRe3bsjx3uXx1DgMT2ymQ==", "15e2576c-7432-41a5-ba15-c7f3ede10860" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4332c9d0-43b6-4297-b64e-e1a574fb91ce", "AQAAAAIAAYagAAAAEBJeJW2b1+fv/xHnvbVZma95dB617B+2cWV5Fhu/hziVh4J2E6N+2ZThAh9ypt26ZA==", "3436a1b2-67b1-4012-991c-bd437dc4c1be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60d7586b-1112-4681-a886-6e11ab0c2926", "AQAAAAIAAYagAAAAEM0YJHmyZuS2m+wGgh9Pc8AkycXFLYkXPzCV0aInG+EwqkYrowqC4Q/sMj4caunYhQ==", "44aa21ee-11ad-4e76-a535-484bfe786eef" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices",
                columns: new[] { "AuditorId", "OfficeId", "PgsPeriodId" },
                unique: true,
                filter: "[PgsPeriodId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.DropIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices");

            migrationBuilder.AlterColumn<int>(
                name: "PgsPeriodId",
                table: "AuditorOffices",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "35585bd7-bd63-4df3-b6e3-f84eac6011ff");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "5be90e82-5512-4eed-9478-a581bd1532ee");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "7f58db33-b50d-43f7-87dd-4d848a4802b8");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "b42c364c-be8c-48f0-894d-02109f5c2e39");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "1b71cc11-f955-49b8-92ac-71a427ab5f12");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "74c4c213-c899-49fb-b079-550a44da5e8f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "0852e8f4-306b-498f-a9ee-979f2c98fc38");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "aca0b610-7dc3-4a31-bee1-6aa8f7695bbe");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "091492d5-f0cf-4e65-ba9f-320c5e7e37d2");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "13087d6a-50a5-42a7-9c2e-ad14f24cbc6c", "AQAAAAIAAYagAAAAEHCVgdm+m9zEcPrbjow0HR4sEjMfAZ187vHZzkuUsIqgp4/A6SPq+72qQxw1aFAjFw==", "d79e444e-0590-4e8e-b3ab-ec037f2d11c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f889782d-488e-4315-a99e-9484d950169e", "AQAAAAIAAYagAAAAEOMdcHEno4oXtYbn5wy+G9eELTVwAgpgIo30KGP6rW7yzLHh6lpLhtcc6RvT2n/9Qg==", "562ae1c2-e4f3-415b-9876-3238996abbeb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f3d13432-f9d7-48b5-8fb1-8a2407805aef", "AQAAAAIAAYagAAAAELdySYc4i3g7+ajKV9mUTTZCMosMImdQH0BacWicBlSjBfj8jFwvdmvBnlhavTYKxw==", "913c3247-44f1-4082-a0a2-cac635773cf5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8927aae5-e7b9-4ac1-9c9f-33eeca7517b1", "AQAAAAIAAYagAAAAEBd8tvCflSRbNKzcp+wwlXpdkI6Wwe47/E4NU8vlbBqj/1SwM/jF6Sg3xyPDxnx7kQ==", "d0b2cec2-9bf6-4ea0-a0e7-390e8c104432" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "762f39a0-4a60-4d3b-b3f9-5fab17fb4808", "AQAAAAIAAYagAAAAEC5byavwGMGtvt80SA8MzfEJc2pXyvuFnY/7OCS17SpPAfNyZ+4ooQsscFxgvRzauQ==", "849c1177-da18-4b49-922a-b884bd516846" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e40deb8-855a-4f21-87de-a511212f4cd3", "AQAAAAIAAYagAAAAEIqmjghPXjExfeJNoNBYtGwKRUC0G9W05rGCsY3NFNsYSCtuX6fu/Jhao8we/mXHPw==", "252c7c72-b2da-4626-b685-edd12f1e4f57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "967a3ef6-fd95-432e-b382-f74eeae8fb2b", "AQAAAAIAAYagAAAAELeEgZ1US0nvTPFvS+Ats3oAyeaa//bIVy+dIVnkfk6kw+IZmI/07z36NPOoUBlBKw==", "9185109b-1fcb-4b18-b925-6c0ffc25085f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e723992-eea6-4bdb-b6c2-0768029c8cb1", "AQAAAAIAAYagAAAAEOSDiMBRvUIsY2ovrMRONlVhHlRk8h6B2exsIWGCU0B7/YjlDTnH0i6nWn38Oy9ChA==", "adaa8f3c-60f8-4085-9792-4398d6a3b721" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9496673f-849d-4112-abcc-f96892506ea4", "AQAAAAIAAYagAAAAEMSKitt+EEuJHjoLtB+UK87FMOCEepgPiVEPZwjyqqE3Bjaziso5E/Clecl1ikHQIw==", "6dc3a0f2-9a46-426d-948b-d20fe4f24fa3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbe4c832-2977-4fc1-bc7e-33922b94a794", "AQAAAAIAAYagAAAAEOd+FR5t1KVrRSwhEtCzZOKZetlSFYvA5f51T78Xc3psWfbOJbwFHSG8HdOyQ4jTSg==", "43e53311-418a-4ad8-a458-85afa106c5ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5601a756-c363-4c4a-b58f-22f07dfdd26e", "AQAAAAIAAYagAAAAEM5dJisGBuAtABs0GfL/eArhanIFn7VQVBK0pm8A8N4+eAfF9xY7u4iZBrOhK/b7LA==", "e5d96b88-25a7-4110-9df2-817e5dde1624" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "321fa871-9520-473e-9bf3-162b8f07097a", "AQAAAAIAAYagAAAAECYLgyBk05eEcdauYm5FrpwHwpTPbR+DEYiePiVhVL4C+7EYHanf2dZ3RUTbfUmY9g==", "168098d8-aacc-4ff9-8931-1d32334a146e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04dff7cb-0924-487b-b54c-383d33a5f901", "AQAAAAIAAYagAAAAEJJ/9YFoF8yjDMQGW3aLHBSDYHO2q2fwe2hspzOdOPAJjz+GHdpDBjugjoK06ThRAA==", "e3573c32-e180-499b-9d82-4e97067dc7ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2925fe5c-8c42-4baa-8095-64d04639a4a9", "AQAAAAIAAYagAAAAEGmiOlIoQsOo/nMfBcTe9eTDbmd+NzoySZjDvzV4I5KisSyrojmr0i8PSRGJWSMyVA==", "234d2149-4fee-4879-8276-d51a4a39106f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50021d0e-5257-4c65-a4aa-517b8d2a2465", "AQAAAAIAAYagAAAAEGKHHDKrE9NuCwur4HXhE+pG3271m/L0/6d/K9xnnW+cmViYhL2DKvqdGMSboR1Gxg==", "c26f6023-3bdc-4cfd-ba16-c4fd6930d9e6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "530d93d1-48bb-44be-bdd3-c210b10aa2af", "AQAAAAIAAYagAAAAENyACfzf8PvgNHtiuS0xnLsCdjK5nTHYwKYrMz1Fd7hXp0DnWUeS/q7BRUDXtjnGDw==", "334133f7-d99d-4d58-bd0a-156d5164448f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "264b15e5-af4f-4c77-9d88-d31232337d20", "AQAAAAIAAYagAAAAEM5FwQI8vhpumS8Q6JRFbD4GbLJQg2PR8RcoycacetakjEwu0YPLuYAjbnkIA2nLZA==", "2d629e34-e789-4405-9d0d-ec80fd8d97e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bf76bca-d4d2-4be0-b194-59750113fd0d", "AQAAAAIAAYagAAAAEPrToIUVIlp48cSHeD1MiL288MPwsFqmh5pzZBtx/Gc4LqS3bBh4pDOvK3pIxWxj9Q==", "c085f664-357c-40e1-aadd-11a10405c12a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed740d9f-750a-4409-8d2f-e8f5802d7744", "AQAAAAIAAYagAAAAEE1SHka3lr1DtfuiBgiud2bWH2IX0gO9PdoB+qadpUdltfP5Gaq1vH3uwLT/w7VTnA==", "48362a35-f77e-4de2-b0d0-783ddab7eea1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "933bdbe1-5a83-43e1-8858-fddb830a6b9a", "AQAAAAIAAYagAAAAEIt/2+Vf5OusSGuOSEqL6aKlcqQ9vk6DHoX/d04aeTr6UOfr0EGdLH7aXUCwMjOhzw==", "1fe8f78f-5111-468b-b8f2-c10243f9e92f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46a12806-d0e9-480a-8b67-09e505b65c88", "AQAAAAIAAYagAAAAENn+SDN8ZPJsTYxgAcIhDkNjJ2q7oame69TU4pfEtnLADMe2b+fvVkXlctaGyLOh7A==", "dc501d1c-6691-4d55-abf6-9d673089444c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "13e5eb07-7ab5-430e-8a9e-85340088497a", "AQAAAAIAAYagAAAAELaDrWhUMAUO6lMOJtWPmEqSTnVi3EslFilHKdraBE4GNn/ev3xJQuZzDFsNAsx/4w==", "2839bcf7-9e9e-4929-9b53-5093a032edcf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8acea049-af65-4666-89e9-f8d3e502c87a", "AQAAAAIAAYagAAAAEKh75CEI/9WNdhpWVDLDwwSzjArHRgnsO7fRb+umn3bJg5GFpXCKirk/yl4Zd98qzA==", "502c15d5-80b6-4d93-9d72-972c737c2802" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dff909d5-6f24-4ac7-8063-ac7109998cf1", "AQAAAAIAAYagAAAAEPLD0hhAvrJmXAHjriS/Xy925ZHAQ40zjyewBory07pcDD7Is6SPw2FAQ4aaODTSVA==", "2a6d06a0-a36f-40e8-bdca-d0adaf673487" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b71ffec6-8578-48d2-a67d-0cac9aa49415", "AQAAAAIAAYagAAAAEJylh/xavIJ9uletiC37SQ5/+LrcNNWMXaAJHq/FRmdmtEEaTTo8wWzLk85L3aOoZw==", "7cc60fe4-8210-4586-90e5-078365a409b3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f248e16-a1f9-4641-9bea-ca0cc39e92f2", "AQAAAAIAAYagAAAAEEH4bQQAd/IYNagMMBUcY/CVud0LGKFsiVYnpij5qp4XwdWTq7oZ6hSsu2MbrgOjzw==", "057cf5cb-3da3-414f-a0d2-aacb2ffbb39e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "272ac7bf-c13a-4365-90a3-4b9234ae587e", "AQAAAAIAAYagAAAAEDDPP4iZ4Fu75dfCAnBpw5Klxz0AyISwY7vixXgIE1EbLUv5j+L7WjleBbv1j31UUg==", "d52416de-8509-4668-ac12-bac8de28a30c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8bc9c0f3-471d-4db5-94db-1bd8bb72ac58", "AQAAAAIAAYagAAAAEC9Ty1WHO/Yxwpi+B5wbPspBj/bzvG+ZQwaTG1TnNmRNF/AFFKHstuCD1CW5I1BFLQ==", "efa307bf-a4d8-4ffd-abf9-96699303f45c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "817d884a-a97b-40d7-a3f7-54a2dff6feb1", "AQAAAAIAAYagAAAAEGXUR7u7YTMEcAVXNmx47taow70ag6+nyK3vvOl8+Gh4PbU/yV/YZbQfvQhn3L7HQw==", "cd431a0a-fd25-4c3c-a0f6-d281bef31776" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ba3c1a8-c9e6-4206-ba92-422531d83d7f", "AQAAAAIAAYagAAAAENFs1l6lIj7/QazG3eiDu2+HKWFNtqI7atPxaXaFKEgUxOXJkYtH3n7S3kiJHXaTbQ==", "391f4d58-1e92-4a2e-8bd2-d9e749b2df6a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04504b52-4b0a-4589-b5d4-97780a771b2c", "AQAAAAIAAYagAAAAEFn4lVo1oxaYoIYS7hjPGV/qWBctFwuypwbaOqk2glaKqL4zjBjOQTRmlL4Caw81VQ==", "df0041ac-beef-4552-a1e5-90646b4dd103" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9f7f6583-628b-43cc-b98c-d795d4bf5fd9", "AQAAAAIAAYagAAAAEECs+XKtAv7CcOkj6F/RQb4qKLCLWI8WV12hux0+d6StKjP//ZWBjmMe0jjxuatIAA==", "52aec6c2-b1a6-4c9e-a483-f16dccc2eaed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff5f05c2-67ab-4ac7-b6cd-3ad4ff212546", "AQAAAAIAAYagAAAAEGpYbEjfMudxLgwCO997y+ZqRgz+2C4bIe3szQsgloSp/CRGhNU1T6Q/Zv7xKpXF5Q==", "1f951ab0-6865-44aa-b7c7-e5fa1bb0ea2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8c94bbd-6111-4ade-9c3f-6db72d248780", "AQAAAAIAAYagAAAAEJHL6MywQnbTA7ra7KMKQjIQ9gZ9n2nSzSWgpJTwE9StewosK915C+AQzTE7vWe92w==", "40eaa9e1-e2c1-42e9-a742-3cc579a29932" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8750367b-686a-4b71-afe3-01ddcae0b3f7", "AQAAAAIAAYagAAAAEA5sF/3Ob8NP4D7z0R5FD49scWmugVS9UJEarHUrbCYHyxF2+viYr7B7049mpQ8KMg==", "fc3907b1-4b29-48f8-9f43-99e04fa7f820" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11e8caae-e061-44fb-9ef3-fcbb2c8ae5d6", "AQAAAAIAAYagAAAAELPv1orBaOwyEG8B9V24aMU9agem7NvZ6pGFoiT0keceoJhSGWyWbjBgepBiN4Pq3A==", "ee395b95-7722-4a25-9039-09b540f2ae95" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da210327-e02b-465d-9014-b900ee525d88", "AQAAAAIAAYagAAAAEDWR7peX9Mn4a9CP5R2Tft8Sf6Qzt+duWVVd501oPYGSSCNw5NOMyQCdYNcKxS3m6g==", "e973cdd1-d787-48f2-9404-885d79717114" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d2d13fd-7936-4b5e-a2bf-77ca9c9b55ac", "AQAAAAIAAYagAAAAECo5i4VfKU6SM6ki02c7aSP/a1TXSpEYnODf3lEWVZdOowuh1Pybv79t0SItvm9h2A==", "f6f1526e-60ad-44aa-92bf-6925f383a8f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46a2e324-2eb5-4fef-91ae-d3b143239b08", "AQAAAAIAAYagAAAAEHu1bT2uBf7AYsJhFYKBuKlBObnKDhNgPROxWz/WY/wCbinnMBOVZlesQBUAIVXMzw==", "95606829-9dd7-42fd-a9d2-ddcdbfe06651" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6487b46-0492-49f7-b94e-c94d8898d9dd", "AQAAAAIAAYagAAAAEEp5ELXN3RLQzxflYis+4Ypk/tyQBwNPqiqNuMQYeZ0Hy8G6FB7jwkcpMq2NY/dm5w==", "36aba60e-dabb-444f-9bdc-5ac5cc0c4434" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ee3523c-7c43-4950-a164-8522870ec220", "AQAAAAIAAYagAAAAEGsFIPsThJjFEQJeRDaHq10hrzXHy4fulq5Z0IkQX2n6h/2omq6UVdb9Z/c3thsSRg==", "5eb6bf62-e663-49b4-b3a1-bafad531d343" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "32a231b3-6de6-4c9a-8236-2ad9c4a53001", "AQAAAAIAAYagAAAAEK5JB+aASo6538g3HZdnVzxVvjOTJiEKDhkJYoOY0G8DfbLg270aZ+KLAIiMdrlhLg==", "167e6529-01ff-4cf5-ae5e-744ea5903bbb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f74c2f96-d427-40de-b449-10814561c614", "AQAAAAIAAYagAAAAEMiGFpQIUykXKwuwkUhQ7KC7q7yZtwBMjySJmcCRCFUOlLNxOtHjlztTqj2Hd90/1w==", "de1b83cf-04f8-4674-96d0-c3e30b1ea722" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0cf3b22c-8dd4-453a-b1db-79b34432d6e0", "AQAAAAIAAYagAAAAEKt+gmhbJ8xZ77VpeuODIXXmNli39pBirbBKvESm2ZQCnImqi6caIUXL0f+7/GmWVQ==", "b720c865-cb1e-40dd-aa18-e500b752c8cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da9c0b24-0e51-40ff-9e4f-f1d26cf52ee7", "AQAAAAIAAYagAAAAELyyMtTay6t75JzV58aRJgAyD2TEDfzxNUrQV+drRnFn+V1cJNNA9hIUSHLfs/ADXg==", "be06829e-3b9a-4c3a-8c9a-e62a362e7013" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56946cad-52e2-4316-a874-0a5f4301bb59", "AQAAAAIAAYagAAAAECFAprFFFvNBZB7LuEL0F3PrmoMzlxCWQW09Go9d3tbPFGdwJoDRi/7AH5n6bG2BOQ==", "605a32ea-a4ae-4194-a95d-e2c809d5d5f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1718dd6b-e6fb-4326-a725-1f57f513e8be", "AQAAAAIAAYagAAAAEBLmOtdpHXPyIq/AHfeK/xZzvGe4RDbItx9zIHqJY2rT3QQ03B4cecmARyv5K+2xlQ==", "29119e8b-b83a-4904-ab6c-81dcc46356a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c38a13e-594f-490d-9241-ee716c735b00", "AQAAAAIAAYagAAAAEDNIVTqzNsE8wkcneEKBwVQC7MDvUmAHnPVXOnAwT1kgK8HCXPFROdD0aiX3qPLLmw==", "172f712a-0f39-4edc-87c8-2ad10d56f15b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea9fe1e1-438c-425f-bad5-5da8c1df6eda", "AQAAAAIAAYagAAAAEBTyxNmjJeAhWHLiQsTMUJ//RFojyM+V8oSMiHMDTOd2ZV2T7/h8UYiuKFNlJbluxg==", "5a54bdbd-16b4-4c64-bc9d-1701e0574f61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bac727ed-6aff-4066-8edc-78a5fc290ffe", "AQAAAAIAAYagAAAAEMKgxa19msqXyvYKXbiqJlsl64FZ0JcVcE1dvJRowUEjmagFLAo+FNOYqgVEY1m/Vg==", "04155d37-82fb-4ac5-9b30-7f972183211f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7d1fbc2-6ecb-451a-bdf6-32f04f1cabda", "AQAAAAIAAYagAAAAEEB6NXMOq9FC95P1m12IROS0FoFjwHYT0TS43+t1FurAcMrguMt5aMnvDBluXdjpJQ==", "b4adab3e-057e-4085-a4d6-75617747a95f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca6204fa-67af-4778-bac8-265b5905ac8c", "AQAAAAIAAYagAAAAEK0sD79cHNmQffb++TYSmrJYH+dHO7ieUfUNxZxb4CDn04LANZ/3DeRW3FqwV/p3XA==", "c30ed2b4-e407-4d59-b1b3-4efcb8da09e6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cfa08f15-e655-4d5d-bc07-d6d3764f5189", "AQAAAAIAAYagAAAAENZzmMUbs6UF8PtEMUZnWeU+0OJabI+au1cbyJc0Cvk1MRi/YJmGhE8QN/jh8EU+KQ==", "efcff2fe-a934-4dcf-a8b1-030e4e821b57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "44a9a867-304e-4673-8e6b-8b2016858045", "AQAAAAIAAYagAAAAEL6YThyVRZLLB2u8OesVaGFEZeR9NdNukv2+XL5WvwqbL5j+3bpztlAEyutCFf5ynQ==", "7826cf71-56a1-4e9e-927e-794ecb811a4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88173599-ffac-40a1-bde0-000b84df35b8", "AQAAAAIAAYagAAAAEGOcmr+b+dKAZwhJEtwdECTjShulwGMD4wfsbZZXCgTmhCf1IrGGdMiL8Y92l6MICQ==", "261f4114-1491-4642-84cb-70702dd89e1c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4755b3b6-ab1b-49ad-9647-0a980b672913", "AQAAAAIAAYagAAAAEJpsufj/feg2tFoyALYFXHtA6p93H8VItwqiP9psZ4KQqHMUnkUKdHkGU/qPeVlzbg==", "653b9f9a-e1e7-463b-b8b9-74c4fd3bf5ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9866aae8-7238-4417-abdb-3da2c1b43953", "AQAAAAIAAYagAAAAEACjpwqx3tzSGKhbsaxnwTrlIPi0PgLuuRaFSGNJK1XjqdOYm5py825/+dGjCVOqcw==", "93d67b0b-2cde-4b9d-a390-fdcf6a453dd8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3a20876-c33a-4209-a989-77ef8a485586", "AQAAAAIAAYagAAAAEC0Wxq/lxE8GTbAf+vWamrvWqYrDZLdJON960ih3OupAbuv1ugOnFQ49IQGY0FpkyA==", "1c5e2e5b-66ba-4346-acfc-c9645c673c7e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4d26ce56-4715-430e-9ad3-b1405daecd33", "AQAAAAIAAYagAAAAEG/IbuvjQBCrBNYj+RwMR432emTB1hnSovlpJr5samvpuQ7kpE1KUPZZdhLUxITYYA==", "cb812113-65c3-4c22-b2fe-1fdb85553e56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55510828-b48f-4951-ad50-c4c8543b7d01", "AQAAAAIAAYagAAAAEMn2Oar7P2H9rUkzQ3NwHc1tA+lz+TwdHdPEgAIczN6TmiAe7ij9+FyVCJP95MUnnw==", "b5442f04-b627-48e2-bf17-4ca20dc465e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a16d7a45-e713-449b-92d0-0cb7386d6e40", "AQAAAAIAAYagAAAAEKWQCBTuhXeseVTq3UREdkpM837Migw8o7reI3Ea5Dzn531UomVcmSai4hnfWgqZ8A==", "6a69b7c0-dc65-4791-bc34-a5f03a0a013e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "718fb4f4-b73e-4fd0-aadd-4b5ebc0cb464", "AQAAAAIAAYagAAAAEDEAPI5trGLqN4vKYiQ0y+kn5AzuN0O2X0TWjTO311Rh205XlUufx65BlHrlBd1zpw==", "b731fb15-e3ba-42b7-9a16-a69c9d3a6b64" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a92beb3-f0f3-4d4a-9ef6-690f27587d7e", "AQAAAAIAAYagAAAAEGc2Fs+F8bxd/Buw6WXMPiVTG0sN8vuPlKLprivOfH9mBZftv5mFWHn4rNhrvax97g==", "30e4148b-7d3a-44da-b7c2-3b1516cefa21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c708344-82ab-4fe7-8045-bcb20446aac2", "AQAAAAIAAYagAAAAEGzGZ7n03x1NZOqbtzXOxC/N0A2pot2jvu1OBn3aFISkxEWHYs4QiAkX4wIaQdDzxg==", "63b40933-a6ea-4749-942d-8e2a65bf8066" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce9af11e-6b05-40ee-b7b0-e86b4c6e6f2f", "AQAAAAIAAYagAAAAEFEgFA49JPDD+S9V7jXdj1axjXpy5bsyBfr44J43rPwB1CllaTWmnxnz5Yog5x9HqA==", "0b6c6d5f-aea1-4450-9a75-3a17b2760eb7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62d1254a-117c-4ac5-867f-97a848d0ffed", "AQAAAAIAAYagAAAAEDRatcEuPpK9xa7NlHYtBiUsyeBlyP7OXku/t6RU4HzEODLO6EytQOndUosGu1Af+Q==", "cfcc1a05-b8a1-483a-9cc8-2228d8f323c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c079033e-c612-4fb4-8ad7-4b6d1047b819", "AQAAAAIAAYagAAAAEARSdyhK1Okv25A6nUYaE+5X3FGPZ9ekGHRIzREjVYQ7SK984dWADJ1gYuXEFFBItA==", "c40eb6ce-9bb2-4e55-9cb4-0dbc4f0c4d2d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0be5c239-e031-4395-97ea-b7681f15fb89", "AQAAAAIAAYagAAAAEEpn/dRFM1f9AdFTRHzQawSuAoETbtiH8z7TMzPMahdVc5eQIo0crMLUqmQ/tSuOZA==", "1f832044-1e30-40f8-a135-d91130cff5e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "622c79dc-d6fc-4133-b509-397885544ed1", "AQAAAAIAAYagAAAAEMnSwJ5vrIhOTmw3kvapo0tDrnaqr09AdSUjEuYYnIK1XGz3IlHKrJmEcod/cWt+/A==", "22ae2481-e79b-46c1-ae8b-f01da8176b00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f1e4004-3714-4dc4-9623-2aeb507eca07", "AQAAAAIAAYagAAAAEAgMKs/7QwSYVwou0KXM8N/28m+0Mx1J8z8FS2aKmeoI+GWcY/jVKoJYqqsKdFN/Xg==", "7240f644-26c3-40f5-bc8a-05b7f7334aac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b7f25ad-f1d8-4f4a-b7b0-8d21b2461158", "AQAAAAIAAYagAAAAEN1iWosfhLcD3nsG4I7ltuJ3+oVZv1NJJapsuIsHCcARjx61zFTS5OyD0X6lMn2cgA==", "2f2da061-cd83-4d77-a8fa-057117da0eb8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "828e764e-2c09-4e80-97f7-1503964639df", "AQAAAAIAAYagAAAAEKe5joPOBhHg4KX2BfxiL6IlVcPUuDwrToQowaEAJ6AFpEAdLuF/7SYTG0qyz7GWyA==", "a359e980-fd48-44de-9eae-556109da50cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e42bc277-b56b-418b-859c-7f1964dc28f3", "AQAAAAIAAYagAAAAEJzwn4y1zWz3jnN4P2+wy2/iq36x18zSi4mgPNVkHqyQVVlRnvLt6Bxm3s8cuPKb5Q==", "24477e54-825a-4e1f-9d34-20e1f52ac2a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "916d33ef-f897-4787-a22f-288c909ac1ed", "AQAAAAIAAYagAAAAEMKAYfH/9OOq7XyULn1DkxDR2joB94IbaVrx15kTcFP10fPgok4sobFIrG93ffucYg==", "7a1a9a12-3e21-41f7-a2b3-688b61d3a956" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "33fb7235-626d-4311-9151-a5364c07fa79", "AQAAAAIAAYagAAAAEH1LGVJIVzj/ZzcEYKpsrp2FgSq8fJUJnHjFJnH4L2EdXLD0E3LmD9q8XId49Gw+RQ==", "a455afea-3340-4497-b1f9-e5bdd09a71ef" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07726319-333b-419a-979e-d7851303f90e", "AQAAAAIAAYagAAAAEBiaUOYsIlaIksw0wHHhYjwh8TXmGaoktbudiFm/X3GqE+8FLz186L2JYecfdsTikg==", "0750a973-8b39-41ab-a625-2a0d11044d73" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40084b15-45e9-462a-b8cd-60e7349d0c5f", "AQAAAAIAAYagAAAAEDkem1YByTWCbS/Mh4TjBg/BApkdHHbarzrx2VPDNA66QznCGRq0wfhuCS9Fb4Y17w==", "11f2ed22-603e-4b2d-8c09-210e3255e011" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b14a06f2-9fb8-4ca4-9392-ba140fab4247", "AQAAAAIAAYagAAAAELGN0i25RdNypq4sWfx+aSoCRwA1sVWpp6Cpibm5pcqnyIdbbx8fZaLzSo5G4vnSNA==", "5fd29a49-b7dc-4df3-b5fc-cb149d0fa858" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d419d090-ceb3-4a53-91f4-e960a6dc44ec", "AQAAAAIAAYagAAAAEJk/ysHHVT/xZ/eYmFLiTBsbH/lTkJRwoqGp99gofwX7Kwjb3z3WpyeBCy/WHbV2/Q==", "a4b85caa-7ce6-430b-bfd6-c76e60a9f6da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed7ade82-b623-49d3-ba31-be5ee70231b5", "AQAAAAIAAYagAAAAEEEIBWLkae1fe1Y67PGSCClEPhV5eijYdhNHs87BIJpgQ4DFYz4ItmJ7SiK4NhxmGQ==", "98f2dbf7-23ce-4954-961e-c9fbb75eb95a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "321b6ea5-15ed-46f1-89e6-8a7e8074ea65", "AQAAAAIAAYagAAAAEBXFnqLHXfZybRRNhECb/d5V/in0bTWpTrvidnnxSU+lyk00CsxVjzLDTU0lsG1/pQ==", "628f749b-e754-4166-bbf7-2940681cc38d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "828b3a15-a997-4e5b-9a0d-8af52d9a77c9", "AQAAAAIAAYagAAAAEHDi9ExXgPInk518AGTnn8o51t1XXPAVyGSCbvuWY0O2ESxw5j588FMBS+Kvjeaiag==", "c9bec9c1-5f15-44fe-891d-22b9ca888b7a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d4f1d20-6094-42cd-a2d1-55abe67db945", "AQAAAAIAAYagAAAAEAIkMocy5U4OKbzl0KxBmjZNTvZtR+bQqRvtts+F1AxjFXJsGk63BGsKGtqfNZDVYw==", "dcd8ec40-455c-4e9a-9f17-d2502ab3bd31" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be435a3f-4e9e-4d26-9596-2907a61a86fb", "AQAAAAIAAYagAAAAEMm/u+VR9wOsubHauc/Jn1hPfORryk+MnKC7cQbJEDHB8DejDMO4+3DhSsaPezNXpA==", "4757cc99-bcd8-4a88-abf8-4e1cf70986ff" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14018fa1-fdfa-417e-9010-243ca087634e", "AQAAAAIAAYagAAAAEG9X+rybA8pkIEjeg4YKBBurbYUTQQlvHq/JgeiKQs+HYfrPL4OQRNrWl0WbwNTNfQ==", "212abcbb-b337-456b-9a2f-a5588306109a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "186730b0-8bf6-49dc-8be3-ceaa28cd69f0", "AQAAAAIAAYagAAAAEDaRLThodXf6eLCaMEFKbnzq7uPv6t5PMlB0Cuw2UvLB5zAN2QCCoyl4a3IlF71Bsg==", "1096b329-bbf3-4e9a-bb68-9be9e00355af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c08df7b-0b3a-488c-b74c-6a461914b652", "AQAAAAIAAYagAAAAEGoBtTWovA+j+QEEJkpUxwIEUlPublurtSfe+VRFl2CZElCzzwWTXx+bxfgv+oSxIQ==", "c39cdca3-1e1d-4f23-8fe8-d1f12af68173" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cb184c7c-b348-4dff-8652-774dd91ac253", "AQAAAAIAAYagAAAAEJf/cm/kGQKO9d/earb+uQrpcEVjwhoF7B6FJmO91J7dp+1doDhudhm43ZFjPJhCTw==", "c6007d7a-2008-4949-a761-734bfc861af5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cebf046-eb3c-49de-89d0-e9381ec66d37", "AQAAAAIAAYagAAAAEOqwAXK2afaPb1jmwWvwPqSBdS0LCMXjnZuXNIhl4nbLSi+gfcU/hYSFjtKYEDcxfg==", "5c3228d5-fd71-415e-b757-4151fc5b4b02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af7b3283-c9b2-4c0c-850d-c908539ad81e", "AQAAAAIAAYagAAAAEDCtwziVzcSTNxIxKLZw8gzD0YAW43f5NDYD8lc3Z85oa6VBoDSKvvcUCF+6K2FEag==", "0c5f6d04-27e9-4005-b569-1417c869ce42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b3829da-45b5-4f8d-b0cf-20be18893517", "AQAAAAIAAYagAAAAEN2PhUjXSi1kF+c8EGXQhLhSIXr1HgdEeUaRLLoHraDYGgkPoDPsCvym8HNIe+Vt1Q==", "bd6d1479-da78-4294-813b-2c97740ba41b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8a1eeda-5795-4595-ab8f-db1e2e27457d", "AQAAAAIAAYagAAAAEAcHGwTNntgfvy+vNndUMFDGzmucAaOkHgW3QVL0AD6/v8aTJmCev9uGwzVPCNKZQQ==", "8d6be04f-cd7b-47f6-832d-55dd092cf79b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bcb9edaf-207e-4058-84bf-1cafad42ceec", "AQAAAAIAAYagAAAAECxU6oHPu95oQOfg4fnKZFcQUWDd1Lah/vq01EOzKEmXrh4epNar0uZyqdxyhp2iWQ==", "d40c8d52-b0d8-4533-97fb-4c1cfd342847" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4198ffe-28f7-47c5-a256-0ab7cc299e81", "AQAAAAIAAYagAAAAEKRgOUmIKmtLfbKjKp1JgEqBqqeTGZN6b+Vn5Q3ppVY8zzZ2u09r2DqZ+fI8WmPpCQ==", "0a772b09-7934-44c1-bf9d-3dea6012f397" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ebc97a7a-1bd3-4b28-94d3-1135881426d7", "AQAAAAIAAYagAAAAEJLwRZ9t+67ctzNV30yM49dJYnIaO0Th2SRKmacMO6m7QzTOmaifKLAFDrVAVDPYFw==", "ecb60b37-838f-4716-935d-0117921fadd9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "457a9a79-23bb-4b36-981f-2be146555150", "AQAAAAIAAYagAAAAEDi+6PQskwu657N2nBo4eX2B8JIYTWhD6mrFE9d77/DGWk5KF3cfPxuD6ok9Vav6Ww==", "ae0f1ab4-bd65-45da-a0ad-d64979a55d54" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditorOffices_AuditorId_OfficeId_PgsPeriodId",
                table: "AuditorOffices",
                columns: new[] { "AuditorId", "OfficeId", "PgsPeriodId" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditorOffices_PgsPeriod_PgsPeriodId",
                table: "AuditorOffices",
                column: "PgsPeriodId",
                principalTable: "PgsPeriod",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
