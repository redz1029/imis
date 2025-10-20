// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/pages/view_pdf_summary.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class ViewSummaryNarrativeReportPage extends StatefulWidget {
  const ViewSummaryNarrativeReportPage({super.key});

  @override
  ViewSummaryNarrativeReportPageState createState() =>
      ViewSummaryNarrativeReportPageState();
}

class ViewSummaryNarrativeReportPageState
    extends State<ViewSummaryNarrativeReportPage> {
  final _commonService = CommonService(Dio());
  final _dateConverter = const LongDateOnlyConverter();
  final _summaryNarrativeService = SummaryNarrativeService(Dio());
  List<PgsSummaryNarrative> reports = [];
  final TextEditingController _findingsControllers = TextEditingController();
  final TextEditingController _conclusionControllers = TextEditingController();
  final TextEditingController _recommendationControllers =
      TextEditingController();
  final TextEditingController _remakrsController = TextEditingController();
  List<PgsPeriod> _periods = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  List<PgsSummaryNarrative> summaryList = [];
  List<PgsSummaryNarrative> filteredList = [];
  List<Office> officeList = [];
  Map<int, String> officeMap = {};
  String? selectedPeriod;
  bool isMenuOpenPeriod = false;
  String selectedPeriodText = "Select Period";
  final _formKey = GlobalKey<FormState>();
  int selectedTabIndex = 0;
  String? selectedOffice;

  final List<String> tabs = ["View Auditor Reports", "View Overall Reports"];
  @override
  void initState() {
    super.initState();
    // _fetchReports();
    () async {
      final period = await _commonService.fetchPgsPeriod();
      final offices = await _commonService.fetchOffices();
      if (!mounted) return;

      setState(() {
        _periods = period;
        officeList = offices;
        officeMap = {for (var office in offices) office.id: office.name};
      });
    }();
    fetchReportsForSelectedTab();
  }

  Future<void> fetchReportsForSelectedTab({
    int page = 1,
    String? searchQuery,
  }) async {
    setState(() => _isLoading = true);

    try {
      if (selectedTabIndex == 0) {
        // Fetch auditor reports
        final pageList = await _summaryNarrativeService.getSummaryNarrative(
          page: _currentPage,
          pageSize: _pageSize,
        );
        setState(() {
          summaryList = pageList.items;
          filteredList = List.from(summaryList);
          _totalCount = pageList.totalCount;
        });
      } else {
        // Fetch head auditor (overall) reports
        final pageList = await _summaryNarrativeService
            .getSummaryNarrativeHeadAuditor(
              page: _currentPage,
              pageSize: _pageSize,
            );
        setState(() {
          summaryList = pageList.items;
          filteredList = List.from(summaryList);
          _totalCount = pageList.totalCount;
        });
      }
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String getPeriodLabel(int periodId) {
    final period = _periods.firstWhere(
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
      appBar: AppBar(
        title: const Text('Report Information'),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(tabs.length, (index) {
                        final bool isSelected = selectedTabIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() => selectedTabIndex = index);
                              await fetchReportsForSelectedTab();
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 18,
                              ),
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? primaryTextColor
                                          : Colors.grey.shade700,

                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                gap24px,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                    ),

                    Flexible(fit: FlexFit.tight, child: Container()),
                    if (selectedTabIndex == 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PopupMenuButton<String>(
                                  color: mainBgColor,
                                  offset: const Offset(0, 30),
                                  onCanceled: () {
                                    setState(() {
                                      isMenuOpenPeriod = false;
                                    });
                                  },
                                  onOpened: () {
                                    setState(() {
                                      isMenuOpenPeriod = true;
                                    });
                                  },
                                  onSelected: (String value) {
                                    setState(() {
                                      selectedPeriod = value;

                                      final selected = _periods.firstWhere(
                                        (period) =>
                                            period.id.toString() ==
                                            selectedPeriod,
                                        orElse:
                                            () => PgsPeriod(
                                              0,
                                              false,
                                              DateTime.now(),
                                              DateTime.now(),
                                              'remarks',
                                            ),
                                      );

                                      selectedPeriodText =
                                          "${_dateConverter.toJson(selected.startDate)} - ${_dateConverter.toJson(selected.endDate)}";
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return _periods.map<PopupMenuItem<String>>((
                                      period,
                                    ) {
                                      final formattedStart = _dateConverter
                                          .toJson(period.startDate);
                                      final formattedEnd = _dateConverter
                                          .toJson(period.endDate);

                                      return PopupMenuItem<String>(
                                        value: period.id.toString(),
                                        child: Text(
                                          '$formattedStart - $formattedEnd',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: FilterButton(
                                    label: selectedPeriodText,
                                    isActive: isMenuOpenPeriod,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed:
                                selectedPeriod != null
                                    ? () async {
                                      showRemarksDialog();
                                    }
                                    : null,

                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Create Overall Report',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
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

                      if (selectedTabIndex == 0) ...[
                        DataColumn2(
                          label: const Text('Office'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: const Text('Period'),
                          size: ColumnSize.L,
                        ),
                      ] else ...[
                        DataColumn2(
                          label: const Text('Report (Period)'),
                          size: ColumnSize.L,
                        ),
                      ],

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

                              if (selectedTabIndex == 0) ...[
                                DataCell(
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: 100,
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
                              ] else ...[
                                DataCell(
                                  Text(
                                    "Report - ${getPeriodLabel(summary.pgsPeriodId)}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],

                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        if (selectedTabIndex == 0) {
                                          showReportDialog(summary);
                                        } else {
                                          showRemarksDialog(summary);
                                        }
                                      },
                                    ),
                                    Tooltip(
                                      message: 'Print Preview',
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.description_outlined,
                                        ),
                                        onPressed: () async {
                                          if (selectedTabIndex == 1) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => ViewPdfSummary(
                                                      pgsPeriodId:
                                                          summary.pgsPeriodId
                                                              .toString(),
                                                    ),
                                              ),
                                            );
                                          } else {
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
                                          }
                                        },
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
                            (page) => fetchReportsForSelectedTab(page: page),
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

  void showReportDialog(PgsSummaryNarrative report) {
    _findingsControllers.text = report.findings ?? '';
    _conclusionControllers.text = report.conclusion ?? '';
    _recommendationControllers.text = report.recommendation ?? '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(child: _buildReportCard(report)),
        );
      },
    );
  }

  Widget _buildReportCard(PgsSummaryNarrative report) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black87),
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
                          'Summary Narrative Report - ${getPeriodLabel(report.pgsPeriodId)}',
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
                                      pgsPeriodId:
                                          report.pgsPeriodId.toString(),
                                      officeId: report.officeId.toString(),
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officeMap[report.officeId] ?? 'Unknown Office',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    gap48px,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: primaryTextColor,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Executive Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Text(
                            'This report analyzes the implementation and progress of the Performance Governance System (PGS) '
                            'for ${getPeriodLabel(report.pgsPeriodId)}. It highlights key governance indicators, institutional performance, and alignment with '
                            'strategic objectives. The analysis covers leadership commitment, strategy execution, stakeholder '
                            'engagement, and overall organizational impact in driving sustainable reforms and improvements.',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),

                    gap48px,
                    _buildReportSection(
                      icon: Icons.error_outline_rounded,
                      iconColor: primaryTextColor,
                      title: "Key Findings",
                      controller: _findingsControllers,
                      decorationColor: Color(0xFFF5FBFF),
                      borderColor: Colors.blue[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      icon: Icons.check_circle_outline,
                      iconColor: primaryTextColor,
                      title: "Conclusions",
                      controller: _conclusionControllers,
                      decorationColor: Color(0xFFF6FFF8),
                      borderColor: Colors.green[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      title: "Recommendations",
                      icon: Icons.trending_up,
                      iconColor: primaryTextColor,
                      controller: _recommendationControllers,
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

  void showRemarksDialog([PgsSummaryNarrative? summary]) {
    if (summary != null) {
      _remakrsController.text = summary.recommendation ?? '';
      selectedPeriod = summary.pgsPeriodId.toString();
      selectedOffice = summary.officeId.toString();
    } else {
      _remakrsController.clear();
      selectedPeriod = null;
      selectedOffice = null;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 900,
            child: SingleChildScrollView(child: _buildRemarksCard(summary)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                _remakrsController.clear();
                selectedOffice = null;
                selectedPeriod = null;

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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
                      0,
                      int.tryParse(selectedPeriod ?? '0') ?? 0,
                      _findingsControllers.text,
                      _remakrsController.text,
                      _conclusionControllers.text,
                      null,
                      isDeleted: false,
                      rowVersion: '',
                    );

                    await _summaryNarrativeService
                        .addSummaryNarrativeAuditorHead(summaryNarrative);
                    _remakrsController.clear();

                    selectedOffice = null;

                    selectedPeriod = null;
                    MotionToast.success(
                      description: const Text("Saved Successfully"),
                      toastAlignment: Alignment.topCenter,
                    ).show(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRemarksCard(PgsSummaryNarrative? summary) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 500),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Form(
            key: _formKey,
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
                            onPressed: () {
                              _remakrsController.clear();

                              Navigator.of(context).pop();
                            },
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
                            'Summary Narrative Report - ${summary != null ? getPeriodLabel(summary.pgsPeriodId) : selectedPeriodText}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildReportSection(
                        title: "Remarks/Recommendations",
                        icon: Icons.trending_up,
                        iconColor: primaryTextColor,
                        controller: _remakrsController,
                        decorationColor: Color(0xFFFFFAF3),
                        borderColor: Colors.orange[100],
                        readOnly: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    bool readOnly = true,
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
              child: TextFormField(
                readOnly: readOnly,
                controller: controller,
                style: TextStyle(fontSize: 14),
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: grey),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
