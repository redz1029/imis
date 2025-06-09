
using System.ComponentModel;

namespace IMIS.Domain
{
    public enum PgsStatus 
    {
        [Description("Not Started")]
        notStarted,

        [Description("In Progress")]
        inProgress,

        [Description("On Track")]
        onTrack,

        [Description("Delayed")]
        delayed,

        [Description("Needs Improvement")]
        needsImprovement,

        [Description("Completed")]
        completed,

        [Description("Exceeded")]
        exceeded,

        [Description("On Hold")]
        onHold,

        [Description("Cancelled")]
        cancelled
    }
}
