using IMIS.Application.IqaNotificationModule;
using IMIS.Domain;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IMIS.Persistence.IqaNotificationModule
{
    public class IqaNotificationService : IIqaNotificationService
    {
        private readonly ImisDbContext _dbContext;

        public IqaNotificationService(ImisDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        private IQueryable<IqaNotification> Visible(string userId)
        {
            var since = DateTime.UtcNow.AddDays(-IIqaNotificationService.RetentionDays);
            return _dbContext.Set<IqaNotification>()
                .Where(n => !n.IsDeleted && n.RecipientUserId == userId && n.CreatedAt >= since);
        }

        public async Task<IqaNotificationListDto> GetForUserAsync(string userId, int limit, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return new IqaNotificationListDto();
            limit = Math.Clamp(limit, 1, 100);

            var unread = await Visible(userId).CountAsync(n => n.ReadAt == null, cancellationToken).ConfigureAwait(false);

            var rows = await Visible(userId)
                .AsNoTracking()
                .OrderByDescending(n => n.CreatedAt)
                .ThenByDescending(n => n.Id)
                .Take(limit)
                .ToListAsync(cancellationToken)
                .ConfigureAwait(false);

            return new IqaNotificationListDto
            {
                UnreadCount = unread,
                Items = rows.Select(n => new IqaNotificationDto
                {
                    Id = n.Id,
                    Type = n.Type,
                    Title = n.Title,
                    Message = n.Message,
                    EntityType = n.EntityType,
                    EntityId = n.EntityId,
                    TargetPage = n.TargetPage,
                    // Stored as UTC; say so, so the app shows the user's local time.
                    CreatedAt = DateTime.SpecifyKind(n.CreatedAt, DateTimeKind.Utc),
                    IsRead = n.ReadAt != null
                }).ToList()
            };
        }

        public async Task<bool> MarkReadAsync(string userId, long id, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return false;

            var now = DateTime.UtcNow;
            var owned = await _dbContext.Set<IqaNotification>()
                .AnyAsync(n => n.Id == id && n.RecipientUserId == userId && !n.IsDeleted, cancellationToken)
                .ConfigureAwait(false);
            if (!owned) return false;

            await _dbContext.Set<IqaNotification>()
                .Where(n => n.Id == id && n.RecipientUserId == userId && n.ReadAt == null)
                .ExecuteUpdateAsync(s => s.SetProperty(n => n.ReadAt, now), cancellationToken)
                .ConfigureAwait(false);
            return true;
        }

        public async Task MarkAllReadAsync(string userId, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(userId)) return;

            var now = DateTime.UtcNow;
            await _dbContext.Set<IqaNotification>()
                .Where(n => n.RecipientUserId == userId && !n.IsDeleted && n.ReadAt == null)
                .ExecuteUpdateAsync(s => s.SetProperty(n => n.ReadAt, now), cancellationToken)
                .ConfigureAwait(false);
        }
    }
}
