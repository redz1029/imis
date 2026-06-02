using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;


namespace IMIS.Application.KraRoadmapCoreSupportProcessModule
{
    public class KraRoadmapCoreSupportProcessDto : BaseDto<KraRoadmapCoreSupportProcess, int>
    {
        public string? ProcessName { get; set; }

        public KraRoadmapCoreSupportProcessDto() { }
        [SetsRequiredMembers]
        public KraRoadmapCoreSupportProcessDto(KraRoadmapCoreSupportProcess kraRoadmapCoreSupportProcess)
        {
            this.Id = kraRoadmapCoreSupportProcess.Id;
            this.ProcessName = kraRoadmapCoreSupportProcess.ProcessName;          
        }
        public override KraRoadmapCoreSupportProcess ToEntity()
        {
            return new KraRoadmapCoreSupportProcess()
            {
                Id = Id,
                ProcessName = ProcessName,              
            };
        }
    }
}
