using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddAnnouncementEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Announcement",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    FromDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ToDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Announcement", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "3ccce086-6571-4169-847a-c26cc95b9e32");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "dca3de63-680e-404f-aff3-7a9218c7de2b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "b7f7984c-bb1e-42b8-bd38-bd448f178adf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "bd20557b-c884-489f-b628-b6550883a01b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e00fd34e-70da-4623-950f-c7170c7e6e50");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b3d5e2ee-f8a7-463b-b588-1955ff974fea");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "691ed4f6-648f-48e4-bde0-5e879bf01f2d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "beaa33e4-0b1a-4aaa-8793-15b0948dd076");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "9da1606b-af64-448a-a2be-d0c43f0707b4");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2447e09d-8e97-487f-bca4-d6cd5cd1aa87", "AQAAAAIAAYagAAAAEBYbfUg3tiwc6I296IB9UrUHH1l5futvE3esyrtL4JFfltG0fv6P9FP1oAx12tqfPg==", "39fd4349-599c-473b-afbc-e5231516c398" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5540334c-b10e-4e31-b878-7f81056faa9f", "AQAAAAIAAYagAAAAEDX4AUAf/nHcaPmXjMyF3sVUuSYOBfAmLsW0bNq9UUTBmfCh/P401zMP8e44uyzo9Q==", "3b33d1df-c5b8-4d43-ac7b-1d8e093accc3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6594aebf-099f-4d41-8b5f-7f4852a545f2", "AQAAAAIAAYagAAAAEFZ2Ozw9EolTGq9r7LzdyUpZ43uUtVwE2yBKJf92kTbl1ZOqfLLgxHTaOgSXHOH7QQ==", "5fcbd0b9-cdff-4d9e-84d7-15d9269d2fe3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52413956-d1d3-473d-af13-9980b3a096c6", "AQAAAAIAAYagAAAAECpMCralH9A2EFeyMaUNItsU0lyoD0L4a6SDbP6Gdo7jAhu6JnE+379PfPKe/78eXg==", "5dc9f7dd-69ec-4ba2-ad69-48aef6b8f10b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "358f7bd5-3f40-493d-8f1c-66cdd94b06b2", "AQAAAAIAAYagAAAAEDXEsvrLmWa10sz4X3fEMJM6UDQWwaEnuuBbUE0E0XSOdDFYl64emHasqn1j1h8Nsg==", "72cf40dd-3823-4fee-b286-78708f5b95a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7f3bdf6-aa09-4678-bde2-c0a146d0c6cf", "AQAAAAIAAYagAAAAEDNexWHU/hYMfog8lD8RiMW4szyxgXlzn1/jUnCt5DPq8+pp4EiOeV+YRDOg2NcGVg==", "1effc65e-8468-4f37-87a2-3c836409936c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b2a4ec95-3747-45c3-a9c2-eaabc96b39e9", "AQAAAAIAAYagAAAAEMkKjfGT8qX0XYyRdie+sqnLFfW40AkP+i+qmGIfE3F9wh1aOQqoIzGWXn1pUITO0A==", "07fc7c53-58fe-477f-a045-027900343025" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9a793498-57e5-4253-804e-8f0102545f61", "AQAAAAIAAYagAAAAEB69n+xmBeY4XKBkDK3L3cvJ7fJCyayr+gt6v+X2sQs8p33fTYAPylHriZBmZOfWzw==", "243d7ffa-3f01-4424-92c5-fb3775e795f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a49cdc09-8dec-40ce-a045-8d27a489cbee", "AQAAAAIAAYagAAAAEMEgIwqWzvYdp+n/qZeOe85aPdDsYKadZEDyxXtV3+a7vCFSGM4bOdifAaEeXeM3Mw==", "cbe1a0d8-6a68-4d12-bb55-51de6dcab1d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a76c2dd2-641c-4320-a2ad-12b348a3da18", "AQAAAAIAAYagAAAAEGgSIbMMnvKGH36gaqjKMgyoYq3oCuqoDDoyM+LF9I8EbZV03eeWITItCdi034XB4A==", "4eab57b0-d499-491a-93bf-e6bbcfb458fa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3f79372a-379b-4136-918b-c43e53d66a1b", "AQAAAAIAAYagAAAAEPk7KwFMbYHiiPL3aHoXkADgrAWBswL8l/aWCaSobhtQiy9kI9Ko+m3uqEOaTQG1NA==", "72325646-72f2-49b6-81cb-f363150e07fd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2cf157a3-a6c8-480f-929d-12ef90ab0125", "AQAAAAIAAYagAAAAECG55I0eV3E31YgGudZqPP9JCAXSGMUGnNZIaKcgJzZZ6a/k6Ka4O54Jphb6EVXjgw==", "b7654162-7cc8-479f-b985-785299345839" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c34d67cb-73f0-4eb1-857b-16b66674feaa", "AQAAAAIAAYagAAAAEG6PrUAZkokjL8Tscfwj/iSuawZP2Wiv22LGLW63/80iLj8lMBg6KhmWnNGKPVEIRA==", "f696c191-1c35-40dd-887f-f6a5f6d2606c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdb048fe-afaf-4ac2-a606-078df2d08636", "AQAAAAIAAYagAAAAEJrrsvKwoJHnavgjPG4XSiQ5H6p52pMI76xIb5nR8ncZ4haGSQHbyVNRu+DpfWNafA==", "94d9f8d4-5a04-4f90-91b4-17697351dd21" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "275aaad5-7f0b-4cb8-b3b2-a05e762a2711", "AQAAAAIAAYagAAAAEIvWerwQBKGCCVDNlqUPsJ49ojas7KkLoEs2zddLRfY4ALTDjXtKDBbPxJD/KU/kcQ==", "7850f838-4b8b-4d8f-8cfc-9d9e37693839" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04f6da5e-5622-42e7-97fd-29ed98e8c54d", "AQAAAAIAAYagAAAAEP2EBt8kRVBMRUj4M09JvO+x/lzow3SJb1QwP+GWsepOGCWQU6e59fxef+Lf54pxWw==", "a29aea6a-ab24-49f5-9781-da6b72796497" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a770845-fd8f-40a8-85be-c226e2af5ad7", "AQAAAAIAAYagAAAAEMCJ+z4e+jpuY5eFZ6TgWh9Aa5cp1U57/iNOn+wkTTcHFLIEg3kS8xzXmIiSWGEebw==", "813cd9d5-096f-4131-8aaf-e825c180d7b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bad23d30-70d3-441c-9366-30818f63ebd2", "AQAAAAIAAYagAAAAEKgf49ziDZ9OjLqK8EIeUwIZFPO6WQW4vFcu7UKvxoO3iHG1BYO9qqDr0+LpuB7bJQ==", "0112b170-c131-4891-84a1-755ba5385cba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b65c5c3c-8c06-494d-baf0-63481928213c", "AQAAAAIAAYagAAAAEO1QFFB5ls1pQn0Q+Lfm5d9+atYxshaUiOcmuPDTADwu20mqkiW/CLk7LFy4IBsVpA==", "9216c636-c187-4bd0-ad82-d1b4cab34240" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "697448de-9ec0-4b11-85f7-981c0e344398", "AQAAAAIAAYagAAAAEPNbSKDe/BBG/cDAlsX9o3RMMS4epUVjdC7aDYHL4PCujfBdJEYyDJUVuDzMi/n4uA==", "07260c67-6f16-4160-96e0-25ca39eb9fed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4bd62f7-a491-4900-8483-0227edc24c23", "AQAAAAIAAYagAAAAEGsjO4hw7R/RnbdO/K9Veqt0gIJziaqbu8rbfKB4g3gkN+FVnzfYkm/Ghkf8E+Xhsw==", "512a7074-9c9b-429c-bd45-8d1caadb0213" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec0a359e-64dc-491e-b334-18a0d0e0c37e", "AQAAAAIAAYagAAAAEJPt2lC2ndXRzeh2vB+5gY2ZTXY47YQqyTk9gySPEmBGYbuL9FcJienxS17WUFk9uQ==", "b2f74328-b7db-4a43-a07b-a977a3613e8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad1b0686-eb28-4b6a-b87e-421588f87fab", "AQAAAAIAAYagAAAAELNIApaV5GD4RUoDs5EXFGYJOXuszxl1MzEwpE/aJURwW+p3HGu3Ov2awhPrMH4f+w==", "fed7bb11-4478-4de3-b9b9-e21ec65dfe2e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f4236831-f218-4f0d-9b8b-eb8289bf11c5", "AQAAAAIAAYagAAAAEMuye5X/iagB73iIgvAS3Ca4xGkzl1+P3dNPniVLzx6c4ACnyD723kOnOU2KgY5bkA==", "df3d0652-1cc2-4c3b-94e1-aaba10509731" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "42db8bf0-e442-412c-aa71-e4f09e624dbb", "AQAAAAIAAYagAAAAELtXzWKu6PkR1eaBvhAxChUujj3tJ7mSzASeOmDQ7tkEsOSMv6zrNSF6sD15khZAEA==", "17ead69e-b274-4777-b900-28b71771232a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "534b3990-589c-4fdc-b567-d9384a8bfd71", "AQAAAAIAAYagAAAAEAidNZki5cSfeQOQLZOM2T47JYdAbqsw/wNUF+WpyVEKHwAwjocZuKaPfiwgs8mSoA==", "d3e9cf68-d98a-47e2-9712-cfa6d97b2af8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8d9de4da-4756-459b-80d3-c78be51d3993", "AQAAAAIAAYagAAAAEJqLYhpivsIg1mEKeXAc6YE/ph/vVD/CxcCLMgq527h2WJ2sV/PuRKaUsVeSEr/XZQ==", "590a76a8-9b15-4f1c-be91-625a9f224623" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3dcf9132-4a48-40c1-bd2c-11ce186a01a1", "AQAAAAIAAYagAAAAEP1Yk9w31fB97RgdmTtw5iZEZYYpptIuCIZvhLu5beniKC/Or3L+rizoUKXxcEEYbA==", "2dd54ff5-c1ed-47cb-bfb1-1e6ab857c697" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "583fb877-3ba7-4366-b04d-17e94ad51d2b", "AQAAAAIAAYagAAAAEGyBoxf9NmLfevxZvlyplVJFjxtY3LPvravDoABFu52QM+UUpYveH4RD8ZlHuq6qWA==", "e6024541-9dce-47a9-a4cd-6cb282f505aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "871f6909-ea95-4dde-8629-922afa4abb27", "AQAAAAIAAYagAAAAEFj6X7n2K9WpDeaCp4On3tr7WRaLAq9alFaIxWJwlSuVLiLyOpLKbedf3MdDrzJllg==", "28cd1f3f-54a3-4c58-9855-6fbda9155846" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1e1c4b35-fb10-4cd7-922c-71ad510437cb", "AQAAAAIAAYagAAAAEO04wO3uATOVNrRjbrg2yFauBDi2ezgIJ0FaNCZGzPnTB/p6ZQv0kNFZn7TMHfc+EQ==", "9a13c470-78fc-4302-ac9a-ee80ee7b8bd1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "11b55ef0-9872-4790-8e07-257437b97e30", "AQAAAAIAAYagAAAAEDYWDGgu+fNpVyBG6EA263S11qXsutS9R8K4cgHaFueVE15y+kmso9udeyJj4Q6N9A==", "53302bf3-cfb8-4ab7-9c90-eece432352d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8de3007b-e727-4835-b7f7-c4ba1dc68127", "AQAAAAIAAYagAAAAECu5LS2aSQf+eqBo/droR/eciOU2I2qO2WPnCoBXhhlCsQJ0veDPofYyC5jH/zvNdw==", "8833af90-e690-4a8e-b87a-027b5e99d42d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50682a79-408b-4ff8-9173-9f025903de91", "AQAAAAIAAYagAAAAEIAX/SMZTfxk4WMt/Xpoe0tcBmbOBbbsnuynaWrKs/THXdmHmbMA8HQ+IVj4555n1w==", "bfb80438-77b9-4379-9f7a-0f4811329319" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0d569813-9006-4e2b-b94f-807bbfb04f04", "AQAAAAIAAYagAAAAEMG2NR9YK/YlsLJgP8aLUvTXW0jtvQTEqeu+lB4xHbO6/MmmgULAIxHZg0KLUn9HoQ==", "2163b068-d4f7-4b39-8a5d-a5fb4ef4541d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18909f89-c223-4ab6-ad6a-963ba8a82e74", "AQAAAAIAAYagAAAAEGrjDScNB8alaHprahjATu+XqTCp/AvJ45L2CPFqrSjAJHpYu+vhfHZRiJgCnRdKwg==", "03fb13d7-6eb8-4295-9e94-c50105c9d0b3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2742cc97-cb5e-40bb-8460-e7136d1a4b95", "AQAAAAIAAYagAAAAEL5sIrTGNtKqf70g3dnEhr5Y0Mg7t7xQ1GMyfMK/H7IZSXTdoBs0K3pPpjSlFR58sA==", "1152ffc8-3018-486c-9f5d-2bb7965390f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2065eba4-e15c-4193-9f92-52b2af692eb4", "AQAAAAIAAYagAAAAEAZ1ARtOJUc5ELZiJBxkSaoF/LFtjvsK05RW88px7B7eJuSwfTZuKPP4wNwupZUZ6w==", "a7a55b2a-474b-4925-b814-48779151ab91" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f14f855-2944-49db-ad4b-a2b1c8b100e7", "AQAAAAIAAYagAAAAEOtxbglkPBsznBlHzoilBt+TQpNZ3BDvYpnKTkRBVi/VUOTulsTldJIyXZSUZ/ZPpQ==", "a59a53cd-4f7f-4c31-9afd-1a85227d870c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "97f11fd2-3408-4601-980b-a0949c693842", "AQAAAAIAAYagAAAAEK/e72zYjSpfJxSVUhAxasmCLdwi3UvxAsNKY+KkaVCpj9dmci/oTs/wisEqWnK+gw==", "865acce3-5445-46fd-8618-70f47ccaae9d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "70924978-38a1-4639-be62-7b8e8112fc28", "AQAAAAIAAYagAAAAEFz94a+LV5+3vD7POz7e80YZxcsHT5juUfiiV/40tIqRgTJL+xhaA1m/xQCrVuu+lA==", "2c2d9dc9-2674-4cee-b0ea-3edb8ab28443" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4c1ed53b-abc5-491c-9594-cc7f2ab4e00d", "AQAAAAIAAYagAAAAEPvtkL3aI2GhVifKcZXIJ70TFbd65IP3LgoDu7dTz+1Odlgt9nv6yLTiAFL2JkNYlw==", "c55b0a46-008d-436f-89a4-56ee3c2ae0d4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f8cd02d0-af0e-4bdf-8def-09c0f9d4f9a5", "AQAAAAIAAYagAAAAEB08JQzsmS4IJ1MuB+nYpK2h8L0fxP8eLI71e5xbHgZQKDVL4daLcqbHJAKZMPGkVg==", "8bdccb97-7bbe-49e9-9909-5ef6cf510c3f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "613833c6-2a5a-433e-86e1-1672394934cf", "AQAAAAIAAYagAAAAEELAJR4wM5+X4fUgW5Hu4u74ia7ziFKLUQuX/QcOtBBtudmoKvlmZGwz5Nd7mZN5Rg==", "72ac0558-6c9b-410f-ba6a-38a30dc358e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "08f49d0b-613f-475f-9814-0872acfcd8fa", "AQAAAAIAAYagAAAAEKfSiPh14DSwmyfUtIw2IKlNWP2aVQ8TpSpWWmK9O1qfwmEHJlzAnEW6Yyd7DIVTFQ==", "1af26039-985e-4aab-8e30-7a12f1abaacb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8dba2315-4a6f-4c4e-b3dd-d76ea5525e8c", "AQAAAAIAAYagAAAAEKF8ItAGmrio9QFB+fgMqdg4Th8A7rYd1GHtP2eo7JvjQahPG4tOcDImNCbxsAzaKw==", "b7389315-f8ce-4841-ba8b-ce76c39de9d8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4bdceaee-d5a5-4a86-a899-243db180777c", "AQAAAAIAAYagAAAAEMjG/ZTvidxiy9693mqf+6N8CdA9ugAG2ze0B/QRANYXK0c4CasqCZePsil4Ls/pzw==", "97fbd71a-4442-48c3-8fdc-aa770390a85d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "295cd0da-0c06-4928-a0e7-332c2e0cd56d", "AQAAAAIAAYagAAAAEM7imMxz7KqMnd+vGrTK0Y+04lNFHRd4QIRr3g14C+L2Vw3Pak4XFg34c6VxdSAyxQ==", "ad07f635-56ea-4bf5-9d4b-1f8ba8a64086" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7f5ff175-9a3b-4e2b-a823-f11c0d074192", "AQAAAAIAAYagAAAAEEW3+M0wkvFn8c/pKM4EBvsX5U33upAcJCshqgYAQP4lYMuvTNhOxkwMkN0m2W1ogQ==", "6454b561-f139-43e9-b853-62f756a0e087" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8b642b2c-5132-4637-8e4f-f461c2873631", "AQAAAAIAAYagAAAAEC2hkQBl4r4eN7sbLEM6tVshyRrt+7cbEMULDO5XqJRfVHF/6AnQp+re/WGXxC4NHw==", "08bfa393-29fe-487c-8c5f-57550b87bda3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f1cd6ec4-4928-4998-af0e-5a37bd4df514", "AQAAAAIAAYagAAAAEIlCLzsudM5vrA+eRXQr9bVnMiuMwqvP447d7WluufNXujbJw9HRjymaGfO0A2gFEw==", "5b0efa86-239c-46d2-8125-47b1e460a3f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "62c8d4f3-2b5f-4f90-b539-038754b30a72", "AQAAAAIAAYagAAAAEBo4B2uNnNSn2bY7S2U7aJLnhdPpu45lusnPw15/F7RmM+cssp4nU78EmdsgyGaXoQ==", "ea1aa7e0-92ec-4423-beb1-55651c0b8c46" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a29c9145-d50c-4cfd-b3c9-144f278166ff", "AQAAAAIAAYagAAAAEGJ9Nn9rCLKBJsFqeES/H16VMflrxNZIK2qO1KjaZ3ahv0XQazxrVJpFGHvnOlGdOw==", "7c98efb2-97d5-45c9-b812-494614ae64b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3055e344-61bb-4581-98ea-59dd6a0971e9", "AQAAAAIAAYagAAAAEOAcliFAM2cWDon6L1sK4cGlCUMXvYXLBA7P8GCpfWKLCYZwXbXhbKh0M3KV8hgBDw==", "c5fddc10-023f-49bf-9b92-b2086b244a99" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e4e06c77-6266-49d3-aa28-a2dd03f81d58", "AQAAAAIAAYagAAAAECX/+eQQY2nAeWA6Zk0oSRW08Ok23KDx6cnaTd5fMnJc/9/uwaDZ+x47GihLkuZYaw==", "3399df42-7f87-4398-8ab3-118f162e298b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "456f88dd-f7a8-4ded-bcf9-d2fa2fc0d85f", "AQAAAAIAAYagAAAAEPcqNVunpWKsJghYwQNaEI2Gkw1kZITWosL8brLpVUgwifOBUuipBh2JbmzX1q/tuQ==", "063097c3-a64c-41b4-b873-08a69447ca8d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad1b4202-fd5d-462d-b1f4-e9de116d8fff", "AQAAAAIAAYagAAAAEPwDrHFx4c1iZ1oONcFD76L+HvdPgR+UW7/WbliT7FhdPxUZQldpIKTCEF9si0UkXg==", "b68fa2e2-14ab-415c-a60e-bd7fd66d060a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8d083c85-c7d6-4b98-913f-42337a65d317", "AQAAAAIAAYagAAAAEAmuUEi59X3e6a4uQle2X+zdtLpO4TcPT4jEQIW3rvWdUi98ADOxVXCUmAr0rfZm/Q==", "abf3418b-69da-47b9-b22c-20639e780006" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7074c9a0-a7e0-4fd6-aabc-be92f53fb23a", "AQAAAAIAAYagAAAAEF4kP37B9JEslPkRJP2uLSK4NdGYoZox8R1kRKQ1U9taW7T6QUWIqCSD4A3AtSeZBQ==", "fb70c12d-655e-4616-bfb3-ca84ff5f4e44" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8e85b5d4-1951-4f74-a177-f255ff9772ca", "AQAAAAIAAYagAAAAEMPbQBszqDnoOzqE/CdZAu2vuIXb0+PyB2DSW+UW2HRhbn2cMlQPjBN4usX4K53zKg==", "848e4dae-7eee-44b4-a245-2d219517ea5d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "55ca6cb9-25f7-44da-a345-774980d475f6", "AQAAAAIAAYagAAAAEMwyv+Hf/qwFBzMf8N69cDvjw2JVE4M+CHYp3MhNPLsNliSUFDQOsewSx9i7BdxzSQ==", "9104fbbd-a11d-43a0-a901-d84d3fc5a695" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aac63fb1-a729-4b43-a916-31fa18006848", "AQAAAAIAAYagAAAAEIPib2CX22lmYy3QLG3lH2OIjjujpaC7uOUXRfEEHomCsLcUJOXCz1OgWhfCYc4k4g==", "c150a10d-99ac-4104-bb47-e242aed5deee" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e849b242-f4a0-4fd3-b386-a8606dc2c7d7", "AQAAAAIAAYagAAAAEERdDuS5m/4U15vOa3+crnME3PuFFwni3Z9NlnrJk04UxJJ6c2vs/6nIm0yXzE8Eyg==", "7c3852f7-e370-4103-9302-8e65cbf188e4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0b8b415f-176a-4096-8a1a-17f8eba37531", "AQAAAAIAAYagAAAAENLb0AvcVh5zK001LJtj8t68+lo+o6Wzx+MFMG0dJeb3CJ3Tv/a7FLj4lgszUhBnJw==", "78298210-c19d-4a50-bb59-69c58bb34d58" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5075f809-d71f-40f1-915c-14084e731e2e", "AQAAAAIAAYagAAAAEAmL+ek0M/yr8fZcLnbH66FA/he/IaXtM0hdGLNV3+a96/W30ZJqzhnNHHOKutv1Sg==", "6059f453-6466-4d84-9346-b86e53265950" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "63ecea3a-6cca-46c8-be97-4bd660eee804", "AQAAAAIAAYagAAAAEDj2zlayVq2ZnjPhWY6ULdv03LT3IQX/l+psCwYrUrUNucwF6fgf5O++FJjszOTr1w==", "ca535be8-4b01-43e1-aa8b-f68079cac59e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8356f72d-7a5a-43da-91b1-a886d8f418e1", "AQAAAAIAAYagAAAAEJYT6XYXUAhkhcFdUspBIBETu4ccHXPIvYqRVCRsiq/iq8ZT0nTTx0ZkrUtqR1Nmuw==", "112431fe-0274-4673-9628-7b35b41a0973" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "926a1e41-a4ab-4d6a-ad0c-5f1988233b42", "AQAAAAIAAYagAAAAEGvYaCi8fBRjsljnXQCahLO6uiAxxnSxbk+s3TekIUCZWKRJhCZ8lYuX/kL4XY/Ftg==", "21f54f1b-c3bf-40b1-b3c3-16e995a89cfd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69562d84-d367-42e8-8530-30901711f15d", "AQAAAAIAAYagAAAAEFaDloiJz5O3M6xeQSSDw1lDNlfm5Fj3ahyA2elOLWSOJUducFVETeo0/xVAnP8R9w==", "61caf612-6277-456a-a256-bb5208f941cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7a7de1a8-8c05-480a-ab18-b828d154de79", "AQAAAAIAAYagAAAAEECAsGkzeBy4YwEmAn+DzxbvL4zEgC3Bgiy6FOrXNR9EHVHa8D/RK43OZ1dlxYgtCA==", "32e2f303-1a0e-4ad0-a5d1-1e19b871c870" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fe8c3009-72c8-4733-9abc-a99d4440a669", "AQAAAAIAAYagAAAAEEDoyUKmfTVL78DQFrQVS/9gjqj87RTbuKtYW8ktzVMGCnsfLN2rut+UbLlPX4cuyg==", "a1b894c3-0e50-41f0-a077-e03b5fe1c3cc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9beb992a-04d0-4434-ab49-7eaa75b454bd", "AQAAAAIAAYagAAAAEJ3O7qKU4TdceWE/OKudopv2RMsAMU1iZymSHgwXETuI4wf0Nna24MM275rMciR/9g==", "50ceb116-17a0-4bd2-b033-e96f30c58446" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "766dd1a6-58f8-44f7-81d9-8574c2a8d0b7", "AQAAAAIAAYagAAAAEDWbOunzcHeR5kKOf2B5WMY1OjmHLXB2trx8juQbe81J21NzzW/qrqtaXYuM/vJIfw==", "c218f2f4-77d0-4552-b779-b96248956aa6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5671306-4857-46cd-8d06-ed93876f7c5a", "AQAAAAIAAYagAAAAENZq3s9BI1KajsgyXsXVJaMxuHjN2MwGAcq8WMDIT3ywgZfR2m3bXdPZiHUFd7gPFQ==", "26d30917-683e-4a98-b245-3ec030b19d1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "616db0f3-222b-4754-bdfc-565d801f0740", "AQAAAAIAAYagAAAAEP9PVuiicYQ0J9AEuSmn3UiRkqyr99pVQ6AFFmJd5o/IngZpJ+5u+F/ERjfcrTgiBA==", "b1c381a4-abcf-49fd-97ec-e79ecd6a7bfe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3e8cf76-09f1-4d2e-8bdb-b160b08ba3a7", "AQAAAAIAAYagAAAAEH8h+FhkPm0u8lYcsHl2s7bpzjEfPVtNygzHeew6l4KlBl1rlv7i9A2JRYNkYrQrVA==", "5003336c-ac19-467a-8351-df759ad52d2c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59c27dbd-69c1-4523-8ca4-87f62c92841a", "AQAAAAIAAYagAAAAEC/gozLSCc6qjbUUGLpeVX4xqkooQFbYWbseBklvTUs3gjZ7rHHJIKl5wP6FMr3IQg==", "4943c61b-1a35-4166-be0e-97bb5b1a3e7d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f51cb3bb-4e4a-482c-812f-d9b1a043ce32", "AQAAAAIAAYagAAAAEGMkZpcTgKW8W5Z+7rEo4tXkN8wN/onxN3wdvt8kY7xMLqjZeW1wliUG4lxbFtbYaA==", "985a6e39-3808-4e82-8e59-48beae0211ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6320559d-429c-4a07-ae6c-1afb44891a59", "AQAAAAIAAYagAAAAEMvefW6VMTr5/GJ1XqHa+s5TWZKwAWgqH2QOkQhrKmOr8wRTS3yln39XB5E8CyqDCA==", "e4747d55-1c7c-4d45-8c08-2c5e51ad1125" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ad22cef4-b169-45d6-9525-11e04c8185c7", "AQAAAAIAAYagAAAAEIYXzRp4CvyCSolq1qMCMTpWyNrJR99FSg/KmQTTCJAdzvU7iaEA7FbNzrdb47FWgg==", "fbe61a33-0f26-4797-b149-05df0428c41b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "40b10703-3303-4d4f-a321-bf8555e5b419", "AQAAAAIAAYagAAAAEBH4Dj4ybZF4qUr8Mn9/2w3bV6Kdz7NRFT0iE4GgNWnqpM0S6teNF3FATz4hOkeKpw==", "65bcfaf5-4796-4736-974b-8354076c394b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "da0950df-d90c-475d-b435-07be8e4ddd3b", "AQAAAAIAAYagAAAAEIfjyjBNg1wbzJwfUDxyaQvd1/Ux6mLfK/V1RSe+IUKxaqeLvCeFRfnS65nWIVx6GA==", "628ee6eb-f7fe-4c9b-b37b-bb657d9d3c83" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5e49c4d8-c197-4678-b3d0-049c9a649752", "AQAAAAIAAYagAAAAEA0NMJJtArqdDygherv7UujurbfFVyKtRCSjo7pxW7N4WnF0yDB31ulm/IYFZ55ziw==", "565a7308-ea37-45b1-89bf-77b9656bf5b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc5c223d-b161-46ad-abc3-325b86018983", "AQAAAAIAAYagAAAAEJAAY+0MQV6CkDRxfuqv91tje/HGqGZGhe6e1FmPw439uafrZILVd6lmzl3AYHwH1Q==", "f4965349-ecc1-4936-a2e5-3c85f993d119" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "93797748-68e6-4c43-879e-a3341486d3e7", "AQAAAAIAAYagAAAAEHJB43QV4pdQvAYKhm6Cc6Zuygy50MPo4viGPV3MbJqhGc/PYEL14QwW2xS00AAzhQ==", "b4c61764-061f-4c61-997f-0f4b90951d4e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "98fac068-885b-4cf9-94f9-d6267f46e2a0", "AQAAAAIAAYagAAAAEPkKAa0EU4SCFqRmdoaGcHt5mDjnM+LmfX5dg064jyu6kNNTS9JSgpTIdxxwHCzWqw==", "7234db3d-bdf2-4324-b145-5ce44fae60f3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "044ae5fc-01ed-40f0-82ed-0d87392ace19", "AQAAAAIAAYagAAAAEPFvXS/O94jtr39RjgX5skQtVCIJpFYO3m+WTkH2xYfABVg6lgX3fssRIpYtAn8GLA==", "8c64bd79-b990-4903-b651-ce0c225bd439" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "22cabead-ac08-42e6-a166-e3b683a92292", "AQAAAAIAAYagAAAAEESlMt9En3c9xwtboB1W7YJcSZRMaRsAB8tWL5GjNZZX7lrxJpsELstgHa+GkpSXDQ==", "8e781485-8338-4528-a3b1-3f75e1a92cec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10c5f6ec-4766-4bea-8b2f-91aa3a61b939", "AQAAAAIAAYagAAAAEG3kH/dZI/mG3KKqzMdyQ49ZwMO1BJZ110JJUtWYB3kV8RKb93hKigTjoT79bwOvww==", "147c8b83-d85b-4ef3-8435-24061ce25388" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2bfdc71d-134d-46f2-95b0-e9576973b2e5", "AQAAAAIAAYagAAAAEHW3sI7HiPeBHtNwfcdrse0CLv1M0D03fzk1uOk+dRnheuOjs4qATww1VN2xWDnKDA==", "b79f1ea7-4da8-48d6-9846-fbe29e0fbe5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e51cc940-b169-4dbd-b263-2a242fcdbafb", "AQAAAAIAAYagAAAAEPYIv9D+wsaKwtze5CauFw/X0v5nfLNzuojytY3ezhnfYBwWywAldePCLVzq/DMQww==", "020d6042-ae92-4c1f-86d4-8c690d6f820b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3a03e6a6-b5fd-4212-847d-c7d3d8ac9c12", "AQAAAAIAAYagAAAAELEQVs6gWlrL7jDzBpx6RXPu/IaTplY+Hk8C3SSK38Q7RKPv6cMKNxR2d+mFKYknfA==", "0d833a13-8c2e-4b6e-b71a-bd3d40d556e2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "56997d2d-429c-413b-be07-551cd9d289da", "AQAAAAIAAYagAAAAEGoCyV5CYIzd5TWkHsoYtpwQe4o5bn9snF2iCuaSFb5HcJ9H8J4dEwAnp8g+TruvCA==", "222d29a2-7bae-42b4-954a-64b20ebc757f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a6daa167-4a24-4760-bb09-fe2fcdb5a10d", "AQAAAAIAAYagAAAAEHvUK1RJ+o/OoqRpKkhPlz+YCIFJ3RrD6eGERSix+xqiJq8fSH234ROBzXBXyjZlYw==", "15e703ac-5d64-4230-a9f3-23d26878b7de" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a451473d-6181-400a-b7cd-26a11d942395", "AQAAAAIAAYagAAAAEOaB9PuSu5CXnbw89d6H7RVJkPG0Aval9EBXs7hVqiPnBz9qLsab0jRjAHygy77hPQ==", "89bd8ef6-e2f0-466f-9285-150029f0e4c0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6296362f-b69c-4e90-9c22-e81dcd2ce1eb", "AQAAAAIAAYagAAAAEFzIIAwgrAryzjj9Q/ZWEVlXJ3hNVMfrLeHTzUrPgZr392cnAJSioWv/Bh5dlcp9gQ==", "c3224419-82af-4b41-85ab-4b08906b140d" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Announcement");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "78371ffc-d892-41e8-b274-95dd9223754d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "e9d6fbef-0207-4021-9e59-db6b884213b0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "f78eb57c-3754-423d-843a-6698eaea7587");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "ec50af17-cb06-4e60-84e9-d56e7d505684");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "f11cbfbb-ad6b-469b-ada6-f67cb4eb739d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "e10fe13a-eafc-4fca-aa22-f99581fd3ca6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "d1ae7de4-945e-474d-bceb-041d593863a6");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "442fac7a-b112-4c1f-aa7c-0df956d867e1");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "1365b106-0eaf-49a8-8d24-36cacceeb0ac");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1628010-d607-4328-9ea9-bbb92e4eb578", "AQAAAAIAAYagAAAAEJiWdZYE7I7xnwloYzTYbTq2/us5+7gxZOqfOBfgAxURPu32HJANw+aNvqYdbTfPMg==", "79b6885b-8f7d-4b3e-a8f4-3f1110b57b1a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3612f5b9-8766-4fc3-a282-df9cbf70dfe3", "AQAAAAIAAYagAAAAEBFmondUyA6B5ehRx9stYl9w23+aYpYMGodfKQAPxNxG4fiBF2uSHJaMaJLjOC0Dcg==", "7a4e0400-cd25-45ee-9100-470f48614041" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a7b2f2a-e808-4833-992e-d7748e334058", "AQAAAAIAAYagAAAAEAsMklvMpG/Koh3cIAQ2Rha8n1qpHDHDNV+g6TTmKzRSTyHt6//638Kt8tPd3isGLQ==", "7bc5a6a9-c599-4c14-80d7-dbc750fcfa68" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "12f58298-7158-46ff-ab35-ec6d5d9ea9aa", "AQAAAAIAAYagAAAAEJKufwPhl8h7RDeoM/fGPXj+HdrsL2rbgn0hrn4QSv+706mNMrIc0fNFAjW8iJKPpA==", "ebf1da89-fae4-4844-b273-4a39793159cf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eda974f0-4518-4b13-8cde-9d734f960060", "AQAAAAIAAYagAAAAEMK1mnsykPjnvmIWNV8c+1jElUPtT3V1DejOgaPc+qI0AptahgZ/YhOXRVpiE1OmiA==", "81b0f92a-0194-4b7c-9be7-1408db842052" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "18a066dd-4098-4adc-bd68-a41c035a457c", "AQAAAAIAAYagAAAAEGNLUnklZq3uPcuc8IygkMXV2RkXitUizG3Wkrd0/GX5WRThR68o8shkW96FMA8cKw==", "39005e82-435d-40c9-a7d8-5a4d2adc8e50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aad6f154-baf1-409f-99ae-131d9ffb0f09", "AQAAAAIAAYagAAAAEFNhFn2r/tdeEtdCpO4sU8sf8BWokuFxGYMqLixh2EXyx2DKPQFtLLFHnHJ1HEH96Q==", "c22aa0d0-2d61-477c-9773-4492f304f253" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8eb43c05-0cdd-42ed-a9ca-8f0c3360f863", "AQAAAAIAAYagAAAAEAbc+8+rG3A/XdVRoIhiBU7Rv3IwG7VTHX9yX06grdyugZCWqvVweEd8VA2kze4m1g==", "0f26cd55-f357-4577-ae63-02eab964e010" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d8f7497-a5a2-446a-8415-e3ff4dcb1b5f", "AQAAAAIAAYagAAAAEHsI6EDtObWAttBBuXII/WhO4PjcX2E25z4umjW0psDJAah+EcShfkQYKTVQv34MZA==", "b3671a3c-1dfb-46db-80b7-1cc5da6e8f37" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9e2c75c5-6c48-4d91-97b9-5056a89d26b4", "AQAAAAIAAYagAAAAEIgbS0Rve+7Rpy9JmTLfqq8ZCYKhJfR2b1rqW36OD4n3eUpzpD7Po/9JoiGU6yvmQg==", "5af9618e-ec78-480a-a963-eced85aa2456" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "73b452c3-aa10-4045-b7d6-a37ce26728de", "AQAAAAIAAYagAAAAEE+sdtb4HXtD4v+H/qb/MomPqWbVxJDkdovinEg95IPss3T6R3EZHdUZaVml5ws0hQ==", "da905ec2-bdbe-44e9-9a92-3e53c521391d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "90daf665-ffbb-48c9-9907-6f1033d6f69e", "AQAAAAIAAYagAAAAECn0+2GGX/Xc9hpf1kRoI6aCROSnDr3s7BtuElHsPw4BjZ6GRoSo4CKqOUNjVSoXQg==", "945bbee0-7b77-4d3b-add1-b2e6d369d41a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6721e987-a132-4e71-a3e9-afbaf794b759", "AQAAAAIAAYagAAAAEIqnAbBSXX5KDa6uA8xQpUhN7Wlqkafq2Ij4jjpp6ebOUQn6rpvpqrA6+YtebxH90A==", "5bf5fb68-f13a-4d52-916a-2573bc240eb9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d5088a95-aa9c-4c73-ba8b-1ddb48e55292", "AQAAAAIAAYagAAAAEDnTFWFxBYr70yJf8+zBgr7jYKCgj0ncgPZMQ6RlC9rHSJ1tSfIrXhnZc98gOFLk0Q==", "d35443e9-a629-42e1-a0fc-f02ab179d017" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6215b82b-f904-40c1-8cd6-c501d7ae92c8", "AQAAAAIAAYagAAAAENmRbo/GSE/tihNUpvNzJF8Rxv9Gp6hW9I/Jc1BsfkklbVQiQ7IuTFcYNT6pMjUJow==", "e2ddb1a9-805b-49f2-bc2d-d8f2223e6a13" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b31016de-7794-44fe-9d6b-d1bd0b7976ae", "AQAAAAIAAYagAAAAEPwGBRsLpxaM4x5He+PvxDtxaOJu3AZAhHNc16NvDs+23+8uYJWTMUNr2BqduzeGGg==", "a3323798-4c33-4142-b6f1-b3e2dfd89faf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c9f9da31-3557-4a9d-8b38-3f85da2e09a9", "AQAAAAIAAYagAAAAEA9aUemAmUgbT+C+6pGfLv9MmZ4ES0bt4g1SanD9YpTGMmrIM+fUrTvipYcVVfluQQ==", "b871fc9e-5112-4d7f-b249-17b1f99fd7fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "026d8582-b552-4575-8dee-5ac697f4c849", "AQAAAAIAAYagAAAAEN1p5wGQ/KO69j3mtwdybZJax61Ie/3FD1y98K2/xdcm7okYPlrsilKNrDM/91tozw==", "cdc7a4b5-1a64-4e66-9d35-2d85f2ec720d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea05c95e-7f91-4950-9f2c-23906d0d9f63", "AQAAAAIAAYagAAAAEBJoENq4WFVlOwNnupHDA8RB9aURCj+Kpu9yWG/eT/ezaGEMbpBi/o/gc0b0IBHGLg==", "9d6883cb-a9cd-4ab6-81eb-54183141be3a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a9f41324-b96a-4a02-bdc0-18ef0e48209e", "AQAAAAIAAYagAAAAEIACvnfafHFBOg2MfvY/ERw1gqwh3/GiFjFcseIGnJubu6+3vt/AgJ6fX0LoS9pEUw==", "5485ab35-18df-4acc-9493-6ccb50a197c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b11dc00f-7ed1-4cac-af7a-72e87462d8f3", "AQAAAAIAAYagAAAAENATX1AimSw9WUMtkFqrvVyXBG1ZdSZUIYISVrq0PSchj5y2Ra8zqqBag55PkSFRLQ==", "93b9d39b-1898-4ad8-8e95-5b94d0737aa4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba4b34a8-1c9b-4383-b016-0a35cc961fcd", "AQAAAAIAAYagAAAAEO3QXqqJAtUBGkZuZ8W/oHFC4OW6soPTf+N0O9cSyqWVEFC0ujc8nXxex7htEKgyZw==", "71b99c7f-b764-44ac-b8a2-52b0413c5706" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f592f328-c20b-4198-a886-30e848c2579c", "AQAAAAIAAYagAAAAEPoa4qQ7IaVO/mgI9Ix3JzFbnb0K1ck3DQmWE9neipxpK4JR7y7+jRiuFPWFWrGQPw==", "4b7c2d03-c33d-41d0-bd68-7f6a57cf536c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "323196f2-fdc4-4d12-a74a-293b26b9534b", "AQAAAAIAAYagAAAAEAJNfEUqfuuE2dJ22L6J4F0HX4Mxqsusi9e6fWXcdFYH4zXoU8PBXBom0yV2VCC7Aw==", "57137233-73d4-440d-aa4f-9a8f1cf458dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f745d1bc-adea-4409-a55d-904acd721f2d", "AQAAAAIAAYagAAAAEPGlDN/o+QfvNH0KbLP8ZgbK98DU4oj+WL/zVNtgloupZY6D3N/HcSWw5t0fVo4Tjg==", "115df6de-e2db-48fb-b401-7a5ad7d7caaf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a9f9a673-0ca7-4799-aa69-af91dc4d2c57", "AQAAAAIAAYagAAAAEMp/kjSlAgs1jrdNMog8YmPONLWuayXWy2e1qRsQswjT88Vh/gS3dA9Ql9nxrBBvcg==", "a8ca5fe0-e2f1-4f1f-8fc5-e1f0d47c08d2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "76323cf2-d2d1-422f-b901-28e688cb63a6", "AQAAAAIAAYagAAAAEJn4TqX6qPZJJ4C/1nmkTH5EH3OdVN8DPaMpXPCDk04Lv58ZF99GS9tNfOGQFaMpcw==", "8062599e-8cff-4b85-b5a9-ec1fba70807f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c68e89b-cf15-4e0c-9964-b3713ff47edc", "AQAAAAIAAYagAAAAEAFGWNvlfAK8VLhQ4Vf7euNAWDqmf45UHLFo+pmptQU78jkORCEF2M3EuQblP846nw==", "8d50c451-c799-4592-abb6-092631e1c389" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd7b5210-0666-43b5-9f10-25c20de13292", "AQAAAAIAAYagAAAAEGAlJrruxn/KxoKKctdgDoBBeF4g1cmMcUM6onNfY3+In01jRizlEHP1zqb0CjrnTA==", "a9b30479-2797-4016-bb95-fbbb45b56ccb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "17d0ef12-d316-4364-bd86-51f7cefade0f", "AQAAAAIAAYagAAAAEF6+0D1ho0jTUen9cDD48falX0z8OT5lq4LRGzQDoENDQApB1ASedcal7nf77mQEPA==", "6acc4150-6f26-4d4a-9400-ba6709d51674" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "32e5bd97-eb23-4010-8357-71347ea93809", "AQAAAAIAAYagAAAAEMRyY0YAsw+WqRcmjcmt3Zhe4Bz5bbg6MtqWRg7XBH6R9N27tjnFHcOwQA3zr97r9A==", "0e795e33-06c8-4ac3-9fd0-89ae5d0ed8b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "900ecf45-01da-473b-b2d1-1a2c74ac85d5", "AQAAAAIAAYagAAAAEDSUtjJCtd4HuVstvRYVnCfxB86j7f8rTBBT8HBs/omfhJLGmdjW2/0ah5kS1AJ8Eg==", "a2e16247-cb43-4c5f-baa3-13aa04ec6407" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f100a602-c0d6-4906-bff5-a2ae5453e72f", "AQAAAAIAAYagAAAAEBlDn6MNW9KP+AzhpHogf+mcXZSKfcCYSwPShBB76eVONacavaXN6ymL9uSIRKFjQw==", "a322e30f-256c-4cae-a550-44de01eb00a9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c60a10a6-2690-47b6-9cad-7a474dd17420", "AQAAAAIAAYagAAAAEKB4j/vOsXbCC6y+avjYuCGwSEWZjp9nICucuShZlF9xOCo6VGyus57jh6xEVd85Qw==", "a0ceb281-4793-42b9-9d46-646babaea10a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a2cf2fd3-d7fd-4079-aca5-7727276459d2", "AQAAAAIAAYagAAAAENBUgn3iGlTFEYF0hW6K7z4vj0WpYxXeNIZkim6DC5KJTRTszwg3dCI3kOOxVanm/A==", "23e04388-402f-4b91-a4b7-f7a99f88d2fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "59dd7fab-7af7-4891-b2b5-40b2b0cf3b07", "AQAAAAIAAYagAAAAEOq26DHTZMeiIi/yvu3gMdtpvXwtLQ6Ye9kYNM+IxS7H2IQW4jVCcQe+2fsQ5u2omA==", "069d88a8-28ce-41c9-8d78-43b147f281b2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e11ba46d-3b62-405e-a64c-744c134c55fa", "AQAAAAIAAYagAAAAEIfNiD3wr8dQuue+vmqgH1s8fDOYRsGoEKMjObxQ5YBcy0M6AnZ2fY88CRyOeg1xhA==", "8ba570ad-a2fe-4e1a-a9c2-e51c4a418479" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "12ee1831-0192-43cc-a932-ae3587ad50c5", "AQAAAAIAAYagAAAAEJrgeUVOIj1rg6x1DeyA3HHgUaxYa6qVe3xsWDvowtdfLsBskJhFqnmJcV3o1R96mA==", "8af7cb0e-18d2-4127-b590-a8cf2d0b6375" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0e7ed49-4ca9-486c-9241-fa2933f5ecbd", "AQAAAAIAAYagAAAAEMoTUM8xEdbtFOJSZJmdfOc/NVCG3Vah9h/YKGgMSU3rmUP5x+//30P1IWh+H4NAcw==", "0a69976d-0afb-4b88-a85d-ae14c4da8d0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "61c443f4-d27e-4d4b-a738-c9f0f7fd34da", "AQAAAAIAAYagAAAAEBR0rzsOah6B6UyOjhTfVXkW1qB1vO5XNhr+aL6H/Cg9fblcchHm8Hw2RXM1A3XIaw==", "1c3921c8-83f2-4807-8d41-4434a3fe122c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f4494b2-8aae-4436-885d-42d163d71e87", "AQAAAAIAAYagAAAAEG0rg8J9PwfZqfcm+TwO9cMANCZiqxAhz71kd5NyI3cEUUNDB6zKpnvAxlIQ15gbxw==", "1c5a7bfe-eae8-479f-82eb-5f1fc9f383ae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3c1b478e-aae6-4959-ba9a-9b3de482a8a2", "AQAAAAIAAYagAAAAEHbIpCDVE3qWVneEL6ci0cB1Bt8vMPw019sp02N3jgPlH1TvTqPoovUjH4Js6IQy4w==", "ac61b738-179d-4ec7-8546-52c83435eb7f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b3efc50-25b0-466d-a518-85309a8ffd54", "AQAAAAIAAYagAAAAEBR+DEa1s/vry4runS9PzDNkm2hun39eRZlWk0O5RkfRLsI0baihx7mAJ6syGOI9tg==", "339fb44c-3a1f-4f25-8072-7eb61fcd048f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "95257ea5-2b94-4337-a58a-779889aba948", "AQAAAAIAAYagAAAAENHq3Ui+wwKasp93lI7HDRIMcnv/3sbPGXnfdzkIn2AWmNUgcS+o+3LkefZdbGNzCg==", "ff1cda7b-fc43-48d3-a4ea-bd0ca847cca0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "eb91ece2-7117-43cd-b178-4ec93996e636", "AQAAAAIAAYagAAAAENy6EJpV6Y9TcRe598VY5N7AvvyNUWt0zZZUr5b5dZmnLttAUJe2xB5DjH3WJ8LOaQ==", "4162e90c-9f2d-40dd-a30b-c95efee80f52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bf1b9aa0-6a86-422e-9391-949bd0c64294", "AQAAAAIAAYagAAAAENZ5KV4/lNfxNQHeQvNn3spgZBE85UAubBgZhRXWdBOWpXTh7VhstFOV9b1MZbZDYQ==", "5cb9d57e-50ef-4cd4-b17e-c08c124f0f3a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9ad15ffe-d173-4918-9278-6b3663d3d355", "AQAAAAIAAYagAAAAEDK015xvFQSCgcFreHMW284u9AYJDkrAodXi/72a5RExTCNhI/GbJqKWM9fUMvtR4A==", "b9f5e019-67f8-4f99-a6be-f9da426c061b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1f667f13-a3db-4135-a781-401c06bebf89", "AQAAAAIAAYagAAAAEDlaSmPV2ppbZ33IstjxL3GYJubia/ZunvcPZwZh8xaAfl0m4iiOeAOfz0eTpuOLrw==", "7d2a5e6a-0842-4dd7-a28b-df64efd0f2e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0e77d338-b0bd-4501-a4cf-47e65053fde0", "AQAAAAIAAYagAAAAEEmDZmFGXN24YGJUI+drYun7vy5ygRC+kTNoOskeOdwP8Onyonmg10R3ic0k1EOR1A==", "12b19a74-74ce-4acf-a17f-2779762bc633" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ba7ed5a8-0665-4651-aa70-664e850fd22c", "AQAAAAIAAYagAAAAEIhBLbW/EIJaUnMuUdjXVv7shBTz776WYkhdyvBhXJktu9zvQgIUp3Rn/VvnldFekA==", "3b228faf-ba21-4a3f-9b5c-18770bb4a493" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e46c58c0-1656-40db-a0d7-cb1ffd2a1d07", "AQAAAAIAAYagAAAAEGJJIoeeMa+R77WInrqqd/YDbJgIprqy+3ZlA0VC67WpvOhnUntwuqnWFG9AiYCD4Q==", "b51264e8-82fe-44a7-bdba-8bddb8c04e7b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d2f066da-7397-4d30-bdda-c132c274d742", "AQAAAAIAAYagAAAAEKKYpRZSmYY+A2pZ1V7LUZGj/10rdSUNEY2cXeNXjSmjK4l7JY/J6FoWblA8JdElww==", "5a35c272-3a3f-4198-939a-378b4ed60d80" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "df39fc55-b98d-4861-af6d-9495798c09e2", "AQAAAAIAAYagAAAAEMvjy64jF+bl9JvbSIgM02uLdkJQKrw0It6e7G6YiAeEjHv/KFRdisxjXVqOhNmjeA==", "ebb35372-5943-464e-adec-2e2de64ffef5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "10f041e6-d47c-4241-b9bc-ff319f4bbbab", "AQAAAAIAAYagAAAAELCB/yKcFHUFs7m4N2wZDXh7adZRiKkiZDNoekzDgBw1E4r10Rs7EqKXJaBaDljVfw==", "2fff814c-5438-4ae3-80bc-5a00f72fe577" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "523a2c47-09a1-4953-81c2-d9e1661cb06b", "AQAAAAIAAYagAAAAEC3KnbTtD0s9m804EKcKWIfmFffvuXRVMtjT/AsR7yAIRwGIn9OUVyNp9HBNnJQaIg==", "1c3209fc-99bc-4725-ae63-fcd0bb7e8c9a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bd3d0aed-27af-4169-80d3-facd256c22d2", "AQAAAAIAAYagAAAAEOXXIsLc/pBZONPqtJJFVR85nhqaZFr3Hm0vZAKvmLt5rz4QvROlzULnXvygq9p2ZA==", "e0eec0db-e12e-4ad9-a82c-57e231286be8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "52b7d675-7f6c-468d-8ee8-fdd79b6b831f", "AQAAAAIAAYagAAAAEKaZycx0yrOyMnlqfxgzJ2mwcHJLE+24xDe6vAN6bbNLRvKoJehdEFkRldrid+zJ7w==", "c1370a0a-db95-4e34-bab5-c9128e18850e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e31fe5eb-ea83-4325-aa45-b4d2be4fddf6", "AQAAAAIAAYagAAAAEIyrSHrAc2/HMjzU3Vit7qq0e3tQJSSfC6Gp48RMql90iDvgjOxEAmotKzQdxBx3IQ==", "b44f3f9a-92b1-4e27-b92f-0063b6fcd278" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5d820c04-0f2f-499f-b668-ac743bc94035", "AQAAAAIAAYagAAAAEOjKA3lAgSR9sUaLGu5wk01Tkj7TdYMlB+ZjVGS7QkDLHl3ccTeoRDFYRtYM21m8tA==", "58d16574-e0e5-4d49-969f-9e3dde78cdb6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "47ab2d2a-0c90-4006-bb2d-8f81fec060ac", "AQAAAAIAAYagAAAAECqjkNNo62wJTQ70jP5h2s+J7wOyb6EmnVM1cwPYATUHuTWU4O3ljQlsuNqX4j7n3w==", "7afebbb5-8b67-4d17-9bef-aaff151d2e7c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7cef0177-ff05-4e61-b279-4bf0aca24a71", "AQAAAAIAAYagAAAAEJPPcJE8VYy0mlZkR6wSIRzTVWM5Uztp1lfpNp/7vsG7cqGArwZli9ROigmh48kBsQ==", "4f8be0c4-1116-4eb0-8956-bb7f750c200a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b0ba8d6d-78f0-4634-906e-139328b85b90", "AQAAAAIAAYagAAAAEOEhMmJ1hFtgIUMmkNzLNvkLCDLyfCT3eGfQGCGq6D8IoZ60n3l/hWbWL3xzhC+3XQ==", "3f869179-9299-4cf8-a17b-627d44ace1e9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dc6c6540-2161-4144-91ee-353d74e9c11d", "AQAAAAIAAYagAAAAEOOVx2Uf1Sknrgdog1cnFPX8pEObd0zXRAWQA0mzTy8y7no9eU7tyg6gUdxdkckWmQ==", "f24c3561-1c33-4e73-81ef-f789535c3e53" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "de46edfd-6975-4ea7-92b5-5f95af492d05", "AQAAAAIAAYagAAAAEK+DF/W/WXyLu5MKQNYsOUUYBRHGzQoQggL3lgLVzlaaLrspRT75q+NsKJCOWwGwKw==", "48fd1046-5e42-4eb4-a5b8-093d89c4989a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d1749fbb-a289-4d6e-818a-eecdf8caa570", "AQAAAAIAAYagAAAAEKEk6APfbpGGy7Pydokz1ebKtEPi9jxHmI0ueVb3WFe3tHmud/sSxmvHJF3FfHquXg==", "ec95902c-4ce2-4eb7-92e4-23db032b7b86" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5187f08-f281-47c1-a9c1-2a52b3e1ab4c", "AQAAAAIAAYagAAAAEK4jozuuU1Dn7E/bNjJLds3zpo0KAnkyNX/vvQtAnO/FX2uODXp8a5trMTO0wBvmKw==", "4b91f03f-3a94-4110-be45-6c46b71f2476" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0df3d8fe-da7f-41e6-8cfb-8abd67dcb072", "AQAAAAIAAYagAAAAEMeDKpmKAegC+p9TjWwB+DDTN7KU9ErSL++TeLtX1hlC7eZb3S0Gc4BOlsIXLRKAuw==", "00a033c9-382a-407f-a307-c8ef4f066a57" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c3f126ce-51e7-4305-a64b-6287b2c41a5d", "AQAAAAIAAYagAAAAEMMeETwNuC8stn+db1yWdyyDCX66sHofeCpJADVLOYE5axncZgFP+bu/iv6WWhLFiw==", "b90c64c0-6366-4210-ae94-dba4a3242b13" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4e6434e7-a2a7-413d-b791-e40c2aac07bd", "AQAAAAIAAYagAAAAELBOcZk20yCJqAZfN5zPR6cvtbZj1g0ic48ayVJKmtiGTIxJBbGRGMnCNQ80cpPJHg==", "6554d949-8072-4a01-b0b2-9382505668c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8cda4499-6615-437f-8a38-c61f57f0db79", "AQAAAAIAAYagAAAAEOEtjijnm3ElKjxD72xRUUbHkRdE3I9HzuPFfcw3i2C4T2Gzaq42E961Mk5Wm3xvqQ==", "f401cd59-8b74-47b0-9f16-8280b2291099" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "869d49d2-05aa-48eb-9d04-58bfaf6dd0a6", "AQAAAAIAAYagAAAAEEXrxwxT35FlXbJh0aY0CNH/pAwhOFMGrj/EJbQ0mHS1eRT145NjThQkICxakQv3jw==", "e994bd1d-b66c-4910-ae99-63b97b97ae6f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2dd83f0b-8289-4a3c-9a26-597edb012209", "AQAAAAIAAYagAAAAEJSs9IB3ZOaltq7/slRTo1xiPwUNl7BZBLcBX2Sz/YNKqhSiFxdHaFqLm+ptQGy9Cg==", "0a5da36f-bd5b-4d17-80a2-e7943faafc66" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "057f38f1-1ea9-4ef8-b0b0-2c38ae5f0aa5", "AQAAAAIAAYagAAAAEB2myDRs0bwCWIEwiCqhR4jOwHJE6FkmrIe/mwzukm3lPI3TwY7tRHo+VdO6VzoS2g==", "32fed505-dd6f-494f-b6f2-4959c32b61a7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "57583684-a1b7-466a-b38e-e79d2ffb9cc3", "AQAAAAIAAYagAAAAEE652gN0ZFzBGqttVgC1BjBe7mnVcIT5mwAhleVjaGPX7Ji+lVIFyRnPCMrjf7CKJQ==", "d8d46c9a-fed5-4520-8cbb-1a4939718f02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "87af8db5-a154-4316-b5d4-7bda6bf9c932", "AQAAAAIAAYagAAAAENa/ygEmjPsmVRrgL1fK1pVafXnxkpaKrPo+lJivhITzlC9i6dQuUYGBRQOcIs5YvA==", "88dec271-1a73-4b0d-88f9-a1f5e2ad09e0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "46169cee-af41-4a5c-9826-3cf3abb9cc68", "AQAAAAIAAYagAAAAECDi8fokc3gbV0A/YZIP7vwGj+jO7PAlwPG49FOAB5aPY89KDIjU3AuteewdGmRXug==", "c1e9f47a-8e66-4597-8704-7695a3db6fd3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdf1281f-5ce3-438e-b2d2-0a77880ae8ee", "AQAAAAIAAYagAAAAECePOGgsrGQf/Teob9dUEHvo7cCMtKQicKfvFe7GIq1QRHyAXTXaQJYL/xTukAloAg==", "9b2ea074-0501-4d04-a6c3-caa1cdd3b04c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "952c3146-15c8-4840-a13a-529346c352d8", "AQAAAAIAAYagAAAAEAnhPX08Tb95UV8Eudhq1weiJf7sidShaIlUFuaPBfR9nV4KJBq5ZdD4zLtkUGlkdA==", "f8a7f554-8402-4eaf-98ac-ee37e6f1801e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1d21fdf3-e4d4-4622-a104-1cc8cc1d3b85", "AQAAAAIAAYagAAAAEHZARh5NpAnypJzgvnTWqGMPkvwdAEQTU9JTMLym/BS8UZldOSuYiyJBCtbU2stHug==", "fa816fd8-6b5a-4b23-94bb-6f4bac8197e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "37c93dce-dbdf-45d3-8915-37a956fead4c", "AQAAAAIAAYagAAAAEF363afM7IOvqJROrgub+wXBO51e2L4BLKxGo9QHv5FKatIEZXZd6fC4AXgC2bLEKA==", "1e4678c6-8811-4d76-b65c-aab745bbbeac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4b127a1c-a769-4af3-8747-ad5d821bd5a3", "AQAAAAIAAYagAAAAEJKzmSNdM114kOwnlBPtGKK/KiL3+cQlrPXIBOVO1vadVyXB+gdgmtDE3zcFQw8lKA==", "36fb6121-5408-49d9-bfff-ae238241a659" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "461fbd30-9d6b-4abb-bff9-66c18cdd389c", "AQAAAAIAAYagAAAAEMMQWATF5TCeYDdJskYSVSxvOWkI3yVSOZFlEjYey03CvcczpJD5rQdp4681hSmWiA==", "9aa5dba2-6754-44c8-87f8-f37a10361581" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "23044b57-a2c5-40d3-a25a-064aa996a095", "AQAAAAIAAYagAAAAEO8X+QBRBUI9n1J3e0V/Sf8hY+ffxIehITF36nr0m95cvLWG3PAsR25jisKHHLS5Zg==", "c767ab4d-cf37-4afd-b8d3-3718130b1144" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bec71589-e81a-47b4-a138-a305e55e2d19", "AQAAAAIAAYagAAAAEG8wIsF/kki2RoYO/jcCCybH6OAJoVoczjBWtXC0uOi/yQV9Hn9/UqH4iMFNXlyP+w==", "ef2b1f6b-7efe-435c-9e0a-ff7a4bb6afd4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "03784ebc-da38-4f12-8cca-1bdb735ede5b", "AQAAAAIAAYagAAAAEMrH1mHqPo64bOJv/nctv11+Qd1Pp3q9bI/x+tevWdD6cDnbIDl+yrUL7d8uK+OcMQ==", "a62354a0-de58-4ab5-a70a-22d33eb8d1aa" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5b53cb58-7f6d-4086-aab4-393c0bb0cb98", "AQAAAAIAAYagAAAAEM8H8tNqjKTq0L0bEwXon797GdPz7lcEq9tPU/4lfNnuMzj7pa983By+n/vRaI3ahQ==", "a90b16f9-953b-4078-9b1a-0ce1ff72424e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77179369-bef2-4507-9289-fc1c4831a4c7", "AQAAAAIAAYagAAAAEFlbQCl+GAZ/y00fCTz5VaYm9qhHDsy0HXU92toTM5jCzMQk/EC/GSEKriN1DiHIdQ==", "edd7b51d-b8b9-4f76-b28f-7b2fc2acf75a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "39806df6-992a-484e-8402-7fd3e29567b6", "AQAAAAIAAYagAAAAEA12qd56OmbGyQYUR6XOdJ8lU2oKmU3A4Llb1HzrZEQJPrCNQU1xNXFmW5zAZTpKRA==", "f3d7752c-e8d1-47cc-8479-050934c7b58d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1629516-9676-4ec8-924a-323e1e05b3da", "AQAAAAIAAYagAAAAEE9Jh5BClMJOYdpJ1U7WsC/hqNL+7M6ky843SCpEytNiGB2PHKeE+xe3flUwiL57+A==", "e7611b80-1987-4b71-8273-07bf3e9f4465" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f99fad1c-ffaf-42ba-88d5-208678b55bbc", "AQAAAAIAAYagAAAAEC888d6EgOxeQOsNKK0GqnxlK4cb6mVbdSuTVb8qbbuzL6lJb5h9iKQ7Myyubgn/kw==", "329c4e19-7350-45b0-8cc4-9785dd83dce1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "499bbd6c-b758-43c4-9055-e3caa452f05d", "AQAAAAIAAYagAAAAECuSaqEl/8Ot9CTgNGqIieNRhQxaaIkkuxi7HKL7l5egS1re6PgVgJ1XpClyqpflMA==", "a5219064-706a-42d2-ba89-b7a21a0cf465" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "febf665e-4ea6-4427-93b4-329da469ab0e", "AQAAAAIAAYagAAAAEOEifmUNPYbLyjDp5XwmMl4IvFqv8ynj18QZJp/aYTo6MZ2X2hDl5GnV8hIhPjVBsg==", "e7297386-269c-4fbc-8a2f-dfb065de91d5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1818f10d-d4a3-450d-b85a-6659f563f16c", "AQAAAAIAAYagAAAAEFFls5xCg4ak9stPfu2LVSdXKzavWud7LdRiQQYCnJjoVSwsGJgmSkWBgZBqEPwS6Q==", "102cdb55-0383-405e-ae42-e4b6e93a673d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2028be39-3684-4b14-a24b-3419e012ed21", "AQAAAAIAAYagAAAAEKpmLkLwcSWZDBc3HIETzTGG0QssrsEEe8uUF2JGJj715bjlG4S1dNSZYYl5G6//qw==", "b282e3c7-7550-429c-a0e2-dee320c88268" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc76b9d2-bbab-460b-b156-390ca745b985", "AQAAAAIAAYagAAAAEDZLdcBefxbc0zcel3XsaRQJiRK617h4e6L4T+fDGnl163N6BT7CbdlgZWR8CHGCcw==", "0c43c643-e8d4-4254-a19d-057374566885" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6ee0e8f5-0ca5-45ab-b654-1f91086c12bd", "AQAAAAIAAYagAAAAEG8HLaADFcUQkVfWmEuCUUdSoAlxBGtINolB99xub7ZDmKbO9/9EVfAHM5LCfw1zCQ==", "12bcf220-563a-40da-80fc-a017757e7aec" });
        }
    }
}
