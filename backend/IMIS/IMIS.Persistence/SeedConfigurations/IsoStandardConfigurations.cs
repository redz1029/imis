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
                           },
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
                               Particulars = "NOTE Applicable actions can include, for example, the provision of training to, the mentoring of, " +
                               "or the reassignment of currently employed persons; or the hiring or contracting of competent persons.The organization shall:",
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
                               Particulars = "The organization shall ensure that persons doing work under the organization’s control are aware of:",
                               ClauseRef = "7.3",
                               Description = "Awareness",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.3.a",
                               Description = "the quality policy;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.3.b",
                               Description = "relevant quality objectives;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.3.c",
                               Description = "their contribution to the effectiveness of the quality management system, including the benefits of improved performance;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.3.d",
                               Description = "the implications of not conforming with the quality management system requirements.",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization shall determine the internal and external communications relevant to the quality management system, including:",
                               ClauseRef = "7.4",
                               Description = "Communication",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.4.a",
                               Description = "on what it will communicate;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.4.b",
                               Description = "when to communicate;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.4.c",
                               Description = "with whom to communicate;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.4.d",
                               Description = "how to communicate;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.4.e",
                               Description = "who communicates.",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.5",
                               Description = "Documented information",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "The organization’s quality management system shall include:",
                               ClauseRef = "7.5.1",
                               Description = "General",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.5.1.a",
                               Description = "documented information required by this International Standard;",
                               isActive = true
                           },
                           new IsoStandard
                           {
                               Id = 1,
                               VersionID = 1,
                               Particulars = "",
                               ClauseRef = "7.5..1b",
                               Description = "documented information determined by the organization as being necessary for the effectiveness of the quality management system.",
                               isActive = true
                           },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "When creating and updating documented information, the organization shall ensure appropriate:",
                                ClauseRef = "7.5.2",
                                Description = "Creating and updating",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "When creating and updating documented information, the organization shall ensure appropriate:",
                                ClauseRef = "7.5.2",
                                Description = "Creating and updating",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.2.a",
                                Description = "identification and description (e.g. a title, date, author, or reference number);",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.2.b",
                                Description = "format (e.g. language, software version, graphics) and media (e.g. paper, electronic);",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.2.c",
                                Description = "review and approval for suitability and adequacy.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.2.c",
                                Description = "review and approval for suitability and adequacy.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3",
                                Description = "Control of documented information",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.1",
                                Description = "Documented information required by the quality management system and by this International Standard shall be controlled to ensure:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.1.a",
                                Description = "it is available and suitable for use, where and when it is needed;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.1.b",
                                Description = "it is adequately protected (e.g. from loss of confidentiality, improper use, or loss of integrity).",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "Documented information of external origin determined by the organization to be necessary for the planning and operation of the quality management system shall be identified as appropriate, and be controlled. " +
                                "Documented information retained as evidence of conformity shall be protected from unintended alterations.",
                                ClauseRef = "7.5.3.2",
                                Description = "For the control of documented information, the organization shall address the following activities, as applicable:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.2.a",
                                Description = "distribution, access, retrieval and use;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.2.b",
                                Description = "storage and preservation, including preservation of legibility;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.2.c",
                                Description = "control of changes (e.g. version control);",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "7.5.3.2.d",
                                Description = "retention and disposition.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8",
                                Description = "Operation",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall plan, implement and control the processes (see 4.4) needed to meet the requirements for the " +
                                "provision of products and services, and to implement the actions determined in Clause 6, by:The output of this planning shall be suitable for the organization’s operations. " +
                                "The organization shall control planned changes and review the consequences of unintended changes, taking action to mitigate any adverse effects, as necessary. " +
                                "The organization shall ensure that outsourced processes are controlled (see 8.4).",
                                ClauseRef = "8.1",
                                Description = "Operational planning and control",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.a",
                                Description = "determining the requirements for the products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.b",
                                Description = "establishing criteria for:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.b.1",
                                Description = "the processes;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.b.2",
                                Description = "the acceptance of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.c",
                                Description = "determining the resources needed to achieve conformity to the product and service requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.d",
                                Description = "implementing control of the processes in accordance with the criteria;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.e",
                                Description = "determining, maintaining and retaining documented information to the extent necessary:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.e.1",
                                Description = "to have confidence that the processes have been carried out as planned;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.1.e.2",
                                Description = "to demonstrate the conformity of products and services to their requirements.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2",
                                Description = "Requirements for products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "Communication with customers shall include:",
                                ClauseRef = "8.2.1",
                                Description = "Customer communication",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.1.a",
                                Description = "providing information relating to products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.1.b",
                                Description = "handling enquiries, contracts or orders, including changes;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.1.c",
                                Description = "obtaining customer feedback relating to products and services, including customer complaints;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.1.d",
                                Description = "handling or controlling customer property;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.1.e",
                                Description = "establishing specific requirements for contingency actions, when relevant.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:",
                                ClauseRef = "8.2.2",
                                Description = "Determining the requirements for products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "When determining the requirements for the products and services to be offered to customers, the organization shall ensure that:",
                                ClauseRef = "8.2.2",
                                Description = "Determining the requirements for products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.2.a",
                                Description = "the requirements for the products and services are defined, including:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.2.a.1",
                                Description = "any applicable statutory and regulatory requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.2.a.2",
                                Description = "those considered necessary by the organization;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.2.b",
                                Description = "the organization can meet the claims for the products and services it offers.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3",
                                Description = "Review of the requirements for products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure that contract or order requirements differing from those previously defined are resolved." +
                                " The customer’s requirements shall be confirmed by the organization before acceptance, " +
                                "when the customer does not provide a documented statement of their requirements.",
                                ClauseRef = "8.2.3.1",
                                Description = "The organization shall ensure that it has the ability to meet the requirements for products and services to be offered to customers. " +
                                "The organization shall conduct a review before committing to supply products and services to a customer, to include:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.1.a",
                                Description = "requirements specified by the customer, including the requirements for delivery and postdelivery activities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.1.b",
                                Description = "requirements not stated by the customer, but necessary for the specified or intended use, when known;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.1.c",
                                Description = "requirements specified by the organization;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.1.d",
                                Description = "statutory and regulatory requirements applicable to the products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.1.e",
                                Description = "contract or order requirements differing from those previously expressed.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.2",
                                Description = "The organization shall retain documented information, as applicable:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.2.a",
                                Description = "on the results of the review;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.2.3.2.b",
                                Description = "on any new requirements for the products and services.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure that relevant documented information is amended, " +
                                "and that relevant persons are made aware of the changed requirements, when the requirements for products and services are changed.",
                                ClauseRef = "8.2.4",
                                Description = "Changes to requirements for products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3",
                                Description = "Design and development of products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall establish, implement and maintain a design and development " +
                                "process that is appropriate to ensure the subsequent provision of products and services.",
                                ClauseRef = "8.3.1",
                                Description = "General",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "In determining the stages and controls for design and development, the organization shall consider:",
                                ClauseRef = "8.3.2",
                                Description = "Design and development of products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.a",
                                Description = "the nature, duration and complexity of the design and development activities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.b",
                                Description = "the required process stages, including applicable design and development reviews;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.c",
                                Description = "the required design and development verification and validation activities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.d",
                                Description = "the responsibilities and authorities involved in the design and development process;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.e",
                                Description = "the internal and external resource needs for the design and development of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.f",
                                Description = "the need to control interfaces between persons involved in the design and development process;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.g",
                                Description = "the need for involvement of customers and users in the design and development process;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.h",
                                Description = "the requirements for subsequent provision of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.i",
                                Description = "the level of control expected for the design and development process by customers and other relevant interested parties;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.2.j",
                                Description = "the documented information needed to demonstrate that design and development requirements have been met.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall determine the requirements essential for the specific types of products and services to be designed and developed. " +
                                "The organization shall consider:" +
                                "Inputs shall be adequate for design and development purposes, complete and unambiguous. " +
                                "Conflicting design and development inputs shall be resolved. " +
                                "The organization shall retain documented information on design and development inputs.",
                                ClauseRef = "8.3.3",
                                Description = "Design and development inputs",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.3.a",
                                Description = "functional and performance requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.3.b",
                                Description = "information derived from previous similar design and development activities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.3.c",
                                Description = "statutory and regulatory requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.3.d",
                                Description = "standards or codes of practice that the organization has committed to implement;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.3.e",
                                Description = "potential consequences of failure due to the nature of the products and services.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall apply controls to the design and development process to ensure that:",
                                ClauseRef = "8.3.4",
                                Description = "Design and development controls",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.4.a",
                                Description = "the results to be achieved are defined;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.4.b",
                                Description = "reviews are conducted to evaluate the ability of the results of design and development to meet requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.4.c",
                                Description = "verification activities are conducted to ensure that the design and development outputs meet the input requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.4.e",
                                Description = "any necessary actions are taken on problems determined during the reviews, or verification and validation activities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.4.f",
                                Description = "documented information of these activities is retained.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall retain documented information on design and development outputs. " +
                                "The organization shall ensure that design and development outputs:",
                                ClauseRef = "8.3.5",
                                Description = "documented information of these activities is retained.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.5.a",
                                Description = "meet the input requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.5.b",
                                Description = "are adequate for the subsequent processes for the provision of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.5.c",
                                Description = "include or reference monitoring and measuring requirements, as appropriate, and acceptance criteria;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.5.d",
                                Description = "specify the characteristics of the products and services that are essential for their intended purpose and their safe and proper provision.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall identify, review and control changes made during, or subsequent to, the design and development of products and services, " +
                                "to the extent necessary to ensure that there is no adverse impact on conformity to requirements. The organization shall retain documented information on:",
                                ClauseRef = "8.3.6",
                                Description = "Design and development changes",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.6.a",
                                Description = "design and development changes;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.6.b",
                                Description = "the results of reviews;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.6.c",
                                Description = "the authorization of the changes;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.3.6.d",
                                Description = "the actions taken to prevent adverse impacts.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4",
                                Description = "Control of externally provided processes, products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure that externally provided processes, products and services conform to requirements." +
                                "The organization shall determine and apply criteria for the evaluation, selection, monitoring of performance, and re-evaluation of external providers, " +
                                "based on their ability to provide processes or products and services in accordance with requirements. " +
                                "The organization shall retain documented information of these activities and any necessary actions arising from the evaluations.",
                                ClauseRef = "8.4.1",
                                Description = "General",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.1.a",
                                Description = "products and services from external providers are intended for incorporation into the organization’s own products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.1.b",
                                Description = "products and services are provided directly to the customer(s) by external providers on behalf of the organization;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.1.c",
                                Description = "a process, or part of a process, is provided by an external provider as a result of a decision by the organization.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure that externally provided processes, " +
                                "products and services do not adversely affect the organization’s ability to consistently deliver conforming products and services to its customers.",
                                ClauseRef = "8.4.2",
                                Description = "Type and extent of control",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars ="",
                                ClauseRef = "8.4.2.a",
                                Description = "ensure that externally provided processes remain within the control of its quality management system;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.2.b",
                                Description = "define both the controls that it intends to apply to an external provider and those it intends to apply to the resulting output;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.2.c",
                                Description = "take into consideration:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.2.c.1",
                                Description = "the potential impact of the externally provided processes, " +
                                "products and services on the organization’s ability to consistently meet customer and applicable statutory and regulatory requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.2.c.2",
                                Description = "the effectiveness of the controls applied by the external provider;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.2.d",
                                Description = "determine the verification, or other activities, necessary to ensure that the externally provided processes, products and services meet requirements.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure the adequacy of requirements prior to their communication to the external provider.",
                                ClauseRef = "8.4.3",
                                Description = "Information for external providers",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.a",
                                Description = "the processes, products and services to be provided",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.b",
                                Description = "tthe approval of:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.b.1",
                                Description = "products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.b.2",
                                Description = "methods, processes and equipment;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.b.3",
                                Description = "the release of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.c",
                                Description = "competence, including any required qualification of persons;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.d",
                                Description = "the external providers’ interactions with the organization;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.e",
                                Description = "control and monitoring of the external providers’ performance to be applied by the organization;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.4.3.f",
                                Description = "verification or validation activities that the organization, or its customer, intends to perform at the external providers’ premises.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5",
                                Description = "Production and service provision",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall implement production and service provision under controlled conditions. " +
                                "Controlled conditions shall include, as applicable:",
                                ClauseRef = "8.5.1",
                                Description = "Control of production and service provision",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.a",
                                Description = "the availability of documented information that defines:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.a.1",
                                Description = "the characteristics of the products to be produced, the services to be provided, or the activities to be performed;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.a.2",
                                Description = "the results to be achieved;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.b",
                                Description = "the availability and use of suitable monitoring and measuring resources;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.c",
                                Description = "the implementation of monitoring and measurement activities at appropriate stages to verify that criteria for control of processes or outputs, " +
                                "and acceptance criteria for products and services, have been met;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.d",
                                Description = "the use of suitable infrastructure and environment for the operation of processes;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.e",
                                Description = "the appointment of competent persons, including any required qualification;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.f",
                                Description = "the validation, and periodic revalidation, of the ability to achieve planned results of the processes for production and service provision, " +
                                "where the resulting output cannot be verified by subsequent monitoring or measurement;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.g",
                                Description = "the implementation of actions to prevent human error;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.1.h",
                                Description = "the implementation of release, delivery and post-delivery activities.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall use suitable means to identify outputs when it is necessary to ensure the conformity of products and services. " +
                                "The organization shall identify the status of outputs with respect to monitoring and measurement requirements throughout production and service provision. " +
                                "The organization shall control the unique identification of the outputs when traceability is a requirement, " +
                                "and shall retain the documented information necessary to enable traceability.",
                                ClauseRef = "8.5.2",
                                Description = "Identification and traceability",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall exercise care with property belonging to customers or external providers while it is under the organization’s control or being used by the organization. " +
                                "The organization shall identify, verify, " +
                                "protect and safeguard customers’ or external providers’ property provided for use or incorporation into the products and services. " +
                                "When the property of a customer or external provider is lost, damaged or otherwise found to be unsuitable for use," +
                                " the organization shall report this to the customer or external provider and retain documented information on what has occurred.",
                                ClauseRef = "8.5.3",
                                Description = "the implementation of release, delivProperty belonging to customers or external providersery and post-delivery activities.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall preserve the outputs during production and service provision, " +
                                "to the extent necessary to ensure conformity to requirements.",
                                ClauseRef = "8.5.4",
                                Description = "Preservation",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall meet requirements for post-delivery activities associated with the products and services." +
                                "In determining the extent of post-delivery activities that are required, the organization shall consider:",
                                ClauseRef = "8.5.5",
                                Description = "Post-delivery activities",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.5.a",
                                Description = "statutory and regulatory requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.5.b",
                                Description = "the potential undesired consequences associated with its products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.5.c",
                                Description = "the nature, use and intended lifetime of its products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.5.d",
                                Description = "customer requirements;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.5.e",
                                Description = "customer feedback.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.5.6",
                                Description = "Control of changes",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall review and control changes for production or service provision, to the extent necessary to ensure continuing conformity with requirements. " +
                                "The organization shall retain documented information describing the results of the review of changes, the person(s) authorizing the change, and any necessary actions arising from the review.",
                                ClauseRef = "8.5.6",
                                Description = "Control of changes",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall implement planned arrangements, at appropriate stages, to verify that the product and service requirements have been met." +
                                "The release of products and services to the customer shall not proceed until the planned arrangements have been satisfactorily completed, unless otherwise approved by a relevant authority and, as applicable, by the customer.",
                                ClauseRef = "8.6",
                                Description = "Release of products and services",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall implement planned arrangements, at appropriate stages, to verify that the product and service requirements have been met." +
                                "The release of products and services to the customer shall not proceed until the planned " +
                                "arrangements have been satisfactorily completed, unless otherwise approved by a relevant authority and, as applicable, by the customer." +
                                "The organization shall retain documented information on the release of products and services. The documented information shall include:",
                                ClauseRef = "8.6",
                                Description = "Release of products and services",
                                isActive = true
             
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.6.a",
                                Description = "evidence of conformity with the acceptance criteria;",
                                isActive = true

                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.6.b",
                                Description = "traceability to the person(s) authorizing the release.",
                                isActive = true

                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7",
                                Description = "Control of nonconforming outputs",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall ensure that outputs that do not conform to their requirements are identified and controlled to prevent their unintended use or delivery. " +
                                "The organization shall take appropriate action based on the nature of the nonconformity and its effect on the conformity of products and services. " +
                                "This shall also apply to nonconforming products and services detected after delivery of products, during or after the provision of services. " +
                                "Conformity to the requirements shall be verified when nonconforming outputs are corrected." +
                                "The organization shall deal with nonconforming outputs in one or more of the following ways:",
                                ClauseRef = "8.7.1",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.1.a",
                                Description = "Correction;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.1.b",
                                Description = "segregation, containment, return or suspension of provision of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.1.c",
                                Description = "informing the customer;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.1.d",
                                Description = "obtaining authorization for acceptance under concession.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall retain documented information that:",
                                ClauseRef = "8.7.2",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.2.a",
                                Description = "describes the nonconformity;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.2.b",
                                Description = "describes the actions taken;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.2.c",
                                Description = "describes any concessions obtained;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "8.7.2.d",
                                Description = "identifies the authority deciding the action in respect of the nonconformity.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9",
                                Description = "Performance evaluation",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1",
                                Description = "Monitoring, measurement, analysis and evaluation",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall evaluate the performance and the effectiveness of the quality management system. " +
                                "The organization shall retain appropriate documented information as evidence of the results.The organization shall determine:",
                                ClauseRef = "9.1.1",
                                Description = "General",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.1.a",
                                Description = "what needs to be monitored and measured;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.1.b",
                                Description = "the methods for monitoring, measurement, analysis and evaluation needed to ensure valid results;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.1.c",
                                Description = "when the monitoring and measuring shall be performed;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.1.d",
                                Description = "when the results from monitoring and measurement shall be analysed and evaluated.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.2",
                                Description = "The organization shall monitor customers’ perceptions of the degree to which their needs and expectations have been fulfilled. " +
                                "The organization shall determine the methods for obtaining, monitoring and reviewing this information.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall analyse and evaluate appropriate data and information arising from monitoring and measurement. " +
                                "The results of analysis shall be used to evaluate:",
                                ClauseRef = "9.1.3",
                                Description = "Analysis and evaluation",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.a",
                                Description = "conformity of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.b",
                                Description = "the degree of customer satisfaction;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.c",
                                Description = "the performance and effectiveness of the quality management system;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.d",
                                Description = "if planning has been implemented effectively;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.e",
                                Description = "the effectiveness of actions taken to address risks and opportunities;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.f",
                                Description = "the performance of external providers;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.1.3.g",
                                Description = "the need for improvements to the quality management system.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2",
                                Description = "Internal audit",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall conduct internal audits at planned intervals to provide information on whether the quality management system:",
                                ClauseRef = "9.2.1",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.1.a",
                                Description = "conforms to:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.1.a.1",
                                Description = "the organization’s own requirements for its quality management system;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.1.a.2",
                                Description = "the requirements of this International Standard;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.1.b",
                                Description = "is effectively implemented and maintained.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall:",
                                ClauseRef = "9.2.2",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.a",
                                Description = "plan, establish, implement and maintain an audit programme(s) including the frequency, methods, responsibilities, planning requirements and reporting, " +
                                "which shall take into consideration the importance of the processes concerned, changes affecting the organization, and the results of previous audits;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.b",
                                Description = "define the audit criteria and scope for each audit;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.c",
                                Description = "select auditors and conduct audits to ensure objectivity and the impartiality of the audit process;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.d",
                                Description = "ensure that the results of the audits are reported to relevant management;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.e",
                                Description = "take appropriate correction and corrective actions without undue delay;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.2.2.f",
                                Description = "retain documented information as evidence of the implementation of the audit programme and the audit results.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3",
                                Description = "Management review",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "Top management shall review the organization’s quality management system, " +
                                "at planned intervals, to ensure its continuing suitability, adequacy," +
                                " effectiveness and alignment with the strategic direction of the organization.",
                                ClauseRef = "9.3.1",
                                Description = "General",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The management review shall be planned and carried out taking into consideration:",
                                ClauseRef = "9.3.2",
                                Description = "Management review inputs",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.a",
                                Description = "the status of actions from previous management reviews;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.b",
                                Description = "changes in external and internal issues that are relevant to the quality management system;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c",
                                Description = "information on the performance and effectiveness of the quality management system, including trends in:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.1",
                                Description = "customer satisfaction and feedback from relevant interested parties;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.2",
                                Description = "the extent to which quality objectives have been met;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.3",
                                Description = "process performance and conformity of products and services;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.4",
                                Description = "nonconformities and corrective actions;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.5",
                                Description = "monitoring and measurement results;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.6",
                                Description = "audit results;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.c.7",
                                Description = "the performance of external providers",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.d",
                                Description = "the adequacy of resources;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.e",
                                Description = "the effectiveness of actions taken to address risks and opportunities (see 6.1);",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.2.f",
                                Description = "opportunities for improvement",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall retain documented information as evidence of the results of management reviews. " +
                                "The outputs of the management review shall include decisions and actions related to:",
                                ClauseRef = "9.3.3",
                                Description = "Management review outputs",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.3.a",
                                Description = "opportunities for improvement; ",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.3.b",
                                Description = "any need for changes to the quality management system; ",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "9.3.3.c",
                                Description = "resource needs. ",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10",
                                Description = "Improvement ",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall determine and select opportunities for improvement and " +
                                "implement any necessary actions to meet customer requirements and enhance customer satisfaction. These shall include:",
                                ClauseRef = "10.1",
                                Description = "General",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.1.1.a",
                                Description = "improving products and services to meet requirements as well as to address future needs and expectations;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.1.1.b",
                                Description = "correcting, preventing or reducing undesired effects;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.1.1.c",
                                Description = "improving the performance and effectiveness of the quality management system.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2",
                                Description = " Nonconformity and corrective action",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "Corrective actions shall be appropriate to the effects of the nonconformities encountered. " +
                                "hen a nonconformity occurs, including any arising from complaints, the organization shall:",
                                ClauseRef = "10.2.1",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.a",
                                Description = "react to the nonconformity and, as applicable:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.a.1",
                                Description = "take action control and correct it;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.a.2",
                                Description = "deal with the consequences;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.b",
                                Description = "evaluate the need for action to eliminate the cause(s) of the nonconformity, in order that it does not recur or occur elsewhere, by:",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.b.1",
                                Description = "reviewing and analysing the nonconformity;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.b.2",
                                Description = "determining the causes of the nonconformity;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.b.3",
                                Description = "determining if similar nonconformities exist, or could potentially occur;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.c",
                                Description = "implement any action needed;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.d",
                                Description = "review the effectiveness of any corrective action taken;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.e",
                                Description = "update risks and opportunities determined during planning, if necessary;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.1.f",
                                Description = "make changes to the quality management system, if necessary.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall retain documented information as evidence of:",
                                ClauseRef = "10.2.2",
                                Description = "",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.2.a",
                                Description = "the nature of the nonconformities and any subsequent actions taken;",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "",
                                ClauseRef = "10.2.2.b",
                                Description = "the results of any corrective action.",
                                isActive = true
                            },
                            new IsoStandard
                            {
                                Id = 1,
                                VersionID = 1,
                                Particulars = "The organization shall continually improve the suitability, adequacy and effectiveness of the quality management system." +
                                "The organization shall consider the results of analysis and evaluation, and the outputs from management review, to determine if there are needs or opportunities that shall be addressed as part of continual improvement.",
                                ClauseRef = "10.3",
                                Description = "Continual improvement",
                                isActive = true
                            }
                            

            );

        }
    }
}
