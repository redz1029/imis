using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace IMIS.Persistence.SeedConfigurations
{
    public class KeyResultAreaConfiguration : IEntityTypeConfiguration<KeyResultArea>
    {
        public void Configure(EntityTypeBuilder<KeyResultArea> builder)
        {
            builder.HasData(
            new KeyResultArea { Id = 1, Name = "SERVICE", Remarks = "It reflects how well services meet client needs and integrates the impact of efficiency, quality, and responsiveness.", StrategicObjective = "Provide advanced healthcare services.", IsDeleted = false },
            new KeyResultArea { Id = 2, Name = "RESEARCH", Remarks = "Focuses on generating new knowledge, improving practices, and supporting evidence-based decision-making. It involves conducting studies, analyzing data, and producing insights that contribute to organizational goals and innovation.", StrategicObjective = "Produce institutional research to influence policy.", IsDeleted = false },
            new KeyResultArea { Id = 3, Name = "TRAINING", Remarks = "Oversees the planning and delivery of training programs to enhance employee skills, address learning needs, and support continuous professional growth.", StrategicObjective = "Enhanced competencies of health providers to deliver specialized care.", IsDeleted = false },
            new KeyResultArea { Id = 4, Name = "LINKAGES", Remarks = "Focuses on building and strengthening partnerships with external organizations, stakeholders, and institutions to support programs, resource sharing, and collaborative initiatives that advance organizational goals.", StrategicObjective = "Strengthen linkages to enhance healthcare accessibility.", IsDeleted = false },
            new KeyResultArea { Id = 5, Name = "INFRASTRUCTURE and EQUIPMENT", Remarks = "Ensures the availability, maintenance, and improvement of physical facilities and equipment to support efficient operations and service delivery.", StrategicObjective = "Modern and environmenta-friendly equipment hospital facilities and physical infrastructure.", IsDeleted = false },
            new KeyResultArea { Id = 6, Name = "FINANCIAL STEWARDSHIP", Remarks = "Manages budgeting, allocation, and utilization of financial resources to ensure transparency, accountability, and support for organizational goals.", StrategicObjective = "Manage funds judiciously.", IsDeleted = false },
            new KeyResultArea { Id = 7, Name = "INFORMATION CAPITAL", Remarks = "Focuses on the effective management, utilization, and protection of data, information systems, and technology to support decision-making, innovation, and operational efficiency.", StrategicObjective = "Utilize technlogy to enhance delivery and monitoring of healthcare services.", IsDeleted = false },
            new KeyResultArea { Id = 8, Name = "HUMAN RESOURCE", Remarks = "Involves developing, managing, and optimizing the workforce through recruitment, capacity building, performance management, and employee engagement to achieve organizational goals.", StrategicObjective = "Strengthen HRM system to attain highest level of PRIME-HRM accreditation.", IsDeleted = false },
            new KeyResultArea { Id = 9, Name = "SAFETY", Remarks = "Ensures a safe, secure, and supportive environment while enhancing the overall experience of employees, clients, and stakeholders through effective safety protocols and service excellence initiatives.", StrategicObjective = "Institutionalized a culture of people safety and holistic care.", IsDeleted = false }
            );
        }
    }
}
