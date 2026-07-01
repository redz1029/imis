using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.StandardVersionModule
{
    public class StandardVersionDto : BaseDto<StandardVersion, int>
    {
        public required string VersionName { get; set; }
        public required bool IsActive { get; set; } // Adjusted casing to follow C# PascalCase conventions

        public StandardVersionDto() { }

        [SetsRequiredMembers]
        public StandardVersionDto(StandardVersion entity)
        {
            if (entity != null)
            {
                Id = entity.Id;
                VersionName = entity.VersionName;
                IsActive = entity.isActive;
            }
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