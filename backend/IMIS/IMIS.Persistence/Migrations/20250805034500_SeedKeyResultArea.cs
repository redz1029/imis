using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedKeyResultArea : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "1e3ca4d4-fa38-4f75-aa1d-8558c16c7bc2");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "da0752d8-54ec-40b0-b0f7-6c5522d1ba92");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "4676786d-2cc8-417c-9dd1-b5faea3d824d");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "a72f1e53-5aa0-49d4-a65a-1ad67307d118");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "ff37ad51-ed10-4e8d-8e50-eb2a6b7518ef", "AQAAAAIAAYagAAAAEKGZx5J27XTx52MhAsWaPzSjyEBMXsZIWw6Ld8OjQn9St+JUcU22w0ktMDoHkUtHTw==", "5891e080-23e8-4426-81e8-72772cafd340" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "db3675eb-3d80-432e-8385-21acd295efa2", "AQAAAAIAAYagAAAAELZbijW2azgrtjR65o8vug3rOLPNMW+oe627Vwnrz0zD+EwzIxD3tQWNigE9YKqxYg==", "15988ee4-194a-457f-bba3-9c4a697fde5a" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "b006eb28-7570-4061-b142-814276e16c8f", "AQAAAAIAAYagAAAAEFQLWbBXdrFPLBwOSw6Xv2O9g5nFIMX0nRvuq83RXjnXKz5gIQ4EczsrHl5H+xrTAA==", "4a66d7a1-88ea-4cd1-979c-a6406992a09e" });

            migrationBuilder.InsertData(
                table: "KeyResultArea",
                columns: new[] { "Id", "IsDeleted", "Name", "Remarks" },
                values: new object[,]
                {
                    { 1, false, "PATIENT CARE", "Focuses on delivering safe, quality, and patient-centered healthcare services to improve patient outcomes and satisfaction." },
                    { 2, false, "RESEARCH", "Focuses on generating new knowledge, improving practices, and supporting evidence-based decision-making. It involves conducting studies, analyzing data, and producing insights that contribute to organizational goals and innovation." },
                    { 3, false, "TRAINING", "Oversees the planning and delivery of training programs to enhance employee skills, address learning needs, and support continuous professional growth." },
                    { 4, false, "LINKAGES", "Focuses on building and strengthening partnerships with external organizations, stakeholders, and institutions to support programs, resource sharing, and collaborative initiatives that advance organizational goals." },
                    { 5, false, "INFRASTRUCTURE & EQUIPMENT", "Ensures the availability, maintenance, and improvement of physical facilities and equipment to support efficient operations and service delivery." },
                    { 6, false, "FINANCE", "Manages budgeting, allocation, and utilization of financial resources to ensure transparency, accountability, and support for organizational goals." },
                    { 7, false, "INFORMATION CAPITAL", "Focuses on the effective management, utilization, and protection of data, information systems, and technology to support decision-making, innovation, and operational efficiency." },
                    { 8, false, "HUMAN CAPITAL", "Involves developing, managing, and optimizing the workforce through recruitment, capacity building, performance management, and employee engagement to achieve organizational goals." },
                    { 9, false, "PEOPLE SAFETY AND EXPERIENCE", "Ensures a safe, secure, and supportive environment while enhancing the overall experience of employees, clients, and stakeholders through effective safety protocols and service excellence initiatives." }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KeyResultArea",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "61ef2127-e8a5-437a-8850-0a455bf08ac0");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "8d31c650-c697-4fad-926f-a8ce8751811e");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "75d816c3-5a6c-4ecd-8073-b49da9e8115b");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "b777ff88-f05d-4f47-aa6f-5b133371cf0d");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "7557ef04-88da-4af5-9297-0a9a914b80bf", "AQAAAAIAAYagAAAAEPaajD+n7jTr+J6yq+NEu1IBYW/PYhUcQ2Aq22MYaROUYz0Q3WevFic6ytOUFNEOog==", "d3bb865c-6012-4b07-8d6a-2a998db78cba" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "5c1751bb-9500-4e89-b7b7-b9989d0cf9db", "AQAAAAIAAYagAAAAEAb5fDzhiJox85/PZ8RdHSc/522oXsjyRDOyVSbLpRt6/7U8cbkWqVQjo03vTuDSDQ==", "701d48f7-f8dc-47bb-adc9-0700054acf55" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "972ee5e1-6556-4693-afac-b6525899878b", "AQAAAAIAAYagAAAAELqF+QDqvCLQLljpWGp3KybxPvGRBXxui2OMeGhaCd3zxkeUp3kfFwi9wiwLglnDag==", "75938acf-61d4-46b4-9d2e-77f3f1d5eab1" });
        }
    }
}
