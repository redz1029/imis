import 'package:flutter/material.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/date_time_converter.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  late final AnnouncementService _announcementService;
  late Future<List<Announcement>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementService = AnnouncementService(Dio());
    _announcementsFuture = _announcementService.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFeeeeee),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔹 Fixed Header
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.campaign, size: 28, color: primaryTextColor),
                const SizedBox(width: 8),
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
          gap16px,

          // 🔹 Scrollable Content
          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _announcementsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load announcements: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                final announcements = snapshot.data ?? [];
                if (announcements.isEmpty) {
                  return const Center(
                    child: Text(
                      'No active announcements at the moment.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final colors = [
                  Colors.orange,
                  Colors.green,
                  Colors.blue,
                  Colors.red,
                ];

                // 🔹 Make the list scrollable
                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return _AnnouncementCard(
                      announcement: announcements[index],
                      borderColor: colors[index % 4],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final Color borderColor;
  final _dateConverter = const LongDateOnlyConverter();

  const _AnnouncementCard({
    required this.announcement,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final fromDateStr = _dateConverter.toJson(announcement.fromDate);
    final toDateStr = _dateConverter.toJson(announcement.toDate);

    final displayDate =
        fromDateStr == toDateStr ? fromDateStr : '$fromDateStr - $toDateStr';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            displayDate,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          gap6px,
          Text(announcement.description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
