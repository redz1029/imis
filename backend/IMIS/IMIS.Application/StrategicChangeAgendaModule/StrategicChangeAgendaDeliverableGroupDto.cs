using IMIS.Domain;

namespace IMIS.Application.StrategicChangeAgendaModule
{
    public class StrategicChangeAgendaDeliverableGroupDto
    {
        public long Id { get; set; }
        public string? Area { get; set; }
        public List<StrategicChangeAgendaDeliverable>? Items { get; set; }

        public List<int?>? Years { get; set; }

        public string? Year1Description => GetDescriptionForYearIndex(0);
        public string? Year2Description => GetDescriptionForYearIndex(1);
        public string? Year3Description => GetDescriptionForYearIndex(2);
        public string? Year4Description => GetDescriptionForYearIndex(3);
        public string? Year5Description => GetDescriptionForYearIndex(4);

        public StrategicChangeAgendaDeliverableGroupDto()
        {
        }

        public StrategicChangeAgendaDeliverableGroupDto(List<StrategicChangeAgendaDeliverable> items, List<int?>? allYears)
        {
            Id = items.First().Id;
            Area = items.First().Area;
            Items = items;
            Years = allYears;
        }

        private string? GetDescriptionForYearIndex(int index)
        {
            if (Years == null || index >= Years.Count)
                return null;

            var targetYear = Years[index];
            return Items?.FirstOrDefault(i => i.Year == targetYear)?.Description;
        }
    }
}