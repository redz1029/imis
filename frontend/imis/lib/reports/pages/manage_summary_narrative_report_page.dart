// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/navigation/navigation_panel.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/pages/view_pdf_summary.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';

class ManageSummaryNarrativeReportPage extends StatefulWidget {
  const ManageSummaryNarrativeReportPage({super.key});

  @override
  ManageSummaryNarrativeReportPageState createState() =>
      ManageSummaryNarrativeReportPageState();
}

class ManageSummaryNarrativeReportPageState
    extends State<ManageSummaryNarrativeReportPage> {
  final _commonService = CommonService(Dio());

  final _dateConverter = const LongDateOnlyConverter();
  final _summaryNarrativeService = SummaryNarrativeService(Dio());
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final _formKey = GlobalKey<FormState>();
  List<PgsSummaryNarrative> reports = [];
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _conclusionsController = TextEditingController();
  final TextEditingController _recommendationsController =
      TextEditingController();
  int periodId = 0;

  List<PgsPeriod> periodList = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  List<PgsSummaryNarrative> summaryList = [];
  List<PgsSummaryNarrative> filteredList = [];
  List<Office> officeList = [];
  String? _selectedPeriod;
  String? _selectedOffice;
  Map<int, String> officeMap = {};
  @override
  void initState() {
    super.initState();
    // _fetchReports();
    () async {
      final period = await _commonService.fetchPgsPeriod();
      final offices = await _deliverableStatusMonitoring.fetchOffices();
      if (!mounted) return;

      setState(() {
        officeList = offices;
        periodList = period;
        officeMap = {for (var office in offices) office.id: office.name};
      });
    }();
    fetchSummaryNarrative();
  }

  Future<void> fetchSummaryNarrative({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _summaryNarrativeService.getSummaryNarrative(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          summaryList = pageList.items;
          filteredList = List.from(summaryList);
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

  String getPeriodLabel(int periodId) {
    final period = periodList.firstWhere(
      (p) => p.id == periodId,
      orElse:
          () => PgsPeriod(0, false, DateTime.now(), DateTime.now(), 'remarks'),
    );

    return "${_dateConverter.toJson(period.startDate)} to ${_dateConverter.toJson(period.endDate)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              () => Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder:
                                      (context) => const NavigationPanel(
                                        initialScreenIndex: 16,
                                      ),
                                ),
                                (route) => false,
                              ),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text(
                            "Back",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBgColor,
                            foregroundColor: primaryTextColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manage Report',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            gap12px,
                            SizedBox(
                              height: 30,
                              width: 300,
                              child: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: lightGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  labelText: 'Search...',
                                  labelStyle: TextStyle(
                                    color: grey,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(Icons.search, size: 20),
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
                                // onChanged: filterSearchResults,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        label: const Text('Office'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: const Text('Period'),
                        size: ColumnSize.L,
                      ),
                      const DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var summary = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(
                                Container(
                                  constraints: BoxConstraints(
                                    // minWidth: 100,
                                    maxWidth: constraints.maxWidth * 0.4,
                                  ),
                                  child: Text(
                                    officeMap[summary.officeId] ??
                                        'Unknown Office',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(getPeriodLabel(summary.pgsPeriodId)),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showReportDialog(summary, index);
                                      },
                                    ),
                                    Tooltip(
                                      message: 'Print Preview',

                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.description_outlined,
                                        ),

                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ViewPdfSummary(
                                                    pgsPeriodId:
                                                        summary.pgsPeriodId
                                                            .toString(),
                                                    officeId:
                                                        summary.officeId
                                                            .toString(),
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    PermissionWidget(
                                      permission:
                                          PermissionString
                                              .editPerformanceGovernanceSystem,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(
                                            255,
                                            221,
                                            79,
                                            79,
                                          ),
                                        ),
                                        onPressed:
                                            () => showDeleteDialog(
                                              summary.id.toString(),
                                            ),
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

                Container(
                  padding: EdgeInsets.all(10),
                  color: secondaryColor,
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
                            (page) => fetchSummaryNarrative(page: page),
                      ),
                      Container(width: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this PGS? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _summaryNarrativeService.deleteSummaryNarrative(id);
                await fetchSummaryNarrative();
                try {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Pgs deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Pgs'));
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

  void showReportDialog(PgsSummaryNarrative report, int index) {
    periodId = report.pgsPeriodId;
    _findingsController.text = report.findings ?? '';
    _conclusionsController.text = report.conclusion ?? '';
    _recommendationsController.text = report.recommendation ?? '';

    _selectedPeriod = report.pgsPeriodId.toString();
    _selectedOffice = report.officeId?.toString();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 900,
            child: SingleChildScrollView(
              child: _buildReportCard(report, index),
            ),
          ),
          actions: [
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
                        title: const Text("Confirm Update"),
                        content: const Text(
                          "Are you sure you want to update this record?",
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
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
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
                    final summaryNarrative = PgsSummaryNarrative(
                      report.id,
                      int.tryParse(_selectedPeriod ?? '0') ?? 0,
                      _findingsController.text,
                      _recommendationsController.text,
                      _conclusionsController.text,
                      int.tryParse(_selectedOffice ?? '0') ?? 0,
                      isDeleted: false,
                      rowVersion: '',
                    );

                    await _summaryNarrativeService.updateSummaryNarrative(
                      summaryNarrative.id,
                      summaryNarrative,
                    );
                    setState(() {
                      fetchSummaryNarrative();
                    });
                    MotionToast.success(
                      description: const Text("Updated Successfully"),
                      toastAlignment: Alignment.topCenter,
                    ).show(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportCard(PgsSummaryNarrative report, int index) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 1000),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      gap16px,
                      Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),

                          Text(
                            'Summary Narative Report - ${getPeriodLabel(report.pgsPeriodId)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),

                          const Spacer(),

                          ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewPdfSummary(
                                        pgsPeriodId: _selectedPeriod.toString(),
                                        officeId: _selectedOffice.toString(),
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.description_outlined,
                              size: 18,
                            ),
                            label: const Text("View PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryTextColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gap48px,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text.rich(
                                      TextSpan(
                                        text: 'Period ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    DropdownSearch<PgsPeriod>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        fit: FlexFit.loose,
                                        menuProps: const MenuProps(
                                          backgroundColor: Colors.white,
                                          elevation: 2,
                                        ),
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            hintText: 'Search Period...',
                                            hintStyle: TextStyle(fontSize: 13),
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        itemBuilder:
                                            (
                                              context,
                                              period,
                                              isSelected,
                                            ) => ListTile(
                                              tileColor: Colors.white,
                                              title: Text(
                                                "${LongDateOnlyConverter().toJson(period.startDate)} - ${LongDateOnlyConverter().toJson(period.endDate)}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                      ),

                                      items: periodList,
                                      itemAsString:
                                          (period) =>
                                              "${LongDateOnlyConverter().toJson(period.startDate)} - ${LongDateOnlyConverter().toJson(period.endDate)}",
                                      selectedItem:
                                          _selectedPeriod == null
                                              ? null
                                              : periodList.firstWhere(
                                                (office) =>
                                                    office.id.toString() ==
                                                    _selectedPeriod,
                                                orElse:
                                                    () => PgsPeriod(
                                                      0,
                                                      false,
                                                      DateTime.now(),
                                                      DateTime.now(),
                                                      'remarks',
                                                    ),
                                              ),

                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPeriod =
                                              value?.id.toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                  labelText: 'Select Period',
                                                  labelStyle: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8,
                                                      ),
                                                ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text.rich(
                                      TextSpan(
                                        text: 'Office ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    DropdownSearch<Office>(
                                      popupProps: PopupProps.menu(
                                        showSearchBox: true,
                                        fit: FlexFit.loose,
                                        menuProps: const MenuProps(
                                          backgroundColor: Colors.white,
                                          elevation: 2,
                                        ),
                                        searchFieldProps: TextFieldProps(
                                          decoration: InputDecoration(
                                            hintText: 'Search Office Name...',
                                            hintStyle: TextStyle(fontSize: 13),
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        itemBuilder:
                                            (context, office, isSelected) =>
                                                ListTile(
                                                  tileColor: Colors.white,
                                                  title: Text(
                                                    office.name,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                      items: officeList,
                                      itemAsString: (office) => office.name,
                                      selectedItem:
                                          _selectedOffice == null
                                              ? null
                                              : officeList.firstWhere(
                                                (office) =>
                                                    office.id.toString() ==
                                                    _selectedOffice,
                                                orElse:
                                                    () => Office(
                                                      id: 0,
                                                      name: 'Unknown',
                                                      officeTypeId: 0,
                                                      parentOfficeId: 0,
                                                      isActive: true,
                                                      isDeleted: false,
                                                    ),
                                              ),

                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOffice =
                                              value?.id.toString();
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                  labelText: 'Select Office',
                                                  labelStyle: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.transparent,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8,
                                                      ),
                                                ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    gap48px,
                    _buildReportSection(
                      icon: Icons.error_outline_rounded,
                      iconColor: primaryTextColor,
                      title: "Key Findings",
                      controller: _findingsController,
                      decorationColor: Color(0xFFF5FBFF),
                      borderColor: Colors.blue[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      icon: Icons.check_circle_outline,
                      iconColor: primaryTextColor,
                      title: "Conclusions",
                      controller: _conclusionsController,
                      decorationColor: Color(0xFFF6FFF8),
                      borderColor: Colors.green[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      title: "Recommendations",
                      icon: Icons.trending_up,
                      iconColor: primaryTextColor,
                      controller: _recommendationsController,
                      decorationColor: Color(0xFFFFFAF3),
                      borderColor: Colors.orange[100],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection({
    required String title,
    required TextEditingController controller,
    IconData icon = Icons.description_outlined,
    Color iconColor = Colors.black54,
    Color? decorationColor,
    Color? borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: decorationColor ?? Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor ?? Colors.grey.shade400),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 14),
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
