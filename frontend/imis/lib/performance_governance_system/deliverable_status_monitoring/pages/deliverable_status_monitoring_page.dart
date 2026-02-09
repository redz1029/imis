// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/reports/models/pgs_summary_narrative.dart';
import 'package:imis/reports/services/summary_narrative_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/accomplishment_auditor_widget.dart';
import 'package:imis/widgets/breakthrough_widget.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:imis/constant/constant.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../reports/pages/manage_summary_narrative_report_page.dart';
import '../../../user/models/user_registration.dart';
import '../../../utils/api_endpoint.dart';
import '../../../utils/auth_util.dart';
import '../../../utils/date_time_converter.dart';
import '../../../utils/http_util.dart';
import '../../../utils/permission_string.dart';
import '../../models/pgs_deliverable_score_history.dart';
import '../../pgs_period/models/pgs_period.dart';
import '../models/pgs_deliverable_accomplishment.dart';
import '../models/pgs_filter.dart';
import '../services/deliverable_status_monitoring_service.dart';

class DeliverableStatusMonitoringPage extends StatefulWidget {
  const DeliverableStatusMonitoringPage({super.key});

  @override
  State<DeliverableStatusMonitoringPage> createState() =>
      _DeliverableStatusMonitoringPageState();
}

class _DeliverableStatusMonitoringPageState
    extends State<DeliverableStatusMonitoringPage> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _headerHorizontalController = ScrollController();
  final _dateConverter = const LongDateOnlyConverter();
  TextEditingController scoreRangeToController = TextEditingController();
  TextEditingController scoreRangeFromController = TextEditingController();
  TextEditingController pageController = TextEditingController();
  TextEditingController pageSizeController = TextEditingController();
  final TextEditingController _findingsController = TextEditingController();
  final TextEditingController _conclusionsController = TextEditingController();
  final TextEditingController _recommendationsController =
      TextEditingController();
  final _summaryNarrativeService = SummaryNarrativeService(Dio());
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _menuScoreRangeKey = GlobalKey();
  final GlobalKey _menuPageKey = GlobalKey();
  final int dataColumns = 8;
  final double numberColumnWidth = 70;
  final double dataColumnWidth = 280;
  final dio = Dio();
  final _commonService = CommonService(Dio());
  final _deliverableStatusMonitoring = DeliverableStatusMonitoringService(
    Dio(),
  );
  final permissionService = PermissionService();
  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<PgsDeliverableHistoryGrouped> deliverableHistoryGrouped = [];
  String userId = "";
  final List<String> headers = [
    "PERIOD",
    "OFFICE",
    "PROCESS (CORE & SUPPORT)",
    "KRA",
    "DIRECT",
    "DELIVERABLES",
    "BY WHEN",
    "ACTIONS",
  ];
  bool isMenuOpenOffice = false;
  bool isMenuOpenPeriod = false;
  bool isMenuOpenPeriodCreateReport = false;
  bool isMenuOpenKra = false;
  bool isMenuOpenType = false;
  bool isMenuScoreRange = false;
  bool isMenuOpenPage = false;
  List<KeyResultArea> kraListOptions = [];
  int? selectedKra;

  List<Office> officeList = [];
  String? _selectedOfficeId;
  bool? isDirect;
  List<PgsPeriod> periodList = [];
  int? selectedPeriod;
  int? selectedPeriodCreateReport;
  String? selectedPeriodText;
  String? selectedPeriodTextCreateReport;
  String? _selectedPeriod;
  String? _selectedOffice;
  int? officeId;
  int? periodId;
  bool _hasAvailableDeliverables = false;
  @override
  @override
  void initState() {
    super.initState();
    _headerHorizontalController.addListener(_syncHeaderScroll);
    _horizontalController.addListener(_syncBodyScroll);
    () async {
      final offices = await _deliverableStatusMonitoring.fetchOffices();
      final period = await _commonService.fetchPgsPeriod();
      final kra = await _commonService.fetchKra();
      if (!mounted) return;

      setState(() {
        officeList = offices;
        periodList = period;
        kraListOptions = kra;
      });
    }();
    fetchFilteredPgsList();
    _loadCurrentUserId();
  }

  void _syncHeaderScroll() {
    if (_horizontalController.offset != _headerHorizontalController.offset) {
      _horizontalController.jumpTo(_headerHorizontalController.offset);
    }
  }

  void _syncBodyScroll() {
    if (_headerHorizontalController.offset != _horizontalController.offset) {
      _headerHorizontalController.jumpTo(_horizontalController.offset);
    }
  }

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkDeliverablesAvailability(Function setDialogState) async {
    if (_selectedOffice == null || _selectedPeriod == null) {
      setState(() {
        _hasAvailableDeliverables = false;
      });
      return;
    }

    try {
      officeId = int.tryParse(_selectedOffice!) ?? 0;
      periodId = int.tryParse(_selectedPeriod!) ?? 0;

      final filter = PgsFilter(
        periodId,
        officeId,
        null,
        null,
        null,
        null,
        null,
        null,
      );

      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["items"] as List<dynamic>? ?? [];

        setDialogState(() {
          _hasAvailableDeliverables = items.isNotEmpty;
        });
      } else {
        setDialogState(() {
          _hasAvailableDeliverables = false;
        });
      }
    } catch (e) {
      debugPrint("Error checking deliverables availability: $e");
      setDialogState(() {
        _hasAvailableDeliverables = false;
      });
    }
    setDialogState(() {});
  }

  Future<bool> _hasCompleteAccomplishmentData(
    int deliverableId,
    int expectedPeriods,
  ) async {
    try {
      final List<PgsDeliverableAccomplishment> accomplishments =
          await _deliverableStatusMonitoring.fetchAccomplishments(
            deliverableId,
          );

      if (accomplishments.isEmpty || accomplishments.length < expectedPeriods) {
        return false;
      }

      int completedPeriods = 0;

      for (var i = 0; i < accomplishments.length; i++) {
        var accomplishment = accomplishments[i];

        final status = accomplishment.remarks;

        final attachmentPath = accomplishment.attachmentPath;

        bool hasValidStatus = status != null && status.toString().isNotEmpty;

        bool hasValidAttachment =
            attachmentPath != null && attachmentPath.isNotEmpty;

        bool isComplete = hasValidStatus && hasValidAttachment;

        if (isComplete) {
          completedPeriods++;
        } else {
          if (!hasValidStatus) debugPrint("    - Missing status: $status");
        }
      }

      bool allComplete = completedPeriods >= expectedPeriods;

      return allComplete;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _headerHorizontalController.dispose();
    super.dispose();
  }

  Future<void> fetchFilteredPgsList() async {
    try {
      int? scoreFrom =
          scoreRangeFromController.text.isNotEmpty
              ? int.tryParse(scoreRangeFromController.text)
              : null;
      int? scoreTo =
          scoreRangeToController.text.isNotEmpty
              ? int.tryParse(scoreRangeToController.text)
              : null;

      int? page =
          pageController.text.isNotEmpty
              ? int.tryParse(pageController.text)
              : null;
      int? pageSize =
          pageSizeController.text.isNotEmpty
              ? int.tryParse(pageSizeController.text)
              : null;

      final filter = PgsFilter(
        selectedPeriod,
        int.tryParse(_selectedOfficeId ?? ''),
        selectedKra,
        isDirect,
        scoreFrom,
        scoreTo,
        page,
        pageSize,
      );

      final queryParams =
          filter.toJson()..removeWhere((key, value) => value == null);

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().filterBy,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items = data["items"] as List<dynamic>? ?? [];

        List<Map<String, dynamic>> formattedData =
            items.map((item) {
              String formattedByWhen = '';
              if (item['byWhen'] != null &&
                  item['byWhen'].toString().isNotEmpty) {
                try {
                  DateTime date = DateTime.parse(item['byWhen'].toString());
                  formattedByWhen = DateFormat('MMMM, yyyy').format(date);
                } catch (e) {
                  formattedByWhen = item['byWhen'].toString();
                }
              }

              deliverableHistoryGrouped.firstWhere(
                (h) => h.pgsDeliverableId == item['pgsDeliverableId'],
                orElse: () => PgsDeliverableHistoryGrouped(0, null),
              );

              return {
                'pgsDeliverableId': item['pgsDeliverableId'],
                'kra': item['keyResultArea'],
                'kraDescription': item['kraDescription'],
                'Start Date': item['pgsPeriod']?.split(" - ")?.first ?? '',
                'End Date': item['pgsPeriod']?.split(" - ")?.last ?? '',
                'officeName': item['office'],
                'isDirect': item['isDirect'],
                'deliverableName': item['deliverable'],
                'byWhen': formattedByWhen,
                'status':
                    item['status'] is PgsStatus
                        ? (item['status'] as PgsStatus).name
                        : item['status'].toString(),
                'remarks': item['remarks'],
                'score': item['score'],
              };
            }).toList();

        if (mounted) {
          setState(() {
            deliverableList = formattedData;
            filteredList = List.from(formattedData);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching filtered data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth =
        numberColumnWidth + (dataColumns * dataColumnWidth) + 24.0;
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewPgsDeliverableMonitor,
    );

    if (!hasPermission) {
      return noPermissionScreen();
    }
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: mainBgColor,
        title: const Text(
          'Deliverables Status Monitoring',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PopupMenuButton<int>(
                      color: mainBgColor,
                      offset: const Offset(0, 40),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<int>(
                              padding: EdgeInsets.zero,
                              child: StatefulBuilder(
                                builder: (
                                  BuildContext context,
                                  setDialogState,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PopupMenuButton<String>(
                                          color: mainBgColor,
                                          offset: const Offset(0, 30),
                                          onCanceled: () {
                                            setDialogState(() {
                                              isMenuOpenPeriod = false;
                                            });
                                          },
                                          onOpened: () {
                                            setDialogState(() {
                                              isMenuOpenPeriod = true;
                                            });
                                          },
                                          onSelected: (String value) {
                                            setDialogState(() {
                                              selectedPeriod =
                                                  value.isEmpty
                                                      ? null
                                                      : int.tryParse(value);
                                              if (selectedPeriod == null) {
                                                selectedPeriodText =
                                                    'All Period';
                                              } else {
                                                final selected = periodList
                                                    .firstWhere(
                                                      (period) =>
                                                          period.id ==
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
                                              }
                                              isMenuOpenPeriod = false;
                                              fetchFilteredPgsList();
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            final updatedPeriodList = [
                                              {'id': '', 'name': 'All Period'},
                                              ...periodList.map(
                                                (period) => {
                                                  'id': period.id,
                                                  'name':
                                                      "${_dateConverter.toJson(period.startDate)} - ${_dateConverter.toJson(period.endDate)}",
                                                },
                                              ),
                                            ];

                                            return updatedPeriodList.map<
                                              PopupMenuItem<String>
                                            >((period) {
                                              return PopupMenuItem<String>(
                                                value: period['id'].toString(),
                                                child: Text(
                                                  period['name']!.toString(),
                                                ),
                                              );
                                            }).toList();
                                          },
                                          child: FilterButton(
                                            label:
                                                selectedPeriod == null
                                                    ? 'All Period'
                                                    : selectedPeriodText ??
                                                        'Period',
                                            isActive: isMenuOpenPeriod,
                                          ),
                                        ),
                                        gap8px,

                                        PopupMenuButton<String>(
                                          color: mainBgColor,
                                          offset: const Offset(0, 30),
                                          onCanceled: () {
                                            setDialogState(() {
                                              isMenuOpenOffice = false;
                                            });
                                          },
                                          onOpened: () {
                                            setDialogState(() {
                                              isMenuOpenOffice = true;
                                            });
                                          },
                                          onSelected: (String value) {
                                            setDialogState(() {
                                              _selectedOfficeId =
                                                  value.isEmpty ? null : value;
                                              isMenuOpenOffice = false;

                                              fetchFilteredPgsList();
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            final updatedOfficeList = [
                                              {'id': '', 'name': 'All Offices'},
                                              ...officeList.map(
                                                (o) => {
                                                  'id': o.id,
                                                  'name': o.name,
                                                },
                                              ),
                                            ];

                                            final searchController =
                                                TextEditingController();
                                            ValueNotifier<String> searchQuery =
                                                ValueNotifier('');

                                            return [
                                              PopupMenuItem<String>(
                                                enabled: false,
                                                height:
                                                    kMinInteractiveDimension,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          searchController,
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            'Search offices...',
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                          size: 18,
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 8,
                                                            ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        isDense: true,
                                                      ),
                                                      onChanged: (value) {
                                                        searchQuery.value =
                                                            value.toLowerCase();
                                                      },
                                                    ),
                                                    const Divider(
                                                      height: 16,
                                                      thickness: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              PopupMenuItem<String>(
                                                enabled: false,
                                                child: ValueListenableBuilder<
                                                  String
                                                >(
                                                  valueListenable: searchQuery,
                                                  builder: (context, query, _) {
                                                    final filteredOffices =
                                                        updatedOfficeList
                                                            .where(
                                                              (
                                                                office,
                                                              ) => office['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    query,
                                                                  ),
                                                            )
                                                            .toList();

                                                    return ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                            maxHeight:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.height *
                                                                0.4,
                                                          ),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children:
                                                              filteredOffices
                                                                  .map<Widget>(
                                                                    (
                                                                      office,
                                                                    ) => ListTile(
                                                                      dense:
                                                                          true,
                                                                      title: Text(
                                                                        office['name']
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      onTap: () {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                        setDialogState(() {
                                                                          _selectedOfficeId =
                                                                              office['id'].toString();
                                                                          fetchFilteredPgsList();
                                                                        });
                                                                      },
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ];
                                          },
                                          child: FilterButton(
                                            label:
                                                _selectedOfficeId == null
                                                    ? 'All Offices'
                                                    : officeList
                                                        .firstWhere(
                                                          (office) =>
                                                              office.id
                                                                  .toString() ==
                                                              _selectedOfficeId,
                                                          orElse:
                                                              () => Office(
                                                                id: 0,
                                                                name:
                                                                    'All Offices',
                                                              ),
                                                        )
                                                        .name,
                                            isActive: isMenuOpenOffice,
                                          ),
                                        ),
                                        gap8px,
                                        PopupMenuButton<int>(
                                          color: mainBgColor,
                                          offset: const Offset(0, 30),
                                          onCanceled: () {
                                            setDialogState(() {
                                              isMenuOpenKra = false;
                                            });
                                          },
                                          onOpened: () {
                                            setDialogState(() {
                                              isMenuOpenKra = true;
                                            });
                                          },

                                          onSelected: (int value) {
                                            setDialogState(() {
                                              selectedKra =
                                                  (value == -1) ? null : value;
                                              isMenuOpenKra = false;

                                              fetchFilteredPgsList();
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            final updatedKraList = [
                                              {'id': -1, 'name': 'All KRA'},
                                              ...kraListOptions.map(
                                                (k) => {
                                                  'id': k.id,
                                                  'name': k.name,
                                                  'remakrs': k.remarks,
                                                },
                                              ),
                                            ];

                                            return updatedKraList
                                                .map<PopupMenuItem<int>>((kra) {
                                                  return PopupMenuItem<int>(
                                                    value: kra['id'] as int,
                                                    child: Text(
                                                      kra['name'].toString(),
                                                    ),
                                                  );
                                                })
                                                .toList();
                                          },
                                          child: FilterButton(
                                            label:
                                                selectedKra == null
                                                    ? 'All KRA'
                                                    : kraListOptions
                                                        .firstWhere(
                                                          (kra) =>
                                                              kra.id ==
                                                              selectedKra,
                                                          orElse:
                                                              () =>
                                                                  KeyResultArea(
                                                                    0,
                                                                    'name',
                                                                    'remarks',
                                                                    'strategic',
                                                                    false,
                                                                  ),
                                                        )
                                                        .name,
                                            isActive: isMenuOpenKra,
                                          ),
                                        ),
                                        gap8px,
                                        PopupMenuButton<String>(
                                          color: mainBgColor,
                                          offset: const Offset(0, 30),
                                          onCanceled: () {
                                            setDialogState(() {
                                              isMenuOpenType = false;
                                            });
                                          },
                                          onOpened: () {
                                            setDialogState(() {
                                              isMenuOpenType = true;
                                            });
                                          },
                                          onSelected: (String value) {
                                            setDialogState(() {
                                              if (value.isEmpty) {
                                                isDirect = null;
                                              } else if (value == 'true') {
                                                isDirect = true;
                                              } else {
                                                isDirect = false;
                                              }
                                              isMenuOpenType = false;

                                              fetchFilteredPgsList();
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              PopupMenuItem<String>(
                                                value: '',
                                                child: Text('All Types'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'true',
                                                child: Text('Direct'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'false',
                                                child: Text('Indirect'),
                                              ),
                                            ];
                                          },
                                          child: FilterButton(
                                            label:
                                                isDirect == null
                                                    ? 'All Types'
                                                    : isDirect!
                                                    ? 'Direct'
                                                    : 'Indirect',
                                            isActive: isMenuOpenType,
                                          ),
                                        ),
                                        gap8px,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              key: _menuScoreRangeKey,
                                              onTap:
                                                  () => _showScoreRangeMenu(
                                                    context,
                                                  ),
                                              child: FilterButton(
                                                label:
                                                    (scoreRangeFromController
                                                                .text
                                                                .isEmpty ||
                                                            scoreRangeToController
                                                                .text
                                                                .isEmpty)
                                                        ? 'Score Range'
                                                        : 'From ${scoreRangeFromController.text} to ${scoreRangeToController.text}',
                                                isActive: isMenuScoreRange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        gap8px,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              key: _menuPageKey,
                                              onTap:
                                                  () => _showPageSizeMenu(
                                                    context,
                                                  ),
                                              child: FilterButton(
                                                label:
                                                    (pageController
                                                                .text
                                                                .isEmpty ||
                                                            pageSizeController
                                                                .text
                                                                .isEmpty)
                                                        ? 'Page'
                                                        : 'From ${pageController.text} to ${pageSizeController.text}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 0.8,
                          ),
                          elevation: 0,
                        ),
                        onPressed: null,
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.black87,
                        ),
                        label: const Text(
                          'Filter by',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),

                Flexible(fit: FlexFit.tight, child: Container()),
                if (!isMinimized)
                  Row(
                    children: [
                      PermissionWidget(
                        allowedRoles: [
                          PermissionString.pgsAuditor,
                          PermissionString.roleAdmin,
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBgColor,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                              width: 0.8,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ManageSummaryNarrativeReportPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: const Color.fromARGB(255, 17, 16, 16),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Manage Auditor Reports',
                                style: TextStyle(color: primaryTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      PermissionWidget(
                        allowedRoles: [
                          PermissionString.pgsAuditor,
                          PermissionString.roleAdmin,
                        ],
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            showReportDialog();
                          },

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Create Report',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              controller: _headerHorizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: totalWidth, child: _buildHeader()),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notif) => notif.depth == 1,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: totalWidth,
                        minHeight: MediaQuery.of(context).size.height - 160,
                      ),
                      child: _buildTableBody(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          isMinimized
              ? FloatingActionButton.extended(
                backgroundColor: primaryColor,
                onPressed: () {
                  showReportDialog();
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Create Report',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : null,
    );
  }

  void showReportDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                  child: _buildReportCard(setDialogState),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    _findingsController.clear();
                    _recommendationsController.clear();
                    _conclusionsController.clear();
                    _selectedOffice = null;
                    _selectedPeriod = null;
                    officeId = null;
                    periodId = null;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                PermissionWidget(
                  permission: AppPermissions.addPgsDeliverableAccomplishment,
                  child: ElevatedButton(
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
                                  onPressed:
                                      () => Navigator.pop(context, false),
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
                            int.tryParse(_selectedPeriod ?? '0') ?? 0,
                            _findingsController.text,
                            _recommendationsController.text,
                            _conclusionsController.text,
                            int.tryParse(_selectedOffice ?? '0') ?? 0,
                            isDeleted: false,
                            rowVersion: '',
                          );

                          await _summaryNarrativeService.addSummaryNarrative(
                            summaryNarrative,
                          );
                          _findingsController.clear();
                          _recommendationsController.clear();
                          _conclusionsController.clear();
                          _selectedOffice = null;
                          _selectedPeriod = null;
                          officeId = null;
                          periodId = null;
                          MotionToast.success(
                            description: const Text("Saved Successfully"),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReportCard(Function setDialogState) {
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
                          onPressed: () {
                            _findingsController.clear();
                            _recommendationsController.clear();
                            _conclusionsController.clear();
                            _selectedOffice = null;
                            _selectedPeriod = null;
                            officeId = null;
                            periodId = null;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Summary Narrative Report',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                      setDialogState(() {
                                        _selectedPeriod = value?.id.toString();
                                        _findingsController.clear();
                                        _recommendationsController.clear();
                                        _conclusionsController.clear();
                                        _checkDeliverablesAvailability(
                                          setDialogState,
                                        );
                                        _checkDeliverablesAvailability(
                                          setDialogState,
                                        );
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
                                                    FloatingLabelBehavior.never,
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                      setDialogState(() {
                                        _selectedOffice = value?.id.toString();
                                        _findingsController.clear();
                                        _recommendationsController.clear();
                                        _conclusionsController.clear();
                                        _checkDeliverablesAvailability(
                                          setDialogState,
                                        );
                                        _checkDeliverablesAvailability(
                                          setDialogState,
                                        );
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
                                                    FloatingLabelBehavior.never,
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
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
                      if (!_hasAvailableDeliverables &&
                          _selectedOffice != null &&
                          _selectedPeriod != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "No available deliverables for the selected office and period.",
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          ),
                        ),
                      const SizedBox(height: 32),
                      _buildReportSection(
                        icon: Icons.error_outline_rounded,
                        iconColor: Colors.blue,
                        title: "Auditor Findings",
                        description:
                            "These will be displayed as separate points in the report.",
                        controller: _findingsController,
                        disabled: !_hasAvailableDeliverables,
                      ),
                      const SizedBox(height: 24),
                      _buildReportSection(
                        icon: Icons.check_circle_outline,
                        iconColor: Colors.green,
                        title: "Conclusions",
                        description:
                            "These should summarize your analysis and insights.",
                        controller: _conclusionsController,
                        disabled: !_hasAvailableDeliverables,
                      ),
                      const SizedBox(height: 24),
                      _buildReportSection(
                        title: "Recommendations",
                        icon: Icons.trending_up,
                        iconColor: Colors.deepOrangeAccent,
                        description:
                            "These should be actionable steps for improvement.",
                        controller: _recommendationsController,
                        disabled: !_hasAvailableDeliverables,
                      ),
                    ],
                  ),
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
    required String description,
    required TextEditingController controller,
    IconData icon = Icons.description_outlined,
    Color iconColor = Colors.black54,
    bool disabled = false,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
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
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: BoxConstraints(minHeight: 120, maxHeight: 180),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: controller,
                      style: const TextStyle(fontSize: 14),
                      maxLines: null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      readOnly: disabled,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type here...",
                        hintStyle: TextStyle(color: Colors.grey),
                        disabledBorder: InputBorder.none,
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
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreRangeMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuScoreRangeKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      color: secondaryColor,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Score Range',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              gap4px,
              TextField(
                controller: scoreRangeFromController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'From',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),

                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              TextField(
                controller: scoreRangeToController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: 'To',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      scoreRangeFromController.text;
                      scoreRangeToController.text;
                      fetchFilteredPgsList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPageSizeMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuPageKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      color: secondaryColor,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Page',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              TextField(
                controller: pageSizeController,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  labelText: 'Page Size',
                  labelStyle: TextStyle(color: grey, fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              gap16px,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      pageController.text;
                      pageSizeController.text;
                      fetchFilteredPgsList();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final border = TableBorder.all(color: Colors.grey.shade700, width: 1.0);

    Map<int, TableColumnWidth> columnWidths = {
      0: FixedColumnWidth(numberColumnWidth),
    };
    for (int i = 1; i <= dataColumns; i++) {
      columnWidths[i] = FixedColumnWidth(dataColumnWidth);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: Table(
        border: border,
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: primaryLightColor),
            children: [
              _cell("#", isHeader: true, align: TextAlign.center),
              for (final h in headers) _cell(h, isHeader: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    final border = TableBorder.all(color: Colors.grey.shade700, width: 1.0);

    Map<int, TableColumnWidth> columnWidths = {
      0: FixedColumnWidth(numberColumnWidth),
    };
    for (int i = 1; i <= dataColumns; i++) {
      columnWidths[i] = FixedColumnWidth(dataColumnWidth);
    }

    if (deliverableList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No data available"),
        ),
      );
    }

    List<TableRow> rows =
        deliverableList.asMap().entries.map((entry) {
          final int index = entry.key;
          final deliverable = entry.value;

          return TableRow(
            children: [
              _cell("${index + 1}", align: TextAlign.center),
              _cell(
                "${deliverable['Start Date']} - ${deliverable['End Date']}",
              ),
              _cell(deliverable['officeName'] ?? ''),
              _buildCoreSupport(deliverable['kra']),
              _buildKRA(deliverable['kraDescription']),
              _cell(deliverable['isDirect'] ? "Direct" : "Indirect"),
              _cell(deliverable['deliverableName'] ?? ''),
              _cell(deliverable['byWhen'] ?? ''),
              _buildCreateAccomplishmentAndBreakthroughCell(index, () {
                debugPrint(
                  "Create tapped for ID: ${deliverable['pgsDeliverableId']}",
                );
              }),
            ],
          );
        }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Table(
        border: border,
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      ),
    );
  }

  Widget _cell(
    String text, {
    bool isHeader = false,
    TextAlign align = TextAlign.left,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Center(
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCoreSupport(String? kra) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              kra ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKRA(String? description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [if (description != null) Text(description)],
      ),
    );
  }

  Widget _buildCreateAccomplishmentAndBreakthroughCell(
    int index,
    VoidCallback onPressed,
  ) {
    final deliverable = deliverableList[index];
    final deliverableId = deliverable['pgsDeliverableId'];

    final startDateStr = deliverable['Start Date'];
    final endDateStr = deliverable['End Date'];
    final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
    final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);

    List<Map<String, dynamic>> monthlyPeriods = [];
    DateTime current = DateTime(startDate.year, startDate.month);
    DateTime end = DateTime(endDate.year, endDate.month);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      monthlyPeriods.add({
        'period': DateFormat('MMMM yyyy').format(current),
        'month': current.month,
        'year': current.year,
      });
      current = DateTime(current.year, current.month + 1);
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: 'Click to open Accomplishment Form',
            child: SizedBox(
              height: 30,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  textStyle: const TextStyle(fontSize: 13),
                  minimumSize: Size.zero,
                ).copyWith(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.hovered) ||
                        states.contains(WidgetState.pressed)) {
                      return const Color.fromARGB(255, 221, 221, 221);
                    }
                    return null;
                  }),
                ),
                onPressed: () async {
                  await loadAccomplishments(deliverable['pgsDeliverableId']);
                  showAccomplishmentFormDialog(context, deliverable, userId);
                },
                icon: const Icon(
                  Icons.bar_chart_outlined,
                  size: 14,
                  color: primaryTextColor,
                ),
                label: const Text(
                  'Accomplishment',
                  style: TextStyle(color: primaryTextColor, fontSize: 10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          FutureBuilder<bool>(
            future: _hasCompleteAccomplishmentData(
              deliverableId,
              monthlyPeriods.length,
            ),
            builder: (context, snapshot) {
              final hasCompleteData = snapshot.data ?? false;

              return Tooltip(
                message:
                    hasCompleteData
                        ? 'Click to open Breakthrough Scoring'
                        : "The accomplishment data hasn't been completed yet.",
                child: SizedBox(
                  height: 30,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasCompleteData
                              ? Colors.transparent
                              : Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: hasCompleteData ? Colors.black : Colors.grey,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      textStyle: const TextStyle(fontSize: 13),
                      minimumSize: Size.zero,
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (hasCompleteData &&
                            (states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.pressed))) {
                          return const Color.fromARGB(255, 221, 221, 221);
                        }
                        return null;
                      }),
                    ),
                    onPressed:
                        hasCompleteData
                            ? () async {
                              await loadBreakThrough(deliverableId);
                              showBreakthroughFormDialog(
                                context,
                                deliverable,
                                userId,
                              );
                            }
                            : null,
                    icon: Icon(
                      Icons.star_outline,
                      size: 14,
                      color: hasCompleteData ? primaryTextColor : Colors.grey,
                    ),
                    label: Text(
                      'Breakthrough Scoring',
                      style: TextStyle(
                        color: hasCompleteData ? primaryTextColor : Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool?> showAccomplishmentFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  final startDateStr = deliverable['Start Date'];
  final endDateStr = deliverable['End Date'];

  final startDate = DateFormat('MMM dd, yyyy').parse(startDateStr);
  final endDate = DateFormat('MMM dd, yyyy').parse(endDateStr);

  List<Map<String, dynamic>> monthlyPeriods = [];

  DateTime current = DateTime(startDate.year, startDate.month);
  DateTime end = DateTime(endDate.year, endDate.month);

  while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
    monthlyPeriods.add({
      'period': DateFormat('MMMM yyyy').format(current),
      'month': current.month,
      'year': current.year,
    });

    current = DateTime(current.year, current.month + 1);
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Accomplishment Form - ${DateFormat('MMMM dd, yyyy').format(startDate)} to ${DateFormat('MMMM dd, yyyy').format(endDate)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                  Text(
                                    "Monthly Tracking Periods: ${monthlyPeriods.length} month(s)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                  Text(
                                    "Due: ${deliverable['byWhen'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
                              Text(
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section title
                        const Row(
                          children: [
                            Icon(Icons.bar_chart_outlined, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Monthly Accomplishment Tracking",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Period",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Status",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks (Department Head)",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Proof",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          "Remarks (Auditor)",
                                          style: TextStyle(color: grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...monthlyPeriods.asMap().entries.map((entry) {
                                final index = entry.key;
                                final period = entry.value;
                                return Column(
                                  children: [
                                    const Divider(height: 1),
                                    TrackingRowWidget(
                                      period: period['period'],
                                      periodIndex: index,
                                      totalPeriods: monthlyPeriods.length,
                                      deliverableId:
                                          deliverable['pgsDeliverableId'],
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                PermissionWidget(
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveAccomplishmentData(
                            deliverable['pgsDeliverableId'],
                            userId,
                          );

                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Save Accomplishment",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> showBreakthroughFormDialog(
  BuildContext context,
  Map<String, dynamic> deliverable,
  String userId,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: mainBgColor,
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Breakthrough Form",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Office: ${deliverable['officeName'] ?? 'N/A'}",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("KRA: ${deliverable['kra'] ?? 'N/A'}"),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Text(
                                "Type: ${deliverable['isDirect'] == true ? 'Direct' : 'Indirect'}",
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Deliverable: ${deliverable['deliverableName'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Row(
                          children: [
                            Icon(Icons.star_outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Breakthrough Scoring",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Dynamic table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Headers
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Percent Accomplishment",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Target Achievement",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Strategic Contribution ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Breakthrough Impact",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Score",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          "Final Grade",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  const Divider(height: 1),
                                  BreakthroughWidget(
                                    deliverableId:
                                        deliverable['pgsDeliverableId'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                PermissionWidget(
                  allowedRoles: [
                    PermissionString.pgsAuditor,
                    PermissionString.roleAdmin,
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          final shouldSave = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: Text("Confirm Save"),
                                  content: Text(
                                    "Are you sure you want to save this data?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(false),
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(ctx).pop(true),
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldSave != true) return;
                          MotionToast.success(
                            description: Text('Saved Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          await saveBreakthroughData(
                            deliverable['pgsDeliverableId'],
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class PgsDeliverableHistoryGrouped {
  final int pgsDeliverableId;
  final List<PgsDeliverableScoreHistory>? scoreHistory;

  PgsDeliverableHistoryGrouped(this.pgsDeliverableId, this.scoreHistory);

  factory PgsDeliverableHistoryGrouped.fromJson(Map<String, dynamic> json) {
    return PgsDeliverableHistoryGrouped(
      json['pgsDeliverableId'] as int,
      json['scoreHistory'] != null
          ? (json['scoreHistory'] as List)
              .map((e) => PgsDeliverableScoreHistory.fromJson(e))
              .toList()
          : null,
    );
  }
}
