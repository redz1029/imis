using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace IMIS.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class SeedOffices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

            migrationBuilder.InsertData(
                table: "Offices",
                columns: new[] { "Id", "IsActive", "IsDeleted", "Name", "OfficeTypeId", "ParentOfficeId" },
                values: new object[,]
                {
                    { 1, true, false, "Medical Center Chief", 1, null },
                    { 2, true, false, "Medical Service", 1, null },
                    { 3, true, false, "Nursing Service", 1, null },
                    { 4, true, false, "Hospital Operations and Patient Support Service", 1, null },
                    { 5, true, false, "Finance Service", 1, null },
                    { 6, true, false, "Lateral Entry", 1, null },
                    { 7, true, false, "Allied/Ancillary", 1, null },
                    { 8, true, false, "Department of Internal Medicine", 2, 2 },
                    { 9, true, false, "Department of Surgery", 2, 2 },
                    { 10, true, false, "Department of Obstetics-Gynecology", 2, 2 },
                    { 11, true, false, "Department of Pediatrics", 2, 2 },
                    { 12, true, false, "Department of Anesthesiology", 2, 2 },
                    { 13, true, false, "Physical Medicine and Rehabilitation Department", 2, 2 },
                    { 14, true, false, "Out-Patient Department", 2, 2 },
                    { 15, true, false, "Emergency Department", 2, 2 },
                    { 16, true, false, "Department of Pathology", 2, 2 },
                    { 17, true, false, "Department of Diagnostic and Therapuetic Radiology", 2, 2 },
                    { 18, true, false, "Dental Department", 2, 2 },
                    { 19, true, false, "Health Information Management Department", 3, 7 },
                    { 20, true, false, "Medical Social Work Department", 3, 7 },
                    { 21, true, false, "Nutrition and Dietetics Department", 3, 7 },
                    { 22, true, false, "Pharmacy Department", 3, 7 },
                    { 23, true, false, "Medicine Ward", 3, 3 },
                    { 24, true, false, "Pediatrics Ward", 3, 3 },
                    { 25, true, false, "Surgery Ward", 3, 3 },
                    { 26, true, false, "OB-Gynecology Ward", 3, 3 },
                    { 27, true, false, "Operating Room", 3, 3 },
                    { 28, true, false, "Delivery Room", 3, 3 },
                    { 29, true, false, "Out-Patient Department", 3, 3 },
                    { 30, true, false, "Emergency Department", 3, 3 },
                    { 31, true, false, "Pay Ward", 3, 3 },
                    { 32, true, false, "Orthopedic, Ophthalmology, and Urology Wards", 3, 3 },
                    { 33, true, false, "Sec. Ona Wing", 3, 3 },
                    { 34, true, false, "Oncology Ward", 3, 3 },
                    { 35, true, false, "Central Supply and Sterilization Room", 3, 3 },
                    { 36, true, false, "Mental Health Unit", 3, 3 },
                    { 37, true, false, "Human Resource Management Department", 3, 4 },
                    { 38, true, false, "Procurement Department", 3, 4 },
                    { 39, true, false, "Materials and Supplies Management Department", 3, 4 },
                    { 40, true, false, "Engineering and Facilities Management Department", 3, 4 },
                    { 41, true, false, "Budget Department", 3, 5 },
                    { 42, true, false, "Accounting department", 3, 5 },
                    { 43, true, false, "Cash Operations Department", 3, 5 },
                    { 44, true, false, "Medical Center Chief Office", 3, 1 },
                    { 45, true, false, "CMPS Office", 3, 2 },
                    { 46, true, false, "Bureau of Quarantine", 3, 6 },
                    { 47, true, false, "Chief Nurse Office", 3, 3 },
                    { 48, true, false, "TB Ward", 3, 3 },
                    { 49, true, false, "CAO Office", 3, 4 },
                    { 50, true, false, "PUBLIC HEALTH UNIT-HEALTH PROMOTION UNIT", 3, 1 },
                    { 51, true, false, "Auditor's Office", 3, 4 },
                    { 52, true, false, "Extension Ward", 3, 3 },
                    { 53, true, false, "MHU-COVID Ext.", 3, 3 },
                    { 54, true, false, "COVID Ext. Ward", 3, 3 },
                    { 55, true, false, "TB-CENTER", 3, 3 },
                    { 56, true, false, "OHCC", 3, 1 },
                    { 57, true, false, "OB/SURGERY/ORTHO Extension Ward", 3, 3 },
                    { 58, true, false, "General Extension Ward", 3, 3 },
                    { 59, true, false, "ICU Complex", 3, 3 },
                    { 60, true, false, "COVEX I", 3, 3 },
                    { 61, true, false, "OB GYNE/SURGERY Ward", 3, 3 },
                    { 62, true, false, "Department of Emergency Medicine", 3, 2 },
                    { 63, true, false, "Transfer Treatment Monitoring Facility", 3, 3 },
                    { 64, true, false, "Family Medicine Department", 3, 2 },
                    { 65, true, false, "Billing and Claims Section", 3, 5 },
                    { 66, true, false, "Public Health Section", 3, 1 },
                    { 67, true, false, "Finance Office", 3, 5 },
                    { 68, true, false, "Cancer Institute", 3, 1 },
                    { 69, true, false, "Women's Health Center", 3, 3 },
                    { 70, true, false, "Section of Dermatology and Venereology", 3, 2 },
                    { 71, true, false, "College of Medicine Department", 3, 1 },
                    { 72, true, false, "Family Medicine Department", 3, 2 },
                    { 73, true, false, "Ophthalmology Department", 3, 2 },
                    { 74, true, false, "Medical Insurance Evaluation and Reconcillation Unit", 3, 2 },
                    { 75, true, false, "Professional,Education,Training and Development Unit", 3, 1 },
                    { 76, true, false, "Soccsksargen Regional Blood Center", 3, 1 },
                    { 77, true, false, "Trauma Center", 3, 1 },
                    { 78, true, false, "Burn Center", 3, 1 },
                    { 79, true, false, "Cardiovascular Center", 3, 1 },
                    { 80, true, false, "Renal Care and Transplant Unit", 3, 1 },
                    { 81, true, false, "Cancer Institute", 3, 3 },
                    { 83, true, false, "Mental Health Unit", 4, 2 },
                    { 124, true, false, "Professional Education Training and Research Unit", 4, 1 },
                    { 125, true, false, "Integrated Hospital Operations and Management Program", 4, 1 },
                    { 126, true, false, "Legal Unit", 4, 1 },
                    { 127, true, false, "Public Assistance and Complaint Desk", 4, 1 },
                    { 128, true, false, "Surveillance Unit", 4, 3 },
                    { 129, true, false, "Infectious Unit", 4, 3 },
                    { 130, true, false, "HACT Office", 4, 3 },
                    { 131, true, false, "OPD Surveillance", 4, 3 },
                    { 132, true, false, "ER Surveillance", 4, 3 },
                    { 133, true, false, "Temporary Treatment Monitoring Facility", 4, 3 },
                    { 134, true, false, "TB ISO", 4, 3 },
                    { 135, true, false, "OSM", 4, 1 },
                    { 136, true, false, "HDU - Annex", 4, 3 },
                    { 138, true, false, "Hospital Infection Prevention and Control Unit", 4, 1 },
                    { 139, true, false, "Social Hygiene and Treatment Hub", 4, 1 },
                    { 148, true, false, "Security Management Unit", 4, 1 },
                    { 156, true, false, "Research Institute", 4, 1 },
                    { 157, true, false, "Health Emergency Disaster Management Unit", 4, 1 },
                    { 159, true, false, "Peritoneal Dialysis", 4, 3 },
                    { 160, true, false, "Pallative Care Unit", 4, 3 },
                    { 163, true, false, "Patient and Safety Unit", 4, 2 },
                    { 164, true, false, "Credit and Collection Section", 4, 5 },
                    { 82, true, false, "Medicine Intensive Care Unit", 4, 8 },
                    { 84, true, false, "Hemodialysis Unit", 4, 8 },
                    { 85, true, false, "Heart Station", 4, 8 },
                    { 86, true, false, "Section of Pulmonary Medicine", 4, 8 },
                    { 87, true, false, "TB Center", 4, 8 },
                    { 88, true, false, "Surgery Intensive Care Unit", 4, 9 },
                    { 89, true, false, "Burn Unit", 4, 9 },
                    { 90, true, false, "Orthopedics", 4, 9 },
                    { 91, true, false, "Ophthalmology", 4, 9 },
                    { 92, true, false, "Urology", 4, 9 },
                    { 93, true, false, "Otorhinolaryngology", 4, 9 },
                    { 94, true, false, "OB-Gyrecology Intensive Care Unit", 4, 10 },
                    { 95, true, false, "Pediatric Intensive Care Unit", 4, 11 },
                    { 96, true, false, "Neonatal Intensive Care Unit", 4, 11 },
                    { 97, true, false, "Anatomic and Clinical Laboratory", 4, 16 },
                    { 98, true, false, "Blood Bank", 4, 16 },
                    { 99, true, false, "Admitting Section", 4, 19 },
                    { 100, true, false, "HIM OPD", 4, 19 },
                    { 101, true, false, "ER Satellite Pharmacy", 4, 22 },
                    { 102, true, false, "OPD Satellite Pharmacy", 4, 22 },
                    { 103, true, false, "Medicine Intensive Care Unit", 4, 23 },
                    { 104, true, false, "Hemodialysis Unit", 4, 23 },
                    { 105, true, false, "Heart Station", 4, 23 },
                    { 106, true, false, "Neonatal Intensive Care Unit", 4, 24 },
                    { 107, true, false, "Pediatric Intensive Care Unit", 4, 24 },
                    { 108, true, false, "Surgery Intensive Care Unit", 4, 25 },
                    { 109, true, false, "Burn Unit", 4, 25 },
                    { 110, true, false, "OB-Gynecology Intensive Care Unit", 4, 26 },
                    { 111, true, false, "Post Aresthetic Care Unit", 4, 27 },
                    { 112, true, false, "CCTV Unit", 4, 40 },
                    { 113, true, false, "Security Services (Contracted Out)", 4, 40 },
                    { 114, true, false, "Motorpool Unit", 4, 40 },
                    { 115, true, false, "Mechanical Maintenance Unit", 4, 40 },
                    { 116, true, false, "Elevator Unit", 4, 40 },
                    { 117, true, false, "Medical Oxygen Plant Unit", 4, 40 },
                    { 118, true, false, "Laundry and Linen Unit", 4, 40 },
                    { 119, true, false, "Housekeeping Unit", 4, 40 },
                    { 120, true, false, "Biomedical Section", 4, 40 },
                    { 121, true, false, "Electrical Section", 4, 40 },
                    { 122, true, false, "Billing Unit", 4, 65 },
                    { 123, true, false, "Claims Unit", 4, 65 },
                    { 137, true, false, "Surgery", 4, 14 },
                    { 140, true, false, "Hospital Epidemiology and Surveillance Unit", 4, 66 },
                    { 141, true, false, "CATH LAB", 4, 27 },
                    { 142, true, false, "Physical Plant", 4, 40 },
                    { 143, true, false, "Newborn Screening", 4, 11 },
                    { 144, true, false, "Plastic Surgery", 4, 9 },
                    { 145, true, false, "Women's Health Center", 4, 10 },
                    { 146, true, false, "PICU", 4, 24 },
                    { 147, true, false, "Clinical Spiritual Care Unit", 4, 16 },
                    { 149, true, false, "TTMF", 4, 45 },
                    { 150, true, false, "Emergency Room", 4, 45 },
                    { 151, true, false, "Diagnostic Evaluation Unit", 4, 45 },
                    { 152, true, false, "Physical Therapy Section", 4, 13 },
                    { 153, true, false, "Prosthetic and Orthotic Section", 4, 13 },
                    { 154, true, false, "Brain and Spine Center", 4, 9 },
                    { 155, true, false, "Dormitory Unit", 4, 40 },
                    { 158, true, false, "Medical Insurance Evaluation Unit", 4, 45 },
                    { 161, true, false, "Toxicology Unit", 4, 64 },
                    { 162, true, false, "New Born Screening", 4, 24 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 30);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 31);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 32);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 33);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 34);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 35);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 36);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 37);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 38);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 39);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 41);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 42);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 43);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 44);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 46);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 47);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 48);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 49);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 50);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 51);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 52);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 53);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 54);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 55);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 56);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 57);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 58);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 59);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 60);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 61);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 62);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 63);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 67);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 68);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 69);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 70);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 71);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 72);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 73);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 74);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 75);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 76);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 77);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 78);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 79);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 80);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 81);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 82);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 83);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 84);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 85);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 86);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 87);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 88);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 89);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 90);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 91);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 92);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 93);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 94);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 95);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 96);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 97);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 98);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 99);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 100);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 101);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 102);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 103);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 104);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 105);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 106);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 107);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 108);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 109);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 110);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 111);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 112);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 113);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 114);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 115);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 116);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 117);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 118);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 119);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 120);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 121);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 122);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 123);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 124);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 125);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 126);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 127);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 128);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 129);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 130);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 131);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 132);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 133);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 134);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 135);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 136);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 137);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 138);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 139);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 140);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 141);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 142);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 143);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 144);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 145);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 146);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 147);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 148);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 149);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 150);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 151);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 152);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 153);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 154);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 155);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 156);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 157);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 158);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 159);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 160);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 161);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 162);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 163);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 164);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 40);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 45);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 64);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 65);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 66);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Offices",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "56996e97-9e8a-4d22-a693-c865144e9b96",
                column: "ConcurrencyStamp",
                value: "36951681-1290-4ded-9674-5ff928ad8b69");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "8d9f58ec-a8b2-4738-9b5f-d5ce46f98b17",
                column: "ConcurrencyStamp",
                value: "2fb42cc0-810a-4bbf-921d-cba3541105cf");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "af7b586c7ee6490bbd878f46f6a47831",
                column: "ConcurrencyStamp",
                value: "791fd81b-1aca-4f00-83bf-c58bdfe72f1a");

            migrationBuilder.UpdateData(
                table: "AspNetRoles",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                column: "ConcurrencyStamp",
                value: "10a8b42d-cee9-4d81-9e5d-e980bb73e604");

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "176bcfeb-f12a-4d42-b790-5d2312660801",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "a1b37067-c41e-4a07-a38a-7fe9bdde8c06", "AQAAAAIAAYagAAAAECWV5nz1g+NYkCIxvkwPqyWBUW/koWWVy/v/fJB4gjY+M58JSxS6xjfg9KWJActVjw==", "d1f005ba-0d1c-4f9d-a864-d5a1992cfd48" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "f7cf5c73-16d9-4da8-9e0a-cc149b34fbbd",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "138a24aa-c093-40c9-9e57-219d06bbb387", "AQAAAAIAAYagAAAAEBbUTAc5tanMY/ZYsAq7qEpW9OSvaipzbLmnqlbhOKk/1ohAgQe9J35XakLn+Atzbw==", "860c733b-2ffe-4ff5-b989-922cce3e793f" });

            migrationBuilder.UpdateData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "fb385d60-eaee-4ea2-8bf1-b5cc0723c17a",
                columns: new[] { "ConcurrencyStamp", "PasswordHash", "SecurityStamp" },
                values: new object[] { "1adef2ce-62f5-417c-b984-0038762cf46f", "AQAAAAIAAYagAAAAEAA/kJRQT3oEjpo6XZ/ltmB+S9b1+40K8s1q0E+UyUQfS3dtlyprW3mfz9cU/sMRtw==", "16130245-1215-404d-90c1-7eafcd8f990a" });
        }
    }
}
