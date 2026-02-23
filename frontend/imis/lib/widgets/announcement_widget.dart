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
      decoration: BoxDecoration(
        color: const Color(0xFFeeeeee),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ),
                  ),
                ),
                Text(
                  'Announcements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),

                const SizedBox(width: 20),
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
                    ),
                  ),
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
                      'No announcements at the moment.',
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

                return RefreshIndicator(
                  onRefresh: _refreshAnnouncements,
                  child: ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return _AnnouncementCard(
                        announcement: announcements[index],
                        borderColor: colors[index % 4],
                        onEdit: (announcement) {
                          showAnnouncementFormDialog(
                            id: announcement.id.toString(),
                            title: announcement.title,
                            fromDate: announcement.fromDate,
                            endDate: announcement.toDate,
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
                        return const Center(child: CircularProgressIndicator());
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
                                          fromDate: ann.fromDate,
                                          endDate: ann.toDate,
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
    DateTime? fromDate,
    DateTime? endDate,
    String? description,
    bool isActive = false,
    Function()? onSaved,
  }) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    DateTime? selectedFromDate = fromDate;
    DateTime? selectedEndDate = endDate;
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

                    // From Date
                    SizedBox(
                      width: 450,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'From Date',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              selectedFromDate != null
                                  ? "${selectedFromDate!.toLocal()}".split(
                                    ' ',
                                  )[0]
                                  : '',
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedFromDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedFromDate = picked;
                              if (selectedEndDate != null &&
                                  selectedEndDate!.isBefore(picked)) {
                                selectedEndDate = null;
                              }
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    // End Date
                    SizedBox(
                      width: 450,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'To Date',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              selectedEndDate != null
                                  ? "${selectedEndDate?.toLocal()}".split(
                                    ' ',
                                  )[0]
                                  : '',
                        ),
                        onTap: () async {
                          if (selectedFromDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select start date first'),
                              ),
                            );
                            return;
                          }

                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedEndDate ?? DateTime.now(),
                            firstDate: selectedFromDate!,
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() => selectedEndDate = picked);
                          }
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
                        fromDate: selectedFromDate!,
                        toDate: selectedEndDate!,
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
          SelectableText(
            announcement.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SelectableText(
            displayDate,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          gap6px,

          SelectableLinkify(
            text: announcement.description,
            style: const TextStyle(fontSize: 14),
            linkStyle: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            onOpen: (link) async {
              final url = Uri.parse(link.url);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open link')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
