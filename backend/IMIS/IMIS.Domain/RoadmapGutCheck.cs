using Base.Primitives;

namespace IMIS.Domain
{
    public class RoadmapGutCheck :  Entity<int>
    {
        public double Ownership { get; set; }
        public double Alignment { get; set; }
        public double Contribution { get; set; }
        public double Measurement { get; set; }
        public double Adaptability { get; set; }
        public double Coherence { get; set; }
        public double Commitment { get; set; }
        public double TotalScore => (Ownership + Alignment + Contribution + Measurement + Adaptability + Coherence + Commitment) / 7;
        public RoadmapGutCheck() { }
        public RoadmapGutCheck(double score1, double score2, double score3, double score4, double score5, double score6, double score7)
        {
            Ownership = score1;
            Alignment = score2;
            Contribution = score3;
            Measurement = score4;
            Adaptability = score5;
            Coherence = score6; 
            Commitment = score7;
        }
    }
}
