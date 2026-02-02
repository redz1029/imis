using Base.Primitives;
using System.Diagnostics.CodeAnalysis;
using IMIS.Domain;
using IMIS.Application.IsoStandardModule;

namespace IMIS.Application.StandardVersionModule
{
    public class StandardVersionDto : BaseDto<StandardVersion, int>
    {
        public required string VersionName { get; set; }
        public bool IsActive { get; set; }
        public List<IsoStandardDto>? IsoStandards { get; set; }

        public StandardVersionDto() { }

        [SetsRequiredMembers]
        public StandardVersionDto(StandardVersion version)
        {
            this.Id = version.Id;
            this.VersionName = version.VersionName;
            this.IsActive = version.isActive;
            if (version?.IsoStandards != null && version.IsoStandards.Count > 0)
            {
                IsoStandards = new List<IsoStandardDto>();
                foreach (var iso in version.IsoStandards)
                {
                    IsoStandards.Add(new IsoStandardDto(iso));
                }
            }
        }

        public override StandardVersion ToEntity()
        {
            return new StandardVersion()
            {
                Id = Id,
                VersionName = VersionName,
                isActive = IsActive
                //IsoStandards = IsoStandards?.Select(iso => iso.ToEntity()).ToList()
            };
        }
    }
}
