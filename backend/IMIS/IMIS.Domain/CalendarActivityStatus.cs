using System.ComponentModel;

namespace IMIS.Domain
{
    public enum CalendarActivityStatus
    {
        [Description("Planned")]
        Planned,

        [Description("In Progress")]
        InProgress,

        [Description("Completed")]
        Completed,

        [Description("Cancelled")]
        Cancelled,

        [Description("Postponed")]
        Postponed
    }
}