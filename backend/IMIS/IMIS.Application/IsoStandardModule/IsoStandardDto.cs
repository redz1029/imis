using Base.Primitives;
using System.Diagnostics.CodeAnalysis;
using IMIS.Domain;
using IMIS.Application.StandardVersionModule;

namespace IMIS.Application.IsoStandardModule
{
    public class IsoStandardDto : BaseDto<Domain.IsoStandard, long>
    {
        public required int VersionID { get; set; }
        public required string ClauseRef { get; set; }
        public string? Description { get; set; }
        public bool IsActive { get; set; }
        public StandardVersionDto? Version { get; set; }

        public IsoStandardDto() { }

        [SetsRequiredMembers]
        public IsoStandardDto(Domain.IsoStandard isoStandard)
        {
            this.Id = isoStandard.Id;
            this.VersionID = isoStandard.VersionID;
            this.ClauseRef = isoStandard.ClauseRef;
            this.Description = isoStandard.Description;
            this.IsActive = isoStandard.isActive;
            if (isoStandard.Version != null)
            {
                Version = new StandardVersionDto(isoStandard.Version);
            }
        }

        public override Domain.IsoStandard ToEntity()
        {
            return new Domain.IsoStandard()
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
