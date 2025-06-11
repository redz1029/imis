using Base.Pagination;
using Base.Utilities;
using IMIS.Domain;

namespace IMIS.Application.PgsDeliverableModule
{
    public class PgsDeliverableMonitorPageList : PageList
    {
        public List<PgsDeliverableMonitorDto> Items { get; set; }

        private PgsDeliverableMonitorPageList(List<PgsDeliverableMonitorDto> items, int page, int pageSize, int totalCount)
        {
            Items = items;
            Page = page;
            PageSize = pageSize;
            TotalCount = totalCount;
        }

        public static PgsDeliverableMonitorPageList Create(List<PgsDeliverable> entities, int page, int pageSize, int totalCount)
        {
            var items = entities.Select(e =>
                    new PgsDeliverableMonitorDto()
                    {
                        PgsDeliverableId = e.Id,
                        PgsPeriod = e.PerfomanceGovernanceSystem!.PgsPeriod.StartDate.ToString("MMM dd, yyyy") + " - " + e.PerfomanceGovernanceSystem.PgsPeriod.EndDate.ToString("MMM dd, yyyy"),
                        Deliverable = e.DeliverableName,
                        IsDirect = e.IsDirect,
                        KeyResultArea = e.Kra?.Name ?? string.Empty,
                        KraDescription = e.KraDescription,
                        Office = e.PerfomanceGovernanceSystem.Office.Name,
                        Score = e.PgsDeliverableScoreHistory?.OrderByDescending(s => s.Date).FirstOrDefault()?.Score ?? 0,
                        Status = e.Status.GetDescription(),
                        Remarks = e.Remarks,
                        ByWhen = e.ByWhen
                    }
                ).ToList();
            return new PgsDeliverableMonitorPageList(items, page, pageSize, totalCount);
        }
    }
}
