// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:data_table_2/data_table_2.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverable_history.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/roadmap/models/kra_roadmap_filter.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/accomplishment_pgs_widget.dart';
import 'package:imis/widgets/breakthrough_widget.dart';
import 'package:imis/widgets/build_header_cell.dart';
import 'package:imis/widgets/custom_tooltip.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_services/common_service.dart';
import '../../utils/http_util.dart';
import '../enum/pgs_action_type.dart';
import 'pgs_reports.dart';

class PerformanceGovernanceSystemPage extends StatefulWidget {
  const PerformanceGovernanceSystemPage({super.key});

  @override
  PerformanceGovernanceSystemPageState createState() =>
      PerformanceGovernanceSystemPageState();
}

class PerformanceGovernanceSystemPageState
    extends State<PerformanceGovernanceSystemPage> {
  late FilterSearchResultUtil<PerformanceGovernanceSystem> pgsSearchUtil;
  final _commonService = CommonService(Dio());
  final _roadMapService = RoadmapService(Dio());
  final GlobalKey _menuKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _dateConverter = const LongDateOnlyConverter();
  final _pgsService = PerformanceGovernanceSystemService(Dio());
  final ScrollController _tableScrollController = ScrollController();
  Map<int, TextEditingController> deliverablesControllers = {};
  Map<int, TextEditingController> deliverablesRoadmapControllers = {};
  Map<int, TextEditingController> deliverablesControllersDisapproved = {};
  Map<int, bool> deliverableUserEdited = {};
  Map<int, bool> clearedOnDisapprove = {};
  Map<int, TextEditingController> signatoryControllers = {};
  Map<int, TextEditingController> selectedByWhenControllers = {};
  Map<int, Map<String, dynamic>> selectedKRAObjects = {};
  late Future<List<Map<String, dynamic>>> deliverables;
  Map<int, TextEditingController> remarksControllers = {};
  Map<int, TextEditingController> percentageControllers = {};
  String? pgsIdHistory;
  Map<int, PgsStatus> selectedStatus = {};
  Map<int, String> selectedValues = {};
  Map<int, String> selectedByWhen = {};
  Map<int, String> selectedStatusOptions = {};
  Map<int, bool> selectedDirect = {};
  Map<int, bool> selectedIndirect = {};
  Map<int, bool> tempSelectedDirect = {};
  Map<int, bool> tempSelectedIndirect = {};
  Map<int, int?> selectedKRA = {};
  String userId = "";
  final permissionService = PermissionService();
  List<Map<String, dynamic>> filteredList = [];

  List<Map<String, dynamic>> deliverableLists = [];
  List<Map<String, dynamic>> readinessList = [];

  List<Map<String, dynamic>> filteredListSignatory = [];
  List<Map<String, dynamic>> options = [];

  List<Map<String, dynamic>> kraOptions = [];
  Map<int, int?> deliverableIds = {};

  List<PgsSignatory> displaySignatoryList = [];
  List<Map<String, dynamic>> signatoryList = [];
  Map<int, int?> signatoryIds = {};

  List<int> rows = [];
  String officeDisplay = "";
  String officeIdList = "";
  String? selectedOffice = "";
  String? _selectedOfficeId;
  String? selectedPeriodText;
  Map<String, dynamic>? selectedPeriodObject;

  String? selectedEndDateText;
  String? selectedStartDateText;
  TextEditingController percentageDeliverables = TextEditingController();

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  List<PgsDeliverables> deliverablesList = [];

  String? displayText;
  List<PgsDeliverableHistory> deliverablesListHistory = [];
  Map<int, PgsDeliverables> deliverablesMap = {};

  int? selectedPeriod;
  String? selectedStartPeriod;
  String? selectedEndDate;
  int? selectedKra;
  Map<int, bool> selectedDisapproved = {};

  final _paginationUtils = PaginationUtil(Dio());
  int _currentPage = 1;
  final int _pageSize = 30;
  int _totalCount = 0;
  bool _isLoading = false;
  bool permissionsLoaded = false;

  bool isMenuOpenOffice = false;
  bool isMenuOpenStartDate = false;
  bool isMenuOpenEndDate = false;
  Map<int, bool> hasDataMap = {};
  final Map<int, bool> isLoadingDescriptions = {};
  final Map<int, List<dynamic>> kraDescriptionsByIndex = {};
  final Map<int, GlobalKey> kraDropdownKeys = {};
  final Map<int, Map<String, dynamic>?> selectedKraDescription = {};

  Map<int, bool> rowErrors = {};
  Map<int, bool> selectedProcessErrors = {};
  List<Office> officeList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();
  Map<int, TextEditingController> reasonController = {};
  Map<int, TextEditingController> kraDescriptionController = {};
  Map<int, TextEditingController> kraDescriptionRoadmapController = {};
  TextEditingController competenceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController resourceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController confidenceScoreController = TextEditingController(
    text: '',
  );

  TextEditingController totalScoreController = TextEditingController(text: '');
  ValueNotifier<double> percentageScore = ValueNotifier(0.0);
  ValueNotifier<double> competenceScore = ValueNotifier(0.0);
  ValueNotifier<double> resourceScore = ValueNotifier(0.0);
  ValueNotifier<double> confidenceScore = ValueNotifier(0.0);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  double get totalScore =>
      competenceScore.value + resourceScore.value + confidenceScore.value;

  bool isValidInput(String value) {
    return value.isEmpty || value == '0' || value == '0.5' || value == '1';
  }

  final dio = Dio();
  int? _lastResponseStatusCode;

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  //Save as draft pgs

  Future<bool> pgsSaveAsDraft(PerformanceGovernanceSystem audit) async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();

      if (user == null || user.id == null || user.id!.isEmpty) {
        _lastResponseStatusCode = 401;
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      final baseUrl = ApiEndpoint().pgsSaveAsDraft;
      final url = '$baseUrl?userId=${user.id}';

      final requestData = audit.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PGS data submitted successfully!");

        if (mounted) {
          setState(() {
            fetchPgsList();
            // clearAllSelections();
          });
        }

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
        _lastResponseStatusCode = response.statusCode;
        return true;
      } else {
        debugPrint("Failed to submit PGS data");
        _lastResponseStatusCode = response.statusCode;
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio Error");
      _lastResponseStatusCode = e.response?.statusCode;
      return false;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return false;
    }
  }

  Future<bool> submitPGS({
    String? pgsId,
    required String userId,
    required PerformanceGovernanceSystem updatePgs,
  }) async {
    UserRegistration? user = await AuthUtil.fetchLoggedUser();
    if (user == null) {
      _lastResponseStatusCode = 401;
      return false;
    }

    final url = '${ApiEndpoint().pgsSubmit}?userId=${user.id}';

    try {
      final signatoryResponse = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().fetchPGSUserId}/${user.id}?pgsId=$pgsId",
      );

      if (signatoryResponse.statusCode != 200) {
        _lastResponseStatusCode = signatoryResponse.statusCode;
        return false;
      }

      final signatoryData = PerformanceGovernanceSystem.fromJson(
        signatoryResponse.data,
      );

      final updatedPgsJson = updatePgs.toJson();
      updatedPgsJson['id'] = pgsId;

      updatedPgsJson['pgsSignatories'] =
          signatoryData.pgsSignatories?.map((s) => s.toJson()).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: updatedPgsJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fetchPgsList();
          // clearAllSelections();
        });
        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
        _lastResponseStatusCode = response.statusCode;
        return true;
      } else {
        debugPrint("Failed to update PGS");
        _lastResponseStatusCode = response.statusCode;
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      _lastResponseStatusCode = e.response?.statusCode;
      return false;
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return false;
    }
  }

  //Disapprove pgs
  Future<void> disapprovePGS(PerformanceGovernanceSystem audit) async {
    var url = ApiEndpoint().disapprovePgs;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final requestData = audit.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fetchPgsList();
          clearAllSelections();
        });

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to disapprove Pgs data");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<List<PgsDeliverables>> fetchDeliverables({String? pgsId}) async {
    List<PgsDeliverables> deliverablesList = [];
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final deliverables =
              (pgsJson['pgsDeliverables'] as List)
                  .map((d) => PgsDeliverables.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();

          deliverablesList.addAll(deliverables);
        }
      } else {
        debugPrint("Failed to fetch deliverables");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return deliverablesList;
  }

  Future<List<PgsDeliverableHistory>> fetchDeliverablesHistory({
    String? pgsId,
  }) async {
    final url = "${ApiEndpoint().pgsDeliverableHistory}/$pgsId";
    final List<PgsDeliverableHistory> deliverablesListHistory = [];

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          deliverablesListHistory.addAll(
            data
                .map((json) => PgsDeliverableHistory.fromJson(json))
                .where((d) => d.id != null)
                .toList(),
          );
        } else if (data is Map<String, dynamic>) {
          final deliverable = PgsDeliverableHistory.fromJson(data);
          if (deliverable.id != null) {
            deliverablesListHistory.add(deliverable);
          }
        }
      } else {
        debugPrint("Failed to fetch deliverables");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return deliverablesListHistory;
  }

  // Future<String?> _selectOffice() async {
  //   final officeNames = await AuthUtil.fetchOfficeNames();
  //   final officeIds = await AuthUtil.fetchOfficeIds();

  //   if (officeNames == null ||
  //       officeIds == null ||
  //       officeNames.isEmpty ||
  //       officeIds.isEmpty) {
  //     MotionToast.error(
  //       title: const Text("Office Not Found"),
  //       description: const Text(
  //         "The selected office ID does not match any known office.\nPlease contact the administrator.",
  //       ),
  //       toastDuration: const Duration(seconds: 10),
  //       toastAlignment: Alignment.topCenter,
  //     ).show(context);
  //     return null;
  //   }

  //   String? selectedOffice = await showDialog<String>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: mainBgColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           constraints: const BoxConstraints(maxHeight: 450, maxWidth: 500),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: IconButton(
  //                   icon: Icon(Icons.close, color: Colors.grey.shade600),

  //                   onPressed: () async {
  //                     final prefs = await SharedPreferences.getInstance();
  //                     await prefs.remove('selectedOfficeId');
  //                     await prefs.remove('selectedOfficeName');

  //                     Navigator.pop(context, null);
  //                   },
  //                 ),
  //               ),
  //               // Title
  //               Text(
  //                 "Select Office",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: primaryTextColor,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               const Divider(),
  //               const SizedBox(height: 8),
  //               // List of offices
  //               Expanded(
  //                 child: ListView.separated(
  //                   itemCount: officeNames.length,
  //                   separatorBuilder: (_, __) => const SizedBox(height: 6),
  //                   itemBuilder: (context, index) {
  //                     return Card(
  //                       color: mainBgColor,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(0.1),
  //                         side: const BorderSide(
  //                           color: primaryTextColor,
  //                           width: 0.5,
  //                         ),
  //                       ),
  //                       child: ListTile(
  //                         contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 10,
  //                         ),
  //                         leading: Icon(
  //                           Icons.apartment_rounded,
  //                           color: primaryColor,
  //                         ),
  //                         title: Text(
  //                           officeNames[index],
  //                           style: const TextStyle(fontSize: 16),
  //                         ),
  //                         onTap: () => Navigator.pop(context, officeIds[index]),
  //                         hoverColor: primaryColor.withValues(alpha: 0.1),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   if (selectedOffice == null || selectedOffice == '-1') {
  //     await AuthUtil.removeSelectedOfficeId();
  //     return null;
  //   }

  //   await AuthUtil.saveSelectedOfficeId(selectedOffice);
  //   return selectedOffice;
  // }

  Future<Map<String, dynamic>?> _selectOffice() async {
    final officeNames = await AuthUtil.fetchOfficeNames();
    final officeIds = await AuthUtil.fetchOfficeIds();

    if (officeNames == null ||
        officeIds == null ||
        officeNames.isEmpty ||
        officeIds.isEmpty) {
      MotionToast.error(
        title: const Text("Office Not Found"),
        description: const Text(
          "The selected office ID does not match any known office.\nPlease contact the administrator.",
        ),
        toastDuration: const Duration(seconds: 10),
        toastAlignment: Alignment.topCenter,
      ).show(context);
      return null;
    }

    List<String> filteredOfficeIds = [];
    List<String> filteredOfficeNames = [];
    for (int i = 0; i < officeIds.length; i++) {
      bool? isHead = await AuthUtil.getIsOfficeHead(officeIds[i]);
      if (isHead == true) {
        filteredOfficeIds.add(officeIds[i]);
        filteredOfficeNames.add(officeNames[i]);
      }
    }

    if (filteredOfficeIds.isEmpty) {
      MotionToast.info(
        title: const Text("No Office Available"),
        description: const Text("You are not the head of any office."),
        toastDuration: const Duration(seconds: 5),
        toastAlignment: Alignment.topCenter,
      ).show(context);
      return null;
    }

    String? selectedOfficeId = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 450, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('selectedOfficeId');
                      await prefs.remove('selectedOfficeName');
                      await prefs.remove('isOfficeHead');
                      Navigator.pop(context, null);
                    },
                  ),
                ),
                Text(
                  "Select Office",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredOfficeNames.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      return Card(
                        color: mainBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.1),
                          side: const BorderSide(
                            color: primaryTextColor,
                            width: 0.5,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: Icon(
                            Icons.apartment_rounded,
                            color: primaryColor,
                          ),
                          title: Text(
                            filteredOfficeNames[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap:
                              () => Navigator.pop(
                                context,
                                filteredOfficeIds[index],
                              ),
                          hoverColor: primaryColor.withOpacity(0.1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOfficeId == null || selectedOfficeId == '-1') {
      await AuthUtil.removeSelectedOfficeId();
      return null;
    }

    await AuthUtil.saveSelectedOfficeId(selectedOfficeId);

    bool? isHead = await AuthUtil.getIsOfficeHead(selectedOfficeId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOfficeHead', isHead ?? false);

    return {
      'officeId': selectedOfficeId,
      'officeName':
          filteredOfficeNames[filteredOfficeIds.indexOf(selectedOfficeId)],
      'isOfficeHead': isHead ?? false,
    };
  }

  Map<String, dynamic> _mapPgsToListItem(
    PerformanceGovernanceSystem pgs,
    String userId,
  ) {
    if (pgs.pgsSignatories != null && pgs.pgsSignatories!.isNotEmpty) {
      signatoryList =
          pgs.pgsSignatories!
              .map(
                (sig) => {
                  'id': sig.id.toString(),
                  'signatoryId': sig.signatoryId,
                  'signatoryName': sig.signatoryName,
                  'signatoryLabel': sig.label,
                  'orderLevel': sig.orderLevel,
                  'defaultSignatoryId': sig.signatoryId,
                  'officeId': pgs.office.id.toString(),
                  'isNextStatus': sig.isNextStatus,
                  'status': sig.status,
                },
              )
              .toList();
    }

    return {
      'pgsReadinessRatingId': pgs.pgsReadinessRating.id.toString(),
      'userId': userId,
      'id': pgs.id.toString(),
      'name': pgs.office.name,
      'pgsStatus': pgs.pgsStatus.toString(),
      'startDate': DateTimeConverter().toJson(pgs.pgsPeriod.startDate),
      'officeid': pgs.office.id,
      'endDate': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
      'competencescore': pgs.pgsReadinessRating.competenceToDeliver.toString(),
      'confidencescore': pgs.pgsReadinessRating.confidenceToDeliver.toString(),
      'resourcescore': pgs.pgsReadinessRating.resourceAvailability.toString(),
      'selectPeriod': pgs.pgsPeriod.id.toString(),
      'totalscore': pgs.pgsReadinessRating.totalScore.toString(),
      'percentDeliverables': pgs.percentDeliverables.toString(),
      'remarks': pgs.remarks,
      'forSignature': pgs.forSignature,
      'signatories': pgs.pgsSignatories?.map((s) => s.toJson()).toList(),
      'periodId': pgs.pgsPeriod.id.toString(),
      'pgsDeliverables': pgs.pgsDeliverables?.map((d) => d.toJson()).toList(),
      'rowVersion': pgs.rowVersion,
      'isDraft': pgs.isDraft,
    };
  }

  Future<void> fetchPgsList({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        return;
      }

      setState(() => userId = user.id ?? "UserId");

      String roleIdParam = "";
      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();

      if (roles != null && roles.isNotEmpty) {
        var currentRole = roles.first;
        if (selectedRoleName != null) {
          try {
            currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
          } catch (e) {
            // keep first
          }
        }
        roleIdParam = "&roleId=${currentRole.id}";
      }

      final pageList = await _paginationUtils.fetchPaginatedData<
        PerformanceGovernanceSystem
      >(
        endpoint:
            "${ApiEndpoint().performancegovernancesystem}/userId/$userId?userId=$userId$roleIdParam",
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          deliverableLists =
              pageList.items
                  .map((pgs) => _mapPgsToListItem(pgs, userId))
                  .toList();
          filteredList = List.from(deliverableLists);
        });
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchSubmitUserId({
    required String pgsId,
    required String userId,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        return;
      }

      setState(() => userId = user.id ?? "UserId");

      String? token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().fetchPGSUserId}/${user.id}?pgsId=$pgsId",
      );
      if (response.statusCode == 200 && mounted) {
        final data = response.data;
        setState(() {
          deliverableLists = [
            _mapPgsToListItem(
              PerformanceGovernanceSystem.fromJson(data),
              userId,
            ),
          ];
          filteredList = List.from(deliverableLists);
        });
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      if (e.response != null) {}
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchPgsFilter({int page = 1, int pageSize = 15}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      String roleIdParam = "";
      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();

      if (roles != null && roles.isNotEmpty) {
        var currentRole = roles.first;
        if (selectedRoleName != null) {
          try {
            currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
          } catch (e) {
            // keep first
          }
        }
        roleIdParam = currentRole.id;
      }

      final Map<String, dynamic> queryParams = {
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
        'RoleId': roleIdParam,
        if (selectedStartPeriod != null)
          'FromDate': DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(selectedStartPeriod!)),
        if (selectedEndDate != null)
          'ToDate': DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(selectedEndDate!)),
        if (_selectedOfficeId != null && _selectedOfficeId!.isNotEmpty)
          'OfficeId': _selectedOfficeId,
      };

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().performancegovernancesystemFilter,
        queryParameters: queryParams,
      );
      debugPrint('Query Params: $queryParams');
      if (response.statusCode == 200) {
        final data = response.data;
        final items =
            (data['items'] as List)
                .map((item) => PerformanceGovernanceSystem.fromJson(item))
                .toList();

        if (mounted) {
          setState(() {
            deliverableLists =
                items.map((pgs) => _mapPgsToListItem(pgs, userId)).toList();
            filteredList = List.from(deliverableLists);
            _currentPage = data['page'] ?? 1;
            _totalCount = data['totalCount'] ?? 0;
          });
        }
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //fetch periods
  Future<void> fetchPGSPeriods() async {
    var url = ApiEndpoint().pgsperiod;
    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsPeriod> data =
            (response.data as List)
                .map((period) => PgsPeriod.fromJson(period))
                .toList();
        if (mounted) {
          setState(() {
            periodList = data.map((period) => period.toJson()).toList();
            filteredListPeriod = List.from(periodList);
          });
        }
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> _loadOfficeName() async {
    List<String>? officeNames = await AuthUtil.fetchOfficeNames();
    List<String>? officeIds = await AuthUtil.fetchOfficeIds();
    selectedOffice = await AuthUtil.fetchSelectedOfficeId();

    String selectedOfficeName = "No Office";

    if (officeNames != null && officeIds != null && selectedOffice != null) {
      int index = officeIds.indexOf(selectedOffice!);
      if (index != -1 && index < officeNames.length) {
        selectedOfficeName = officeNames[index];
      }
    }

    setState(() {
      officeDisplay = selectedOfficeName;
      officeIdList = selectedOffice ?? "No Office ID";
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      final offices = await _commonService.fetchOffices();
      if (!mounted) return;

      setState(() {
        officeList = offices;
      });
    }();
    _loadOfficeName();
    _loadCurrentUserId();
    fetchPgsList();

    fetchPGSPeriods();
    isSearchFocus.addListener(() {
      setState(() {});
    });
    fetchKraDropDown().then((_) {
      if (filteredListPeriod.isNotEmpty) {
        selectedPeriod = filteredListPeriod[0]['id'];
        selectedPeriodText =
            "${filteredListPeriod[0]['startDate']} - ${filteredListPeriod[0]['endDate']}";
      }
    });

    pgsSearchUtil = FilterSearchResultUtil<PerformanceGovernanceSystem>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().performancegovernancesystem,
      pageSize: _pageSize,
      fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
    );
  }

  //Save deliverables
  Future<void> saveDeliverables(int pgsId) async {
    var url = ApiEndpoint().deliverables;
    List<PgsDeliverables> deliverablesList = getTableDeliverables(pgsId);

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsDeliverables> data =
            (response.data as List)
                .map((deliverable) => PgsDeliverables.fromJson(deliverable))
                .toList();

        if (mounted) {
          setState(() {
            deliverablesList = data;
            filteredList = List.from(deliverablesList);
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchKraDropDown() async {
    var url = ApiEndpoint().keyresult;
    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        options =
            data.map<Map<String, dynamic>>((item) {
              return {
                'id': item['id'] as int,
                'name': item['name'].toString(),
                'remarks': item['remarks']?.toString() ?? '',
              };
            }).toList();
      } else {
        debugPrint("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  PerformanceGovernanceSystem getPgsDetails({
    required int id,
    required String pgsStatus,

    List<PgsSignatory> existingSignatories = const [],
  }) {
    // double percentDeliverables = 0.0;

    try {
      // percentDeliverables = double.tryParse(percentageDeliverables.text) ?? 0.0;
    } catch (e) {
      debugPrint("Error parsing percentDeliverables");
    }

    return PerformanceGovernanceSystem(
      id: id,
      pgsStatus: pgsStatus,
      pgsPeriod: PgsPeriod(
        selectedPeriod!,
        false,
        rowVersion: "",
        DateTime.now(),
        DateTime.now(),
        '',
      ),
      office: Office(
        id: int.tryParse(selectedOffice!) ?? 0,
        name: "Office Name",
        officeTypeId: 0,
        parentOfficeId: 0,
        isActive: false,
        rowVersion: "",
      ),
      pgsDeliverables: getTableDeliverables(id),
      pgsReadinessRating: PgsReadiness(
        0,
        false,
        null,
        competenceScore.value,
        resourceScore.value,
        confidenceScore.value,
        totalScore,
      ),

      pgsSignatories: [],
      isDeleted: false,
      isDraft: false,
      remarks: "",
      rowVersion: "",
      percentDeliverables: 40,
      forSignature: false,
    );
  }

  List<PgsDeliverables> getTableDeliverables(int pgsId) {
    List<PgsDeliverables> updatedDeliverables = [];

    deliverablesControllers.forEach((index, controller) {
      final existingId = deliverableIds[index] ?? 0;

      final kraId = selectedKRA[index];

      final kraData = options.firstWhere(
        (option) => option['id'] == kraId,
        orElse:
            () => {
              'id': 1,
              'name': 'Unknown',
              'remarks': '',
              'isDeleted': false,
              'rowVersion': '',
            },
      );
      selectedKRAObjects[index] = kraData;

      final deliverableText =
          controller.text.isNotEmpty ? controller.text : "No Name";
      final kraDescriptionText = kraDescriptionController[index]?.text ?? '';

      final isDirect = selectedDirect[index] ?? false;
      final byWhen =
          DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();
      // double percentDeliverables =
      //     (percentageControllers[index]?.text.isNotEmpty ?? false)
      //         ? double.tryParse(percentageControllers[index]!.text) ?? 0.0
      //         : 0.0;
      final disapprovalRemarksText = reasonController[index]?.text ?? '';
      final isDisapproved = selectedDisapproved[index] ?? false;
      final statusIndex =
          selectedStatus[index]?.index ?? PgsStatus.notStarted.index;
      final status = PgsStatus.values.firstWhere(
        (e) => e.index == statusIndex,
        orElse: () => PgsStatus.notStarted,
      );
      final remarks = remarksControllers[index]?.text ?? '';
      final rowVersion = kraData['rowVersion'] ?? '';
      updatedDeliverables.add(
        PgsDeliverables(
          existingId,
          KeyResultArea(
            kraData['id'] as int,
            kraData['name'] as String,
            kraData['remarks'] ?? '',
            kraData['strategic objectives'] ?? '',
            true,
            rowVersion: rowVersion,
          ),
          kraId,
          deliverableText,
          kraDescriptionText,
          isDirect,
          byWhen,
          40,
          disapprovalRemarksText,
          isDisapproved,
          status,
          pgsId,
          remarks: remarks,
          rowVersion: '',
        ),
      );
    });
    return updatedDeliverables;
  }

  //Add rows-------------
  void _addRow() {
    setState(() {
      rows.add(rows.length);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tableScrollController.hasClients) {
        _tableScrollController.animateTo(
          _tableScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void clearAllSelections() {
    rows.clear();
    selectedDirect.clear();
    selectedIndirect.clear();
    selectedByWhen.clear();
    selectedStatus.clear();
    selectedKRA.clear();
    deliverableIds.clear();
    deliverablesList.clear();
    percentageDeliverables.clear();
    rowErrors.clear();
    deliverablesControllers.clear();
    reasonController.clear();
    selectedDisapproved.clear();
    clearedOnDisapprove.clear();
  }

  void confirmSelection() {
    setState(() {
      selectedDirect.addAll(tempSelectedDirect);
      selectedIndirect.addAll(tempSelectedIndirect);
      tempSelectedDirect.clear();
      tempSelectedIndirect.clear();
    });
  }

  @override
  void dispose() {
    isSearchFocus.dispose();
    super.dispose();
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
                await _pgsService.deletePgs(id);
                await fetchPgsList();
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

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewPerformanceGovernanceSystem,
    );

    if (!hasPermission) {
      return noPermissionScreen();
    }
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('Performance Governance Information'),
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
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filter by',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            PermissionWidget(
                              permission: PermissionString.viewOffice,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PopupMenuButton<String>(
                                      color: mainBgColor,
                                      offset: const Offset(0, 30),
                                      onCanceled: () {
                                        setState(() {
                                          isMenuOpenOffice = false;
                                        });
                                      },
                                      onOpened: () {
                                        setState(() {
                                          isMenuOpenOffice = true;
                                        });
                                      },
                                      onSelected: (String value) {
                                        setState(() {
                                          _selectedOfficeId =
                                              value.isEmpty ? null : value;
                                          isMenuOpenOffice = false;

                                          fetchPgsFilter();
                                        });
                                      },
                                      itemBuilder: (BuildContext context) {
                                        final updatedOfficeList = [
                                          {'id': '', 'name': 'All Offices'},
                                          ...officeList.map(
                                            (o) => {'id': o.id, 'name': o.name},
                                          ),
                                        ];
                                        final searchController =
                                            TextEditingController();
                                        ValueNotifier<String> searchQuery =
                                            ValueNotifier('');
                                        return [
                                          PopupMenuItem<String>(
                                            enabled: false,
                                            height: kMinInteractiveDimension,
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: searchController,
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
                                                          (office) =>
                                                              office['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    query,
                                                                  ),
                                                        )
                                                        .toList();
                                                return ConstrainedBox(
                                                  constraints: BoxConstraints(
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
                                                                  dense: true,
                                                                  title: Text(
                                                                    office['name']
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    setState(() {
                                                                      _selectedOfficeId =
                                                                          office['id']
                                                                              .toString();

                                                                      fetchPgsFilter();
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
                                                            name: 'All Offices',
                                                          ),
                                                    )
                                                    .name,
                                        isActive: isMenuOpenOffice,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                        isMenuOpenStartDate = false;
                                      });
                                    },
                                    onOpened: () {
                                      setState(() {
                                        isMenuOpenStartDate = true;
                                      });
                                    },
                                    onSelected: (String selectedDate) {
                                      setState(() {
                                        selectedStartPeriod =
                                            selectedDate.isEmpty
                                                ? null
                                                : selectedDate;
                                        selectedStartDateText =
                                            selectedStartPeriod == null
                                                ? 'All Start Date'
                                                : _dateConverter.toJson(
                                                  DateTime.parse(
                                                    selectedStartPeriod!,
                                                  ),
                                                );
                                        isMenuOpenStartDate = false;
                                        fetchPgsFilter();
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      final periodOptions = [
                                        {
                                          'date': '',
                                          'displayText': 'All Start Date',
                                        },
                                        ...filteredListPeriod.map(
                                          (period) => {
                                            'date': period['startDate'],
                                            'displayText': _dateConverter
                                                .toJson(
                                                  DateTime.parse(
                                                    period['startDate'],
                                                  ),
                                                ),
                                          },
                                        ),
                                      ];

                                      return periodOptions
                                          .map<PopupMenuItem<String>>((option) {
                                            return PopupMenuItem<String>(
                                              value: option['date'],
                                              child: Text(
                                                option['displayText']!,
                                              ),
                                            );
                                          })
                                          .toList();
                                    },
                                    child: FilterButton(
                                      label:
                                          selectedStartDateText ??
                                          'Select Start Date',
                                      isActive: isMenuOpenStartDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),

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
                                        isMenuOpenEndDate = false;
                                      });
                                    },
                                    onOpened: () {
                                      setState(() {
                                        isMenuOpenEndDate = true;
                                      });
                                    },
                                    onSelected: (String selectedDate) {
                                      setState(() {
                                        selectedEndDate =
                                            selectedDate.isEmpty
                                                ? null
                                                : selectedDate;
                                        selectedEndDateText =
                                            selectedEndDate == null
                                                ? 'All End Date'
                                                : _dateConverter.toJson(
                                                  DateTime.parse(
                                                    selectedEndDate!,
                                                  ),
                                                );
                                        isMenuOpenEndDate = false;
                                        fetchPgsFilter();
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      final periodOptions = [
                                        {
                                          'date': '',
                                          'displayText': 'All End Date',
                                        },
                                        ...filteredListPeriod.map(
                                          (period) => {
                                            'date': period['endDate'],
                                            'displayText': _dateConverter
                                                .toJson(
                                                  DateTime.parse(
                                                    period['endDate'],
                                                  ),
                                                ),
                                          },
                                        ),
                                      ];

                                      return periodOptions
                                          .map<PopupMenuItem<String>>((option) {
                                            return PopupMenuItem<String>(
                                              value: option['date'],
                                              child: Text(
                                                option['displayText']!,
                                              ),
                                            );
                                          })
                                          .toList();
                                    },
                                    child: FilterButton(
                                      label:
                                          selectedEndDateText ??
                                          'Select End Date',
                                      isActive: isMenuOpenEndDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (!isMinimized)
                      PermissionWidget(
                        permission:
                            AppPermissions.addPerformanceGovernanceSystem,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () async {
                            clearAllSelections();
                            selectedOffice =
                                await AuthUtil.fetchSelectedOfficeId();

                            if (selectedOffice == null ||
                                selectedOffice!.isEmpty) {
                              await _selectOffice();

                              selectedOffice =
                                  await AuthUtil.fetchSelectedOfficeId();

                              if (selectedOffice != null &&
                                  selectedOffice!.isNotEmpty) {
                                await _loadOfficeName();
                                showFormDialog();
                              } else {}
                            } else {
                              await _loadOfficeName();
                              showFormDialog();
                            }

                            setState(() {
                              pgsIdHistory = null;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Add New',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
                        label: const Text('Office'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: const Text('Period'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(
                        label: const Text('Status'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: const Text('Actions'),
                        size: ColumnSize.M,
                      ),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var pgsgovernancesystem = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;
                          final isDraft =
                              pgsgovernancesystem['isDraft'] as bool? ?? false;

                          final signatories = List<Map<String, dynamic>>.from(
                            pgsgovernancesystem['signatories'] ?? [],
                          );
                          final deliverables = List<Map<String, dynamic>>.from(
                            pgsgovernancesystem['pgsDeliverables'] ?? [],
                          );
                          String status = 'Draft';
                          if (deliverables.any(
                            (d) => d['isDisapproved'] as bool? ?? false,
                          )) {
                            status = 'Disapproved';
                          } else if (isDraft) {
                            status = 'Draft';
                          } else {
                            final hasNextStatus = signatories.any((signatory) {
                              final isNextStatus = signatory['isNextStatus'];

                              if (isNextStatus == null) return false;
                              if (isNextStatus is bool) return isNextStatus;
                              if (isNextStatus is String) {
                                return isNextStatus.toLowerCase() == 'true';
                              }
                              return false;
                            });

                            status =
                                hasNextStatus ? 'For Approval' : 'Approved';
                          }

                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 40,
                                  child: Text(itemNumber.toString()),
                                ),
                              ),
                              DataCell(
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 100,
                                    maxWidth: constraints.maxWidth * 0.4,
                                  ),
                                  child: Text(
                                    pgsgovernancesystem['name'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  child: Text(
                                    "${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgsgovernancesystem['startDate']))} - ${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgsgovernancesystem['endDate']))}",
                                  ),
                                ),
                              ),
                              DataCell(SizedBox(child: Text(status))),
                              DataCell(
                                SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),

                                        onPressed: () async {
                                          try {
                                            await AuthUtil.saveSelectedOfficeId(
                                              pgsgovernancesystem['officeid']
                                                  .toString(),
                                            );
                                            selectedOffice =
                                                await AuthUtil.fetchSelectedOfficeId();

                                            final deliverables =
                                                await fetchDeliverables(
                                                  pgsId:
                                                      pgsgovernancesystem['id'],
                                                );
                                            final signatory =
                                                await fetchSignatoryList(
                                                  pgsId:
                                                      pgsgovernancesystem['id'],
                                                );
                                            await fetchSubmitUserId(
                                              userId: userId,
                                              pgsId: pgsgovernancesystem['id'],
                                            );

                                            final isDraftValue =
                                                pgsgovernancesystem['isDraft'] ??
                                                false;

                                            showFormDialog(
                                              userId:
                                                  pgsgovernancesystem['userId'],
                                              id: pgsgovernancesystem['id'],
                                              officename:
                                                  pgsgovernancesystem['name'],
                                              officenameid:
                                                  pgsgovernancesystem['officeid'],
                                              competencescore:
                                                  pgsgovernancesystem['competencescore'],
                                              confidencescore:
                                                  pgsgovernancesystem['confidencescore'],
                                              resourcescore:
                                                  pgsgovernancesystem['resourcescore'],
                                              startDate:
                                                  pgsgovernancesystem['startDate'],
                                              endDate:
                                                  pgsgovernancesystem['endDate'],
                                              percentDeliverables:
                                                  pgsgovernancesystem['percentDeliverables'],
                                              deliverables: deliverables,
                                              signatories: signatory,
                                              isDraft: isDraftValue,
                                              remarks:
                                                  pgsgovernancesystem['remarks'],
                                            );
                                            // ignore: empty_catches
                                          } catch (e) {}
                                        },
                                      ),
                                      Tooltip(
                                        message: 'Print Preview',
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.description_outlined,
                                          ),
                                          onPressed: () async {
                                            final pgsId =
                                                pgsgovernancesystem['id']
                                                    .toString();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ReportViewerPage(
                                                          pgsId: pgsId,
                                                        ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      if (status != 'Approved' &&
                                          status != 'For Approval')
                                        PermissionWidget(
                                          permission:
                                              AppPermissions
                                                  .deletePerformanceGovernanceSystem,
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
                                                  pgsgovernancesystem['id']
                                                      .toString(),
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10),
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
                        onPageChanged: (page) => fetchPgsList(page: page),
                      ),
                      const SizedBox(width: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton:
          isMinimized
              ? PermissionWidget(
                permission: AppPermissions.addPerformanceGovernanceSystem,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                    if (selectedOffice == null || selectedOffice!.isEmpty) {
                      await _selectOffice();

                      selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                      if (selectedOffice != null &&
                          selectedOffice!.isNotEmpty) {
                        await _loadOfficeName();

                        showFormDialog();
                      } else {}
                    } else {
                      await _loadOfficeName();
                      showFormDialog();
                    }
                  },
                  child: Icon(Icons.add, color: Colors.white),
                ),
              )
              : null,
    );
  }

  String? getSignatoryByOrderLevelDefault(int level) {
    try {
      final signatory = signatoryList.firstWhere(
        (item) => item['orderLevel'] == level,
        orElse: () => <String, dynamic>{},
      );

      if (signatory.isEmpty || signatory['defaultSignatoryId'] == null) {
        return null;
      }
      return signatory['defaultSignatoryId'].toString();
    } catch (e) {
      return null;
    }
  }

  String? getSignatoryTitleByOrderLevel(int level) {
    try {
      final signatory = signatoryList.firstWhere(
        (item) => item['orderLevel'] == level,
        orElse: () => <String, dynamic>{},
      );

      if (signatory.isEmpty || signatory['signatoryLabel'] == null) {
        return null;
      }

      return signatory['signatoryLabel'].toString();
    } catch (e) {
      return null;
    }
  }

  Future<List<PgsSignatory>> fetchSignatoryList({String? pgsId}) async {
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    displaySignatoryList.clear();

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;

        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final signatoriesJson = pgsJson['pgsSignatories'];
          if (signatoriesJson is List) {
            final signatories =
                signatoriesJson.map((d) => PgsSignatory.fromJson(d)).toList();

            displaySignatoryList.addAll(signatories);
          } else {
            debugPrint("No valid 'pgsSignatories' list found in response.");
          }
        }
      } else {
        debugPrint("Failed to fetch signatories");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return displaySignatoryList;
  }

  int? selectedPgsId;

  void onPgsIdChanged(int? newPgsId) {
    setState(() {
      selectedPgsId = newPgsId;
    });
  }

  Future showFormDialog({
    String? userId,
    String? id,
    String? officename,
    int? officenameid,
    String? startDate,
    String? endDate,
    String? competencescore,
    String? resourcescore,
    String? confidencescore,
    String? selectPeriod,
    String? percentDeliverables,
    List<dynamic>? deliverabledIds,
    List<PgsDeliverables>? deliverables,
    List<PgsSignatory>? signatories,
    List<PgsDeliverableHistory>? pgsDeliverableHistroy,
    PerformanceGovernanceSystem? pgs,
    bool? isDraft,
    String? pgsId,
    String? remarks,
    int? index,
  }) {
    setState(() {
      if (rows.isEmpty) {
        rows = [0];
      }
      officename ?? officeDisplay;
      if (id == null) {
        competenceScore.value = 0.0;
        resourceScore.value = 0.0;
        confidenceScore.value = 0.0;
        selectedPeriod = null;
        selectedPeriodText = null;
        percentageDeliverables.text = '40';
        clearedOnDisapprove.clear();
        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedKRAObjects.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedByWhenControllers.clear();
        selectedStatus.clear();
        deliverableIds.clear();
        kraDescriptionController.clear();
        kraDescriptionRoadmapController.clear();
        deliverablesRoadmapControllers.clear();
        reasonController.clear();
        selectedDisapproved.clear();
      } else {
        competenceScore.value = double.tryParse(competencescore ?? '') ?? 0.0;
        resourceScore.value = double.tryParse(resourcescore ?? '') ?? 0.0;
        confidenceScore.value = double.tryParse(confidencescore ?? '') ?? 0.0;

        if (percentDeliverables != null) {
          percentageDeliverables.text = percentDeliverables;
        }

        if (startDate != null && endDate != null) {
          final selected = filteredListPeriod.firstWhere(
            (period) =>
                period['startDate'] == startDate &&
                period['endDate'] == endDate,
            orElse: () => {},
          );

          if (selected.isNotEmpty) {
            selectedPeriod = selected['id'];
            selectedPeriodText =
                "${selected['startDate']} - ${selected['endDate']}";
          } else {
            selectedPeriod = null;
            selectedPeriodText = null;
          }
        }

        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedKRAObjects.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedByWhenControllers.clear();
        selectedStatus.clear();
        deliverableIds.clear();
        kraDescriptionController.clear();
        kraDescriptionRoadmapController.clear();
        deliverablesRoadmapControllers.clear();
        reasonController.clear();
        selectedDisapproved.clear();
        clearedOnDisapprove.clear();

        if (deliverables != null && deliverables.isNotEmpty) {
          rows = List.generate(deliverables.length, (index) => index);

          for (int i = 0; i < deliverables.length; i++) {
            final item = deliverables[i];
            deliverablesControllers[i] = TextEditingController(
              text: item.deliverableName,
            );
            deliverablesControllersDisapproved[i] = TextEditingController(
              text: item.deliverableName,
            );

            selectedDirect[i] = item.isDirect;
            selectedIndirect[i] = !item.isDirect;
            selectedByWhen[i] = DateFormat('yyyy-MM-dd').format(item.byWhen);
            selectedByWhenControllers[i] = TextEditingController(
              text: DateFormat('MMMM yyyy').format(item.byWhen),
            );
            selectedStatus[i] = item.status;
            deliverableIds[i] = item.id ?? 0;

            selectedKRA[i] = item.kra!.id;
            final selectedKraId = item.kra!.id;
            final kraOption = options.firstWhere(
              (option) => option['id'] == selectedKraId,
              orElse: () => {'id': 0, 'name': 'Unknown', 'remarks': ''},
            );
            selectedKRAObjects[i] = kraOption;
            remarksControllers[i] = TextEditingController(text: item.remarks);
            percentageControllers[i] = TextEditingController(
              text: item.percentDeliverables.toString(),
            );

            kraDescriptionController[i] = TextEditingController(
              text: item.kraDescription,
            );
            reasonController[i] = TextEditingController(
              text: item.disapprovalRemarks,
            );
            selectedDisapproved[i] = item.isDisapproved;
          }
        } else {
          rows = [0];
        }
      }
    });
    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentSignatory = signatoryList.firstWhere(
              (signatory) =>
                  signatory['signatoryId'].toString() == userId.toString(),
              orElse: () => {'id': 0, 'orderLevel': 0},
            );

            final orderLevel = currentSignatory['orderLevel'] ?? 0;

            final idSig = int.tryParse(currentSignatory['id'].toString()) ?? 0;

            final isAnyDisapproved =
                deliverables?.any((d) => d.isDisapproved == true) ?? false;
            final isDraftSafe = isDraft ?? false;
            bool showButton = !isDraftSafe && orderLevel >= 1 && idSig == 0;

            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: primaryTextColor,
                        size: 32,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('selectedOfficeId');
                        await prefs.remove('selectedOfficeName');
                        setDialogState(() {
                          Navigator.pop(context);
                          clearAllSelections();
                          fetchPgsList();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: DefaultTabController(
                        length: 3,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Header Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/CRMC.png', height: 90),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        id == null
                                            ? 'COTABATO REGIONAL AND MEDICAL CENTER'
                                            : 'COTABATO REGIONAL AND MEDICAL CENTER',

                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Container(
                                        width: 400,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Tooltip(
                                          message:
                                              'A defined timeframe (quarter, semester, or year) used to track, evaluate, and report performance deliverables.',

                                          child: DropdownButtonFormField<int>(
                                            autovalidateMode:
                                                AutovalidateMode
                                                    .onUserInteraction,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select a period date';
                                              }
                                              return null;
                                            },
                                            hint: const Center(
                                              child: Text(
                                                'Select a Period',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),

                                            value: selectedPeriod,
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged:
                                                !hasEditPermission
                                                    ? null
                                                    : (int? newValue) {
                                                      setState(() {
                                                        selectedPeriod =
                                                            newValue;

                                                        selectedPeriodObject =
                                                            filteredListPeriod
                                                                .firstWhere(
                                                                  (period) =>
                                                                      period['id'] ==
                                                                      newValue,
                                                                  orElse:
                                                                      () => {},
                                                                );

                                                        if (selectedPeriodObject!
                                                            .isNotEmpty) {
                                                          final start =
                                                              selectedPeriodObject!['startDate'];
                                                          final end =
                                                              selectedPeriodObject!['endDate'];

                                                          selectedPeriodText =
                                                              "$start - $end";
                                                        }
                                                      });
                                                    },

                                            selectedItemBuilder: (
                                              BuildContext context,
                                            ) {
                                              return filteredListPeriod.map<
                                                Widget
                                              >((period) {
                                                final start = _dateConverter
                                                    .toJson(
                                                      _dateConverter.fromJson(
                                                        period['startDate'],
                                                      ),
                                                    );
                                                final end = _dateConverter
                                                    .toJson(
                                                      _dateConverter.fromJson(
                                                        period['endDate'],
                                                      ),
                                                    );
                                                return Center(
                                                  child: Text(
                                                    "$start to $end",
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              }).toList();
                                            },

                                            items:
                                                filteredListPeriod.map<
                                                  DropdownMenuItem<int>
                                                >((period) {
                                                  final start = _dateConverter
                                                      .toJson(
                                                        _dateConverter.fromJson(
                                                          period['startDate'],
                                                        ),
                                                      );
                                                  final end = _dateConverter
                                                      .toJson(
                                                        _dateConverter.fromJson(
                                                          period['endDate'],
                                                        ),
                                                      );
                                                  return DropdownMenuItem<int>(
                                                    value: period['id'],
                                                    child: Center(
                                                      child: Text(
                                                        "$start to $end",
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              TabBar(
                                labelColor: primaryLightColor,
                                unselectedLabelColor: Colors.black,
                                indicatorColor: primaryColor,
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                tabs: [
                                  Tab(
                                    text: "Strategic Contributions",
                                  ), // Tab Name 1
                                  Tab(
                                    text:
                                        "Readiness Rating - ${officename ?? officeDisplay}",
                                  ), // Tab Name 2
                                  Tab(
                                    text: "PGS Deliverables Status",
                                  ), // Tab Name 3
                                  // Tab(
                                  //   text: "PGS Deliverables History",
                                  // ), // Tab Name 4
                                ],
                              ),
                              //First Tab Strategic Contributions
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 20),

                                        Expanded(
                                          child: SingleChildScrollView(
                                            controller: _tableScrollController,
                                            child: Column(
                                              children: [
                                                // MAIN HEADER TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(3.5),
                                                    1: FlexColumnWidth(1.0),
                                                    2: FlexColumnWidth(2.2),
                                                    3: FlexColumnWidth(2.2),
                                                  },
                                                  children: [
                                                    _buildMainHeaderStrategic(
                                                      officename:
                                                          officename ??
                                                          officeDisplay,
                                                    ),
                                                  ],
                                                ),

                                                // SUB HEADER TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(0.2),
                                                    1: FlexColumnWidth(1.8),
                                                    2: FlexColumnWidth(1.5),
                                                    3: FlexColumnWidth(0.5),
                                                    4: FlexColumnWidth(0.5),
                                                    5: FlexColumnWidth(2.2),
                                                    6: FlexColumnWidth(1),
                                                    7: FlexColumnWidth(1.2),
                                                  },
                                                  children: [
                                                    _buildTableSubHeaderStrategic(),
                                                  ],
                                                ),

                                                // ROWS TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(0.2),
                                                    1: FlexColumnWidth(1.8),
                                                    2: FlexColumnWidth(1.5),
                                                    3: FlexColumnWidth(0.5),
                                                    4: FlexColumnWidth(0.5),
                                                    5: FlexColumnWidth(2.2),
                                                    6: FlexColumnWidth(1),
                                                    7: FlexColumnWidth(1.2),
                                                  },
                                                  children: [
                                                    ...rows.map(
                                                      (
                                                        rowId,
                                                      ) => _buildTableRowStrategic(
                                                        rowId,
                                                        '',
                                                        '',
                                                        setState,
                                                        setDialogState,
                                                        orderLevel,
                                                        id,
                                                        showErrors:
                                                            rowErrors[rowId] ??
                                                            false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        if ((id == null && orderLevel == 0) ||
                                            (id == null && orderLevel >= 1) ||
                                            isAnyDisapproved ||
                                            (signatories == null ||
                                                signatories.isEmpty))
                                          TextButton(
                                            onPressed: () {
                                              setDialogState(() {
                                                _addRow();
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: primaryColor,
                                                ),

                                                Text(
                                                  'Add Row',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    //End First Tab

                                    //Second Tab  Readiness Rating-Cancer Care
                                    Scaffold(
                                      backgroundColor: mainBgColor,
                                      appBar: AppBar(
                                        automaticallyImplyLeading: false,
                                        title: Row(
                                          children: [
                                            Text(
                                              'READINESS RATING - ${(officename ?? officeDisplay).toUpperCase()}',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        toolbarHeight: 60,
                                        backgroundColor: primaryLightColor,
                                      ),
                                      body: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                alignment: Alignment(1.0, 0.0),
                                                padding: EdgeInsets.only(
                                                  right: 50.0,
                                                ),
                                                child: Text(
                                                  'SCORE',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              // Competence Score Dropdown
                                              buildScoreRow(
                                                'COMPETENCE TO DELIVER',
                                                [
                                                  'Teams lack adequate skills and training to deliver performance commitments',
                                                  'Teams are skilled but lack training to deliver performance commitments ',
                                                  'Teams are highly skilled and trained to deliver performance commitments',
                                                ],

                                                competenceScore,
                                              ),

                                              // Resource Availability Dropdown
                                              buildScoreRow(
                                                'RESOURCE AVAILABILITY',
                                                [
                                                  'Insufficient; external resources difficult to source',
                                                  'Sufficient resources but not available; OR Insufficient but external resources can be tapped',
                                                  'Sufficient and available staff and budget',
                                                ],

                                                resourceScore,
                                              ),

                                              // Confidence to Deliver Dropdown
                                              buildScoreRow(
                                                'CONFIDENCE TO DELIVER',
                                                [
                                                  'Low confidence because of high degree of organizational change required',
                                                  'Moderate confidence',
                                                  'High confidence despite organizational change required',
                                                ],

                                                confidenceScore,
                                              ),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ValueListenableBuilder<
                                                    double
                                                  >(
                                                    valueListenable:
                                                        competenceScore,
                                                    builder: (
                                                      context,
                                                      comp,
                                                      __,
                                                    ) {
                                                      return ValueListenableBuilder<
                                                        double
                                                      >(
                                                        valueListenable:
                                                            resourceScore,
                                                        builder: (
                                                          context,
                                                          res,
                                                          __,
                                                        ) {
                                                          return ValueListenableBuilder<
                                                            double
                                                          >(
                                                            valueListenable:
                                                                confidenceScore,
                                                            builder: (
                                                              context,
                                                              conf,
                                                              __,
                                                            ) {
                                                              final totalScore =
                                                                  comp +
                                                                  res +
                                                                  conf;
                                                              return Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      right:
                                                                          60.0,
                                                                    ),
                                                                child: Text(
                                                                  ('TOTAL SCORE: ${totalScore.toStringAsFixed(1)}'),

                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    //End Second Tab

                                    // Third Tab: PGS Deliverable Status
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                // MAIN HEADER TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(3.5),
                                                    1: FlexColumnWidth(1.0),
                                                    2: FlexColumnWidth(2.2),
                                                    3: FlexColumnWidth(2.2),
                                                  },
                                                  children: [
                                                    _PgsDeliverableHeader(
                                                      officename:
                                                          officename ??
                                                          officeDisplay,
                                                    ),
                                                  ],
                                                ),

                                                // SUB HEADER TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(0.2),
                                                    1: FlexColumnWidth(1.8),
                                                    2: FlexColumnWidth(1.5),
                                                    3: FlexColumnWidth(0.5),
                                                    4: FlexColumnWidth(0.5),
                                                    5: FlexColumnWidth(2.2),
                                                    6: FlexColumnWidth(1),
                                                    7: FlexColumnWidth(1.2),
                                                  },
                                                  children: [
                                                    _pgsBuildTableSubheader(),
                                                  ],
                                                ),

                                                // ROWS TABLE
                                                Table(
                                                  border: TableBorder.all(
                                                    color: Color.fromARGB(
                                                      255,
                                                      49,
                                                      46,
                                                      46,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(0.2),
                                                    1: FlexColumnWidth(1.8),
                                                    2: FlexColumnWidth(1.5),
                                                    3: FlexColumnWidth(0.5),
                                                    4: FlexColumnWidth(0.5),
                                                    5: FlexColumnWidth(2.2),
                                                    6: FlexColumnWidth(1),
                                                    7: FlexColumnWidth(1.2),
                                                  },
                                                  children: [
                                                    ...rows.map(
                                                      (
                                                        rowId,
                                                      ) => _buildTableRowStrategicPGSDeliverableStatus(
                                                        rowId,
                                                        '',
                                                        '',
                                                        setState,
                                                        orderLevel,
                                                        id,
                                                        setDialogState,
                                                        showErrors:
                                                            rowErrors[rowId] ??
                                                            false,
                                                      ),
                                                    ),
                                                  ],
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              actions: [
                if ((id == null) ||
                    isAnyDisapproved ||
                    (signatories == null || signatories.isEmpty))
                  PermissionWidget(
                    permission: AppPermissions.draftPerformanceGovernanceSystem,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: secondaryBgButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        setDialogState(() {
                          rowErrors.clear();
                          for (final index in rows) {
                            final isDirectSelected =
                                selectedDirect[index] ?? false;
                            final isIndirectSelected =
                                selectedIndirect[index] ?? false;

                            rowErrors[index] =
                                !(isDirectSelected || isIndirectSelected);
                          }
                        });

                        final hasRowErrors = rowErrors.values.any(
                          (error) => error == true,
                        );

                        if (_formKey.currentState!.validate() &&
                            !hasRowErrors) {
                          handlePgsAction(
                            context,
                            id,
                            orderLevel,
                            actionType: ActionType.draft,
                          );
                        }
                      },
                      child: Text(
                        'Save as Draft',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),

                if ((isAnyDisapproved || id != null) &&
                    (signatories == null || signatories.isEmpty))
                  PermissionWidget(
                    permission: AppPermissions.draftPerformanceGovernanceSystem,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      onPressed: () {
                        setDialogState(() {
                          rowErrors.clear();
                          for (final index in rows) {
                            final isDirectSelected =
                                selectedDirect[index] ?? false;
                            final isIndirectSelected =
                                selectedIndirect[index] ?? false;

                            rowErrors[index] =
                                !(isDirectSelected || isIndirectSelected);
                          }
                        });
                        final hasRowErrors = rowErrors.values.any(
                          (error) => error == true,
                        );

                        if (_formKey.currentState!.validate() &&
                            !hasRowErrors) {
                          if (deliverablesControllers.length < 5) {
                            MotionToast.warning(
                              title: const Text("Insufficient Deliverables"),
                              description: const Text(
                                "Please provide at least 5 deliverables.",
                              ),
                              toastAlignment: Alignment.center,
                            ).show(context);
                            return;
                          }

                          handlePgsAction(
                            context,
                            id,
                            orderLevel,
                            actionType: ActionType.submit,
                          );
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (showButton)
                  PermissionWidget(
                    permission:
                        AppPermissions.confirmPerformanceGovernanceSystem,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed:
                          () => handlePgsAction(
                            context,
                            id,
                            orderLevel,
                            actionType: ActionType.approve,
                          ),
                      child: Text(
                        'Confirm',
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

  Future<void> handlePgsAction(
    BuildContext context,
    String? id,
    int orderLevel, {
    required ActionType actionType,
  }) async {
    int? pgsId = int.tryParse(id ?? '');
    final updatedDeliverables = getTableDeliverables(pgsId ?? 0);
    bool isAnyDisapproved = updatedDeliverables.any(
      (d) => d.isDisapproved == true,
    );

    if (actionType == ActionType.approve) {
      actionType =
          isAnyDisapproved ? ActionType.disapprove : ActionType.approve;
    }

    String title;
    String content;

    switch (actionType) {
      case ActionType.draft:
        title = "Save as Draft";
        content =
            "Do you want to save this record as a draft? You can come back and make changes later.";
        break;
      case ActionType.submit:
        title = "Confirm Submit";
        content =
            "Are you sure you want to submit this record? You won't be able to make any changes.";
        break;
      case ActionType.approve:
        title = "Confirm Approval";
        content = "Are you sure you want to approve this record?";
        break;
      case ActionType.disapprove:
        title = "Confirm Disapprove";
        content =
            "One or more deliverables are disapproved. Do you want to confirm disapproval?";
        break;
    }

    bool? confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("No", style: TextStyle(color: primaryColor)),
              ),
              ElevatedButton(
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
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    if (selectedPeriod == null) {
      MotionToast.warning(
        title: const Text("Missing Fields"),
        description: const Text("Please select a period."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    if (rows.isEmpty) {
      MotionToast.warning(
        title: const Text("Missing Fields"),
        description: const Text("Please add at least one deliverable."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    for (int i in rows) {
      if (!deliverablesControllers.containsKey(i) ||
          deliverablesControllers[i]!.text.trim().isEmpty) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text(
            "Please fill in all deliverable names (Row ${i + 1}).",
          ),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }

      final isDirect = selectedDirect[i] ?? false;
      final isIndirect = selectedIndirect[i] ?? false;
      if (!isDirect && !isIndirect) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text(
            "Please select Direct or Indirect for Row ${i + 1}.",
          ),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }

      if (!selectedKRA.containsKey(i) || selectedKRA[i] == null) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text("Please select a process (KRA) for Row ${i + 1}."),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }

      // Check "By When" date
      if (!selectedByWhen.containsKey(i) ||
          selectedByWhen[i] == null ||
          selectedByWhen[i]!.isEmpty) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text("Please set a date for Row ${i + 1}."),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }
    }

    if ((actionType != ActionType.draft) && (id == null || id.isEmpty)) {
      MotionToast.error(
        description: Text("PGS ID is missing. Cannot proceed."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    PerformanceGovernanceSystem pgs = getPgsDetails(
      id: pgsId ?? 0,
      pgsStatus:
          actionType == ActionType.draft
              ? "Draft"
              : (actionType == ActionType.disapprove
                  ? "Disapproved"
                  : "Approved"),
    );

    try {
      if (actionType == ActionType.draft) {
        final deliverables = pgs.pgsDeliverables;
        if (deliverables != null) {
          for (final deliverable in deliverables) {
            deliverable.isDisapproved = false;
            deliverable.disapprovalRemarks = '';
          }
        }
        final success = await pgsSaveAsDraft(pgs);
        if (!success) {
          final msg =
              _lastResponseStatusCode == 403
                  ? "You don't have permission to save as draft."
                  : "Failed to save draft!";
          MotionToast.error(
            description: Text(msg),
            toastAlignment: Alignment.center,
          ).show(context);
          return;
        }
      } else if (actionType == ActionType.submit) {
        final currentUser = await AuthUtil.fetchLoggedUser();
        final currentUserId = currentUser?.id;
        final deliverables = pgs.pgsDeliverables;
        if (deliverables != null) {
          for (final deliverable in deliverables) {
            deliverable.isDisapproved = false;
            deliverable.disapprovalRemarks = '';
          }
        }
        final success = await submitPGS(
          pgsId: id!,
          updatePgs: pgs,
          userId: currentUserId.toString(),
        );
        if (!success) {
          final msg =
              _lastResponseStatusCode == 403
                  ? "You don't have permission to submit."
                  : (orderLevel >= 1
                      ? "Failed to Confirm!"
                      : "Failed to submit!");
          MotionToast.error(
            description: Text(msg),
            toastAlignment: Alignment.center,
          ).show(context);
          return;
        }
      } else {
        final currentUser = await AuthUtil.fetchLoggedUser();
        final currentUserId = currentUser?.id;

        final success = await submitPGS(
          pgsId: id!,
          updatePgs: pgs,
          userId: currentUserId.toString(),
        );
        if (!success) {
          final msg =
              _lastResponseStatusCode == 403
                  ? "You don't have permission to approve/disapprove."
                  : (actionType == ActionType.approve
                      ? "Failed to approve!"
                      : "Failed to disapprove!");
          MotionToast.error(
            description: Text(msg),
            toastAlignment: Alignment.center,
          ).show(context);
          if (actionType != ActionType.draft) {
            await Future.delayed(const Duration(milliseconds: 1500));
          }
          Navigator.pop(context);
          return;
        }
      }

      String successMessage;
      switch (actionType) {
        case ActionType.draft:
          successMessage =
              isAnyDisapproved
                  ? "Saved successfully!"
                  : (id != null && orderLevel >= 1)
                  ? "Confirm successfully!"
                  : "Saved successfully!";
          break;
        case ActionType.submit:
          successMessage = "Submitted successfully!";
          break;
        case ActionType.approve:
          successMessage = "Approved successfully!";
          break;
        case ActionType.disapprove:
          successMessage = "Disapproved successfully!";
          break;
      }

      MotionToast.success(
        description: Text(successMessage),
        toastAlignment: Alignment.center,
      ).show(context);

      Navigator.pop(context);
    } catch (e) {
      String errorMessage;
      switch (actionType) {
        case ActionType.draft:
          errorMessage = "Failed to save draft!";
          break;
        case ActionType.submit:
          errorMessage =
              orderLevel >= 1 ? "Failed to Confirm!" : "Failed to submit!";
          break;
        case ActionType.approve:
          errorMessage = "Failed to approve!";
          break;
        case ActionType.disapprove:
          errorMessage = "Failed to disapprove!";
          break;
      }

      MotionToast.error(
        description: Text(errorMessage),
        toastAlignment: Alignment.center,
      ).show(context);

      if (actionType != ActionType.draft) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      Navigator.pop(context);
    }
  }

  Widget _buildDatePickerCell(int index, String? id, Function setDialogState) {
    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now);
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message:
            'Specify when this deliverable is expected to be finished. Used to monitor deadlines and keep progress on schedule.',
        child: TextFormField(
          controller: selectedByWhenControllers[index],
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: EdgeInsets.all(8.0),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap:
              !hasEditPermission
                  ? null
                  : () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                              onPrimary: secondaryColor,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      setDialogState(() {
                        selectedByWhen[index] = formattedDate;
                        selectedByWhenControllers[index]?.text = DateFormat(
                          'MMMM yyyy',
                        ).format(pickedDate);
                      });
                    }
                  },
        ),
      ),
    );
  }

  Widget _buildProcess(int index, String? id, Function setDialogState) {
    final selectedKraObject = selectedKRAObjects[index];

    final kraTooltipMessage =
        selectedKraObject?['remarks'] ?? 'No description available';

    bool hasData = hasDataMap[index] ?? true;
    bool hasError = selectedProcessErrors[index] ?? false;

    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );
    debugPrint('Has edit permission: $hasEditPermission');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTooltip(
            key: ValueKey('kra_tooltip_${selectedKRA[index]}'),
            maxLines: 5,
            message: kraTooltipMessage,
            child: Container(
              key: kraDropdownKeys.putIfAbsent(index, () => GlobalKey()),
              child: DropdownButtonFormField<int?>(
                dropdownColor: mainBgColor,
                isExpanded: true,
                value: selectedKRA[index],
                hint: const Text('--Select Process--'),
                onChanged:
                    !hasEditPermission
                        ? null
                        : (int? newValue) async {
                          if (newValue == null) return;

                          setDialogState(() {
                            selectedKRA[index] = newValue;
                            selectedProcessErrors[index] = false;
                            selectedKRAObjects[index] = options.firstWhere(
                              (o) => o['id'] == newValue,
                            );
                          });

                          final data = await _roadMapService
                              .getAllKraDescriptions(kraId: newValue);

                          setDialogState(() {
                            hasDataMap[index] = data.isNotEmpty;
                            kraDescriptionsByIndex[index] = data;
                          });

                          if (!hasData) {
                            setDialogState(() {
                              deliverablesRoadmapControllers[index]?.clear();
                              kraDescriptionRoadmapController[index]?.clear();
                            });
                          }

                          if (data.isEmpty) return;

                          try {
                            final key = kraDropdownKeys[index];
                            final renderBox =
                                key?.currentContext?.findRenderObject()
                                    as RenderBox?;
                            final overlay =
                                Overlay.of(context).context.findRenderObject()
                                    as RenderBox;

                            if (renderBox == null) return;

                            renderBox.localToGlobal(
                              Offset(renderBox.size.width, 0),
                              ancestor: overlay,
                            );

                            final selected = await showGeneralDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: 'KRA Roadmap',
                              barrierColor: Colors.black.withOpacity(0.4),
                              transitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder: (_, __, ___) {
                                return Center(
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(12),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 420,
                                        maxHeight: 480,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Select KRA from roadmap',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    size: 20,
                                                  ),
                                                  splashRadius: 18,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),

                                          const Divider(height: 1),

                                          Expanded(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children:
                                                  data.map((d) {
                                                    final desc =
                                                        d['kraDescription'] ??
                                                        '';
                                                    return ListTile(
                                                      title: Text(desc),
                                                      onTap: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop(desc);
                                                      },
                                                    );
                                                  }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            if (selected == null) return;

                            setDialogState(() {
                              selectedKRAObjects[index]?['selectedDescription'] =
                                  selected;
                            });

                            int filterYear = DateTime.now().year;
                            if (selectedPeriodObject?['startDate'] != null) {
                              final parsed = DateTime.tryParse(
                                selectedPeriodObject!['startDate'],
                              );
                              if (parsed != null) filterYear = parsed.year;
                            }

                            final filter = KraRoadmapFilter(
                              kraId: selectedKRA[index]!,
                              year: filterYear,
                              kraDescription: selected,
                              isDirect: true,
                            );

                            try {
                              final result = await _roadMapService
                                  .kraRoadmapFilter(filter);

                              setDialogState(() {
                                deliverablesRoadmapControllers[index]?.clear();
                                kraDescriptionRoadmapController[index]?.clear();

                                if (result.isNotEmpty) {
                                  if (result.first['deliverableDescription']
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true) {
                                    deliverablesRoadmapControllers[index]!
                                            .text =
                                        result.first['deliverableDescription'];
                                  }

                                  if (result.first['kraDescription']
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true) {
                                    kraDescriptionRoadmapController[index]!
                                        .text = result.first['kraDescription'];
                                  }
                                }
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to filter KRA roadmap'),
                                ),
                              );
                            }
                          } catch (_) {
                            // ignore overlay errors
                          }
                        },
                items:
                    options.map<DropdownMenuItem<int?>>((option) {
                      return DropdownMenuItem<int?>(
                        value: option['id'],
                        child: Text(option['name']),
                      );
                    }).toList(),
                validator: (value) {
                  if (value == null) {
                    return "Please select process";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.grey,
                      width: hasError ? 2 : 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                ),
              ),
            ),
          ),
          if (hasError)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Please select a process',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (!hasData)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'No KRA from roadmap',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProcessStatus(int index, String? id, Function setDialogState) {
    final selectedValue = selectedKRA[index];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTooltip(
          key: ValueKey('kra_tooltip_status_$selectedValue'),
          maxLines: 5,
          message:
              selectedKRAObjects[index]?['remarks'] ??
              'No description available',
          child: Text(
            selectedKRAObjects[index]?['name'] ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownKraCell(int index, String? id, Function setDialogState) {
    if (!kraDescriptionController.containsKey(index)) {
      kraDescriptionController[index] = TextEditingController();
    }

    if (!kraDescriptionRoadmapController.containsKey(index)) {
      kraDescriptionRoadmapController[index] = TextEditingController();
    }

    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTooltip(
            message:
                'Enter a short description of what this KRA focuses on achieving.',
            child: TextFormField(
              readOnly: !hasEditPermission,
              controller: kraDescriptionController[index],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Enter your KRA. (3 to 4 words)",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your KRA";
                }
                return null;
              },
              maxLines: 3,
            ),
          ),

          gap12px,
          SelectableText(
            kraDescriptionRoadmapController[index]!.text.isNotEmpty
                ? 'Sample KRA: ${kraDescriptionRoadmapController[index]!.text}'
                : '',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildMainHeaderStrategic({String? officename}) {
    return TableRow(
      decoration: BoxDecoration(color: primaryLightColor),

      children: [
        GestureDetector(
          key: _menuKey,
          child: BuildHeaderCell(
            text: (officename ?? officeDisplay).toUpperCase(),
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.normal,
          ),
        ),

        BuildHeaderCell(
          text: 'ALIGNMENT',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),

        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),

        // TableCell(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Tooltip(
        //       message:
        //           'This percentage is used during performance reviews to determine how each output affects your overall results.',
        //       child: TextFormField(
        //         readOnly: !hasEditPermission,
        //         controller: percentageDeliverables,
        //         autovalidateMode: AutovalidateMode.onUserInteraction,
        //         textAlign: TextAlign.center,
        //         keyboardType: TextInputType.number,
        //         style: TextStyle(
        //           color: secondaryColor,
        //           fontSize: 20,
        //           fontStyle: FontStyle.normal,
        //         ),
        //         validator: (value) {
        //           if (value == null || value.isEmpty) {
        //             return "Please enter percentage";
        //           }
        //           return null;
        //         },
        //         inputFormatters: [
        //           FilteringTextInputFormatter.digitsOnly,
        //           LengthLimitingTextInputFormatter(2),
        //           RangeInputFormatter(1, 40),
        //         ],

        //         decoration: InputDecoration(
        //           labelText: percentDeliverables,
        //           hintText: '0',
        //           suffixText: '%',
        //           border: OutlineInputBorder(),
        //           suffixStyle: TextStyle(color: secondaryColor, fontSize: 20),
        //           hintStyle: TextStyle(color: Colors.white),
        //           enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.white),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message:
                  'This percentage is used during performance reviews to determine how each output affects your overall results.',
              child: Center(
                child: Text(
                  '40%',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Sub Header
  TableRow _buildTableSubHeaderStrategic() {
    return TableRow(
      decoration: BoxDecoration(color: peachLight),
      children: [
        BuildHeaderCell(text: '#'),
        BuildHeaderCell(text: 'PROCESS (CORE & SUPPORT)'),
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'BY WHEN'),
        BuildHeaderCell(text: 'ACTION'),
      ],
    );
  }

  // PGS Table Row  Strategic
  TableRow _buildTableRowStrategic(
    int index,
    String direct,
    String indirect,
    Function setState,
    Function setDialogState,
    int orderLevel,
    String? id, {
    required bool showErrors,
  }) {
    deliverablesControllers.putIfAbsent(index, () => TextEditingController());
    selectedDirect.putIfAbsent(index, () => true);
    selectedIndirect.putIfAbsent(index, () => false);
    selectedByWhen.putIfAbsent(index, () => '');
    final isDirectSelected = selectedDirect[index] ?? false;
    final isIndirectSelected = selectedIndirect[index] ?? false;
    final errorText =
        (!isDirectSelected && !isIndirectSelected && showErrors)
            ? 'Please select either Direct or Indirect.'
            : null;

    // bool hasDisapprovePermission = permissionService.hasPermission(
    //   AppPermissions.disapprovePerformanceGovernanceSystem,
    // );
    Color rowColor = (index % 2 == 0) ? mainBgColor : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        _buildNumbering(index),
        _buildProcess(index, id, setDialogState),
        _buildDropdownKraCell(index, id, setDialogState),
        _buildCheckboxCell(
          index,
          id,
          selectedDirect,
          selectedIndirect,
          setDialogState,
          isDirect: true,
          errorText: errorText,
        ),
        _buildCheckboxCell(
          index,
          id,
          selectedIndirect,
          selectedDirect,
          setDialogState,
          isDirect: false,
          errorText: errorText,
        ),
        _buildExpandableTextAreaCell(index, id, setDialogState),
        _buildDatePickerCell(index, id, setDialogState),
        (id == null || orderLevel < 1)
            ? _buildRemoveButton(index, setDialogState)
            : _buildApprovedDisapprovedSignatory(index, setDialogState),
      ],
    );
  }

  Widget _buildNumbering(int index) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: Text((index + 1).toString(), style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildCheckboxCell(
    int index,
    String? id,
    Map<int, bool> selectedValues,
    Map<int, bool> oppositeValues,
    Function setDialogState, {
    required bool isDirect,
    required String? errorText,
  }) {
    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message:
                isDirect
                    ? 'Direct: Indicates if the deliverable is directly managed by the office.'
                    : 'Indirect: Indicates if the deliverable is indirectly supported by the office.',
            child: Center(
              child: Checkbox(
                value: selectedValues[index] ?? false,
                onChanged:
                    !hasEditPermission
                        ? null
                        : (bool? newValue) async {
                          if (newValue == null) return;

                          setDialogState(() {
                            selectedValues[index] = newValue;

                            if (newValue) {
                              oppositeValues[index] = false;
                            }
                          });

                          final bool isDirectValue =
                              selectedDirect[index] == true;

                          int filterYear = DateTime.now().year;
                          if (selectedPeriodObject != null &&
                              selectedPeriodObject!['startDate'] != null) {
                            final parsed = DateTime.tryParse(
                              selectedPeriodObject!['startDate'],
                            );
                            if (parsed != null) filterYear = parsed.year;
                          }

                          final filter = KraRoadmapFilter(
                            kraId: selectedKRAObjects[index]?['id'] ?? 0,
                            year: filterYear,
                            kraDescription:
                                kraDescriptionRoadmapController[index]?.text ??
                                '',
                            // kraDescription:
                            //     kraDescriptionController[index]?.text ?? '',
                            isDirect: isDirectValue,
                          );

                          try {
                            final result = await _roadMapService
                                .kraRoadmapFilter(filter);

                            setDialogState(() {
                              if (result.isNotEmpty &&
                                  result.first['kraDescription']
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true) {
                                kraDescriptionRoadmapController[index]!.text =
                                    result.first['kraDescription'];
                              }
                            });
                          } catch (e) {
                            //uwu
                          }
                        },
                activeColor: Colors.white,
                checkColor: Colors.black,
              ),
            ),
          ),

          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText,
                style: const TextStyle(color: primaryColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  //Readiness Rating-Cancer Care Table
  Widget buildScoreRow(
    String title,
    List<String> descriptions,
    ValueNotifier<double> selectedValue,
  ) {
    List<Color> boxColors = [
      const Color.fromARGB(197, 235, 235, 235),
      secondaryBgButton,
      primaryLightColor,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < descriptions.length; i++)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 120,
                  decoration: BoxDecoration(
                    color: boxColors[i],
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${i * 0.5}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              width: 150,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 243, 243),
                ),
                borderRadius: BorderRadius.circular(1),
              ),
              child: ValueListenableBuilder<double>(
                valueListenable: selectedValue,
                builder: (context, value, child) {
                  return DropdownButton<double>(
                    value: value,
                    onChanged: (newValue) {
                      selectedValue.value = newValue!;
                    },
                    items: List.generate(descriptions.length, (index) {
                      return DropdownMenuItem(
                        value: index * 0.5,
                        child: Center(
                          child: Text(
                            '${index * 0.5}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                    underline: Container(),
                    isExpanded: true,
                    alignment: Alignment.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
  // End Readiness Rating-Cancer Care

  //PGS DELIVERABLES STATUS
  // ignore: non_constant_identifier_names
  TableRow _PgsDeliverableHeader({String? officename}) {
    return TableRow(
      children: [
        BuildHeaderCell(
          text: 'OFFICE: ${(officename ?? officeDisplay).toUpperCase()}',
          fontSize: 15,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: 'ALIGNMENT'),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          fontSize: 15,
          fontStyle: FontStyle.normal,
        ),

        // TableCell(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Tooltip(
        //       message:
        //           'This percentage is used during performance reviews to determine how each output affects your overall results.',
        //       child: TextFormField(
        //         readOnly: !hasEditPermission,
        //         controller: percentageDeliverables,
        //         textAlign: TextAlign.center,
        //         keyboardType: TextInputType.number,
        //         style: TextStyle(
        //           color: const Color.fromARGB(255, 10, 7, 1),
        //           fontSize: 20,
        //           fontStyle: FontStyle.normal,
        //         ),
        //         inputFormatters: [
        //           FilteringTextInputFormatter.digitsOnly,
        //           LengthLimitingTextInputFormatter(2),
        //           RangeInputFormatter(1, 40),
        //         ],

        //         decoration: InputDecoration(
        //           labelText: percentDeliverables,
        //           hintText: '0',
        //           suffixText: '%',
        //           suffixStyle: TextStyle(
        //             color: const Color.fromARGB(255, 15, 11, 1),
        //             fontSize: 20,
        //           ),
        //           hintStyle: TextStyle(color: Colors.white),
        //           enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.white),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message:
                  'This percentage is used during performance reviews to determine how each output affects your overall results.',
              child: Center(
                child: Text(
                  '40%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _pgsBuildTableSubheader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        BuildHeaderCell(text: '#'),
        BuildHeaderCell(text: 'PROCESS (CORE & SUPPORT)'),
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'BY WHEN'),
        BuildHeaderCell(text: 'ACTION'),
      ],
    );
  }

  //END PGS DELIVERABLES STATUS

  // start-----------------------PGS Deliverable Status---------------------

  TableRow _buildTableRowStrategicPGSDeliverableStatus(
    int index,
    String direct,
    String indirect,
    Function setState,
    int orderLevel,
    String? id,
    Function setDialogState, {
    required bool showErrors,
  }) {
    deliverablesControllers.putIfAbsent(index, () => TextEditingController());
    selectedDirect.putIfAbsent(index, () => false);
    selectedIndirect.putIfAbsent(index, () => false);
    selectedByWhen.putIfAbsent(index, () => '');
    int deliverableId = int.tryParse(id ?? '') ?? 0;
    // Define alternating row colors
    Color rowColor = (index % 2 == 0) ? mainBgColor : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        _buildNumbering(index),
        // _buildProcess(index, id, setDialogState),
        _buildProcessStatus(index, id, setDialogState),

        // _buildDropdownKraCellPGSDeliverableStatus(
        //   index,
        //   id,
        //   setDialogState,
        //   orderLevel,
        // ),
        _buildKraDescriptionStatus(index, id, setDialogState),

        _buildCheckboxCell(
          index,
          id,
          selectedDirect,
          selectedIndirect,
          setDialogState,
          isDirect: true,
          errorText: '',
        ),
        _buildCheckboxCell(
          index,
          id,
          selectedIndirect,
          selectedDirect,
          setDialogState,
          isDirect: false,
          errorText: '',
        ),
        // _buildExpandableTextAreaCellPGSDeliverable(
        //   index,
        //   id,
        //   orderLevel,
        //   setDialogState,
        // ),
        _buildExpandableTextAreaCelStatus(index, id, setDialogState),
        _buildDatePickerCellPgsDeliverableStatus(
          index,
          id,
          setDialogState,
          orderLevel,
        ),
        _buildCreateAccomplishmentCell(index, deliverableId),
      ],
    );
  }

  Widget _buildCreateAccomplishmentCell(int index, int deliverableId) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
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
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 221, 221, 221);
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 221, 221, 221);
                  }
                  return null; // default
                }),
              ),

              onPressed: () async {
                if (deliverableId == 0) {
                  MotionToast.warning(
                    title: const Text("Deliverable Not Saved"),
                    description: const Text(
                      "Please save your deliverable first before creating an accomplishment.",
                    ),
                    toastAlignment: Alignment.center,
                  ).show(context);
                  return;
                }
                await loadAccomplishments(deliverableId);
                _showAccomplishmentDialog(index);
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
          gap8px,
          SizedBox(
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
                overlayColor: MaterialStateProperty.resolveWith<Color?>((
                  states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 221, 221, 221);
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 221, 221, 221);
                  }
                  return null; // default
                }),
              ),

              onPressed: () async {
                if (deliverableId == 0) {
                  MotionToast.warning(
                    title: const Text("Deliverable Not Saved"),
                    description: const Text(
                      "Please save your deliverable first before creating an accomplishment.",
                    ),
                    toastAlignment: Alignment.center,
                  ).show(context);
                  return;
                }
                await loadAccomplishments(deliverableId);
                showBreakthroughFormDialog(index, context, userId);
              },
              icon: const Icon(
                Icons.bar_chart_outlined,
                size: 14,
                color: primaryTextColor,
              ),
              label: const Text(
                'Breakthrough Scoring',
                style: TextStyle(color: primaryTextColor, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> getPeriodMonths(dynamic period) {
    final startDate = DateTime.parse(period['startDate']);
    final endDate = DateTime.parse(period['endDate']);

    List<DateTime> months = [];
    DateTime currentDate = DateTime(startDate.year, startDate.month);

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(DateTime(endDate.year, endDate.month))) {
      months.add(currentDate);
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    return months;
  }

  void _showAccomplishmentDialog(int index) async {
    final selectedPeriodData = filteredListPeriod.firstWhere(
      (p) => p['id'] == selectedPeriod,
    );
    final startAndEndDates = getPeriodMonths(selectedPeriodData);
    final int? kraId = selectedKRA[index];
    final String kraName =
        options.firstWhere(
          (o) => o['id'] == kraId,
          orElse:
              () => {
                'id': 1,
                'name': 'Unknown',
                'remarks': '',
                'isDeleted': false,
                'rowVersion': '',
              },
        )['name'];
    final int deliverableId = deliverableIds[index] ?? 0;
    final String deliverableName = deliverablesControllers[index]?.text ?? '';
    final bool isDirect = selectedDirect[index] ?? false;
    final String byWhen = selectedByWhen[index] ?? '';

    final parsedByWhen = DateTime.parse(byWhen);
    final String formattedByWhen = DateFormat('MMMM yyyy').format(parsedByWhen);

    final startDate = DateTime.parse(selectedPeriodData['startDate']);
    final endDate = DateTime.parse(selectedPeriodData['endDate']);
    final formattedStart = DateFormat.yMMMMd().format(startDate);
    final formattedEnd = DateFormat.yMMMMd().format(endDate);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: mainBgColor,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                "Accomplishment Form - $formattedStart to $formattedEnd",
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
                                    Text("KRA: $kraName"),
                                    Text(
                                      "Monthly Tracking Periods: ${startAndEndDates.length} month(s)",
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
                                    Text("Deliverable: $deliverableName"),
                                    Text("Due: $formattedByWhen"),
                                  ],
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  "Type: ${isDirect ? 'Direct' : 'Indirect'}",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                // Table headers
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

                                // Table rows
                                Column(
                                  children: [
                                    const Divider(height: 1),
                                    AccomplishmentListView(
                                      index: index,
                                      startAndEndDates: startAndEndDates,
                                      deliverableId: deliverableId,
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
                  const SizedBox(height: 20),
                  Row(
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
                                  title: const Text("Confirm Save"),
                                  content: const Text(
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

                          await saveAccomplishmentData(deliverableId, userId);
                          MotionToast.success(
                            description: Text('Save Successfully'),
                            toastAlignment: Alignment.topCenter,
                          ).show(context);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          "Save Accomplishment",
                          style: TextStyle(color: Colors.white),
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
  }

  Future<bool?> showBreakthroughFormDialog(
    int index,
    BuildContext context,
    String userId,
  ) {
    final int? kraId = selectedKRA[index];
    final String kraName =
        options.firstWhere(
          (o) => o['id'] == kraId,
          orElse:
              () => {
                'id': 1,
                'name': 'Unknown',
                'remarks': '',
                'isDeleted': false,
                'rowVersion': '',
              },
        )['name'];
    final int deliverableId = deliverableIds[index] ?? 0;
    final String deliverableName = deliverablesControllers[index]?.text ?? '';
    final bool isDirect = selectedDirect[index] ?? false;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: mainBgColor,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("KRA: $kraName")],
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "Type: ${isDirect ? 'Direct' : 'Indirect'}",
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Deliverable: $deliverableName",
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
                                      deliverableId: deliverableId,
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
                            await saveBreakthroughData(deliverableId);
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

  // Widget _buildDropdownKraCellPGSDeliverableStatus(
  //   int index,
  //   String? id,
  //   Function setDialogState,
  //   int orderLevel,
  // ) {
  //   if (!kraDescriptionController.containsKey(index)) {
  //     kraDescriptionController[index] = TextEditingController();
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Tooltip(
  //           message:
  //               'Enter a short description of what this KRA focuses on achieving.',
  //           child: TextFormField(
  //             readOnly: id != null && orderLevel >= 1,
  //             controller: kraDescriptionController[index],
  //             decoration: const InputDecoration(
  //               hintText: "Enter your description here...",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildKraDescriptionStatus(
    int index,
    String? id,
    Function setDialogState,
  ) {
    if (!kraDescriptionController.containsKey(index)) {
      kraDescriptionController[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: kraDescriptionController[index]!,
        builder: (context, value, child) {
          return Text(
            value.text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          );
        },
      ),
    );
  }

  //Start---------------------Pgs Deliverable datepicker status---------------------------------------
  Widget _buildDatePickerCellPgsDeliverableStatus(
    int index,
    String? id,
    Function setDialogState,
    int orderLevel,
  ) {
    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now);
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message:
            'Specify when this deliverable is expected to be finished. Used to monitor deadlines and keep progress on schedule.',
        child: TextFormField(
          controller: selectedByWhenControllers[index],
          readOnly: true,
          style: TextStyle(fontSize: 13.50),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: EdgeInsets.all(8.0),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap:
              id != null && orderLevel >= 1
                  ? null
                  : () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                              onPrimary: secondaryColor,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      setDialogState(() {
                        selectedByWhen[index] = formattedDate;
                        selectedByWhenControllers[index]?.text = DateFormat(
                          'MMMM yyyy',
                        ).format(pickedDate);
                      });
                    }
                  },
        ),
      ),
    );
  }
  //End---------------------Pgs Deliverable Status---------------------------------------

  // Start-----------------------PGS Deliverable Status---------------------
  // Dropdown field that allows changing PgsStatus for each row
  // Widget _buildDropdownCellStatusPgsDeliverableStatus(
  //   int index,
  //   VoidCallback setDialogState,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: DropdownButtonFormField<PgsStatus>(
  //       value: selectedStatus[index] ?? PgsStatus.notStarted,
  //       onChanged: null,
  //       isExpanded: true,
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.all(8.0),
  //       ),

  //       items:
  //           PgsStatus.values.map((PgsStatus value) {
  //             return DropdownMenuItem<PgsStatus>(
  //               value: value,
  //               child: Text(value.name, style: const TextStyle(fontSize: 13)),
  //             );
  //           }).toList(),
  //     ),
  //   );
  // }
  // End-----------------------PGS Deliverable Status---------------------

  //Start------------Pgs Deliverables Status----------------------------------------------
  // Widget _buildExpandableTextAreaCellPGSDeliverable(
  //   int index,
  //   String? id,
  //   int orderLevel,
  //   Function setDialogState,
  // ) {
  //   if (!deliverablesControllers.containsKey(index)) {
  //     deliverablesControllers[index] = TextEditingController();
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ConstrainedBox(
  //       constraints: BoxConstraints(minHeight: 50.0),
  //       child: Tooltip(
  //         message:
  //             'Specify the tangible results or outcomes tied to this responsibility.',
  //         child: TextFormField(
  //           readOnly: id != null && orderLevel >= 1,
  //           controller: deliverablesControllers[index],
  //           maxLines: null,
  //           keyboardType: TextInputType.multiline,
  //           style: TextStyle(fontSize: 14.0),
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(),
  //             contentPadding: EdgeInsets.all(8.0),
  //           ),
  //           onChanged: (value) {
  //             deliverableUserEdited[index] = true;
  //             setState(() {});
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildExpandableTextAreaCelStatus(
    int index,
    String? id,
    Function setDialogState,
  ) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: deliverablesControllers[index]!,
        builder: (context, value, child) {
          return Text(
            value.text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          );
        },
      ),
    );
  }

  //End------------Pgs Deliverables Status----------------------------------------------

  // Removed Rows
  void _removeRowAndRemap(int index, Function setDialogState) {
    setDialogState(() {
      rows.removeAt(index);
      rows = List<int>.generate(rows.length, (i) => i + 0);

      final allMapsToRemap = [
        deliverablesControllers,
        deliverablesRoadmapControllers,
        deliverablesControllersDisapproved,
        deliverableUserEdited,
        clearedOnDisapprove,
        selectedByWhenControllers,
        selectedKRAObjects,
        remarksControllers,
        percentageControllers,
        selectedStatus,
        selectedValues,
        selectedByWhen,
        selectedStatusOptions,
        selectedKRA,
        selectedDirect,
        selectedIndirect,
        tempSelectedDirect,
        tempSelectedIndirect,
        deliverableIds,
        signatoryIds,
        hasDataMap,
        isLoadingDescriptions,
        kraDescriptionsByIndex,
        kraDropdownKeys,
        selectedKraDescription,
        rowErrors,
        reasonController,
        kraDescriptionController,
        kraDescriptionRoadmapController,
        selectedDisapproved,
      ];

      for (final map in allMapsToRemap) {
        map.remove(index);

        final keysToRemap =
            map.keys.where((key) => key > index).toList()..sort();

        for (final oldKey in keysToRemap) {
          final value = map.remove(oldKey);
          if (value != null) {
            map[oldKey - 1] = value;
          }
        }
      }
    });
  }

  Widget _buildRemoveButton(int index, Function setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        gap16px,
        IconButton(
          tooltip: 'Remove row',
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                    'Are you sure you want to delete this row?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _removeRowAndRemap(index, setDialogState);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildReasonDisapproval(int index, Function setDialogState) {
    bool? isDisapproved = selectedDisapproved[index];
    reasonController[index] ??= TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDisapproved == true) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  226,
                  85,
                  74,
                ).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 201, 149, 145),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 204, 65, 55),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.warning_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Disapproved",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  gap16px,
                  Text(
                    "Reason for Disapproval",
                    style: TextStyle(
                      fontSize: 14,

                      color: Color.fromARGB(255, 185, 28, 28),
                    ),
                  ),
                  gap6px,
                  Text(
                    reasonController[index]?.text ?? 'No reason provided',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  gap16px,
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    thickness: 0.3,
                    indent: 1,
                    endIndent: 1,
                  ),

                  gap4px,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.article_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Original Submission',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 107, 107, 107),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  gap6px,
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 60,
                      maxHeight: 120,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '"${deliverablesControllersDisapproved[index]?.text ?? 'No deliverables'}"',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildApprovedDisapprovedSignatory(
    int index,
    Function setDialogState,
  ) {
    bool? isDisapproved = selectedDisapproved[index];
    reasonController[index] ??= TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  tooltip: 'Click this to approve the deliverable',
                  icon: Icon(
                    Icons.thumb_up,
                    color:
                        isDisapproved == false
                            ? Colors.green
                            : primaryTextColor,
                  ),
                  onPressed: () {
                    setDialogState(() {
                      selectedDisapproved[index] = false;
                      reasonController[index]?.clear();
                    });
                  },
                ),
                const Text("Approve", style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'Click this to disapprove the deliverable',

                  icon: Icon(
                    Icons.thumb_down,
                    color:
                        isDisapproved == true ? Colors.red : primaryTextColor,
                  ),
                  onPressed: () {
                    setDialogState(() {
                      selectedDisapproved[index] = true;
                    });
                  },
                ),
                const Text("Disapprove", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        if (isDisapproved == true) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reason:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: grey),
                ),
                CustomTooltip(
                  message: 'State your reason here',
                  child: TextField(
                    controller: reasonController[index],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandableTextAreaCell(
    int index,
    String? id,
    Function setDialogState,
  ) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
    }

    if (!deliverablesRoadmapControllers.containsKey(index)) {
      deliverablesRoadmapControllers[index] = TextEditingController();
    }

    bool hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    final currentSignatory = signatoryList.firstWhere(
      (signatory) => signatory['signatoryId'].toString() == userId.toString(),
      orElse: () => {'id': 0, 'orderLevel': 0},
    );
    final orderLevel = currentSignatory['orderLevel'] ?? 0;

    bool showDisapproveControls = false;
    if (selectedDisapproved[index] == true && orderLevel == 0) {
      showDisapproveControls = true;
    } else if (deliverablesList.isNotEmpty) {
      showDisapproveControls = deliverablesList.any(
        (deliverable) =>
            deliverable.id == deliverableIds[index] &&
            deliverable.isDisapproved == true,
      );
    }

    if (showDisapproveControls && clearedOnDisapprove[index] != true) {
      deliverablesControllers[index]!.clear();
      clearedOnDisapprove[index] = true;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDisapproveControls) ...[
            StatefulBuilder(
              builder: (context, setDialogState) {
                return _buildReasonDisapproval(index, setDialogState);
              },
            ),
            gap14px,
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50.0),
            child: Tooltip(
              message:
                  'Specify the tangible results or outcomes tied to this responsibility.',
              child: TextFormField(
                readOnly: !hasEditPermission,
                focusNode: FocusNode(canRequestFocus: hasEditPermission),
                controller: deliverablesControllers[index],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),

                validator: (value) {
                  final isDisapproved =
                      selectedDisapproved[index] == true ||
                      deliverablesList.any(
                        (deliverable) =>
                            deliverable.id == deliverableIds[index] &&
                            deliverable.isDisapproved == true,
                      );

                  if (value == null || value.isEmpty) {
                    return isDisapproved
                        ? "Please revise your deliverable"
                        : "Please enter your deliverable";
                  }
                  return null;
                },
                onChanged: (val) {
                  deliverableUserEdited[index] = true;
                },
              ),
            ),
          ),
          gap12px,
          if (deliverablesControllers[index]!.text.isEmpty &&
              selectedKRA[index] != null)
            SelectableText(
              deliverablesRoadmapControllers[index]!.text.isNotEmpty
                  ? 'Sample deliverable: ${deliverablesRoadmapControllers[index]!.text}'
                  : 'No sample deliverables',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }
}
