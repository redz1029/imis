// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/permission_role_string.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  late final AnnouncementService _announcementService;
  late Future<List<Announcement>> _announcementsFuture;
  final _announcement = AnnouncementService(Dio());
  final _formKey = GlobalKey<FormState>();
  final _dateConverter = const LongDateOnlyConverter();

  @override
  void initState() {
    super.initState();
    _announcementService = AnnouncementService(Dio());
    _announcementsFuture = _announcementService.getAnnouncements();
  }

  Future<void> _refreshAnnouncements() async {
    setState(() {
      _announcementsFuture = _announcementService.getAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder<List<Announcement>>(
                    future: _announcementsFuture,
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      final label =
                          count == 0 ? 'Announcement' : '$count Announcements';
                      return Text(
                        snapshot.hasData ? label : 'Announcements',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PermissionWidget(
                      allowedRoles: [
                        PermissionRoleString.roleAdmin,
                        PermissionRoleString.mcc,
                      ],
                      child: Tooltip(
                        message: 'Add announcement',
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.blue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            onPressed: () => showAnnouncementFormDialog(),
                            icon: const Icon(Icons.add, color: primaryColor),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    PermissionWidget(
                      allowedRoles: [
                        PermissionRoleString.roleAdmin,
                        PermissionRoleString.mcc,
                      ],
                      child: Tooltip(
                        message: 'Manage announcement',
                        child: IconButton(
                          onPressed: () => _showManageAnnouncementsDialog(),
                          icon: const Icon(Icons.list),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          gap16px,
          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _announcementsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
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
                      'No announcements at the moment.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshAnnouncements,
                  child: ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return _AnnouncementCard(
                        announcement: announcements[index],
                        borderColor: Color(0xFFCD2C58),
                        onEdit: (announcement) {
                          showAnnouncementFormDialog(
                            id: announcement.id.toString(),
                            title: announcement.title,

                            description: announcement.description,
                            isActive: announcement.isActive,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showManageAnnouncementsDialog() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              Future<List<Announcement>> announcementsFuture =
                  _announcementService.getAnnouncementsFromEndpoint(
                    ApiEndpoint().announcement,
                  );
              return AlertDialog(
                backgroundColor: mainBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Manage Announcements',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: 500,
                  height: 400,
                  child: FutureBuilder<List<Announcement>>(
                    future: announcementsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final allAnnouncements = snapshot.data ?? [];
                        return allAnnouncements.isEmpty
                            ? const Center(
                              child: Text('No announcements found.'),
                            )
                            : ListView.builder(
                              itemCount: allAnnouncements.length,
                              itemBuilder: (context, index) {
                                final ann = allAnnouncements[index];
                                return Card(
                                  elevation: 0,
                                  color: mainBgColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      ann.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${ann.description}\nFrom: ${_dateConverter.toJson(ann.fromDate)} - To: ${_dateConverter.toJson(ann.toDate)}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showAnnouncementFormDialog(
                                          id: ann.id.toString(),
                                          title: ann.title,
                                          description: ann.description,
                                          isActive: ann.isActive,
                                          onSaved: () {
                                            setState(() {
                                              announcementsFuture =
                                                  _announcementService
                                                      .getAnnouncementsFromEndpoint(
                                                        ApiEndpoint()
                                                            .announcement,
                                                      );
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      MotionToast.error(
        title: const Text("Error"),
        toastAlignment: Alignment.topCenter,
        description: Text("Failed to fetch announcements: $e"),
      ).show(context);
    }
  }

  void showAnnouncementFormDialog({
    String? id,
    String? title,
    String? description,
    bool isActive = false,
    Function()? onSaved,
  }) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    bool activeState = isActive;

    bool localIsActive = isActive;
    final isEdit = id != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 460,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .12),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.campaign_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit
                                    ? 'Edit Announcement'
                                    : 'Create Announcement',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update announcement details'
                                    : 'Add a new announcement',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      SizedBox(height: 20),
                      dialogField(
                        label: 'Title',
                        controller: titleController,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Please fill out this field'
                                    : null,
                      ),
                      SizedBox(height: 12),
                      dialogField(
                        label: 'Description',
                        controller: descriptionController,
                        maxLines: 4,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Please fill out ths field'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Show on Dashboard',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kText,
                                  ),
                                ),
                                Text(
                                  'Visible to all users on the dashboard',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: kMuted,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: activeState,
                              onChanged:
                                  (val) =>
                                      setStateDialog(() => activeState = val),
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: kBorder),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                final confirmed = await showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: kSurface,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 32,
                                                offset: const Offset(0, 12),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(
                                                  Icons.help_outline_rounded,
                                                  color: primaryColor,
                                                  size: 26,
                                                ),
                                              ),
                                              SizedBox(height: 14),
                                              Text(
                                                isEdit
                                                    ? 'Confirm Update'
                                                    : 'Confirm Save',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: kText,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isEdit
                                                    ? 'Are you sure you want to update this announcement?'
                                                    : 'Are you want to save this announcement',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 22),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        'No',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color: kMuted,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            primaryColor,
                                                        elevation: 0,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 11,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Yes',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );
                                if (confirmed != true) return;
                                final announcement = Announcement(
                                  id: int.tryParse(id ?? '0') ?? 0,
                                  title: titleController.text,
                                  fromDate: DateTime.now(),
                                  toDate: DateTime.now(),
                                  description: descriptionController.text,
                                  isActive: localIsActive,
                                  isDeleted: false,
                                );

                                try {
                                  if (announcement.id == 0) {
                                    await _announcement.createAnnouncement(
                                      announcement,
                                    );
                                  } else {
                                    await _announcement.updateAnnouncement(
                                      announcement,
                                    );
                                  }

                                  Navigator.pop(context);
                                  if (onSaved != null) {
                                    onSaved(); // << Call the onSaved callback
                                  }

                                  MotionToast.success(
                                    title: const Text("Success"),
                                    toastAlignment: Alignment.topCenter,
                                    description: Text(
                                      announcement.id == 0
                                          ? "Announcement created successfully!"
                                          : "Announcement updated successfully!",
                                    ),
                                  ).show(context);
                                  _refreshAnnouncements();
                                } catch (e) {
                                  MotionToast.error(
                                    title: const Text("Error"),
                                    toastAlignment: Alignment.topCenter,
                                    description: Text("Failed to save: $e"),
                                  ).show(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final Color borderColor;
  final Function(Announcement) onEdit;
  final _dateConverter = const LongDateOnlyConverter();

  const _AnnouncementCard({
    required this.announcement,
    required this.borderColor,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final fromDateStr = _dateConverter.toJson(announcement.fromDate);
    final toDateStr = _dateConverter.toJson(announcement.toDate);
    final displayDate =
        fromDateStr == toDateStr ? fromDateStr : '$fromDateStr – $toDateStr';
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCD2C58),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SelectableText(
                            announcement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF1A1A2E),
                              height: 1.3,
                            ),
                          ),
                        ),
                        PermissionWidget(
                          allowedRoles: [
                            PermissionRoleString.roleAdmin,
                            PermissionRoleString.mcc,
                          ],
                          child: Tooltip(
                            message: 'Edit announcement',
                            child: InkWell(
                              onTap: () => onEdit(announcement),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 15,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 11,
                          color: const Color(0xFFCD2C58).withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Tooltip(
                          message: displayDate,
                          child: Text(
                            getRelativeTime(announcement.fromDate),
                            style: TextStyle(
                              color: const Color(
                                0xFFCD2C58,
                              ).withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Divider(
                      color: Colors.grey.shade100,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 8),
                    SelectableLinkify(
                      text: announcement.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4A4A6A),
                        height: 1.5,
                      ),
                      linkStyle: const TextStyle(
                        color: Colors.lightBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                      ),
                      onOpen: (link) async {
                        final url = Uri.parse(link.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open link'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
