
public class PgsDeliverableMonitoringDto
{
      
    public int? PgsPeriodId { get; set; }
    public int? Department { get; set; }
    public int? Kra { get; set; }
    public string? KraDescription { get; set; }
    public bool? IsDirect { get; set; }
    public string? Deliverable { get; set; }
    public double? Score { get; set; }
    public string? DeliverableStatus { get; set; }

    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 25;

    public PgsDeliverableMonitoringDto() { }

    public PgsDeliverableMonitoringDto(
        long? pgsDeliverableId = null,
        int? pgsPeriod = null,
        int? department = null,
        int? kra = null,
        string? KraDescription = null,
        bool? isDirect = null,
        string? deliverable = null,
        double? score = null,
        string? deliverableStatus = null,
        int page = 1,
        int pageSize = 25)
    {      
        PgsPeriodId = pgsPeriod;
        Department = department;
        Kra = kra;
        KraDescription = KraDescription;
        IsDirect = isDirect;
        Deliverable = deliverable;
        Score = score;
        DeliverableStatus = deliverableStatus;
        Page = page;
        PageSize = pageSize;
    }
}

