//using Base.Primitives;
//using System.Diagnostics.CodeAnalysis;

//namespace IMIS.Application.IQASignatoryModule
//{
//    public class IQASignatoryDto : BaseDto<IMIS.Domain.IQASignatory, long>
//    {
//        public required string AuditEntityType { get; set; }
//        public required int AuditEntityId { get; set; }
//        public int? AuditProgrammeId { get; set; }
//        public string? AuditProgrammeReferenceNumber { get; set; }
//        public int? AuditPlanId { get; set; }
//        public string? AuditPlanName { get; set; }
//        public int? AuditScheduleId { get; set; }
//        public int? IQASignatoryTemplateId { get; set; }
//        public string? SignatoryId { get; set; }
//        public string? SignatoryName { get; set; }
//        public DateTime DateSigned { get; set; }
//        public string? Remarks { get; set; }
//        public string? ApprovalStatus { get; set; }

//        public IQASignatoryDto() { }

//        [SetsRequiredMembers]
//        public IQASignatoryDto(IMIS.Domain.IQASignatory signatory)
//        {
//            Id = signatory.Id;
//            AuditEntityType = signatory.AuditEntityType;
//            AuditEntityId = signatory.AuditEntityId;
//            AuditProgrammeId = signatory.AuditProgrammeId;
//            AuditProgrammeReferenceNumber = signatory.AuditProgramme?.Year.ToString();
//            AuditPlanId = signatory.AuditPlanId;
//            AuditPlanName = signatory.AuditPlan?.PlanName;
//            AuditScheduleId = signatory.AuditScheduleId;
//            IQASignatoryTemplateId = signatory.IQASignatoryTemplateId;
//            SignatoryId = signatory.SignatoryId;
//            SignatoryName = signatory.Signatory?.UserName;
//            DateSigned = (DateTime)signatory.DateSigned;
//            Remarks = signatory.Remarks;
//            ApprovalStatus = signatory.ApprovalStatus;
//            IsDeleted = signatory.IsDeleted;
//            RowVersion = signatory.RowVersion;
//        }

//        public override IMIS.Domain.IQASignatory ToEntity()
//        {
//            return new IMIS.Domain.IQASignatory
//            {
//                Id = Id,
//                AuditEntityType = AuditEntityType,
//                AuditEntityId = AuditEntityId,
//                AuditProgrammeId = AuditProgrammeId,
//                AuditPlanId = AuditPlanId,
//                AuditScheduleId = AuditScheduleId,
//                IQASignatoryTemplateId = IQASignatoryTemplateId,
//                SignatoryId = SignatoryId,
//                DateSigned = DateSigned,
//                Remarks = Remarks,
//                ApprovalStatus = ApprovalStatus,
//                IsDeleted = IsDeleted,
//                RowVersion = RowVersion
//            };
//        }
//    }
//}
using Base.Primitives;
using System.Diagnostics.CodeAnalysis;

namespace IMIS.Application.IQASignatoryModule
{
    public class IQASignatoryDto : BaseDto<IMIS.Domain.IQASignatory, long>
    {
        public required string AuditEntityType { get; set; }
        public required int AuditEntityId { get; set; }
        public int? AuditProgrammeId { get; set; }
        public string? AuditProgrammeReferenceNumber { get; set; }
        public int? AuditPlanId { get; set; }
        public string? AuditPlanName { get; set; }
        public int? AuditScheduleId { get; set; }
        public int? IQASignatoryTemplateId { get; set; }
        public string? SignatoryId { get; set; }
        public string? SignatoryName { get; set; }

        // From the template: "QMR", "Lead Auditor", ... and the signing order.
        public string? SignatoryLabel { get; set; }
        public string? Position { get; set; }
        public int? OrderLevel { get; set; }

        // Null until the signatory has actually signed.
        public DateTime? DateSigned { get; set; }
        public string? Remarks { get; set; }
        public string? ApprovalStatus { get; set; }

        public IQASignatoryDto() { }

        [SetsRequiredMembers]
        public IQASignatoryDto(IMIS.Domain.IQASignatory signatory)
        {
            Id = signatory.Id;
            AuditEntityType = signatory.AuditEntityType;
            AuditEntityId = signatory.AuditEntityId;
            AuditProgrammeId = signatory.AuditProgrammeId;
            AuditProgrammeReferenceNumber = signatory.AuditProgramme?.Year.ToString();
            AuditPlanId = signatory.AuditPlanId;
            AuditPlanName = signatory.AuditPlan?.PlanName;
            AuditScheduleId = signatory.AuditScheduleId;
            IQASignatoryTemplateId = signatory.IQASignatoryTemplateId;
            SignatoryId = signatory.SignatoryId;
            SignatoryName = FullNameOf(signatory.Signatory);
            SignatoryLabel = signatory.IQASignatoryTemplate?.SignatoryLabel;
            Position = signatory.IQASignatoryTemplate?.Position;
            OrderLevel = signatory.IQASignatoryTemplate?.OrderLevel;
            DateSigned = signatory.DateSigned;
            Remarks = signatory.Remarks;
            ApprovalStatus = signatory.ApprovalStatus;
            IsDeleted = signatory.IsDeleted;
            RowVersion = signatory.RowVersion;
        }

        private static string? FullNameOf(IMIS.Domain.User? user)
        {
            if (user == null) return null;

            var parts = new[] { user.Prefix, user.FirstName, user.MiddleName, user.LastName, user.Suffix }
                .Where(p => !string.IsNullOrWhiteSpace(p));
            var fullName = string.Join(" ", parts);

            return string.IsNullOrWhiteSpace(fullName) ? user.UserName : fullName;
        }

        public override IMIS.Domain.IQASignatory ToEntity()
        {
            return new IMIS.Domain.IQASignatory
            {
                Id = Id,
                AuditEntityType = AuditEntityType,
                AuditEntityId = AuditEntityId,
                AuditProgrammeId = AuditProgrammeId,
                AuditPlanId = AuditPlanId,
                AuditScheduleId = AuditScheduleId,
                IQASignatoryTemplateId = IQASignatoryTemplateId,
                SignatoryId = SignatoryId,
                DateSigned = DateSigned,
                Remarks = Remarks,
                ApprovalStatus = ApprovalStatus,
                IsDeleted = IsDeleted,
                RowVersion = RowVersion
            };
        }
    }
}