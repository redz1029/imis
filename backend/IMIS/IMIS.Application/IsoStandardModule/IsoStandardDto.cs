using Base.Primitives;
using System.Diagnostics.CodeAnalysis;
using IMIS.Domain;
using IMIS.Application.StandardVersionModule;

namespace IMIS.Application.IsoStandardModule
{
    public class IsoStandardDto : BaseDto<IsoStandard, long>
    {
        public required int VersionID { get; set; }
        public required string ClauseRef { get; set; }
        public string? Description { get; set; }
        public bool IsActive { get; set; }
        public StandardVersionDto? Version { get; set; }

        public IsoStandardDto() { }

        [SetsRequiredMembers]
        public IsoStandardDto(IsoStandard isoStandard)
        {
            this.Id = isoStandard.Id;
            this.VersionID = isoStandard.VersionID;
            this.ClauseRef = isoStandard.ClauseRef;
            this.Description = isoStandard.Description;
            this.IsActive = isoStandard.isActive;
            
            // Only include Version metadata, NOT nested IsoStandards to avoid circular reference
            if (isoStandard?.Version != null)
            {
                this.Version = new StandardVersionDto()
                {
                    Id = isoStandard.Version.Id,
                    VersionName = isoStandard.Version.VersionName,
                    IsActive = isoStandard.Version.isActive,
                    IsoStandards = null // IMPORTANT: Don't include nested list to prevent circular refs
                };
            }
        }

        public override IsoStandard ToEntity()
        {
            return new IsoStandard()
            {
                Id = Id,
                VersionID = VersionID,
                ClauseRef = ClauseRef,
                Description = Description,
                isActive = IsActive
            };
        }
    }
}
