using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using IMIS.Domain;

namespace IMIS.Persistence.SeedConfigurations
{
    /// <summary>
    /// Seed data for IQA (Internal Quality Audit) Signatory Template.
    /// Defines approval chain for Audit Programme, Audit Plan, and Audit Schedule approvals.
    /// </summary>
    public class IQASignatoryTemplateConfiguration : IEntityTypeConfiguration<IQASignatoryTemplate>
    {
        public void Configure(EntityTypeBuilder<IQASignatoryTemplate> builder)
        {
            builder.HasData(
                // === AUDIT PROGRAMME Approvals ===
                // Level 1: Lead Auditor creates/submits (PENDING status)
                new IQASignatoryTemplate
                {
                    Id = 1,
                    AuditEntityType = "AuditProgramme",
                    Status = "Pending",
                    SignatoryLabel = "Lead Auditor",
                    OrderLevel = 1,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "Lead Auditor",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },
                // Level 2: QMR approves/disapproves (APPROVED or DISAPPROVED)
                new IQASignatoryTemplate
                {
                    Id = 2,
                    AuditEntityType = "AuditProgramme",
                    Status = "Pending",
                    SignatoryLabel = "QMR (Quality Management Representative)",
                    OrderLevel = 2,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "QMR",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },

                // === AUDIT PLAN Approvals ===
                // Level 1: Lead Auditor creates/submits
                new IQASignatoryTemplate
                {
                    Id = 3,
                    AuditEntityType = "AuditPlan",
                    Status = "Pending",
                    SignatoryLabel = "Lead Auditor",
                    OrderLevel = 1,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "Lead Auditor",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },
                // Level 2: QMR approves/disapproves
                new IQASignatoryTemplate
                {
                    Id = 4,
                    AuditEntityType = "AuditPlan",
                    Status = "Pending",
                    SignatoryLabel = "QMR (Quality Management Representative)",
                    OrderLevel = 2,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "QMR",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },

                // === AUDIT SCHEDULE Approvals ===
                // Level 1: Lead Auditor/Audit Team creates/submits
                new IQASignatoryTemplate
                {
                    Id = 5,
                    AuditEntityType = "AuditSchedule",
                    Status = "Pending",
                    SignatoryLabel = "Lead Auditor",
                    OrderLevel = 1,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "Lead Auditor",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },
                // Level 2: Department Head (Standard User) approves the audit schedule
                new IQASignatoryTemplate
                {
                    Id = 6,
                    AuditEntityType = "AuditSchedule",
                    Status = "Pending",
                    SignatoryLabel = "Department Head",
                    OrderLevel = 2,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "Department Head",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                },
                // Level 3: QMR final approval on audit schedule
                new IQASignatoryTemplate
                {
                    Id = 7,
                    AuditEntityType = "AuditSchedule",
                    Status = "Pending",
                    SignatoryLabel = "QMR (Quality Management Representative)",
                    OrderLevel = 3,
                    DefaultSignatoryId = null,
                    IsActive = true,
                    OfficeId = 1,
                    Position = "QMR",
                    IsDeleted = false,
                    RowVersion = new byte[] { }
                }
            );
        }
    }
}
