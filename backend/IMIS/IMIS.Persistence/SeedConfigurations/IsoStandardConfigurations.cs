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
                new IsoStandard {
                    Id = 1, VersionID = 1,
                    Particulars = "", ClauseRef = "4",
                    Description = "Context of the organization",
                    isActive = true
                },
                new IsoStandard
                {
                    Id = 2,
                    VersionID = 1,
                    Particulars = "The organization shall determine external and internal issues that are relevant to its purpose and its strategic direction and that affect its ability to achieve the intended result(s) of its quality management system. Issues can include positive and negative factors or conditions for consideration.",
                    ClauseRef = "4.1 ",
                    Description = "Understanding the organization and its context",
                    isActive = true
                },
                new IsoStandard
                {
                    Id = 1,
                    VersionID = 1,
                    Particulars = "",
                    ClauseRef = "4.1.NOTE 1",
                    Description = "The organization shall monitor and review information about these external and internal issues.",
                    isActive = true
                },
                
                new IsoStandard
                {
                    Id = 1,
                    VersionID = 1,
                    Particulars = "",
                    ClauseRef = "4.1.NOTE 2",
                    Description = "Understanding the external context can be facilitated by considering issues arising from legal, technological, competitive, market, cultural, social and economic environments, whether international, national, regional or local.",
                    isActive = true
                },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.1.NOTE 3",
                     Description = "Understanding the internal context can be facilitated by considering issues related to values, culture, knowledge and performance of the organization.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "Due to their effect or potential effect on the organization’s ability to consistently provide products and services that meet customer and applicable statutory and regulatory requirements, the organization shall determine: The organization shall monitor and review information about these interested parties and their relevant requirements.",
                     ClauseRef = "4.2 ",
                     Description = "Understanding the needs and expectations of interested parties",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.2.a ",
                     Description = "the interested parties that are relevant to the quality management system;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.2.b ",
                     Description = "the requirements of these interested parties that are relevant to the quality management system.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "The organization shall determine the boundaries and applicability of the quality management system to establish its scope.The organization shall apply all the requirements of this International Standard if they are applicable within the determined scope of its quality management system. The scope of the organization’s quality management system shall be available and be maintained as documented information. The scope shall state the types of products and services covered, and provide justification for any requirement of this International Standard that the organization determines is not applicable to the scope of its quality management system. Conformity to this International Standard may only be claimed if the requirements determined as not being applicable do not affect the organization’s ability or responsibility to ensure the conformity of its products and services and the enhancement of customer satisfaction. When determining this scope, the organization shall consider:",
                     ClauseRef = "4.3",
                     Description = "Determining the scope of the quality management system",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.3.a ",
                     Description = "the external and internal issues referred to in 4.1;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.3.b ",
                     Description = "the requirements of relevant interested parties referred to in 4.2;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.3.c ",
                     Description = "the products and services of the organization.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4",
                     Description = "Quality management system and its processes",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "The organization shall determine the processes needed for the quality management system and their application throughout the organization, and shall:",
                     ClauseRef = "4.4.1",
                     Description = "The organization shall establish, implement, maintain and continually improve a quality management system, including the processes needed and their interactions, in accordance with the requirements of this International Standard.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 a",
                     Description = "determine the inputs required and the outputs expected from these processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 b",
                     Description = "determine the sequence and interaction of these processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 c",
                     Description = "determine and apply the criteria and methods (including monitoring, " +
                     "measurements and related performance indicators) needed to ensure the effective operation and control of these processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 d",
                     Description = "determine the resources needed for these processes and ensure their availability;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 e",
                     Description = "assign the responsibilities and authorities for these processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 f",
                     Description = "address the risks and opportunities as determined in accordance with the requirements of 6.1;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 g",
                     Description = "evaluate these processes and implement any changes needed to ensure that these processes achieve their intended results;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.1 h",
                     Description = "improve the processes and the quality management system.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "To the extent necessary, the organization shall:",
                     ClauseRef = "4.4.2",
                     Description = "",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.2.a",
                     Description = "maintain documented information to support the operation of its processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "4.4.2.b",
                     Description = "retain documented information to have confidence that the processes are being carried out as planned.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5",
                     Description = "Leadership",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1",
                     Description = "Leadership and commitment",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "Top management shall demonstrate leadership and commitment with respect to the quality management system by: NOTE Reference to “business” in this International Standard can be interpreted broadly to mean those activities that are core to the purposes of the organization’s existence, whether the organization is public, private, for profit or not for profit.",
                     ClauseRef = "5.1.1",
                     Description = "General",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.a",
                     Description = "taking accountability for the effectiveness of the quality management system;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.b",
                     Description = "ensuring that the quality policy and quality objectives are established for the quality management system and are compatible with the context and strategic direction of the organization;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.c",
                     Description = "ensuring the integration of the quality management system requirements into the organization’s business processes;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.d",
                     Description = "promoting the use of the process approach and risk-based thinking;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.e",
                     Description = "ensuring that the resources needed for the quality management system are available;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.f",
                     Description = "communicating the importance of effective quality management and of conforming to the quality management system requirements;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.g",
                     Description = "ensuring that the quality management system achieves its intended results;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.h",
                     Description = "engaging, directing and supporting persons to contribute to the effectiveness of the quality management system;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.i",
                     Description = "promoting improvement;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.1.j",
                     Description = "supporting other relevant management roles to demonstrate their leadership as it applies to their areas of responsibility.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.2",
                     Description = "Top management shall demonstrate leadership and commitment with respect to customer focus by ensuring that:",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.2.a",
                     Description = "customer and applicable statutory and regulatory requirements are determined, understood and consistently met;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.2.b",
                     Description = "the risks and opportunities that can affect conformity of products and services and the ability to enhance customer satisfaction are determined and addressed;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.1.2.c",
                     Description = "the focus on enhancing customer satisfaction is maintained.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2",
                     Description = "Policy",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "Top management shall establish, implement and maintain a quality policy that:",
                     ClauseRef = "5.2.1",
                     Description = "Establishing the quality policy",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.1.a",
                     Description = "is appropriate to the purpose and context of the organization and supports its strategic direction;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.1.b",
                     Description = "provides a framework for setting quality objectives;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.1.c",
                     Description = "includes a commitment to satisfy applicable requirements;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.1.c",
                     Description = "includes a commitment to continual improvement of the quality management system.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "The quality policy shall:",
                     ClauseRef = "5.2.2",
                     Description = "Communicating the quality policy",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.2.a",
                     Description = "be available and be maintained as documented information;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.2.b",
                     Description = "be communicated, understood and applied within the organization;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.2.2.c",
                     Description = "be available to relevant interested parties, as appropriate.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "Top management shall ensure that the responsibilities and authorities for relevant roles are assigned, communicated and understood within the organization." +
                     "Top management shall assign the responsibility and authority for:",
                     ClauseRef = "5.3",
                     Description = "Organizational roles, responsibilities and authorities",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.3.a",
                      Description = "ensuring that the quality management system conforms to the requirements of this International Standard;",
                      isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.3.b",
                     Description = "ensuring that the processes are delivering their intended outputs;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.3.c",
                     Description = "reporting on the performance of the quality management system and on opportunities for improvement (see 10.1), in particular to top management;",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "5.3.d",
                     Description = "ensuring the promotion of customer focus throughout the organization.",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "",
                     ClauseRef = "6",
                     Description = "Planning",
                     isActive = true
                 },
                 new IsoStandard
                 {
                     Id = 1,
                     VersionID = 1,
                     Particulars = "When planning for the quality management system, the organization shall consider the context of the organization and the issues referred to in 4.1, as well as the requirements referred to in 4.2. The organization shall determine the risks and opportunities that need to be addressed to:",
                     ClauseRef = "6.1",
                     Description = "Actions to address risks and opportunities",
                     isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.a",
                      Description = "give assurance that the quality management system can achieve its intended result(s);",
                      isActive = true
                  },
                  new IsoStandard
                   {
                        Id = 1,
                        VersionID = 1,
                        Particulars = "",
                        ClauseRef = "6.1.b",
                        Description = "enhance desirable effects;",
                        isActive = true
                   },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.c",
                      Description = "prevent, or reduce, undesired effects;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.d",
                      Description = "achieve improvement.",
                      isActive = true
                   },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "The organization shall plan: evaluate the effectiveness of these actions.",
                      ClauseRef = "6.1.2",
                      Description = "",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.a",
                      Description = "actions to address these risks and opportunities;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.b",
                      Description = "how to:",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.b.1",
                      Description = "integrate and implement the actions into its quality management system processes (see 4.4);",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.b.1",
                      Description = "evaluate the effectiveness of these actions.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.Note 1",
                      Description = "Options to address risks can include avoiding risk, taking risk in order to pursue an opportunity, " +
                      "eliminating the risk source, changing the likelihood or consequences, sharing the risk, or retaining risk by informed decision.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.1.2.Note 2",
                      Description = "Opportunities can lead to the adoption of new practices, launching new products, opening new markets, addressing new customers, " +
                      "building partnerships, using new technology and other desirable and viable possibilities to address the organization’s or its customers’ needs.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2",
                      Description = "Quality objectives and planning to achieve them",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "The quality objectives shall: The quality objectives shall:",
                      ClauseRef = "6.2.1",
                      Description = "The organization shall establish quality objectives at relevant functions, levels and processes needed for the quality management system.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.a",
                      Description = "be consistent with the quality policy;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.b",
                      Description = "be measurable;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.c",
                      Description = "take into account applicable requirements;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.d",
                      Description = "be relevant to conformity of products and services and to enhancement of customer satisfaction;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.e",
                      Description = "be monitored;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.f",
                      Description = "be communicated;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.1.g",
                      Description = "be updated as appropriate.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "When planning how to achieve its quality objectives, the organization shall determine:",
                      ClauseRef = "6.2.2",
                      Description = "",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.2.a",
                      Description = "what will be done;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.2.b",
                      Description = "what resources will be required;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.2.c",
                      Description = "who will be responsible;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.2.d",
                      Description = "when it will be completed;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.2.2.e",
                      Description = "how the results will be evaluated.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "When the organization determines the need for changes to the quality management system, the changes shall be carried out in a planned manner (see 4.4)." +
                      "The organization shall consider:",
                      ClauseRef = "6.3",
                      Description = "Planning of changes",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.3.a",
                      Description = "the purpose of the change and its potential consequences;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.3.b",
                      Description = "the integrity of the quality management system;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.3.c",
                      Description = "the availability of resources;",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "6.3.d",
                      Description = "the allocation or reallocation of responsibilities and authorities.",
                      isActive = true
                  },
                  new IsoStandard
                  {
                      Id = 1,
                      VersionID = 1,
                      Particulars = "",
                      ClauseRef = "7",
                      Description = "Support",
                      isActive = true
                   },
                   new IsoStandard
                   {
                       Id = 1,
                       VersionID = 1,
                       Particulars = "",
                       ClauseRef = "7.1",
                       Description = "Resources",
                       isActive = true
                    },
                    new IsoStandard
                    {
                        Id = 1,
                        VersionID = 1,
                        Particulars = "The organization shall determine and provide the resources needed for the establishment, implementation," +
                        " maintenance and continual improvement of the quality management system. The organization shall consider:",
                        ClauseRef = "7.1.1",
                        Description = "General",
                        isActive = true
                     },
                     new IsoStandard
                     {
                         Id = 1,
                         VersionID = 1,
                         Particulars = "",
                         ClauseRef = "7.1.1.a",
                         Description = "the capabilities of, and constraints on, existing internal resources;",
                         isActive = true
                     },
                     new IsoStandard
                     {
                         Id = 1,
                         VersionID = 1,
                         Particulars = "",
                         ClauseRef = "7.1.1.b",
                         Description = "what needs to be obtained from external providers.",
                         isActive = true
                      },
                     new IsoStandard
                     {
                         Id = 1,
                         VersionID = 1,
                         Particulars = "The organization shall determine and provide the persons necessary for the effective implementation of its " +
                         "quality management system and for the operation and control of its processes.",
                         ClauseRef = "7.1.2",
                         Description = "People",
                         isActive = true
                      },
                     new IsoStandard
                        {
                            Id = 1,
                            VersionID = 1,
                            Particulars = "The organization shall determine and provide the infrastructure needed for the operation of its processes and to achieve conformity of products and services. " +
                            "Note Infrastracture can Include:",
                            ClauseRef = "7.1.3",
                            Description = "Infrastructure",
                            isActive = true
                        },
                      new IsoStandard
                      {
                          Id = 1,
                          VersionID = 1,
                          Particulars = "",
                          ClauseRef = "7.1.3.a",
                          Description = "buildings and associated utilities;",
                          isActive = true
                      },
                       new IsoStandard
                       {
                           Id = 1,
                           VersionID = 1,
                           Particulars = "",
                           ClauseRef = "7.1.3.b",
                           Description = " equipment, including hardware and software;",
                           isActive = true
                       },
                       new IsoStandard
                       {
                           Id = 1,
                           VersionID = 1,
                           Particulars = "",
                           ClauseRef = "7.1.3.c",
                           Description = "transportation resources;",
                           isActive = true
                       },
                       new IsoStandard
                       {
                           Id = 1,
                           VersionID = 1,
                           Particulars = "",
                           ClauseRef = "7.1.3.d",
                           Description = "information and communication technology.",
                           isActive = true
                        },
                        new IsoStandard
                        {
                            Id = 1,
                            VersionID = 1,
                            Particulars = "The organization shall determine, provide and maintain the environment necessary for the operation of its processes and to achieve conformity of products and services. " +
                            "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise)." +
                            "NOTE A suitable environment can be a combination of human and physical factors, such as:",
                            ClauseRef = "7.1.4",
                            Description = "Environment for the operation of processes",
                            isActive = true
                         },
                         new IsoStandard
                         {
                             Id = 1,
                             VersionID = 1,
                             Particulars = "",
                             ClauseRef = "7.1.4.a",
                             Description = " social (e.g. non-discriminatory, calm, non-confrontational);",
                             isActive = true
                          },
                          new IsoStandard
                          {
                              Id = 1,
                              VersionID = 1,
                              Particulars = "",
                              ClauseRef = "7.1.4.b",
                              Description = " psychological (e.g. stress-reducing, burnout prevention, emotionally protective);",
                              isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.4.c",
                               Description = "physical (e.g. temperature, heat, humidity, light, airflow, hygiene, noise).",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5",
                               Description = "Monitoring and measuring resources",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization shall determine and provide the resources needed to ensure valid and reliable results when monitoring or measuring " +
                               "is used to verify the conformity of products and services to requirements. " +
                               "The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources." +
                               "The organization shall retain appropriate documented information as evidence of fitness for purpose of the monitoring and measurement resources.",
                               ClauseRef = "7.1.5.1",
                               Description = "General",
                               isActive = true
                           }
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5.1.a",
                               Description = "are suitable for the specific type of monitoring and measurement activities being undertaken;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5.1.b",
                               Description = "are maintained to ensure their continuing fitness for their purpose.",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization shall determine if the validity of previous measurement results has been adversely " +
                               "affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary. " +
                               "The organization shall determine if the validity of previous measurement results has been adversely affected when measuring equipment is found to be unfit for its intended purpose, and shall take appropriate action as necessary.",
                               ClauseRef = "7.1.5.2",
                               Description = "Measurement traceability",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5.2.a",
                               Description = "calibrated or verified, or both, at specified intervals, or prior to use, against measurement standards traceable to international or national measurement standards; " +
                               "when no such standards exist, the basis used for calibration or verification shall be retained as documented information;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5.2.b",
                               Description = "identified in order to determine their status;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.5.2.c",
                               Description = "safeguarded from adjustments, damage or deterioration that would invalidate the calibration status and subsequent measurement results.",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization shall determine the knowledge necessary for the operation of its processes and to achieve conformity of products and services. " +
                               "This knowledge shall be maintained and be made available to the extent necessary. " +
                               "When addressing changing needs and trends, the organization shall consider its current knowledge " +
                               "and determine how to acquire or access any necessary additional knowledge and required updates.",
                               ClauseRef = "7.1.6",
                               Description = "Organizational knowledge",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.6.Note 1",
                               Description = "Organizational knowledge is knowledge specific to the organization; " +
                               "it is generally gained by experience. It is information that is used and shared to achieve the organization’s objectives.",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, " +
                               "or the reassignment of currently employed persons; or the hiring or contracting of competent persons.",
                               ClauseRef = "7.1.6.Note 2",
                               Description = "Organizational knowledge can be based on:",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.6.a",
                               Description = " internal sources (e.g. intellectual property; knowledge gained from experience; lessons learned from failures and successful projects; " +
                               "capturing and sharing undocumented knowledge and experience; the results of improvements in processes, products and services);",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.1.6.b",
                               Description = "external sources (e.g. standards; academia; conferences; gathering knowledge from customers or external providers).",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.2",
                               Description = "Competence",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization shall:",
                               ClauseRef = "7.2",
                               Description = "Competence",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.2.a",
                               Description = "determine the necessary competence of person(s) doing work under its control " +
                               "that affects the performance and effectiveness of the quality management system;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.2.b",
                               Description = "ensure that these persons are competent on the basis of appropriate education, training, or experience;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.2.c",
                               Description = "where applicable, take actions to acquire the necessary competence, and evaluate the effectiveness of the actions taken;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.2.d",
                               Description = "retain appropriate documented information as evidence of competence.",
                               isActive = true
                           },

            );
        }
    }
}
