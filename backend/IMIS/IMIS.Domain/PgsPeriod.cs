using Base.Primitives;

namespace IMIS.Domain
{
    public class PgsPeriod : Entity<int>
    {
        public required DateOnly StartDate { get; set;}
        public required DateOnly EndDate { get; set;}
        public string? Remarks { get; set;}
    }
}

