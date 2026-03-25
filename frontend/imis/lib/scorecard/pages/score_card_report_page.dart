// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/roadmap/kra_period_roadmap/services/kra_period_roadmap_service.dart';
import 'package:imis/scorecard/pages/process_core_support_pdf.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';

class ScoreCardReportPage extends StatefulWidget {
  const ScoreCardReportPage({super.key});

  @override
  ScoreCardReportPageState createState() => ScoreCardReportPageState();
}

class ScoreCardReportPageState extends State<ScoreCardReportPage> {
  final _paginationUtils = PaginationUtil(Dio());
  final _pgsPeriodService = KraPeriodRoadmapService(Dio());
  late FilterSearchResultUtil<KraRoadmapPeriod> pgsPeriodSearchUtil;
  List<KraRoadmapPeriod> kraPeriodList = [];
  List<KraRoadmapPeriod> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  bool? isMenuOpenYear;
  int? selectedYear;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String? selectedYearText;
  bool isAllYearsSelected = false;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchScoredcardReport();
    pgsPeriodSearchUtil = FilterSearchResultUtil<KraRoadmapPeriod>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().pgsperiod,
      pageSize: _pageSize,
      fromJson: (json) => KraRoadmapPeriod.fromJson(json),
    );

    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchScoredcardReport({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _pgsPeriodService.getKraPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          kraPeriodList = pageList.items;
          filteredList = List.from(kraPeriodList);
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

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: const Text(
          'Scorecard Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap16px,
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
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '#',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Period',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Actions',
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
                              : ListView.separated(
                                itemCount: filteredList.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                itemBuilder: (context, index) {
                                  final period = filteredList[index];
                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final periodText =
                                      '${LongDateOnlyConverter().toJson(period.startYear)} - ${LongDateOnlyConverter().toJson(period.endYear)}';

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // #
                                          Expanded(
                                            flex: 1,
                                            child: Text('$itemNumber'),
                                          ),

                                          // Period
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              periodText,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          // Actions
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Print Preview',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    onPressed: () {
                                                      openProcessCoreSupport(
                                                        period.id.toString(),
                                                        'Process(Core & Support)',
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$itemNumber. $periodText',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.description_outlined,
                                            size: 18,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () {
                                            openProcessCoreSupport(
                                              period.id.toString(),
                                              'Process(Core & Support)',
                                            );
                                          },
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
                                (page) => fetchScoredcardReport(page: page),
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
    );
  }
}
