// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/custom_toggle.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  AnnouncementPageState createState() => AnnouncementPageState();
}

class AnnouncementPageState extends State<AnnouncementPage> {
  final _announcement = AnnouncementService(Dio());
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  List<Announcement> filteredList = [];
  List<Announcement> announcementList = [];
  final Dio dio = Dio();
  late FilterSearchResultUtil<Announcement> announcementSearchUtil;
  final _paginationUtils = PaginationUtil(Dio());

  @override
  void initState() {
    super.initState();
    fetchAnnouncement();
    announcementSearchUtil = FilterSearchResultUtil<Announcement>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().announcement,
      pageSize: _pageSize,
      fromJson: (json) => Announcement.fromJson(json),
    );
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> fetchAnnouncement({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _announcement.getAnnouncement(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          announcementList = pageList.items;
          filteredList = List.from(announcementList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> filterSearchResults(String query) async {
    final results = await announcementSearchUtil.filter(
      query,
      (announcement, search) =>
          (announcement.title).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Announcement Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 300,
                  child: TextField(
                    focusNode: isSearchfocus,
                    controller: searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      labelText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: isSearchfocus.hasFocus ? primaryColor : grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                    ),
                    onChanged: filterSearchResults,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  ElevatedButton.icon(
                    onPressed: () => showAnnouncementFormDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DESKTOP HEADER
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Title",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Status",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),

                    Expanded(
                      child:
                          _isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final announcement = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(announcement.title),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              announcement.isActive
                                                  ? 'Active'
                                                  : 'Inactive',
                                            ),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      size: 18,
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showAnnouncementFormDialog(
                                                        id:
                                                            announcement.id
                                                                .toString(),
                                                        title:
                                                            announcement.title,
                                                        fromDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  announcement
                                                                      .fromDate,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  announcement
                                                                      .toDate,
                                                                ),
                                                        description:
                                                            announcement
                                                                .description,
                                                        isActive:
                                                            announcement
                                                                .isActive,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    size: 18,
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        announcement.id
                                                            .toString(),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  showAnnouncementFormDialog(
                                                    id:
                                                        announcement.id
                                                            .toString(),
                                                    title: announcement.title,
                                                    fromDate:
                                                        DateTimeConverter()
                                                            .toJson(
                                                              announcement
                                                                  .fromDate,
                                                            ),
                                                    endDate: DateTimeConverter()
                                                        .toJson(
                                                          announcement.toDate,
                                                        ),
                                                    description:
                                                        announcement
                                                            .description,
                                                    isActive:
                                                        announcement.isActive,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    announcement.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                    ),

                                                    PopupMenuItem(
                                                      value: 'delete',

                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .delete_simple,
                                                            color: Colors.red,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Delete'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Team Name: ${announcement.title}",
                                        ),
                                        SizedBox(height: 8),

                                        Text(
                                          announcement.isActive
                                              ? 'Active'
                                              : 'Inactive',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged:
                                (page) => fetchAnnouncement(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showAnnouncementFormDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  void showAnnouncementFormDialog({
    String? id,
    String? title,
    String? fromDate,
    String? endDate,
    String? description,
    bool isActive = false,
  }) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    DateTime? selectedFromDate =
        fromDate != null ? DateTime.tryParse(fromDate) : null;
    DateTime? selectedEndDate =
        endDate != null ? DateTime.tryParse(endDate) : null;

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
                  id == null ? 'Create Announcement' : 'Manage Announcement',
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
                          focusColor: primaryColor,
                          labelText: 'From Date',
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
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
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                    onPrimary: secondaryColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedFromDate = picked;
                              if (selectedEndDate != null &&
                                  selectedEndDate!.isBefore(
                                    selectedFromDate!,
                                  )) {
                                selectedEndDate = null;
                              }
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedFromDate == null) {
                            return 'Please select a start date';
                          }
                          return null;
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
                          focusColor: primaryColor,
                          labelText: 'To Date',
                          floatingLabelStyle: TextStyle(color: primaryColor),
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              selectedEndDate != null
                                  ? "${selectedEndDate!.toLocal()}".split(
                                    ' ',
                                  )[0]
                                  : '',
                        ),
                        onTap: () async {
                          if (selectedFromDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select the start date first',
                                ),
                              ),
                            );
                            return;
                          }

                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                    onPrimary: secondaryColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => selectedEndDate = picked);
                          }
                        },
                        validator: (value) {
                          if (selectedEndDate == null) {
                            return 'Please select an end date';
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
                        maxLines: 6,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 14),

                    CustomToggle(
                      label: "Show on Dashboard",
                      value: isActive,
                      activeColor: primaryColor,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() => isActive = val);
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
                      bool? confirmAction = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              id == null ? "Confirm Save" : "Confirm Update",
                            ),
                            content: Text(
                              id == null
                                  ? "Are you sure you want to save this announcement?"
                                  : "Are you sure you want to update this announcement?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmAction == true) {
                        final announcement = Announcement(
                          id: int.tryParse(id ?? '0') ?? 0,
                          title: titleController.text,
                          fromDate: selectedFromDate!,
                          toDate: selectedEndDate!,
                          description: descriptionController.text,
                          isActive: isActive,
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

                          setState(() {
                            fetchAnnouncement();
                          });

                          Navigator.pop(context);

                          MotionToast.success(
                            title: const Text("Saved Successfully"),
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              announcement.id == 0
                                  ? "Announcement created successfully!"
                                  : "Announcement updated successfully!",
                            ),
                          ).show(context);
                        } catch (e) {
                          MotionToast.error(
                            title: const Text("Error"),
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              "Failed to save announcement: $e",
                            ),
                          ).show(context);
                        }
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Team? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _announcement.deleteAnnouncement(id);
                  await fetchAnnouncement();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Announcement deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete Team'));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
