using Base.Primitives;
using IMIS.Application.StandardVersionModule;
using IMIS.Domain;
using System.Diagnostics.CodeAnalysis;

public class IsoStandardDto : BaseDto<IsoStandard, long>
{
    public required int VersionID { get; set; }
    public long? ParentID { get; set; }
    public required string ClauseRef { get; set; }
    public string? Description { get; set; }
    public bool IsActive { get; set; }
    public required string Particulars { get; set; }

    public List<IsoStandardDto> Children { get; set; } = new();

    public StandardVersionDto? Version { get; set; }

    public IsoStandardDto() { }

    [SetsRequiredMembers]
    public IsoStandardDto(IsoStandard isoStandard )
    {
        Id = isoStandard.Id;
        VersionID = isoStandard.VersionID;
        ClauseRef = isoStandard.ClauseRef;
        Description = isoStandard.Description;
        IsActive = isoStandard.isActive;
        ParentID = isoStandard.ParentID;
        Particulars = isoStandard.Particulars;
        

        if (isoStandard.Version != null)
        {
            Version = new StandardVersionDto
            {
                Id = isoStandard.Version.Id,
                VersionName = isoStandard.Version.VersionName,
                IsActive = isoStandard.Version.isActive
            };
        }
    }

    public override IsoStandard ToEntity()
    {
        return new IsoStandard
        {
            Id = Id,
            VersionID = VersionID,
            ClauseRef = ClauseRef,
            Description = Description,
            isActive = IsActive,
            ParentID = ParentID,
            Particulars = Particulars
        };
    }
}