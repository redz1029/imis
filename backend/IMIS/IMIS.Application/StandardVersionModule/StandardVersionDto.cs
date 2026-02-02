using Base.Primitives;
using IMIS.Application.IsoStandardModule;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;
using System.Text.Json.Serialization;

namespace IMIS.Application.StandardVersionModule
{
    public class StandardVersionDto : BaseDto<StandardVersion, int>
    {
        public required string VersionName { get; set; }
        public bool IsActive { get; set; }

        // This prevents the serializer from looking back at the standards list
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
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
