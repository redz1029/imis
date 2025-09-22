namespace IMIS.Application.PerfomanceGovernanceSystemModule
{
    public class PgsStatus
    {
        public const string Prepared = "Prepared";
        public const string Pending = "Pending";
        public const string Approved = "Approved";
        public const string ApprovedBy = "Approved By";
        public const string Disapproved = "Disapproved";
        public const string PreparedBy = "Prepared By";       
        public static string OfficeHead { get; set; } = "Office Head";
    }
}
