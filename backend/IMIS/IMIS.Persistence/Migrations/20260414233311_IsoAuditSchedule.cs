using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class IsoAuditSchedule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropIndex(
                name: "IX_AuditScheduleDetails_OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "EndDate",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "StartDate",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "EndDateTime",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "OfficeId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropColumn(
                name: "StartDateTime",
                table: "AuditScheduleDetails");

            migrationBuilder.RenameColumn(
                name: "TeamId",
                table: "AuditScheduleDetails",
                newName: "AuditPlanEntryId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_TeamId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_AuditPlanEntryId");

            migrationBuilder.AddColumn<int>(
                name: "AuditorTeamsId",
                table: "AuditSchedules",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Purpose",
                table: "AuditSchedules",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "AuditableOffices",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "AuditableOffices",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<byte[]>(
                name: "RowVersion",
                table: "AuditableOffices",
                type: "rowversion",
                rowVersion: true,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "604074b0-eb0c-49ef-b919-b81a2e02a185");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "906f2475-515c-4b83-b64f-1bcfb3cabf07");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "12b069c6-cdd2-4cc8-aa23-81de3f3242e6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "65b665ec-1215-4a75-9836-c5e80092d45d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "927de29d-1052-4f65-a219-efd344fdf8ac");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "92be79a1-80ab-4bbe-ae9c-6d6136446255");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "a0b02b2d-c0a3-4249-b4ce-e9f384584531");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "5969206d-843c-4750-a0b4-ee5d6a760d7e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "62a874e3-cb5b-4ca2-9117-8e2540c78651");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "a96e9631-0200-4f8e-b605-25593f1c9677");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "afce0da6-e44a-42f3-9bc7-3965248a40ac");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "969f1c36-4200-4d0c-a4d7-e5527b9d1e5e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "422c504b-a68c-4135-b557-e93009d88134");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "1ffff2f9-a07a-4f12-8a0c-3b0384553c29");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "72d29ed3-8dcf-4457-bedf-6f14b0382a4e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "eaf1c53b-4df2-4327-be53-632390baa62e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "90ac2ecc-8dac-4b1c-b18d-5c65b05a856d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "94df0d92-dbb5-413a-98fc-b860126584ac");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "9067c1ce-0de2-4eff-b3ac-4ba77ffd8622");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba97986b-b1a0-4ab0-94f0-12af56b9229a", "AQAAAAIAAYagAAAAEIFF0bn9jVTbTRWPjuWPF7e3p4SVLqbhJ1ZbLVO/ngWZekeqZcUVpqnk28vCJ4pu9w==", "6d33ff09-a349-4cfe-8cd9-3708506ce0ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "838c1a42-1333-4a5d-9a35-15a653879e83", "AQAAAAIAAYagAAAAEFJ1BAdcReF7hxGuwh/cA541OgiI0C+uScXuEevuTHEmbwGGcYIlVt14x2/omnTA/g==", "2a0fb337-9d95-44dd-a27b-5c6382745f19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3e296258-e06d-47c0-bc7e-35ac91c7defc", "AQAAAAIAAYagAAAAEMLkueZERuKEf+VGCgZIG21/P1Am1C9+sDIXUGcH8oRTavyn6DnGDAkbl37XBPlEbg==", "502bd5cb-8935-4a82-a377-f15b689f5613" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b4c3b20-c1cf-47dc-b55a-6e8a4f04351f", "AQAAAAIAAYagAAAAEMznCkwBVAYg+jaRfK9yXOHMnXoAimRnZeSINL5wAD8qdbaGph048joyh2TwPZ2SUg==", "f12fcedf-f58c-4654-aa0e-c8419efb321e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08e58ac4-2def-47b0-9b9c-9313ceb44bf1", "AQAAAAIAAYagAAAAEOoQJDDtfOpIOwWpoH56IO2D2T/eBr5oxoxGYLTrn7RER/zw+wzycvm3K3PWfMirSw==", "05bf8805-d9a8-445e-a370-d2e5d1712faa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fcacb875-6ccd-4429-8f19-af8fa67f849e", "AQAAAAIAAYagAAAAEM8si06BA7350f7XJElj28HF671YuQx53oc8N0MT/WihIjGivvPN7uxWGuLm9k/Xcg==", "7d706d18-2a07-4c4b-baa4-46d8daf6cb22" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08519e60-01ba-4906-a4ef-92eb8bc99404", "AQAAAAIAAYagAAAAEGblY7S8xq49JjXslMEEFa8CGEFZtMUJtH6V1OxEC24gw8kRDqkuYU2zlkQqfe25QA==", "8553c476-6e46-4ca1-bfc3-480dd1ec4bcb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd1f9b4b-6f33-4f78-a1e6-649b71e78126", "AQAAAAIAAYagAAAAEFxjpZEn8wm2kcZhBuPFoqWug/qNqVqpmjrC+sGhjcrs/MYiWpY6v2/31lWZ+uqsLw==", "791edfa5-4d81-4b69-8971-aeb69a82ebdc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a36e33a5-dbc9-4730-92a9-5a8b8acb495f", "AQAAAAIAAYagAAAAEDRtHFgss05aJUw6EQpM+kn0QykSPwl7WW4RvhIUqeHPCdX1nxleOS7fPUVl8L6w1Q==", "803f24c9-b6db-480b-9fd7-92de0ff0bebc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b47d6277-81f3-4782-9b4d-4d5ba17c0071", "AQAAAAIAAYagAAAAEEQ4c5SF68HkEm4cXaZyJ5QAjVtgaBrz9hYeSmD8KblQIoFv/HykhCJsZLGwaLVpLQ==", "a762bcaa-2fa0-4599-8683-ecc3316fc918" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "204ff083-b914-42eb-9455-4776c7712d0a", "AQAAAAIAAYagAAAAEGxGwv3Ivx7Yv0V7Mn1Yo8GNpTRfdSspOMwYMpKDECrhQE0PL0HOkXpa2smxO1nRpA==", "17c72905-e990-4167-bda1-5056d2cffa40" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f79ab79c-405f-4a9b-9bf6-215cbc332af5", "AQAAAAIAAYagAAAAEOj7azIAvS9+RC2NWicHcfsJOsq5DW0G35+wKWKgckCYl+AqHAO73Oj0fbmg657hOQ==", "b23de04b-cc2a-4853-9282-5ac74c12b761" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3042b4f7-6b36-4e02-bfd1-c922f5e7fc47", "AQAAAAIAAYagAAAAEFz8JpWoDg89myo24b7iTKtkhxTdb1LaLWFqw4E6ptMZWc81pqdtoZSqA5Wp8xy7BQ==", "bd007d4e-12ec-4100-b47f-8f1dc299b0a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86f89d4d-8b6e-4119-81d2-4e50f77f7890", "AQAAAAIAAYagAAAAEM0uAGbi7bqJwN7LdD9gSRdQ0vU1TkidOin1pUX1436oCJ0y+OnM4Zhl79YBu7fZLQ==", "3b1ccfea-f977-4304-a64b-509e60a5decc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8c1274c-6b1e-46bf-b8a2-22b16eb0303f", "AQAAAAIAAYagAAAAEBr1NRIV7gAl23R68SH9IM+Yh+Hbri1ZiaYR7x9kojIh3tvoiBm3Z2YeX+LTa7QnZQ==", "000ef523-c032-4710-9963-9225471875fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6c6408e9-fc65-4245-a35e-32a9298a28c5", "AQAAAAIAAYagAAAAEAcVEH7OX8DYFwYFfk1gZkNRLvV3Q+WHD/TGmk0C0Ra4lbX2aGHlClRrMJNx+2TYqA==", "c8420cc1-01e8-40fc-8eda-5aa330459e36" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1b301c9b-1d84-4956-9dfa-b30a99010fed", "AQAAAAIAAYagAAAAEHVM8BngqkdBWnZNhlqQmiUdozrbgdQ+wePxG2Y4Kuk4kxsXmIuOCJb+/ItbumOtbg==", "b87f28f9-a85f-4f1f-b301-f12323254a6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8f5123fc-f00e-4aa0-ac72-d3e982e01dd6", "AQAAAAIAAYagAAAAEFUcriGLAaqT/Xh19vTM/F0mevzwMHhYI3kUus283V+OzLaqxEjvbSD0ftn/QRO2MA==", "3d590957-6313-4e90-9884-9a07de1d909d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28aa0562-7c39-4f7b-a3e1-b7e40e45e931", "AQAAAAIAAYagAAAAEBhj5rWhSePG5O7SEAFkp8YOXS420y3lXDR7J1bq4/Ful12SUWguBjDfafJNuKV+Fg==", "75bfa862-7bb5-45bd-93fc-25c42bf81260" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ede84583-b05c-45f1-b5e8-3fea2353a9a7", "AQAAAAIAAYagAAAAEO+n181urW5sCMNXMKMCEOeO95HUz5cySDApZ2zwo9o/qXGgMOi7R351sWxfGyrlhg==", "f8626562-5ba2-4495-a4ed-339faa95b0d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0894272b-2d92-42c1-8125-13e2fcf19755", "AQAAAAIAAYagAAAAEAxZFVCieMpytJloD5pIjNy5IPRdRTUf15JztcNjGuWyG7es5mpMGPjBMRQo+jd8hQ==", "3d94f56a-1b2f-4d16-bd34-0bce27bd233e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5574565-89f6-4e85-a72b-80ba4c792125", "AQAAAAIAAYagAAAAEHUo2c91nHkHg9yxpwqSUcsnMF/jawx30D96EwHoJVJaFuXAViIe6Qv3TS+uOgExKQ==", "aa121759-aba3-483b-b8a1-63bfc5955426" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1ad206c7-78f8-4e00-933f-99854b825b72", "AQAAAAIAAYagAAAAEJxtbx2TmtYWv8v/mFUakOfK6f5pbceyddQJNxDs1AfqBG+8/HxHrTFSAwe/yxTU+w==", "6a6f3065-f870-46c3-829e-fe96749460ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9b68abb1-d5c9-4ad7-a4ed-c842993bbf20", "AQAAAAIAAYagAAAAEL33lrD7I/nN5luAiGxU3zB9eJXFkF99oFD5X1/dloAqG3YStbqxWmjNyxvf2o43Cw==", "e1e2434b-91c7-4c7f-8545-0d872a156d14" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "65dc44d9-0c11-4a6a-87db-ca570518a327", "AQAAAAIAAYagAAAAEBnme+yz8aZmim3zvDseAYhAertFhydv1ZgY0EDvGeK2bTaIdUutREXEm+5h+E/BPg==", "ad72c2ca-3db6-4e48-bfa3-301ef1cc4f06" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d7681cec-267d-48b1-9dab-c80e2d0c0e73", "AQAAAAIAAYagAAAAEIig44AFvp45q2Id+yZROCFbcN8bR/htADyOhRqlnz7CpyWcS55p11CfTXtyiT8F7Q==", "fe2bb5b7-4fe8-40d5-941c-47a68e7d0ae9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04a46623-2b1d-474d-8f79-66d3b85dec5d", "AQAAAAIAAYagAAAAEOc7sdBrCDp3RTuTy3e+2BZxOFn1/C0myetyASy+2ltGQAgqHE0mMKsZt3n44y/u5g==", "e09643cf-4705-43c6-b9a3-91dcaccb0857" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8545090d-6b48-4f66-b6fc-3488e285a267", "AQAAAAIAAYagAAAAENRt4ig9ghiv6RSQCtQzPI7sHng7QIuW49NihFknv0T8UQP61UxHGzP4QyS74F6atw==", "25d5061e-c570-4292-98c3-d38cdb9ebc30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3649e647-aa86-4ffe-8dc9-d8790c6f7fea", "AQAAAAIAAYagAAAAEE+/UwzKkcearR0pm15YW14/q1GlHlwt8advSGrmjXfoJ2pjCFNme7r2bAKKlPDDaQ==", "d5081643-f1eb-4e36-bebe-de077c828afb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1aa225d1-4cb1-4e87-940a-873ed8a53c9d", "AQAAAAIAAYagAAAAEGwZXVXUU9rKRREYCvASiyasuw8igVcnZ6y4fci3d+RWqdWD2ZGxjZTyNWvbHc/txQ==", "9ed0780d-7201-4dd2-8b9e-2fa4ae163ec3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9cf3fe7e-c9a2-49c8-8bdd-28d075ad7de0", "AQAAAAIAAYagAAAAEJiv/bYiUF1cpqqp+3mm32YtHuLOiSFRU3iAvSKo0LX7YI3nL7F1xSbeZ+PzPUzkmg==", "4620894a-717e-432e-9114-7b0c6b5c23ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98ee633b-c349-4779-9248-4bf3ad01a570", "AQAAAAIAAYagAAAAEIHDE95R0IJeeLyPLWBUtb49s7MMfSmwWGJMbGiHvnoYOt3CfFXK+KzVuIu6kNHXkg==", "70b44826-d810-4152-98bb-d23a5dc4e21b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b152ca9d-ed1d-44d2-ae19-15844d6b9b60", "AQAAAAIAAYagAAAAEDlugZWLH6b5oyR6tHx8qYUt/C4p5VQgJq63bEhbm28hRfrnbTs45KrbD5G+pQQ/6Q==", "998ddbc5-9493-408a-a23d-d4658eda1ec3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f3ed6d7-73ff-4af5-a28a-d848da12dd63", "AQAAAAIAAYagAAAAEI17cWCnkYOe1U1b2vWkRn7tXtVCIWzNOlGEqFiH7JUqCszdDJyPOZG/BBv899gNdg==", "3abe3d86-6068-4aff-9db6-91955b53008c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c1d7b986-59e7-42fb-ab6c-3545886310db", "AQAAAAIAAYagAAAAEHuz9zDXGPbQUJl/oUWQnn6FJwGAV2AaY0kFqNwqKrQ5OstapLvXnC8nrtvTvKKE9g==", "97be4961-c2f7-435f-aa55-952b39b266d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3cfb7a7e-362d-4c15-8ccc-18e01a33a39d", "AQAAAAIAAYagAAAAEFLYNdNEV2NJTRVdf2SiaxTJ3PGage6hyXjZO1vICOf+NUHgnvsHi05am1Q5+nw0xQ==", "defcda60-0f96-4eab-a479-ec67d3950044" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e01b3049-cbb2-44b2-aa5b-cd77f5b0a2d7", "AQAAAAIAAYagAAAAEOjhAZxf5zJhQH4BABOHcTJQiR0bFv1KA9TjcG83SktFDfzFU6vH3joc4BmkxUU2kQ==", "d11e6603-b1df-4341-8a1e-d63288bc45d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96d5562d-04fb-4efe-88de-68a9d4c01f7e", "AQAAAAIAAYagAAAAEPs1/F+B3kdDVbEQwAG5Mz/zFZp4WSQuQMbw8VdVCPlO5HpwVPrQCf8t2lUvL9iQAw==", "837f0ca8-17a3-4309-bde5-0a953f77cee3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc1f25b5-e8f7-4c69-8694-73b9855fa9cb", "AQAAAAIAAYagAAAAELzaVmDKYa6LQ7ZBXkvvxLvbTxBxKKZ5YMuS8ypnCjfnyy6NB6mu0UAzgJw2an1AWA==", "031cd224-223c-41f7-893b-ee56548b2081" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d8ac4a5e-f4db-44b9-8cf5-b30df404d366", "AQAAAAIAAYagAAAAEOO8l25Gistmo18IOH+KpEpkYwQQiKTLKGkg8MJLyc+NlPyDUAW/D4wb2KY32DjueA==", "d41b52da-340b-47e0-af0a-a331d958c05a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbcc5c40-d89b-4c03-93c8-1d40014432c5", "AQAAAAIAAYagAAAAECJFi/rT0zXNunsSpCNLRb7bBlr6DV4jWNSIYigNrKzTv30Zo+5P44hOf0Fd4wzadw==", "401db88f-b3d2-4628-aaef-6d7e7094a1ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6dc554ce-a670-4c4d-ad65-7594f7034e94", "AQAAAAIAAYagAAAAECY91ybKXL91IiwiaKaTOrzNw52dc9qLvyveA65ElGbguZiuTrz6g0MRT9KTaGnVXQ==", "65e92a90-c14f-4c7f-9cab-1726769bfee7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f3aad21-a38b-4eb2-807d-76a5156540b0", "AQAAAAIAAYagAAAAECAQcfk5GyjGlJA+VSSOTP3/D62Rl0j2OPISswE2N2XmM5q2iWvKh+2TkEHQV0QLCA==", "583759aa-ca83-4358-8b8d-90007b7d3072" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cfa0974-762f-463e-82a8-061c031a967c", "AQAAAAIAAYagAAAAEFrIJFIGDeTLVy6xCcVCI7C7gK5IagD8zla/ysZ4D0mV+CMOwqNyPHGBb2YX0uhrCA==", "91d103fd-69d8-49b6-a1e0-5e5d9748930d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0556a7d-5ffc-41a1-824d-1ae2c85f3e9f", "AQAAAAIAAYagAAAAEAXs2GcIy5QUzVCiNoU1rmQ1JDfxk9SX4XfdKnOVq6nSV8dKFDotu+7tlMQxbyTfGQ==", "81f48be8-6a8c-46e1-88fa-9195004a4e83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7da3047e-f1cf-439f-a852-14a4aa3fbd09", "AQAAAAIAAYagAAAAEJxIGkhReuwhoz5SHUCRGSAFZIQ6KxiS74VyCe+rLGltW/xsQyP11rv7Ur1pRrVfhA==", "fcf75c50-9686-4636-a489-d27a9930c7e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba9d7c30-0b47-4b03-8399-9c5170d5d64b", "AQAAAAIAAYagAAAAEPkypNJj3wAgP92pmLtOQ7MDAJe/O/ttzRBvE6DKeI0D/hbhuWPeQJQmBFOFFdn6cQ==", "738d7979-9da3-4b99-a850-c25a66b24a3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5acf82d5-dae0-40cc-a89e-e2130b23e7d7", "AQAAAAIAAYagAAAAEDBn73vupQ4JWuSICf0UAiUazrJt5v4bSPr0dX8y4GQSQj2r6x0UnH3TK/fWNE4xQw==", "7f668f04-a291-42dd-bf10-b53b88d91694" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "900eb90e-ff29-4de6-87be-56cf77e07e5b", "AQAAAAIAAYagAAAAEDiYK8LLKuyXqpUrbMtzFbMNgOnRjbrkQwVDQ7Q2HNwB6QKL/FrVsqTjHWcZfy9ouA==", "a43fb4f2-c3a9-45ec-8d7c-53b66ab571a3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8df390a-fbcc-494c-b848-e5c838fee989", "AQAAAAIAAYagAAAAED1ejtJdIh7o0iw3uVvNMPq9qHxpWdOfrmZDulstviM2wvgY1IW7IyNyFz6tyERnhg==", "56452018-bde5-479f-a13a-cbefa64ac1d0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2afe7835-9e11-46f4-992d-bd016bd937e6", "AQAAAAIAAYagAAAAEOk8XrXSXoZ+qXR0f023OOnn1epQf+Buvsu7yJ5JPz4mgesyLVIue1O3F+Rin8tGlg==", "800957f8-0b29-47bf-9fb4-3db1e097e81d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a011390b-29e3-487f-a4e7-e4505eeaeeed", "AQAAAAIAAYagAAAAEGMnvK3tDhEJ1agq77Zea1Kll6A9/UHCqSvxXllJPD4Ae5LuCvtmMWvTrV1UBxSVAQ==", "4953c9ce-cc50-4e75-87fa-8a25827b9fc6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aaceb7a8-b2d7-4a63-bc1d-e25b581e600d", "AQAAAAIAAYagAAAAEPpZG+oXdrRBr0PPK4GU5Im1BqBTnn2MJsmMgr7aK4XlHWQahvZ4Zmk4QVlmmrzMGg==", "2b466998-8966-44cd-a99c-e7ece49489da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3ca44731-13fa-49cc-875e-564c1abbf6ab", "AQAAAAIAAYagAAAAEPRkBNE6cHXHSdhRy39AHv7B6MWW2NLIi7FGiqbCI3hlzp6b+2H/QNTd2cvtWZLYdw==", "af6907f2-2832-4f27-8110-693c31b93722" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8ea0abc9-ec94-4856-8d7e-3c05901046ab", "AQAAAAIAAYagAAAAECSwr9rgkQ5ltS3VRTJSk9l7ZFXC/R++2wDOppwS46EvZyyOJkKDk64DhBiYwhXzEg==", "4cdf8bdb-8d19-4b9b-87a6-9c10f836ce10" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b89f8470-3ccf-4c6b-9dfd-0bd91a270103", "AQAAAAIAAYagAAAAEEf+xXAb7C+xhYUm9ubHwJMTADtzrXdboDvAHGdRzxRUMToyWFw/PYnHKNA6ZhDROw==", "3a80f719-5ece-4353-b0f5-f0fd4fab823a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4f924d8f-2b97-4512-bea3-31ad5e003d38", "AQAAAAIAAYagAAAAEFNEM9RXBsdHT8U25eiOSOcS1hTiKvZyNw0CkvwMBrAvWbRTQnJ0dJIxFJxk2JKeAA==", "10c0573f-c1ba-4eb5-8978-89990689f8e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c4b9a1d-bcf6-4ae0-a30f-ebcdf7940033", "AQAAAAIAAYagAAAAEGcYvnuQN23V2GIlQqRAVNHJ0W18PUQTlggVMq9dbJlVep3aAvHVV1gg1Bt+bMH4Xw==", "c2411923-49ea-424e-bd7b-82f172500352" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe7ee9ee-6b3d-43c4-8b13-cf7efcc0e383", "AQAAAAIAAYagAAAAEEpYXc7yAWIOARKQStHqL6etCuYrJXNmpMVN+MnKAYClWj/kB5lBNdBIqE1nseUQiA==", "db5a6220-6691-469a-bc99-d0a91cb671e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2c7b51ca-c1d0-42eb-84ba-d89f4a0d3565", "AQAAAAIAAYagAAAAELk/H3mKaSnNA3ILnJzWEvwlpET/ACEi6Zdohvc7ddADmki+qSuE2XjpgOqvgQ4I9g==", "d05a2968-835b-44f5-ad2e-5a8113d1f461" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9bbc5fab-e7c9-4f54-a2d7-8023620eaedc", "AQAAAAIAAYagAAAAEOe2RR+faeg/2mmxGXKFcXM5rdGkzIxGhUazpmxzWgaESPwLPo48kSlp54buj9JATQ==", "6df01f4f-1b77-4055-a98f-18e0f0f83cca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94b5dcf4-c9a4-4f31-a3d0-289090eb59b3", "AQAAAAIAAYagAAAAELuz8QvFcIFq1pm3emUARpZcmq9CoXi6ZnncDDarqgBjn6372vI11+FZx/+qWO1r4g==", "a41ac63f-cd5d-414e-a39a-094302927737" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2066a329-9518-4bd6-adb0-8e9e907b857b", "AQAAAAIAAYagAAAAEIeiCV2UtxdGQkf7ul6aYE/AYJKSXIJZoxwbrMi559SsPRWojKT+Dyt6w8YaeGY+3A==", "54806e95-41cb-47cc-a950-289691c70868" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0973fa2-35da-4479-b632-e1a60644ab0e", "AQAAAAIAAYagAAAAELj9RTocRcjfyO+gXVsdsDjONERkhkGX/DFLVz+8tJMGg7RWDVWRLZe4lOIj79bzvA==", "20261034-0c0a-4e67-a2e8-e5a56e58db02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d52d9610-422e-4654-9ca3-0ebbee6b090c", "AQAAAAIAAYagAAAAENsWZSAjhgpq70NgCdl6L5dsFcdn5BVWKNNMk3hvt+ZHbFsjBc3gpijvSMbO5NW0gg==", "c995093f-994e-4818-b1f8-64091a300a82" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5d1d0ad-865a-4bef-8694-7e46c21109e8", "AQAAAAIAAYagAAAAEIZiLpOCGa/KW2dLS+XuL0kzQcoH00Wn+TegmJRbdfI7WVk5gyNqX0+FIea2xpqIDw==", "6fee759c-7801-4133-bcfd-fe44ed51ab7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cde2f8f9-6691-49a3-aa47-187cbff54c1a", "AQAAAAIAAYagAAAAEHB+stfYDSk8rXEQsypUqCL0XynB95z4LK7OjLu+OE1DYczy+YIuc1179FMwvHlt9g==", "9574f939-6e27-482d-960f-21befe79fce2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5c7a290-9fbe-4704-b13a-cf5e771ffe9a", "AQAAAAIAAYagAAAAEJ4Nw8CdlxXCz6wDCkFLj8wSegR5KQAwGaObImGyXQxwpbYDndOeuaV2F4bcsJtyKw==", "ef86f65b-0a3a-44af-bb76-e7595f77b3b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "36c89c56-c127-4e12-854d-d1bb96da96b6", "AQAAAAIAAYagAAAAEFp8BchPMJlHa/HFDT4Khk0YXzZX2anKkeVSU5LTKBOP0Nym1qlieiyNtzpMVs6UYw==", "e1e67a16-88e1-489b-9359-f4dbf31e67eb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff6f07bc-51bf-4bd4-a2fb-0403803cf696", "AQAAAAIAAYagAAAAENIyQBmqqrXGo5ivQPBlnMQunXgjbcawhzWIHUfFwt7tdsv7O3un7J+zHpGm2NAhaA==", "5f6bf538-6e12-4b0c-a528-894b756386db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e07c6c2-2ad6-4bd7-95c1-781be0fbdee6", "AQAAAAIAAYagAAAAEBcGXgXv+tY9kvsWyQIglidb542nVsYztiA3FNolxNCNfTHSiklvsdjiz5PqmGe4BQ==", "27d9dba4-0aef-464b-97e5-999702cc5821" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21878d0a-b57b-40e1-b3bc-6c465bcf6096", "AQAAAAIAAYagAAAAEOO0UeCku18vQIEJPVNpediRet5hvzyzBvkuz4u99TMcW404tHGSV9ZDzA3uaFxziw==", "76005c11-16a5-41e6-bfac-3079ef21f627" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6df5a33-5750-4800-b364-c633340791ce", "AQAAAAIAAYagAAAAEOs27GfPzexEAEyiG1tlg1txUoR5mn0ybWXGvgKWDqCIIsk1fkGj61KYWWiN3HniJA==", "fb2b5590-91c0-4a7f-8fcc-ff4c84baefa8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e0a13bd0-5d61-42f8-b12a-2db420a62d43", "AQAAAAIAAYagAAAAEDgD6GMi5P+isUMogC9HvXQRLdzm1OySYrt7JfaxUapQakz8DcdPXqGHgAtHqHPYcw==", "fc08b537-a65e-41e7-b0be-b5b7734628a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79198daf-47cf-41a4-9909-9068777f417f", "AQAAAAIAAYagAAAAECmLTtistpsZk1S3rSy02MQRawD+wkv4rMTEN1VO+RqEjEjfDSXECLwPmA/YCmTuqA==", "f8e46c60-918a-4160-9cd1-e399dd22be47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fc3aac88-a3df-4388-8ef0-ea74001d7998", "AQAAAAIAAYagAAAAECWjTVdUKcfcI1prx9b5L60XzgEP6Inehmz1Br0vELgzU4QqWB75IZ0D/eWXQHgBcQ==", "7ce4836c-48d3-4d80-9950-63acbc7bb7ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a03d4f4c-b6ac-4dc0-b0eb-6b6381e6021c", "AQAAAAIAAYagAAAAEOMlYqfCeNcHisPBgMrl4HFGn6WI6fLrSGVA8DkxVtEH+rHJ7oElu8qaKRNYD0FEMQ==", "d75e023f-8d1c-44d7-a220-76250833ceca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "35dadc6f-1bdd-4ed2-a908-fc9da06ac3ae", "AQAAAAIAAYagAAAAEAChaAontsXOtHXbceyHKEtrgV0L0t4c3RiBXs68qAxJdxjPDdTGDtyPU9faz1H/tQ==", "6e30014f-d1f4-4d26-952a-4f4233fe4ade" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "571d2b3d-8b1c-4b96-9ee2-2a9a64ce3d82", "AQAAAAIAAYagAAAAENljvjghUtaTdikBrnhXwBMp1hZd1uihdxaDobGo0EF4y6vvQHqrQQfNP6ECY+qQgg==", "4b0d6996-7a13-4081-86c4-dd64f51f5705" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "88702f45-c7b1-4347-883b-55c205a0a059", "AQAAAAIAAYagAAAAELuq3ZPfH1PxXqSF82pTkmupOR717uZFnWHSlceP7NTBZ/Oezn6Q2ZGWQu4lSfo3AA==", "c3eab822-e230-4ded-a61e-35975792d59f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50fdb210-9a71-4855-89f7-42f91308f3a0", "AQAAAAIAAYagAAAAED4LUg3jxC3kXmDb1g/ZZ/S6IlYorVkz0uSUUX5dBDcUTMaZcSvMIjdkC6rO3ezqiQ==", "08275e7e-b36d-482c-8af8-6739a6cb9918" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d219f744-ba84-4089-af17-ea9d4b27a618", "AQAAAAIAAYagAAAAEK+dlOxegJ484FwMu2ntMr9jqOic0atcc9emI9HYDm5JaJI4XXmCBxLGcslB6W6JlQ==", "7b1c833b-17c1-4118-a841-737693ca8b90" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9648b96-c583-4d14-a702-6fa09f7cf4bb", "AQAAAAIAAYagAAAAEOzTUHXBWMfHdOsAScocDntjpvq3s41kKp0wnW1x7cl9IhmpzlL/e19qPgAwLDSRDg==", "33dea8e4-ecba-4b82-8158-3383e4c65bed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b21543c7-7a97-4b17-9ff1-672c09c90d8f", "AQAAAAIAAYagAAAAELiGh+KW0LXWy3iqDY98tDk+23FoLPSEWJiJpJgwpR8Hafv//qCuP+JLVZyhLwNS4g==", "719931dc-3eb2-4e0a-9dc4-10b7c7fa70f8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f596ad80-10a5-4cb5-8dc4-24608c6c3cfa", "AQAAAAIAAYagAAAAELHjnnlOGjrnGYBbTDLaA4OonlZySAb4D50JBr0BnkOwj1SxPU4ntB/xoAgdKY1mxg==", "1dbcc728-61cd-4377-ae44-d0a80df63dd4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "124c6b06-1915-473b-9b9f-f8aa9a199789", "AQAAAAIAAYagAAAAEJvRqrmD28P1rLxgwdHImMtJoNwxyupGMNmCqmO3yzIwJ6oztcs2i0t4F2AZaOyKvg==", "373ffe2c-7bb4-45ab-84e4-12a22eff2ce4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e24a0b31-3659-47f6-aa05-bfc4ca7366cf", "AQAAAAIAAYagAAAAEOAT1p5UtkCc1CO00Kr7hEC3+kkYrwouvYH6toNYRSLYae1P51reFFviJpXcoLNKeg==", "66cdff72-39ed-4402-8d30-a172fbb815db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "84f2420b-1f09-4812-be6c-f385a6217cbc", "AQAAAAIAAYagAAAAEK4njfDjSYfzu48qeCvGDZCAH4EeOYKBGHu5mRq+C3iWgA6Bi7RzU0CIFoJJvTsgYw==", "57353ac0-e1b2-4ffd-b03b-91c1c458406e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d0a1523-8827-417b-91f4-543762c93c0c", "AQAAAAIAAYagAAAAEEI/62wklW2Y8L7yOAKeXDKdDMpC0+KVGtoA312FSxObJDX0m8VFbfVEd3XHejUxfA==", "307d6827-89e2-4862-af18-e094b323b0aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30f7784b-331b-4a1f-abea-35eac7079c2f", "AQAAAAIAAYagAAAAEMGaafA5tQ1g8bW74sDifJHqKjxFJfQ7RqL5nbK7iNQxPirZoz4ItplpRA42UHgNlA==", "f1f9f8a2-d755-40ee-8795-afdd1b6b3c9d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a680271-9e15-4233-a93b-16bac88c079b", "AQAAAAIAAYagAAAAEKgXTKbWhygxwxnlhXd79EB9LZmrMtKr9sCZeGFBXXwv15fqmr8spNgR0c1cW3lUUg==", "a197f9cf-5a05-45e2-ab73-f1479e939970" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bef5360d-367e-40c6-ab2e-3b1bb2ebec46", "AQAAAAIAAYagAAAAEOitOr/wN0M8ZbHM7syiJQWn6YkW4hvTi0EPF51SQcZWno/FO4+JSafI4Kn1wKs76g==", "8ab4a75f-0825-466d-98cb-ce21ff6d6b08" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a617785-44ab-4c93-98c4-1afa4b346b45", "AQAAAAIAAYagAAAAEOnq72tHDwo60+X9O6SkdcdGtFDk7A482eOieXDn/YTuUWg+9/dAN2IVfxdaVsEs6Q==", "2c5c1508-7083-4c90-afcc-6c01d9f11cbb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28c195fb-9e13-44ca-8883-e4ac02609e3b", "AQAAAAIAAYagAAAAECdbRy8VubaDg2K7LhY7JlrQf79WyPWUm9CGY09yzhrAbnQ5kRyVDOtkUwVqOQaT/A==", "066f6006-89ba-48d3-8003-3dbf275e1647" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "844867c8-448c-41b6-910c-e512fde4e68f", "AQAAAAIAAYagAAAAEPrMNj5g+7xD4o6Z5jl5inTUnHatHw65IKIqrPEX8FBzHTvO9Xe+umEDBqZ81khTHw==", "8c661e1f-1fa7-4287-a851-3ad2eaf6f62f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70b20bd1-60ec-4d41-8982-5ee39d6a1a58", "AQAAAAIAAYagAAAAEKWQpnaEw3XKmeS5egkc/zR7+2j+X3El8uB+f49YZgysPwqFg+7Z5enTvmcCOuvVDw==", "c26dfffa-aeab-4cf8-832e-8a382aaea55c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64581bc8-1512-45f4-af52-ae220cbc600b", "AQAAAAIAAYagAAAAEPkH38KQRxClWNh6HkRgR8hlH5RTluEqOyklT6sNYbv90ZMXwy5TrZz0p4d1mK7mZg==", "b8d7d07f-5540-4a92-b400-15c89f520f47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4afb8e4d-d03a-4e6e-8c5b-1fd94b10e999", "AQAAAAIAAYagAAAAEApL6KwWPSvp0TXsUIZT+o2Dx5efy+WbxjyRMRYyDzMWDYlsq68b49TEpVE2UQlgwQ==", "41df6524-341b-4e82-8ec2-d70e0667b4a2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1474c5a4-0c18-4722-b254-ab6b16f9a60d", "AQAAAAIAAYagAAAAEDJAX3raerHDHSTbNWZLHJVIgl+064rDyCwH5Vsivw5blboVXk1EggoRT1ilt2venw==", "4cd9a041-5f5b-4b06-9bf3-f2e368acff89" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52bd0c7d-188a-4856-9046-e71f155df015", "AQAAAAIAAYagAAAAEEF0siwQnDAF8oIRJWpEhB+ZJ5uh9AC/UfczsQh/ZcpnwxTwtZoGc491uhDMWjO5FA==", "c4309260-e7b2-44e5-a75d-a443631e49b1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d8135815-f480-4c06-9e7d-56a0ffad1bed", "AQAAAAIAAYagAAAAEOP1JXKaS67tyQSgzIAaGDmfvqKOuPCuCLOTlmQY7WtR45+PKjLNa6U/HKQGETCiuA==", "715c8b78-a8d1-4fb6-85bb-bb9c0b97d594" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08dfaab7-014a-474e-a967-b809dffc896c", "AQAAAAIAAYagAAAAEOjzpU2mVmw4MR8xtBhTVIPZxT4CfgvssBBsZfnF6VD7rKizi7omEu8T9t1O+iVFXA==", "bd4c7482-e20e-40cc-bdf9-f86137ea88e3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "03430248-2fce-44b3-83a1-2f05dd769f1b", "AQAAAAIAAYagAAAAEEjUcm4SHoc3AbwO+5iAhjW9vJFxbWtFMQihFRvs8duSVpjv1SZPKtmIi98gk2/9Gg==", "9a90e7b4-b445-4e09-b5ad-4bfc14ac2a91" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1eabc98-4b18-49a7-8152-b626f8a1f666", "AQAAAAIAAYagAAAAEOWv/ZJxl6J6GM9Ha8mdpE2C0GjDH1AZl5M7XLHW99XlgXEPeNrcmbuvSsntBObOWg==", "0a6e531d-4b62-4787-8a90-cb451bf41e20" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2d44a5ba-a08d-4f17-890e-73c476c28c33", "AQAAAAIAAYagAAAAEHRnA55dIz8C4SvwLqaG4Ul+X5G0/OHzkYgEXDcAFwgVzUZcFwB1fW1Z37rLhAy42A==", "4834611d-7cf5-455d-8eef-bfba022b6ca4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2770d8e-c318-4e82-acf7-4fa6950008f9", "AQAAAAIAAYagAAAAEGSt9ghBL7zXayVR2StjxX4W6IUJy8t7cxk854TFaYwR32rH/gVC4doKJ4218QwdIA==", "318b7e6b-86a8-4411-9031-d76092712e29" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b46a12d-9b08-4bc5-b4e2-25b547a04bfe", "AQAAAAIAAYagAAAAEIScZv/6+s0ql6H5Tlo5pC9SxZbKmvLvv8kMGpery7XnDW2rycwJbGS06lH33MCQlQ==", "a965df51-d507-4175-b4af-6d54c6332e4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ac19a0d6-6d25-4679-b38d-c40b75dd3a87", "AQAAAAIAAYagAAAAEJc69g9vsX9vPCJ14X7RPjz5l9TRTCaXzPMAYb5J5EYGFHJexT5FG0nbNmopcGTFEg==", "ab8c4dc3-811d-4d2c-9b45-1e18a850a5d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8fa41b1-e729-486e-beb7-8840457275d5", "AQAAAAIAAYagAAAAEDQp2jXrnfFKC1TjtodzBdhTNDjLxQdXp4eL3T7s2+QRezYczmmcYYiXusUxYwijgA==", "1e701af1-5eba-4a53-a70b-317511935871" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cafb2bd4-f248-4b11-a524-ddd63779021b", "AQAAAAIAAYagAAAAEEFRcsolZv+hfQXTyrdrc5GdB1z3KV2N1z2VF9FFgNaGl+BgqQEmlOA1nY6aeNLPKw==", "574d8372-8b79-4419-a8bd-8ed21fae33d1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "45fba573-1680-42f9-8f80-cc27f95e4cff", "AQAAAAIAAYagAAAAEGSVkUCpgr24WNpqYesgJKLmQc3M5u+i7wOsbDP7H7CB8MnWBlsLg9uKx32W4IeQ1A==", "bbfa94ce-e7df-48a0-8438-570636d07908" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "133caad3-7409-4472-90f7-a9cc15eb4336", "AQAAAAIAAYagAAAAEO+AYqRSqEyQtDYr61k6uw1q8jcy/0mM9q4/YTMu/6NTU5nFBHrcSg7Y41r7Je0W0g==", "eafb7fb1-1f79-4e17-bd9b-1b241ed6e83a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e2efb0ed-75ab-4f51-921d-e5d28cfc4b7b", "AQAAAAIAAYagAAAAEKt4saFmqIVnjHUJybi6pzugHo0Cq6X2vcwXhTJhQqvWdsOVM/yxJaJXYqoaSGYZUA==", "840bf32c-f330-4170-8c85-0389833fac3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "15298afd-fb01-4374-bfce-7b7fe9834007", "AQAAAAIAAYagAAAAEHzF/VVhELnANhfjUE4cCK/X42nDG8thbr0zalh9ktMIGyBIXBZX4b+zpNdrp09Lbg==", "2ea2f10a-ca54-4fa5-bb02-a616814ca89e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "703758cb-55ef-4194-bc2e-c37753368306", "AQAAAAIAAYagAAAAEP5ZbZd6IciNphkO8hFSCXwItc+lsNjfsYumbMqEiWlWgGRriSVfBoNlPNU/1/QHEQ==", "44e0c567-23ed-4724-a76f-2774eb4639a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e49e3fc-162f-40d6-ae8f-5017d19c81be", "AQAAAAIAAYagAAAAEHxG8HQnAExqkewgsZ22ebkf5k1Kvw/rZCCuVaQX3lWkanm1Lavs2NJnSNZr6G93bw==", "18938669-17f4-4c5e-9788-158f86c03054" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17970524-1d1a-44e1-b59c-633c8c2faf68", "AQAAAAIAAYagAAAAEBCKy9C0O1o75yShtlwOiEzOkKYj57HdcSx7w9vejNFZdgdLkti+zh3JnBaPSpFzEg==", "3d61db11-98e1-49f5-89f2-d2abcb02fe1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c8a0e485-fad0-40f7-8a34-6e71948ff9ff", "AQAAAAIAAYagAAAAEArYL02LGsQexCRuf557/43HpwhcDEJBrKF4S6eCbo2ZmD0TyS5GxexR3KzzHZnbOw==", "ae3fefa6-8824-48e6-9826-6e858f376151" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5669a68-5bd7-4da3-9e57-b9a1da843fed", "AQAAAAIAAYagAAAAEPQmfGjlJMhiqhLnJdAZcECVRu26FNzfHPWiRxv7eGnaVoYd4pKWre5WvFnZWZeOZw==", "dbb80490-0e0e-495d-abf1-9b4868d254a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "276b56b0-be22-4619-b2c8-b6dcada0bab0", "AQAAAAIAAYagAAAAEMkVmMIDEKKizMB49212ASVC3pv6cnN8u5kUZkrP6PdHHG/uKG2J1a1oFfG5iRDoRA==", "7258e8c0-51ce-44de-ab1b-2448f6fe90bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbc113ab-6edc-4e50-8f06-105d6b6a767d", "AQAAAAIAAYagAAAAELaUDr/91MVcZ8tcqggAmnYM1gxpdOEdzDh3KK5rbC3uzbvYWD5fDXS3an0ewOglnA==", "eb973e12-e573-4d74-ad24-36e834ac87e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d87e60c-41b3-42ff-8abf-c6c877783b07", "AQAAAAIAAYagAAAAEF9Zc1ZGPbIbzg+LQvtoe07nvz+zmZXiwor+J+UGRQmByxrcahIXo5QM+q+YEc9rcQ==", "05205cd1-d8cc-4a9a-85e7-f540de504eea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5fba3bdf-97f6-41c1-8536-a8f0f1dee441", "AQAAAAIAAYagAAAAEP34vwNOFSZxAEyBYoHxY19fFvO/zF89vgEHTCNsVvx9Z108eakaeAn7OiGNCbKSrA==", "8baaf915-e4d3-431e-a102-a07f82ceac39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93a445f3-6865-4245-8dd7-2e0e916a8715", "AQAAAAIAAYagAAAAEHhbnQA4pauoE7pYBqV54nhmLmhquCh+djJ/hVwDXcduLMGvjYD4nfSoQLwluPxYvw==", "6997c956-7379-4bc6-9295-304b5a919a95" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f7b66a0-2cee-46c6-8487-39512ffde72e", "AQAAAAIAAYagAAAAEIar5W81utzjdiXpe57KqsUlF7mvKcJ+Frd9LyCndbIWAUv4CPPp7qCo/1efjkFjDA==", "b62f15ce-7b3e-4202-9eea-4de8b96b4092" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2f77cd37-c009-4452-b7f7-8779f50e1823", "AQAAAAIAAYagAAAAEFUj0vhUZvib47pkSRA5+vdfmIIYsrzQSj7Fz1ATeGabwxVRQCT4dHw9Q8kH/WAzKQ==", "898fe634-0099-44fe-9f79-0c09bdaa7736" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "26cf7297-05fe-4b5c-ac60-661dec13e33b", "AQAAAAIAAYagAAAAEGi1nzh9WBi2bcPaJYjT/k4j0W3qUM7OI01rt4W4hufUgjE1G2FCPAwJcJBzVI1mPw==", "8f0d3973-6d30-414b-aa28-fa2896eb69be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af911d41-5647-4dff-bf47-80d2ba8628b3", "AQAAAAIAAYagAAAAEEZG/FoPERrCmwGZcgmreTmUsDIUmNG9Wu1gXPQknTgJLdgtpVbJBfu1jbNExMUofw==", "82286ac9-4fa9-49bd-a919-9cfcfb6aa8db" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59d9dc85-c492-4a95-bd3e-3d3eadecfc30", "AQAAAAIAAYagAAAAEJG1x00mwXF8JCWwB2TMhQvxXEDqu2yf7oc+X8Ut+Xk7nh09GfNGpWsgXxztRVYAyQ==", "225a1713-a50b-48ae-b4a7-2f44d87144d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04909d4d-61ea-4475-bfd7-1a1f73c85797", "AQAAAAIAAYagAAAAEI3mPsNKCYnegWURDelVaz/WsIaQdwl39jjbhz9c1xJuQv4GGUH3DHketTVh0bZbJg==", "051e031c-08eb-424e-bbfc-e14fd097a5d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8eaa0759-0704-4f10-b0a0-3b536a57d7bb", "AQAAAAIAAYagAAAAEPL0a92gdcZsqGEmtFkYVvRkmib1kfBNP4llzYqPLLixUJS4o7U5J4wKZ99FT/Jxjw==", "0c344306-8982-4d5e-9f06-b80d7cafd093" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40c7fa8e-39c1-4421-96c6-529fe4466c29", "AQAAAAIAAYagAAAAEN4jiG1Rcycvhze2iMXOcvrWKE7D9fLdKxm4l9qT1Wad1a6P9AcnJf41qbsduEgdIg==", "c43945e3-4a0e-4597-a52a-14d12b08260a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2ab2986f-0d20-4cd1-b9e2-824632a75235", "AQAAAAIAAYagAAAAEH/vdQrkUvFC/bgSl520Fy2PBz96K0abPxjlhWeUC4DxI5mNUvoZOZGzUADwu+L3dw==", "9bc2d84d-df90-4576-8519-36b78e884481" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9cf1240f-cd40-4903-96d8-325a40a99cbb", "AQAAAAIAAYagAAAAEGl7rOGA5S4PxXwICwBIJgL2V9UG9ZhNjXFcM/XMg/G32E1tJmBDgJncyIufijt26A==", "1c12cdb5-f6df-4898-91da-8e07a59fbc26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4aa7c1be-ea43-4589-9730-3a5fe4dfdc00", "AQAAAAIAAYagAAAAEDSOeoqkg3Nbxl+3MQN/t3ixZOBn55FztPQ+TXVmNLra0qqgh1Z/iHO2TnQGry+Dxw==", "eba6f664-7bfc-4901-83f1-6f1a7170f361" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52055b0e-ddfc-4970-a00a-eb81c2a3f772", "AQAAAAIAAYagAAAAEDG1IAsM9RoPLE+6BWFyDO2qCSQfdb+4RhS9Qza5WpryQ0+JzfCl62MP2xtPxGNRRQ==", "38301d72-cb3b-480d-893a-fa85cc92c27e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad7f21fd-aa06-4eea-83a0-613c67ad3b52", "AQAAAAIAAYagAAAAELzlW99Kw9VeKg8ppmS+Sb72NCjl+kfMhf/fufqeG8F83WKf8zLDeVZx5dl8VEQ4BQ==", "184c03c9-637e-447a-bbff-f02d3f5cba1d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "119b3963-8139-4339-9b71-a0c4a30e71c6", "AQAAAAIAAYagAAAAECddGGWVRb+BZdq6ZHPZuOozPz469wCyXloDRrIM1QVYdme6Afz4kTyLxFUmkKxECw==", "a9b6f91f-d1ab-4822-9cf6-447b99856765" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a94665e-9fd1-4407-b4de-3e778af599cc", "AQAAAAIAAYagAAAAEIntynwcumqh0ly6d3GmFby1IV0DoBIDyRiGNMwds1oIgFbwaVlrUxA8FkExS9oQAg==", "aff3cc07-727a-407a-b550-2e73403b55b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b29b7ddc-9a49-4a60-8f33-837c56c2ffec", "AQAAAAIAAYagAAAAEFkVzgf29Ub8pJtSSEctVqejZNKwE/SK7cy/+yvte8MqnDbjxFd6xvU5bTMp+hCwmA==", "4901ba9e-5ac6-4063-bc02-32cab1691f41" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d95e450-c136-424e-9c21-97e51ba4121f", "AQAAAAIAAYagAAAAEKc+IhkxWZNZreb82H5FhxaGQpNyyNJet6DudjSon/ZUSy7zDdfF63ciSXaCldnxnQ==", "e71fe4f7-ee2a-42ae-acc8-86918021812d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6c859f5-603f-44e4-af37-74c547a6239c", "AQAAAAIAAYagAAAAEKHlGF08l+WtD21JcNeEfHhhoAzNL6K5/+GrnQUirNpmCj9pvC+OrAY504rqunvsYQ==", "f7cb7bcb-b218-4217-94b1-79c8ab952204" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95933051-bb31-4adf-8d14-1d66d2507d6c", "AQAAAAIAAYagAAAAEBgp9hDjiySftDhvOvFnyStC9K7CsQe00qi04V+82y9KQjWt2G0hdD2W16P47OiBaA==", "ce3cf6e7-88d2-4576-b5c7-e0a4eef01157" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1af004aa-e562-4bea-ad43-c2dd95a29fed", "AQAAAAIAAYagAAAAEORFwxGOJDOjVK5eBoO0gH8hG+K1jOdP8s+fyNQAPdb2NAPlO9Aa//NA7SCLrP1PNw==", "c8a2841b-221d-4752-a131-853f873a19ad" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b838ed01-733f-4100-a195-52e80c47e7c7", "AQAAAAIAAYagAAAAED0sjj2JcFIsCHdFE66OedcZTeaHuwh50RyzfVgE+bj8WBwRM+hgZup/J5sVKIqv6Q==", "1944ee7e-40ad-4bd6-8ca4-6cb7eb1e6463" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3d53c121-9082-4eeb-97a9-94a72f5c7387", "AQAAAAIAAYagAAAAENqcwJKyh60XWMhxyWxR86unPEZyVYC1MzAfkiHOGqKGzV6oESObgPtXrbw2zHKFug==", "fa530711-aec3-4704-913d-599808dbdc46" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db7b227b-f848-4066-bd38-5e3d0b813097", "AQAAAAIAAYagAAAAEBtOp1EOiFU5OgCaM2k2mPGOMtwVhH1PMSN1DdqQ66P+aybUVF39lxHx7aJ5rmvLRA==", "44fe76fe-89b7-4a4a-a5e5-0fedf0a0dd87" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7a3fbfe-a031-417a-902d-1b31a57332c5", "AQAAAAIAAYagAAAAELyEuHBkI5oSU8MZ98U63dZYkwHawIBvx0JHKatXg1Iftq9mEpx7bk5KD7TAVC8hUA==", "f4ea8ae7-9079-447e-8686-946c31126a2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6088a549-7f0a-4bec-85b0-73440daf14f1", "AQAAAAIAAYagAAAAEKpRe4fgy5JLSL20gA2s6Z+Crfc6a/Fof0ap8DsGeqKxOk8lHuU1ts1ixemwbKmy2A==", "3b4eaeba-dcdb-46fa-b420-87671ec9a38c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "07d0b905-aa50-4367-a6d9-323063985e33", "AQAAAAIAAYagAAAAEA8yXtxrxCfhaEpjG/YRdD96CZL6kCZYFR4oLK3KgAyB0vwC/Ou6V6Z9CrHV9qrfPA==", "53f6cb05-b898-449b-a420-69e44e3c0ba6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2720a73d-60ef-4643-9786-87e54ba8f934", "AQAAAAIAAYagAAAAEHKYfTw+eA+RhYZac3nGIaypFr7d3BMORH4UUNzyox4a36Xszr12H6jEVb+JS6c1Vw==", "8308950b-62e3-4878-86c1-4d858bd7ceb2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0173a09e-6486-44fd-8a28-8be1b7d62531", "AQAAAAIAAYagAAAAEE0bnvfIvixUUhT93Lq6blEOhbilbiGQjn58IJ0LAqhXHgeSpYsfjafTiyTt6oKugA==", "df574e6c-21dd-49c9-99f3-c20edd6c58d3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21b68668-1861-42fd-a10b-d336d2fd9dcc", "AQAAAAIAAYagAAAAENGjGoHpK6k3CO3d3UB4eidZE9NGl7/HfUvYv4l96L5xCxkXnnXIl+49jcyQXDQTHQ==", "3376920b-d904-4c4b-b8ec-b3caa935a28e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81391a44-70e8-49a6-9dda-bd5d93040045", "AQAAAAIAAYagAAAAEIQNcrdv9nuA0lR7PG29B3qLhwD1MoRRIS9izuFdHGVStiQbOWz1vi7Vc37C+8S6QA==", "05394f34-93bc-4f39-bc3f-d136195b5f54" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditSchedules_AuditorTeamsId",
                table: "AuditSchedules",
                column: "AuditorTeamsId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditScheduleDetails",
                column: "AuditPlanEntryId",
                principalTable: "AuditPlanEntries",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules",
                column: "AuditorTeamsId",
                principalTable: "AuditorTeams",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AuditScheduleDetails_AuditPlanEntries_AuditPlanEntryId",
                table: "AuditScheduleDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_AuditSchedules_AuditorTeams_AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropIndex(
                name: "IX_AuditSchedules_AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "AuditorTeamsId",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "Purpose",
                table: "AuditSchedules");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "AuditableOffices");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "AuditableOffices");

            migrationBuilder.DropColumn(
                name: "RowVersion",
                table: "AuditableOffices");

            migrationBuilder.RenameColumn(
                name: "AuditPlanEntryId",
                table: "AuditScheduleDetails",
                newName: "TeamId");

            migrationBuilder.RenameIndex(
                name: "IX_AuditScheduleDetails_AuditPlanEntryId",
                table: "AuditScheduleDetails",
                newName: "IX_AuditScheduleDetails_TeamId");

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDate",
                table: "AuditSchedules",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDate",
                table: "AuditSchedules",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDateTime",
                table: "AuditScheduleDetails",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<int>(
                name: "OfficeId",
                table: "AuditScheduleDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "StartDateTime",
                table: "AuditScheduleDetails",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "d3023c0d-0274-4af8-b9d5-bb5309cff08f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "2a6f5c90-1d3b-4e8f-9c42-7b1e5d0a83c2",
                column: "ConcurrencyStamp",
                value: "aea4ca6c-d102-40d2-934a-91648819d1e6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "3e1b5f2c-9d8a-4a07-8c64-fb2e9d7a1c50",
                column: "ConcurrencyStamp",
                value: "b2616e91-ca2a-48db-8660-a84033e79600");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "4c1c9c2e-9e2b-4c88-8a94-6a7d3e4c5a01",
                column: "ConcurrencyStamp",
                value: "7588ab5e-a046-439d-90a9-0e2c0a528eb0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "0a60f39e-e387-44a3-82a7-379b0c6dba17");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5c2e8b9f-6a1d-4e73-9f0b-1c7a4d3e8b52",
                column: "ConcurrencyStamp",
                value: "ceef8785-20d0-41f3-8cdc-f12f5203eba9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "5ef7f4d6-712b-4a7c-94d0-cc0fc6a16f88",
                column: "ConcurrencyStamp",
                value: "a0d80449-dd4e-4cab-a8db-a0da807d4406");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "6b7f1c2e-8a4d-4f90-9e53-0d3a5c2b718f",
                column: "ConcurrencyStamp",
                value: "c8c76c89-bbdc-4c62-8096-00fef1551b27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "7d8b0f3c-4a6e-4f9b-8c21-2e5a1d7b90f3",
                column: "ConcurrencyStamp",
                value: "36e215af-d160-4dd9-90e8-117c7e5e8b31");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "59c0d2bc-6e02-4597-a270-2e5b4e2d9d71");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "d23a4570-258c-47f1-829d-d3c4f37a5fe7");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "9b7d2e11-6c3a-4f2e-a1d8-0f7c4b2e91a4",
                column: "ConcurrencyStamp",
                value: "dc259e8b-6ec3-4cd0-bca0-4ae556b1ba7f");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "d3f28fad-4ee6-4051-b7da-db560711546b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "a9a10abb-e04a-4d7f-9bd5-67aa995247b4");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "120c01f0-5350-42ad-bd4f-919f84ed57f9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "1f9de3ee-9409-4a64-b54d-1182aee8349c");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e3f7a4c1-5b29-4a8e-9d10-8c6e2f91b4a7",
                column: "ConcurrencyStamp",
                value: "449955a4-f2ee-497a-9614-58dd3dd6ba58");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f0a8d2c7-1e9b-4c5a-8f63-7b4e2d9c1a30",
                column: "ConcurrencyStamp",
                value: "29684f36-9d6e-46f0-a906-51595ed2015a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "73c0c6cf-d088-40d3-a6c6-88be0907eb53");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0020lEhG-NkaH-jB19f-9uh12-11dFwnTe6543",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6869e4e4-6228-49d6-941c-fc71720a674d", "AQAAAAIAAYagAAAAELefsb4zFkD14ab8bTscum3tB8usQ5Fw3/WR5Y8+U/ChgcdZ5T4Zwmxap/VCeua/hQ==", "cd5d480d-66d1-4600-892a-23c89d924e00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0201JEhG-NkaH-jB19f-9uh12-22GYwrTr9872",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de647876-79ee-43fd-8b90-e6cbbc411b7d", "AQAAAAIAAYagAAAAECrUnZGwRuqnYq0DEdP+I8/g6kqjNQNqGap6/VIEdlD+DxEO2J8uhhSDEaB5SN4SEQ==", "5c613b10-a7a5-4dac-a068-14721b8d123a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed6161e8-b555-4a13-b943-5cd24e7c4fc3", "AQAAAAIAAYagAAAAEC9Jrt7gDiCAEvN9OokZZhNPda9ldLGmrVNAjdzt0JPHgZODyrhubnRWqxtj5XCSsg==", "84df8980-3cfb-4fec-b8bc-06d59db1ba2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5fa9753e-08d7-40c3-ab20-7c68edaa1194", "AQAAAAIAAYagAAAAEDIMV2SXh3vt2StKZc9y13ZpsT1/fJSRjL7ANet70xDGqE60vlbjUcYOgPceAw5fiA==", "94f1ccdd-0ea0-430d-a594-48eae647ee42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08f608af-0608-4cf5-b2ef-b419b016b87e", "AQAAAAIAAYagAAAAECZ08IBl0d1ztsT86ZesoDZ0avgJVz+jCnYUR5C7G1HqB9CYko+VHIXFfBg315TwCA==", "18a72a42-a058-4712-be1c-e7020b4bd8d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0b8ca2a-14f4-4ef9-83a3-193b5973d218", "AQAAAAIAAYagAAAAEG1IPyzo2ik3KJO0JF0jky49clMYATbp7h7Eo8QoTerwCE9WCbI/QgAfCoV7hhQK9Q==", "55d28cd0-adae-4ad6-bc9a-34680334f4c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3bac9163-c531-444e-b23a-4f4ff4572989", "AQAAAAIAAYagAAAAEHWeLuB5yPTRfgo+Jqg9DCT3eAnNrVPCbLXNeg2Far9GfoN+bM+XBXoV0517TEJ7QA==", "afe82488-4bce-411d-b76c-cc55739026ee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c44c505d-dc9a-4779-8463-1c1ed2887cf0", "AQAAAAIAAYagAAAAECrCAPENLTo1I8lzgp3Qgx+zNB+OGSuS2UE57bON/jvEbGRgwENR92SMbbSCUacrXg==", "5c1b576f-078e-475d-9bcd-3aa39e28f894" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "964389b0-c0d2-486d-9ead-35c9e07721ef", "AQAAAAIAAYagAAAAEMouyQJWMLvQkGDppi4aZeANqr1HuOLNDcCkfd+DAogp4ZIzeYK7EwRxSKsLGR+jwA==", "65563f1a-e270-4c3f-a684-28c84ba852be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "123rliom-2akV-cl381-uwe9-kah8h3f98632",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bb45006f-d389-464b-909d-347acf64a8df", "AQAAAAIAAYagAAAAELm5J4CyhLFHRDfO21Tb2jYi1ci444QpFtBp31OfvOlX8qJByKXYexwar5yBPCqrWA==", "bca8aa32-9be9-4746-be7c-c9c3a8a69787" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e8580246-ff3b-49bf-b320-4be1184c8584", "AQAAAAIAAYagAAAAELqfduomem44IhO6y7OeqLYlZMvM+ChdYAUviTKf75d6aZwyUZiKYwEpaaJiarjlbA==", "af44e551-9320-4efe-963c-7cada0d6ea6a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d6e0e7f0-7ddc-43b3-88f8-59ec2eacd4fd", "AQAAAAIAAYagAAAAENUZ8Ya/vYGUv4zdZ7N5pKvpDlZH8LULiN6LG9hipG3Zm0p9YqkhZiPTr0TTa8m1Yg==", "c44cb111-c44b-427f-9929-3a1bb66938a8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0471c019-e4c5-4997-afbf-4a82e46c5d0e", "AQAAAAIAAYagAAAAENlVcbxP227UAQQiC1gYeg6Wl4S9TU35WvSKxbDdbbdSr9tcd56U9Fg8Ka7zgRSmwg==", "f1e39229-acb0-4c0b-b846-8ac3bb520c83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a8900006-5408-40a5-8bf3-b4fb06160dee", "AQAAAAIAAYagAAAAECD07EeE1lB8pJ2tSvhLZ4nMgC5SkscJxkEfwro7QzmEFJ2AXn6k9r5ZHSw+zd6j1Q==", "75b92a2a-6f7f-46f5-a84d-728409ea9508" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a7c3e9b-42f8-4b25-9f81-7cd92c84b9a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d68d9842-2504-4639-9b9a-195dd4654753", "AQAAAAIAAYagAAAAEC6CJs2OJq/SgUhxeJ7PArBsY1shc7X+NjO2BfzxRUo59KVkJpvFM666dIJzoT0wdQ==", "c53c15fd-e002-49fb-8959-c35f132f28b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6f464ba-1534-49c0-8f21-5012d10df495", "AQAAAAIAAYagAAAAEB7/pc7HpXgbaderp81SSBDvRL+Oe7/5lBMh5xOkOPIuaz762rZQEKZbJsUckqHcHA==", "5d8a8468-b0fc-4620-adfe-a0d8283c79d9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ca0944f9-68c3-4c24-bebc-fc0b1c13c811", "AQAAAAIAAYagAAAAEBmZDi9btEOGE7Ptx2keP8TtXQ01aD+tXFJ4g4AVsCR0cJWIrejd0vspdwt69mMrKg==", "eb3d3c2c-8853-4346-b48f-e02ffb753679" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9e3f84-2b4d-45a8-9e3f-7b6c8d1e2f94",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "331e74d9-7501-4a1a-a1dc-fdc528153a24", "AQAAAAIAAYagAAAAEGiuR4Jpx4H1nJdzyPq3+qkrqaemD+F2rIeOF6RQ8abscRJfOFA/T/p/eIi2O+zjAw==", "7c51c713-1e64-4650-8013-800091c658e7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "27ae3288-5b9e-4341-8744-08edfe9591a1", "AQAAAAIAAYagAAAAELjDJ+D5CmeY9NXkJYFz/0ET32eWpCMBYMgvnkvyw+PCKwmz1wH6Cswo6aOVyVUG9w==", "d50e5bb3-91ae-462d-9194-5cdd1e53ae8f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1k3bdpoy-1cb3-4c3b-1fp0-kff9k71h3ysg",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b521f0c1-6704-4fa3-b316-6936aa966a3a", "AQAAAAIAAYagAAAAEHsLsyyT+NsHEfGLpwJzMNaHusfbTv0hJ9bD7ctJuBBTizaOyRCtMryjuHD9CNXxhQ==", "eef3b999-87d7-4acc-ae78-da9117c0e47f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21ag1234-884k-0ak8-ap8i-2y54768532d2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0033282f-6700-4833-8a90-c728a578b164", "AQAAAAIAAYagAAAAEMkjyRw9O0xfmaQqH09fv/2bcMpXGs98nFRWJiw/BdtICJzpoGHznAaLE94dvexqrQ==", "c8abae76-10d3-4de2-a8b3-a0f98aa54cbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e9ae173-719e-4944-bb75-46704406e6f1", "AQAAAAIAAYagAAAAEB+E+cVbIRfe6C+8yRTNVohY0XbmmqyHIQal/vO4ZsAzlz7Tg8H2cALJ44+ChypHSw==", "abcdc750-e9a3-4afc-be7b-a2ddeef14538" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "234glioh-2akV-BL062-Hh28-LSJ2Gnj976w3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b8f27cb-4859-48e6-a1c5-27a117b6d21f", "AQAAAAIAAYagAAAAEOCOB2JKel4s/6yNNW9UAugZ9ehTUwv+jwwTnGM1o5gYdrp+ExU1iROVFht53L8q9A==", "abef9855-5527-4fce-81be-28af48d503c6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87d295d7-0d5d-4359-aaa0-c9cedef54a17", "AQAAAAIAAYagAAAAEJpK/zAouJMs9q1LJ7aW/wk92NaU2Z5ZJlzRsLkeXDU/SNSjCkEAEqHIGNg4f5WyYg==", "b7b769ac-6411-477f-9e4d-5d2bb8f00217" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54cd11fc-1455-47ff-85c8-de006c7471b3", "AQAAAAIAAYagAAAAEIRbHcM5+76QJKrzfBIsBaNejGK1SY1NN2oag6Z5MjWVSQ7oK6iZ/j4+ArYmEQ85xQ==", "cc643e4c-58b6-43a7-a562-38aacf9ad750" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f08106ff-d800-4426-9720-5be992ad9760", "AQAAAAIAAYagAAAAEF1fnCb7xLyQOcOxH6mk1yZi9n6lWD/bxsq/Yj7Mqj3K6mlGlpckOQ+IQPyP7rgamQ==", "ccd9e502-c373-4047-b441-dbf662fb4275" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76fe4d4e-0ae4-4e48-9d17-b4e6bec61b94", "AQAAAAIAAYagAAAAEC86FdQCra7+jRaw36T+e4B9CAFH1tltWlYZ9Ghtx09UuDc6gFC025ahr7O5LKypfg==", "9d1f3d4a-7024-40a1-b380-85c33482a12f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e9a6b74-7a21-4d33-9a84-5b9f1e8a3d27",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fa80acc7-4f44-4ae7-a057-3fbb8d8b6947", "AQAAAAIAAYagAAAAEL1+jKSicvLdu+YekJBYET4yOwIjAEbaTXy0sTljaPqoPy6rLYrD7e7GYQuU0yYJlQ==", "3a663722-b3c8-4253-891b-7d527701b570" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf827572-4c02-4caf-8880-f855bd0566c1", "AQAAAAIAAYagAAAAEAo/8842QA6MfZrwDNTMUPoWOfWalNPu/Wltq7sp1/oCHcmHf46xSfcCPtJ6SvXwzg==", "557cd776-fa5d-4190-8be3-85505eced701" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "806b44d4-50b6-4067-b571-041ac2971964", "AQAAAAIAAYagAAAAEHqbkXphVx8gE7hNnU4bExBy4enfo6RkWkyuE9ByCTkoE3AFke4HMQlqX3MLNF+F+A==", "7a4a668c-0097-471e-ae7d-13e3d55d4db3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "793731e2-f631-48fc-8ad5-4540e8994475", "AQAAAAIAAYagAAAAEFOITGwpCQ5RRkaaDw3vpbCQo7kiAL8raph4wv5gOvy4RYB3pXFpjGUlybMIGMhCrg==", "c1b89827-5d88-4301-a09c-8a48f3dfe4f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c639a29a-5736-41b9-a032-6e2726dfaba1", "AQAAAAIAAYagAAAAENe+ty3QLkGqHKrc+5O1L6NsD80muoMbMiELWB9boaLDu/lld1MdeiE2wezmGoAX+A==", "88a7ea36-adee-4734-a705-99bbfe21e62f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09f3e25d-fc37-42b2-9664-937fd55bc2ee", "AQAAAAIAAYagAAAAENgYtIpdBdU3qQfMNstByDPfC+OOjveoPqGj7pBG7fF+BKdiZoyGr4EPFQ9300isCg==", "0f8c9fc0-6089-4547-b914-6fd9b6e6996d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "09a8e966-ab47-478e-854d-bfbd3e562ec3", "AQAAAAIAAYagAAAAENK2egN+z2RyuduZPvfvHibzaoiYOwKSygrTv6BFQW7cTVr3W3mMZSV4s/LAtmR9gw==", "3ce76398-4e86-46e0-8c72-3b5d63096b30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f64d3d54-899c-434d-9685-1e3427f7a476", "AQAAAAIAAYagAAAAEOctOhcPTulQO/kMECgQ+m0Ls8rojxvtTxkYQYdMzcI9SWbJatd6FMUKxheVvRsadQ==", "1d9e373a-9345-4508-a65b-c95bd5e910b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "28447065-73de-4e69-b875-3e19fd557756", "AQAAAAIAAYagAAAAEOdv/m+Qppj1Q4M/Z0qSvrF45CBbhv7pWmIzX0uhs09qhQ05Dh7yZIeQMO3Y5eOPIw==", "a07cc8b3-542e-4371-928c-8dcb3334020b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b57a31b3-1ce3-4036-900d-d2b53f2d5d08", "AQAAAAIAAYagAAAAEJeTxYDA70uaNhR60enhr+0rDa7ExsWg+JtI6aJMFNDxmPJV13sAYfI9ubv4DObPeg==", "636c1537-3555-448e-9941-a53c4406019f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d0f42c6b-16e7-43c7-a551-5dbbf86d1e24", "AQAAAAIAAYagAAAAEBN9v1hVv/oPCbTA7wqXUOhpgCoNa5QBGt2CHIRyljyrEjaxS8PSKxsnWoIxxoMx2Q==", "b1f75391-b33a-41fb-ae64-705ba81e9bb4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ee63d724-434a-4f6d-b753-2a4965de690e", "AQAAAAIAAYagAAAAEGfnImR7RlpCUaKPQDn3Uq5O3GSykqvnh+BIlyxHm+FaIincUQ8a1MXGUxr42DJkvw==", "0b9fff77-4a3a-4483-a6a0-f97fea75c796" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1fdfeac-cbf2-416a-a0e5-696675aa2887", "AQAAAAIAAYagAAAAENggneBTr9IEYFQWE4NZVcY2aKijHIofKlHSUzOyk4fnGjk+OAC4YZnc1csJT5fFvg==", "b27cb726-1359-4c92-a90e-7242bb5faaac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0116e0c9-b340-473c-bf2b-925cde52a856", "AQAAAAIAAYagAAAAELEXQhAFvYY68HeJoZp+pxMeFdOICNCXFoWGR8mZTET5LWNucsCaIvw3UvR2SNy2uA==", "ef606ff5-c0e4-4f2c-a895-3fcac50bd5dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "206e5fa8-b52b-4fcb-8a1d-010694286d5a", "AQAAAAIAAYagAAAAEOCnTjtgK0fja9vYRfva7l02lsU5Os6g4+QZzsVe1SoROfRQtlWzGW/9bhQDrvUFZQ==", "867b5149-2526-437a-8492-9dd4060dad9b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "45fm8462-553a-4ac5-ap8i-3d65879641h8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "801edcbc-4e4e-4e83-8b35-2a3a6fbbc6fa", "AQAAAAIAAYagAAAAEF8O9iF6vC+eOPctsqF/tEG9+/jtP58/2cqj/tYYnd36JV3h7olKEzpvxrRx+aLhIg==", "4a5a371d-c1db-4cf3-8c4a-4f56733c6f3d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78cbf188-aa56-4cea-bc9c-c826631a3285", "AQAAAAIAAYagAAAAEJniykE4gnWDFHngMIlm8Spg2HGzSepnBOCnOE9FpjaJds/fYWySlJROF8YCf0GOJw==", "0cd22385-5388-42c7-9fc4-674a86ee3e49" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c4f9879-774d-4016-ae65-71e7195ce2c9", "AQAAAAIAAYagAAAAEDeW1qbNGWDPbT0NlgtdHv9Q+VQu6gftLudQWxzFJAyTrSi+G4AQeCeB4ocK5jTfFA==", "cfdfaaed-a999-4929-aae6-7f4a0126c756" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17ecf7ed-8f30-45e3-ad79-3fee8f0b51bc", "AQAAAAIAAYagAAAAENML4VBi98FOr7kfEgEp4ESh/d2jvjLeVcy+LkMS5sxQ+dd4XzOcZd+bTIoCo+SCbQ==", "2e6c1f3a-1e6c-4658-a176-586413805ded" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4gghfkad-4xhj-4c3b-1fp0-damxmbak242V",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce8e7db1-2879-4f5a-a93e-84e413bc471d", "AQAAAAIAAYagAAAAED0e3OiuM0d4DoQ4k6bPuR5bNSJsRCEhJOG+2eeNE2qEvv9Ebr8q/7mKSAvWnHIIiw==", "7a86f27e-02c4-4394-9af5-32494f089774" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b9e270b-0dd0-46a6-a8c6-ec9daa9dd7bc", "AQAAAAIAAYagAAAAENPaHkehnKxCmJr0op6Oz0WrMEnk0DrWHIr1GHV1ztK90EhiLbMwYukrzq2ykTKbcg==", "e3296eeb-0922-4d83-b813-fc2d69363f6e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "82a3c48a-ae53-4269-9cae-64aa8e61bdbf", "AQAAAAIAAYagAAAAEOIIw8bLyxrWEjLHn0SaZXC7mOjnW/UhdRGFgfXDSaWjTR31dSAXlL3Isiwbp1+rLg==", "c260fe36-29cf-478d-bb22-ae90cc51778c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b98100d-a31c-4794-b1bc-73d634a7d7b8", "AQAAAAIAAYagAAAAEBgu+/kZvatW7vD06Q45aciiWlkKhPCLiqxjmQQcdTLZLKY+xgO+ELspWgZ5NkZJ5A==", "094bd174-f78e-4f06-a9f7-d9775cf4f2df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a303f84d-61f0-45fe-b7be-df3fec8961b2", "AQAAAAIAAYagAAAAEIgfT/LETwyGrjP+ZEN27Q0oCfLFUPKEVHzyWqc4r3hAfnusOyXvVooRI+pi5hm8Cw==", "9732b4ce-138b-4ad9-b25b-53aa17a05495" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5fb9bda8-90ee-472f-bc65-89ac2b36db38", "AQAAAAIAAYagAAAAEP1qFPTf95aMDrcH5aK4jgyQHuEr2PNnK36XazJ5tNB8aQ1R8y53RUpE9oGPWxuIqw==", "5ef4b31e-c296-49c7-a020-fbf06252da1b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fc4d560-e795-460c-904f-d2506617df7f", "AQAAAAIAAYagAAAAEP+vFh25qzCXADcDFaDviZb54skkFHqYrSfBfKB/hwImajlkAtpyoFoohXcsjkFOOw==", "89047543-bd36-4d8a-bd53-e24d4f80afe2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "99d40550-afe5-44c6-8f2e-d38d38a80017", "AQAAAAIAAYagAAAAEANn3QmEVkF1FGyG96miYdQxtGTZpCUUvDiG3ttYr4dd+XA+TdI4r8FSRYjixyIWlA==", "60f7615c-1342-4f03-83ff-733a86014f3b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5af0c944-c18d-4131-aac4-5bb88f06493e", "AQAAAAIAAYagAAAAEFH15eRhxApqxbLWnjsrhyTPzbPC4iES+AHZ4vYNQNs4hwLW/+ehb5mbTjqsl1hrkg==", "2adfab8f-a13e-4648-af88-6fd407654110" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0b5bd38-bbbd-44a8-bf3c-0d75b74d0f34", "AQAAAAIAAYagAAAAEJbeufEofCKsvrvz6j8BGZznB51iZ5ztR0FfySMKp5liN+8SitMadoseHDMng3BomQ==", "51761467-749b-4572-ba73-6a761206acae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b53e3048-8bae-4e0a-a6ba-e807b01dc668", "AQAAAAIAAYagAAAAEBu2AiYc+KUXWh+EY5054N1izxwJBUQPpzhc1bi691C3D9qfSbOCDqwpowEjTVIvkQ==", "d35715a5-651c-42dd-abe0-2fddead7932a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fec81e2-d356-4fd9-97e9-95c072ec4458", "AQAAAAIAAYagAAAAEEq5/nPIVjxsQDesUQzvxxTetb9fZZKm0mqrzOizXstQ6Eta77CCFrBjRppbVCJkbw==", "3ce508de-9b3b-4a6d-8d35-20da2192c62c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d29db112-db07-4c52-b586-2a2769f4e49d", "AQAAAAIAAYagAAAAEJqbNWqmaUZaH9n+8dtah3O7HLT1V5CBzKq5380u2e/OhwVnITmRRwANTQ66oE7+fQ==", "36738298-a40e-48f1-95a3-60838d8b9f24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "560cf41c-6e02-4774-9b87-f20018bf9fc0", "AQAAAAIAAYagAAAAEFjHSdikzS+YIEwZixEFHFqFkNq+Ht71N10qTqFF1+/gsVnU3uHD6oSh5CDo9ubPEQ==", "d6b2534b-c285-424f-b64b-4edfe908c71e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5bbda415-6c8e-4986-9902-5ca458172afb", "AQAAAAIAAYagAAAAEHjTySgN1DD3zJyir49ZxZinxZoClz9rSmjyyz6rk/K6pvm2amdFSf6A1N0bzM3ugQ==", "8cb63d11-adb6-4c5d-b73f-46c45448be8e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "401c4715-57e1-4f7b-81d9-58fb5e51ec80", "AQAAAAIAAYagAAAAEL3dONNOI+nLPS5eXGkQAHQLiTiRyrpnNcbNYZOZCTOdCMw4JU3Mg8wJh6ZRNcQMAw==", "de3d98a4-b196-4b3d-9d5c-ed8c1d224d30" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "654hHioh-NkaH-jB19f-9uh12-33dFJnY823f2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "542bb562-efed-4b9e-ad53-aaae4c92763e", "AQAAAAIAAYagAAAAEMgAX9M54KswI/Isdnly/vEE7LZCFGj8vxawA9u+tEGQdXOEIEexObdSfxRl+RuYJg==", "de83c518-b4c8-4e4d-b16f-85d39f3ac452" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "66fg1385-86sd-8aw9-vm5g-1s87643521j5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "698ea70c-8833-4743-aae6-5b5f1ab1b5f6", "AQAAAAIAAYagAAAAEB+u1AsZDBxfG6imz/LasiXlBXOVrus4khCFo5rluyUyTfGqE4Lr1nA9WQFFLa9Hfg==", "04b78870-8e44-45dd-a5f5-f043ee0262bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6b3f8d72-9a1e-4c65-bd43-2e9c7f4b6a85",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be5998e0-db61-48ea-93cd-79880c6ca7c6", "AQAAAAIAAYagAAAAEHV2oSWxrSpGZVHlm2bteNgnqSPi8n6M8HwrC+AsByRg8+OU9h3IrJzGlAH5FhUYrw==", "0b7ca1d1-9971-4e32-88ee-6d6de323f287" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9509d93d-9b86-4ebc-a2da-f4e4fc40d1e7", "AQAAAAIAAYagAAAAEN3mfdD2PLs9l7xtge71G2OGghCeqxKPY1aKafFvSYAjCcWi1OqNeum+ixMLLEP/QA==", "b51385ff-1907-48e4-99df-cb0f4c95bac4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c34d165-229d-4c6c-b375-aef7fb134b8e", "AQAAAAIAAYagAAAAEI0dhAEl8ZUCp6VZCgb9KGgnbJhUxJOaWH/LYzTh2hEj65EUWoy7d/0zwORclvVoCg==", "690218e3-c535-4b1d-9ea7-2916bfe3d634" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef6f9dbb-6a76-4441-9cec-c01f6a3de5e0", "AQAAAAIAAYagAAAAELqw/bWDBNbddrHTyfolJy+euTAjQyWs1mAmPpCzJoO8tjmaShoq6f8J1A7KN4YETQ==", "144d8a73-1303-4461-8af5-35082f2989f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c4b05c48-59e5-470f-b43a-63209cee855a", "AQAAAAIAAYagAAAAEA7Qa7kyp2Rme6ki+kS4fr8qC73oyCVgNoh30mknEC4yO4OcXnKl1WWkxjvvT/V13w==", "6c6d502f-5574-4c33-b918-05bd522ad0e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6713594-c99a-4df6-95c1-9cacef2d4c85", "AQAAAAIAAYagAAAAEHKfA1ohsqSgL4w8AdHkNocEBUBD2Wb+2DamDGqu/AxYlP8Mbef3sGYi8GyNkUL/bA==", "7a43085f-3964-4af9-b46f-414b31278fae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b35af1a-e02e-4dc4-9b6c-b3bbcdca400f", "AQAAAAIAAYagAAAAEF1ECFOC3TKJxCquifi83PVj3D6MoyJVrnV3eeYnaXy/QZjBqwPGfiCf6mfeYYA7fg==", "7c866611-eccb-4582-b912-aae6f88bf52a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1322946e-de93-4afc-afae-54b2aa5ca5ae", "AQAAAAIAAYagAAAAEHEvkfTW+VmIwKeE0u5KlOC3gOG75wdVlDZOWQIPi2r7UZQKVjZpm83+t5wh7xQ0RQ==", "c381c615-50b8-4d76-b20a-10b4d7424545" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95358ed1-0863-4af0-b2e3-d957677d73ee", "AQAAAAIAAYagAAAAEI7cyKsTzhNfr2UVPbdbQV7KIfvQaOAd/+gJ9/s0wLD3ns5nsGNHFmlJUufeoG3JDw==", "c3478783-9de2-45e2-a46b-a0badac688d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7A91XEhQ-MpZ3-KL28-A9uT1-88HWrLQe5630",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b9191970-6ecc-42a3-bb95-93ec80466c05", "AQAAAAIAAYagAAAAEKkVsYpUW5vErF2jSlGlYrkGYsRCbm/iZsu1j040fE5JCaQ62jtGomV5LNlpnjeysA==", "d1d4a32a-b8a0-42f3-ad62-6fe6d573b381" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1ce4814-2a24-4060-9c86-7266720258d3", "AQAAAAIAAYagAAAAELgA3h6zVA4uI7gLvlltOs1eW2lj2CZkZrrZS0sGCYCQg2azxy9qfBSYf1NqcvuS2Q==", "84d25990-2a9c-40f6-95ae-f46356c48ab6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52eae60a-6392-4230-8f28-fafc53fe9586", "AQAAAAIAAYagAAAAEHpDyIJoEvGLztN+p/2u0h/QYgsSNC1KA/rpdlxB2zwe5/Zf/UJHNGWoGSrnGTMWDA==", "b5669bc7-bbf6-4147-ade8-1f96ca006b5c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7e4c8a59-1b9d-4c5e-ae31-8c2f3d5b7a61",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40fa6864-91d9-4209-9e60-a4d823219a68", "AQAAAAIAAYagAAAAEJbGI3LN77dyvNYDQi7fBTLAhm+WkIbEl9QtwxsssmFHD+VjrbBYnYMv/WO2f2kIUA==", "63a04f33-2046-4a6a-b0c3-7cdac7f69367" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf2c6693-5ac9-4aac-b520-63a52a1c7286", "AQAAAAIAAYagAAAAEN3NOWT5wuI4XE49DOOJAGqP5ixlcxcbyT0kQ35escp0ytgkfRMg5FeKOE2FuSB5xw==", "9bcead25-3cb7-41e0-984f-b4453f2d506b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f798a51e-2a89-43f8-a762-ce8fb9d4a114", "AQAAAAIAAYagAAAAEL/kZ7J1OC0sbQDHmYvdcAV5U4/wkL4xpb+2lGrZcqJiV38TkRmKcKerbggdorUaiA==", "37d18d8c-d6f9-4fa5-909c-ec46f673485c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "813tyuio-7asd-1f7k-6kl0-aqFx134Tv190",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "64831b42-4bf3-4a30-a13a-f596bab36154", "AQAAAAIAAYagAAAAECHGZYjqNrFTmc0oLIqjbgazLyDQYqH6MB+nMqyxRkhk+WdJIZas+/EcW6ftn5656g==", "d5062f52-bd97-432e-9687-407c5dc86f17" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "822rlioO-0Dvi-3fo9O-bjh8-ya846jg58t24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6d3b68d9-6d4e-491a-89f8-07c4bd5b618b", "AQAAAAIAAYagAAAAENG+DXqPoLGf8xdoD8mZFSp6J6a3RdqWlOeiNPfe6kbzzLrv+pQElnzB3FNtQ+UNjg==", "72ee21b5-8f0f-4d45-ade6-077ff77b7963" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cfce93a3-4dbd-452e-9cd7-a342bd12668f", "AQAAAAIAAYagAAAAEN5n7+Wna5a0oEoL8Q7Q8uMXVoKbXT+pXGCsnXfeojdUoa257PPBkXwyySudElRQGQ==", "5a8dc950-f575-446a-82c1-587337ac18da" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "458995d6-6b1b-4903-91ae-6ef0d98c95a2", "AQAAAAIAAYagAAAAEPBdjDyVdOqUFDepiOR89t1zhFcpSjsmFWrCPPrk4vIBVWJuOhu8+/rw9MjTHi6F1A==", "02393037-44ee-4d21-aa95-e8389c7d1fb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b6a3aaa-6244-45a2-b30d-62ca14395d11", "AQAAAAIAAYagAAAAEJeQtFmHWO0z+xLJmTq8Zfe49n08iHeYqgB2B/UWY3gMdABQZgfX0O/RGZ/wpBsDuA==", "8aeba2da-7938-4637-b0eb-9be6793130fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6f944dd-4955-4907-b303-b7c544bdef98", "AQAAAAIAAYagAAAAEIsLEZLD+ajXcVYwnG3fx3antf5keSuDd/IgV/qeVaWMpXuXbRk5IfJ/sXmeOgyjBQ==", "c230bb5e-3563-4103-9cda-4f166f2dd6d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8c1f5b93-4e7a-4f18-b3c9-1a2d5f84c9e1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "06ffaa27-aed3-4893-bf85-cd435bf182f2", "AQAAAAIAAYagAAAAEB2FEzgmRRXxWq94AyI7CPTrTcq0hZKSU8HN12bF3v7VTBI5ErFAZb2mFQrHeEPeMw==", "99345d98-a0e0-47da-88aa-cb601a1f95c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8d9a1b3f-0c84-46a7-b932-13cf8d05f2a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "21368ee7-8c2f-45e2-b90f-3a216bd9f868", "AQAAAAIAAYagAAAAELMW++O/jglKToykBqWULiBPL5wtfd7OO4e3ZYVNyZu0/j/TfoniWx2snskhw0va4g==", "6ae7640a-8e86-4232-8780-347c6ccdb20a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e246fdbf-1c18-4d4d-b902-1760a907b2b8", "AQAAAAIAAYagAAAAENeF0G4M3d5Lxp75XyCEEF/ZUDL8ujP9Zp3K9h7VlfMvQaQPaFLNkzCfytpQous8PA==", "edce6b06-bd89-4f5a-8fe9-c531e93f4482" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af4e7241-03d1-4c7f-8544-9752c050bd30", "AQAAAAIAAYagAAAAEPlMVdlzlov4bZ3uIFPrN34VLLyW1tv0WO4IQ2SfptJztV1HNeqGxFW6LhstWa5bxQ==", "c034320f-89eb-4bf6-8744-f8697806171c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "48d61a86-a5b6-49db-9327-d138620d9fb4", "AQAAAAIAAYagAAAAENvJ5ecCxOZig/fbd9nCxkdybFizYbcwLAPF65pyK0jSMSMVkZ5zBpeqs+Ul+DoaWQ==", "d3d38d66-7f91-42e7-967c-9b8ab95be20c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8rrdhjqf-2xhj-4c3b-1fp0-hqvxadfh137e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "211db1b4-c684-40e8-aa23-73e262a08430", "AQAAAAIAAYagAAAAELsa/50iNFGuhNb5DoHn23J2FQcu1e1diHQh//VANDlCZ1sglGFqF0KcS/90+WqOTQ==", "3ce483ff-2c90-4eaf-b2e0-76a6d64b587f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "924omboD-0Dvi-3fkhQ-blh6-yaFv1de62431",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78a28016-f1d7-4d82-842e-9eab4047f89b", "AQAAAAIAAYagAAAAEAt9WAR3tlEPG+9oGIGCg27rO5Ulag9A+Jev0MkniVjWsYcEj30QMmWyOXjoqqz8NA==", "b35db558-b0f9-41ea-9ea8-a742f12f3226" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c18ddf1-4dd2-418c-aa66-c8333f3c3082", "AQAAAAIAAYagAAAAEHtSxkM/L4v9BZt6H5Pzu1Nao9I2bBkovF3/HfDJUt9U65L+tV6rVaFn3lxa4zk1jw==", "b4d8412a-756b-44c3-8941-3a8a50239f27" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f6d22fc1-b4b2-4891-b8ba-205b9ce669a5", "AQAAAAIAAYagAAAAEPzNoQYbFI8jYg4yhdupce4dRY9p58LI8v4cdiiLDnrRKaFj7bLDxrd10wPjuBkhMw==", "d9fa1cab-29c5-4133-b962-c1de6486459d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc96e601-4a7e-477b-9efe-24c62dca2f2e", "AQAAAAIAAYagAAAAEEWYDORhfyA5zdG6WTgRuMNp4vDT7/+aQfN+XNpIoi6tEPIDx2U1K0VRiCUhnefvQA==", "554ee4f2-63e8-477f-bd77-d2cfb492db78" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eaead440-29dd-4bc2-b2f7-992f529d8ddb", "AQAAAAIAAYagAAAAELt7pTg4pELx2oTU+UM/8BIyjVEHf6/M4pQjyj8gD4T5bZl/1JZv8sEpi5qy6b2X9g==", "5567f9f1-5203-45ff-9fb4-b9262d37b2de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9f3b1c52-2e4a-4d65-8d13-6f2c7a9b5f42",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce88c968-c73b-46bb-9650-4d155cd17705", "AQAAAAIAAYagAAAAEEjJnlwNYWuA2UXOSmnf35uL36Aiz4S//kJtcgBFYZZlSbkV3aWfrmwIsrsHXGZw1Q==", "4f47f11f-9682-488b-9eb0-5c8ab7d72ecb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5aad542b-0d13-42c6-b8fe-a987ba5fe830", "AQAAAAIAAYagAAAAENd8Kb0CUAl9ipWlmlfHS5MIPGRVfl3AqNSB0w2L67H+k8o4VohJ9colkdh5QWL8jQ==", "3c436156-71a9-43de-a9d3-960cb506218b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1c7d995-3f89-4fcb-86c4-4d8d193b57a3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4803696-b1a3-45cc-a91d-28fbf74e8e8f", "AQAAAAIAAYagAAAAEJIzRaChuLPX2lVzih13jET2DiPZkE9N692Ox28xcm8GHD3bDPAhsCffRjMmEMgmQA==", "1e266b50-0bc1-4caa-bb56-eb0870040794" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d79de2f-33df-4cee-84b0-d8fe2ea9e3ae", "AQAAAAIAAYagAAAAEJWYA9dHdv0e/C4GYYOdlNIz20wHcFirU2QZma7Ot1/On+FcPMrHWin+hNusWfDlbA==", "02b5ac7d-6e9d-4355-ae2f-38438bf6718b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bdf8f629-887f-4004-94e9-3909a352ef8f", "AQAAAAIAAYagAAAAEA5sLTXq0eztjwhe3wFxQDZqHFaGjbW1AdvBMJaElglg6PZJWBZjeD0ubIjT6IExiw==", "e84aa7b7-8b0a-4955-9d9b-d2cefccbfd35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1d89495-5b89-4de2-aa9f-5903f2d06bfc", "AQAAAAIAAYagAAAAEGobL7i9mMbwDUGoesLlbb0+UH8L8dI05iHfHtU+0NR/M2KJWNKxtHsBU0ZpBdVGtg==", "bd2a32f0-3f91-4add-a805-f104d7f7934c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed30c3ef-a343-438b-8664-8aef8890ccd6", "AQAAAAIAAYagAAAAEDtX717t3YsrSfEpji7TNydSvIqe5XnBA4kTVyxL43uRLKEXXNbnn1bXsohC4/wiqA==", "508d31b4-b9d5-4cf4-9094-7dad2d2e5cb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bbc97308-e069-4927-884c-795f737a15b5", "AQAAAAIAAYagAAAAENkVu/v2Svri+IayuB/bRfXFvWnY2XAmQ6AW+UhMsHllLzpRoKDOnUEk8bJ0zYXUmA==", "6de0b861-0372-48b3-8c5d-1c9ba432151a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ffe5990-bc72-450e-82f5-7c6528652f93", "AQAAAAIAAYagAAAAEAz60VgElOowWTA6Y1IJO10cuF4fOCYgoTnzCXQr28w9bPAAtolI4HgiKMxgWKiy5g==", "fc0dfe6a-630e-4ab5-b3df-9d29a84d12ea" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cd1c30d-99dc-4bba-b5f4-71141881c8e1", "AQAAAAIAAYagAAAAEMPo2ImU0ry0v0aBWGExyH3GWwOTRL2NN3Pj/lOSwQahcVwDKwC4zVth3jKIjQkZPQ==", "bbb93536-3484-413f-b09d-b3a8d1ab6948" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "24b506e3-16cf-49c9-b119-ab6e20c12806", "AQAAAAIAAYagAAAAEEaWj/4xP31snkjWutsHDDw04lIhriXLFvJtipuY/8mqWBOZEeEGw7kOLQFCN5ob8w==", "902bd7ad-3de5-4b54-bad8-a83698d34b33" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fabbca48-919e-44ba-a718-aef8d965740b", "AQAAAAIAAYagAAAAEAAmpJYRDWC3O3Z/ASb/vrMKqNbrGIeVEAK3olEKk8EPxON3CfNnD34oTAn/VVy+lQ==", "c67781b8-ed59-4c1f-a02e-00709c8eacde" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4628f575-6afc-4aaa-9a5f-dd517044dee7", "AQAAAAIAAYagAAAAEMn5olTraN0MrRFNU7ZMUpik6tTKk5cOMZ+DgQR1kAv1gnqDH6/QvXR6RwAbrBOt7w==", "a0ccbe41-2bb4-4d83-8347-4269b89054dd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c7b19f7-1b5e-47f5-a811-796bd1afae39", "AQAAAAIAAYagAAAAEIfSbC2kSvy+U+l4+5WR/y/TtOHP4VmvcZu92HupgAcKNDDatTg4M66Rv/77pPf3AQ==", "0675f406-30cc-48b2-a574-fb2f2577345b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b4848c3f-3ee2-4081-9c40-153d80437338", "AQAAAAIAAYagAAAAENziYJe5o218LBw/u4UCMtpDZgREfO8con092/HnlcsjjYoWslQC+0sAJo8afse0pQ==", "774a5e7d-9e87-4cec-a466-d6e7230b1e50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b7f4e831-25ad-48a9-91d3-7e26f53a4db2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c1edf497-cfa6-4935-983e-6c4a8efc8d7e", "AQAAAAIAAYagAAAAEPabMWK8ENTpCpIWwN1aPXr6uflA8l/yZTQK6hkDfra/hu0GyCiYp1+inwPv943GwQ==", "c0acb1fe-281e-456f-b793-b9fa5f3c7a47" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2217e950-2bb7-4276-9200-b7d69cde9b1d", "AQAAAAIAAYagAAAAEIfLv76V04FRFQ/+8Zfqjhe5c2NrVLQ9qiezmsK9/q/ghvUMq+zAUt/4CHPE49Zxlg==", "ce037800-52e0-4056-9f96-5984d31841ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e29e4f0-f9e3-41c5-86a7-f76f10f88f73", "AQAAAAIAAYagAAAAEMgopIaV4yw9Ea+YlBQEI3Tonqe3VnIfqAfSMfQyUZ+xlq43DOYrdUXRo9fdLI8lgg==", "0afc00ea-20d6-4efe-8e4e-a07ae982f660" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f46da09-3fb7-4f93-af54-aca97ef6e880", "AQAAAAIAAYagAAAAEOfOCSNG78eT0dmECcsQChUN82SPK1wHeQ3wXhEzD9nAfHkOu8qCZ+B+BonL/d9Ubg==", "6ae940e2-fc1b-42ce-a4f2-735bacd3a9a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "622514ab-beb8-4e7c-8b96-697459d973d7", "AQAAAAIAAYagAAAAEF1JcSRjw+s8z+2bZFcVxQjA8j3b7Uwl4oqmO/BE9666S73xd22UtjoRshpVTr/EMw==", "555cb708-4fb2-411f-954d-9df05929ef00" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a808abed-764a-4caa-affd-a411e8be302c", "AQAAAAIAAYagAAAAEEI4haXOGCdHJP1SVjwITX4GAConWhRPnAMm8E1qyLS0BhSacdxdJGR4SENTibLIaA==", "7d28cc88-b6ab-457d-b938-d11a924a4957" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4696f979-4955-459c-b0c1-090662273cd0", "AQAAAAIAAYagAAAAEJVq7OiC/FmwfupYZx8IsuhUNISmLXBWXAP1nZ2bILTyIWmB0hMFf+YOmtfJCPW9rw==", "e593dc19-c278-4e73-83dd-2c0cb4d47223" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0f406d8b-6d82-402c-a25d-0bdbbeec3a14", "AQAAAAIAAYagAAAAEP2L60YdbiMjxln+B8Z/kR9lFVp1IOQJZ3B0zYor+Bpcz8BHY1jdza9wncOSh/8XOw==", "7841f8a2-6e85-4ae7-84d7-0f2f899dc974" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c4bd9e2a-1cb3-4c3b-9d0c-2ff2e43c7d1b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23c8359b-44f8-4dd0-83de-a87433ab3f67", "AQAAAAIAAYagAAAAED/1WEC7d6E/+aPaJ3Z+5RF9KFzjkn2iFSpAl/n2GV+KIHoRq5iICAeK45bmTtrkpQ==", "6f464dcd-454f-4ee9-a157-3f5a43d0f78c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57013e1a-126c-4f83-ab37-3e23971d5ae8", "AQAAAAIAAYagAAAAEBp/s5+JJwTbcwtIyKqno2qDtWtKmWKlHcPt4TgDkKNPFqvAjlpKvmp0B7hT7TBC8Q==", "39554de3-a100-4bf7-a340-73cebbd75f37" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c5e81f9d-73a0-4b93-b6fc-97c72e3c15e8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "697dce83-7b45-4e2f-98ee-cb14e7d0e000", "AQAAAAIAAYagAAAAED6Qenlr/zmKREtgtoHT6duZMlsCQtjlPYFlHaG5YmRS+ZPJTovHdf8dS2/r1bEUtA==", "b7525cae-7e9a-4a9d-a70e-9e395edb030c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c63b2e15-8ad4-45b8-bfd1-3a98216c5ea4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00760865-a5e2-4c43-87cd-f382c280ab1d", "AQAAAAIAAYagAAAAEHbOHSm7Kr6Hfy0TxyVafahawZdNaf7sGbBi8NwNjvkKVkIOapZhhqytU7ZmtWnw9w==", "2371d7f0-1d08-482c-9d7b-a897aa3cac91" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20f1e565-2ae4-4baf-adc0-d67ea7623d4c", "AQAAAAIAAYagAAAAEALMlAvAVanoG/dkGfSIVqSocCAo2reHfupcU8CfgBOojJRTR43Mi5uOt77z3XFsCg==", "5e46494e-67da-4517-9cf4-9e56698b5a2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bfe2a0d6-c711-4181-a58a-1afa71990ac1", "AQAAAAIAAYagAAAAEJGf3Cr4gDGtJYZU/JJE+Z9UDhKeZeJY3ffYri5UpJtOteEQCsCfW49qlNu900lzLw==", "569172c6-20e8-4e15-9000-de12a39cc505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f391ae64-6f9d-446c-b7fb-f5f669f82561", "AQAAAAIAAYagAAAAEKrUYpwkABqcO5k48epjCF3KrIMH/412QzUfFjOn/+61+dJD2AcSYYTTE0mCUrPKqg==", "efdd646d-ba60-4497-8c63-208c2f76052f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11e894a9-8e66-4b62-91bf-6c46a332f712", "AQAAAAIAAYagAAAAEFRYTE/QsQH7J3X/KWgSzfCPAQ5NPdMozRHD6KzzkmfhCPBhtWIqdwyIXbTXALCzIw==", "12bf0701-33a8-4e2f-963a-12dac1b3bc0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fbf19607-32fe-4fd7-a567-21ce67d77fc7", "AQAAAAIAAYagAAAAEBv3HPQHcv/jE5ZMFFHxdTxeCkiM2782kcyM+zCj98DFhqmbUcE5foGNU6f+sPQiAg==", "495e05aa-4b41-4f27-baa5-96bc7d863808" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79c63dc2-a9c3-46ea-b954-66108868fba2", "AQAAAAIAAYagAAAAEIIGse98vcTMaLtFOE5cX/4QowVZIQGqTPRpQkumfls0nPH9ab3HHI0kXSxoUMTdMQ==", "8a50a12b-84ea-4d26-888a-ea0aa320a1cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "478d88db-9164-46a9-9f78-a26c1176fe9b", "AQAAAAIAAYagAAAAEFuiory97MJMZYCz+3qIBQChhyOAGCCptIkmXqgfYPK3dPhj1Ke8yWbLpmlR+XhF7Q==", "1a70d43d-b5a3-40d0-b518-37bd69b75512" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "924da41e-d9f9-4a3d-8fe1-895cfd86d486", "AQAAAAIAAYagAAAAEO+WQFJXWjkuSvCP33r80Pr9JFnr7tdwDZwisqMyiaVuS9Q1D/G6aptNH1uy1E2uOQ==", "131304a5-2cd0-4040-80fd-7e6603a74f45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d5e2c4f8-95b1-47b9-bc12-8c4f9d8e2b17",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "19149801-d825-425d-9df6-ab303e81340a", "AQAAAAIAAYagAAAAEAO5L+IsUu/FZeTJElEDA2G0WOS7xTa6MGypr+YQoBU67lycDDZb2zTiO3V33aH3zA==", "902f70bc-ed91-414e-898c-ead56bd3ee6a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "349fa07e-7966-4374-b80d-fb9fe2873c07", "AQAAAAIAAYagAAAAECU0n+qP5ZuUfmP/kS5epQx6auZ8ANBLnaPZeNx9REC+qkkcJRaj0Epqv4Uk/dZ+KQ==", "6b1313f0-61b0-46be-af8f-bf9229b28d4f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77bcb423-6197-4712-98e6-41bf3e4111ba", "AQAAAAIAAYagAAAAEMqlJNjYvRxaOxtVmhTPUTBljBzV4mJotum0QVBYKtwQAUEosb5yfX5Ef5S3v4sP/w==", "f08e37fa-ea3c-4f23-87f6-835fbb407559" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5a92d61-0eb9-491b-81c3-d217756fc77c", "AQAAAAIAAYagAAAAECFHZRHTPhKTRhSi8bDXOboplJTTIXUVQ5vBWHEchQLyX9ZD4ch1oCR3Slo265WJGQ==", "a8b3873f-88b7-4fd5-9afe-ec4051e59ab0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e30662b-fbea-4d5a-adbd-53bdb5ccbc9f", "AQAAAAIAAYagAAAAEAauaRKnM1amLUHYa66xK7f9zPNYV+n+1lVX2Qc1xZZwrOinv8QvLMEVWLW94K0i2A==", "c05e5119-ee61-4173-846c-d34896252345" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ebb2498-57ad-4cb7-aca3-77d27c21b9e2", "AQAAAAIAAYagAAAAECX5g/tg+5OBfhLaWPZEZy8GOSAuXLFv+ExlyqfsqrEiBU/47RrB5J7GxEv4UHkYuA==", "2cfbbf78-d976-4a4c-bbfc-f6544443bf8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff30f665-751f-47e6-815a-4616f27c210c", "AQAAAAIAAYagAAAAEBdi3NDa5kNfrnWwJgYFVl6q2Nzd9nU/6bqdlhiZdMZiROenqUG/8JDARn5oiw7Ftw==", "bdf43038-4552-4f79-8d4d-396779294f2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddcb2da7-e527-4bce-8ea8-45aee908ac1b", "AQAAAAIAAYagAAAAEOJPS7JdsSQXW7f9xH8sCUAIuidmpUHqHo5VG6YT3aDTKyRmACf00pG/89lXiE7Wqg==", "44ed8ab4-94d9-41d0-b5ab-d326c87817d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e4b3a611-7c8a-4f9b-83a6-2a5b9e61d4c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55408ee4-5ec4-4c8c-9ae8-311a1113f7a2", "AQAAAAIAAYagAAAAELMoSauIffL1jqNXq8b0LHIQ0WTSjymvGQnhtjF7aaIdfT35jpKLx/jwXiRidcxqzg==", "d21336f8-4949-442e-a9b8-93b2d51e5bfa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "71f4fa28-8170-45ee-b884-4aa567f58587", "AQAAAAIAAYagAAAAECnN9q7TTye4didgz2S55V7Dwi3zhgfOzsOTqmiJpGbxkYkKG/kS7MRMnn0ZrPBc3w==", "ae311931-9700-41f5-9769-b033d5087653" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1228be4b-fa51-4597-88dc-8cd88c7e59de", "AQAAAAIAAYagAAAAEDjQ2xUulaiHz0qlkbHOiDvXfIjAiqCK6+uRtecslCcI4Z3mM38avPbPP7xolgyV+w==", "60329c8c-8e60-419e-86bc-a25c8df26505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96f03232-78d0-4669-91ec-fdea04c4cd31", "AQAAAAIAAYagAAAAEF1H/MCpaPdwf8OgSy+M/JiZVlsHQWk1PJ8Ijc/KRUUEEqY6Nr7VoarT24vxCKmlDA==", "8d71ba21-7cbd-429e-b91e-90f359e77839" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f0018009-d6db-4b5d-8eda-b0163604e538", "AQAAAAIAAYagAAAAED2HKQlfAl+8Dba9EZ5vrZouLphBQEVvQClcrL31ss1cO1JT/raLSRcL05T21zGCIg==", "8b42afc7-8c14-4b86-9202-c7f6ad5f964f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6196a35b-e1f9-43ca-a4c5-6f56398028fc", "AQAAAAIAAYagAAAAEMsOg8A06A01NwjTvdgqVYsd42Q3q04QaezaAlGHX5hBKkNhA3uqO1qJP3UcUaWrlw==", "94304953-693e-4d8c-9ebd-fedb1b0fd32c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8c10ebe2-f229-443e-b13f-5147a5c97449", "AQAAAAIAAYagAAAAEDYTnNJU5j6w0P0MCdnKSNFoQemcHvwRJjm+jKnqfX9pzCULdUwKnNSAv7p/tMe31w==", "f141d52e-b2a6-4034-adfa-5f5b6facf43d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8a6cf087-abf2-4464-bb9c-caad3e4f03a2", "AQAAAAIAAYagAAAAECuqA3ZrpbJcGhyRmX7VjTTxLvlqYL3ES4jjmdn2XGrlcNJcsYj61E1xU5lyCrzLgw==", "a715eb0e-684d-4986-b753-b374ff757a5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e6f096de-d1d0-4e34-8d6b-728b72086d39", "AQAAAAIAAYagAAAAENUiaTUgtNMYZTBtFtYfFgHrS55Y0h6nzndh2zbhrnDNkmoaB8VjWMS923QGabkYrw==", "fa01d8a9-e2aa-4978-9f18-3a1217cdbfbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ce805d38-611c-4826-aa22-8cae95295528", "AQAAAAIAAYagAAAAEBvZXTGt4bvU507+SbnGGRTezfvjLmzITgvpFP/sWubF4tFlne7eYRd0Vb7S/p9sUg==", "bda44a6b-aec3-4464-abee-3fdab56fb499" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2dd78ba-7493-4a16-aeda-5808eb72f1a3", "AQAAAAIAAYagAAAAEGU77/Ky5z7efD9lKytOUtOMRdsJjOjib5jwXwME+z8ejVbwwECloQRy71qITRJvsw==", "3b9b2fd7-1845-4fd3-9e84-389ee91b5e1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f82a9135-7bdf-4ca1-9ea2-2c8b63a1d7f9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "14c0c04e-0b3c-4b32-b21d-8c4089e38e0c", "AQAAAAIAAYagAAAAEOB0PyXZQzuswZhMtLXDCWkWLQTgju7KtwEVIT3SeDVxNjjiMTHjTMAFux2tWy/qAA==", "18be3d14-8b32-4eba-a946-479df2cf1fa7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa66ecfb-c2e7-4fe6-8199-50d25b0329cd", "AQAAAAIAAYagAAAAEAOL1OcQl+nZjRDsDyZ4bopJ5YLvI1UyXzpB/DQCIbgzKvg+saBJ+Q0noKoIUWqnEA==", "02b96700-0ba7-4e18-8fc2-486b87482816" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "316b9a38-e6e6-4911-8ba8-c4eb90633299", "AQAAAAIAAYagAAAAEKU0qG1NXoAj7FCNbZP+dfH52dmN8vBm8FwicdOtRhBOpalmAISreotVDoR1JoYUmw==", "14b49e7c-639e-41fb-ae69-6a97f5bb2227" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "m3xzke5a-1cb3-4c3b-9d0o-9kk8f72v8j5f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c89e3ae8-8f19-4341-a3bb-4ad20c3ff1a1", "AQAAAAIAAYagAAAAEF5LdjJT8rQcyEH8Rgd/gI4i6Of2pD1IArqGQ5CgAKBjifLdflNt/J2O4s3t88o70A==", "330be354-28ae-402b-9090-a7aa7872cbdc" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditScheduleDetails_OfficeId",
                table: "AuditScheduleDetails",
                column: "OfficeId");

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Offices_OfficeId",
                table: "AuditScheduleDetails",
                column: "OfficeId",
                principalTable: "Offices",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_AuditScheduleDetails_Teams_TeamId",
                table: "AuditScheduleDetails",
                column: "TeamId",
                principalTable: "Teams",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
