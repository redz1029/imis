using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class IsoStandardConfigurations : IEntityTypeConfiguration<IsoStandard>
    {
        public void Configure(EntityTypeBuilder<IsoStandard> builder)
        {


            builder.HasData(

                // =========================
                // CLAUSE 4 - ROOT
                // =========================
                new IsoStandard
                {
                    Id = 1,
                    VersionID = 1,
                    ParentID = null,
                    ClauseRef = "4",
                    Particulars = "",
                    Description = "Context of the organization",
                    isActive = true
                },

                // 4.1
                new IsoStandard
                {
                    Id = 2,
                    VersionID = 1,
                    ParentID = 1,
                    ClauseRef = "4.1",
                    Particulars = "The organization shall determine external and internal issues that are relevant to its purpose and its strategic direction and that affect its ability to achieve the intended result(s) of its quality management system. Issues can include positive and negative factors or conditions for consideration.",
                    Description = "Understanding the organization and its context",
                    isActive = true
                },

                // 4.1 NOTES
              
                // 4.2
                new IsoStandard
                {
                    Id = 3,
                    VersionID = 1,
                    ParentID = 1,
                    ClauseRef = "4.2",
                    Particulars = "Due to their effect or potential effect on the organization’s ability to consistently provide products and services that meet customer and applicable statutory and regulatory requirements, the organization shall determine: " +
                    "The organization shall monitor and review information about these interested parties and their relevant requirements.",
                    Description = "Understanding the needs and expectations of interested parties",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 4,
                    VersionID = 1,
                    ParentID = 6,
                    ClauseRef = "4.2.a",
                    Particulars = "",
                    Description = "The interested parties that are relevant to the quality management system;",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 5,
                    VersionID = 1,
                    ParentID = 6,
                    ClauseRef = "4.2.b",
                    Particulars = "",
                    Description = "The requirements of these interested parties that are relevant to the quality management system.",
                    isActive = true
                },

                // 4.3
                new IsoStandard
                {
                    Id = 6,
                    VersionID = 1,
                    ParentID = 1,
                    ClauseRef = "4.3",
                    Particulars = "The organization shall determine the boundaries and applicability of the quality management system to establish its scope.The organization shall apply all the requirements of this International Standard if they are applicable within the determined scope of its quality management system. " +
                    "The scope of the organization’s quality management system shall be available and be maintained as documented information. The scope shall state the types of products and services covered, " +
                    "and provide justification for any requirement of this International Standard that the organization determines is not applicable to the scope of its quality management system. " +
                    "Conformity to this International Standard may only be claimed if the requirements determined as not being applicable do not affect the organization’s ability or responsibility to ensure the conformity of its products and services and the enhancement of customer satisfaction. " +
                    "When determining this scope, the organization shall consider:",
                    Description = "Determining the scope of the quality management system",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 10,
                    VersionID = 1,
                    ParentID = 9,
                    ClauseRef = "4.3.a",
                    Particulars = "",
                    Description = "The external and internal issues referred to in 4.1;",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 11,
                    VersionID = 1,
                    ParentID = 9,
                    ClauseRef = "4.3.b",
                    Particulars = "",
                    Description = "The requirements of relevant interested parties referred to in 4.2;",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 12,
                    VersionID = 1,
                    ParentID = 9,
                    ClauseRef = "4.3.c",
                    Particulars = "",
                    Description = "The products and services of the organization.",
                    isActive = true
                },

                // 4.4
                new IsoStandard
                {
                    Id = 13,
                    VersionID = 1,
                    ParentID = 1,
                    ClauseRef = "4.4",
                    Particulars = "",
                    Description = "Quality management system and its processes",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 14,
                    VersionID = 1,
                    ParentID = 13,
                    ClauseRef = "4.4.1",
                    Particulars = "The organization shall determine the processes needed for the quality management system and their application throughout the organization, and shall:",
                    Description = "The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 15,
                    VersionID = 1,
                    ParentID = 14,
                    ClauseRef = "4.4.1.a",
                    Particulars = "",
                    Description = "Determine the inputs required and outputs expected;",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 16,
                    VersionID = 1,
                    ParentID = 14,
                    ClauseRef = "4.4.1.b",
                    Particulars = "",
                    Description = "Determine sequence and interaction of processes;",
                    isActive = true
                },

                new IsoStandard
                {
                    Id = 17,
                    VersionID = 1,
                    ParentID = 14,
                    ClauseRef = "4.4.1.c",
                    Particulars = "",
                    Description = "determine and apply the criteria and methods (including monitoring, " +
                 "measurements and related performance indicators) needed to ensure the effective operation and control of these processes;",
                    isActive = true
                },


              //end
              new IsoStandard
              {
                  Id = 18,
                  VersionID = 1,
                  ParentID = 14,
                  Particulars = "",
                  ClauseRef = "4.4.1.d",
                  Description = "determine the resources needed for these processes and ensure their availability;",
                  isActive = true
              },
              new IsoStandard
              {
                  Id = 19,
                  VersionID = 1,
                  ParentID = 14,
                  Particulars = "",
                  ClauseRef = "4.4.1.e",
                  Description = "assign the responsibilities and authorities for these processes;",
                  isActive = true
              },
                new IsoStandard
                {
                    Id = 20,
                    VersionID = 1,
                    ParentID = 14,
                    Particulars = "",
                    ClauseRef = "4.4.1.f",
                    Description = "address the risks and opportunities as determined in accordance with the requirements of 6.1;",
                    isActive = true
                },
                new IsoStandard
                {
                    Id = 21,
                    VersionID = 1,
                    ParentID = 14,
                    Particulars = "",
                    ClauseRef = "4.4.1.g",
                    Description = "evaluate these processes and implement any changes needed to ensure that these processes achieve their intended results;",
                    isActive = true
                },
                new IsoStandard
                {
                    Id = 22,
                    VersionID = 1,
                    ParentID = 14,
                    Particulars = "",
                    ClauseRef = "4.4.1.h",
                    Description = "improve the processes and the quality management system.",
                    isActive = true
                },

                // 4.4.2 (child of 4.4)
                new IsoStandard
                {
                    Id = 23,
                    VersionID = 1,
                    ParentID = 13,
                    Particulars = "To the extent necessary, the organization shall:",
                    ClauseRef = "4.4.2",
                    Description = "",
                    isActive = true
                },

                // 4.4.2.a
                new IsoStandard
                {
                    Id = 24,
                    VersionID = 1,
                    ParentID = 23,
                    Particulars = "",
                    ClauseRef = "4.4.2.a",
                    Description = "maintain documented information to support the operation of its processes;",
                    isActive = true
                },

                // 4.4.2.b
                new IsoStandard
                {
                    Id = 25,
                    VersionID = 1,
                    ParentID = 23,
                    Particulars = "",
                    ClauseRef = "4.4.2.b",
                    Description = "retain documented information to have confidence that the processes are being carried out as planned.",
                    isActive = true
                },
                //end of 4

                // =========================
                // CLAUSE 5 - ROOT
                // =========================
                new IsoStandard
                {
                    Id = 26,
                    VersionID = 1,
                    ParentID = null,
                    ClauseRef = "5",
                    Particulars = "",
                    Description = "Leadership",
                    isActive = true
                },

                // 5.1
                new IsoStandard
                {
                    Id = 27,
                    VersionID = 1,
                    ParentID = 26,
                    ClauseRef = "5.1",
                    Particulars = "",
                    Description = "Leadership and commitment",
                    isActive = true
                },

                // 5.1.1
                new IsoStandard
                {
                    Id = 28,
                    VersionID = 1,
                    ParentID = 27,
                    ClauseRef = "5.1.1",
                    Particulars = "Top management shall demonstrate leadership and commitment with respect to the quality management system by: NOTE Reference to “business” in this International " +
                    "Standard can be interpreted broadly to mean those activities that are core to the purposes of the organization’s existence, whether the organization is public, private, for profit or not for profit.",
                    Description = "General",
                    isActive = true
                },

                // 5.1.1 a–j
                new IsoStandard { Id = 29, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.a", Particulars = "", Description = "taking accountability for the effectiveness of the quality management system;", isActive = true },
                new IsoStandard { Id = 30, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.b", Particulars = "", Description = "ensuring that the quality policy and quality objectives are established and compatible with the organization;", isActive = true },
                new IsoStandard { Id = 31, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.c", Particulars = "", Description = "ensuring integration of QMS requirements into business processes;", isActive = true },
                new IsoStandard { Id = 32, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.d", Particulars = "", Description = "promoting the use of the process approach and risk-based thinking;", isActive = true },
                new IsoStandard { Id = 33, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.e", Particulars = "", Description = "ensuring necessary resources are available;", isActive = true },
                new IsoStandard { Id = 34, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.f", Particulars = "", Description = "communicating the importance of effective quality management;", isActive = true },
                new IsoStandard { Id = 35, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.g", Particulars = "", Description = "ensuring QMS achieves intended results;", isActive = true },
                new IsoStandard { Id = 36, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.h", Particulars = "", Description = "engaging and supporting persons to contribute to QMS effectiveness;", isActive = true },
                new IsoStandard { Id = 37, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.i", Particulars = "", Description = "promoting improvement;", isActive = true },
                new IsoStandard { Id = 38, VersionID = 1, ParentID = 28, ClauseRef = "5.1.1.j", Particulars = "", Description = "supporting other management roles to demonstrate leadership;", isActive = true },

                // 5.1.2
                new IsoStandard
                {
                    Id = 39,
                    VersionID = 1,
                    ParentID = 27,
                    ClauseRef = "5.1.2",
                    Particulars = "",
                    Description = "Customer focus",
                    isActive = true
                },

                new IsoStandard { Id = 40, VersionID = 1, ParentID = 39, ClauseRef = "5.1.2.a", Particulars = "", Description = "customer and statutory requirements are determined and met;", isActive = true },
                new IsoStandard { Id = 41, VersionID = 1, ParentID = 39, ClauseRef = "5.1.2.b", Particulars = "", Description = "risks and opportunities affecting conformity are addressed;", isActive = true },
                new IsoStandard { Id = 42, VersionID = 1, ParentID = 39, ClauseRef = "5.1.2.c", Particulars = "", Description = "focus on enhancing customer satisfaction is maintained.", isActive = true },

                // 5.2
                new IsoStandard
                {
                    Id = 43,
                    VersionID = 1,
                    ParentID = 26,
                    ClauseRef = "5.2",
                    Particulars = "",
                    Description = "Policy",
                    isActive = true
                },

                // 5.2.1
                new IsoStandard
                {
                    Id = 44,
                    VersionID = 1,
                    ParentID = 43,
                    ClauseRef = "5.2.1",
                    Particulars = "Top management shall establish, implement and maintain a quality policy that:",
                    Description = "Establishing the quality policy",
                    isActive = true
                },

                new IsoStandard { Id = 45, VersionID = 1, ParentID = 44, ClauseRef = "5.2.1.a", Particulars = "", Description = "is appropriate to the purpose and context of the organization;", isActive = true },
                new IsoStandard { Id = 46, VersionID = 1, ParentID = 44, ClauseRef = "5.2.1.b", Particulars = "", Description = "provides a framework for setting quality objectives;", isActive = true },
                new IsoStandard { Id = 47, VersionID = 1, ParentID = 44, ClauseRef = "5.2.1.c", Particulars = "", Description = "includes a commitment to satisfy applicable requirements;", isActive = true },
                new IsoStandard { Id = 48, VersionID = 1, ParentID = 44, ClauseRef = "5.2.1.d", Particulars = "", Description = "includes a commitment to continual improvement of the QMS.", isActive = true },

                // 5.2.2
                new IsoStandard
                {
                    Id = 49,
                    VersionID = 1,
                    ParentID = 43,
                    ClauseRef = "5.2.2",
                    Particulars = "The quality policy shall:",
                    Description = "Communicating the quality policy",
                    isActive = true
                },

                new IsoStandard { Id = 50, VersionID = 1, ParentID = 49, ClauseRef = "5.2.2.a", Particulars = "", Description = "be available and maintained as documented information;", isActive = true },
                new IsoStandard { Id = 51, VersionID = 1, ParentID = 49, ClauseRef = "5.2.2.b", Particulars = "", Description = "be communicated and understood within the organization;", isActive = true },
                new IsoStandard { Id = 52, VersionID = 1, ParentID = 49, ClauseRef = "5.2.2.c", Particulars = "", Description = "be available to relevant interested parties.", isActive = true },

                // 5.3
                new IsoStandard
                {
                    Id = 53,
                    VersionID = 1,
                    ParentID = 26,
                    ClauseRef = "5.3",
                    Particulars = "Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, " +
                    "communicated and understood within the organization. Top management shall assign the responsibility and authority for:",
                    Description = "Organizational roles, responsibilities and authorities",
                    isActive = true
                },

                new IsoStandard { Id = 54, VersionID = 1, ParentID = 53, ClauseRef = "5.3.a", Particulars = "", Description = "ensuring QMS conforms to requirements;", isActive = true },
                new IsoStandard { Id = 55, VersionID = 1, ParentID = 53, ClauseRef = "5.3.b", Particulars = "", Description = "ensuring processes deliver intended outputs;", isActive = true },
                new IsoStandard { Id = 56, VersionID = 1, ParentID = 53, ClauseRef = "5.3.c", Particulars = "", Description = "reporting on the performance of the quality management system and on opportunities for improvement (see 10.1), in particular to top management;", isActive = true },
                new IsoStandard { Id = 57, VersionID = 1, ParentID = 53, ClauseRef = "5.3.d", Particulars = "", Description = "ensuring promotion of customer focus.", isActive = true },

                // =========================
                // CLAUSE 6 - ROOT
                // =========================
                new IsoStandard
                {
                    Id = 58,
                    VersionID = 1,
                    ParentID = null,
                    ClauseRef = "6",
                    Particulars = "",
                    Description = "Planning",
                    isActive = true
                },

                // 6.1
                new IsoStandard
                {
                    Id = 59,
                    VersionID = 1,
                    ParentID = 58,
                    ClauseRef = "6.1",
                    Particulars = "When planning for the quality management system, the organization shall consider the context of the organization and the issues referred to in 4.1," +
                    " as well as the requirements referred to in 4.2. The organization shall determine the risks and opportunities that need to be addressed to:",
                    Description = "Actions to address risks and opportunities",
                    isActive = true
                },

                new IsoStandard { Id = 60, VersionID = 1, ParentID = 59, ClauseRef = "6.1.a", Particulars = "", Description = "give assurance that the QMS can achieve its intended results;", isActive = true },
                new IsoStandard { Id = 61, VersionID = 1, ParentID = 59, ClauseRef = "6.1.b", Particulars = "", Description = "enhance desirable effects;", isActive = true },
                new IsoStandard { Id = 62, VersionID = 1, ParentID = 59, ClauseRef = "6.1.c", Particulars = "", Description = "prevent or reduce undesired effects;", isActive = true },
                new IsoStandard { Id = 63, VersionID = 1, ParentID = 59, ClauseRef = "6.1.d", Particulars = "", Description = "achieve improvement.", isActive = true },

                // 6.1.2
                new IsoStandard
                {
                    Id = 64,
                    VersionID = 1,
                    ParentID = 59,
                    ClauseRef = "6.1.2",
                    Particulars = "The organization shall plan actions to address risks and opportunities and evaluate their effectiveness of these actions..",
                    Description = "",
                    isActive = true
                },

                new IsoStandard { Id = 65, VersionID = 1, ParentID = 64, ClauseRef = "6.1.2.a", Particulars = "", Description = "actions to address these risks and opportunities;", isActive = true },
                new IsoStandard { Id = 66, VersionID = 1, ParentID = 64, ClauseRef = "6.1.2.b", Particulars = "how to:", Description = "", isActive = true },
                new IsoStandard { Id = 67, VersionID = 1, ParentID = 66, ClauseRef = "6.1.2.b.1", Particulars = "", Description = "integrate and implement the actions into QMS processes (see 4.4);", isActive = true },
                new IsoStandard { Id = 68, VersionID = 1, ParentID = 66, ClauseRef = "6.1.2.b.2", Particulars = "", Description = "evaluate the effectiveness of these actions.", isActive = true },

                new IsoStandard
                {
                    Id = 69,
                    VersionID = 1,
                    ParentID = 64,
                    ClauseRef = "6.1.2.NOTE 1",
                    Particulars = "",
                    Description = "Options to address risks can include avoiding risk, taking risk in order to pursue an opportunity, " +
                    "eliminating the risk source, changing the likelihood or consequences, sharing the risk, or retaining risk by informed decision.",
                    isActive = true
                },
                new IsoStandard
                {
                    Id = 70,
                    VersionID = 1,
                    ParentID = 64,
                    ClauseRef = "6.1.2.NOTE 2",
                    Particulars = "",
                    Description = "Opportunities can lead to the adoption of new practices, launching new products, opening new markets, addressing new customers, building partnerships, using new technology and other desirable and viable possibilities to address the organization’s or its customers’ needs.",
                    isActive = true
                },

                // 6.2
                new IsoStandard
                {
                    Id = 71,
                    VersionID = 1,
                    ParentID = 58,
                    ClauseRef = "6.2",
                    Particulars = "",
                    Description = "Quality objectives and planning to achieve them",
                    isActive = true
                },

                // 6.2.1
                new IsoStandard
                {
                    Id = 72,
                    VersionID = 1,
                    ParentID = 71,
                    ClauseRef = "6.2.1",
                    Particulars = "The quality objectives shall: " +
                    "The quality objectives shall:",
                    Description = "The organization shall establish quality objectives at relevant functions, levels and processes needed for the quality management system.",
                    isActive = true
                },

                new IsoStandard { Id = 73, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.a", Particulars = "", Description = "be consistent with the quality policy;", isActive = true },
                new IsoStandard { Id = 74, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.b", Particulars = "", Description = "be measurable;", isActive = true },
                new IsoStandard { Id = 75, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.c", Particulars = "", Description = "take into account applicable requirements;", isActive = true },
                new IsoStandard { Id = 76, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.d", Particulars = "", Description = "be relevant to conformity and customer satisfaction;", isActive = true },
                new IsoStandard { Id = 77, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.e", Particulars = "", Description = "be monitored;", isActive = true },
                new IsoStandard { Id = 78, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.f", Particulars = "", Description = "be communicated;", isActive = true },
                new IsoStandard { Id = 79, VersionID = 1, ParentID = 72, ClauseRef = "6.2.1.g", Particulars = "", Description = "be updated as appropriate.", isActive = true },

                // 6.2.2
                new IsoStandard
                {
                    Id = 80,
                    VersionID = 1,
                    ParentID = 71,
                    ClauseRef = "6.2.2",
                    Particulars = "When planning how to achieve quality objectives, the organization shall determine:",
                    Description = "",
                    isActive = true
                },

                new IsoStandard { Id = 81, VersionID = 1, ParentID = 80, ClauseRef = "6.2.2.a", Particulars = "", Description = "what will be done;", isActive = true },
                new IsoStandard { Id = 82, VersionID = 1, ParentID = 80, ClauseRef = "6.2.2.b", Particulars = "", Description = "what resources will be required;", isActive = true },
                new IsoStandard { Id = 83, VersionID = 1, ParentID = 80, ClauseRef = "6.2.2.c", Particulars = "", Description = "who will be responsible;", isActive = true },
                new IsoStandard { Id = 84, VersionID = 1, ParentID = 80, ClauseRef = "6.2.2.d", Particulars = "", Description = "when it will be completed;", isActive = true },
                new IsoStandard { Id = 85, VersionID = 1, ParentID = 80, ClauseRef = "6.2.2.e", Particulars = "", Description = "how results will be evaluated.", isActive = true },

                // 6.3
                new IsoStandard
                {
                    Id = 86,
                    VersionID = 1,
                    ParentID = 58,
                    ClauseRef = "6.3",
                    Particulars = "When the organization determines the need for changes to the quality management system, the changes shall be carried out in a planned manner (see 4.4). The organization shall consider:",
                    Description = "Planning of changes",
                    isActive = true
                },

                new IsoStandard { Id = 87, VersionID = 1, ParentID = 86, ClauseRef = "6.3.a", Particulars = "", Description = "purpose of the change and potential consequences;", isActive = true },
                new IsoStandard { Id = 88, VersionID = 1, ParentID = 86, ClauseRef = "6.3.b", Particulars = "", Description = "integrity of the QMS;", isActive = true },
                new IsoStandard { Id = 89, VersionID = 1, ParentID = 86, ClauseRef = "6.3.c", Particulars = "", Description = "availability of resources;", isActive = true },
                new IsoStandard { Id = 90, VersionID = 1, ParentID = 86, ClauseRef = "6.3.d", Particulars = "", Description = "allocation or reallocation of responsibilities and authorities.", isActive = true },

                    // =========================
                    // 7 - ROOT
                    // =========================
                    new IsoStandard { Id = 91, VersionID = 1, ParentID = null, ClauseRef = "7", Particulars = "", Description = "Support", isActive = true },

                    // 7.1
                    new IsoStandard { Id = 92, VersionID = 1, ParentID = 91, ClauseRef = "7.1", Particulars = "", Description = "Resources", isActive = true },

                    // 7.1.1
                    new IsoStandard { Id = 93, VersionID = 1, ParentID = 92, ClauseRef = "7.1.1", Particulars = "The organization shall determine and provide the resources needed for the establishment, implementation, maintenance and continual improvement of the quality management system. The organization shall consider:", Description = "General", isActive = true },
                    new IsoStandard { Id = 94, VersionID = 1, ParentID = 93, ClauseRef = "7.1.1.a", Particulars = "", Description = "capabilities and constraints of existing internal resources;", isActive = true },
                    new IsoStandard { Id = 95, VersionID = 1, ParentID = 93, ClauseRef = "7.1.1.b", Particulars = "", Description = "what needs to be obtained from external providers.", isActive = true },

                    // 7.1.2
                    new IsoStandard { Id = 96, VersionID = 1, ParentID = 92, ClauseRef = "7.1.2", Particulars = "The organization shall determine and provide the persons necessary for the effective implementation of its quality management system and for the operation and control of its processes.", Description = "People", isActive = true },

                    // 7.1.3
                    new IsoStandard { Id = 97, VersionID = 1, ParentID = 92, ClauseRef = "7.1.3", Description = "Infrastructure", Particulars = "The organization shall determine and provide the infrastructure needed for the operation of its processes and to achieve conformity of products and services. ", isActive = true },
                    new IsoStandard { Id = 98, VersionID = 1, ParentID = 97, ClauseRef = "7.1.3.a", Particulars = "", Description = "buildings and associated utilities;", isActive = true },
                    new IsoStandard { Id = 99, VersionID = 1, ParentID = 97, ClauseRef = "7.1.3.b", Particulars = "", Description = "equipment, including hardware and software;", isActive = true },
                    new IsoStandard { Id = 100, VersionID = 1, ParentID = 97, ClauseRef = "7.1.3.c", Particulars = "", Description = "transportation resources;", isActive = true },
                    new IsoStandard { Id = 101, VersionID = 1, ParentID = 97, ClauseRef = "7.1.3.d", Particulars = "", Description = "information and communication technology.", isActive = true },

                    // 7.1.4
                    new IsoStandard { Id = 102, VersionID = 1, ParentID = 92, ClauseRef = "7.1.4", Particulars = "The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services. " +
                    "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise). NOTE A suitable environment can be a combination of human and physical factors, such as:", Description = "Environment for the operation of processes", isActive = true },
                    new IsoStandard { Id = 103, VersionID = 1, ParentID = 102, ClauseRef = "7.1.4.a", Particulars = "", Description = "social (e.g. non-discriminatory, calm, non-confrontational);", isActive = true },
                    new IsoStandard { Id = 104, VersionID = 1, ParentID = 102, ClauseRef = "7.1.4.b", Particulars = "", Description = "psychological (e.g. stress-reducing, burnout prevention, emotionally protective);", isActive = true },
                    new IsoStandard { Id = 105, VersionID = 1, ParentID = 102, ClauseRef = "7.1.4.c", Particulars = "", Description = "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise).", isActive = true },

                    // 7.1.5
                    new IsoStandard { Id = 106, VersionID = 1, ParentID = 92, ClauseRef = "7.1.5", Particulars = "", Description = "Monitoring and measuring resources", isActive = true },
                    new IsoStandard { Id = 107, VersionID = 1, ParentID = 106, ClauseRef = "7.1.5.1", Particulars = "The organization shall determine and provide the resources needed to ensure valid and reliable results when monitoring or measuring " +
                    "is used to verify the conformity of products and services to requirements. \" +\r\n            \"The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources." +
                    "The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.\"", Description = "General", isActive = true },
                    new IsoStandard { Id = 108, VersionID = 1, ParentID = 107, ClauseRef = "7.1.5.1.a", Particulars = "", Description = "are suitable for specific monitoring activities being undertaken;", isActive = true },
                    new IsoStandard { Id = 109, VersionID = 1, ParentID = 107, ClauseRef = "7.1.5.1.b", Particulars = "", Description = "are maintained to ensure their continuing fitness for their purpose.", isActive = true },

                    new IsoStandard { Id = 110, VersionID = 1, ParentID = 106, ClauseRef = "7.1.5.2", Particulars = "The organization shall determine if the validity of previous measurement results has been adversely " +
                    "affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary. " +
                    "The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary.", Description = "Measurement traceability", isActive = true },
                    new IsoStandard { Id = 111, VersionID = 1, ParentID = 110, ClauseRef = "7.1.5.2.a", Particulars = "", Description = "calibrated or verified, or both, at specified intervals, or prior to use, against measurement standards traceable to international or national measurement standards; " +
                    "when no such standards exist, the basis used for calibration or verification shall be retained as documented information;", isActive = true },
                    new IsoStandard { Id = 112, VersionID = 1, ParentID = 110, ClauseRef = "7.1.5.2.b", Particulars = "", Description = "identified to determine status;", isActive = true },
                    new IsoStandard { Id = 113, VersionID = 1, ParentID = 110, ClauseRef = "7.1.5.2.c", Particulars = "", Description = "safeguarded from adjustments, damage or deterioration that would invalidate the calibration status and subsequent measurement results.", isActive = true },

                    // 7.1.6
                    new IsoStandard { Id = 114, VersionID = 1, ParentID = 92, ClauseRef = "7.1.6", Particulars = "The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services. " +
                    "This knowledge shall be maintained and be made available to the extent necessary. " +
                    "When addressing changing needs and trends, the organization shall consider its current knowledge " +
                    "and determine how to acquire or access any necessary additional knowledge and required updates. Organizational knowledge can be based on:",
                        Description = "Organizational knowledge", isActive = true },
                    new IsoStandard { Id = 115, VersionID = 1, ParentID = 114, ClauseRef = "7.1.6.Note 1", Particulars = "", Description = "Organizational knowledge is knowledge specific to the organization; it is generally gained by experience. It is information that is used and shared to achieve the organization’s objectives.", isActive = true },
                    new IsoStandard { Id = 116, VersionID = 1, ParentID = 114, ClauseRef = "7.1.6.Note 2", Particulars = "", Description = "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, or the reassignment of currently employed persons; or the hiring or contracting of competent persons.", isActive = true },
                    new IsoStandard { Id = 117, VersionID = 1, ParentID = 114, ClauseRef = "7.1.6.a", Particulars = "", Description = "internal sources (e.g. intellectual property; knowledge gained from experience; lessons learned from failures and successful projects; " +
                    "capturing and sharing undocumented knowledge and experience; the results of improvements in processes, products and services);", isActive = true },
                    new IsoStandard { Id = 118, VersionID = 1, ParentID = 114, ClauseRef = "7.1.6.b", Particulars = "", Description = "external sources (e.g. standards; academia; conferences; gathering knowledge from customers or external providers).", isActive = true },
                    // 7.2
                    new IsoStandard { Id = 119, VersionID = 1, ParentID = 91, ClauseRef = "7.2", Particulars = "", Description = "Competence", isActive = true },
                    new IsoStandard { Id = 120, VersionID = 1, ParentID = 117, ClauseRef = "7.2.a", Particulars = "", Description = "determine the necessary competence of person(s) doing work under its control that affects the performance and effectiveness of the quality management system;", isActive = true },
                    new IsoStandard { Id = 121, VersionID = 1, ParentID = 117, ClauseRef = "7.2.b", Particulars = "", Description = "ensure that these persons are competent on the basis of appropriate education, training, or experience;", isActive = true },
                    new IsoStandard { Id = 122, VersionID = 1, ParentID = 117, ClauseRef = "7.2.c", Particulars = "", Description = "where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken;", isActive = true },

                    // 7.3
                    new IsoStandard { Id = 123, VersionID = 1, ParentID = 91, ClauseRef = "7.3", Particulars = "The organization shall ensure that persons doing work under the organization’s control are aware of:", Description = "Awareness", isActive = true },
                    new IsoStandard { Id = 124, VersionID = 1, ParentID = 121, ClauseRef = "7.3.a", Particulars = "", Description = "quality policy;", isActive = true },
                    new IsoStandard { Id = 125, VersionID = 1, ParentID = 121, ClauseRef = "7.3.b", Particulars = "", Description = "relevant quality objectives;", isActive = true },
                    new IsoStandard { Id = 126, VersionID = 1, ParentID = 121, ClauseRef = "7.3.c", Particulars = "", Description = "their contribution to the effectiveness of the quality management system, including the benefits of improved performance;", isActive = true },
                    new IsoStandard { Id = 127, VersionID = 1, ParentID = 121, ClauseRef = "7.3.d", Particulars = "", Description = "the implications of not conforming with the quality management system requirements.", isActive = true },

                    // 7.4
                    new IsoStandard { Id = 128, VersionID = 1, ParentID = 91, ClauseRef = "7.4", Particulars = "The organization shall determine the internal and external communications relevant to the quality management system, including:", Description = "Communication", isActive = true },
                    new IsoStandard { Id = 129, VersionID = 1, ParentID = 126, ClauseRef = "7.4.a", Particulars = "", Description = "what to communicate;", isActive = true },
                    new IsoStandard { Id = 130, VersionID = 1, ParentID = 126, ClauseRef = "7.4.b", Particulars = "", Description = "when to communicate;", isActive = true },
                    new IsoStandard { Id = 131, VersionID = 1, ParentID = 126, ClauseRef = "7.4.c", Particulars = "", Description = "with whom to communicate;", isActive = true },
                    new IsoStandard { Id = 132, VersionID = 1, ParentID = 126, ClauseRef = "7.4.d", Particulars = "", Description = "how to communicate;", isActive = true },
                    new IsoStandard { Id = 133, VersionID = 1, ParentID = 126, ClauseRef = "7.4.e", Particulars = "", Description = "who communicates.", isActive = true },

                    // 7.5
                    new IsoStandard { Id = 134, VersionID = 1, ParentID = 91, ClauseRef = "7.5", Particulars = "", Description = "Documented information", isActive = true },
                    new IsoStandard { Id = 135, VersionID = 1, ParentID = 132, ClauseRef = "7.5.1", Particulars = "The organization’s quality management system shall include:", Description = "General", isActive = true },
                    new IsoStandard { Id = 136, VersionID = 1, ParentID = 133, ClauseRef = "7.5.1.a", Particulars = "", Description = "documented information required by this International Standard;", isActive = true },
                    new IsoStandard { Id = 137, VersionID = 1, ParentID = 133, ClauseRef = "7.5.1.b", Particulars = "", Description = "documented information determined by the organization as being necessary for the effectiveness of the quality management system.", isActive = true },

                    new IsoStandard { Id = 138, VersionID = 1, ParentID = 132, ClauseRef = "7.5.2", Particulars = "When creating and updating documented information, the organization shall ensure appropriate:", Description = "Creating and updating", isActive = true },
                    new IsoStandard { Id = 139, VersionID = 1, ParentID = 136, ClauseRef = "7.5.2.a", Particulars = "", Description = "identification and description (e.g. a title, date, author, or reference number);", isActive = true },
                    new IsoStandard { Id = 140, VersionID = 1, ParentID = 136, ClauseRef = "7.5.2.b", Particulars = "", Description = "format (e.g. language, software version, graphics) and media (e.g. paper, electronic);", isActive = true },
                    new IsoStandard { Id = 141, VersionID = 1, ParentID = 136, ClauseRef = "7.5.2.c", Particulars = "", Description = "review and approval for suitability and adequacy.", isActive = true },

                    new IsoStandard { Id = 142, VersionID = 1, ParentID = 132, ClauseRef = "7.5.3", Particulars = "", Description = "Control of documented information", isActive = true },
                    new IsoStandard { Id = 143, VersionID = 1, ParentID = 140, ClauseRef = "7.5.3.1", Particulars = "", Description = "Documented information required by the quality management system and by this International Standard shall be controlled to ensure:", isActive = true },
                    new IsoStandard { Id = 144, VersionID = 1, ParentID = 141, ClauseRef = "7.5.3.1.a", Particulars = "", Description = "it is available and suitable for use, where and when it is needed;", isActive = true },
                    new IsoStandard { Id = 145, VersionID = 1, ParentID = 141, ClauseRef = "7.5.3.1.b", Particulars = "", Description = "it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).", isActive = true },

                    new IsoStandard { Id = 146, VersionID = 1, ParentID = 140, ClauseRef = "7.5.3.2", Particulars = "Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and be controlled." +
                    "Documented information retained as evidence of conformity shall be protected from unintended alterations. For the control of documented information, the organization shall address the following activities, as applicable:", Description = "", isActive = true },
                    new IsoStandard { Id = 147, VersionID = 1, ParentID = 144, ClauseRef = "7.5.3.2.a", Particulars = "", Description = "distribution and access;", isActive = true },
                    new IsoStandard { Id = 148, VersionID = 1, ParentID = 144, ClauseRef = "7.5.3.2.b", Particulars = "", Description = "storage and preservation, including preservation of legibility;", isActive = true },
                    new IsoStandard { Id = 149, VersionID = 1, ParentID = 144, ClauseRef = "7.5.3.2.c", Particulars = "", Description = "control of changes (e.g. version control);", isActive = true },
                    new IsoStandard { Id = 150, VersionID = 1, ParentID = 144, ClauseRef = "7.5.3.2.d", Particulars = "", Description = "retention and disposition.", isActive = true },

                // =========================
                // 8 - ROOT
                // =========================
                new IsoStandard { Id = 151, VersionID = 1, ParentID = null, ClauseRef = "8", Particulars = "", Description = "Operation", isActive = true },

                // =========================
                // 8.1 Operational planning and control
                // =========================
                new IsoStandard { Id = 152, VersionID = 1, ParentID = 149, ClauseRef = "8.1", Description = "Operational planning and control", Particulars = "The organization shall plan, implement and control the processes (see 4.4) needed to meet the requirements for the provision of products and services, " +
                "and to implement the actions determined in Clause 6, by:The output of this planning shall be suitable for the organization’s operations. The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary. " +
                "The organization shall ensure that outsourced processes are controlled (see 8.4).", isActive = true },

                new IsoStandard { Id = 153, VersionID = 1, ParentID = 150, ClauseRef = "8.1.a", Particulars = "", Description = "determining the requirements for the products and services;", isActive = true },

                new IsoStandard { Id = 154, VersionID = 1, ParentID = 150, ClauseRef = "8.1.b", Particulars = "", Description = "establishing criteria for:", isActive = true },

                new IsoStandard { Id = 155, VersionID = 1, ParentID = 152, ClauseRef = "8.1.b.1", Particulars = "", Description = "the processes;", isActive = true },

                new IsoStandard { Id = 156, VersionID = 1, ParentID = 152, ClauseRef = "8.1.b.2", Particulars = "", Description = "the acceptance of products and services;", isActive = true },

                new IsoStandard { Id = 157, VersionID = 1, ParentID = 150, ClauseRef = "8.1.c", Particulars = "", Description = "determining the resources needed to achieve conformity to the product and service requirements;", isActive = true },

                new IsoStandard { Id = 158, VersionID = 1, ParentID = 150, ClauseRef = "8.1.d", Particulars = "", Description = "implementing control of the processes in accordance with criteria;", isActive = true },

                new IsoStandard { Id = 159, VersionID = 1, ParentID = 150, ClauseRef = "8.1.e", Particulars = "", Description = "determining, maintaining and retaining documented information to the extent necessary:", isActive = true },

                new IsoStandard { Id = 160, VersionID = 1, ParentID = 157, ClauseRef = "8.1.e.1", Particulars = "", Description = "to have confidence processes were carried out as planned;", isActive = true },

                new IsoStandard { Id = 161, VersionID = 1, ParentID = 157, ClauseRef = "8.1.e.2", Particulars = "", Description = "to demonstrate the conformity of products and services to their requirements.", isActive = true },

                // =========================
                // 8.2 Requirements for products and services
                // =========================
                new IsoStandard { Id = 162, VersionID = 1, ParentID = 149, ClauseRef = "8.2", Particulars = "", Description = "Requirements for products and services", isActive = true },

                // 8.2.1
                new IsoStandard { Id = 163, VersionID = 1, ParentID = 157, ClauseRef = "8.1.e.2", Particulars = "", Description = "to demonstrate the conformity of products and services to their requirements.", isActive = true },
                new IsoStandard { Id = 164, VersionID = 1, ParentID = 160, ClauseRef = "8.2.1", Description = "Customer communication", Particulars = "Communication with customers shall include:", isActive = true },

                new IsoStandard { Id = 165, VersionID = 1, ParentID = 161, ClauseRef = "8.2.1.a", Particulars = "", Description = "providing information relating to products and services;", isActive = true },
                new IsoStandard { Id = 166, VersionID = 1, ParentID = 161, ClauseRef = "8.2.1.b", Particulars = "", Description = "handling enquiries, contracts or orders, including changes;;", isActive = true },
                new IsoStandard { Id = 167, VersionID = 1, ParentID = 161, ClauseRef = "8.2.1.c", Particulars = "", Description = "obtaining customer feedback relating to products and services, including customer complaints;;", isActive = true },
                new IsoStandard { Id = 168, VersionID = 1, ParentID = 161, ClauseRef = "8.2.1.d", Particulars = "", Description = "handling or controlling customer property;", isActive = true },
                new IsoStandard { Id = 169, VersionID = 1, ParentID = 161, ClauseRef = "8.2.1.e", Particulars = "", Description = "establishing specific requirements for contingency actions, when relevant.", isActive = true },

                // 8.2.2 (duplicate removed, only one kept)
                new IsoStandard { Id = 170, VersionID = 1, ParentID = 160, ClauseRef = "8.2.2", Particulars = "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:", Description = "Determining the requirements for products and services", isActive = true },

                new IsoStandard { Id = 171, VersionID = 1, ParentID = 167, ClauseRef = "8.2.2.a", Particulars = "", Description = "the requirements for the products and services are defined, including:", isActive = true },

                new IsoStandard { Id = 172, VersionID = 1, ParentID = 168, ClauseRef = "8.2.2.a.1", Particulars = "", Description = "any applicable statutory and regulatory requirements;", isActive = true },

                new IsoStandard { Id = 173, VersionID = 1, ParentID = 168, ClauseRef = "8.2.2.a.2", Particulars = "", Description = "those considered necessary by the organization;", isActive = true },

                new IsoStandard { Id = 174, VersionID = 1, ParentID = 167, ClauseRef = "8.2.2.b", Particulars = "", Description = "the organization can meet the claims for the products and services it offers.", isActive = true },

                // 8.2.3
                new IsoStandard { Id = 175, VersionID = 1, ParentID = 160, ClauseRef = "8.2.3", Particulars = "Review of the requirements for products and services", Description = "", isActive = true },

                new IsoStandard { Id = 176, VersionID = 1, ParentID = 172, ClauseRef = "8.2.3.1", Particulars = "The organization shall ensure that contract or order requirements differing from those previously defined are resolved." +
                " The customer’s requirements shall be confirmed by the organization before acceptance, " +
                "when the customer does not provide a documented statement of their requirements.", Description = "Review before commitment to supply", isActive = true },

                new IsoStandard { Id = 177, VersionID = 1, ParentID = 173, ClauseRef = "8.2.3.1.a", Particulars = "", Description = "requirements specified by the customer, including the requirements for delivery and postdelivery activities;", isActive = true },
                new IsoStandard { Id = 178, VersionID = 1, ParentID = 173, ClauseRef = "8.2.3.1.b", Particulars = "", Description = "requirements not stated by the customer, but necessary for the specified or intended use, when known;", isActive = true },
                new IsoStandard { Id = 179, VersionID = 1, ParentID = 173, ClauseRef = "8.2.3.1.c", Particulars = "", Description = "requirements specified by organization;", isActive = true },
                new IsoStandard { Id = 180, VersionID = 1, ParentID = 173, ClauseRef = "8.2.3.1.d", Particulars = "", Description = "statutory and regulatory requirements applicable to the products and services;", isActive = true },
                new IsoStandard { Id = 181, VersionID = 1, ParentID = 173, ClauseRef = "8.2.3.1.e", Particulars = "", Description = "contract or order requirements differing from those previously expressed.", isActive = true },

                new IsoStandard { Id = 182, VersionID = 1, ParentID = 172, ClauseRef = "8.2.3.2", Particulars = "", Description = "The organization shall retain documented information, as applicable:", isActive = true },

                new IsoStandard { Id = 183, VersionID = 1, ParentID = 179, ClauseRef = "8.2.3.2.a", Particulars = "", Description = "on the results of the review;", isActive = true },
                new IsoStandard { Id = 184, VersionID = 1, ParentID = 179, ClauseRef = "8.2.3.2.b", Particulars = "", Description = "on any new requirements for products and services.", isActive = true },

                // 8.2.4
                new IsoStandard { Id = 185, VersionID = 1, ParentID = 160, ClauseRef = "8.2.4", Particulars = "The organization shall ensure that relevant documented information is amended, and that relevant persons are made aware of the changed requirements, when the requirements for products and services are changed.", Description = "Changes to requirements for products and services", isActive = true },

                // =========================
                // 8.3 Design and development
                // =========================
                new IsoStandard { Id = 186, VersionID = 1, ParentID = 149, ClauseRef = "8.3", Particulars = "", Description = "Design and development of products and services", isActive = true },

                new IsoStandard { Id = 187, VersionID = 1, ParentID = 183, ClauseRef = "8.3.1", Particulars = "The organization shall establish, implement and maintain a design and development process that is appropriate to ensure the subsequent provision of products and services.", Description = "General", isActive = true },

                new IsoStandard { Id = 188, VersionID = 1, ParentID = 183, ClauseRef = "8.3.2", Particulars = "In determining the stages and controls for design and development, the organization shall consider:", Description = "Design and development of products and services", isActive = true },

                new IsoStandard { Id = 189, VersionID = 1, ParentID = 185, ClauseRef = "8.3.2.a", Particulars = "", Description = "the nature, duration and complexity of the design and development activities;", isActive = true },
                new IsoStandard { Id = 190, VersionID = 1, ParentID = 185, ClauseRef = "8.3.2.b", Particulars = "", Description = "the required process stages, including applicable design and development reviews;", isActive = true },
                new IsoStandard { Id = 191, VersionID = 1, ParentID = 185, ClauseRef = "8.3.2.c", Particulars = "", Description = "the required design and development verification and validation activities;", isActive = true },
                new IsoStandard { Id = 192, VersionID = 1, ParentID = 185, ClauseRef = "8.3.2.d", Particulars = "", Description = "the responsibilities and authorities involved in the design and development process;", isActive = true },
                new IsoStandard { Id = 193, VersionID = 1, ParentID = 185, ClauseRef = "8.3.2.e", Particulars = "", Description = "the internal and external resource needs for the design and development of products and services;;", isActive = true },
                new IsoStandard { Id = 194, VersionID = 1, Particulars = "", ClauseRef = "8.3.2.f", Description = "The need to control interfaces between persons involved in the design and development process;", isActive = true, ParentID = 188 },
                new IsoStandard { Id = 195, VersionID = 1, Particulars = "", ClauseRef = "8.3.2.g", Description = "The need for involvement of customers and users in the design and development process;", isActive = true, ParentID = 188 },
                new IsoStandard { Id = 196, VersionID = 1, Particulars = "", ClauseRef = "8.3.2.h", Description = "The requirements for subsequent provision of products and services;", isActive = true, ParentID = 188 },
                new IsoStandard { Id = 197, VersionID = 1, Particulars = "", ClauseRef = "8.3.2.i", Description = "The level of control expected by customers and other interested parties;", isActive = true, ParentID = 188 },
                new IsoStandard { Id = 198, VersionID = 1, Particulars = "", ClauseRef = "8.3.2.j", Description = "Documented information to demonstrate requirements are met;", isActive = true, ParentID = 188 },


                // 8.3.3 Design and Development Inputs
                new IsoStandard
                {
                    Id = 199,
                    VersionID = 1,
                    Particulars = "The organization shall determine the requirements essential for the specific types of products and services to be designed and developed. " +
                    "The organization shall consider: Inputs shall be adequate for design and development purposes, complete and unambiguous. " +
                    "Conflicting design and development inputs shall be resolved. " +
                    "The organization shall retain documented information on design and development inputs.",
                    ClauseRef = "8.3.3",
                    Description = "Design and development inputs",
                    isActive = true,
                    ParentID = 186
                },

                new IsoStandard { Id = 200, VersionID = 1, Particulars = "", ClauseRef = "8.3.3.a", Description = "Functional and performance requirements; ", isActive = true, ParentID = 199 },
                new IsoStandard { Id = 201, VersionID = 1, Particulars = "", ClauseRef = "8.3.3.b", Description = "Information from previous similar design and development activities; ", isActive = true, ParentID = 199 },
                new IsoStandard { Id = 202, VersionID = 1, Particulars = "", ClauseRef = "8.3.3.c", Description = "Statutory and regulatory requirements; ", isActive = true, ParentID = 199 },
                new IsoStandard { Id = 203, VersionID = 1, Particulars = "", ClauseRef = "8.3.3.d", Description = "standards or codes of practice that the organization has committed to implement;", isActive = true, ParentID = 199 },
                new IsoStandard { Id = 204, VersionID = 1, Particulars = "", ClauseRef = "8.3.3.e", Description = "potential consequences of failure due to the nature of the products and services.", isActive = true, ParentID = 199 },

                // 8.3.4 Design and Development Controls
                new IsoStandard
                {
                    Id = 205,
                    VersionID = 1,
                    Particulars = "The organization shall apply controls to the design and development process to ensure that:",
                    ClauseRef = "8.3.4",
                    Description = "Design and development controls",
                    isActive = true,
                    ParentID = 186
                },
                new IsoStandard { Id = 206, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.a", Description = "The results to be achieved are defined; ", isActive = true, ParentID = 205 },
                new IsoStandard { Id = 207, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.b", Description = "reviews are conducted to evaluate the ability of the results of design and development to meet requirements;", isActive = true, ParentID = 205 },
                new IsoStandard { Id = 208, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.c", Description = "verification activities are conducted to ensure that the design and development outputs meet the input requirements;", isActive = true, ParentID = 205 },
                new IsoStandard { Id = 209, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.d", Description = "Validation activities conducted to ensure that the resulting products and services meet requirements for the specified application or intended use; ", isActive = true, ParentID = 205 },
                new IsoStandard { Id = 210, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.e", Description = "any necessary actions are taken on problems determined during the reviews, or verification and validation activities;", isActive = true, ParentID = 205 },
                new IsoStandard { Id = 211, VersionID = 1, Particulars = "", ClauseRef = "8.3.4.f", Description = "Documented information of these activities is retained. ", isActive = true, ParentID = 205 },

                // 8.3.5 Design and Development Outputs
                new IsoStandard
                {
                    Id = 212,
                    VersionID = 1,
                    Particulars = "The organization shall retain documented information on design and development outputs. The organization shall ensure that design and development outputs.",
                    ClauseRef = "8.3.5",
                    Description = "design and development outputs",
                    isActive = true,
                    ParentID = 186
                },
                new IsoStandard { Id = 213, VersionID = 1, Particulars = "", ClauseRef = "8.3.5.a", Description = "Meet the input requirements", isActive = true, ParentID = 212 },
                new IsoStandard { Id = 214, VersionID = 1, Particulars = "", ClauseRef = "8.3.5.b", Description = "are adequate for the subsequent process for the provision of products and services", isActive = true, ParentID = 212 },
                new IsoStandard { Id = 215, VersionID = 1, Particulars = "", ClauseRef = "8.3.5.c", Description = "include or reference monitoring and measuring requirements, as appropriate, and acceptance criteria;", isActive = true, ParentID = 212 },
                new IsoStandard { Id = 216, VersionID = 1, Particulars = "", ClauseRef = "8.3.5.d", Description = "specify the characteristics of the products and services that are essential for their intended purpose and their safe and proper provision.", isActive = true, ParentID = 212 },

                // 8.3.6 Design and Development Changes
                new IsoStandard
                {
                    Id = 217,
                    VersionID = 1,
                    Particulars = "The organization shall identify, review and control changes made during, or subsequent to, the design and development of products and services, " +
                    "to the extent necessary to ensure that there is no adverse impact on conformity to requirements. The organization shall retain documented information on:",
                    ClauseRef = "8.3.6",
                    Description = "Design and development changes",
                    isActive = true,
                    ParentID = 186
                },
                new IsoStandard { Id = 218, VersionID = 1, Particulars = "", ClauseRef = "8.3.6.a", Description = "design and development changes; ", isActive = true, ParentID = 217 },
                new IsoStandard { Id = 219, VersionID = 1, Particulars = "", ClauseRef = "8.3.6.b", Description = "the results of reviews", isActive = true, ParentID = 217 },
                new IsoStandard { Id = 220, VersionID = 1, Particulars = "", ClauseRef = "8.3.6.c", Description = "the authorization of the changes", isActive = true, ParentID = 217 },
                new IsoStandard { Id = 221, VersionID = 1, Particulars = "", ClauseRef = "8.3.6.d", Description = "the actions taken to prevent adverse impacts", isActive = true, ParentID = 217 },
                
                // 8.4 Control of externally provided processes, products and services
                new IsoStandard
                {
                    Id = 222,
                    VersionID = 1,
                    Particulars = "",
                    ClauseRef = "8.4",
                    Description = "Control of externally provided processes, products and services",
                    isActive = true,
                    ParentID = null
                },

    // 8.4.1 General
    new IsoStandard
    {
        Id = 223,
        VersionID = 1,
        Particulars = "The organization shall ensure that externally provided processes, products and services conform to requirements." +
        "The organization shall determine and apply criteria for the evaluation, selection, monitoring of performance, and re-evaluation of external providers, " +
        "based on their ability to provide processes or products and services in accordance with requirements. " +
        "The organization shall retain documented information of these activities and any necessary actions arising from the evaluations.",
        ClauseRef = "8.4.1",
        Description = "General",
        isActive = true,
        ParentID = 222
    },
    new IsoStandard { Id = 224, VersionID = 1, Particulars = "", ClauseRef = "8.4.1.a", Description = "Products and services intended for incorporation into the organization’s own products and services; ", isActive = true, ParentID = 223 },
    new IsoStandard { Id = 225, VersionID = 1, Particulars = "", ClauseRef = "8.4.1.b", Description = "Products and services provided directly to customers by external providers on behalf of the organization; ", isActive = true, ParentID = 223 },
    new IsoStandard { Id = 226, VersionID = 1, Particulars = "", ClauseRef = "8.4.1.c", Description = "A process, or part of a process, provided by an external provider as a result of a decision by the organization. ", isActive = true, ParentID = 223 },

    // 8.4.2 Type and extent of control
    new IsoStandard
    {
        Id = 227,
        VersionID = 1,
        Particulars = "The organization shall ensure that externally provided processes, products and services do not adversely affect the organization’s ability to consistently deliver conforming products and services to its customers.",
        ClauseRef = "8.4.2",
        Description = "Type and extent of control",
        isActive = true,
        ParentID = 222
    },
    new IsoStandard { Id = 228, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.a", Description = "ensure that externally provided processes remain within the control of its quality management system;", isActive = true, ParentID = 227 },
    new IsoStandard { Id = 229, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.b", Description = "define both the controls that it intends to apply to an external provider and those it intends to apply to the resulting output;", isActive = true, ParentID = 227 },
    new IsoStandard { Id = 230, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.c", Description = "Take into consideration:", isActive = true, ParentID = 227 },
    new IsoStandard { Id = 231, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.c.1", Description = "the potential impact of the externally provided processes, products and services on the organization’s ability to consistently meet customer and applicable statutory and regulatory requirements;", isActive = true, ParentID = 230 },
    new IsoStandard { Id = 232, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.c.2", Description = "Effectiveness of controls applied by the external provide;r", isActive = true, ParentID = 230 },
    new IsoStandard { Id = 233, VersionID = 1, Particulars = "", ClauseRef = "8.4.2.d", Description = "determine the verification, or other activities, necessary to ensure that the externally provided processes, products and services meet requirements.", isActive = true, ParentID = 227 },

    // 8.4.3 Information for external providers
    new IsoStandard
    {
        Id = 234,
        VersionID = 1,
        Particulars = "The organization shall ensure adequacy of requirements prior to communication to external providers.",
        ClauseRef = "8.4.3",
        Description = "Information for external providers",
        isActive = true,
        ParentID = 222
    },
    new IsoStandard { Id = 235, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.a", Description = "Processes, products and services to be provided", isActive = true, ParentID = 234 },
    new IsoStandard { Id = 236, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.b", Description = "the approval of:", isActive = true, ParentID = 234 },
    new IsoStandard { Id = 237, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.b.1", Description = "Products and services", isActive = true, ParentID = 236 },
    new IsoStandard { Id = 238, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.b.2", Description = "Methods, processes and equipment", isActive = true, ParentID = 236 },
    new IsoStandard { Id = 239, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.b.3", Description = "the release of products and services", isActive = true, ParentID = 236 },
    new IsoStandard { Id = 240, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.c", Description = "Competence, including qualification of persons", isActive = true, ParentID = 234 },
    new IsoStandard { Id = 241, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.d", Description = "External providers’ interactions with the organization", isActive = true, ParentID = 234 },
    new IsoStandard { Id = 242, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.e", Description = "control and monitoring of the external providers’ performance to be applied by the organization;", isActive = true, ParentID = 234 },
    new IsoStandard { Id = 243, VersionID = 1, Particulars = "", ClauseRef = "8.4.3.f", Description = "verification or validation activities that the organization, or its customer, intends to perform at the external providers’ premises.", isActive = true, ParentID = 234 },

    // 8.5 Production and service provision
    new IsoStandard
    {
        Id = 244,
        VersionID = 1,
        Particulars = "",
        ClauseRef = "8.5",
        Description = "Production and service provision",
        isActive = true,
        ParentID = null
    },
// 8.5.1
new IsoStandard { Id = 245, VersionID = 1, ClauseRef = "8.5.1", Description = "Control of production and service provision", Particulars = "The organization shall implement production and service provision under controlled conditions. Controlled conditions shall include, as applicable:", isActive = true, ParentID = 244 },

new IsoStandard { Id = 246, VersionID = 1, ClauseRef = "8.5.1.a", Description = "the availability of documented information that defines:", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 247, VersionID = 1, ClauseRef = "8.5.1.a.1", Description = "the characteristics of the products to be produced, the services to be provided, or the activities to be performed;", Particulars = "", isActive = true, ParentID = 246 },

new IsoStandard { Id = 248, VersionID = 1, ClauseRef = "8.5.1.a.2", Description = "the results to be achieved;", Particulars = "", isActive = true, ParentID = 246 },

new IsoStandard { Id = 249, VersionID = 1, ClauseRef = "8.5.1.b", Description = "the availability and use of suitable monitoring and measuring resources;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 250, VersionID = 1, ClauseRef = "8.5.1.c", Description = "the implementation of monitoring and measurement activities at appropriate stages to verify that criteria for control of processes or outputs, and acceptance criteria for products and services, have been met;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 251, VersionID = 1, ClauseRef = "8.5.1.d", Description = "the use of suitable infrastructure and environment for the operation of processes;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 252, VersionID = 1, ClauseRef = "8.5.1.e", Description = "the appointment of competent persons, including any required qualification;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 253, VersionID = 1, ClauseRef = "8.5.1.f", Description = "the validation, and periodic revalidation, of the ability to achieve planned results of the processes for production and service provision, where the resulting output cannot be verified by subsequent monitoring or measurement;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 254, VersionID = 1, ClauseRef = "8.5.1.g", Description = "the implementation of actions to prevent human error;", Particulars = "", isActive = true, ParentID = 245 },

new IsoStandard { Id = 255, VersionID = 1, ClauseRef = "8.5.1.h", Description = "the implementation of release, delivery and post-delivery activities.", Particulars = "", isActive = true, ParentID = 245 },

// 8.5.2
new IsoStandard { Id = 256, VersionID = 1, ClauseRef = "8.5.2", Description = "Identification and traceability", Particulars = "The organization shall use suitable means to identify outputs when it is necessary to ensure the conformity of products and services. " +
"The organization shall identify the status of outputs with respect to monitoring and measurement requirements throughout production and service provision. " +
"The organization shall control the unique identification of the outputs when traceability is a requirement, " +
"and shall retain the documented information necessary to enable traceability.", isActive = true, ParentID = 244 },

// 8.5.3
new IsoStandard { Id = 257, VersionID = 1, ClauseRef = "8.5.3", Description = "Property belonging to customers or external providers", Particulars = "The organization shall exercise care with property belonging to customers or external providers while it is under the organization’s control or being used by the organization. " +
"The organization shall identify, verify, protect and safeguard customers’ or external providers’ property provided for use or incorporation into the products and services. " +
"When the property of a customer or external provider is lost, damaged or otherwise found to be unsuitable for use," +
" the organization shall report this to the customer or external provider and retain documented information on what has occurred.", isActive = true, ParentID = 244 },

// 8.5.4
new IsoStandard { Id = 258, VersionID = 1, ClauseRef = "8.5.4", Description = "Preservation", Particulars = "The organization shall preserve the outputs during production and service provision, to the extent necessary to ensure conformity to requirements.", isActive = true, ParentID = 244 },

// 8.5.5
new IsoStandard { Id = 259, VersionID = 1, ClauseRef = "8.5.5", Description = "Post-delivery activities", Particulars = "The organization shall meet requirements for post-delivery activities associated with the products and services. In determining the extent of post-delivery activities that are required, the organization shall consider:", isActive = true, ParentID = 244 },

new IsoStandard { Id = 260, VersionID = 1, ClauseRef = "8.5.5.a", Description = "statutory and regulatory requirements;", Particulars = "", isActive = true, ParentID = 259 },

new IsoStandard { Id = 261, VersionID = 1, ClauseRef = "8.5.5.b", Description = "the potential undesired consequences associated with its products and services;", Particulars = "", isActive = true, ParentID = 259 },

new IsoStandard { Id = 262, VersionID = 1, ClauseRef = "8.5.5.c", Description = "the nature, use and intended lifetime of its products and services;", Particulars = "", isActive = true, ParentID = 259 },

new IsoStandard { Id = 263, VersionID = 1, ClauseRef = "8.5.5.d", Description = "customer requirements;", Particulars = "", isActive = true, ParentID = 259 },

new IsoStandard { Id = 264, VersionID = 1, ClauseRef = "8.5.5.e", Description = "customer feedback.", Particulars = "", isActive = true, ParentID = 259 },
// 8.5.6
new IsoStandard
{
    Id = 265,
    VersionID = 1,
    ClauseRef = "8.5.6",
    Description = "Control of changes",
    Particulars = "The organization shall review and control changes for production or service provision, to the extent necessary to ensure continuing conformity with requirements. The organization shall retain documented information describing the results of the review of changes, the person(s) authorizing the change, and any necessary actions arising from the review.",
    isActive = true,
    ParentID = 244
},

// 8.6
new IsoStandard
{
    Id = 266,
    VersionID = 1,
    ClauseRef = "8.6",
    Description = "Release of products and services",
    Particulars = "The organization shall implement planned arrangements, at appropriate stages, to verify that the product and service requirements have been met. The release of products and services to the customer shall not proceed until the planned arrangements have been satisfactorily completed, unless otherwise approved by a relevant authority and, as applicable, by the customer. The organization shall retain documented information on the release of products and services. The documented information shall include:",
    isActive = true,
    ParentID = 244
},

new IsoStandard
{
    Id = 267,
    VersionID = 1,
    ClauseRef = "8.6.a",
    Description = "evidence of conformity with the acceptance criteria;",
    Particulars = "",
    isActive = true,
    ParentID = 266
},

new IsoStandard
{
    Id = 268,
    VersionID = 1,
    ClauseRef = "8.6.b",
    Description = "traceability to the person(s) authorizing the release.",
    Particulars = "",
    isActive = true,
    ParentID = 266
},

// 8.7
new IsoStandard
{
    Id = 269,
    VersionID = 1,
    ClauseRef = "8.7",
    Description = "Control of nonconforming outputs",
    Particulars = "",
    isActive = true,
    ParentID = 244
},

new IsoStandard
{
    Id = 270,
    VersionID = 1,
    ClauseRef = "8.7.1",
    Description = "",
    Particulars = "The organization shall ensure that outputs that do not conform to their requirements are identified and controlled to prevent their unintended use or delivery. The organization shall take appropriate action based on the nature of the nonconformity and its effect on the conformity of products and services. This shall also apply to nonconforming products and services detected after delivery of products, during or after the provision of services. Conformity to the requirements shall be verified when nonconforming outputs are corrected. The organization shall deal with nonconforming outputs in one or more of the following ways:",
    isActive = true,
    ParentID = 269
},

new IsoStandard { Id = 271, VersionID = 1, ClauseRef = "8.7.1.a", Description = "Correction;", Particulars = "", isActive = true, ParentID = 270 },

new IsoStandard { Id = 272, VersionID = 1, ClauseRef = "8.7.1.b", Description = "segregation, containment, return or suspension of provision of products and services;", Particulars = "", isActive = true, ParentID = 270 },

new IsoStandard { Id = 273, VersionID = 1, ClauseRef = "8.7.1.c", Description = "informing the customer;", Particulars = "", isActive = true, ParentID = 270 },

new IsoStandard { Id = 274, VersionID = 1, ClauseRef = "8.7.1.d", Description = "obtaining authorization for acceptance under concession.", Particulars = "", isActive = true, ParentID = 270 },

new IsoStandard
{
    Id = 275,
    VersionID = 1,
    ClauseRef = "8.7.2",
    Description = "",
    Particulars = "The organization shall retain documented information that:",
    isActive = true,
    ParentID = 269
},

new IsoStandard { Id = 276, VersionID = 1, ClauseRef = "8.7.2.a", Description = "describes the nonconformity;", Particulars = "", isActive = true, ParentID = 275 },

new IsoStandard { Id = 277, VersionID = 1, ClauseRef = "8.7.2.b", Description = "describes the actions taken;", Particulars = "", isActive = true, ParentID = 275 },

new IsoStandard { Id = 278, VersionID = 1, ClauseRef = "8.7.2.c", Description = "describes any concessions obtained;", Particulars = "", isActive = true, ParentID = 275 },

new IsoStandard { Id = 279, VersionID = 1, ClauseRef = "8.7.2.d", Description = "identifies the authority deciding the action in respect of the nonconformity.", Particulars = "", isActive = true, ParentID = 275 },
new IsoStandard { Id = 280, VersionID = 1, ClauseRef = "9", Description = "Performance evaluation", Particulars = "", ParentID = null, isActive = true },

    // 9.1
    new IsoStandard { Id = 281, VersionID = 1, ClauseRef = "9.1", Description = "Monitoring, measurement, analysis and evaluation", Particulars = "", ParentID = 280, isActive = true },

    new IsoStandard { Id = 282, VersionID = 1, ClauseRef = "9.1.1", Description = "General", Particulars = "The organization shall evaluate the performance and the effectiveness of the quality management system. The organization shall retain appropriate documented information as evidence of the results. The organization shall determine:", ParentID = 281, isActive = true },

    new IsoStandard { Id = 283, VersionID = 1, ClauseRef = "9.1.1.a", Description = "what needs to be monitored and measured;", Particulars = "", ParentID = 282, isActive = true },
    new IsoStandard { Id = 284, VersionID = 1, ClauseRef = "9.1.1.b", Description = "the methods for monitoring, measurement, analysis and evaluation needed to ensure valid results;", Particulars = "", ParentID = 282, isActive = true },
    new IsoStandard { Id = 285, VersionID = 1, ClauseRef = "9.1.1.c", Description = "when the monitoring and measuring shall be performed;", Particulars = "", ParentID = 282, isActive = true },
    new IsoStandard { Id = 286, VersionID = 1, ClauseRef = "9.1.1.d", Description = "when the results from monitoring and measurement shall be analysed and evaluated.", Particulars = "", ParentID = 282, isActive = true },

    new IsoStandard { Id = 287, VersionID = 1, ClauseRef = "9.1.2", Description = "Customer satisfaction", Particulars = "The organization shall monitor customers’ perceptions of the degree to which their needs and expectations have been fulfilled. The organization shall determine the methods for obtaining, monitoring and reviewing this information.", ParentID = 281, isActive = true },

    new IsoStandard { Id = 288, VersionID = 1, ClauseRef = "9.1.3", Description = "Analysis and evaluation", Particulars = "The organization shall analyse and evaluate appropriate data and information arising from monitoring and measurement. The results of analysis shall be used to evaluate:", ParentID = 281, isActive = true },

    new IsoStandard { Id = 289, VersionID = 1, ClauseRef = "9.1.3.a", Description = "conformity of products and services;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 290, VersionID = 1, ClauseRef = "9.1.3.b", Description = "the degree of customer satisfaction;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 291, VersionID = 1, ClauseRef = "9.1.3.c", Description = "the performance and effectiveness of the quality management system;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 292, VersionID = 1, ClauseRef = "9.1.3.d", Description = "if planning has been implemented effectively;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 293, VersionID = 1, ClauseRef = "9.1.3.e", Description = "the effectiveness of actions taken to address risks and opportunities;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 294, VersionID = 1, ClauseRef = "9.1.3.f", Description = "the performance of external providers;", Particulars = "", ParentID = 288, isActive = true },
    new IsoStandard { Id = 295, VersionID = 1, ClauseRef = "9.1.3.g", Description = "the need for improvements to the quality management system.", Particulars = "", ParentID = 288, isActive = true },

    // 9.2 Internal audit
    new IsoStandard { Id = 296, VersionID = 1, ClauseRef = "9.2", Description = "Internal audit", Particulars = "", ParentID = 280, isActive = true },
    new IsoStandard { Id = 297, VersionID = 1, ClauseRef = "9.2.1", Description = "", Particulars = "The organization shall conduct internal audits at planned intervals to provide information on whether the quality management system:", ParentID = 296, isActive = true },
    new IsoStandard { Id = 298, VersionID = 1, ClauseRef = "9.2.1.a", Description = "conforms to:", Particulars = "", ParentID = 297, isActive = true },
    new IsoStandard { Id = 299, VersionID = 1, ClauseRef = "9.2.1.a.1", Description = "the organization’s own requirements for its quality management system;", Particulars = "", ParentID = 298, isActive = true },
    new IsoStandard { Id = 300, VersionID = 1, ClauseRef = "9.2.1.a.2", Description = "the requirements of this International Standard;", Particulars = "", ParentID = 298, isActive = true },
    new IsoStandard { Id = 301, VersionID = 1, ClauseRef = "9.2.1.b", Description = "is effectively implemented and maintained.", Particulars = "", ParentID = 297, isActive = true },
    new IsoStandard { Id = 302, VersionID = 1, ClauseRef = "9.2.2", Description = "", Particulars = "The organization shall:", ParentID = 296, isActive = true },
    new IsoStandard { Id = 303, VersionID = 1, ClauseRef = "9.2.2.a", Description = "plan, establish, implement and maintain an audit programme(s) including the frequency, methods, responsibilities, planning requirements and reporting, which shall take into consideration the importance of the processes concerned, changes affecting the organization, and the results of previous audits;", Particulars = "", ParentID = 302, isActive = true },

// 9.2.2.b to 9.3.2.c.6 continuation
new IsoStandard { Id = 304, VersionID = 1, Particulars = "", ClauseRef = "9.2.2.b", Description = "define the audit criteria and scope for each audit;", isActive = true, ParentID = 302 },
new IsoStandard { Id = 305, VersionID = 1, Particulars = "", ClauseRef = "9.2.2.c", Description = "select auditors and conduct audits to ensure objectivity and the impartiality of the audit process;", isActive = true, ParentID = 279 },
new IsoStandard { Id = 306, VersionID = 1, Particulars = "", ClauseRef = "9.2.2.d", Description = "ensure that the results of the audits are reported to relevant management;", isActive = true, ParentID = 302 },
new IsoStandard { Id = 307, VersionID = 1, Particulars = "", ClauseRef = "9.2.2.e", Description = "take appropriate correction and corrective actions without undue delay;", isActive = true, ParentID = 302 },
new IsoStandard { Id = 308, VersionID = 1, Particulars = "", ClauseRef = "9.2.2.f", Description = "retain documented information as evidence of the implementation of the audit programme and the audit results.", isActive = true, ParentID = 302 },

// 9.3 Management review
new IsoStandard { Id = 309, VersionID = 1, Particulars = "", ClauseRef = "9.3", Description = "Management review", isActive = true, ParentID = 280 },

new IsoStandard { Id = 310, VersionID = 1, Particulars = "Top management shall review the organization’s quality management system, at planned intervals, to ensure its continuing suitability, adequacy, effectiveness and alignment with the strategic direction of the organization.", ClauseRef = "9.3.1", Description = "General", isActive = true, ParentID = 309 },

new IsoStandard { Id = 311, VersionID = 1, Particulars = "The management review shall be planned and carried out taking into consideration:", ClauseRef = "9.3.2", Description = "Management review inputs", isActive = true, ParentID =309 },

new IsoStandard { Id = 312, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.a", Description = "the status of actions from previous management reviews;", isActive = true, ParentID = 311 },
new IsoStandard { Id = 313, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.b", Description = "changes in external and internal issues that are relevant to the quality management system;", isActive = true, ParentID = 311 },
new IsoStandard { Id = 314, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c", Description = "information on the performance and effectiveness of the quality management system, including trends in:", isActive = true, ParentID = 311 },

new IsoStandard { Id = 315, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.1", Description = "customer satisfaction and feedback from relevant interested parties;", isActive = true, ParentID = 314 },
new IsoStandard { Id = 316, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.2", Description = "the extent to which quality objectives have been met;", isActive = true, ParentID = 314 },
new IsoStandard { Id = 317, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.3", Description = "process performance and conformity of products and services;", isActive = true, ParentID = 314 },
new IsoStandard { Id = 318, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.4", Description = "nonconformities and corrective actions;", isActive = true, ParentID = 314 },
new IsoStandard { Id = 319, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.5", Description = "monitoring and measurement results;", isActive = true, ParentID = 314 },
new IsoStandard { Id = 320, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.6", Description = "audit results;", isActive = true, ParentID = 314 },
// 9.3.2.c.7 to 10.3
new IsoStandard { Id = 321, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.c.7", Description = "the performance of external providers", isActive = true, ParentID = 314 },
new IsoStandard { Id = 322, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.d", Description = "the adequacy of resources;", isActive = true, ParentID = 311 },
new IsoStandard { Id = 323, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.e", Description = "the effectiveness of actions taken to address risks and opportunities (see 6.1);", isActive = true, ParentID = 311 },
new IsoStandard { Id = 324, VersionID = 1, Particulars = "", ClauseRef = "9.3.2.f", Description = "opportunities for improvement", isActive = true, ParentID = 311 },

new IsoStandard { Id = 325, VersionID = 1, Particulars = "The organization shall retain documented information as evidence of the results of management reviews. The outputs of the management review shall include decisions and actions related to:", ClauseRef = "9.3.3", Description = "Management review outputs", isActive = true, ParentID = 309 },
new IsoStandard { Id = 326, VersionID = 1, Particulars = "", ClauseRef = "9.3.3.a", Description = "opportunities for improvement;", isActive = true, ParentID = 325 },
new IsoStandard { Id = 327, VersionID = 1, Particulars = "", ClauseRef = "9.3.3.b", Description = "any need for changes to the quality management system;", isActive = true, ParentID = 325 },
new IsoStandard { Id = 328, VersionID = 1, Particulars = "", ClauseRef = "9.3.3.c", Description = "resource needs.", isActive = true, ParentID = 325 },

// 10 – Improvement
new IsoStandard { Id = 329, VersionID = 1, Particulars = "", ClauseRef = "10", Description = "Improvement", isActive = true, ParentID = null },
new IsoStandard { Id = 330, VersionID = 1, Particulars = "The organization shall determine and select opportunities for improvement and implement any necessary actions to meet customer requirements and enhance customer satisfaction. These shall include:", ClauseRef = "10.1", Description = "General", isActive = true, ParentID = 329 },
new IsoStandard { Id = 331, VersionID = 1, Particulars = "", ClauseRef = "10.1.1.a", Description = "improving products and services to meet requirements as well as to address future needs and expectations;", isActive = true, ParentID = 330 },
new IsoStandard { Id = 332, VersionID = 1, Particulars = "", ClauseRef = "10.1.1.b", Description = "correcting, preventing or reducing undesired effects;", isActive = true, ParentID = 330 },
new IsoStandard { Id = 333, VersionID = 1, Particulars = "", ClauseRef = "10.1.1.c", Description = "improving the performance and effectiveness of the quality management system.", isActive = true, ParentID = 330 },

new IsoStandard { Id = 334, VersionID = 1, Particulars = "", ClauseRef = "10.2", Description = "Nonconformity and corrective action", isActive = true, ParentID = 329 },
new IsoStandard { Id = 335, VersionID = 1, Particulars = "Corrective actions shall be appropriate to the effects of the nonconformities encountered. When a nonconformity occurs, including any arising from complaints, the organization shall:", ClauseRef = "10.2.1", Description = "", isActive = true, ParentID = 334 },
new IsoStandard { Id = 336, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.a", Description = "react to the nonconformity and, as applicable:", isActive = true, ParentID = 335 },
new IsoStandard { Id = 337, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.a.1", Description = "take action control and correct it;", isActive = true, ParentID = 336 },
new IsoStandard { Id = 338, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.a.2", Description = "deal with the consequences;", isActive = true, ParentID = 336 },
new IsoStandard { Id = 339, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.b", Description = "evaluate the need for action to eliminate the cause(s) of the nonconformity, in order that it does not recur or occur elsewhere, by:", isActive = true, ParentID = 335 },
new IsoStandard { Id = 340, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.b.1", Description = "reviewing and analysing the nonconformity;", isActive = true, ParentID = 339 },
new IsoStandard { Id = 341, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.b.2", Description = "determining the causes of the nonconformity;", isActive = true, ParentID = 339 },
new IsoStandard { Id = 342, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.b.3", Description = "determining if similar nonconformities exist, or could potentially occur;", isActive = true, ParentID = 335 },
new IsoStandard { Id = 343, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.c", Description = "implement any action needed;", isActive = true, ParentID = 335 },
new IsoStandard { Id = 344, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.d", Description = "review the effectiveness of any corrective action taken;", isActive = true, ParentID = 335 },
new IsoStandard { Id = 345, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.e", Description = "update risks and opportunities determined during planning, if necessary;", isActive = true, ParentID = 335 },
new IsoStandard { Id = 346, VersionID = 1, Particulars = "", ClauseRef = "10.2.1.f", Description = "make changes to the quality management system, if necessary.", isActive = true, ParentID = 335 },
new IsoStandard { Id = 347, VersionID = 1, Particulars = "The organization shall retain documented information as evidence of:", ClauseRef = "10.2.2", Description = "", isActive = true, ParentID = 334 },
new IsoStandard { Id = 348, VersionID = 1, Particulars = "", ClauseRef = "10.2.2.a", Description = "the nature of the nonconformities and any subsequent actions taken;", isActive = true, ParentID = 347 },
new IsoStandard { Id = 349, VersionID = 1, Particulars = "", ClauseRef = "10.2.2.b", Description = "the results of any corrective action.", isActive = true, ParentID = 347 },

new IsoStandard { Id = 350, VersionID = 1, Particulars = "The organization shall continually improve the suitability, adequacy and effectiveness of the quality management system. The organization shall consider the results of analysis and evaluation, and the outputs from management review, to determine if there are needs or opportunities that shall be addressed as part of continual improvement.", ClauseRef = "10.3", Description = "Continual improvement", isActive = true, ParentID = 329 }








            );

        }
    }
}
