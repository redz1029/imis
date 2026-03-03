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
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: Text('Scorecard Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PopupMenuButton<int>(
                    //   color: mainBgColor,
                    //   offset: Offset(0, 30),
                    //   onCanceled: () {
                    //     setState(() {
                    //       isMenuOpenYear = false;
                    //     });
                    //   },
                    //   onOpened: () {
                    //     setState(() {
                    //       isMenuOpenYear = true;
                    //     });
                    //   },
                    //   onSelected: (int value) async {
                    //     setState(() {
                    //       selectedYear = (value == -1) ? null : value;
                    //       selectedYearText =
                    //           (value == -1) ? null : value.toString();
                    //       isMenuOpenYear = false;
                    //       isAllYearsSelected = (value == -1);
                    //     });
                    //     try{
                    //       final ro
                    //     }
                    //   },
                    // ),
                    SizedBox(width: 15),
                  ],
                ),
              ],
            ),
            gap16px,
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Period', style: TextStyle(color: grey)),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text('Actions', style: TextStyle(color: grey)),
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
                                .map((index, period) {
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
                                                '${LongDateOnlyConverter().toJson(period.startYear)} - ${LongDateOnlyConverter().toJson(period.endYear)}',
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
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Tooltip(
                                                    message: 'Print Preview',
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .description_outlined,
                                                      ),
                                                      onPressed: () async {
                                                        final kraRoadmapPeriod =
                                                            period.id
                                                                .toString();

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => ProcessCoreSupportPdf(
                                                                  processCoreId:
                                                                      kraRoadmapPeriod,
                                                                ),
                                                          ),
                                                        );
                                                      },
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
                    onPageChanged: (page) => fetchScoredcardReport(page: page),
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
}
