import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/pages/view_pdf_summary.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/pagination_controls.dart';

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
  List<TextEditingController> _findingsControllers = [];
  List<TextEditingController> _conclusionControllers = [];
  List<TextEditingController> _recommendationControllers = [];
  List<PgsPeriod> _periods = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  List<PgsSummaryNarrative> summaryList = [];
  List<PgsSummaryNarrative> filteredList = [];
  @override
  void initState() {
    super.initState();
    _fetchReports();
    () async {
      final period = await _commonService.fetchPgsPeriod();

      if (!mounted) return;

      setState(() {
        _periods = period;
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

  Future<void> _fetchReports() async {
    try {
      final List rawNarratives =
          await _summaryNarrativeService.getSummaryNarratives();
      final List<PgsSummaryNarrative> narratives =
          rawNarratives.map((n) => PgsSummaryNarrative.fromJson(n)).toList();

      setState(() {
        reports = narratives;
        _findingsControllers =
            narratives
                .map(
                  (report) =>
                      TextEditingController(text: report.findings ?? ''),
                )
                .toList();
        _conclusionControllers =
            narratives
                .map(
                  (report) =>
                      TextEditingController(text: report.conclusion ?? ''),
                )
                .toList();
        _recommendationControllers =
            narratives
                .map(
                  (report) =>
                      TextEditingController(text: report.recommendation ?? ''),
                )
                .toList();
      });
    } catch (e) {
      debugPrint("Error fetching narratives: $e");
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
      appBar: AppBar(title: Text('View Report'), backgroundColor: mainBgColor),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Bar
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
                    // onChanged: filterSearchResults,
                  ),
                ),

                Spacer(),
              ],
            ),
            gap24px,

            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Performance Report',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Period', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Center(
                              child: Text(
                                'Actions',
                                style: TextStyle(color: grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            filteredList
                                .asMap()
                                .map((index, summary) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                itemNumber.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                'Performance Report',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                getPeriodLabel(
                                                  summary.pgsPeriodId,
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      showReportDialog(
                                                        summary,
                                                        index,
                                                      );
                                                    },
                                                  ),

                                                  Tooltip(
                                                    message: 'Print Preview',

                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .description_outlined,
                                                      ),

                                                      onPressed: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => ViewPdfSummary(
                                                                  pgsPeriodId:
                                                                      summary
                                                                          .pgsPeriodId
                                                                          .toString(),
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: primaryColor,
                                                    ),
                                                    onPressed: () => {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                      ),
                    ),
                  ),
                ],
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
                    onPageChanged: (page) => fetchSummaryNarrative(page: page),
                  ),
                  Container(width: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showReportDialog(PgsSummaryNarrative report, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(child: _buildReportCard(report, index)),
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
                          'Performance Report - ${getPeriodLabel(report.pgsPeriodId)}',
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
                          child: const Text(
                            'This report analyzes the implementation and progress of the Performance Governance System (PGS) '
                            'for Q2 2024. It highlights key governance indicators, institutional performance, and alignment with '
                            'strategic objectives. The analysis covers leadership commitment, strategy execution, stakeholder '
                            'engagement, and overall organizational impact in driving sustainable reforms and improvements.',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),

                    gap48px,
                    _buildReportSection(
                      icon: Icons.error_outline_rounded,
                      iconColor: primaryTextColor,
                      title: "Key Findings",
                      controller: _findingsControllers[index],
                      decorationColor: Color(0xFFF5FBFF),
                      borderColor: Colors.blue[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      icon: Icons.check_circle_outline,
                      iconColor: primaryTextColor,
                      title: "Conclusions",
                      controller: _conclusionControllers[index],
                      decorationColor: Color(0xFFF6FFF8),
                      borderColor: Colors.green[100],
                    ),
                    const SizedBox(height: 24),
                    _buildReportSection(
                      title: "Recommendations",
                      icon: Icons.trending_up,
                      iconColor: primaryTextColor,
                      controller: _recommendationControllers[index],
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
                readOnly: true,
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
