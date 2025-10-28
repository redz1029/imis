using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc /> 
    public partial class SeedUpdateUserAddedPositions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "32f4e631-4285-4158-83ba-2f931d45a408");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "66ea3ce5-89d1-4e36-9826-4a2493c7e161");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "7eecec35-a9c5-4d4f-87eb-151a73c088b9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "0e20b433-e13e-46f4-a66f-7df813afefd0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "e1d8c00c-0df7-43ff-8c86-5ccd8a136d27");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "aeaaa420-9bef-41d0-b55c-4b0d7b07e314");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "f4807faa-eddc-4133-add0-91a9f0952524");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "f7b20fff-3a27-4974-b4b7-bd074336780d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "4f6923db-f3c5-4ee4-9cea-72c326f23810");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "8ccaa5bc-53ec-4f4a-988b-779b61a51f39", "AQAAAAIAAYagAAAAEMfsvABVz1tmzP2TVAkb5mG3RZo38yAfdB+sBalK3H1LT9BAvlANXKvWNhB2+9gQWw==", "Head, Public Assistance and Complaint Desk", "3fb276d7-173c-45be-85e2-5fb1f90e926e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "7eda3094-318c-4428-a636-7784d3a76e36", "AQAAAAIAAYagAAAAEBFglFzdWgWlX+yofMA148vJ9remYjj/t2U2Pg9RUP1ss50kjc92jHfLzW3jBRLJCg==", "Head, Cash Operations Department", "9a687c56-3aad-4dcc-bf0e-2fce7a471076" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "298fa7f6-4b2d-44f1-9c3b-930a274803f0", "AQAAAAIAAYagAAAAEJX0KHZMR9djz8NzQqDylZctvl0rkkzdG+lxEN36tyQ27LxdbknUCXNxOklXBm+i6A==", "da175dc3-e47f-4e62-9773-d93e540c3aa1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "6b3c8ae2-0762-4aa9-bd44-a76b3222d666", "AQAAAAIAAYagAAAAEHL95d0LoZET3suc7pJ8zT3PFmRGk93gq+jZUdMk1Afa+7a818ON0L8fell+FMMG2A==", "Head, Human Resource Management Department", "538df873-4735-40be-944f-7adb1d2a85fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "06a0067a-7d01-44a9-97fa-089be7c4071c", "AQAAAAIAAYagAAAAENUfhuhsRSjzSN1Il2nHJy9S55WKkvszpZcBwgKcJ20kf4QtMuRZPTwqQFk6NNAb3A==", "Head, Billing Section", "fa4a0090-a9e2-49e4-b0a4-6b9bacf3bf65" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d4b61b8a-4bfa-4d7c-9894-5c523004e0b4", "AQAAAAIAAYagAAAAEDq+Ui10RR4vaGltqZbqiER/f3CL7zF3s6i78ayk4ICG4msBbwszogZjg3BTeRhu0Q==", "4f837771-37c3-408d-bf0e-8eff2502346c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "2c033873-9126-4d69-9fac-48e6235af0a3", "AQAAAAIAAYagAAAAEElMt/XRfiZAEzU1j/UD4/iBMO5hupuVMph/hriJyUV7F1oLXlPj4w5Mhrb2hahQ3Q==", "Head, Hemodialysis-Main", "6fbd7094-4a6b-437f-80d2-e687c39e449e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "191d40af-dcbb-408f-8a62-fde314daf567", "AQAAAAIAAYagAAAAENsvNqGaLDEkC22zDkA/J9/66zw1mwQWaZbumsgWn7EZPx9opssB4B4eCGb/9eUkKA==", "Head, General Extension Ward", "5e20ba26-41b9-484e-97ae-d0d98c1443f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c7c8418c-8657-406d-b032-295d3832c241", "AQAAAAIAAYagAAAAEMbpIhD1A/JNS9dPZn23+JTVe4mg3+IYxzQEd8Cv6Y3OiU4kcWSfgp0IMtKBhrX9pg==", "76f2a714-8599-443f-845e-2f99d3a59fc6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "cd30c125-88c7-4094-a9c6-5fc37ef50b16", "AQAAAAIAAYagAAAAENUwU+lzryIKCss1E09J4K39YENlSXeM8UqI5XhfqPwY1sJiP2mxvKjhmcH3h2dvbw==", "ef96ae02-fd62-41f8-94fd-bb3e201d6f24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "36e0b4af-5100-4b0e-b1b1-377604d7f768", "AQAAAAIAAYagAAAAEAVFyR3xcav+aSss2ngUF866Ntx14PyeHyanHMDkeieX6bJ818pCRpLyzyEoHsqC0w==", "Head, Department of Pediatrics", "f5364597-e53e-4036-b133-d992800133c9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7dd7bb13-869f-4969-a7e7-1f80987723e3", "AQAAAAIAAYagAAAAEGMa4L3Fl/4TkGIldyRYfcv79T8P69WztcUax//D1R9CYBs80uU0Sfp9PbKUR3F0Xw==", "a94a7eed-198c-443e-bb24-01c178ac6be0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1d3145a5-864c-4319-b0ac-0828598864bd", "AQAAAAIAAYagAAAAENWDoI67mdEa8Iw9To0w3lKbaMcxpyhx3P6Wnc8/wHS6vSftLZpRIj9G7iTdPt9owg==", "Head, SHTH", "2167d3d9-2c6d-4a58-8297-ac9681eb5834" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "17520237-bf44-42ed-9797-a77c2762bda3", "AQAAAAIAAYagAAAAENxO7EqsSjvJLC836HO/QqV5nTQBsjEYTjPs/itCXnzknYYvowfyyWbYk/jB3YWWSg==", "Head, EEG", "dee6388e-02a7-4a6d-b4bf-04ea54c8c7b7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "60505527-f910-4502-9407-ad3dd9718c68", "AQAAAAIAAYagAAAAEMkLE6ZkzT9UziGKsjDsw7kH+dH8anjjPaQj4h6c1jdqyDPKore2VBeXBz4nDr5nmw==", "d80073bf-12c4-4253-a5c8-62a8a136a19e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "af8748da-307f-455b-9001-e8d283d9294b", "AQAAAAIAAYagAAAAEFRuRdFhS4toE6frBru0aIW942Jsxl3VdPZ344kSopFdVIn7T/RQOXPNJe0/orkQrw==", "032dbbfd-c72a-4f07-a565-fdb44fb44fdd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "abedc55e-69d4-4bad-bbec-97af6d57521f", "AQAAAAIAAYagAAAAEN0GWZddehnEpCtZ0l0AXB2lAovlZh+O5aCd+YzPyOMTxr/vmVWYGyFEKF2Lpb6Rfw==", "48130cca-e192-4792-a435-4ae95b52a41b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "3003a273-87e2-41c9-b961-3dc440152561", "AQAAAAIAAYagAAAAEL5oh8p032l36RcZYaf6SkJJprmhtmm0uldldzsJe451ac6cXKA3KtBRnBCXyTDK3g==", "Head, Department of Anesthesiology", "dad328d2-68fd-40d9-a3a1-b9fabf3d3c25" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a7900983-6cf8-4b01-a6ad-bef9a7fe2e11", "AQAAAAIAAYagAAAAEBxQiRwgQ/HIzgu5Pa1ZUscIu+5pwdO1UQGlbiB/Omj58QU5rgp1W/VumXOY77ezYw==", "967643a6-effc-476a-9e40-d938276fd2fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3bf8fd5d-32c3-4c4f-b5ec-b71d9d85b16d", "AQAAAAIAAYagAAAAEDeYqfHOFa6I8ScB7ra8s0ome7j+C5LGFHCMJ6k+BKr5Bkba48d0kbfz+bFdgq2ORA==", "3580374d-7f79-4893-8ec8-d16ac1548fe6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7c99f686-c179-4403-b37b-e4ada62b01cb", "AQAAAAIAAYagAAAAEHg4djElOylHycKLy/Rle4d/VgD0XoeCRvxRm4EcyIHA7fqi5+gc+S+1OWamT9W+XA==", "825ebb7f-b560-4619-ab34-8d2739afad01" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "f356e042-e017-4707-b912-79f916092fc6", "AQAAAAIAAYagAAAAEK5u2t0GxwbzZEU8KDB1yqAJ+gWBmNJNW9r/79g5lrWL4ZF5D4yMA0IIAMAj+AnOyA==", "Head, Surgery Wing", "d119d3fc-f43e-477b-a7e3-ef501f728492" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c7776b37-9168-445d-a452-4ba6cff9bf6b", "AQAAAAIAAYagAAAAEFwiPBwfmaVZhwNpiPx9umwM+FrYS4R8iF0849JvPyogpFkhqJpbZS813Tqk6m5VVw==", "Head, Department of Diagnostic and Therapuetic Radiology", "1d918ba8-5059-4ffa-a49d-a4b7e25eb4df" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e1ec7026-c692-40f7-882a-334b94776491", "AQAAAAIAAYagAAAAEFnLzrOlcPGaYa0zUxaPyn1GJqrT7gS4U+82B5kiJYF1Xsxdd3igkQSNyVbarkF/lQ==", "81d1a23b-c958-4b7a-b057-7902de100d65" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1e6af0df-f32c-4085-87c6-fd5f64da941f", "AQAAAAIAAYagAAAAEHHvrNbuBaN3oKPzsirif8ko98gLN0bcwA8jz/SC7XDQEYk6Nf4oscgkQcDI9rxQlg==", "Head, Central Supply and Sterilization Room", "c0e02b11-acf9-4ce0-9b2e-13e45d7439c3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "591cab52-a829-4c8d-96ce-29789e20d2cf", "AQAAAAIAAYagAAAAEPQWO0Mk+JJNrUlqzJlqxnMi+fHUmkcTKP26Q3tQEHzvAMUHEOK3iBeC4TP+vfA1hQ==", "9fd63011-2f30-420a-8f6a-973b687975c1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a7a573b-c835-40e7-abf8-f88de0735dcb", "AQAAAAIAAYagAAAAEJufEd061niwmB9kt7CjH/uNPsK2sHnt12Dhbc1KfNlbAL721mQmaKXneyrEksL/7g==", "6264aa5e-f33f-494f-9cf9-12fa0606fbc0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b05b211b-9911-4c95-9530-dae8c4c9c965", "AQAAAAIAAYagAAAAEHcgQEoXGqZuV0+bapsHbtz+xz3IqINa/JUIGPUPfc9o86fO3o0myb0QzCFuBH+Gxg==", "b254a732-3582-4055-b80a-152a2562d717" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2e2ccc91-087d-46cd-ac62-b07f930952bb", "AQAAAAIAAYagAAAAEFg5EocNO9M8VIBD+JLhGm16DES0QtSUYW6DF0dDtnQ5Fk8gkAO45rH9kuFgOcIsoQ==", "6a5c4cde-59ad-48d1-a48a-ed1d611a6efd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "7e24f551-8c7a-4b5e-b668-aa28a1803c73", "AQAAAAIAAYagAAAAEIiCKhSnrFeBS5HW3VuDdhnK/+LKJNN2qlvnr3v8ZW+75G5UQYpCS9PWsE7m6hXb5Q==", "Head, Mental Health Unit", "9bc803a1-e0c9-4ad4-b7e8-7f0107b5e407" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "be19f864-c0fa-4d22-8b8d-0375b3f8af87", "AQAAAAIAAYagAAAAEAEgnMpIejbkKCTwJtFnmR/mnCejKHNv1dBT8wSAEj4hbCOh3FI9rt2ht0SWFMSmcQ==", "Head, TTMF", "b72b5c18-6aca-4214-913d-ffadaaf248b0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "510a4ecc-fc2f-481d-8099-893778b87e16", "AQAAAAIAAYagAAAAEMVmdsd3kbAK6mteUSeMBLD8fUlhWCEEMwolvDxgW35ZLmVrA7We3OBt3VfsN32C3w==", "a23ae2c5-a3b7-4a4a-b574-e321cbb0a175" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "346d7b0b-b48b-403c-8073-777d3910163b", "AQAAAAIAAYagAAAAELHiLdJjwnFllZjaRIrQczbWwwv0/Bw5kC7l2ATJW0ftlBf03fFnvh7/7kYZoA6LGw==", "ffc058df-1480-4fa3-8741-925f9516b3ca" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "4cc96886-ffa7-4a57-82f0-660228179334", "AQAAAAIAAYagAAAAEBHS3TRQx2814ik3ifJvjK7dfVEtzzGm4G+C0eDUyKUuEPv7k1dqoQzv/UI9roa69w==", "Head, Cancer Institute", "03fc310d-707c-4ec7-99a3-f9736f255ff7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "42a41286-d823-4e2f-bdbe-812ed962a187", "AQAAAAIAAYagAAAAEMi/S9CYmUqXc7UvCFVcF62UsdMSfROpmUq00qx5leGmxwjkJVPaXt6qPu3mp5QQfA==", "Head, Hospital Epidemiology and Surveillance Unit", "dd108d6d-73af-45da-a8fe-f80e17ff3343" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff0adba3-5596-484b-b9fe-42843f756f9a", "AQAAAAIAAYagAAAAEG0/yCmNJtqrI4L1H2c9DOeQkRzdN/Ms4nC0UHkmYP+xz7wp5+QbQdu2Q7GxzBXjBg==", "12e2cc1f-ac72-4e75-9906-ef452441dfa9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a78348f9-150d-429e-b971-2a6c2fb58a53", "AQAAAAIAAYagAAAAEBd6JjWH7VCyDBG+DeZK01e1cpCClVpOlWzMbn2AyV1yS9dgRAZG5TCkN6dqcHFuXQ==", "c072bf70-cd14-4ad1-99ab-38ebb8783173" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "7673c5ca-d0ec-4d45-ad25-883f3b3dfd65", "AQAAAAIAAYagAAAAENRc5sSel1ww81zzumImaR96JkD/Gk6rYxmyMqpkOUxDNTXXhODm4ShEDvYeV10yDw==", "Head, Integrated Hospital Operations and Management Program", "c023e983-91e2-41c5-9da8-d18114825dd0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "382bf259-ecef-4f77-b38c-3eaeaaf14324", "AQAAAAIAAYagAAAAEFJApyuQTIn+a1ku/2ezplMcaVlaCVwDFRqZYHLzQa2sx3YdVEcPnoP5KLahPUwHVg==", "62064e8b-ddcf-443f-96d5-fc0a379080f0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c48f4f5-6c1e-4752-9737-0921804b1813", "AQAAAAIAAYagAAAAEJEj2oTkBcBRdcMZzEujBAIhLt4GzTdGHp+lC2YTKjVRon2sgFH6Pv7Hwje8s2+VAQ==", "0ca75ec6-ba34-448a-967f-d856256ea780" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4ecd49eb-9796-460f-a443-47cbafabe8af", "AQAAAAIAAYagAAAAEKPEuuTfQIpS3pkqHQMcSuzzMFeCFQ6/wonpXOyUekls90kpyycCQHsNuLA5oxAdtg==", "1238cfde-32aa-48f3-bdaf-b733bf099e16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "018b4183-f218-4bf3-a973-4f490231e41d", "AQAAAAIAAYagAAAAEBdaS50zMbRn9a+Ni6r0tOAWl9Tw/xRyQq9A8nZJndIOO2Muc1eMLjfOCAvya6tYuQ==", "Head, Research Institute", "b378247a-6937-46ab-8eab-952353688ac7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8680b04e-2131-41c2-88a4-3a84b22ceeec", "AQAAAAIAAYagAAAAEFj64JFV34alERVDNr1g5M0zh32DjaicTuOftf7oRStHKllIt2QsvgalTF4wIyuHZw==", "8539cf6c-c072-4d9c-bbf0-9c5df17c5f6b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "94aff897-d9ad-4b10-a856-2feb8d1723e1", "AQAAAAIAAYagAAAAENuTbEwAWTKs7rB/7J9SaRtz0afRiR0aX63eLyPlQuo72x4H0lkePXjbTqk1Px0fGQ==", "Head, Engineering and Facilities Management Department", "2d2bc974-5944-4841-be68-e6d69ba25a74" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c0cef180-1639-4dd2-b5cc-51b27eff83c5", "AQAAAAIAAYagAAAAEGKRuAT1cSibXugYzo+xGOYl8nJtl8+N7wt2j/8jM2TO8gWbQyDTxs0rDdD/c4nQVQ==", "0d583a65-04b0-4c93-8c21-afed4264dcbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ec4e0c09-e46e-48ce-9d9e-99401a77eec0", "AQAAAAIAAYagAAAAEGEyjeCf4sLcBG7SdMew+fLO6enYcosFpU+W7TrVuNArL4lsgQT09QuRVbQfzC/GVw==", "624b6156-99a7-4c91-af2f-2be8278360bc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0acaa318-62a0-4cc7-8c69-2c9c4b0f2053", "AQAAAAIAAYagAAAAEBgpQempdQACDIxcht35vW5iA6ixJGEYsbkd4Wn3SYqosjod7xrlMSlaS80rSmhWLw==", "21d8e134-4207-489d-bc6a-3a09887215ec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "86243735-dca1-4ca0-8acf-a2b0f14b4180", "AQAAAAIAAYagAAAAENTcQqgfKaadbI0t1A/IWEDTDgYzOz7NjJJxlj2UnIOwnWUp/r59ezKdr3uSsP/gFg==", "6982e7bd-fef7-4069-ad35-76fc378cbe16" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "30806b1c-f0c9-4bca-95c8-3d77e1954ef9", "AQAAAAIAAYagAAAAEJE1EDSrMI0Vrdq7DCa3QdcZzmzpfwT8T1iJEFkXn79w+xWl6mnR4MR5qmqYkzIACA==", "de4dcb99-3757-4333-9f55-92c13502fbc1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1c046484-db2d-4eda-a4cc-e8b9547baa53", "AQAAAAIAAYagAAAAEPjRAq9esySYHxH/FCalyyarh2dIxXRCSit4mfCoVPilAN2wskL96NmbgxYjFrSWKA==", "Head, Department of Internal Medicine", "28c3e162-1940-44a7-8889-e038755a5d69" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "f4c44789-8c00-4c60-94f9-3f464225c983", "AQAAAAIAAYagAAAAEAu6cBcRvq09wSi11I1FiIVA3PEHdUPIqg+Q2w7oLuT6JxiPcE2G9yl7JxOmEHJvzg==", "Head, Emergency Department", "59987cda-8626-4b5b-99ab-1fbf6e3858a0" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ed870170-295f-4040-82dc-edb28417122e", "AQAAAAIAAYagAAAAEIyPpc4FfcBJwjktEmgWn3pTk7BX+89m7f3Ulg6mMSllcpbzODFbcskumha+O0Ea6w==", "Head, Operating Room", "38ab735e-f831-4ea2-b219-45dc87e1fbf4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "6ad6bfde-acd1-46a9-8c65-c62e4440fd14", "AQAAAAIAAYagAAAAEGJQ0iC0ESe9mCyJQn3ae3jCIJ5FesBZVPKWqSnsOI9zv4VUBaUKMqFw1aD6cKvjQQ==", "Head, Department of Obstetics-Gynecology", "eab0a21d-12c5-45b0-a123-ca4185c88a75" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "7aa0452a-406b-4068-9e9c-cf43c3c82861", "AQAAAAIAAYagAAAAEFRCF9eZYdUNNLXv+rmPoaB/QHbAGkCd3vTvU2DFg9iqm1whylkCI+vTHBNRCxcD/Q==", "Head, Emergency Department", "6f3116a4-f369-4027-9689-616d0b4bbe5f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3c36eb6-3131-4635-9d7e-1c968dcc1071", "AQAAAAIAAYagAAAAEAtmsYQUaOulOzj97kL+s5psh5YJdLfWXRw8tojxRfV4FdBgkGGvXrC7IGra/86kJA==", "0d5b83a0-6ffb-4602-8ad1-91f8b322ec3c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "FirstName", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "b8b8fe01-03ba-4403-95d0-56d3e9f39b29", "Sheila farisha", "AQAAAAIAAYagAAAAEIP2YeOcrhhkuYdRTkQcT5NsrJP6bTkajho5qG0JHycMK1ZYC5cDlaOCpndXaYZNtg==", "Head, Office for Strategy Management", "63c93351-ca10-4b69-bb53-fe2ed9b14ee4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "79e9bd55-1b98-44ba-b503-9323a9370a67", "AQAAAAIAAYagAAAAEJfvLKvED4J/BsG0dWq+PFd7rrOBrB0h+Y6uxRAVUEkfSY8ayT/mV6Ec5JY+i56kkw==", "fc51a545-a79a-4848-a28f-f68632150cbe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ff99121c-6137-46a8-b5c4-25cb8cbb4e3a", "AQAAAAIAAYagAAAAEBPn8YFcv3G4Kyv+XM/0Pb/bwrsYRnaRPtHBWbIcXi8bMfi7/GmzXYyCUJ7hStxH4g==", "Head, Pharmacy Department", "25e51a17-bf60-4527-bb25-fc0d61aa6b0e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "3cd9fcf5-d0d8-4932-8220-9b6bae9086b6", "AQAAAAIAAYagAAAAEGosMgS2Q2J1fMq4fVwvb6RpzNS6XwRTWR6VNtqdS2+vrpHWNiY6nivdUGADofJDFw==", "Head, Department of Family and Community Medicine", "b252bb4a-1b06-496e-94f2-576ac391cdc1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3fb4582b-d421-43dc-a5bf-e08300b45548", "AQAAAAIAAYagAAAAEBc3zeMP7ssRBkeTD9gm9Stn6Pl6VtjF4wrz9FW8n0Jj+08hLR9/MFhCJi3GolzrbQ==", "17181d81-abb1-4fd6-8f60-2b2532a3c618" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c5fd35f7-1dc2-4f23-b933-3fa4346acc8a", "AQAAAAIAAYagAAAAEFRLQ+jew57zLyK4n7h7W0FnB+8zfBzhzxignn9lVm8Izd93Y8gq/GDYX51AaKL8TQ==", "053ec117-2c19-4b43-b100-ab1ddee9f931" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "a6acd9e4-8b58-4c29-90a2-afdb9dba0434", "AQAAAAIAAYagAAAAEI9rgpqa5e/fcnjOAEDnrmhpjWBGyA+wffcQiNjmS/+y3RqXL+n+QDeK3dSQGVR9fw==", "Head, Budget Department", "8d5a2cf3-d720-4828-a27d-74281d4e3695" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a5ce6128-87a8-4083-9336-722abcf79aca", "AQAAAAIAAYagAAAAEMTbNmLCt/ZEtGKbxGOyeW/1+ldrJYKJWkDDrFRlctJ0T6FqcX9WVaLPmI19jrdLWA==", "ca844a96-ca19-4452-a439-3a7dfab8ab1e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "866f2a5f-cd26-447c-9380-5b8a7b1577e6", "AQAAAAIAAYagAAAAEOl0o8FvH+w2XDcK79cKWudub7Hg78RD3/VJYiuzRklVacPRolzwshIVW3WXvL8tcQ==", "Head, OB-Gyne Ward", "1481b874-2bef-4c15-bb57-d23a0f2f20b6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "2b619835-881b-4aaa-9b36-98ad61639a76", "AQAAAAIAAYagAAAAEMODMjI7f2y5Xe1B6wKkV7re0q/iRo7fbYcHoFy/LlcyRhFqvrKXcNoXrqveMeyKTw==", "Head, Oncology Ward", "3bee5ac3-9c97-4561-9871-0bb9301de808" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ea463132-2c0b-4cfa-8671-9768f9ac5800", "AQAAAAIAAYagAAAAECf1Ntc4FAbE9mCydJjZc8orXRvTiHRH+5GMBg13lHIfMt5kyL4qw9N+Z2l6nD5TvA==", "Head, Materials and Supplies Management Department", "52fb8482-2eb3-4a49-a49d-7c420d06cf52" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5f5adfc0-4054-41aa-b66f-98f03f4a8f6f", "AQAAAAIAAYagAAAAEKwk7yoewrDWAB/kYDetdL6fWF6WpsxwwKnBcyaYMXkjnBKF/qHEE9fk+MzObrYlbw==", "d4a8441d-b8bd-425b-b755-baebfa508291" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "bdf800bb-19cc-48ea-a831-1918fdf8f918", "AQAAAAIAAYagAAAAECS0py7EGgbU4dnI4SzwSy1Lpltxv2vN+ZRntLhHjJY1Lvsj9QK2Tp2IVSgPl0SECQ==", "Head, Legal Unit", "e2727bba-5d3e-4327-b342-181ff50dae5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e7f690cb-37d7-431f-89bd-b47ac609baf9", "AQAAAAIAAYagAAAAEL0UaqpQKuwf5udGymw5qqh+LskL3w1PM2iKFeQqpQ9jpSAwgIUhRvhdZrM30MkBVg==", "ae53f45f-901b-4577-8f1c-2a99291b9d18" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "aac825cc-50f2-4714-a87d-29eb8a496a18", "AQAAAAIAAYagAAAAEFqdVyXxF/p3H0Onvkoz0yjLw94mkNYGfYtmPlc9/HoY1lt8s6icnFHeX1HlbxvcTw==", "Chief Administrative Officer", "a033a8ab-a0cb-4be2-b289-653b39d029e1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "aa6b6d10-be52-4f03-b67c-e56ef847ba70", "AQAAAAIAAYagAAAAEBDvBdsHiLAa3jUgFMLRlBBMtS1PUIVmZYnXUodtzEkYDwazgeVV2ZLggN1LmuqC4w==", "49e99272-ede5-4065-a4f9-4f7f0d380de9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "5e4a84bc-e171-4c1f-af71-798c6973e997", "AQAAAAIAAYagAAAAEDjaaz/PZFV18SVOktbBuv3xeWMEo/wUJFrDwYfVO2nEdzKxokUI9QE9EV9dFx3jbA==", "Head, Physical Medicine and Rehabilitation Department", "ad9df7dd-d5fc-460f-85ab-2bd24dcfce32" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "169c7a99-96c9-4b09-8553-bd137e1f084e", "AQAAAAIAAYagAAAAEMwblkfD7MgwdPvtzB+62OrsFqiige70EhP4t0sa20Qt+HZwxfao57NsumYzY0FVGQ==", "Head, Public Health Unit-Health Promotion Unit", "864653f3-b891-4c91-acdb-bb9c349a416e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d310fa83-2241-4c06-806a-69c79ecde01c", "AQAAAAIAAYagAAAAEJehum7Z1Gax0ejSOKvci+0pn0/U/Fc2mqYZpVmNNUqQvoheLtGbr/+ANLYxuWqH6g==", "21ef7905-6d43-44ce-8e0a-eb4d477ead61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "4a5cbffb-d04c-407d-933e-50b439efe812", "AQAAAAIAAYagAAAAEP2aghTaU3BkPWY4zQCa9zV1eBnQp4q41kzL24Wd4cOogz6dyDxmHb2FsVKxdHPsmg==", "Head, Sec. Ona Wing", "39c84ebb-46ab-4533-9f92-9d2cc6aece9c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0243046f-5a16-49d1-ab5c-06ace216bd6b", "AQAAAAIAAYagAAAAEF1T64USftFxbJCJVTULmP7tygdRa24dIexkqa+siAYqpivb6kgsNfqG35NR49ZNCg==", "d6b58412-0976-431a-bd20-8dc6d10b4eae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "f1fcbd70-c104-4801-97c5-3010cc1a0786", "AQAAAAIAAYagAAAAEPytCSD1QAlNkcrvyOnmWMhDNFQTFgFaev+KG9NAy+qd3BxCV2/9zQBpa7xbPYSi4A==", "e2fa9dcf-83fc-44c8-93b4-fe8a660a066d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ed943fba-8a40-40f4-af0f-f779e304f163", "AQAAAAIAAYagAAAAEHccxFGjAYCY0kcesSpurEITah1sXSTyYqhIm8+ZuioEapnoLajJMON5Zh9LdVr4kQ==", "892a20b8-78c3-463b-8b79-8ae263a745d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "50633370-f7b6-4866-a34b-ef4cc9a2faf2", "AQAAAAIAAYagAAAAEM7a2C6CeySHskyuKHVulN5tVs7KPzGiAh3fB9eVqwIXev7O1kn4Gx6boPM/1jpq/Q==", "OIC-Head, Department of Pathology", "ee63ef26-babc-47ae-88b4-59449fa719bf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2b589339-4105-4dc1-92fe-0a9c4c4bb9bf", "AQAAAAIAAYagAAAAEEEY0Omqf1jvbWqRx8UjBZT1xv6SMw3gb/uugbwYojqJwt9XfVzur9aS8a1CfmIi6w==", "cd53912c-065c-4619-98b9-a0bbb6c1fc19" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbfe4cb6-ea21-4494-a2aa-3e363740635e", "AQAAAAIAAYagAAAAEFLAvqidcz+my6kOYD4ajUPw6yQewwYaCjAhjG4ovFycLKTDswj6krWbDmGSSbOVzQ==", "e121dd8e-6794-42e5-9f53-167d9a66cb6c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ecce2d6b-2e38-4376-9e66-069254200ade", "AQAAAAIAAYagAAAAEE7LZK7loYZaEvNJ7v3NxMSoKhAtrW97E6+ymeMltaltg4fgvRXkHrZWZdHdi/D97w==", "Head, Accounting Department", "c3cc2f95-4fdb-4f66-9c8c-1204d01d29cd" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "cdd75457-6f6b-4203-834f-98921cb32e99", "AQAAAAIAAYagAAAAEN7zBAVIKcDM4EzlrQMxOlGWMMNLz1m3Wfs52sWDvhCcUzGgEy6EFIc6DRNv2hQj7w==", "Head, Credit and Collection Section", "938a8db1-1b4c-4c9a-ac85-80ac48d4d17d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "080f6eaa-222b-4984-a806-ac3ce34e79fe", "AQAAAAIAAYagAAAAEOsnQ3spP0yyes896N5k1NFeyRGATDtl+8VZaTs2bT2/8ppS/fZ+wTs+HHjNKgARyQ==", "Head, Pediatrics Ward", "0f4a137c-f7a1-4287-b185-809da9a31c70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "728fe606-0751-4844-ac68-990f091c24b9", "AQAAAAIAAYagAAAAEOGNi5WqCrIRcoM0J3XDEyXwVTKQvq3aivh8Rn3vuMBBEV9thpDi/p+AoMbmbRnk4g==", "a3bc39fe-d6c6-4828-9672-6b3a8c8ae34a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "887b1c3c-991e-40e9-b48d-71041f6ae9ee", "AQAAAAIAAYagAAAAEBSn8tUlPcAHsMFDTheqw641CAPp97Pg4CZPwDz31/fIgfNEEnTrjQuucGF7u9OU3w==", "Head, Professional Education Training Development Unit", "f66bf5b8-ea1b-4a0f-96cc-0de0de6054d6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "888bd0d4-a703-4ca2-b205-8fc167a2e8ce", "AQAAAAIAAYagAAAAEJlc1sBZh2wC4RYhWINbJP47DQo7+uI3SeXAjTDLi9/g0+o9PIkUXbKViFQvJrLJYg==", "3fdd1d5d-4881-446c-8d95-77166ad8f9fb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2dee72d1-4a53-493f-85a8-1fa727ab252c", "AQAAAAIAAYagAAAAELNsaxShTmwLAjtb22lMdpsOyqUpGwydj/awkbX5WiMRc8muZsQMY0rvAUpii1jpkg==", "8e6f6fea-fd10-47e2-a47d-2f4c4f851e94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "85652c55-79c3-445c-984c-e84a31bf7770", "AQAAAAIAAYagAAAAEGAAjQ+b9faG45l7BxrUKVzugNPmxfKIp+BqYyt9bG5AhIwqmyrhiAmNDwTbOKaxuA==", "Head, Medical Social Work Department", "e921b764-fb67-444f-8125-06c9285a731b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "65894718-067c-40b3-af50-14ce6d737b60", "AQAAAAIAAYagAAAAEIVO+si/ybvGkv8YS5tumMhS5TjXo2XmXZvEQlEa2KDcPiqZ+uezCyCTRhCGOy4eTQ==", "Head, Nutrition and Dietetics Department", "bdb93808-31a6-42e3-838d-417713d12670" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "77295dd4-e0a5-4ce2-b396-9b8174cffa84", "AQAAAAIAAYagAAAAEMIM8y+JrGntE0SkdqBl7paUwQnftos30rOwjya0aJDU+SIPX+YO6MrDlWBlT5k4Ug==", "f46b0d6e-7aac-4596-81c3-64f5aee5611f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "786579e0-2c89-4c3a-acb2-3a39a3fc0faa", "AQAAAAIAAYagAAAAEDhwtYuWr0nLcmspKqiF0uRnPPWEAzcVOdL6UFFSsddkn9vW9Y+PRTgh4/cJ/iovAA==", "0895ebab-3192-45cc-901e-9e2e59550866" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a62ce4a2-1f09-4aac-81da-9662a45bf492", "AQAAAAIAAYagAAAAELG79HFYk62W2hblrsJJz7wWImcDdusx3m4JuokrXCON4wDBMj7m+X5iLq9y2XWlGg==", "63ec5bf1-5486-446d-9842-3187ef7b7233" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e138998e-9006-4aa0-81a1-b7abe022eaef", "AQAAAAIAAYagAAAAEFWSEAKZLrzpsA0NTiQCgnTVkZ+Y5eqhGE2fPaLFAM+mVA7qMIfO/Y5ojviXaRuMAg==", "80ff3fd1-f02f-4b7d-9037-24a82342cb6f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9c0cae09-f733-4ba7-bc1a-b97437a5e568", "AQAAAAIAAYagAAAAEHoHg/H81hMW5F2Hx2yxV+2k7pzviGttKPydXQeBwC2XAgvqhh1Qlx+tGhnOoEspAQ==", "d8ea0900-d4bd-4d27-b623-6f739301f813" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "07400fed-94a4-4c0d-98cc-be3884db4823", "AQAAAAIAAYagAAAAEEDjB4NMfGlGQtPJerAi+ixxEQ1Q36gssupMaWa+iZ0vnhi4B3eT0GOAEGpc7NTUkA==", "Head, Paritoneal Dialysis Clinic", "1aeaef1c-5dcf-4d8d-8677-6530ad517d0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0a41f449-0c8e-44d0-8396-0ecad4b471a2", "AQAAAAIAAYagAAAAEDqWM3G4Xb11CDUdGjCeJ4Ei0iSQ+Q1yvJzUS1zeNw7DH1Uycm7TkfTy02tgdMYKzg==", "023272df-3d92-4801-b6d9-5b612e5ab7fc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "3d5f0dad-fada-4a27-9035-8fb942d469ea", "AQAAAAIAAYagAAAAEJlEBqcd1y4ZeAVe5Bq8ZZWgn0GbMzp17lBVxx5AqV5biO9BfZwTKcOIT9OxL12p6Q==", "Head, Medicine Ward", "c4a6cf99-e822-4b37-afba-893ae58c439b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a3af789b-121c-4ea1-9bb0-5ba70e38efc0", "AQAAAAIAAYagAAAAECbCB9OtC+0Zx2rAWlM9fVBAdzXstPbex1oaYASyg06RooxyU7lN9qeRJDTjUH3tdA==", "58ef358d-ba68-4a68-ba64-5ce2593fc86c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "0c1e383d-1e5a-4a1d-a05b-740b66c4c078", "AQAAAAIAAYagAAAAEFcK/gAsC5cz4SAZWbevQsuh0pxvuhnFj/y7+oVfLjn9tGSqHxTFGu4GdbkBXaF5mA==", "Head, Health Information Management Department", "edff6c90-5b2b-4e87-ba94-21b8b9ef3a08" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c33998c5-dce1-4a90-af51-f166994c7086", "AQAAAAIAAYagAAAAEEVOXQDbxxCANoBlAN9JD8k224veKgPd4VJ17eGVv08MIzdemwk4W8ZClFrL+FIM6w==", "Head, Out-Patient Department", "30b39662-c130-40af-98a1-fc3a2dc95e73" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "d5c94125-2e91-4bcc-a968-e0a72167840c", "AQAAAAIAAYagAAAAENK2IwJHL21tAueNpYsSCMVO9torb7/7saaqSzU3keE863+3qYEI6uwuTHEd/agVrw==", "Head, Procurement Department", "958bfc63-e7c2-482f-af53-da29f7efc9f2" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "24088105-a840-43f7-840a-cc495af484a5", "AQAAAAIAAYagAAAAEC3s4QZLVOMhPJOX8xy3hQHXGTmwka11c9SZQxvcoatNGL8Z3w7sDtuExwC7+kpYMg==", "Head, Out-Patient Department", "412d77fc-e68e-446d-9ed9-b748725b446e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8423acca-982f-4bc0-bb86-d9d4c4f2f939", "AQAAAAIAAYagAAAAEJri9BKvrWl4vtIxi/r4MsVzFVCbqpIF10naQbffS5vR0/WQ3zllPr+SowKE/IFUUw==", "1ab50560-0097-4f76-b8aa-5b62558c9605" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3161aebb-7b42-4bee-8707-07aa728d5564", "AQAAAAIAAYagAAAAEB01j/IF1xesw4QfbYEzZmHM5PDPFIZfCCMJbMtBBSsmc0BjRTqwyR+BhTppcObFkQ==", "47c24f13-6aea-4fd2-9e6a-ecc1c4e9874b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "653c3bc8-79c1-4b7c-8416-3a0c25d53a2a", "AQAAAAIAAYagAAAAEA092ygxRFGjlhEpGQsCNxRK6iRm5g51ZGGeu/fTHn9SHHjQNs17CysB2fuVjDSATg==", "2f067921-c8cb-4fa1-993d-fabfa215605a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9abca722-a54a-4729-ac80-3e7306b48702", "AQAAAAIAAYagAAAAEMRgePSjp1/+ZB5yEOUUmMUTOcgheeA1h56aFB6ZmPKpDUqb3GTZXNa+7E1pXzqKZQ==", "ad03a04e-f45c-4ef9-acf6-5d11874bf5fe" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "d05f7b14-2665-49d2-8cd7-b60f3170c057", "AQAAAAIAAYagAAAAEL5Ah2Jt2d/7/Xh1l/EcKMucyk9kQpwX1lkwUxS6g+Aq6OOmb2YWxALgt+itAjHz8w==", "Head, Delivery Room", "00ca63c3-b7f4-41f7-b893-40d5be0c28cb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5bb8029d-0eb6-45dc-aafb-2d8b367fe151", "AQAAAAIAAYagAAAAEFEkNU8YCjMGPQnTAE8nim4aEyrema8r2LAlyMTFKPAVBkO90K7yyS1IqiKt22WiyQ==", "2b5cb130-6c1f-4af7-acd3-19631cd0d273" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "0dc96e15-3b9c-4021-a54e-647d1d09f27d", "AQAAAAIAAYagAAAAELuel5NC0CDyDVmRjgrvCGPy4nwImj7qB5TKVkdKKUjcDggWdGOJ0Kh0dS+FlflcqA==", "Medical Center Chief II", "fa14a9cc-7ef5-4c45-8c0d-94a6cd1c3fac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c178792f-e8de-4c4a-983c-b0e9e5ebf517", "AQAAAAIAAYagAAAAEBBu9ogMHDnQmz/m5/2xRKStyOgBpfFRv+jysfUrNTCcYZuDCo/djXDJnTmSDIfOHQ==", "Head, Women and Child Protection Unit", "a29cfe16-683f-4931-8e75-a2dec3c10255" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c6a2e98b-c031-4df8-8a2a-8a6c4a83b620", "AQAAAAIAAYagAAAAEO0DbTacP0poUZfyo/SvMJ8Iw+A9PHkpUL99fDXwCRsUFFpBEmRHigGtakjNriV7dA==", "Chief Administrative Officer", "4869bce6-6a7e-43c2-b587-af236d428fe7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1690be94-8c76-4a56-badf-9fd9c840659b", "AQAAAAIAAYagAAAAEAUYJq5/FqtgcM0mYm58PsDs2KDBTwPV4DsjNIvEQobgpnu7toaIel90z6grfAzxGw==", "232bb1ab-ca21-45db-977f-cd07c4c0d30f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "eabc24fb-c135-4636-8bd1-0daa532531fa", "AQAAAAIAAYagAAAAEKSlqtVMvRPXiXejWuplFxzuspihStGbbHB57m7mMaEoNpE9XiWHhdh8shFoTsVADQ==", "Head, Department of Surgery", "fa7aa20b-8e20-4653-b8e3-c30fd2346e88" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "20b53da5-7188-48ab-8581-1a45c82ae6e1", "AQAAAAIAAYagAAAAEODuk+U7F6XypouxJ4QNTQ4GjENvid+tOa+91fmcxXgTVbEG7GoMTFjWcueYaPQP9Q==", "e310c12a-af69-4c13-82a5-e2239ab706ab" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "645d9844-fa85-4410-a722-27c66fc07c92", "AQAAAAIAAYagAAAAEOsx1t89wJxuc0rdZsmypSQw51twMRbQl1cuqjWMYzeWY/BIQqwD9Ju1+vYjHB0L7w==", "dd8b4467-0b26-4e85-92a2-e2c4ab6a7673" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "519e04e8-cbc4-4094-903d-df5193bcd6e8", "AQAAAAIAAYagAAAAEL41dh5FefU6H474pnTdPFfnOh+MvA+z0IxB5BG03rnUw2gPWeH328V4CRf4wznkaA==", "Head, Department of Dental Medicine", "a430d167-2b96-488a-ad5d-db13412d65c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "935a4862-2730-4f7b-aa77-a3279efc5f20", "AQAAAAIAAYagAAAAEApbXq6LFnXzR9vKEKsaKHIa6qEGB5p0MU5JjW5BMbMzOwA9kIowJDSAhlOWOz+Vsw==", "Head, Claims Section", "b3929686-fb29-41f7-bfc6-adbbbde0e741" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "78c876cf-f2c5-425f-91e7-5edb044db100", "AQAAAAIAAYagAAAAEO1yp9qyhNArCv7AbVYSRknVYlVp5WX84VHp68t6bWyf/VLm7aBdXYdPaT4f/CscWw==", "c0f91b3b-f53f-41ab-92f7-d8062d34df35" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b5f7d2c8-66fc-4b56-b8fe-9431678954c6", "AQAAAAIAAYagAAAAENmAjPfYorO7xif1r/kqgTLX/2HxhXhglQvplCQx+vwewqLJCkWsn4KZ4chC4TfhPA==", "35c7d858-d406-4ba4-b280-e5d33ffd3623" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "6f842c57-7a67-4723-b34d-8ca1db3a2032", "AQAAAAIAAYagAAAAELm00QRQBuMlI2m6In/Xlcy5a3Ohnk3lORx0SbFY+xgIOlpxFjqU13jA+/+3BGkYFg==", "3a65be44-bc7f-4fa9-9322-4cfb49894dec" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bc2821f3-cc67-47c3-9d63-8f5347a9d23c", "AQAAAAIAAYagAAAAEAwtwaOcaXdr1gjPW1K507bdxSoMj4FOVCelR6vyT7wWX0ULNkvH+hf5G5z5wYBUjw==", "1ca8bbe4-9b40-4d91-92e3-b204f206fbe3" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                column: "ConcurrencyStamp",
                value: "2b6d376b-aae1-473b-9048-9bba30a280a5");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "79979ad2-5689-42a4-959f-fa25f20bdedf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "f56390ec-fcb0-45b0-9895-83b1a061485b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "95f224dd-3973-42ef-b350-7af30f67c2ca",
                column: "ConcurrencyStamp",
                value: "c52f3bd3-d422-4fb7-94d9-5e415eaaa6a9");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "a3c8f0de-45d7-49ab-9c3f-8e25b5e7d421",
                column: "ConcurrencyStamp",
                value: "fd37068f-b174-4860-8cab-1fa8402a8a47");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "b3f5fbe0-6ff3-4e71-b13b-244f662c951a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "b6b97a7d-23b0-4c2f-9f9a-54d4f67b1234",
                column: "ConcurrencyStamp",
                value: "30014f04-8ba2-4b75-8e31-31c1310a0521");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "e2a6a3fc-1f3a-4e9e-9df0-5f4a6e1f8c21",
                column: "ConcurrencyStamp",
                value: "be8ed5be-52bd-4e14-9f06-60e0f48ba629");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "90af8841-78f2-4d87-bf1c-9a3db8a4f9dc");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0301f6de-6d6d-448f-a46c-2bb32ba97a28",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "4b6a2e15-13cc-4577-b0d7-0f58c74db914", "AQAAAAIAAYagAAAAEFhwilCqAIPEb6PCZUpJ0dRgg3cUtvwMLtnz6zIESdVttttqmGUXStLfBB4FesexlQ==", null, "c280eae9-92f9-4397-a307-2af363ec81c8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "08a7ead1-5c61-4207-8ea5-aec3d6b691d0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "dfc0ebdd-28c5-45aa-ae85-3fe4776b39d2", "AQAAAAIAAYagAAAAECnTSDCdXAB0fLRU0/VS27pqYtm87voahwSjPh7LCyVbAGJ4J25gbvHKVVQbp0XNAQ==", null, "49d16862-07b2-4d9d-8f92-9b1eb2864295" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0b91d20a-0ab3-4820-b3f2-fbcf01c0af26",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7fb3c83d-d08c-4a5c-8214-8f1e2e4cce67", "AQAAAAIAAYagAAAAECo0/3r9cdj2GRoYeJQXsnbI2cluW4v7maLxc4RPrjMNYqA2OhDAOXrE/3qPnuEnUw==", "a204b0e8-7cce-4d1a-8d24-62236cf5e0be" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0c0e6892-41a4-4536-bda7-757dd5aeb4ee",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "67e9af52-c4f5-4b49-ba73-ac7bca37de79", "AQAAAAIAAYagAAAAENMsaQ+c7vUg4HW71zwcG7p3H0ao7bznOGqbv+2GohcCqxG3SZhBF6HjymA+eIuuMQ==", null, "03747b1c-9d49-481e-8ccc-ac39bf74adb1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ed1f88a-8859-4d6c-9a1f-84aaf19cc45c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "273cb6f9-55a6-4060-91dc-051d54a39c44", "AQAAAAIAAYagAAAAECqrn5553qJYn4nSb+RGbiwO+RGZ5yegBmp17csQD6UNIya/0j2c8h/ZLc9cURipkw==", null, "35620a73-7b83-4735-9ed4-92d2a7033c50" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "0ff9af54-f57a-4d1b-a2d6-679b3a4b8c30",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4197e665-8048-4a41-8c6c-cefadde9f9d4", "AQAAAAIAAYagAAAAEMGiOmvLk4cDEfi7tBbZ3bTyjYZypK+1jb6+avHTO6E9m6nB05h8s6xlsQ6+ZGR9KA==", "f1f96245-9b96-421f-861f-d0ed8fcac1dc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "12183b62-26ee-459b-a859-88a94e86c117",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "745aa9dd-13a1-4842-9242-95b3d8666a5c", "AQAAAAIAAYagAAAAECLm+lh7ye0N9RtDF93YC+3AX2hD5z6HASN+Mpvs4XsKrMH+XwAk6FFbWY7xB0R04A==", null, "171092b7-105f-4935-96d2-6981538606e5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "13ab0a0e-5d9a-4e53-a5f0-5cb11a775fe3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ce39ea85-6e06-4ad0-ae4f-6ab944227662", "AQAAAAIAAYagAAAAEMBwShjkLngx8PWbuX/oCYx8eYMuOuosTwmZX+IpzeXg3zYV/xw/8BCLc4TOrNStXQ==", null, "8231d8ce-d84c-418e-ab31-5b79e19a635c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5ad0c287-4c07-492a-814b-c41356ad7366", "AQAAAAIAAYagAAAAEAu1ACmhhBgVY3uu+RDWJfRYgiVAf11BrBPt8LlRyrqLFyEaxeUtJFLwvusmZkRv1Q==", "48260325-2c0a-4b21-8600-8db8d3bf464a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "17793347-1bfa-4526-a0af-0ffcf374aa9a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a0cb68cc-00c1-4baf-9ff0-5741f0ed8463", "AQAAAAIAAYagAAAAEDWUqivorUDph/gSuWD2OX+Uu41AABcflj163UbTsqY58w3KLD5AaO8OFL0FRn4DRw==", "c4463b1c-81c8-4a8f-88e6-56722545421d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "18b4151f-bff9-4525-b787-7a7e009757c3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "92f7ce3b-8e99-4a4f-9e1c-7cb5f830df00", "AQAAAAIAAYagAAAAEJaGxJyU+pKTFr/cYoVqZASPL5ZNk3yoedJmIhVu0SsEO2H8K1/6fv+GDhjUtYyVQQ==", null, "ec56b77e-5a5e-4254-9b4b-626ac700543c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b50-9431-4e23c174cc60",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "dbdca87f-5f1c-4ee3-91a6-f3e8e7c552aa", "AQAAAAIAAYagAAAAELu85s1wX3l8KNppcbhkiGCP6/W0aKSp6YDPaLXjn+gRoQJQWIgmEBlL8LpPifbQJA==", "c5e7c9d1-7f4c-4d18-a5d4-59d3dddea04c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1a9d8654-1c19-4b60-9491-4e33c176cc64",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c3409a41-7422-46a0-b57a-7dde2a7762a2", "AQAAAAIAAYagAAAAEEr7b80hARTudVoZYSE+30UjHJsdiFvCF0yyX6bKFq1a0lrgkKJUInE2dgMojZRaCQ==", null, "1b735a14-cc8a-4f3c-bfeb-f4a44a6dccce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "1b8a5144-b8a6-4df5-bb98-0136d7ebdf24",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "b983e22b-c917-436f-8332-c04998c47a49", "AQAAAAIAAYagAAAAEDiAkrEtkV/UaKmjiltwftWMIiOEmXElzw1MB4XUKQUPL6JIRAOSC/iNFVwkqoKQvw==", null, "5e26157e-48c9-44f6-8ee7-76af01a27d59" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "21d7b7dc-3425-464f-96d5-f6784b19b4cf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e5817f27-a5a5-4da3-b3bd-b7cd422de384", "AQAAAAIAAYagAAAAEEiM3zCoij2enQgCortV8uGMIrbmbYBl45DFJ3fKVtQuGFQCLi5EOMDIn06/y9J7vA==", "8ee8020d-a707-4b81-9b84-76735776e139" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2489fce0-858f-43af-b82a-65ee42cb2e33",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "68f7d7ab-8384-4190-bb6d-ffa3b35b4cbb", "AQAAAAIAAYagAAAAEPag6Qdir5l/h0WJj6X8V0Cnjz7yHcCfkrAumAvP0Vt7T7xFlGl8/0RGNvovkKKkuQ==", "237156e2-1428-4b6e-ba8d-6bdb9c042d8f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "28a2a313-bc8e-4225-b8c2-85c2935b315e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "405de083-4994-46e8-8d34-4902e9a55d76", "AQAAAAIAAYagAAAAEAfhvzr35NhnyrUXU7nhMz2E3PX8jUhyS05JRPRTrI7bJo2yURfuQVsiMtOt0pnw/Q==", "89636dce-fee8-456f-ba6a-c245158c6dbf" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2902eb0b-328f-4c82-a37b-e6b67c1e7770",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "5585ab7c-4260-4761-a105-9b765dd602f1", "AQAAAAIAAYagAAAAEPazzXpNuXDnaOnUbiYMv/E8Q5Lqeln2LthWY0+zV1DTBOriK2aPKF4uJG35CNYdAg==", null, "33dbbce3-8797-4e34-96a0-89c7255e515f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2e889d55-159e-44a0-b9c9-44cc9f25c66b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "85fab4ed-a68d-4c3c-8bcd-ac434212b6f9", "AQAAAAIAAYagAAAAEH4Pir9oYMKLs0jg2+N9g90otinKahAm8MCbkWLKOY94tKYfP510RgpKcO3CUd+w0A==", "b062697b-7e01-435e-bfc2-ba480cbbdd42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2ec1e24b-50c6-48b7-8e9c-18c64a42e172",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a72db71a-ced3-4e0c-a968-ff6288422029", "AQAAAAIAAYagAAAAECXazYDyP1+UZb80g93zglRM6Y/sXhXIsRYKye5IUWTI6Xn9RSRcLshHxFunFxF1Cg==", "85d1d7c5-99de-41e4-97e6-95e15b65c252" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "2z9f8451-1n19-4b50-8432-4e23c164cs51",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "770cec7e-5ad3-4504-b065-28acada6265b", "AQAAAAIAAYagAAAAEIQYJ0YOHPQ0Gw/KNndMneyO9uYs2zUmcMJWZFirpMumKPSEFTJr/dn/UGE4TCu2hw==", "72457f8e-e99d-496e-b41f-1b1ba7c0b415" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "31298867-e329-4dbf-8c68-2e557d98e864",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "5c63f959-212f-4eb0-be11-f5fc00b1cc31", "AQAAAAIAAYagAAAAEFk8kK8DNQL68B+dtdrhbXYYEljGmjC8SbV1atgeh6dAc4ynm+Redt6i6al+ihiv5Q==", null, "67679674-0a79-4642-be0b-278dd4abef72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "32074da3-f8f8-4755-8cd5-f2aabba599e2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "84a5dd05-80fa-4627-b464-a5aea751bfa8", "AQAAAAIAAYagAAAAEDBshYm/5qhLQ5OXiyUErVnSVDU0gBdDpKY4dYG0q98prhEhFt3m8SshPK2fMrwU0w==", null, "4ce0ba9b-c7db-43bf-99d5-b1c6e08b55b5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "33a13c76-041f-4d68-8f67-41b7dd60c408",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5dc172d0-920c-4945-9789-a1b42fe8e889", "AQAAAAIAAYagAAAAEFI//+IqVJTWt89CLYaJGepw/2Ic/qiiqbFce2C4jLBLZD6TWS5ThMfep2K5gSEmcA==", "a6fe74c6-3450-48de-9f8e-68fcf8b082a5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35035c73-8072-4005-85bb-0a91cd97741b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "9202c903-d98c-46a5-afb0-540218a0ce52", "AQAAAAIAAYagAAAAEIWQvy2L7S6Dit6yyjL/HH98HjMVoJJh8dudY1vQm7/ftuAF4W9A2oTdN/jvgLCPYA==", null, "d17269ad-5ae2-4d42-b1a2-21b25039f300" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "35159a7c-2120-46f6-9135-8a8469b9c7b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ae87531a-c8f5-48ab-89ba-c23157da5fd8", "AQAAAAIAAYagAAAAEFIQ/V+ODTw7MPYL924hY0Qj3mkiEbrvVrb8LRWQ2x38SW9JxpZ2ourA196o/TaONQ==", "523f51f7-3a4b-47e8-a879-3406b5806221" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "39987409-6b12-4a73-a9a3-61c7f117dcab",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1590869c-70bd-4520-b2bd-c9f3cb699705", "AQAAAAIAAYagAAAAEMMRbF2PINmRAA18jp8W29/vX365ubXnDFYd84Uwd2gd3nPfuxzty247srybV6/cZg==", "2fa32a4c-1515-4100-8761-f55fecca5a75" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "399f5e43-93d8-4a28-b113-d23eccd2ea15",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bafcdafe-f29a-4b56-b65b-cd0bb7b4e54a", "AQAAAAIAAYagAAAAEBzrG5SCkhcswL4W/R/936aRvebGZbA/Ipc19gH2D6YN5YTuthsSaXav1/16KcNiug==", "c143f3e0-c0f8-498f-8d32-6f86d53cdf55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3a4c88b0-5f73-41f0-82e7-255e19e8d9d1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "50c569b9-18b3-41f7-884a-a6d85c1dab69", "AQAAAAIAAYagAAAAEKn5ffMRBrW34y6w4Bx/NcUvGENxzzKGUeBb77rk02VjA0AfMu3IIFum6xj1Q3IvVA==", "2b640e42-53d0-43c2-9611-c7453d07293e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3cfa9401-553a-4ac5-ab8d-3d65899090b3",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "e7593897-1fcf-4265-8f09-fae3acb871bf", "AQAAAAIAAYagAAAAEHi1Hps4Dhd085OShLQPOrny3Ha3nAg0AXR3FX43TbRMDnWOaW2GMaDqO5gmBoMZrw==", null, "b45b435b-0d6b-4bf2-beec-999c62ea0897" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "3db6b5af-4b42-4747-a3f0-3a60b3e36a56",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "621a05a9-0baa-4e73-9af9-1eeead4b0896", "AQAAAAIAAYagAAAAEBhcYh3P4HMGgZSEfYc8HQjkPR+vH4b52v6+ifk1jHfeOkXzMDLflsFRRJ36MheAFA==", null, "cdc0639b-75b7-43a7-a742-2fee0219f55f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43cd6e17-9d86-4cb9-8d84-298e43a23450",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ef8eb64e-6e09-4214-b39b-3231899004fa", "AQAAAAIAAYagAAAAEJA1iuRWuylNtD/MyLggl5JPGDi4dGa+z/xqUP7wchuXH9DTTSraAs4/QD1QVUDUuQ==", "0e22832a-3fe1-4061-b808-8ca65526bf94" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "43f6a708-995c-4a07-9e90-6d0a5efc32d5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e346ecf4-210b-4bbc-877b-1aee82f8c611", "AQAAAAIAAYagAAAAENRcN1phTg1y8oQ1vtZeepoyoDvTKaFen2e/8T85/LvGFV/n5Hv0mWw9yVcn96KRwA==", "46a277f5-7013-4fef-8fd6-4c6a99b8cb7a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "49180f4a-cbe7-489b-8fd1-901e79dfe2f5",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "9de2721b-7f8c-4c51-8890-4f507344078d", "AQAAAAIAAYagAAAAECD5DZb8KudgDF69khCuDD1o1GxpFD3t1dpQocdnF3IyUPbHV3aHHjsRRYyMGjjgfA==", null, "2b4c2207-e5b7-4518-a1c8-74ed4436dfae" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4e21fe59-4f5e-46b3-82b7-28df270038da",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ffa2047a-26d7-40ee-9e4b-e43c56857719", "AQAAAAIAAYagAAAAEA/k9eTrqmpbIKI+CZqKcYllWP7tfnWZntM6rIieZCA6NY82GazSpGn3+FyNDtUxhg==", null, "c1640458-8c1d-4e94-a04c-775bdcc5034e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "4f5b9c31-d406-4036-b8cd-37cb92d6b211",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "25b138e9-6525-4f55-a1cb-59e702d37597", "AQAAAAIAAYagAAAAEC+rspgG79N1bu3//2ykbiT8p6KjuYBTZIWdPF5hC5TqUkff9HkbtdLs1n7Xzrub0w==", "4a8415c7-ec87-44cf-bf51-b881fc159f02" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "50e3ff41-8195-4d52-805a-d55efb68f08a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "49c19618-ffe9-4bf5-988c-051310414233", "AQAAAAIAAYagAAAAEB6GTN/AjiX6nXVu1KZm9zUp4MKnR85nftCSFom72QNWm2NHF1NBFlI342XA/uM91A==", "3c396ce4-d36a-4a4c-88ee-be71e4a438e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "537d9fcd-b505-4f93-afc6-17eb8eddff83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "2ee6f52f-8874-4fa0-a3d7-00a4267c0d0e", "AQAAAAIAAYagAAAAEFtqZKVD9PGP+RxnrixSSVFWboWdqzrs+1A1G9Y3p6VrHxoGXSKXcE327vFNNBdtXw==", null, "d37d464d-6a23-47d5-84f2-491b2f973b53" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53a2b071-d36f-4f1f-bf8e-3f7dbf7b8c7b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "9f8fd49b-247c-44b7-9808-2cd26df92bb7", "AQAAAAIAAYagAAAAEIM/2QkQSiVYHvcB5GxKJgz5/ccPrUY7d4jhTO+x+cLG7gwwixMGRe97k6zdiacn9w==", "9ddf66dd-733b-4ea6-bdc2-a33a28cf8be6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "53ac9d08-f52f-4a25-92d7-10de53f612fa",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74953cb1-f234-420b-88cd-3bca77f248d9", "AQAAAAIAAYagAAAAEEiumYDcchxPlhnBHKTfYh2rNtRR4NSTZBsXlYm3A/BboVQSJz62Ub81F67P3DIUPg==", "e5c70cb5-3b2d-4513-b9c3-9982269144ba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "55c79a0c-4f48-472f-9d13-1801e2e5c167",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "4352eb48-6b3d-4bca-8e43-050b1527d5b3", "AQAAAAIAAYagAAAAENetrEyYKfd3RjDxl72fGklHQXk0kGpAJD6wyKBBLsMKCY//xsNWLYMnthID8Y7cZw==", "7ede707a-d298-4900-98d2-b6b2d113674c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "562a00d1-f6de-4c44-bfc2-b55e99074bcf",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "887f11d3-f657-4072-9895-5679426d89c1", "AQAAAAIAAYagAAAAEKB+e3asQmfIJHrO7kCGb8NcLUf3akVmjKNxEEUaIm6g71z6118+0VIfzeiAsYoz/g==", null, "ae100b7f-ab48-4f2a-a821-89caf191db37" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "56731842-6b12-9a46-k9h2-61c7f212hyex",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "94cc70cc-cc6b-45d7-880b-b7307f24ee06", "AQAAAAIAAYagAAAAEHw2QLst0k8J42R8Q31zMHy89hyVlZYe9iic3SzRMrk0T6hJvwTgGetpdzPdt1qr+g==", "be188223-47fd-4f1d-bf22-bfc20decc5f9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "576fc42f-b0f9-433b-907a-29d98ebf7af6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "901697a1-e0b7-4071-8ca5-751b013c8051", "AQAAAAIAAYagAAAAEMbf3JDZI8gV8So7S3RmPTdYrFuVIszPfcXGB/sNsOeP9XTScHMI5ZN35B93OcI7Pw==", null, "6b077883-fd5a-4e80-87d2-5c636477cbdb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "59b4a3e6-30c2-4a8c-8851-78b95cf11f5b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "321d1f5c-737f-431e-b60f-737782dba142", "AQAAAAIAAYagAAAAEAlt08D2NvqztKGzfDTAMfI4Mc+4LtPCTsYCksB19Wuks+ZKuWP8EbYAiUZOhyrGeA==", "198a654c-5065-4301-b9fe-763e2237ca8a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5b7ff0c8-b6f9-489c-9f1d-9faadf9e6c6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2a59d1fb-5788-4d3e-9e66-7b506d3862c8", "AQAAAAIAAYagAAAAEMyEt9pao+3X9RRqo9XJnj9TqYXN+FObJ6scB81s9ArLKqTzf4UWNLdFxc2jByrOWQ==", "d833aa46-a7fa-4d27-ba0b-55d21991e0b4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5d8a2197-b38b-40b2-940a-845e2a44b622",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3db5050c-5e9e-4f81-9481-ef73d9e0d12c", "AQAAAAIAAYagAAAAEPEQMLCyEXQaJGNdMyiKZOedqm0vTpeUsMJWmmQPvekC9T9ummgaq7QSxdlFuaSKNg==", "82edb41b-66e9-4c07-a7c0-24a868437c20" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5f33b779-c424-4e4d-89a9-7b8e5ac3e98d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "02737158-99d3-42df-836f-5a2b2af9708f", "AQAAAAIAAYagAAAAEEI/6R9iUpk3Nz3CIdBhENog0E9AwMc+1IsgzNC/4HXkMnKXMdJPn/El+C0I2orEmA==", "6fed55ab-3714-4575-b726-eaf1340d68f5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "5ff58cb5-9d0c-44b2-bc2a-5f96a3c9d621",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "00c456c5-0e28-4c3b-ac71-740d898d4fff", "AQAAAAIAAYagAAAAEHxe1cmz6JC4BuWSkssL8dHydu7XCoBfl99VKZkQNeyM7yurR1kIzd+khY3QYPrHlA==", "dd12714b-60e2-41a3-b1e1-e90a72a39a58" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "60cbc60f-8572-47ba-b70c-cc328c363bd7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "023ef2e2-1ae1-4ffe-b9c0-75275750576a", "AQAAAAIAAYagAAAAEMIXonDAxA92IiXBfjppzum1voudnl7Zkin8x4yr18Y2dQexHjAr2kaVjti+WAA0Eg==", null, "29544d71-d781-4938-893a-0bc76037ff99" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6517b46b-eade-4618-984b-525a31aec14f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "f4e1f7fe-01fd-4dc8-8f21-83625334c8c9", "AQAAAAIAAYagAAAAEGtCslUgRP9BKimfh0BKChWn271Qu5trti1qj1FabwE2aw8N46fv7CtkN/PEmuh4Pw==", null, "d39914b8-8045-4e90-8e9a-f98b6516b513" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6c8454ef-fd19-4db5-9f88-dcd7b13e5c55",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "5f43e347-f703-40a1-abb1-fd904d944a21", "AQAAAAIAAYagAAAAEKmGuEion8o7HC8oM159EdEqMbqjBBaV5kNI5axxcD9pUAVGur3OQVCPFGqM9Twdvw==", null, "60e33bf9-b033-4806-8dda-b35e8179f7ac" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6ccacdfe-d21f-404a-a09a-fbb0a8027c9e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "e23acc8a-4d22-4a7b-b762-de25fcfd03e2", "AQAAAAIAAYagAAAAEIc1ov1hbX1UHg3i1s4pFIQwU+lt08HPGQLGX4RGl8HtNApBiAN6xegwAprKXu1m4w==", null, "f376ac40-ffe3-4be6-8e6a-7dcd292beb2f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6db39f4a-9d19-4fc2-b3ab-2aa37851bb71",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "f3b32b40-0eb4-4fb3-8660-67b6c2c8f67f", "AQAAAAIAAYagAAAAEMhBs/gF+ONifS36oTtr8bkgjt3Suj8yt4zuHnGlUjdt0i/pfMh5xvF6iAfJmdyVQQ==", null, "48d67c6d-f7a8-4356-b703-b65981361102" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "6f34a16a-6e68-4d8b-9f6a-0e0c07a09ed8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1fee9185-16b6-4a6c-9f0c-22d3cfd7293b", "AQAAAAIAAYagAAAAEO8VZxo+cxSh/6euBSj8dgLyM7bPLU312cVAGKNvaU7lXCEjKHn1qwbiYrXP4axSZA==", "70947790-943a-4ff1-846d-677cd5fc2125" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "743b9807-3441-47c1-9285-5ff8dfd7acb9",
                columns: new[] { "ConcurrencyStamp", "FirstName", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "139fecff-b91b-4073-b106-562cf7685515", "Sheila farish", "AQAAAAIAAYagAAAAEMBhCVolvF9+ddeRMh3EIb7vJ9fx0bQm1gQmn4dLBxNBe72ot5o4U/6VBU7EuySZvg==", null, "3fd4eef8-8a03-46a8-a686-09b306dd8729" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "74c35794-54d9-44a4-baf0-b8fa23e2d481",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "74698f21-ed17-490d-accc-c6f75d87fdd1", "AQAAAAIAAYagAAAAENBRNPhpE41jQkSTw5PjCCBD/oSoKZIFUDO6rgKkjtOhHs2QS/SNfRyBtul7X0Wx6g==", "63aa197b-2445-4220-b8dc-c3336af62952" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "75228ef1-9a3f-4a55-8181-b1794ec72e8d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "2f484ff5-05a8-4362-861d-072bebef4141", "AQAAAAIAAYagAAAAEB07/U50kKhWQbBZ6+OIAurtuGMq0tYF6fDaGiDO/seDxSFz4Xg2UGdZ46NaEjB9FA==", null, "f5448f29-82e3-401c-a7bc-32a8ba4fd7c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "756c27c7-7637-4525-9b85-c1f41c0c5a8f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "fceb58a4-55f5-4ed7-b19f-32bd265138b5", "AQAAAAIAAYagAAAAEOBQe94KOOHrs3axMwNVeTjimApANvP5dsyO9hHRyjEnMDSt62B1GGgF3O3iwHsOjQ==", null, "d74435e6-cef8-40cc-b76f-dc5c39688c26" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7acb06ae-c2de-4fa1-8b62-53c1d63121f0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "d3a3c4df-49b8-4a48-a386-06c115067303", "AQAAAAIAAYagAAAAEEVG6moBxIFVHEj1ajZTYby95iOex2opkrTd8+Jug+BChP//9tiMTaoSBWBtoNVPtA==", "2658a62b-3ed4-4eb7-a1b3-08728c71a184" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7cfd0766-f3d3-47aa-9a48-53d437d6c232",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c144d25-4476-4331-b9c8-a306a9be288b", "AQAAAAIAAYagAAAAEGwrSmwlZ5ZkpRYB+ovBl01E6OsKF5gg26DwNO4X9xtoS/Y3yp7JIhtqJJynm3gqew==", "13bff817-2e7d-4308-99e2-3f5ed607b600" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7eee5b08-df0d-4ac0-a8db-39d924dd30b7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "04f35e50-4312-428b-8270-cd8ed4590ac6", "AQAAAAIAAYagAAAAEAHARtylBR0cWsz0rSLy7nATk/jjPmgC5u8OBDVlZD6vuxB96aC4Zt7Y+GJ6LZjvvw==", null, "5bdf52f0-29d0-4f4e-82ab-bd249f6d257a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "7gf2b7zj-4b42-2476-f3f3-1x72b3e34aq68",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "146129da-c433-4461-b844-7277ae9e3c83", "AQAAAAIAAYagAAAAECjAS4HCdCc4/T507/P5z2M3+1dXtFu8rcfjUqOeE1Lu+oZw+znEq6VHhZ+EKHw8sA==", "3715fe18-0c46-4029-9605-e201d7b0cf42" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "827e71e5-479c-47a7-8f91-16327825a02d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ae183739-fcac-41fa-9a6d-ac7cd1ad7470", "AQAAAAIAAYagAAAAEMFqmsgo42FuBqwT6lliRwKIu6flx0horMCnv7Ir45zsQ9yjbMg0IfTAWwjg8R3nrA==", null, "adfa0053-998c-4fae-9cc4-72ff6684c590" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "86e65501-a4a6-438c-abe7-5ec802032bd4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "699064a6-5673-4153-aa4d-d11678de2b11", "AQAAAAIAAYagAAAAEOzhqMqY1HMB4+Chs3OaSQz4l82C1Rzy037xdiR2IYr28gByH/cplQY6/HbkFw4JZg==", null, "b17dc0eb-c102-4ceb-8160-d617148a6e86" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "87234d0c-41c3-44e5-8cb7-5d7a7a9209c8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "91568d68-ae4b-482b-b86a-464aac1b779f", "AQAAAAIAAYagAAAAELnwIHDufX5eQG9M/gU2scofiYjgczdaM4igp1sK4kJAfHCIl7YGY18KPZUEuQzDwA==", null, "d454c0b1-64a0-4a82-ab34-68050224a527" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "88a1a0b3-943d-47a2-b0bb-f1c8763acaf4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "c982d93c-06b8-459f-9282-ab7595d20112", "AQAAAAIAAYagAAAAEE+ALqSZHt+fKe4AMEOTKvpXP5H0GrMzZx1MIhDuipn3iuh+PVqj+Bwhx0tRXELphw==", "a5779d96-9fe4-4454-bc8d-06cfe745e3bb" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8e4f430c-72da-4142-83d9-cd9d9c6f2a6e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "3bcb4fdc-42d9-4ba0-8086-124a6057a2dd", "AQAAAAIAAYagAAAAEMK5qI9WBJF7HkoyW5UWJRP4KB/wj3JHIcXz2UcxAEg03ByEZplIx4WMNNKPSECm+w==", null, "15b9a90f-f9f9-47ef-a5c0-8ddacb9ad01f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8ea08a3f-066a-41ac-9ef0-ffb47d3657d9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bbb48d17-c178-4a9f-be83-f2900c7b0686", "AQAAAAIAAYagAAAAEEwT4Ye+8ohmjyT0Q6B88kuabBto0ZnRmRH64iJC3xk9AeF3Fc8wSj3vCM5CLjCcYQ==", "ef5b09d0-cc52-48d0-bebf-e44449a26622" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "8fa3f3e4-b8a2-4375-9dc8-91b6fbc55e4a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "4cb62741-2bf9-432b-8867-31a522bda540", "AQAAAAIAAYagAAAAEIUeG1u+JRsQQpwavctU0D5R5cMZICGFcTeqEWmRwXKtunWNpc9cEZV+mt5DuMzqkw==", null, "7ffd3a95-ea00-4a65-9332-f6ae61ea7097" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "969fb51f-26aa-4637-8a8a-96247c7a67a4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ddd3ee5e-4976-4544-b2e0-cfbc29873c34", "AQAAAAIAAYagAAAAEKb3nuDsiEK9L3IhWszIpdKfkiufq0zx62He4RvEIB4gYaZfxppT9hr2NOxZoy/C5g==", "28b31136-59fc-4dee-b40c-6d122482adda" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9821dbf5-0f70-4630-8c68-f2077a3abf08",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "147d041d-dcd1-4cfd-87de-6670cf07b1a8", "AQAAAAIAAYagAAAAENG9RG45i7ivhcx4bTx94p96gRhtJR6pGodzbNzB8no61XuLJzqASBtzH4NqbRDcgQ==", null, "8f1a6b22-68e9-4a5d-80fa-43ee12ed3526" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9b6d73e5-ff27-44bb-a9d0-f7c58b31c4a1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "40a665fc-69d8-493e-a393-1fb3824377be", "AQAAAAIAAYagAAAAEAcUtTjZ0blUzgaJLUtuxgpnKW8FH3mHODOhFPUZ+I3RITmJF2M7HgS89FQRgpO2Xg==", null, "9592be6a-c05e-40ad-a693-1a89d0ab8f11" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "9c49e0f2-4cb0-45b1-9f0e-4fbd24d25368",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1c49b206-a7f1-493d-a453-6eca5f5952e3", "AQAAAAIAAYagAAAAEPpxQtoKvUJrB+niW5VZk/nqvwdGQOuvBVOAWrzi6ViMGWoVO2n5bf5MBvKK0O5xNQ==", "ce1e580b-0b67-4534-8e4f-47d785535328" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1a6e8f1-4749-4a8e-8f9b-0b6b2f05f38b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1de784f0-a745-4157-af9e-395dec972332", "AQAAAAIAAYagAAAAEPGh8ZdM1tzQBv4ToYlbHq7T2/RuRnS+K0vQHZYU8rDBipk5JUYV5FhhmWrCyZhcDQ==", null, "12f03a40-52aa-4355-9c0d-58d01a3765b9" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1e10c26-4d1d-4f9e-9378-1382457c82ad",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "be63bdee-c48a-4069-bc49-eec8e89f117c", "AQAAAAIAAYagAAAAEOAcq9IK5cxUGr59+UkzvpZeqmyEaAZwXG3AolbBjrxc4ibUYyzHmiAXmb2zfUUj1A==", "5f6a5e43-878d-42af-8aab-eb2602286ec3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a1f6d353-df11-4a17-b2be-49371b8c223d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "774e0e26-35ec-4c8f-975f-31ec7954cefc", "AQAAAAIAAYagAAAAEP6xl3s6xae7srQYWSxY7s9w7UgvBmZ6VYymGDgncxZWUJcMDD/Jx2SHaqgbY0Rauw==", "c11fa97c-b2ea-4257-8480-a012a8be79ed" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a2a9b64b-1b54-4c49-90e2-4dbf1e59a98e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "54fc07c7-59da-4f6d-bd0c-289ace960462", "AQAAAAIAAYagAAAAELhfNmVrJq3LtlZNu/oDmbv+ZRGz7vGReZtJk+Ff0EzIpefuU6drBzHIcXLILscARw==", "feb96e26-600e-4d2a-821e-e01f6f0a1b61" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a452e452-d791-439e-b390-d80dba5ffbc0",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1235d3a6-07a6-4940-a1ef-defda93be596", "AQAAAAIAAYagAAAAELsO5db3rS4pj+37QBjnTfvnEm6YD1jXj80VdFxHR6MgrlSLS1oHpWdcYd/wxltisg==", null, "c843bd0e-5da1-424e-bd3e-bc6b84062923" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6866933-92a9-41e7-9100-8bee51ed0ada",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "69490b87-e4b0-4681-a791-298498a40947", "AQAAAAIAAYagAAAAEA6k7aJUPPIxlahBjnyyLsWZ7022X/UvE0kV+jMXrBeeeU4xsN7PAj3YNQT8ebgijQ==", "a17f320f-b84e-4407-8696-3ac5b5e24157" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "a6b59fd2-75eb-457e-90ea-d1d419da5f6d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b6658cc4-7945-4c99-a4ca-37763f48580d", "AQAAAAIAAYagAAAAENgPsF4/pScrVGYGUUYA3/X8XPjTPZGOclM31EvfukMFiXt8xT8vtAAa3AMNewrUnw==", "79736027-cb41-4b97-8f18-9e7b37526c24" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "aa704a60-ad3d-4148-90c0-316803202de6",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "841abe88-6bf1-4a84-aedc-5c34109014a3", "AQAAAAIAAYagAAAAEDGtXoMc0aNNmCDKrU07t2CppfyEi6jwnhwzCHIDqxmGBV1XCYUGpw0RLIiixP7wSg==", null, "c29298d9-da74-4f33-adb1-dcb5d9e6765b" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "abfc1b6f-9f29-44dd-9c45-cdcddaa6eb83",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "e4327f14-5251-49ec-ae88-16ad20b44a5c", "AQAAAAIAAYagAAAAEFq9x6kB0aDTffYV6mlmfXrWkHOwNB7kmBDMV9lyfEjjqLRATN84A9ECoDIBuRDYyg==", null, "f831a37b-07af-4d81-905d-f8498bf9f75a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b1ec6cc6-9920-4df6-bce0-b22b107a476d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "66d657d2-c86c-4754-ac3f-c7acbe18fbe1", "AQAAAAIAAYagAAAAEGbDmdjMiambFKRrCnnDE17Pg+BZtWQDwt7zHz+ux8ZE/5huvGrmY1N8DGUacZJltQ==", null, "e59651b2-af1f-4b70-990b-c9f0d32adb58" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b4d73e5f-f530-4a4d-9c3d-0b364236da6f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e32df423-b3bf-486e-a851-d375b3f487f1", "AQAAAAIAAYagAAAAEG1Ty6xFkQjvQKtw4sXoscuiUtb5vjLtkzm2uxIXiOuEEaSm0gvJCtNoTN1VDtO0bg==", "1d0f332f-5ed2-4696-9335-e4a63ecf8a39" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b582fc78-cd33-46d4-a994-8c43789600ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "e4909002-c794-4ad0-b522-e1e9aa0d88e9", "AQAAAAIAAYagAAAAEHfHed4KlzNmRmIVr/2NEJWD/vkm3Lkuw/a4oNclGeiGlhRqLL1RA2N79uoLdZMpfw==", null, "b762396c-dd2e-48b9-b0bf-23112498ea1a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b5870b06-0240-4d35-a6b1-54a76c1e09fc",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "2dd2c5e8-89b9-40ca-ad17-4b82bbd241c8", "AQAAAAIAAYagAAAAEKVWWu+XZmvaCLR7Yl/1f/I3Phsi/951In8YW34B0bpKwY4uFowzyDS6CHb80J64qA==", "4994059e-349f-48f4-9768-785b6c059e1c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "b83670e3-3d7c-40a4-8d07-5a3c3f6bde91",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "0149b8d4-ceaf-4545-acf4-94ee17c04122", "AQAAAAIAAYagAAAAEGkjVl9oazUFab2O4dtfhImtEw9jCZmFaiPK+LFFiaT1rRcawBYKCxvmALJDCoyA9g==", "809abcba-6007-4fce-8bab-e1456d9d6c56" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ba16dd9a-fbdb-4ed6-9cfa-b972bda73917",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "56daad0b-eccb-4621-82a4-6a33322f67e6", "AQAAAAIAAYagAAAAEC2owswt/4gUXy8NgurusNTguctXpbO7QZrOmEZtTrteImaloZCpHq8SAiVcUkXFCA==", null, "3b6d5eea-d6df-4050-b30f-b48f67015a82" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bacdfd11-acd7-40fe-9fb3-b8831f94d7de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "42135be1-a2ea-424b-b4d0-b2cdf452f784", "AQAAAAIAAYagAAAAEPU+o9tZkGnsiyTtL0+EXrt7X6+VIKUqL4fHZkMLV7U4ZlX7Rq5Okj0CEH9fdozT1g==", null, "8129a6e2-ee00-4bf6-99bb-a9ba1a69b9af" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "baf0a172-7e0a-4999-8c03-8f9bfb62150b",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8672cff6-3ff0-4751-a353-bc01f07c9a42", "AQAAAAIAAYagAAAAEBQo8EtB75cXBzfpBWDnEOT7gqNHeif+vnEzd4a6KEP5OR2mvKryA8vp5+8fbTj12w==", "2d2de7a0-6a2c-49fe-8128-3129c910e70a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "bb22c692-bc14-44db-9a6e-5b0196c9a8c2",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "81f3031e-bdce-4f6c-8064-d1d773283a73", "AQAAAAIAAYagAAAAEI5kwlLCgB9tUeNSyvWA/acxhqulplqpvpKkR7Nj8tmIxlSe0o0jB89Ta4cQ+9IVlw==", "163fa1c1-f8fe-4d19-bb2d-41eba05137f4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c0b41f2c-0f8d-4a53-b0a9-5cfa02b6a851",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "3483f665-df43-4ce9-bff8-17b447e59e6c", "AQAAAAIAAYagAAAAEG1K2axI4FYTBDUjWa7txURbKwAS/BYg9lbZSJD0YF/giSjbFODDEAV5gyPM00ZBEg==", "62fe9da4-6c68-4e82-95e5-d8a2d4ef3549" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c171e56e-b2e0-43f2-91f1-8f258417bc3d",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ea996af2-b420-4c51-abd6-9fbc99f363d9", "AQAAAAIAAYagAAAAEDQYp4MK2NYMo6XWqp9sZcAVvtdudEe+9wgON46H+zl2D1usZn+0xlA4KllJfIOubQ==", "1852ae2e-b134-48d9-ad5a-e5b6dfd0d9b3" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c54d18f2-9a21-4f72-92eb-1f5d6e8f58de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "fdda0ca2-17b9-4b62-ad7a-7c619031acb9", "AQAAAAIAAYagAAAAEHpRjfgRDYcmBVozUVB39JEiRueHCOMpfn2/lwovxVx2P7mJG5cIgVCc0GlD9V2GgA==", "082e7c12-34bc-4794-a7a0-065bfe5d798e" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c77b5df0-836a-4f9e-9f29-d2f6c6cf4074",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "121c7fcb-920d-4bfe-bfe0-19c54e6e97be", "AQAAAAIAAYagAAAAEB7JKa/GHhHnWajrdn7IxLIZs2j1m4w/HSsBQGE1rHLapACmbPUaY5q0Nqwfykb0Ew==", null, "b354e640-1ab1-42a9-8907-2a7a77dd9def" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79be729-47b3-4907-88e1-0a67dd4e48b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7eef20a5-9db9-438f-990f-84ae0bbffb76", "AQAAAAIAAYagAAAAEL1E9z5V7cmCobW5emESbq2fyDAy6kJSJfekROqm6pzuZOTUHf4e0z0A/EzpsOLYAQ==", "3e28fec6-3870-4f46-9bde-783385941321" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c79c6433-d1ad-46a3-ae87-84edb44476de",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "0e9c31a1-ad29-4ee5-a8ba-bab6e026b7fa", "AQAAAAIAAYagAAAAEKKQTpNhFJNee5aCwb3ytpF+zOODMkap0GtCiLCrspRebSw4g3xPlB2pf1FsD54A5w==", null, "515cb347-16b1-4cc0-a519-fdee03549a45" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8463e9f-8ac6-40c3-91b1-2385f6a91eb4",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8834efd5-dcd5-4118-bb15-6e3981ba73f1", "AQAAAAIAAYagAAAAEHN9VT17zFQh8xNy08KqTuBYdXHGGaveGSur2rhHjd1j6xlsvv1+s4unqP429lc4Pg==", "4989c29e-9bf6-4b4c-b330-fd8c90cc5c0f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "c8dc080e-2c5f-4a8e-b0e0-9c29dc45a31f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "b94b5697-2ca4-4b4b-9ee5-8caaf0e8153a", "AQAAAAIAAYagAAAAEOyb0+MHRY9CRx4OPUmuw6QK7zS1KAaq9J93BemsrtrP5oKWd1m1wWJj2xrrtUz91Q==", null, "47e9de99-b85e-4f64-9872-ecdc7722a200" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cade94b1-d0d9-4ded-a46f-c8473d9fbc00",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "4a4d79e7-61ba-4dbc-b18a-abcae9f6f388", "AQAAAAIAAYagAAAAEDDsiBkp9Fy0dmgFXwo69mqIaRt0cxfOaIdfVlNgMc0UB1sn/mMRMq7gkHP5aHidXA==", null, "47303d95-2169-46db-b904-73135a236824" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "cc505df2-3586-41a1-9d44-b5fc8f28e3a9",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "1a58156b-79b0-4797-a9ea-6b11b5b51061", "AQAAAAIAAYagAAAAENAvHxvVlZsXzIuNizhBTQOLvgxnxqHONWr7HI086xvO3SUJU1j7CZaylTCiLyIJSw==", null, "4d1360df-38ee-4a70-92bd-6cf0e1f0f8c5" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d55b7093-1298-42fb-96b2-b12edb1cf49f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "ccb65042-d987-49c6-a663-f56ffbe2e04f", "AQAAAAIAAYagAAAAEAbZyOBl38a7yzkL9HkvTZvbVTcxTtSi1ZvcQHZZ6kHPd2tHkuS2T1KdKgJ7jr2kOQ==", null, "377277d0-1aa0-45ea-8d5c-c115bd07a6e8" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d65e3f58-b23d-4b83-8b15-15e66565d29f",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b11260e9-2786-4318-97f3-2ea04d4a6de4", "AQAAAAIAAYagAAAAENjr/HXpHbTyT8xphMdjeQmwycrRVuJBdhUFaN0KJlN3VHG37DpV7pstBvxQMzYMLg==", "92841fa1-f54c-40c6-8231-d709d74dbf65" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "db7fba3d-88fc-47cf-b119-f868d9196f02",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db3249fa-6298-4949-bd0b-9041ceaa9753", "AQAAAAIAAYagAAAAEFBvCQeVvfGaPPWOniwV5jFg87Days1V4jcOiovyJ4jY6VV932WsuB2AL/03ivpJ7A==", "ac70608c-e4f6-4bdd-907c-a2dfa4918b0c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dcf663a4-36f5-4fd6-b124-bae31e0c9e2e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7edddf72-5fb6-4e7d-a94b-bb3226724086", "AQAAAAIAAYagAAAAECrYdd+ueR2Bn9teiEHF5GR8Mm0SjCb31/x1dbMNuBV3PAdO7upDs7BC8X93GV40Rw==", "c5c8bdfb-8be9-4252-ae3d-f7fc6147d3ce" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "de17cb47-83e7-4a6b-b97c-13808e14a7ff",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a269f318-9441-4284-b9ec-f66ea40d4302", "AQAAAAIAAYagAAAAENy8Imx4QnF1tf5dUjzwlaOPifsAojUuKsoQ0Tu2j49EQXv5B/pf2IDc3FLVQNsSfA==", "520784b0-3991-4be1-b3b7-e6832e5cf96d" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfb15a5f-9f4e-48e6-b781-f4a62c5bfb0a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "0a9c381d-a265-476e-b16d-1d2c44d4770e", "AQAAAAIAAYagAAAAEMVn3GK3OacNc3ENOXPJ+qhL4hVOj/9iR1MpUyEAT6bKvpZTDJa6EaQOOid76HIuPg==", null, "52f8f323-6fbc-4338-b752-c1f004e4d2a4" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "dfc40941-0cfb-46ed-8991-e285aa08c20e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "bbfcca3f-0e39-409d-8c5b-cd6f3d8fd214", "AQAAAAIAAYagAAAAEHTFDBrM5NQNqyA93/AyVtVADHlMW55+aBEP7nijcJjeLUJ1GY0Njn/ynZPC7Z2sfQ==", "6f6387a9-5585-4746-96cf-e890f9648398" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e1a3ac20-1d20-4f37-8826-242657a746c7",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "bba604f4-afee-4dbe-b63f-e6f5f02d2faf", "AQAAAAIAAYagAAAAEB8v9mK0tXjB3v342A4Gkc9ax5M8svJMP6rrokHU+U7+6Wbtoh1q2wUb7REZo3HGaQ==", null, "3bc65814-9ee5-4654-a603-9be50956f88c" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e765e1f5-bc17-49b1-9c3f-8c5c2c18b420",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "862bb26d-5879-4376-b485-189d9bfbcc7d", "AQAAAAIAAYagAAAAEGVEWpbRFc04qtgeR5PzXPnTCUdjODPyAWz1fApepOMF5L5MhwCgs7HuNuoIggPiDw==", null, "88e6c8ae-2254-4f08-8cd9-5e4e3f248d86" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "e9bcc340-e63f-40e6-8326-8fe86cbef923",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "d2fefe93-26d2-4caa-8ead-2250f2c0abab", "AQAAAAIAAYagAAAAEHmA0aP2A0YQnGQGAVJSiahigKfSekMr0JZDEPYluWgFIP5ikkllg08olq/Zhuk+bA==", null, "8a91bad5-9aa4-4b29-ab7d-20765cf8e8b6" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ec4219b7-dfc6-4966-bf2a-3f1eecf17391",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "96cb3eaf-ce40-446b-9646-eb060403b0a2", "AQAAAAIAAYagAAAAEFyPM9Qgzj06dOF5nRaL7YFJh72HBChOCCSLjSM0wv15T92+1Uf/v3KYA9Dgu6iHJQ==", "b12a642c-ff84-4fd4-a4dd-c65230263505" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "eeadfae2-544f-4a5d-9027-808537e694b1",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "95b93f9f-87c9-42c9-a764-3cc7f4a8373b", "AQAAAAIAAYagAAAAEJf8f/6uGrRxNn4N+MaJnpWuwTnRVHVhYbR+PPxSRrgIqcyuUg3zQ8JTzyZ094CcTg==", null, "7b3c1c61-e6a5-4884-a75f-918892f1dedc" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "ef529a6b-b381-4db1-a204-913ba73a6721",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "04079800-341c-448e-86f9-06c5d651b250", "AQAAAAIAAYagAAAAEGC4kx9QQ178CM0d6yPNy3EK2xzI9D6Katk+tpf6BL+VIOUoVdrXtNv8HNa5VU6Zjg==", "52302a54-ea2c-4c45-a266-32e07ade065f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f03cf528-c2a5-4820-91a5-6821dc5350f8",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "486e10d0-6857-41d5-8def-3924f3a537a9", "AQAAAAIAAYagAAAAEK7bQxMklj9FPi98nSmSlTYupr8L8Q5Ee0gW30GBhZAoVCNk+7R3hbEdhvQzqQX4Bw==", "a955bcc3-05fa-4a0d-b345-5adf1f8071d7" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f23ac0c6-68ac-41c8-94ff-383acbfc3e41",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "cc52871b-7ca8-4937-b3f5-334c1e4d8354", "AQAAAAIAAYagAAAAEOMaG6KHc/n5HQiar+lDy9snCptoFaivPijAQPLxn0+fYKN/pkS83p3Hr2h4bz7GuQ==", null, "c8338d4a-f34f-4bb0-853b-4fc66eb35f70" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f2b28c8e-58cf-47b2-8245-33a7a98a7344",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "Position", "SecurityStamp" },
                values: new object[] { "c37cbba3-79ab-4725-a200-353895ab9175", "AQAAAAIAAYagAAAAEILTNVP333y1UKrPhmvQ1VQ4fePdZUeIWauhTcJ2qxbalmfZhOZ7EodRUYXAXyq5Pg==", null, "5ec9af25-dea0-48c8-aa05-4f03d9542ed1" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f79e34aa-f6a2-4ff1-b2e0-4a7c8194e61c",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "8711456b-62ce-4a32-854d-cc344bf37dfb", "AQAAAAIAAYagAAAAEFmuj/EaN1zFWGbvfHsiPjFCVPI1S2I8MDys+0nOKDjJNFE20dMd+4RYHwDZkRUvpQ==", "19432875-fe12-4d03-b2b9-06ef3761e435" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "26c6dc9a-0740-4fe3-8272-b7c0b36f6e13", "AQAAAAIAAYagAAAAELGHuVQmTL0RhwpIA/HsYMXhJBZB5eVQIuDGlyvZi3ciU7YCndsyvdRnqWK0Qe/JUw==", "6c12a807-35e1-449f-8980-07739233df72" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f8a17354-91b3-4c0e-9b71-d6af05f4e11e",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b8f3b3d2-2fdb-4940-8648-7aa2db6ce1a4", "AQAAAAIAAYagAAAAEP/VHggC5dgz0iVV7rHZBCMop5iSz7VvO+s/6ZZH/uatT8V/3yC0GlXPtmB+Fkh4Xw==", "bfdc9f3a-e8f0-4c95-bbc7-fbf085b9685f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "e70607a2-21b2-4702-b2b2-53ae2686e6be", "AQAAAAIAAYagAAAAEEETbVE6qKL/rk6jLl/KlKIaR+xbbLJCn/q9Tabw8kBPCEWsMiVgvyXwlllJAhmdCQ==", "f922f7e7-5c51-48b4-bd19-85c21cbd084d" });
        }
    }
}
