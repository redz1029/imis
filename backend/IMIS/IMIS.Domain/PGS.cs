using Base.Primitives;

namespace IMIS.Domain
{
    public class PGS : Entity<int>
    {
        public required string Year { get; set; }
        public required string KRA_1 { get; set; }
        public required bool Direct_1 { get; set; }        
        public required bool Indirect_1 { get; set; }
        public required string Delivarables_1 { get; set; }
        public required string ByWhen_1 { get; set; }
        public required string Percent_Deliverables { get; set; }
        public required string Status { get; set; }
        

    }    
}
