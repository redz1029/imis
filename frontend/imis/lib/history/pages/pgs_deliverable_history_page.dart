import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/history/models/pgs_deliverable_history.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:intl/intl.dart';
import '../../performance_governance_system/enum/pgs_status.dart';
import '../../performance_governance_system/key_result_area/models/key_result_area.dart';
import '../../utils/http_util.dart';

class PgsDeliverableHistoryPage extends StatefulWidget {
  const PgsDeliverableHistoryPage({super.key});

  @override
  PgsDeliverableHistoryPageState createState() =>
      PgsDeliverableHistoryPageState();
}

class PgsDeliverableHistoryPageState extends State<PgsDeliverableHistoryPage> {
  final _paginationUtils = PaginationUtil(Dio());

  final FocusNode isSearchfocus = FocusNode();
  final List<String> statusOptions = ['Active', 'Inactive'];
  String statusFilter = 'Active';
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGroupedfilteredList = [];

  List<PgsDeliverables> deliverablesList = [];
  List<PgsDeliverables> filteredListDeliverables = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchHistoryGrouped();
    fetchdeliverables();
    mapDeliverableIdToDeliverableName();
  }

  Future<void> fetchHistoryGrouped({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils
          .fetchPaginatedData<PgsDeliverableHistoryGrouped>(
            endpoint: ApiEndpoint().pgsDeliverableScoreHistoryGrouped,
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            fromJson: (json) => PgsDeliverableHistoryGrouped.fromJson(json),
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          deliverableHistoryGrouped = pageList.items;
          deliverableHistoryGroupedfilteredList = List.from(
            deliverableHistoryGrouped,
          );
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

  void showFormDialog(int pgsDeliverableId) async {
    final groupedItem = deliverableHistoryGrouped.firstWhere(
      (item) => item.pgsDeliverableId == pgsDeliverableId,
      orElse: () => PgsDeliverableHistoryGrouped(pgsDeliverableId, null),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: const Text('Score History'),
          content: SizedBox(
            width: 600,
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (groupedItem.scoreHistory != null &&
                      groupedItem.scoreHistory!.isNotEmpty)
                    _buildHistoryTable(groupedItem.scoreHistory!)
                  else
                    const Text('No history available for this deliverable'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryTable(List<PgsDeliverableHistory> items) {
    items.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.grey.shade200,
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Score',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        ...items.map((item) {
          final date = item.date;
          final datePart = DateFormat('MMM, dd, yyyy').format(date);
          final timePart = DateFormat('hh:mm a').format(date);

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: datePart),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: timePart,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    item.score.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Future<void> fetchdeliverables() async {
    var url = ApiEndpoint().deliverables;

    try {
      var response = await AuthenticatedRequest.get(dio, url);
      debugPrint("Raw User response: ${response.data}");

      if (response.statusCode == 200 && response.data is List) {
        List<PgsDeliverables> data =
            (response.data as List)
                .map((e) => PgsDeliverables.fromJson(e))
                .toList();

        setState(() {
          deliverablesList = data;
        });

        debugPrint("deliverable list loaded: ${data.length}");
        mapDeliverableIdToDeliverableName();
      }
    } catch (e) {
      debugPrint("fetchdeliverableList Error: $e");
    }
  }

  void mapDeliverableIdToDeliverableName() {
    for (var deliverables in deliverableHistoryGrouped) {
      deliverablesList.firstWhere(
        (deliverable) => deliverable.id == deliverables.pgsDeliverableId,
        orElse:
            () => PgsDeliverables(
              0,
              KeyResultArea(0, 'name', 'remarks', false),
              0,
              'deliverableName',
              'kraDescription',
              true,
              DateTime.now(),
              0,
              'disapproveRemarkes',
              false,
              PgsStatus.notStarted,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(title: Text('History'), backgroundColor: mainBgColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      labelText: 'Search History',
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
                gap4,
                SizedBox(
                  height: 30,
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: mainBgColor,
                    value: statusFilter,
                    onChanged: (value) {
                      setState(() {
                        statusFilter = value!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                    ),
                    items:
                        statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                  ),
                ),
                Spacer(),

                if (!isMinimized)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () => {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Add New', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
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
                            'Deliverable Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'History Count',
                            style: TextStyle(color: grey),
                          ),
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
                            deliverableHistoryGroupedfilteredList
                                .asMap()
                                .map((index, history) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  final deliverableName = deliverablesList
                                      .firstWhere(
                                        (deliverable) =>
                                            deliverable.id ==
                                            history.pgsDeliverableId,
                                        orElse:
                                            () => PgsDeliverables(
                                              0,
                                              KeyResultArea(
                                                0,
                                                'name',
                                                'remarks',
                                                false,
                                              ),
                                              0,
                                              'deliverableName',
                                              'kraDescription',
                                              true,
                                              DateTime.now(),
                                              0,
                                              'disapproveRemarkes',
                                              false,
                                              PgsStatus.notStarted,
                                            ),
                                      );
                                  final name = deliverableName.deliverableName;
                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 16,
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
                                                name,
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
                                                history.scoreHistory?.length
                                                        .toString() ??
                                                    '0',
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
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        history
                                                            .pgsDeliverableId,
                                                      );
                                                    },
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
                    onPageChanged: (page) => fetchHistoryGrouped(page: page),
                  ),
                  Container(width: 60),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMinimized
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => {},
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}

class PgsDeliverableHistoryGrouped {
  final int pgsDeliverableId;
  final List<PgsDeliverableHistory>? scoreHistory;

  PgsDeliverableHistoryGrouped(this.pgsDeliverableId, this.scoreHistory);

  factory PgsDeliverableHistoryGrouped.fromJson(Map<String, dynamic> json) {
    return PgsDeliverableHistoryGrouped(
      json['pgsDeliverableId'] as int,
      json['scoreHistory'] != null
          ? (json['scoreHistory'] as List)
              .map((e) => PgsDeliverableHistory.fromJson(e))
              .toList()
          : null,
    );
  }
}
