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

      
        

        public StandardVersionDto() { }

        [SetsRequiredMembers]
        public StandardVersionDto(StandardVersion version)
        {
            this.Id = version.Id;
            this.VersionName = version.VersionName;
            this.IsActive = version.isActive;
        }

        public override StandardVersion ToEntity()
        {
            return new StandardVersion()
            {
                Id = Id,
                VersionName = VersionName,
                isActive = IsActive

            };
        }
    }
}

