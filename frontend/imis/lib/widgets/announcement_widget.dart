// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/custom_toggle.dart';
import 'package:imis/widgets/permission_widget.dart';
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
                        PermissionString.roleAdmin,
                        PermissionString.mcc,
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
                        PermissionString.roleAdmin,
                        PermissionString.mcc,
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

    bool localIsActive = isActive;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null ? 'Create Announcement' : 'Edit Announcement',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    SizedBox(
                      width: 450,
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Description
                    SizedBox(
                      width: 450,
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Toggle
                    CustomToggle(
                      label: "Show on Dashboard",
                      value: localIsActive,
                      activeColor: primaryColor,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() => localIsActive = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
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
                          await _announcement.createAnnouncement(announcement);
                        } else {
                          await _announcement.updateAnnouncement(announcement);
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
                    }
                  },
                  child: Text(
                    id == null ? 'Save' : 'Update',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
        // fallback to actual date if too old
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
                            PermissionString.roleAdmin,
                            PermissionString.mcc,
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
