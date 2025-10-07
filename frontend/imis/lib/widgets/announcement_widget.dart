import 'package:flutter/material.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/constant/constant.dart';

class AnnouncementList extends StatelessWidget {
  static final List<Announcement> _staticAnnouncements = [
    Announcement(
      id: 0,
      title: 'Annual Performance Review Schedule',
      toDate: DateTime(2025, 5, 1),
      fromDateDate: DateTime(2025, 4, 10),
      description:
          'All staff are advised to review their 2025 performance goals and prepare for review discussions by May 30th.',
      isActive: true,
    ),
    Announcement(
      id: 0,
      title: 'New Policy Effective Next Month',
      toDate: DateTime(2025, 4, 10),
      fromDateDate: DateTime(2025, 4, 10),

      description:
          'Please review the udated attendance policy in the company portal.',
      isActive: true,
    ),
    Announcement(
      id: 0,
      title: 'Workshop: Leadership Training',
      toDate: DateTime(2025, 4, 25),
      fromDateDate: DateTime(2025, 4, 10),
      description:
          'Participate in our upcoming CRMC Leadership Development session.',
      isActive: true,
    ),
  ];

  const AnnouncementList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFeeeeee),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Row(
              children: [
                Icon(Icons.campaign, size: 48, color: primaryTextColor),
                SizedBox(width: 6),
                Text(
                  'Announcements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          gap24px,
          ...List<Widget>.generate(_staticAnnouncements.length, (index) {
            final colors = [
              Colors.orange,
              Colors.green,
              Colors.blue,
              Colors.red,
            ];
            return _AnnouncementCard(
              announcement: _staticAnnouncements[index],
              borderColor: colors[index % 4],
            );
          }),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final Color borderColor;

  const _AnnouncementCard({
    required this.announcement,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            announcement.toDate.toLocal().toString().split(' ')[0],
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          gap6px,
          Text(announcement.description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
