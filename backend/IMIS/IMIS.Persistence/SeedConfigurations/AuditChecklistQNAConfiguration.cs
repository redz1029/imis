using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class AuditChecklistQNAConfiguration : IEntityTypeConfiguration<AuditChecklistQNA>
    {
        public void Configure(EntityTypeBuilder<AuditChecklistQNA> builder)
        {
            builder.HasData(
                new AuditChecklistQNA
                {
                    Id = 1,
                    Question = "Can you please explain how the organization identifies relevant internal andexternal issues?",
                    IsoStandardId =2,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 2,
                    Question = "How often do you review and update these issues? Can you provide examples of recent changes?",
                    IsoStandardId = 2,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 3,
                    Question = "How does the organization go about identifying relevant interested parties?",
                    IsoStandardId = 3,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 4,
                    Question = "Can you describe the process of determining the requirements and expectations of these interested parties?",
                    IsoStandardId = 3,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 5,
                    Question = "How often do you review and update the requirements and expectations of interested parties? Can you share any recent updates or changes?",
                    IsoStandardId = 3,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 6,
                    Question = "Can you walk me through how the organization defined the scope of its QMS?",
                    IsoStandardId = 6,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 7,
                    Question = "How did you ensure that the scope includes all relevant products, services, and processes covered by the QMS?",
                    IsoStandardId = 6,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 8,
                    Question = "How were the organization’s context and the requirements of interested parties considered while determining the scope?",
                    IsoStandardId = 6,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 9,
                    Question = "Is the scope documented and easily accessible to relevant personnel? Can you show me where it is available?",
                    IsoStandardId = 6,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 10,
                    Question = "How has the organization established, implemented, maintained, and continually improved its QMS?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 11,
                    Question = "Can you explain how the QMS processes are identified and their interactions determined?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 12,
                    Question = "How do you document process inputs, outputs, sequences, and interactions?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 13,
                    Question = "How were responsibilities and authorities assigned to personnel for QMS processes?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 14,
                    Question = "Can you provide examples of how process performance criteria, resources, and risks are identified and managed?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 15,
                    Question = "How does the organization establish methods for monitoring, measuring, and controlling QMS processes?",
                    IsoStandardId = 13,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 16,
                    Question = "Can you share any recent evaluations of QMS processes and improvements made as a result?",
                    IsoStandardId = 13 ,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 17,
                    Question = "Can you provide examples of how top management demonstrates leadership and commitment to the QMS??",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 18,
                    Question = "How does top management ensure that quality policy and objectives are established and compatible with the organization’s strategic direction?",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 19,
                    Question = "Can you explain how top management ensures the integration of the QMS into the organization’s processes?",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 20,
                    Question = "How does top management promote the use of a process approach and risk-based thinking within the organization?",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 21,
                    Question = "How does top management ensure that customer requirements are understood and met?",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 22,
                    Question = "Can you share any examples of how top management emphasizes the importance of enhancing customer satisfaction?",
                    IsoStandardId = 27,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 23,
                    Question = "Can you explain how the quality policy was established, documented, and communicated within the organization?",
                    IsoStandardId = 43,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 24,
                    Question = "How does the quality policy align with the organization’s purpose and context?",
                    IsoStandardId = 43,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 25,
                    Question = "Can you provide examples of how the quality policy supports the organization’s strategic direction and provide sa framework for setting quality objectives?",
                    IsoStandardId = 43,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 26,
                    Question = "How do you ensure the quality policy is available to relevant interested parties?",
                    IsoStandardId = 43,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 27,
                    Question = "Can you provide examples of how top management ensures the quality policy is understood, implemented, and maintained at all levels of the organization?",
                    IsoStandardId = 43,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 28,
                    Question = "Can you explain how roles, responsibilities, andauthorities have been assigned, communicated, and understood within the organization?",
                    IsoStandardId = 53,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 29,
                    Question = "How does top management ensure the QMS conforms to the ISO 9001 requirements?",
                    IsoStandardId = 53,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 30,
                    Question = "Can you provide examples of how top management ensures processes deliver intended outputs?",
                    IsoStandardId = 53,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 31,
                    Question = "How do top management review and report on QMS performance, resource needs, and opportunities for improvement?",
                    IsoStandardId = 53,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 32,
                    Question = "How does the organization identify risks and opportunities associated with the QMS?",
                    IsoStandardId = 59,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 33,
                    Question = "Can you explain the process for assessing and prioritizing these risks and opportunities?",
                    IsoStandardId = 59,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 34,
                    Question = "How does the organization determine appropriate actions to address identified risks and opportunities?",
                    IsoStandardId = 59,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 35,
                    Question = "Can you provide examples of recent actions taken to address risks and opportunities?",
                    IsoStandardId = 59,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 36,
                    Question = "Can you explain how the organization sets and documents quality objectives?",
                    IsoStandardId = 71,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 37,
                    Question = "How do you ensure the quality objectives are specific, measurable, achievable, relevant,and time-bound (SMART)?",
                    IsoStandardId = 71,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 38,
                    Question = "Can you describe the process for determining the necessary resources and actions to achieve the quality objectives?",
                    IsoStandardId = 71,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 39,
                    Question = "How does the organization evaluate progress toward meeting the quality objectives?",
                    IsoStandardId = 71,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 40,
                    Question = "Can you explain the process for planning and implementing changes to the QMS?",
                    IsoStandardId = 86,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 41,
                    Question = "How does the organization ensure that the purpose and potential consequences of changes are considered before implementation?",
                    IsoStandardId = 86,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 42,
                    Question = "Can you provide examples of recent changes made to the QMS and the planning process followed?",
                    IsoStandardId = 86,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 43,
                    Question = "How does the organization determine and provide the necessary resources for the QMS?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 44,
                    Question = "Can you share examples of how the organization ensures that resources are available, maintained, and monitored for effectiveness??",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 45,
                    Question = "How does the organization ensure that it has the required personnel to effectively implement the QMS and maintain its processes??",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 46,
                    Question = "Can you provide examples of how the organization manages personnel resources to meet its quality objectives?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 47,
                    Question = "How does the organization identify and provide the necessary infrastructure for the QMS?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 48,
                    Question = "Can you provide examples of how the organization maintains and improves its infrastructure to support its processes and achieve its quality objectives?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 49,
                    Question = "How does the organization determine and manage the work environment needed for its processes?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 50,
                    Question = "Can you share examples of how the organization ensures that the work environment supports the achievement of its quality objectives?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 51,
                    Question = "How does the organization identify and provide the necessary monitoring and measuring resources to ensure valid results?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 52,
                    Question = "Can you provide examples of how the organization ensures that monitoring and measuring resources are calibrated and maintained?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 53,
                    Question = "How does the organization identify, maintain, andmanage the necessary organizational knowledge for its processes?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 54,
                    Question = "Can you share examples of how the organization acquires and shares new knowledge within the organization?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 55,
                    Question = "How does the organization determine the necessary competence for personnel affecting the QMS performance??",
                    IsoStandardId = 119,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 56,
                    Question = "Can you explain how the organization ensures that personnel are competent and, if necessary, provide training or other actions to acquire the required competence?",
                    IsoStandardId = 119,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 57,
                     Question = "How does the organization identify and provide the necessary monitoring and measuring resources to ensure valid results?",
                     IsoStandardId = 92,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 58,
                    Question = "Can you provide examples of how the organization ensures that monitoring and measuring resources are calibrated and maintained?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 59,
                    Question = "How does the organization identify, maintain, andmanage the necessary organizational knowledge for its processes?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 60,
                    Question = "Can you share examples of how the organization acquires and shares new knowledge within the organization?",
                    IsoStandardId = 92,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 61,
                    Question = "How does the organization determine the necessary competence for personnel affecting the QMS performance??",
                    IsoStandardId = 119,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 62,
                    Question = "Can you explain how the organization ensures that personnel are competent and, if necessary, provide training or other actions to acquire the required competence?",
                    IsoStandardId = 119,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 63,
                     Question = "How does the organization evaluate the effectiveness of the actions taken to address competence requirements?",
                     IsoStandardId = 119,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 64,
                    Question = "How does the organization ensure that personnel are aware of the quality policy, quality objectives, and their contribution to the QMS?",
                    IsoStandardId = 123,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 65,
                    Question = "Can you provide examples of how the organization promotes awareness of the importance of conforming to QMS requirements and enhancing customer satisfaction??",
                    IsoStandardId = 123,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 66,
                    Question = "How does the organization determine and implement internal and external communication relevant to the QMS?",
                    IsoStandardId = 128,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 67,
                    Question = "Can you explain how the organization ensures the effectiveness of its communication processes?",
                    IsoStandardId = 128,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 68,
                    Question = "How does the organization create, update, and control documented information required by the QMS?",
                    IsoStandardId = 134,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 69,
                     Question = "Can you provide examples of how the organization ensures the availability and suitability of documented information?",
                     IsoStandardId = 134,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 70,
                    Question = "How does the organization ensure that documented information is properly identified, described, reviewed, and approved before use?",
                    IsoStandardId = 134,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 71,
                    Question = "Can you provide examples of recent updates to documented information and the process followed?",
                    IsoStandardId = 134,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 72,
                    Question = "Can you explain how the organization controls access, distribution, and retrieval of documented information?",
                    IsoStandardId = 134,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 73,
                    Question = "How does the organization ensure the proper storage, preservation, and disposal of documented information?",
                    IsoStandardId = 134,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 74,
                    Question = "How does the organization plan, implement, and control its processes to meet requirements and enhance customer satisfaction?",
                    IsoStandardId = 152,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 75,
                     Question = "Can you provide examples of how the organization ensures effective control over out sourced processes?",
                     IsoStandardId = 152,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 76,
                    Question = "How does the organization communicate with customers regarding product and service information, inquiries, contracts, and handling customer feedback?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 77,
                    Question = "Can you share examples of effective customer communication processes?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 78,
                    Question = "Can you share examples of how the organization acquires and shares new knowledge within the organization?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 79,
                    Question = "How does the organization determine and review the requirements for its products and services?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 80,
                    Question = "Can you provide examples of how the organization ensures that it can meet the requirements for products and services before committing to customers?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 81,
                     Question = "Can you explain the process for reviewing and confirming customer requirements before accepting an order?",
                     IsoStandardId = 162,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 82,
                    Question = "How does the organization handle changes in requirements and communicate them internally?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 83,
                    Question = "How does the organization manage changes to requirements for products and services?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 84,
                    Question = "Can you provide examples of recent changes to requirements and the process followed to ensure proper implementation?",
                    IsoStandardId = 162,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 85,
                    Question = "How does the organization plan and control the design and development process for its products and services?",
                    IsoStandardId = 186,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 86,
                    Question = "Can you provide examples of design and development activities, including inputs, controls, outputs, and validation?",
                    IsoStandardId = 186,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 87,
                     Question = "How does the organization ensure that externally provided processes, products, and services conform to its requirements?",
                     IsoStandardId = 222,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 88,
                    Question = "Can you provide examples of how the organization evaluates, selects, and monitors external providers and their performance?",
                    IsoStandardId = 222,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 89,
                    Question = "Are production and service provision processes planned and carried out under controlled conditions?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 90,
                    Question = "Are criteria for workmanship established and communicated?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 91,
                    Question = "Are suitable equipment and infrastructure available for production and service provision?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 92,
                    Question = "Are products and services identified throughout the production process?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 93,
                    Question = "Is traceability maintained, as necessary,to ensure conformity to requirements?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 94,
                    Question = "Are the status of products and services monitored throughout the production process?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 95,
                    Question = "Is customer or external provider property identified, verified, protected, and safeguarded?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 96,
                    Question = "Are necessary actions taken if the customer or external provider property is lost, damaged, or found to be unsuitable foruse?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },

                 //
                 new AuditChecklistQNA
                 {
                     Id = 97,
                     Question = "Are products and services preserved during production and service provision to maintain conformity to requirements?",
                     IsoStandardId = 244,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 98,
                    Question = "Is preservation also applied to the constituent parts of products?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 99,
                    Question = "Are post-delivery activities, such as warranty provisions, maintenance services, and disposal, determined and controlled?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 100,
                    Question = "Are post-delivery activities considered in the risk assessment process?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 101,
                     Question = "Are changes to production and service provision processes properly controlled and documented?",
                     IsoStandardId = 244,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 102,
                    Question = "Are changes reviewed, verified, and validated as appropriate?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 103,
                    Question = "Are changes approved by the responsible person before implementation?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 104,
                    Question = "Are the consequences of changes evaluated, and necessary actions taken to mitigate any potential adverse effects?",
                    IsoStandardId = 244,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 105,
                    Question = "How does the organization ensure that products and services meet the specified requirements beforere leasing them to customers?",
                    IsoStandardId = 266,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 106,
                    Question = "Can you provide examples of release criteria and the process for verifying conformity to requirements?",
                    IsoStandardId = 266,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 107,
                     Question = "How does the organization control nonconforming outputs to prevent unintended use or delivery?",
                     IsoStandardId = 269,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 108,
                    Question = "Can you provide examples of how the organization identifies, evaluates, and takes appropriate actions on nonconforming outputs?",
                    IsoStandardId = 269,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 109,
                    Question = "How does the organization determine what needs to be monitored and measured and the methods, criteria, and timing for monitoring and measurement?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 110,
                    Question = "Can you provide examples of the organization’s approach to maintaining documented information as evidence of the results?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 111,
                    Question = "How does the organization monitor and measure customer satisfaction?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 112,
                    Question = "Can you provide examples of methods used to obtain and analyze customer feedback?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 113,
                    Question = "How does the organization analyze and evaluate the data and information from its monitoring and measurement activities?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 114,
                    Question = "Can you provide examples of how the organization uses the analysis results to improve its QMS?",
                    IsoStandardId = 281,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 115,
                    Question = "Can you explain the organization’s internal audit process, including planning, conducting, reporting, and follow-upactivities?",
                    IsoStandardId = 296,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 116,
                    Question = "How does the organization ensure that internal audits are objective and impartial?",
                    IsoStandardId = 296,
                    IsDeleted = false
                },
                //
                new AuditChecklistQNA
                {
                    Id = 117,
                    Question = "How does the organization conduct management reviews to ensure the continuing suitability, adequacy, and effectiveness of the QMS?",
                    IsoStandardId = 309,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 118,
                    Question = "Can you provide examples of inputs, outputs, and actions taken as a result of management reviews?",
                    IsoStandardId = 309,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 119,
                    Question = "How does the organization identify and implement opportunities for improvement in its QMS?",
                    IsoStandardId = 330,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 120,
                    Question = "Canyouprovideexamplesofrecentimprovementsandtheprocessesusedtoidentifyand implementthem?",
                    IsoStandardId = 330,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 121,
                    Question = "How does the organization handle nonconformities and take corrective actions to prevent recurrence?",
                    IsoStandardId = 334,
                    IsDeleted = false
                },
                 new AuditChecklistQNA
                 {
                     Id = 122,
                     Question = "Can you provide examples of recent nonconformities, the root cause analysis performed, and the corrective actions taken?",
                     IsoStandardId = 334,
                     IsDeleted = false
                 },
                new AuditChecklistQNA
                {
                    Id = 123,
                    Question = "How does the organization continually improve the suitability, adequacy, and effectiveness of its QMS?",
                    IsoStandardId = 350,
                    IsDeleted = false
                },
                new AuditChecklistQNA
                {
                    Id = 124,
                    Question = "Can you provide examples of how the organization uses data and information from monitoring, measurement, analysis, and evaluation to drive continual improvement?",
                    IsoStandardId = 281,
                    IsDeleted = false
                }
                
            );
        }
    }
}