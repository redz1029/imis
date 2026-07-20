// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
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
                              : filteredList.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.campaign_outlined,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "No announcement available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
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
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    // DateTime? selectedFromDate =
    //     fromDate != null ? DateTime.tryParse(fromDate) : null;
    // DateTime? selectedEndDate =
    //     endDate != null ? DateTime.tryParse(endDate) : null;
    bool activeState = isActive;
    final isEdit = id != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Future<void> pickDate({required bool isFrom}) async {
            //   final picked = await showDatePicker(
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(2000),
            //     lastDate: DateTime(2101),
            //     builder:
            //         (context, child) => Theme(
            //           data: Theme.of(context).copyWith(
            //             colorScheme: ColorScheme.light(
            //               primary: primaryColor,
            //               onPrimary: Colors.white,
            //             ),
            //             textButtonTheme: TextButtonThemeData(
            //               style: TextButton.styleFrom(
            //                 foregroundColor: primaryColor,
            //               ),
            //             ),
            //           ),
            //           child: child!,
            //         ),
            //   );
            //   if (picked == null) return;
            //   setStateDialog(() {
            //     if (isFrom) {
            //       selectedFromDate = picked;
            //       if (selectedEndDate != null &&
            //           selectedEndDate!.isBefore(picked)) {
            //         selectedEndDate = null;
            //       }
            //     } else {
            //       selectedEndDate = picked;
            //     }
            //   });
            // }

            // Widget dateField({
            //   required String label,
            //   required DateTime? value,
            //   required bool isFrom,
            //   required String? Function(String?)? validator,
            // }) {
            //   return TextFormField(
            //     readOnly: true,
            //     controller: TextEditingController(
            //       text: value != null ? "${value.toLocal()}".split(' ')[0] : '',
            //     ),
            //     onTap: () async {
            //       if (!isFrom && selectedFromDate == null) {
            //         MotionToast.warning(
            //           toastAlignment: Alignment.topCenter,
            //           description: const Text(
            //             'Please select a start date first',
            //           ),
            //         ).show(context);
            //         return;
            //       }
            //       await pickDate(isFrom: isFrom);
            //     },
            //     validator: validator,
            //     style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
            //     decoration: InputDecoration(
            //       labelText: label,
            //       labelStyle: GoogleFonts.plusJakartaSans(
            //         fontSize: 13,
            //         color: kMuted,
            //       ),
            //       floatingLabelStyle: GoogleFonts.plusJakartaSans(
            //         fontSize: 12,
            //         color: primaryColor,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       suffixIcon: const Icon(
            //         Icons.calendar_today_outlined,
            //         size: 18,
            //         color: kMuted,
            //       ),
            //       filled: true,
            //       fillColor: Colors.grey.shade50,
            //       contentPadding: const EdgeInsets.symmetric(
            //         horizontal: 14,
            //         vertical: 13,
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(color: kBorder),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(color: kBorder),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(
            //           color: primaryColor,
            //           width: 1.5,
            //         ),
            //       ),
            //       errorBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(color: kDanger),
            //       ),
            //       focusedErrorBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(color: kDanger, width: 1.5),
            //       ),
            //     ),
            //   );
            // }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 460,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
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
                            child: const Icon(
                              Icons.campaign_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
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
                      const SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      const SizedBox(height: 20),

                      dialogField(
                        label: 'Title',
                        controller: titleController,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Please fill out this field'
                                    : null,
                      ),
                      // const SizedBox(height: 12),

                      // // Date row
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: dateField(
                      //         label: 'From Date',
                      //         value: selectedFromDate,
                      //         isFrom: true,
                      //         validator:
                      //             (_) =>
                      //                 selectedFromDate == null
                      //                     ? 'Required'
                      //                     : null,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: dateField(
                      //         label: 'To Date',
                      //         value: selectedEndDate,
                      //         isFrom: false,
                      //         validator:
                      //             (_) =>
                      //                 selectedEndDate == null
                      //                     ? 'Required'
                      //                     : null,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 12),

                      dialogField(
                        label: 'Description',
                        controller: descriptionController,
                        maxLines: 4,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Please fill out this field'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
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
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                              icon: Icon(
                                isEdit ? Icons.save_rounded : Icons.add_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: const EdgeInsets.all(24),
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
                                                child: const Icon(
                                                  Icons.help_outline_rounded,
                                                  color: primaryColor,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(height: 14),
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
                                                    : 'Are you sure you want to save this announcement?',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 22),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      style: OutlinedButton.styleFrom(
                                                        side: const BorderSide(
                                                          color: kBorder,
                                                        ),
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
                                                  const SizedBox(width: 10),
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
                                  title: titleController.text.trim(),
                                  fromDate: DateTime.now(),
                                  toDate: DateTime.now(),
                                  description:
                                      descriptionController.text.trim(),
                                  isActive: activeState,
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

                                  await fetchAnnouncement();

                                  if (!mounted) return;

                                  Navigator.of(context).pop();

                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text(
                                      announcement.id == 0
                                          ? 'Announcement created successfully!'
                                          : 'Announcement updated successfully!',
                                    ),
                                  ).show(context);
                                } catch (e, stackTrace) {
                                  debugPrint('Error saving announcement: $e');
                                  debugPrintStack(stackTrace: stackTrace);

                                  if (!mounted) return;

                                  MotionToast.error(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Failed to save: $e'),
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Announcement',
            itemName: 'announcement',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _announcement.deleteAnnouncement(id);
                await fetchAnnouncement();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Announcement deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete announcement',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
