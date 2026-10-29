using Base.Primitives;

namespace IMIS.Domain
{
    /// <summary>
    /// A picture attached to an NCAR as evidence that the nonconformity was
    /// resolved. Printed on the second page of the NCAR form (QP-03-F-08).
    /// </summary>
    public class NcarAttachment : Entity<long>
    {
        public required long NonconformingActionReportId { get; set; }
        public NonconformingActionReport? NonconformingActionReport { get; set; }

        public required string FileName { get; set; }
        public required string ContentType { get; set; }
        public required byte[] Content { get; set; }
        public string? Caption { get; set; }
        public int OrderNumber { get; set; }
    }
}
