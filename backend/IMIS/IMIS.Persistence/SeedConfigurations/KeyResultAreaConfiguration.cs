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
            new KeyResultArea { Id = 1, Name = "PATIENT CARE", Remarks = "Focuses on delivering safe, quality, and patient-centered healthcare services to improve patient outcomes and satisfaction.", IsDeleted = false },
            new KeyResultArea { Id = 2, Name = "RESEARCH", Remarks = "Focuses on generating new knowledge, improving practices, and supporting evidence-based decision-making. It involves conducting studies, analyzing data, and producing insights that contribute to organizational goals and innovation.", IsDeleted = false },
            new KeyResultArea { Id = 3, Name = "TRAINING", Remarks = "Oversees the planning and delivery of training programs to enhance employee skills, address learning needs, and support continuous professional growth.", IsDeleted = false },
            new KeyResultArea { Id = 4, Name = "LINKAGES", Remarks = "Focuses on building and strengthening partnerships with external organizations, stakeholders, and institutions to support programs, resource sharing, and collaborative initiatives that advance organizational goals.", IsDeleted = false },
            new KeyResultArea { Id = 5, Name = "INFRASTRUCTURE & EQUIPMENT", Remarks = "Ensures the availability, maintenance, and improvement of physical facilities and equipment to support efficient operations and service delivery.", IsDeleted = false },
            new KeyResultArea { Id = 6, Name = "FINANCE", Remarks = "Manages budgeting, allocation, and utilization of financial resources to ensure transparency, accountability, and support for organizational goals.", IsDeleted = false },
            new KeyResultArea { Id = 7, Name = "INFORMATION CAPITAL", Remarks = "Focuses on the effective management, utilization, and protection of data, information systems, and technology to support decision-making, innovation, and operational efficiency.", IsDeleted = false },
            new KeyResultArea { Id = 8, Name = "HUMAN CAPITAL", Remarks = "Involves developing, managing, and optimizing the workforce through recruitment, capacity building, performance management, and employee engagement to achieve organizational goals.", IsDeleted = false },
            new KeyResultArea { Id = 9, Name = "PEOPLE SAFETY AND EXPERIENCE", Remarks = "Ensures a safe, secure, and supportive environment while enhancing the overall experience of employees, clients, and stakeholders through effective safety protocols and service excellence initiatives.", IsDeleted = false }
            );
        }
    }
}
