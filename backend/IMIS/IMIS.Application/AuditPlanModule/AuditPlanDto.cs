//using Base.Primitives;
//using IMIS.Application.AuditPlanEntryModule;
//using IMIS.Application.AuditPlanApprovalModule;
//using IMIS.Application.IsoAuditorModule;
//using IMIS.Domain;
//using System;
//using System.Collections.Generic;
//using System.Diagnostics.CodeAnalysis;
//using System.Linq;
//using IMIS.Application.AuditProgrammeModule;

//namespace IMIS.Application.AuditPlanModule
//{
//    public class AuditPlanDto : BaseDto<AuditPlan, int>
//    {
//        public required DateTime StartDate { get; set; }
//        public required DateTime EndDate { get; set; }

//        // Fix: Explicitly include the Foreign Key property to prevent EF Core graph drops
//        public int AuditProgrammeId { get; set; }
//        public AuditProgrammeDto? AuditProgramme { get; set; }

//        // Fix: Keep a dedicated field for the lookup ID of the Auditor to avoid duplication bugs
//        public int? PreparerId { get; set; }
//        public IsoAuditorDto? Preparer { get; set; }

//        public required string PlanStatus { get; set; }

//        public DateTime CreatedDate { get; set; }
//        public DateTime? LastModifiedDate { get; set; }

//        // Navigation DTOs
//        public List<AuditPlanEntryDto> Entries { get; set; } = new();
//        public List<AuditPlanApprovalDto> Approvals { get; set; } = new();

//        public AuditPlanDto() { }

//        [SetsRequiredMembers]
//        public AuditPlanDto(AuditPlan entity)
//        {
//            this.Id = entity.Id;
//            this.StartDate = entity.StartDate;
//            this.EndDate = entity.EndDate;
//            this.PlanStatus = entity.PlanStatus;
//            this.CreatedDate = entity.CreatedDate;
//            this.LastModifiedDate = entity.LastModifiedDate;

//            // Map the Parent ID connection
//            this.AuditProgrammeId = entity.AuditProgrammeId;

//            // Map Lookup Reference Info
//            // Note: Assuming your Domain entity has a 'PreparerId' column matching its Preparer property
//            // this.PreparerId = entity.PreparerId; 

//            this.Preparer = entity.Preparer != null
//                ? new IsoAuditorDto(entity.Preparer)
//                : null;

//            this.Entries = entity.Entries != null
//                ? entity.Entries.Select(x => new AuditPlanEntryDto(x)).ToList()
//                : new List<AuditPlanEntryDto>();

//            this.Approvals = entity.Approvals != null
//                ? entity.Approvals.Select(x => new AuditPlanApprovalDto(x)).ToList()
//                : new List<AuditPlanApprovalDto>();

//            this.RowVersion = entity.RowVersion;
//        }

//        public override AuditPlan ToEntity()
//        {
//            return new AuditPlan
//            {
//                Id = this.Id,
//                StartDate = this.StartDate,
//                EndDate = this.EndDate,
//                PlanStatus = this.PlanStatus,
//                CreatedDate = this.CreatedDate,
//                LastModifiedDate = this.LastModifiedDate,

//                // Fix: Bind the Parent Link to the Domain instance 
//                AuditProgrammeId = this.AuditProgrammeId,

//                // Fix: Avoid setting navigation entity graphs directly for lookups during conversions.
//                // Setting 'Preparer = ToEntity()' causes EF Core to treat the lookup as a completely new 
//                // record to insert into the db, which breaks. Instead, map its explicit Foreign Key Id if applicable.
//                // PreparerId = this.PreparerId, 

//                Entries = this.Entries?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanEntry>(),
//                Approvals = this.Approvals?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanApproval>(),

//                RowVersion = this.RowVersion
//            };
//        }
//    }
//}

using Base.Primitives;
using IMIS.Application.AuditPlanEntryModule;
using IMIS.Application.AuditPlanApprovalModule;
using IMIS.Application.IsoAuditorModule;
using IMIS.Domain;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json.Serialization; // ?? CRITICAL for blocking cyclic property serialization loops
using IMIS.Application.AuditProgrammeModule;

namespace IMIS.Application.AuditPlanModule
{
    public class AuditPlanDto : BaseDto<AuditPlan, int>
    {
        public required DateTime StartDate { get; set; }
        public required DateTime EndDate { get; set; }

        // Keep the primitive foreign key property for API payload binding
        public int AuditProgrammeId { get; set; }

        // ?? FIX: The crucial attribute to prevent the serializer from entering an infinite loop.
        // This completely hides the parent back-reference path from the JSON serializer engine and Swagger.
        [JsonIgnore]
        public AuditProgrammeDto? AuditProgramme { get; set; }

        public int? PreparerId { get; set; }
        public IsoAuditorDto? Preparer { get; set; }

        public required string PlanStatus { get; set; }

        public DateTime CreatedDate { get; set; }
        public DateTime? LastModifiedDate { get; set; }

        // Navigation DTOs
        public List<AuditPlanEntryDto> Entries { get; set; } = new();
        public List<AuditPlanApprovalDto> Approvals { get; set; } = new();

        public AuditPlanDto() { }

        [SetsRequiredMembers]
        public AuditPlanDto(AuditPlan entity)
        {
            this.Id = entity.Id;
            this.StartDate = entity.StartDate;
            this.EndDate = entity.EndDate;
            this.PlanStatus = entity.PlanStatus;
            this.CreatedDate = entity.CreatedDate;
            this.LastModifiedDate = entity.LastModifiedDate;

            // Map the Parent ID connection safely
            this.AuditProgrammeId = entity.AuditProgrammeId;

            this.Preparer = entity.Preparer != null
                ? new IsoAuditorDto(entity.Preparer)
                : null;

            this.Entries = entity.Entries != null
                ? entity.Entries.Select(x => new AuditPlanEntryDto(x)).ToList()
                : new List<AuditPlanEntryDto>();

            this.Approvals = entity.Approvals != null
                ? entity.Approvals.Select(x => new AuditPlanApprovalDto(x)).ToList()
                : new List<AuditPlanApprovalDto>();

            this.RowVersion = entity.RowVersion;
        }

        public override AuditPlan ToEntity()
        {
            return new AuditPlan
            {
                Id = this.Id,
                StartDate = this.StartDate,
                EndDate = this.EndDate,
                PlanStatus = this.PlanStatus,
                CreatedDate = this.CreatedDate,
                LastModifiedDate = this.LastModifiedDate,

                AuditProgrammeId = this.AuditProgrammeId,

                Entries = this.Entries?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanEntry>(),
                Approvals = this.Approvals?.Select(x => x.ToEntity()).ToList() ?? new List<AuditPlanApproval>(),

                RowVersion = this.RowVersion
            };
        }
    }
}