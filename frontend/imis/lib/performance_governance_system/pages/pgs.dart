import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_action_type.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/pages/pgs_reports.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/roadmap/models/kra_roadmap_filter.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/filter_widget/button_filter.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../performance_governance_system/models/pgs_deliverables.dart';
import '../../performance_governance_system/models/pgs_readiness.dart';
import '../../performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import '../../utils/auth_util.dart';
import '../../utils/permission_service.dart';
import '../../widgets/custom_tooltip.dart';

const _kPrimaryLight = Color(0xFFD4919E);
const _kPrimaryBg = Color(0xFFF2D5D9);
const _kBg = Color(0xFFFAF7F8);
const _kBorder = Color(0xFFE8D5D8);
const _kTextDark = Color(0xFF2D1F22);
const _kTextMid = Color(0xFF6B4E53);
const _kTextLight = Color(0xFF9E8285);
const _kAccentDark = Color(0xFF8B3A4A);

const int _fHandle = 2;
const int _fNo = 2;
const int _fProcess = 9;
const int _fKra = 11;
const int _fDirect = 3;
const int _fIndirect = 3;
const int _fDeliv = 15;
const int _fByWhen = 8;
const int _fAction = 8;

class _DeliverableRow {
  int? id;
  int? kraId;
  bool isDirect;
  String byWhen;

  _DeliverableRow({
    this.id,
    this.kraId,
    this.isDirect = true,
    this.byWhen = '',
  });
}

class Pgs extends StatefulWidget {
  const Pgs({super.key});

  @override
  State<Pgs> createState() => _PerformanceGovernanceSystemPageState();
}

class _PerformanceGovernanceSystemPageState extends State<Pgs> {
  List<PerformanceGovernanceSystem> pgsList = [];
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  final _commonService = CommonService(Dio());
  String? selectedOffice = "";
  String officeDisplay = "";
  String officeIdList = "";
  String? selectedStartDateText;
  int _currentPage = 1;
  final _pgsService = PerformanceGovernanceSystemService(Dio());

  String? selectedStartPeriod;
  String? selectedEndDate;
  String userId = "";

  List<PgsPeriod> pgsPeriodList = [];
  String? _selectedOfficeId;
  bool _isLoading = false;
  final int _pageSize = 15;
  final _paginationUtils = PaginationUtil(Dio());
  List<Map<String, dynamic>> signatoryList = [];
  final dio = Dio();

  final _dateConverter = const LongDateOnlyConverter();
  String? selectedEndDateText;
  int? _lastResponseStatusCode;

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];

  bool get _isMobile => MediaQuery.sizeOf(context).width < 640;
  List<Office> officeList = [];
  List<Map<String, dynamic>> deliverableLists = [];
  List<Map<String, dynamic>> filteredList = [];

  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
    fetchPgsList();
  }

  // ---------------------------------------------------------------------------
  Future<void> fetchPgsList({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return;
      setState(() => userId = user.id ?? "");

      String? roleId;
      final prefs = await SharedPreferences.getInstance();
      final String? selectedRoleName = prefs.getString('selectedRole');
      final roles = await AuthUtil.fetchRoles();
      if (roles != null && roles.isNotEmpty) {
        var currentRole = roles.first;
        if (selectedRoleName != null) {
          try {
            currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
          } catch (_) {}
        }
        roleId = currentRole.id;
      }

      final pageList = await _paginationUtils
          .fetchPaginatedData<PerformanceGovernanceSystem>(
            endpoint:
                "${ApiEndpoint().performancegovernancesystem}/user/$userId",
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            additionalParams: {
              'userId': userId,
              if (roleId != null) 'roleId': roleId,
            },
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  //  API: FILTER
  // ---------------------------------------------------------------------------
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
          } catch (_) {}
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
      if (mounted) setState(() => _isLoading = false);
    }
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

  // ---------------------------------------------------------------------------
  //  API: SAVE AS DRAFT
  // ---------------------------------------------------------------------------
  Future<bool> pgsSaveAsDraft(PerformanceGovernanceSystem audit) async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null || user.id == null || user.id!.isEmpty) {
        _lastResponseStatusCode = 401;
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final url = '${ApiEndpoint().pgsSaveAsDraft}?userId=${user.id}';
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: audit.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) setState(() => fetchPgsList());
        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
        _lastResponseStatusCode = response.statusCode;
        return true;
      } else {
        _lastResponseStatusCode = response.statusCode;
        return false;
      }
    } on DioException catch (e) {
      _lastResponseStatusCode = e.response?.statusCode;
      return false;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //  API: SUBMIT / APPROVE
  // ---------------------------------------------------------------------------
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

      final prefs = await SharedPreferences.getInstance();
      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: updatedPgsJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) setState(() => fetchPgsList());
        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
        _lastResponseStatusCode = response.statusCode;
        return true;
      } else {
        _lastResponseStatusCode = response.statusCode;
        return false;
      }
    } on DioException catch (e) {
      _lastResponseStatusCode = e.response?.statusCode;
      return false;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //  API: FETCH DELIVERABLES
  // ---------------------------------------------------------------------------
  Future<List<PgsDeliverables>> fetchDeliverables({String? pgsId}) async {
    List<PgsDeliverables> list = [];
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
          list.addAll(deliverables);
        }
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
    return list;
  }

  Future<Map<String, dynamic>?> fetchSubmitUserId({
    required String pgsId,
    required String userId,
  }) async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return null;

      String? token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().fetchPGSUserId}/${user.id}?pgsId=$pgsId",
      );
      if (response.statusCode == 200 && mounted) {
        final data = response.data;

        return _mapPgsToListItem(
          PerformanceGovernanceSystem.fromJson(data),
          userId,
        );
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  //  API: FETCH SIGNATORIES
  // ---------------------------------------------------------------------------
  Future<List<PgsSignatory>> fetchSignatoryList({String? pgsId}) async {
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";
    List<PgsSignatory> list = [];
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];
        for (var pgsJson in pgsDataList) {
          final signatoriesJson = pgsJson['pgsSignatories'];
          if (signatoriesJson is List) {
            list.addAll(
              signatoriesJson.map((d) => PgsSignatory.fromJson(d)).toList(),
            );
          }
        }
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
    return list;
  }

  // ---------------------------------------------------------------------------
  //  HANDLE ACTION (draft / submit / approve / disapprove)
  // ---------------------------------------------------------------------------
  Future<void> handlePgsAction(
    BuildContext context,
    String? id,
    int orderLevel, {
    required ActionType actionType,
    required List<PgsDeliverables> deliverables,
    required int? selectedPeriod,
    required String? selectedOfficeId,
    required List<int> rows,
    required Map<int, TextEditingController> deliverablesControllers,
    required Map<int, bool> selectedDirect,
    required Map<int, bool> selectedIndirect,
    required Map<int, int?> selectedKRA,
    required Map<int, String> selectedByWhen,
    required double competence,
    required double resource,
    required double confidence,
    required Map<int, Map<String, dynamic>> selectedKRAObjects,
    required List<Map<String, dynamic>> options,
    required Map<int, TextEditingController> kraDescriptionController,
    required Map<int, TextEditingController> reasonController,
    required Map<int, bool> selectedDisapproved,
    required Map<int, int?> deliverableIds,
    required Map<int, TextEditingController> remarksControllers,
    required Map<int, TextEditingController> percentageControllers,
  }) async {
    bool isAnyDisapproved = deliverables.any((d) => d.isDisapproved == true);

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

    final int pgsId = int.tryParse(id ?? '') ?? 0;

    // Build deliverables list
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
      final deliverableText =
          controller.text.isNotEmpty ? controller.text : "No Name";
      final kraDescriptionText = kraDescriptionController[index]?.text ?? '';
      final isDirect = selectedDirect[index] ?? false;
      final byWhen =
          DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();
      final disapprovalRemarksText = reasonController[index]?.text ?? '';
      final isDisapproved = selectedDisapproved[index] ?? false;
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
          PgsStatus.notStarted,
          pgsId,
          remarks: remarks,
          rowVersion: '',
        ),
      );
    });

    final pgs = PerformanceGovernanceSystem(
      id: pgsId,
      pgsStatus:
          actionType == ActionType.draft
              ? "Draft"
              : (actionType == ActionType.disapprove
                  ? "Disapproved"
                  : "Approved"),
      pgsPeriod: PgsPeriod(
        selectedPeriod,
        false,
        rowVersion: "",
        DateTime.now(),
        DateTime.now(),
        '',
      ),
      office: Office(
        id: int.tryParse(selectedOfficeId ?? '') ?? 0,
        name: officeDisplay,
        officeTypeId: 0,
        parentOfficeId: 0,
        isActive: false,
        rowVersion: "",
      ),
      pgsDeliverables: updatedDeliverables,
      pgsReadinessRating: PgsReadiness(
        0,
        false,
        null,
        competence,
        resource,
        confidence,
        competence + resource + confidence,
      ),
      pgsSignatories: [],
      isDeleted: false,
      isDraft: actionType == ActionType.draft,
      remarks: "",
      rowVersion: "",
      percentDeliverables: 40,
      forSignature: false,
    );

    try {
      bool success = false;
      if (actionType == ActionType.draft) {
        final d = pgs.pgsDeliverables;
        if (d != null) {
          for (final del in d) {
            del.isDisapproved = false;
            del.disapprovalRemarks = '';
          }
        }
        success = await pgsSaveAsDraft(pgs);
        if (!success) {
          MotionToast.error(
            description: Text(
              _lastResponseStatusCode == 403
                  ? "You don't have permission to save as draft."
                  : "Failed to save draft!",
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          return;
        }
      } else if (actionType == ActionType.submit) {
        final currentUser = await AuthUtil.fetchLoggedUser();
        final d = pgs.pgsDeliverables;
        if (d != null) {
          for (final del in d) {
            del.isDisapproved = false;
            del.disapprovalRemarks = '';
          }
        }
        success = await submitPGS(
          pgsId: id!,
          updatePgs: pgs,
          userId: currentUser?.id ?? '',
        );
        if (!success) {
          MotionToast.error(
            description: Text(
              _lastResponseStatusCode == 403
                  ? "You don't have permission to submit."
                  : (orderLevel >= 1
                      ? "Failed to Confirm!"
                      : "Failed to submit!"),
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          return;
        }
      } else {
        final currentUser = await AuthUtil.fetchLoggedUser();
        success = await submitPGS(
          pgsId: id!,
          updatePgs: pgs,
          userId: currentUser?.id ?? '',
        );
        if (!success) {
          MotionToast.error(
            description: Text(
              _lastResponseStatusCode == 403
                  ? "You don't have permission to approve/disapprove."
                  : (actionType == ActionType.approve
                      ? "Failed to approve!"
                      : "Failed to disapprove!"),
            ),
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
          successMessage = "Saved successfully!";
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
      MotionToast.error(
        description: Text("An error occurred."),
        toastAlignment: Alignment.center,
      ).show(context);
      if (actionType != ActionType.draft) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      Navigator.pop(context);
    }
  }

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

  Future<void> _fetchData() async {
    try {
      final periods = await _commonService.fetchPgsPeriod();
      final offices = await _commonService.fetchOffices();

      // Also fetch periods for filter dropdowns
      var url = ApiEndpoint().pgsperiod;
      final response = await AuthenticatedRequest.get(dio, url);
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

      if (mounted) {
        setState(() {
          pgsPeriodList = periods;
          officeList = offices;
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
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

  void _openDialog({Map<String, dynamic>? existingPgs}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => _PgsFormDialog(
            officeName: officeDisplay,
            officeId: officeIdList,
            periods: pgsPeriodList,
            filteredListPeriod: filteredListPeriod,
            commonService: _commonService,
            existingPgs: existingPgs,
            onSaved: () => fetchPgsList(),
            onDraft: (pgs) => pgsSaveAsDraft(pgs),
            onSubmit:
                (pgsId, pgs) =>
                    submitPGS(pgsId: pgsId, updatePgs: pgs, userId: userId),
            lastResponseStatusCode: () => _lastResponseStatusCode,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final permissionService = PermissionService();
    final hasPermission = permissionService.hasPermission(
      AppPermissions.viewPerformanceGovernanceSystem,
    );

    if (!hasPermission) return noPermissionScreen();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Governance Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (isMobile) _buildMobileFilters() else _buildDesktopFilters(),
            const SizedBox(height: 26),
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
                    if (!isMobile) _buildDesktopHeader(),
                    const SizedBox(height: 5),
                    Expanded(child: _buildListView(isMobile)),
                    _buildPagination(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
              ? PermissionWidget(
                permission: AppPermissions.addPerformanceGovernanceSystem,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: _onAddTap,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              )
              : null,
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filter by",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _officeDropdown(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _startDateDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _endDateDropdown()),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        const Text(
          "Filter by",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        const SizedBox(width: 8),
        _buildDropdown(
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _officeDropdown(),
          ),
        ),
        const SizedBox(width: 8),
        _buildDropdown(child: _startDateDropdown()),
        const SizedBox(width: 8),
        _buildDropdown(child: _endDateDropdown()),
        const Spacer(),
        PermissionWidget(
          permission: AppPermissions.addPerformanceGovernanceSystem,
          child: ElevatedButton.icon(
            onPressed: _onAddTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add New', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _officeDropdown() {
    return SearchableDropdown(
      items: ["All Offices", ...officeList.map((o) => o.name)],
      selectedItem:
          _selectedOfficeId == null
              ? "All Offices"
              : (officeList
                      .where((o) => o.id.toString() == _selectedOfficeId)
                      .firstOrNull
                      ?.name ??
                  "All Offices"),
      hintText: "Office",
      searchHint: "Search offices...",
      onChanged: (value) {
        setState(() {
          _selectedOfficeId =
              value == "All Offices"
                  ? null
                  : officeList.firstWhere((o) => o.name == value).id.toString();
          fetchPgsFilter();
        });
      },
    );
  }

  Widget _startDateDropdown() {
    return SearchableDropdown(
      items: [
        "All Start Date",
        ...filteredListPeriod.map(
          (p) => _dateConverter.toJson(DateTime.parse(p['startDate'])),
        ),
      ],
      selectedItem: selectedStartDateText ?? "Start Date",
      hintText: "Start Date",
      searchHint: "Search...",
      onChanged: (value) {
        setState(() {
          if (value == "All Start Date") {
            selectedStartPeriod = null;
            selectedStartDateText = "All Start Date";
          } else {
            final selected = filteredListPeriod.firstWhere(
              (p) =>
                  _dateConverter.toJson(DateTime.parse(p['startDate'])) ==
                  value,
            );
            selectedStartPeriod = selected['startDate'];
            selectedStartDateText = value;
          }
          fetchPgsFilter();
        });
      },
    );
  }

  Widget _endDateDropdown() {
    return SearchableDropdown(
      items: [
        "All End Date",
        ...filteredListPeriod.map(
          (p) => _dateConverter.toJson(DateTime.parse(p['endDate'])),
        ),
      ],
      selectedItem: selectedEndDateText ?? "End Date",
      hintText: "End Date",
      searchHint: "Search...",
      onChanged: (value) {
        setState(() {
          if (value == "All End Date") {
            selectedEndDate = null;
            selectedEndDateText = "All End Date";
          } else {
            final selected = filteredListPeriod.firstWhere(
              (p) =>
                  _dateConverter.toJson(DateTime.parse(p['endDate'])) == value,
            );
            selectedEndDate = selected['endDate'];
            selectedEndDateText = value;
          }
          fetchPgsFilter();
        });
      },
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Text("#", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Office",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Period",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Actions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        int itemNumber = ((_currentPage - 1) * _pageSize) + index + 1;
        final pgs = filteredList[index];
        final isDraft = pgs['isDraft'] as bool? ?? false;
        final signatories = List<Map<String, dynamic>>.from(
          pgs['signatories'] ?? [],
        );
        final deliverables = List<Map<String, dynamic>>.from(
          pgs['pgsDeliverables'] ?? [],
        );

        String status = 'Draft';
        if (deliverables.any((d) => d['isDisapproved'] as bool? ?? false)) {
          status = 'Disapproved';
        } else if (isDraft) {
          status = 'Draft';
        } else {
          final hasNextStatus = signatories.any((signatory) {
            final isNextStatus = signatory['isNextStatus'];
            if (isNextStatus == null) return false;
            if (isNextStatus is bool) return isNextStatus;
            if (isNextStatus is String)
              return isNextStatus.toLowerCase() == 'true';
            return false;
          });
          status = hasNextStatus ? 'For Approval' : 'Approved';
        }

        if (!isMobile) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("$itemNumber")),
                Expanded(flex: 3, child: Text(pgs['name'] ?? "")),
                Expanded(
                  flex: 2,
                  child: Text(
                    "${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgs['startDate']))} - "
                    "${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgs['endDate']))}",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        margin: EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(status),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: getStatusIcon(status)),
                      ),
                      Text(
                        status,
                        style: TextStyle(color: getStatusColor(status)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      PermissionWidget(
                        permission:
                            AppPermissions.viewPerformanceGovernanceSystem,
                        child: Tooltip(
                          message: 'Edit',
                          child: IconButton(
                            icon: const Icon(size: 18, Icons.edit_outlined),
                            onPressed: () async {
                              try {
                                await AuthUtil.saveSelectedOfficeId(
                                  pgs['officeid'].toString(),
                                );
                                selectedOffice =
                                    await AuthUtil.fetchSelectedOfficeId();
                                final deliverablesList =
                                    await fetchDeliverables(pgsId: pgs['id']);
                                final signatory = await fetchSignatoryList(
                                  pgsId: pgs['id'],
                                );
                                await fetchSubmitUserId(
                                  userId: userId,
                                  pgsId: pgs['id'],
                                );
                                await _loadOfficeName();
                                _openDialog(
                                  existingPgs: {
                                    ...pgs,
                                    'deliverables': deliverablesList,
                                    'signatories': signatory,
                                  },
                                );
                              } catch (_) {}
                            },
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Print Preview',
                        child: IconButton(
                          icon: const Icon(
                            size: 18,
                            Icons.description_outlined,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () async {
                            await openPGSReportNewTab(
                              pgs['id'].toString(),
                              pgs['name'] ?? "",
                            );
                          },
                        ),
                      ),
                      if (status != 'Approved' && status != 'For Approval')
                        PermissionWidget(
                          permission:
                              AppPermissions.deletePerformanceGovernanceSystem,
                          child: IconButton(
                            icon: const Icon(
                              size: 18,
                              CupertinoIcons.delete_simple,
                              color: Colors.redAccent,
                            ),
                            onPressed:
                                () => _showDeleteDialog(pgs['id'].toString()),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile card
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "$itemNumber",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    color: Theme.of(context).cardColor,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        try {
                          await AuthUtil.saveSelectedOfficeId(
                            pgs['officeid'].toString(),
                          );
                          selectedOffice =
                              await AuthUtil.fetchSelectedOfficeId();
                          final deliverablesList = await fetchDeliverables(
                            pgsId: pgs['id'],
                          );
                          await _loadOfficeName();
                          _openDialog(
                            existingPgs: {
                              ...pgs,
                              'deliverables': deliverablesList,
                            },
                          );
                        } catch (_) {}
                      }
                      if (value == 'preview') {
                        await openPGSReportNewTab(
                          pgs['id'].toString(),
                          pgs['name'] ?? "",
                        );
                      }
                      if (value == 'delete' &&
                          status != 'Approved' &&
                          status != 'For Approval') {
                        _showDeleteDialog(pgs['id'].toString());
                      }
                    },
                    itemBuilder:
                        (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: PermissionWidget(
                              permission:
                                  AppPermissions
                                      .viewPerformanceGovernanceSystem,
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'preview',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 18,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(width: 8),
                                Text('Print preview'),
                              ],
                            ),
                          ),
                          if (status != 'Approved' && status != 'For Approval')
                            PopupMenuItem(
                              value: 'delete',
                              child: PermissionWidget(
                                permission:
                                    AppPermissions
                                        .deletePerformanceGovernanceSystem,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.delete_simple,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: getStatusIcon(status)),
                  ),
                  Text(status, style: TextStyle(color: getStatusColor(status))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("Office: ", style: TextStyle(color: Colors.grey)),
                  Expanded(child: Text(pgs['name'] ?? "")),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("Period: ", style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Text(
                      "${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgs['startDate']))} - "
                      "${LongDateOnlyConverter().toJson(LongDateOnlyConverter().fromJson(pgs['endDate']))}",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Container(
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
            onPageChanged: (page) => fetchPgsList(page: page),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildDropdown({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 250),
      child: SizedBox(height: 38, child: child),
    );
  }

  Future<void> _onAddTap() async {
    selectedOffice = await AuthUtil.fetchSelectedOfficeId();
    if (selectedOffice == null || selectedOffice!.isEmpty) {
      await _selectOffice();
      selectedOffice = await AuthUtil.fetchSelectedOfficeId();
      if (selectedOffice != null && selectedOffice!.isNotEmpty) {
        await _loadOfficeName();
        _openDialog();
      }
    } else {
      await _loadOfficeName();
      _openDialog();
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this PGS? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: primaryTextColor),
                ),
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
          ),
    );
  }
}

// ------------------------------------------------------------------------------
//  FORM DIALOG
// ------------------------------------------------------------------------------
class _PgsFormDialog extends StatefulWidget {
  final String officeName;
  final String officeId;
  final List<PgsPeriod> periods;
  final List<Map<String, dynamic>> filteredListPeriod;
  final CommonService commonService;
  final Map<String, dynamic>? existingPgs;
  final VoidCallback onSaved;
  final Future<bool> Function(PerformanceGovernanceSystem) onDraft;
  final Future<bool> Function(String, PerformanceGovernanceSystem) onSubmit;
  final int? Function() lastResponseStatusCode;

  const _PgsFormDialog({
    required this.officeName,
    required this.officeId,
    required this.periods,
    required this.filteredListPeriod,
    required this.commonService,
    required this.onSaved,
    required this.onDraft,
    required this.onSubmit,
    required this.lastResponseStatusCode,
    this.existingPgs,
  });

  @override
  State<_PgsFormDialog> createState() => _PgsFormDialogState();
}

class _PgsFormDialogState extends State<_PgsFormDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int? _selectedPeriodId;
  Map<String, dynamic>? _selectedPeriodObject;

  double _competence = 0.0, _resource = 0.0, _confidence = 0.0;
  double get _total => _competence + _resource + _confidence;

  final List<_DeliverableRow> _rows = [];
  final Map<int, TextEditingController> _delivCtrl = {};
  final Map<int, TextEditingController> _kraCtrl = {};
  final Map<int, TextEditingController> _kraRoadmapCtrl = {};
  final Map<int, TextEditingController> _delivRoadmapCtrl = {};
  final Map<int, TextEditingController> _reasonCtrl = {};
  final Map<int, int?> _deliverableIds = {};
  final Map<int, Map<String, dynamic>> _selectedKRAObjects = {};
  final Map<int, bool> _selectedDisapproved = {};
  final Map<int, String> _processMap = {};
  final Map<int, int?> _selectedKRA = {};
  final Map<int, GlobalKey> _kraDropdownKeys = {};
  final Map<int, bool> _hasDataMap = {};
  final Map<int, List<dynamic>> _kraDescsByIndex = {};
  final List<UniqueKey> _rowKeys = [];

  List<Map<String, dynamic>> _options = [];
  bool _processLoading = false;
  bool _submitting = false;

  final _permissionService = PermissionService();
  final _roadMapService = RoadmapService(Dio());
  final _dateConverter = const LongDateOnlyConverter();

  bool get _isMobile => MediaQuery.sizeOf(context).width < 640;
  List<PgsPeriod> get _activePeriods =>
      widget.periods.where((p) => !p.isDeleted).toList();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _loadKraOptions();
    _initFromExisting();
    if (_rows.isEmpty) _addRowInternal();
  }

  void _initFromExisting() {
    final pgs = widget.existingPgs;
    if (pgs == null) return;

    // Period
    final startDate = pgs['startDate'];
    final endDate = pgs['endDate'];
    if (startDate != null && endDate != null) {
      final selected = widget.filteredListPeriod.firstWhere(
        (period) =>
            period['startDate'] == startDate && period['endDate'] == endDate,
        orElse: () => {},
      );
      if (selected.isNotEmpty) {
        _selectedPeriodId = selected['id'];
        _selectedPeriodObject = selected;
      }
    }

    // Readiness
    _competence = double.tryParse(pgs['competencescore'] ?? '') ?? 0.0;
    _resource = double.tryParse(pgs['resourcescore'] ?? '') ?? 0.0;
    _confidence = double.tryParse(pgs['confidencescore'] ?? '') ?? 0.0;

    // Deliverables
    final deliverables = pgs['deliverables'];
    if (deliverables is List && deliverables.isNotEmpty) {
      for (int i = 0; i < deliverables.length; i++) {
        final item = deliverables[i];
        if (item is PgsDeliverables) {
          _rows.add(
            _DeliverableRow(
              id: item.id,
              kraId: item.kra?.id,
              isDirect: item.isDirect,
              byWhen: DateFormat('yyyy-MM-dd').format(item.byWhen),
            ),
          );
          _delivCtrl[i] = TextEditingController(text: item.deliverableName);
          _kraCtrl[i] = TextEditingController(text: item.kraDescription);
          _selectedKRA[i] = item.kra?.id;
          _deliverableIds[i] = item.id ?? 0;
          _selectedDisapproved[i] = item.isDisapproved;
          _reasonCtrl[i] = TextEditingController(text: item.disapprovalRemarks);
          _processMap[i] = item.kra?.name ?? '';
          _rowKeys.add(UniqueKey());
        }
      }
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final c in _delivCtrl.values) c.dispose();
    for (final c in _kraCtrl.values) c.dispose();
    for (final c in _kraRoadmapCtrl.values) c.dispose();
    for (final c in _delivRoadmapCtrl.values) c.dispose();
    for (final c in _reasonCtrl.values) c.dispose();
    super.dispose();
  }

  Future<void> _loadKraOptions() async {
    if (_processLoading) return;
    setState(() => _processLoading = true);
    try {
      final List<KeyResultArea> result = await widget.commonService.fetchKra();
      setState(() {
        _options =
            result
                .map((e) => {'id': e.id, 'name': e.name, 'remarks': e.remarks})
                .toList();
        _processLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch KRA Error: $e");
      setState(() => _processLoading = false);
    }
  }

  void _addRowInternal() {
    final idx = _rows.length;
    _rows.add(_DeliverableRow());
    _delivCtrl[idx] = TextEditingController();
    _kraCtrl[idx] = TextEditingController();
    _kraRoadmapCtrl[idx] = TextEditingController();
    _delivRoadmapCtrl[idx] = TextEditingController();
    _reasonCtrl[idx] = TextEditingController();
    _processMap[idx] = '';
    _rowKeys.add(UniqueKey());
  }

  void _addRow() => setState(_addRowInternal);

  void _removeRow(int idx) {
    setState(() {
      _rows.removeAt(idx);
      _rowKeys.removeAt(idx);

      final maps = [
        _delivCtrl,
        _kraCtrl,
        _kraRoadmapCtrl,
        _delivRoadmapCtrl,
        _reasonCtrl,
        _processMap,
        _selectedKRA,
        _kraDropdownKeys,
        _hasDataMap,
        _kraDescsByIndex,
        _deliverableIds,
        _selectedKRAObjects,
        _selectedDisapproved,
      ];
      for (final map in maps) map.remove(idx);

      // Re-key
      for (final map in maps) {
        final keysAbove = map.keys.where((k) => k > idx).toList()..sort();
        for (final k in keysAbove) {
          map[k - 1] = map.remove(k)!;
        }
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final row = _rows.removeAt(oldIndex);
      _rows.insert(newIndex, row);
      final key = _rowKeys.removeAt(oldIndex);
      _rowKeys.insert(newIndex, key);

      final maps = [
        _delivCtrl,
        _kraCtrl,
        _kraRoadmapCtrl,
        _delivRoadmapCtrl,
        _reasonCtrl,
        _processMap,
        _selectedKRA,
        _kraDropdownKeys,
        _hasDataMap,
        _kraDescsByIndex,
        _deliverableIds,
        _selectedKRAObjects,
        _selectedDisapproved,
      ];
      for (final map in maps) {
        final oldMap = Map.from(map);
        map.clear();
        for (int i = 0; i < _rows.length; i++) {
          int orig;
          if (i == newIndex) {
            orig = oldIndex;
          } else if (i < newIndex && i >= oldIndex) {
            orig = i + 1;
          } else if (i > newIndex && i <= oldIndex) {
            orig = i - 1;
          } else {
            orig = i;
          }
          if (oldMap.containsKey(orig)) map[i] = oldMap[orig];
        }
      }
    });
  }

  // ---------------------------------------------------------------------------
  //  SUBMIT ACTION
  // ---------------------------------------------------------------------------
  Future<void> _submitAction(ActionType actionType) async {
    if (_selectedPeriodId == null) {
      MotionToast.warning(
        title: const Text("Missing Fields"),
        description: const Text("Please select a period."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    if (_rows.isEmpty) {
      MotionToast.warning(
        title: const Text("Missing Fields"),
        description: const Text("Please add at least one deliverable."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    for (int i = 0; i < _rows.length; i++) {
      if (_delivCtrl[i]?.text.trim().isEmpty ?? true) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text(
            "Please fill in all deliverable names (Row ${i + 1}).",
          ),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }
      if (_selectedKRA[i] == null) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text("Please select a process (KRA) for Row ${i + 1}."),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }
      if (_rows[i].byWhen.isEmpty) {
        MotionToast.warning(
          title: const Text("Missing Fields"),
          description: Text("Please set a date for Row ${i + 1}."),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }
    }

    final id = widget.existingPgs?['id'];
    if (actionType != ActionType.draft && (id == null)) {
      MotionToast.error(
        description: const Text("PGS ID is missing. Cannot proceed."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    String title, content;
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

    setState(() => _submitting = true);

    final pgsId = int.tryParse(id?.toString() ?? '') ?? 0;
    final deliverables = _buildDeliverables(pgsId);

    final pgs = PerformanceGovernanceSystem(
      id: pgsId,
      pgsStatus:
          actionType == ActionType.draft
              ? "Draft"
              : (actionType == ActionType.disapprove
                  ? "Disapproved"
                  : "Approved"),
      pgsPeriod: PgsPeriod(
        _selectedPeriodId!,
        false,
        rowVersion: "",
        DateTime.now(),
        DateTime.now(),
        '',
      ),
      office: Office(
        id: int.tryParse(widget.officeId) ?? 0,
        name: widget.officeName,
        officeTypeId: 0,
        parentOfficeId: 0,
        isActive: false,
        rowVersion: "",
      ),
      pgsDeliverables: deliverables,
      pgsReadinessRating: PgsReadiness(
        0,
        false,
        null,
        _competence,
        _resource,
        _confidence,
        _total,
      ),
      pgsSignatories: [],
      isDeleted: false,
      isDraft: actionType == ActionType.draft,
      remarks: "",
      rowVersion: "",
      percentDeliverables: 40,
      forSignature: false,
    );

    try {
      bool success = false;
      if (actionType == ActionType.draft) {
        for (final d in pgs.pgsDeliverables ?? []) {
          d.isDisapproved = false;
          d.disapprovalRemarks = '';
        }
        success = await widget.onDraft(pgs);
        if (!success) {
          MotionToast.error(
            description: Text(
              widget.lastResponseStatusCode() == 403
                  ? "You don't have permission to save as draft."
                  : "Failed to save draft!",
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          setState(() => _submitting = false);
          return;
        }
      } else {
        for (final d in pgs.pgsDeliverables ?? []) {
          d.isDisapproved = false;
          d.disapprovalRemarks = '';
        }
        success = await widget.onSubmit(id.toString(), pgs);
        if (!success) {
          MotionToast.error(
            description: Text(
              widget.lastResponseStatusCode() == 403
                  ? "You don't have permission."
                  : "Operation failed!",
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          setState(() => _submitting = false);
          return;
        }
      }

      MotionToast.success(
        description: Text(
          actionType == ActionType.draft
              ? "Saved successfully!"
              : "Submitted successfully!",
        ),
        toastAlignment: Alignment.center,
      ).show(context);
      widget.onSaved();
      Navigator.pop(context);
    } catch (e) {
      MotionToast.error(
        description: const Text("An error occurred."),
        toastAlignment: Alignment.center,
      ).show(context);
      setState(() => _submitting = false);
    }
  }

  List<PgsDeliverables> _buildDeliverables(int pgsId) {
    List<PgsDeliverables> list = [];
    for (int i = 0; i < _rows.length; i++) {
      final row = _rows[i];
      final kraId = _selectedKRA[i];
      final kraData = _options.firstWhere(
        (o) => o['id'] == kraId,
        orElse:
            () => {'id': 1, 'name': 'Unknown', 'remarks': '', 'rowVersion': ''},
      );
      list.add(
        PgsDeliverables(
          _deliverableIds[i] ?? 0,
          KeyResultArea(
            kraData['id'] as int,
            kraData['name'] as String,
            kraData['remarks'] ?? '',
            '',
            true,
            rowVersion: kraData['rowVersion'] ?? '',
          ),
          kraId,
          _delivCtrl[i]?.text ?? '',
          _kraCtrl[i]?.text ?? '',
          row.isDirect,
          DateTime.tryParse(row.byWhen) ?? DateTime.now(),
          40,
          _reasonCtrl[i]?.text ?? '',
          _selectedDisapproved[i] ?? false,
          PgsStatus.notStarted,
          pgsId,
          remarks: '',
          rowVersion: '',
        ),
      );
    }
    return list;
  }

  // ---------------------------------------------------------------------------
  //  BUILD
  // ---------------------------------------------------------------------------
  static const _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = _isMobile;
    final dWidth =
        isMobile
            ? size.width * 0.97
            : size.width < 900
            ? size.width * 0.99
            : size.width < 1200
            ? size.width * 1.00
            : size.width < 1600
            ? size.width * 0.98
            : size.width * 0.95;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 16,
        vertical: isMobile ? 8 : 20,
      ),
      child: Container(
        width: dWidth,
        constraints: BoxConstraints(maxHeight: size.height * 0.92),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(.15),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(isMobile),
            _periodSelector(isMobile),
            _tabBar(isMobile),
            Flexible(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _tab1Strategic(isMobile),
                  _tab2Readiness(isMobile),
                  _tab3Deliverables(isMobile),
                ],
              ),
            ),
            _footer(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _dialogHeader(bool isMobile) => Padding(
    padding: EdgeInsets.fromLTRB(isMobile ? 12 : 24, isMobile ? 14 : 18, 12, 4),
    child: Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 42 : 52,
                height: isMobile ? 42 : 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kPrimaryBg,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/CRMC.png',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Icon(
                          Icons.local_hospital,
                          color: primaryColor,
                          size: isMobile ? 20 : 26,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'COTABATO REGIONAL AND MEDICAL CENTER',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: isMobile ? 11 : 14,
                      color: _kTextDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('selectedOfficeId');
            await prefs.remove('selectedOfficeName');
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _kBg,
              shape: BoxShape.circle,
              border: Border.all(color: _kBorder),
            ),
            child: Icon(
              Icons.close,
              size: isMobile ? 16 : 18,
              color: _kTextMid,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _periodSelector(bool isMobile) {
    String formatPeriodRange(PgsPeriod p) {
      final start = _dateConverter.toJson(p.startDate);
      final end = _dateConverter.toJson(p.endDate);
      return "$start to $end";
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          DropdownButton<int>(
            value: _selectedPeriodId,
            hint: Text(
              _activePeriods.isEmpty
                  ? 'No periods available'
                  : 'Select PGS Period',
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                color: _kTextLight,
              ),
            ),
            underline: const SizedBox(),
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: _kTextDark,
              fontWeight: FontWeight.w500,
            ),
            items:
                _activePeriods.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(formatPeriodRange(p)),
                  );
                }).toList(),
            onChanged: (v) {
              setState(() {
                _selectedPeriodId = v;
                _selectedPeriodObject = widget.filteredListPeriod.firstWhere(
                  (p) => p['id'] == v,
                  orElse: () => {},
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _tabBar(bool isMobile) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: _kBorder, width: 1.5)),
    ),
    child: TabBar(
      controller: _tabs,
      labelColor: primaryColor,
      unselectedLabelColor: _kTextLight,
      indicatorColor: primaryColor,
      indicatorWeight: 2.5,
      labelStyle: TextStyle(
        fontSize: isMobile ? 9 : 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: TextStyle(fontSize: isMobile ? 9 : 12),
      tabs: const [
        Tab(text: 'Strategic Contributions'),
        Tab(text: 'Readiness Rating'),
        Tab(text: 'PGS Deliverables Status'),
      ],
    ),
  );

  Widget _footer(bool isMobile) {
    final isEdit = widget.existingPgs != null;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: const BoxDecoration(
        color: _kBg,
        border: Border(top: BorderSide(color: _kBorder)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_submitting)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ),
            ),
          OutlinedButton(
            onPressed:
                _submitting ? null : () => _submitAction(ActionType.draft),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 22,
                vertical: isMobile ? 8 : 12,
              ),
            ),
            child: Text(
              'Save as Draft',
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed:
                _submitting
                    ? null
                    : () => _submitAction(
                      isEdit ? ActionType.approve : ActionType.submit,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 28,
                vertical: isMobile ? 8 : 12,
              ),
              elevation: 2,
            ),
            child: Text(
              isEdit ? 'Confirm' : 'Submit',
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  TABLE CELLS
  // ---------------------------------------------------------------------------
  Widget _groupCell(String text, int flex, Color bg) => Expanded(
    flex: flex,
    child: Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
    ),
  );

  Widget _subCell(String text, int flex) => Expanded(
    flex: flex,
    child: Container(
      color: _kPrimaryBg,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: _kTextDark,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );

  Widget _dataCell(
    Widget child,
    int flex,
    Color rowColor, {
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
  }) => Expanded(
    flex: flex,
    child: Container(color: rowColor, padding: padding, child: child),
  );

  Widget _tab1GroupRow(String officeName) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _groupCell(
          officeName.toUpperCase(),
          _fHandle + _fNo + _fProcess + _fKra,
          primaryColor,
        ),
        _groupCell('ALIGNMENT', _fDirect + _fIndirect, primaryColor),
        _groupCell('STRATEGIC CONTRIBUTIONS', _fDeliv, primaryColor),
        _groupCell('40%', _fAction + _fByWhen, primaryColor),
      ],
    ),
  );

  Widget _tab3GroupRow(String officeName) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _groupCell(
          officeName.toUpperCase(),
          _fHandle + _fNo + _fProcess + _fKra,
          primaryColor,
        ),
        _groupCell('ALIGNMENT', _fDirect + _fIndirect, _kPrimaryLight),
        _groupCell('PGS DELIVERABLES STATUS', _fDeliv, primaryColor),
        _groupCell('40%', _fByWhen + _fAction, _kAccentDark),
      ],
    ),
  );

  Widget _subHeaderRow({required String actionLabel}) => Container(
    decoration: BoxDecoration(
      border: Border.symmetric(
        horizontal: BorderSide(color: _kBorder, width: 1),
      ),
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _subCell('?', _fHandle),
          _subCell('#', _fNo),
          _subCell('PROCESS (CORE & SUPPORT)', _fProcess),
          _subCell('KRA', _fKra),
          _subCell('DIRECT', _fDirect),
          _subCell('INDIRECT', _fIndirect),
          _subCell('DELIVERABLES', _fDeliv),
          _subCell('BY WHEN', _fByWhen),
          _subCell(actionLabel, _fAction),
        ],
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  //  TAB 1 — STRATEGIC CONTRIBUTIONS
  // ---------------------------------------------------------------------------
  Widget _tab1Strategic(bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _mobileOfficeHeader(),
            const SizedBox(height: 6),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: _onReorder,
              proxyDecorator: _proxyDecorator,
              children: [
                for (int i = 0; i < _rows.length; i++)
                  _mobileRowCard(i, key: _rowKeys[i]),
              ],
            ),
            TextButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add, size: 16, color: primaryColor),
              label: const Text(
                '+ Add Row',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _kBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                _tab1GroupRow(widget.officeName),
                _subHeaderRow(actionLabel: 'ACTION'),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: _kBorder),
                  right: BorderSide(color: _kBorder),
                  bottom: BorderSide(color: _kBorder),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: ReorderableListView.builder(
                itemCount: _rows.length,
                onReorder: _onReorder,
                proxyDecorator: _proxyDecorator,
                itemBuilder: (_, i) => _tab1DataRow(i, key: _rowKeys[i]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add, size: 16, color: primaryColor),
              label: const Text(
                '+ Add Row',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) => AnimatedBuilder(
    animation: animation,
    builder:
        (_, __) => Material(
          color: Colors.transparent,
          elevation: 6,
          shadowColor: primaryColor.withOpacity(.3),
          borderRadius: BorderRadius.circular(8),
          child: Opacity(opacity: .9, child: child),
        ),
  );

  Widget _tab1DataRow(int i, {required Key key}) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    _kraRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    _delivRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    _processMap.putIfAbsent(i, () => '');
    final row = _rows[i];
    final rowColor = i.isEven ? Colors.white : _kBg;

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.8)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dataCell(
              ReorderableDragStartListener(
                index: i,
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: Center(
                    child: Icon(
                      Icons.drag_indicator,
                      size: 18,
                      color: _kTextLight,
                    ),
                  ),
                ),
              ),
              _fHandle,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
              ),
              _fNo,
              rowColor,
            ),
            // ✅ REVISED: buildProcess-style dropdown with roadmap dialog
            _dataCell(_buildProcessCell(i), _fProcess, rowColor),
            // ✅ KRA TextField with roadmap sample below
            _dataCell(_buildKraCell(i), _fKra, rowColor),
            _dataCell(
              Center(
                child: Checkbox(
                  value: row.isDirect,
                  activeColor: primaryColor,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (_) => setState(() => row.isDirect = true),
                ),
              ),
              _fDirect,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Checkbox(
                  value: !row.isDirect,
                  activeColor: primaryColor,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (_) => setState(() => row.isDirect = false),
                ),
              ),
              _fIndirect,
              rowColor,
            ),
            // ✅ Deliverables with sample below
            _dataCell(_buildDeliverablesCell(i), _fDeliv, rowColor),
            _dataCell(Center(child: _byWhenBtn(i)), _fByWhen, rowColor),
            _dataCell(
              Center(
                child: Tooltip(
                  message: 'Remove row',
                  child: InkWell(
                    onTap: () => _removeRow(i),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
              _fAction,
              rowColor,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  ✅ REVISED: _buildProcessCell — like buildProcess in file 2
  //    Shows a dropdown that, on selection, opens the KRA roadmap dialog
  // ---------------------------------------------------------------------------
  Widget _buildProcessCell(int i) {
    final current = _processMap[i] ?? '';
    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );
    final kraData = _selectedKRAObjects[i];
    final tooltipMsg = kraData?['remarks'] ?? 'No description available';

    return Padding(
      padding: const EdgeInsets.all(4),
      child: CustomTooltip(
        key: ValueKey('proc_tooltip_$i'),
        maxLines: 5,
        message: tooltipMsg,
        child: Container(
          key: _kraDropdownKeys.putIfAbsent(i, () => GlobalKey()),
          child: DropdownButtonFormField<int?>(
            dropdownColor: Colors.white,
            isExpanded: true,
            value: _selectedKRA[i],
            hint:
                _processLoading
                    ? Row(
                      children: const [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 6),
                        Text('Loading…', style: TextStyle(fontSize: 11)),
                      ],
                    )
                    : const Text(
                      '-- Select Process --',
                      style: TextStyle(fontSize: 11),
                    ),
            onChanged:
                !hasEditPermission
                    ? null
                    : (int? newValue) async {
                      if (newValue == null) return;

                      setState(() {
                        _selectedKRA[i] = newValue;
                        _selectedKRAObjects[i] = _options.firstWhere(
                          (o) => o['id'] == newValue,
                          orElse:
                              () => {'id': newValue, 'name': '', 'remarks': ''},
                        );
                        _processMap[i] = _selectedKRAObjects[i]!['name'] ?? '';
                      });

                      // Load roadmap descriptions for this KRA
                      final data = await _roadMapService.getAllKraDescriptions(
                        kraId: newValue,
                      );

                      setState(() {
                        _hasDataMap[i] = data.isNotEmpty;
                        _kraDescsByIndex[i] = data;
                      });

                      if (data.isEmpty) return;

                      // Show roadmap dialog (same as buildProcess in file 2)
                      try {
                        final selected = await showGeneralDialog<String>(
                          context: context,
                          barrierDismissible: false,
                          barrierLabel: 'KRA Roadmap',
                          barrierColor: Colors.black.withOpacity(0.4),
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (_, __, ___) {
                            return Center(
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 500,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                'Select a KRA from the roadmap to anchor your entry',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                size: 20,
                                              ),
                                              splashRadius: 18,
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1),
                                      Expanded(
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          children:
                                              data.asMap().entries.map((entry) {
                                                final idx = entry.key;
                                                final d = entry.value;
                                                final desc =
                                                    d['kraDescription'] ?? '';
                                                return ListTile(
                                                  title: Text(
                                                    "${idx + 1}. $desc",
                                                  ),
                                                  onTap:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(desc),
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

                        setState(() {
                          _kraRoadmapCtrl
                              .putIfAbsent(i, () => TextEditingController())
                              .text = selected;
                        });

                        // Filter roadmap to get sample deliverable
                        int filterYear = DateTime.now().year;
                        if (_selectedPeriodObject != null &&
                            _selectedPeriodObject!['startDate'] != null) {
                          final parsed = DateTime.tryParse(
                            _selectedPeriodObject!['startDate'],
                          );
                          if (parsed != null) filterYear = parsed.year;
                        }

                        final filter = KraRoadmapFilter(
                          kraId: newValue,
                          year: filterYear,
                          kraDescription: selected,
                          isDirect: _rows[i].isDirect,
                        );

                        try {
                          final result = await _roadMapService.kraRoadmapFilter(
                            filter,
                          );
                          setState(() {
                            _delivRoadmapCtrl
                                .putIfAbsent(i, () => TextEditingController())
                                .clear();
                            _kraRoadmapCtrl[i]!.clear();
                            if (result.isNotEmpty) {
                              if (result.first['deliverableDescription']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true) {
                                _delivRoadmapCtrl[i]!.text =
                                    result.first['deliverableDescription'];
                              }
                              if (result.first['kraDescription']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true) {
                                _kraRoadmapCtrl[i]!.text =
                                    result.first['kraDescription'];
                              }
                            }
                          });
                        } catch (_) {}
                      } catch (_) {}
                    },
            items:
                _options.map<DropdownMenuItem<int?>>((option) {
                  return DropdownMenuItem<int?>(
                    value: option['id'],
                    child: Text(
                      option['name'],
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                }).toList(),
            validator:
                (value) => value == null ? "Please select process" : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  ✅ KRA text field with roadmap sample below (like _buildDropdownKraCell)
  // ---------------------------------------------------------------------------
  Widget _buildKraCell(int i) {
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    _kraRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTooltip(
            message:
                'Enter a short description of what this KRA focuses on achieving.',
            child: TextFormField(
              readOnly: !hasEditPermission,
              controller: _kraCtrl[i],
              maxLines: null,
              style: const TextStyle(fontSize: 11, color: _kTextDark),
              decoration: const InputDecoration(
                hintText: 'Enter KRA…',
                hintStyle: TextStyle(color: _kTextLight, fontSize: 11),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? "Please enter your KRA"
                          : null,
            ),
          ),
          // Sample KRA from roadmap (shown when direct alignment selected)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _kraRoadmapCtrl.putIfAbsent(
              i,
              () => TextEditingController(),
            ),
            builder: (context, val, _) {
              if (val.text.isEmpty || !(_rows[i].isDirect))
                return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _kBorder),
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sample KRA from Roadmap\n',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      TextSpan(
                        text: '(Copy this if your alignment is direct)\n\n',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      TextSpan(
                        text: val.text,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  ✅ Deliverables TextField with sample from roadmap below
  // ---------------------------------------------------------------------------
  Widget _buildDeliverablesCell(int i) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _delivRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTooltip(
            message:
                'Specify the tangible results or outcomes tied to this responsibility.',
            child: TextFormField(
              readOnly: !hasEditPermission,
              controller: _delivCtrl[i],
              maxLines: null,
              style: const TextStyle(fontSize: 11, color: _kTextDark),
              decoration: const InputDecoration(
                hintText: 'Enter deliverable…',
                hintStyle: TextStyle(color: _kTextLight, fontSize: 11),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? "Please enter your deliverable"
                          : null,
            ),
          ),
          // ✅ Sample deliverable from roadmap shown below
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _delivRoadmapCtrl.putIfAbsent(
              i,
              () => TextEditingController(),
            ),
            builder: (context, val, _) {
              if (val.text.isEmpty || (_delivCtrl[i]?.text.isNotEmpty == true))
                return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _kBorder),
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sample deliverable from Roadmap\n',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      TextSpan(
                        text: val.text,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  TAB 2 — READINESS RATING
  // ---------------------------------------------------------------------------
  Widget _tab2Readiness(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 20,
              vertical: isMobile ? 10 : 14,
            ),
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'READINESS RATING – ${widget.officeName.toUpperCase()}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 11 : 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'SCORE',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 10 : 12,
                color: _kTextDark,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 6),
          _readinessRow(
            'COMPETENCE TO DELIVER',
            [
              'Teams lack adequate skills and training to deliver performance commitments',
              'Teams are skilled but lack training to deliver performance commitments',
              'Teams are highly skilled and trained to deliver performance commitments',
            ],
            _competence,
            (v) => setState(() => _competence = v),
            isMobile,
          ),
          const SizedBox(height: 10),
          _readinessRow(
            'RESOURCE AVAILABILITY',
            [
              'Insufficient; external resources difficult to source',
              'Sufficient resources but not available; OR Insufficient but can be tapped',
              'Sufficient and available staff and budget',
            ],
            _resource,
            (v) => setState(() => _resource = v),
            isMobile,
          ),
          const SizedBox(height: 10),
          _readinessRow(
            'CONFIDENCE TO DELIVER',
            [
              'Low confidence because of high degree of organizational change required',
              'Moderate confidence',
              'High confidence despite organizational change required',
            ],
            _confidence,
            (v) => setState(() => _confidence = v),
            isMobile,
          ),
          const SizedBox(height: 14),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 20,
              vertical: isMobile ? 10 : 14,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kPrimaryBg, Colors.white],
              ),
              border: Border.all(color: _kBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL SCORE',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 11 : 13,
                    color: _kTextDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _total.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 14 : 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _readinessRow(
    String title,
    List<String> descs,
    double current,
    ValueChanged<double> onChange,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 10 : 12,
            color: _kTextDark,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        isMobile
            ? Column(
              children: [
                ...List.generate(descs.length, (i) {
                  final val = i * 0.5;
                  final sel = val == current;
                  return GestureDetector(
                    onTap: () => onChange(val),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: sel ? primaryColor : _kPrimaryBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: sel ? _kAccentDark : _kPrimaryLight,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            val.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: sel ? Colors.white : primaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              descs[i],
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    sel
                                        ? Colors.white.withOpacity(.9)
                                        : _kTextMid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _kBg,
                    border: Border.all(color: _kBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Score: $current',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            )
            : Row(
              children: [
                ...List.generate(descs.length, (i) {
                  final val = i * 0.5;
                  final sel = val == current;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChange(val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: sel ? primaryColor : _kPrimaryBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: sel ? _kAccentDark : _kPrimaryLight,
                            width: sel ? 2 : 1,
                          ),
                          boxShadow:
                              sel
                                  ? [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(.25),
                                      blurRadius: 8,
                                    ),
                                  ]
                                  : [],
                        ),
                        child: Column(
                          children: [
                            Text(
                              val.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: sel ? Colors.white : primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              descs[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    sel
                                        ? Colors.white.withOpacity(.9)
                                        : _kTextMid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _kBg,
                    border: Border.all(color: _kBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    current.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  TAB 3 — PGS DELIVERABLES STATUS (read-only view of Tab 1 data)
  // ---------------------------------------------------------------------------
  Widget _tab3Deliverables(bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _mobileOfficeHeader(),
            const SizedBox(height: 6),
            ...List.generate(_rows.length, (i) => _mobileDeliverableCard(i)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _kBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                _tab3GroupRow(widget.officeName),
                _subHeaderRow(actionLabel: 'ACTION'),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: _kBorder),
                  right: BorderSide(color: _kBorder),
                  bottom: BorderSide(color: _kBorder),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: ListView.builder(
                itemCount: _rows.length,
                itemBuilder: (_, i) => _tab3DataRow(i, key: _rowKeys[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tab3DataRow(int i, {required Key key}) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    final row = _rows[i];
    final rowColor = i.isEven ? Colors.white : _kBg;

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.8)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dataCell(
              Center(
                child: Icon(Icons.drag_indicator, size: 18, color: _kBorder),
              ),
              _fHandle,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    color: primaryColor,
                  ),
                ),
              ),
              _fNo,
              rowColor,
            ),
            _dataCell(
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  _processMap[i] ?? '',
                  style: const TextStyle(fontSize: 11, color: _kTextDark),
                ),
              ),
              _fProcess,
              rowColor,
            ),
            _dataCell(
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  _kraCtrl[i]?.text.isEmpty == true
                      ? '—'
                      : (_kraCtrl[i]?.text ?? '—'),
                  style: const TextStyle(fontSize: 11, color: _kTextDark),
                ),
              ),
              _fKra,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Icon(
                  row.isDirect
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 16,
                  color: row.isDirect ? primaryColor : _kTextLight,
                ),
              ),
              _fDirect,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Icon(
                  !row.isDirect
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 16,
                  color: !row.isDirect ? primaryColor : _kTextLight,
                ),
              ),
              _fIndirect,
              rowColor,
            ),
            _dataCell(
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  _delivCtrl[i]?.text.isEmpty == true
                      ? '—'
                      : (_delivCtrl[i]?.text ?? '—'),
                  style: const TextStyle(fontSize: 11, color: _kTextDark),
                ),
              ),
              _fDeliv,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Text(
                  row.byWhen.isEmpty ? '—' : row.byWhen,
                  style: const TextStyle(fontSize: 10, color: _kTextMid),
                  textAlign: TextAlign.center,
                ),
              ),
              _fByWhen,
              rowColor,
            ),
            _dataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _outlineBtn(Icons.bar_chart, 'Accomplishment'),
                  const SizedBox(height: 3),
                  _outlineBtn(Icons.grade_outlined, 'Breakthrough Scoring'),
                ],
              ),
              _fAction,
              rowColor,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  MOBILE HELPERS
  // ---------------------------------------------------------------------------
  Widget _mobileOfficeHeader() => Container(
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            widget.officeName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.22),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '40%',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _mobileRowCard(int i, {required Key key}) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    _kraRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    _delivRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    _processMap.putIfAbsent(i, () => '');
    final row = _rows[i];

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: _kBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: i,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.drag_indicator,
                        size: 20,
                        color: _kTextLight,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: _kPrimaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Entry',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: _kTextDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: primaryColor,
                    size: 18,
                  ),
                  onPressed: () => _removeRow(i),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _lbl('Process'),
            const SizedBox(height: 4),
            _buildProcessCell(i),
            const SizedBox(height: 8),
            _lbl('KRA'),
            const SizedBox(height: 4),
            _buildKraCell(i),
            const SizedBox(height: 8),
            _lbl('Deliverables'),
            const SizedBox(height: 4),
            _buildDeliverablesCell(i),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _lbl('Alignment'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Checkbox(
                            value: row.isDirect,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged:
                                (_) => setState(() => row.isDirect = true),
                          ),
                          const Text('Direct', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: !row.isDirect,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged:
                                (_) => setState(() => row.isDirect = false),
                          ),
                          const Text(
                            'Indirect',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _lbl('By When'),
                      const SizedBox(height: 4),
                      _byWhenBtn(i),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileDeliverableCard(int i) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    final row = _rows[i];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: _kBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: _kPrimaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _processMap[i] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: _kTextDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: row.isDirect ? _kPrimaryBg : const Color(0xFFDEEBFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    row.isDirect ? 'Direct' : 'Indirect',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: row.isDirect ? primaryColor : Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _lbl('KRA'),
            Text(
              _kraCtrl[i]?.text.isEmpty == true
                  ? '(No KRA entered)'
                  : (_kraCtrl[i]?.text ?? ''),
              style: const TextStyle(
                fontSize: 11,
                color: _kTextMid,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 6),
            _lbl('Deliverables'),
            Text(
              _delivCtrl[i]?.text.isEmpty == true
                  ? '(No deliverable entered)'
                  : (_delivCtrl[i]?.text ?? ''),
              style: const TextStyle(
                fontSize: 11,
                color: _kTextMid,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _outlineBtn(Icons.bar_chart, 'Accomplishment')),
                const SizedBox(width: 6),
                Expanded(
                  child: _outlineBtn(
                    Icons.grade_outlined,
                    'Breakthrough Scoring',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: _kTextMid,
      letterSpacing: 0.4,
    ),
  );

  Widget _byWhenBtn(int i) {
    final hasDate = _rows[i].byWhen.isNotEmpty;
    return Tooltip(
      message: 'Select date',
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            builder:
                (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(primary: primaryColor),
                  ),
                  child: child!,
                ),
          );
          if (picked != null) {
            setState(
              () => _rows[i].byWhen = DateFormat('yyyy-MM-dd').format(picked),
            );
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month, size: 14, color: primaryColor),
              Text(
                hasDate
                    ? '${_monthsShort[DateTime.parse(_rows[i].byWhen).month - 1]} '
                        '${DateTime.parse(_rows[i].byWhen).year}'
                    : 'Pick',
                style: TextStyle(
                  fontSize: 9,
                  color: hasDate ? primaryColor : _kTextLight,
                  fontWeight: hasDate ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlineBtn(IconData icon, String label) => OutlinedButton.icon(
    onPressed: () {},
    icon: Icon(icon, size: 11, color: primaryColor),
    label: Text(
      label,
      style: const TextStyle(
        fontSize: 9,
        color: primaryColor,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
