import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/navigation/navigation_panel.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/date_time_converter.dart';

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
  List<PgsSummaryNarrative> _reports = [];
  List<TextEditingController> _findingsControllers = [];
  List<TextEditingController> _conclusionControllers = [];
  List<TextEditingController> _recommendationControllers = [];
  List<PgsPeriod> _periods = [];

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
  }

  Future<void> _fetchReports() async {
    try {
      final List rawNarratives =
          await _summaryNarrativeService.getSummaryNarratives();
      final List<PgsSummaryNarrative> narratives =
          rawNarratives.map((n) => PgsSummaryNarrative.fromJson(n)).toList();

      setState(() {
        _reports = narratives;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const NavigationPanel(initialScreenIndex: 17),
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
                    side: BorderSide(color: Colors.grey.shade400, width: 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'View Reports',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            gap32px,
            ..._reports.asMap().entries.map((entry) {
              final index = entry.key;
              final report = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: _buildReportCard(report, index),
              );
            }),
          ],
        ),
      ),
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
              // Gray header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
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

                    Flexible(fit: FlexFit.tight, child: Container()),

                    ElevatedButton.icon(
                      onPressed: () async {},
                      icon: const Icon(Icons.description_outlined, size: 18),
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
