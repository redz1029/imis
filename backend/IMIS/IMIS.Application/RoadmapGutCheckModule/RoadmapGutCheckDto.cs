using System.Diagnostics.CodeAnalysis;
using Base.Primitives;
using IMIS.Domain;

namespace IMIS.Application.RoadmapGutCheckModule
{
    public class RoadmapGutCheckDto : BaseDto<RoadmapGutCheck, int>
    {

        public double Ownership { get; set; }
        public double Alignment { get; set; }
        public double Contribution { get; set; }
        public double Measurement { get; set; }
        public double Adaptability { get; set; }
        public double Coherence { get; set; }
        public double Commitment { get; set; }
        public double TotalScore { get; set; }
        public RoadmapGutCheckDto() { }
        [SetsRequiredMembers]
        public RoadmapGutCheckDto(RoadmapGutCheck roadmapGutCheck)
        {
            this.Id = roadmapGutCheck.Id;  
            this.Ownership = roadmapGutCheck.Ownership;
            this.Alignment = roadmapGutCheck.Alignment;
            this.Contribution = roadmapGutCheck.Contribution;
            this.Measurement = roadmapGutCheck.Measurement;
            this.Adaptability = roadmapGutCheck.Adaptability;
            this.Coherence = roadmapGutCheck.Coherence;
            this.Commitment = roadmapGutCheck.Commitment;
            this.TotalScore = roadmapGutCheck.TotalScore;
        }
        public override RoadmapGutCheck ToEntity()
        {
            return new RoadmapGutCheck()
            {
                Id = Id,
                Ownership = Ownership,
                Alignment = Alignment,
                Contribution = Contribution,
                Measurement = Measurement,
                Adaptability = Adaptability,
                Coherence = Coherence,
                Commitment = Commitment,
               
            };
        }
    }
}
