import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_roadmap/models/roadmap_history.dart';
import 'package:imis/utils/date_time_converter.dart';

class RoadmapHistoryDialog extends StatefulWidget {
  final List<RoadmapHistory> history;

  const RoadmapHistoryDialog({super.key, required this.history});

  @override
  State<RoadmapHistoryDialog> createState() => _RoadmapHistoryDialogState();
}

class _RoadmapHistoryDialogState extends State<RoadmapHistoryDialog> {
  final _dateConverter = const LongDateOnlyConverter();

  String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hrs = difference.inHours;
      return '$hrs ${hrs == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return _dateConverter.toJson(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 640;
    final dWidth =
        isMobile
            ? size.width * 0.97
            : size.width < 900
            ? size.width * 0.92
            : size.width < 1200
            ? size.width * 0.80
            : size.width * 0.30;
    final validEntries =
        widget.history.where((item) {
          final hasDetails =
              (item.deliverableDescription ?? '').trim().isNotEmpty;
          final hasYear = item.year != null;
          final hasAuthor = (item.userFullName ?? '').trim().isNotEmpty;
          final hasDate = item.postingDate != null;
          return hasDetails || hasYear || hasAuthor || hasDate;
        }).toList();

    validEntries.sort((a, b) {
      final ad = a.postingDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.postingDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    final roadmapName = widget.history
        .map((e) => (e.kraRoadmapName ?? '').trim())
        .firstWhere((name) => name.isNotEmpty, orElse: () => '');
    final headerTitle =
        roadmapName.isNotEmpty ? '$roadmapName ROADMAP HISTORY' : 'HISTORY';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 24,
        vertical: isMobile ? 8 : 20,
      ),
      child: Container(
        height: 600,
        width: dWidth,
        constraints: BoxConstraints(maxHeight: size.height * 0.93),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(.15),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 24,
                isMobile ? 14 : 18,
                14,
                12,
              ),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.history_outlined, color: Colors.white, size: 29),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      headerTitle,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: isMobile ? 13 : 15,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Flexible(
              child:
                  validEntries.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.history_toggle_off_rounded,
                                size: 40,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No history yet.',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 28,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 15),
                            ...validEntries.asMap().entries.map((e) {
                              final index = e.key;
                              final item = e.value;
                              final isDeleted = item.isDeleted == true;
                              return _buildHistoryText(
                                isMobile,
                                action: isDeleted ? 'Deleted' : 'Edited',
                                year: item.year?.toString() ?? '',
                                kraDescription: item.kraDescription ?? '',
                                details: item.deliverableDescription ?? '',
                                author: item.userFullName ?? '',
                                timeAgo:
                                    item.postingDate != null
                                        ? getRelativeTime(item.postingDate!)
                                        : '',
                                isDeleted: isDeleted,
                                isFirst: index == 0,
                                isLast: index == validEntries.length - 1,
                              );
                            }),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryText(
    bool isMobile, {
    required String action,
    required String year,
    required String kraDescription,
    required String details,
    required String author,
    required String timeAgo,
    bool isDeleted = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final dotColor = isDeleted ? Colors.redAccent : primaryColor;
    final hasFooter = author.isNotEmpty || timeAgo.isNotEmpty;

    // A Deliverable-level edit always carries a deliverable description;
    // if that's empty but a KRA description exists, the change happened
    // at the KRA level instead.
    final isDeliverableChange = details.trim().isNotEmpty;
    final mainText = isDeliverableChange ? details : kraDescription;
    final entityWord = isDeliverableChange ? 'deliverable' : 'KRA';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: isFirst ? 10 : 8,
                height: isFirst ? 10 : 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFirst ? dotColor : Colors.grey.shade300,
                  border:
                      isFirst
                          ? Border.all(
                            color: dotColor.withValues(alpha: 0.25),
                            width: 3,
                          )
                          : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: Colors.grey.shade200),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- timeAgo badge ---
                  if (timeAgo.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: dotColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: dotColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeAgo,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: dotColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // --- Main sentence: "Edited deliverable {name} for
                  // {year}, under KRA of {kra}" all in one flow ---
                  if (mainText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SelectableText.rich(
                      TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isMobile ? 12 : 12.5,
                          fontWeight: FontWeight.w400,
                          color: kMuted,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: '$action $entityWord '),
                          TextSpan(
                            text: mainText,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kText,
                              decoration:
                                  isDeleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              decorationColor: Colors.redAccent,
                            ),
                          ),
                          if (year.isNotEmpty) ...[
                            const TextSpan(text: ' for '),
                            TextSpan(
                              text: year,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                          if (isDeliverableChange &&
                              kraDescription.isNotEmpty) ...[
                            const TextSpan(text: ', under KRA of '),
                            TextSpan(
                              text: kraDescription,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // --- Footer: author ---
                  if (hasFooter) ...[
                    const SizedBox(height: 8),
                    if (author.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 12,
                            color: kMuted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'by $author',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: kMuted,
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
