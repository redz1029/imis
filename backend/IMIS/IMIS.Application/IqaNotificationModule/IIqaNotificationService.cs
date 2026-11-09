using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Application.IqaNotificationModule
{
    /// <summary>The IQA notifications of one signed-in user (the bell).</summary>
    public interface IIqaNotificationService
    {
        /// <summary>Notifications older than this many days are no longer listed, read or not.</summary>
        public const int RetentionDays = 30;

        /// <summary>The newest notifications of the user and how many are unread.</summary>
        Task<IqaNotificationListDto> GetForUserAsync(string userId, int limit, CancellationToken cancellationToken);

        /// <summary>Marks one notification of the user as read; false when it is not theirs.</summary>
        Task<bool> MarkReadAsync(string userId, long id, CancellationToken cancellationToken);

        Task MarkAllReadAsync(string userId, CancellationToken cancellationToken);
    }
}
