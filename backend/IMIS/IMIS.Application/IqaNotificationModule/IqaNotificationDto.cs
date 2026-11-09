using System;
using System.Collections.Generic;

namespace IMIS.Application.IqaNotificationModule
{
    public class IqaNotificationDto
    {
        public long Id { get; set; }
        public string Type { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
        public string EntityType { get; set; } = string.Empty;
        public long? EntityId { get; set; }

        /// <summary>The ISO sub-page the item is on (see IqaNotification.TargetPage).</summary>
        public int TargetPage { get; set; }

        /// <summary>UTC.</summary>
        public DateTime CreatedAt { get; set; }

        public bool IsRead { get; set; }
    }

    public class IqaNotificationListDto
    {
        public int UnreadCount { get; set; }
        public List<IqaNotificationDto> Items { get; set; } = new();
    }
}
