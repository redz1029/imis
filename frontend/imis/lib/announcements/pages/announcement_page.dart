import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/announcements/models/announcement.dart';
import 'package:imis/announcements/services/announcement_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/custom_toggle.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  AnnouncementPageState createState() => AnnouncementPageState();
}

class AnnouncementPageState extends State<AnnouncementPage> {
  final _announcement = AnnouncementService(Dio());
  final FocusNode isSearchfocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final int _currentPage = 1;
  final int _pageSize = 15;
  final int _totalCount = 0;
  final bool _isLoading = false;
  List<Announcement> filteredList = [];
  final Dio dio = Dio();
  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('View Report'),
        backgroundColor: mainBgColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 300,
                      child: TextField(
                        focusNode: isSearchfocus,
                        // controller: searchController,
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
                      ),
                    ),
                    if (!isMinimized)
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
                const SizedBox(height: 20),
                Expanded(
                  child: DataTable2(
                    columnSpacing: isMobile ? 8 : 12,
                    headingRowColor: WidgetStatePropertyAll(secondaryColor),
                    dataRowColor: WidgetStatePropertyAll(mainBgColor),
                    headingTextStyle: const TextStyle(color: grey),
                    horizontalMargin: 12,
                    minWidth: 700,
                    fixedTopRows: 1,
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade100),
                    ),
                    columns: [
                      DataColumn2(label: const Text('#'), fixedWidth: 40),
                      DataColumn2(
                        label: const Text('Title'),
                        size: ColumnSize.L,
                      ),

                      const DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var announcement = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 100,
                                    maxWidth: constraints.maxWidth * 0.4,
                                  ),
                                  child: Text(
                                    '',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ),

                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {},
                                    ),
                                    Tooltip(
                                      message: 'Print Preview',

                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.description_outlined,
                                        ),

                                        onPressed: () async {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.all(10),
                //   color: secondaryColor,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       PaginationInfo(
                //         currentPage: _currentPage,
                //         totalItems: _totalCount,
                //         itemsPerPage: _pageSize,
                //       ),
                //       PaginationControls(
                //         currentPage: _currentPage,
                //         totalItems: _totalCount,
                //         itemsPerPage: _pageSize,
                //         isLoading: _isLoading,
                //         onPageChanged:
                //             (page) => fetchSummaryNarrative(page: page),
                //       ),
                //       Container(width: 60),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showAnnouncementFormDialog({
    String? id,
    String? title,
    DateTime? fromDate,
    DateTime? endDate,
    String? description,
    bool isActive = false,
  }) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(
      text: description,
    );

    DateTime? selectedFromDate = fromDate;
    DateTime? selectedEndDate = endDate;

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
                          labelText: 'From Date',
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
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedFromDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedFromDate = picked;

                              // reset end date if it's before from date
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
                          labelText: 'End Date',
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

                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedEndDate ?? selectedFromDate!,
                            firstDate: selectedFromDate!,
                            lastDate: DateTime(2100),
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

                    // Active Toggle
                    CustomToggle(
                      label: "Active",
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
                          fromDateDate: selectedFromDate!,
                          toDate: selectedEndDate!,
                          description: descriptionController.text,
                          isActive: isActive,
                          rowVersion: '',
                          isDeleted: false,
                        );

                        await _announcement.createAnnouncement(announcement);
                        setState(() {});
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
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
