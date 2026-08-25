namespace IMIS.Application.AuditorTeamsModule
{
    public class AuditorTeamsPageDto
    {
        public int Page { get; set; }

        public int PageSize { get; set; }

        public int TotalCount { get; set; }

        public List<AuditorTeamsDto> Items { get; set; } = new();
    }
}
