// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:typed_data';
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
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/accomplishment_widget.dart/breakthrough_widget.dart';
import 'package:imis/widgets/button_widget/filter_button_widget.dart';
import 'package:imis/widgets/filter_widget/button_filter.dart';
import 'package:imis/widgets/no_permission_to_view_widget.dart';
import 'package:imis/widgets/operations_review_protocol_widget/monthly_review_dialog_widget.dart';
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
import '../../widgets/accomplishment_widget.dart/accomplishment_pgs_standardUser_widget.dart';
import '../../widgets/custom_tooltip.dart';

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

class PerformanceGovernanceSystemPage extends StatefulWidget {
  const PerformanceGovernanceSystemPage({super.key});

  @override
  State<PerformanceGovernanceSystemPage> createState() =>
      _PerformanceGovernanceSystemPageState();
}

class _PerformanceGovernanceSystemPageState
    extends State<PerformanceGovernanceSystemPage> {
  List<PerformanceGovernanceSystem> pgsList = [];

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
  Map<int, bool?> selectedDisapproved = {};
  List<PgsPeriod> pgsPeriodList = [];
  String? _selectedOfficeId;
  String? _selectedServiceId;
  bool _isLoading = false;
  final int _pageSize = 15;
  final dio = Dio();
  final _dateConverter = const LongDateOnlyConverter();
  String? selectedEndDateText;
  int? _lastResponseStatusCode;
  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  List<Office> officeList = [];
  List<Office> serviceList = [];

  List<PerformanceGovernanceSystem> deliverableLists = [];
  List<PerformanceGovernanceSystem> filteredList = [];
  Map<String, int> _statusCounts = {
    'All': 0,
    'Draft': 0,
    'For Approval': 0,
    'Approved': 0,
    'Disapproved': 0,
  };

  int _totalCount = 0;
  String _statusFilter = 'All';
  Future<String> _getRoleId() async {
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
      return currentRole.id;
    }
    return '';
  }

  String? _getOfficeOrServiceId() {
    if (_selectedServiceId != null && _selectedServiceId!.isNotEmpty) {
      return _selectedServiceId;
    } else if (_selectedOfficeId != null && _selectedOfficeId!.isNotEmpty) {
      return _selectedOfficeId;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    fetchPgsFilter();
  }

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

      final pageList = await _pgsService.getPgsList(
        userId: userId,
        roleId: roleId,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          deliverableLists = pageList.items;
          filteredList = List.from(deliverableLists);
        });
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> fetchPgsFilter({int? page, int pageSize = 15}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return;
      setState(() => userId = user.id ?? "");

      final roleIdParam = await _getRoleId();
      final officeOrServiceId = _getOfficeOrServiceId();

      final result = await _pgsService.fetchFilteredPgsWithCounts(
        roleId: roleIdParam,
        page: targetPage,
        pageSize: pageSize,
        fromDate:
            selectedStartPeriod != null
                ? DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.parse(selectedStartPeriod!))
                : null,
        toDate:
            selectedEndDate != null
                ? DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.parse(selectedEndDate!))
                : null,
        officeId: officeOrServiceId,
        statusFilter: _statusFilter,
      );

      if (mounted) {
        setState(() {
          deliverableLists = result['items'];
          filteredList = result['items'];
          _currentPage = result['page'];
          _totalCount = result['totalCount'];
          _statusCounts = result['statusCounts'];
        });
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> pgsSaveAsDraft(PerformanceGovernanceSystem pgs) async {
    final statusCode = await _pgsService.saveAsDraft(pgs);
    _lastResponseStatusCode = statusCode;
    if (statusCode == 200 || statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selectedOfficeId');
      await prefs.remove('selectedOfficeName');
      if (mounted) fetchPgsFilter();
      return true;
    }
    return false;
  }

  Future<bool> submitPGS({
    String? pgsId,
    required String userId,
    required PerformanceGovernanceSystem updatePgs,
  }) async {
    final statusCode = await _pgsService.submitPgs(
      pgsId: pgsId ?? '',
      pgs: updatePgs,
    );
    _lastResponseStatusCode = statusCode;

    if (statusCode == 200 || statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selectedOfficeId');
      await prefs.remove('selectedOfficeName');
      if (mounted) fetchPgsFilter();
      return true;
    }
    return false;
  }

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
          index,
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

  void _showSignatoryTimeline(
    BuildContext context,
    PerformanceGovernanceSystem pgs,
  ) {
    final signatories = pgs.pgsSignatories ?? [];
    final deliverables = pgs.pgsDeliverables ?? [];

    String status = 'Draft';
    if (deliverables.any((d) => d.isDisapproved == true)) {
      status = 'Disapproved';
    } else if (pgs.isDraft == true) {
      status = 'Draft';
    } else {
      final hasNext = signatories.any((s) => s.isNextStatus == true);
      status = hasNext ? 'Pending' : 'Approved';
    }
    final bool isDraft = pgs.isDraft == true || status == 'Draft';
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380, maxHeight: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.route_outlined,
                          color: getStatusColor(status),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Approval Timeline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pgs.office.name,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  if (isDraft)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No timeline available yet',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'This document is still in Draft stage.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (signatories.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.pending_outlined,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              status == 'Draft'
                                  ? 'Not yet submitted'
                                  : 'No signatories found',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: signatories.length,
                        itemBuilder: (_, index) {
                          final s = signatories[index];
                          final isNext = s.isNextStatus == true;
                          final signatoryJson = s.toJson();
                          final int nextIndex = signatories.indexWhere(
                            (sig) => sig.isNextStatus == true,
                          );
                          final bool isDone =
                              nextIndex == -1
                                  ? true // all approved
                                  : index < nextIndex;
                          final bool isPending = isNext;

                          final Color dotColor =
                              isDone
                                  ? Colors.green
                                  : isPending
                                  ? Colors.orange.shade600
                                  : Colors.grey.shade300;

                          final Color lineColor =
                              isDone ? Colors.green : Colors.grey.shade200;

                          final String label =
                              signatoryJson['label']?.toString() ??
                              signatoryJson['designation']?.toString() ??
                              signatoryJson['role']?.toString() ??
                              'Signatory';

                          final String name =
                              signatoryJson['signatoryName']?.toString() ??
                              signatoryJson['name']?.toString() ??
                              signatoryJson['fullName']?.toString() ??
                              'Unknown';

                          final bool isLast = index == signatories.length - 1;
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: Column(
                                    children: [
                                      // Dot
                                      Container(
                                        width: 14,
                                        height: 14,
                                        margin: const EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: dotColor,
                                          shape: BoxShape.circle,
                                          border:
                                              isPending
                                                  ? Border.all(
                                                    color:
                                                        Colors.orange.shade600,
                                                    width: 2,
                                                  )
                                                  : null,
                                        ),
                                        child:
                                            isDone
                                                ? const Icon(
                                                  Icons.check,
                                                  size: 9,
                                                  color: Colors.white,
                                                )
                                                : isPending
                                                ? Container(
                                                  margin: const EdgeInsets.all(
                                                    3,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                )
                                                : null,
                                      ),
                                      // Connecting line
                                      if (!isLast)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            color: lineColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Content
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isLast ? 0 : 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isDone
                                                    ? Colors.green.shade700
                                                    : isPending
                                                    ? Colors.orange.shade600
                                                    : Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        // Name
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1A1D23),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        // Status badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isDone
                                                    ? Colors.green.withValues(
                                                      alpha: 0.1,
                                                    )
                                                    : isPending
                                                    ? Colors.orangeAccent
                                                        .withValues(alpha: 0.1)
                                                    : Colors.grey.withValues(
                                                      alpha: 0.1,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            isDone
                                                ? 'Done'
                                                : isPending
                                                ? 'Pending'
                                                : 'Waiting',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isDone
                                                      ? Colors.green.shade700
                                                      : isPending
                                                      ? Colors.orange.shade600
                                                      : Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                          hoverColor: primaryColor.withValues(alpha: 0.1),
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
      final services = await _commonService.fetchService();
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
          serviceList = services;
        });
      }
    } catch (e) {
      debugPrint("Error loading data");
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
            onSaved: () => fetchPgsFilter(),
            onDraft: (pgs) => pgsSaveAsDraft(pgs),
            onSubmit:
                (pgsId, pgs) =>
                    submitPGS(pgsId: pgsId, updatePgs: pgs, userId: userId),
            lastResponseStatusCode: () => _lastResponseStatusCode,
            userId: userId,
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(isMobile),
          _buildFilterBar(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
          ),
        ],
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

  Widget _buildPageHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PGS Deliverables Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "$_totalCount PGS deliverable${_totalCount != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                PermissionWidget(
                  permission: AppPermissions.addPerformanceGovernanceSystem,
                  child: ElevatedButton.icon(
                    onPressed: () => _onAddTap(),
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
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedServiceId = null;
      selectedEndDate = null;
      selectedStartPeriod = null;
      _selectedOfficeId = null;
      selectedStartDateText = "All Start Date";
      selectedEndDateText = "All End Date";
      _statusCounts = {
        'All': 0,
        'Draft': 0,
        'For Approval': 0,
        'Approved': 0,
        'Disapproved': 0,
      };
    });
    fetchPgsFilter();
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Filter by",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: grey,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        gap8px,
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _servicesDropdown(),
          ),
        ),
        SizedBox(
          height: 38,
          child: PermissionWidget(
            permission: AppPermissions.viewOffice,
            child: _officeDropdown(),
          ),
        ),
        gap8px,
        SizedBox(height: 38, child: _startDateDropdown()),
        gap8px,

        SizedBox(height: 38, child: _endDateDropdown()),
      ],
    );
  }

  bool get _hasActiveFilters =>
      _selectedServiceId != null ||
      _selectedOfficeId != null ||
      selectedStartPeriod != null ||
      selectedEndDate != null;

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 15, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              "Filter by",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            buildDropdown(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _servicesDropdown(),
              ),
            ),
            buildDropdown(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _officeDropdown(),
              ),
            ),
            buildDropdown(child: _startDateDropdown()),
            buildDropdown(child: _endDateDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _officeDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
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
          prefixIcon: Icons.apartment_outlined,
          onChanged: (value) {
            setState(() {
              _selectedOfficeId =
                  value == "All Offices"
                      ? null
                      : officeList
                          .firstWhere((o) => o.name == value)
                          .id
                          .toString();
              _selectedServiceId = null;
              fetchPgsFilter();
            });
          },
        ),
      ),
    );
  }

  Widget _servicesDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Services", ...serviceList.map((o) => o.name)],
          selectedItem:
              _selectedServiceId == null
                  ? "All Services"
                  : (serviceList
                          .where((o) => o.id.toString() == _selectedServiceId)
                          .firstOrNull
                          ?.name ??
                      "All Services"),
          hintText: "Service",
          searchHint: "Search services...",
          prefixIcon: Icons.miscellaneous_services,
          onChanged: (value) {
            setState(() {
              _selectedServiceId =
                  value == "All Services"
                      ? null
                      : serviceList
                          .firstWhere((o) => o.name == value)
                          .id
                          .toString();
              _selectedOfficeId = null;
              fetchPgsFilter();
            });
          },
        ),
      ),
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
      selectedItem: selectedStartDateText,
      prefixIcon: Icons.calendar_today_outlined,
      hintText: "All Start Date",
      searchHint: "Search start date...",
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
      selectedItem: selectedEndDateText,
      hintText: "All End Date",
      searchHint: "Search end date...",
      prefixIcon: Icons.calendar_today_outlined,
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
    return Column(
      children: [
        _buildStatusTabs(),
        Container(
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
        ),
      ],
    );
  }

  Widget _buildStatusTabs() {
    final tabs = [
      ('All', _statusCounts['All'] ?? _totalCount, null),
      ('Draft', _statusCounts['Draft'] ?? 0, Colors.grey.shade600),
      (
        'For Approval',
        _statusCounts['For Approval'] ?? 0,
        Colors.orange.shade600,
      ),
      ('Approved', _statusCounts['Approved'] ?? 0, Colors.green.shade600),
      ('Disapproved', _statusCounts['Disapproved'] ?? 0, Colors.red.shade400),
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children:
            tabs.map((tab) {
              final label = tab.$1;
              final count = tab.$2;
              final color = tab.$3;
              final isSelected = _statusFilter == label;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _statusFilter = label;
                    _currentPage = 1;
                    deliverableLists = [];
                    filteredList = [];
                    _totalCount = 0;
                  });
                  fetchPgsFilter(page: 1);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? primaryColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color:
                              isSelected ? primaryColor : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? primaryColor.withValues(alpha: 0.12)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected
                                    ? primaryColor
                                    : (color ?? Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildListView(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    final displayList = filteredList;
    if (displayList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No deliverables found',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        int itemNumber = ((_currentPage - 1) * _pageSize) + index + 1;
        final pgs = displayList[index];

        final isDraft = pgs.isDraft ?? false;
        final signatories = pgs.pgsSignatories ?? [];
        final deliverables = pgs.pgsDeliverables ?? [];
        final officeName = pgs.office.name;
        final startDate = pgs.pgsPeriod.startDate;
        final endDate = pgs.pgsPeriod.endDate;
        String status = 'Draft';

        if (deliverables.any((d) => d.isDisapproved == true)) {
          status = 'Disapproved';
        } else if (isDraft) {
          status = 'Draft';
        } else {
          final hasNextStatus = signatories.any((signatory) {
            final isNextStatus = signatory.isNextStatus;
            if (isNextStatus == null) return false;
            return isNextStatus;
          });

          status = hasNextStatus ? 'Pending' : 'Approved';
        }

        final converter = LongDateOnlyConverter();
        final start = converter.toJson(startDate);
        final end = converter.toJson(endDate);
        if (!isMobile) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text("$itemNumber")),
                Expanded(flex: 3, child: Text(officeName)),
                Expanded(flex: 2, child: Text("$start - $end")),

                Expanded(
                  flex: 2,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _showSignatoryTimeline(context, pgs),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: getStatusIcon(status)),
                          ),
                          Tooltip(
                            message: "Track Deliverables",
                            child: Text(
                              status,
                              style: TextStyle(
                                color: getStatusColor(status),
                                decorationColor: getStatusColor(status),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.info_outline,
                            size: 13,
                            color: getStatusColor(status),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Wrap(
                    children: [
                      PermissionWidget(
                        permission:
                            AppPermissions.viewPerformanceGovernanceSystem,
                        child: Tooltip(
                          message: 'Edit',
                          child: IconButton(
                            icon: const Icon(size: 18, Icons.edit_outlined),
                            onPressed: () => _onEditTap(pgs),
                          ),
                        ),
                      ),
                      PermissionWidget(
                        permission: AppPermissions.viewOperationReviewProtocol,
                        child: Tooltip(
                          message: 'Operations Review Protocol',
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder:
                                    (_) => MonthlyReviewListDialog(
                                      pgsId: pgs.id.toString(),
                                      startDate: pgs.pgsPeriod.startDate,
                                      endDate: pgs.pgsPeriod.endDate,
                                      data: pgs,
                                      onFetch:
                                          (id, month, year) =>
                                              _pgsService.fetchIdDeliverable(
                                                pgsId: id,
                                                month: month,
                                                year: year,
                                              ),
                                      onFetchDeliverables:
                                          (pgsId) =>
                                              _pgsService.fetchDeliverablesOnly(
                                                pgsId: pgsId,
                                              ),
                                      onFetchAll:
                                          (pgsId) => _pgsService
                                              .fetchAllOperationReviewProtocols(
                                                pgsId: pgsId,
                                              ),
                                      onFetchById:
                                          (id) => _pgsService
                                              .fetchOperationReviewProtocolById(
                                                id: id,
                                              ),
                                      onSave:
                                          (
                                            request, {
                                            Uint8List? minutesBytes,
                                            String? minutesFileName,
                                          }) => _pgsService
                                              .saveOperationReviewProtocol(
                                                request: request,
                                                minutesBytes: minutesBytes,
                                                minutesFileName:
                                                    minutesFileName,
                                              ),
                                    ),
                              );
                            },
                            icon: const Icon(
                              Icons.reviews_outlined,
                              size: 18,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Print Preview',
                        child: PopupMenuButton<String>(
                          color: Colors.white,
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 18,
                            color: Colors.blueAccent,
                          ),
                          onSelected: (value) async {
                            if (value == 'DeliverablesOnly') {
                              await openDeliverablesOnlyPreview(
                                pgs.id.toString(),
                                officeName,
                                context: context,
                              );
                            }
                            if (value == 'ReadinessRating') {
                              await openReadinessRatingPreview(
                                pgs.id.toString(),
                                officeName,
                                context: context,
                              );
                            }
                            if (value == 'PGSDeliverablesStatus') {
                              await openPGSDeliverablesStatusPreview(
                                pgs.id.toString(),
                                officeName,
                                context: context,
                              );
                            }
                            if (value == 'AllCombinedView') {
                              await openAllCombinedPGSPreview(
                                pgs.id.toString(),
                                officeName,
                                context: context,
                              );
                            }
                          },
                          itemBuilder:
                              (_) => [
                                PopupMenuItem(
                                  value: 'DeliverablesOnly',
                                  child: Text('Deliverables Only'),
                                ),
                                const PopupMenuItem(
                                  value: 'ReadinessRating',
                                  child: Text('Readiness Rating'),
                                ),
                                const PopupMenuItem(
                                  value: 'PGSDeliverablesStatus',
                                  child: Text('PGS Deliverables Status'),
                                ),
                                const PopupMenuItem(
                                  value: 'AllCombinedView',
                                  child: Text('All Combined View'),
                                ),
                              ],
                        ),
                      ),
                      if (status != 'Approved' && status != 'Pending')
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
                                () => _showDeleteDialog(pgs.id.toString()),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
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
                      if (value == 'edit') _onEditTap(pgs);
                      if (value == 'operationReviewProtocol') {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder:
                              (_) => MonthlyReviewListDialog(
                                pgsId: pgs.id.toString(),
                                startDate: pgs.pgsPeriod.startDate,
                                endDate: pgs.pgsPeriod.endDate,
                                data: pgs,
                                onFetch:
                                    (id, month, year) =>
                                        _pgsService.fetchIdDeliverable(
                                          pgsId: id,
                                          month: month,
                                          year: year,
                                        ),
                                onFetchDeliverables:
                                    (pgsId) => _pgsService
                                        .fetchDeliverablesOnly(pgsId: pgsId),
                                onFetchAll:
                                    (pgsId) => _pgsService
                                        .fetchAllOperationReviewProtocols(
                                          pgsId: pgsId,
                                        ),
                                onFetchById:
                                    (id) => _pgsService
                                        .fetchOperationReviewProtocolById(
                                          id: id,
                                        ),
                                onSave:
                                    (
                                      request, {
                                      Uint8List? minutesBytes,
                                      String? minutesFileName,
                                    }) =>
                                        _pgsService.saveOperationReviewProtocol(
                                          request: request,
                                          minutesBytes: minutesBytes,
                                          minutesFileName: minutesFileName,
                                        ),
                              ),
                        );
                      }

                      if (value == 'delete' &&
                          status != 'Approved' &&
                          status != 'For Approval') {
                        _showDeleteDialog(pgs.id.toString());
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
                          PopupMenuItem(
                            value: 'operationReviewProtocol',
                            child: PermissionWidget(
                              permission:
                                  AppPermissions.viewOperationReviewProtocol,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.reviews_outlined,
                                    size: 18,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Operation Review Protocol'),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: PopupMenuButton<String>(
                              color: Theme.of(context).cardColor,
                              tooltip: '',
                              offset: const Offset(180, 0),
                              onSelected: (value) async {
                                Navigator.of(context).pop();
                                if (value == 'DeliverablesOnly') {
                                  await openDeliverablesOnlyPreview(
                                    pgs.id.toString(),
                                    officeName,
                                    context: context,
                                  );
                                }
                                if (value == 'ReadinessRating') {
                                  await openReadinessRatingPreview(
                                    pgs.id.toString(),
                                    officeName,
                                    context: context,
                                  );
                                }
                                if (value == 'PGSDeliverablesStatus') {
                                  await openPGSDeliverablesStatusPreview(
                                    pgs.id.toString(),
                                    officeName,
                                    context: context,
                                  );
                                }
                                if (value == 'AllCombinedView') {
                                  await openAllCombinedPGSPreview(
                                    pgs.id.toString(),
                                    officeName,
                                    context: context,
                                  );
                                }
                              },
                              itemBuilder:
                                  (_) => const [
                                    PopupMenuItem(
                                      value: 'DeliverablesOnly',
                                      child: Text('Deliverables Only'),
                                    ),
                                    PopupMenuItem(
                                      value: 'ReadinessRating',
                                      child: Text('Readiness Rating'),
                                    ),
                                    PopupMenuItem(
                                      value: 'PGSDeliverablesStatus',
                                      child: Text('PGS Deliverables Status'),
                                    ),
                                    PopupMenuItem(
                                      value: 'AllCombinedView',
                                      child: Text('All Combined View'),
                                    ),
                                  ],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.description_outlined,
                                      size: 18,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Print preview'),
                                    Spacer(),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          if (status != 'Approved' && status != 'Pending')
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
              gap8px,
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
              gap4px,
              Row(
                children: [
                  const Text("Office: ", style: TextStyle(color: Colors.grey)),
                  Expanded(child: Text(officeName)),
                ],
              ),
              gap4px,
              Row(
                children: [
                  const Text("Period: ", style: TextStyle(color: Colors.grey)),
                  Expanded(child: Text("$start - $end")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<PerformanceGovernanceSystem?> fetchSubmitUserId({
    required String pgsId,
  }) async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null || user.id == null) return null;

      final String userId = user.id!;

      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final String url = "${ApiEndpoint().fetchPGSUserId}/$userId?pgsId=$pgsId";

      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;
        return PerformanceGovernanceSystem.fromJson(data);
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return null;
  }

  Future<void> _onEditTap(PerformanceGovernanceSystem pgs) async {
    try {
      await AuthUtil.saveSelectedOfficeId(pgs.office.id.toString());
      selectedOffice = await AuthUtil.fetchSelectedOfficeId();

      final result = await _pgsService.fetchDeliverablesAndSignatories(
        pgsId: pgs.id.toString(),
      );
      final fetchPgsUser = await fetchSubmitUserId(pgsId: pgs.id.toString());
      final deliverablesList = result['deliverables'] as List<PgsDeliverables>;
      final signatory = result['signatories'] as List<PgsSignatory>;

      if (mounted) {
        setState(() {
          officeDisplay = pgs.office.name;
          officeIdList = pgs.office.id.toString();
        });

        _openDialog(
          existingPgs: {
            'id': pgs.id,
            'name': pgs.office.name,
            'officeid': pgs.office.id,
            'deliverables': deliverablesList,
            'signatories': signatory,
            'rawSignatories':
                fetchPgsUser?.pgsSignatories ?? pgs.pgsSignatories,
            'isDraft': fetchPgsUser?.isDraft ?? pgs.isDraft,
            'startDate': DateTimeConverter().toJson(pgs.pgsPeriod.startDate),
            'endDate': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
            'competencescore':
                pgs.pgsReadinessRating.competenceToDeliver.toString(),
            'resourcescore':
                pgs.pgsReadinessRating.resourceAvailability.toString(),
            'confidencescore':
                pgs.pgsReadinessRating.confidenceToDeliver.toString(),
            'selectPeriod': pgs.pgsPeriod.id.toString(),
          },
        );
      }
      // ignore: empty_catches
    } catch (e) {}
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
            onPageChanged: (page) => fetchPgsFilter(page: page),
          ),
          const SizedBox(width: 60),
        ],
      ),
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
                  await fetchPgsFilter();
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
  final String userId;

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
    required this.userId,
  });

  @override
  State<_PgsFormDialog> createState() => _PgsFormDialogState();
}

class _PgsFormDialogState extends State<_PgsFormDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int? _selectedPeriodId;
  Map<String, dynamic>? _selectedPeriodObject;
  final Map<int, bool> _savedDisapproved = {};
  double _competence = 0.0, _resource = 0.0, _confidence = 0.0;
  double get _total => _competence + _resource + _confidence;
  final ScrollController _listScrollController = ScrollController();
  final List<_DeliverableRow> _rows = [];
  final Map<int, TextEditingController> _delivCtrl = {};
  Map<int, TextEditingController> originalDelivCtrl = {};
  Map<int, bool> clearedOnDisapprove = {};
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
  final Map<int, List<String>> _kraDropdownOptions = {};
  final Map<int, String> _selectedKRAText = {};
  List<Map<String, dynamic>> _options = [];
  bool _processLoading = false;
  final Map<int, String> _previousKRAText = {};
  bool _submitting = false;
  final _formKey = GlobalKey<FormState>();
  final Set<int> _changingKRA = {};
  final Set<int> _isRetrievedData = {};
  final _permissionService = PermissionService();
  final _roadMapService = RoadmapService(Dio());
  final _dateConverter = const LongDateOnlyConverter();
  final Map<int, List<dynamic>> _kraDescCache = {};
  Map<int, String> _initialDelivCtrl = {};
  Map<int, String> _initialKraCtrl = {};
  Map<int, int?> _initialSelectedKRA = {};
  Map<int, String> _initialByWhen = {};
  Map<int, bool> _initialIsDirect = {};
  int? _initialPeriodId;
  double _initialCompetence = 0.0;
  double _initialResource = 0.0;
  double _initialConfidence = 0.0;
  bool get _isMobile => MediaQuery.sizeOf(context).width < 640;
  List<PgsPeriod> get _activePeriods =>
      widget.periods.where((p) => !p.isDeleted).toList();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _initFromExisting();
    if (_rows.isEmpty) _addRowInternal();
    _loadKraOptions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takeSnapshot();
    });
  }

  void _initFromExisting() {
    final pgs = widget.existingPgs;
    if (pgs == null) return;

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

    _competence = double.tryParse(pgs['competencescore'] ?? '') ?? 0.0;
    _resource = double.tryParse(pgs['resourcescore'] ?? '') ?? 0.0;
    _confidence = double.tryParse(pgs['confidencescore'] ?? '') ?? 0.0;

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
          _savedDisapproved[i] = item.isDisapproved;
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
    for (final c in _delivCtrl.values) {
      c.dispose();
    }
    for (final c in _kraCtrl.values) {
      c.dispose();
    }
    for (final c in _kraRoadmapCtrl.values) {
      c.dispose();
    }
    for (final c in _delivRoadmapCtrl.values) {
      c.dispose();
    }
    for (final c in _reasonCtrl.values) {
      c.dispose();
    }
    _listScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadKraOptions() async {
    if (_processLoading) return;
    setState(() => _processLoading = true);

    try {
      final List<KeyResultArea> result = await widget.commonService.fetchKra();
      if (!mounted) return;
      setState(() {
        _options =
            result
                .map(
                  (e) => {
                    'id': e.id,
                    'name': e.name,
                    'remarks': e.remarks,
                    'rowVersion': e.rowVersion ?? '',
                  },
                )
                .toList();

        for (int i = 0; i < _rows.length; i++) {
          final savedKra = _kraCtrl[i]?.text ?? '';
          if (savedKra.isNotEmpty) {
            _selectedKRAText[i] = 'Others';
            _isRetrievedData.add(i);

            _kraDropdownOptions[i] = ['Others'];
            _hasDataMap[i] = false;
          }
        }

        _processLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch KRA Error: $e");
      if (mounted) setState(() => _processLoading = false);
    }
  }

  Future<void> _loadKraDescriptionsForRow(int i, int kraId) async {
    List<dynamic> data;
    if (_kraDescCache.containsKey(kraId)) {
      data = _kraDescCache[kraId]!;
    } else {
      data = await _roadMapService.getAllKraDescriptions(kraId: kraId);
      _kraDescCache[kraId] = data;
    }

    if (!mounted) return;
    setState(() {
      _hasDataMap[i] = data.isNotEmpty;
      _kraDescsByIndex[i] = data;
      final List<String> opts =
          data
              .map<String>((d) => d['kraDescription']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
      opts.add('Others');
      _kraDropdownOptions[i] = opts;
    });
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

  void _addRow() {
    setState(_addRowInternal);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_listScrollController.hasClients) {
        _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
        originalDelivCtrl,
        clearedOnDisapprove,
        _selectedDisapproved,
      ];
      for (final map in maps) {
        map.remove(idx);
      }
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
        clearedOnDisapprove,
        originalDelivCtrl,
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

  Future<void> _submitAction(
    ActionType actionType, {
    bool skipConfirm = false,
  }) async {
    final bool isAnyDisapproved = _selectedDisapproved.values.any(
      (v) => v == true,
    );

    if (actionType == ActionType.approve) {
      actionType =
          isAnyDisapproved ? ActionType.disapprove : ActionType.approve;
    }

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
    if (actionType == ActionType.submit) {
      if (_delivCtrl.length < 2) {
        MotionToast.warning(
          title: const Text("Insufficient Deliverables"),
          description: const Text(
            "Please provide at least 2 or more deliverables.",
          ),
          toastAlignment: Alignment.center,
        ).show(context);
        return;
      }
    }

    if (!skipConfirm) {
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
    }

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
      } else if (actionType == ActionType.submit) {
        for (final d in pgs.pgsDeliverables ?? []) {
          d.isDisapproved = false;
          d.disapprovalRemarks = '';
        }
        success = await widget.onSubmit(id.toString(), pgs);
        if (!success) {
          MotionToast.error(
            description: Text(
              widget.lastResponseStatusCode() == 403
                  ? "You don't have permission to submit."
                  : "Failed to submit!",
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          setState(() => _submitting = false);
          return;
        }
      } else {
        success = await widget.onSubmit(id.toString(), pgs);
        if (!success) {
          MotionToast.error(
            description: Text(
              widget.lastResponseStatusCode() == 403
                  ? "You don't have permission to approve/disapprove."
                  : (actionType == ActionType.approve
                      ? "Failed to approve!"
                      : "Failed to disapprove!"),
            ),
            toastAlignment: Alignment.center,
          ).show(context);
          setState(() => _submitting = false);
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
          i,
          remarks: '',
          rowVersion: '',
        ),
      );
    }
    return list;
  }

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
              color: primaryColor.withValues(alpha: .15),
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
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    _tab1Strategic(isMobile),
                    _tab2Readiness(isMobile),
                    _tab3Deliverables(isMobile),
                  ],
                ),
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
                  color: kPrimaryBg,
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
                      color: kText,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Builder(
          builder:
              (innerContext) => InkWell(
                onTap: () async {
                  // if (!_hasUnsavedChanges()) {
                  //   final prefs = await SharedPreferences.getInstance();
                  //   await prefs.remove('selectedOfficeId');
                  //   await prefs.remove('selectedOfficeName');
                  //   Navigator.pop(innerContext);
                  //   return;
                  // }

                  // final result = await showDialog<String>(
                  //   context: innerContext,
                  //   builder:
                  //       (_) => AlertDialog(
                  //         title: const Text("Unsaved Changes"),
                  //         content: const Text(
                  //           "You have unsaved changes. Would you like to save as draft before leaving?",
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             onPressed:
                  //                 () => Navigator.pop(innerContext, 'discard'),
                  //             child: const Text(
                  //               "Discard",
                  //               style: TextStyle(color: primaryTextColor),
                  //             ),
                  //           ),
                  //           ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor: primaryColor,
                  //               padding: const EdgeInsets.symmetric(
                  //                 vertical: 10,
                  //                 horizontal: 16,
                  //               ),
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(4),
                  //               ),
                  //             ),
                  //             onPressed:
                  //                 () => Navigator.pop(innerContext, 'draft'),
                  //             child: const Text(
                  //               "Save as Draft",
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  // );

                  // if (result == 'draft') {
                  //   await _submitAction(ActionType.draft, skipConfirm: true);
                  //   return;
                  // } else if (result == 'discard') {
                  //   final prefs = await SharedPreferences.getInstance();
                  //   await prefs.remove('selectedOfficeId');
                  //   await prefs.remove('selectedOfficeName');
                  //   Navigator.pop(innerContext);
                  // }

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('selectedOfficeId');
                  await prefs.remove('selectedOfficeName');
                  Navigator.pop(innerContext);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBorder),
                  ),
                  child: Icon(
                    Icons.close,
                    size: isMobile ? 16 : 18,
                    color: kTextMid,
                  ),
                ),
              ),
        ),
      ],
    ),
  );

  void _takeSnapshot() {
    _initialPeriodId = _selectedPeriodId;
    _initialCompetence = _competence;
    _initialResource = _resource;
    _initialConfidence = _confidence;

    _initialDelivCtrl = {
      for (final e in _delivCtrl.entries) e.key: e.value.text,
    };
    _initialKraCtrl = {for (final e in _kraCtrl.entries) e.key: e.value.text};
    _initialSelectedKRA = Map.from(_selectedKRA);
    _initialByWhen = {
      for (int i = 0; i < _rows.length; i++) i: _rows[i].byWhen,
    };
    _initialIsDirect = {
      for (int i = 0; i < _rows.length; i++) i: _rows[i].isDirect,
    };
  }

  bool _hasUnsavedChanges() {
    if (_selectedPeriodId != _initialPeriodId) return true;
    if (_competence != _initialCompetence) return true;
    if (_resource != _initialResource) return true;
    if (_confidence != _initialConfidence) return true;

    final snapshotRowCount = _initialByWhen.length;
    for (int i = 0; i < snapshotRowCount; i++) {
      if ((_delivCtrl[i]?.text ?? '') != (_initialDelivCtrl[i] ?? '')) {
        return true;
      }
      if ((_kraCtrl[i]?.text ?? '') != (_initialKraCtrl[i] ?? '')) return true;
      if (_selectedKRA[i] != _initialSelectedKRA[i]) return true;
      if (_rows[i].byWhen != (_initialByWhen[i] ?? '')) return true;
      if (_rows[i].isDirect != (_initialIsDirect[i] ?? true)) return true;
    }

    for (int i = snapshotRowCount; i < _rows.length; i++) {
      final hasDeliverable = _delivCtrl[i]?.text.trim().isNotEmpty == true;
      final hasKra = _selectedKRA[i] != null;
      final hasByWhen = _rows[i].byWhen.isNotEmpty;
      if (hasDeliverable || hasKra || hasByWhen) return true;
    }

    return false;
  }

  Widget _periodSelector(bool isMobile) {
    String formatPeriodRange(PgsPeriod p) {
      final start = _dateConverter.toJson(p.startDate);
      final end = _dateConverter.toJson(p.endDate);
      return "$start to $end";
    }

    bool hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: _selectedPeriodId,
            hint: Text(
              _activePeriods.isEmpty
                  ? 'No periods available'
                  : 'Select PGS Period',
              style: TextStyle(fontSize: isMobile ? 11 : 13, color: kTextLight),
            ),
            underline: const SizedBox(),
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: kText,
              fontWeight: FontWeight.w500,
            ),
            items:
                _activePeriods.map((p) {
                  return DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(formatPeriodRange(p)),
                  );
                }).toList(),
            onChanged:
                !hasEditPermission
                    ? null
                    : (v) {
                      setState(() {
                        _selectedPeriodId = v;
                        _selectedPeriodObject = widget.filteredListPeriod
                            .firstWhere((p) => p['id'] == v, orElse: () => {});
                      });
                    },
          ),
        ],
      ),
    );
  }

  Widget _tabBar(bool isMobile) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: kBorder, width: 1.5)),
    ),
    child: TabBar(
      controller: _tabs,
      labelColor: primaryColor,
      unselectedLabelColor: kTextLight,
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
    final id = widget.existingPgs?['id'];
    final isDraftSafe = widget.existingPgs?['isDraft'] as bool? ?? true;
    final isAnyDisapproved = _selectedDisapproved.values.any((v) => v == true);
    final String currentUserId = widget.userId.trim();

    final rawSignatories =
        widget.existingPgs?['rawSignatories'] ??
        widget.existingPgs?['signatories'];

    List<Map<String, dynamic>> pgsSignatories = [];
    if (rawSignatories is List) {
      for (final s in rawSignatories) {
        if (s is Map<String, dynamic>) {
          pgsSignatories.add(s);
        } else if (s is PgsSignatory) {
          pgsSignatories.add(s.toJson());
        }
      }
    }

    Map<String, dynamic>? nextSignatory;
    for (final s in pgsSignatories) {
      final isNext = s['isNextStatus'];
      final isNextBool =
          isNext is bool ? isNext : isNext?.toString().toLowerCase() == 'true';
      if (isNextBool == true) {
        nextSignatory = s;
        break;
      }
    }

    final nextSignatoryId =
        nextSignatory?['signatoryId']?.toString().trim() ?? '';
    final isCurrentUserNextSignatory =
        nextSignatoryId.isNotEmpty && nextSignatoryId == currentUserId;

    final showConfirmButton = !isDraftSafe && isCurrentUserNextSignatory;

    final showDraftSubmit =
        isDraftSafe || pgsSignatories.isEmpty || isAnyDisapproved || id == null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: const BoxDecoration(
        color: kBg,
        border: Border(top: BorderSide(color: kBorder)),
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

          if (showDraftSubmit)
            PermissionWidget(
              permission: AppPermissions.draftPerformanceGovernanceSystem,
              child: OutlinedButton(
                onPressed:
                    _submitting
                        ? null
                        : () {
                          if (!_formKey.currentState!.validate()) return;
                          _submitAction(ActionType.draft);
                        },
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
            ),

          if (showDraftSubmit && id != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: PermissionWidget(
                permission: AppPermissions.draftPerformanceGovernanceSystem,
                child: ElevatedButton(
                  onPressed:
                      _submitting
                          ? null
                          : () => _submitAction(ActionType.submit),
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
                    'Submit',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

          if (showConfirmButton)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: PermissionWidget(
                permission: AppPermissions.confirmPerformanceGovernanceSystem,
                child: ElevatedButton(
                  onPressed:
                      _submitting
                          ? null
                          : () => _submitAction(ActionType.approve),
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
                    'Confirm',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
      color: kPrimaryBg,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: kText,
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
          'Office: ${officeName.toUpperCase()}',
          _fHandle + _fNo + _fProcess + _fKra,
          primaryColor,
        ),
        _groupCell('ALIGNMENT', _fDirect + _fIndirect, primaryColor),
        _groupCell('STRATEGIC CONTRIBUTIONS  ', _fDeliv, primaryColor),
        _groupCell('40%', _fByWhen + _fAction, primaryColor),
      ],
    ),
  );

  Widget _subHeaderRow({required String actionLabel}) => Container(
    decoration: BoxDecoration(
      border: Border.symmetric(
        horizontal: BorderSide(color: kBorder, width: 1),
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
            PermissionWidget(
              permission: AppPermissions.editPerformanceGovernanceSystem,
              child: TextButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add, size: 16, color: primaryColor),
                label: const Text(
                  'Add Row',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
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
              border: Border.all(color: kBorder),
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
                  left: BorderSide(color: kBorder),
                  right: BorderSide(color: kBorder),
                  bottom: BorderSide(color: kBorder),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: ReorderableListView.builder(
                scrollController: _listScrollController,
                itemCount: _rows.length,
                onReorder: _onReorder,
                proxyDecorator: _proxyDecorator,
                itemBuilder: (_, i) => _tab1DataRow(i, key: _rowKeys[i]),
              ),
            ),
          ),
        ),
        PermissionWidget(
          permission: AppPermissions.editPerformanceGovernanceSystem,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add, size: 16, color: primaryColor),
                label: const Text(
                  'Add Row',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
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
          shadowColor: primaryColor.withValues(alpha: .3),
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
    _selectedDisapproved.putIfAbsent(i, () => false);
    final row = _rows[i];
    final rowColor = i.isEven ? Colors.white : kBg;
    final hasDeletePermission = _permissionService.hasPermission(
      AppPermissions.deletePerformanceGovernanceSystem,
    );
    final hasDisapprovePermission = _permissionService.hasPermission(
      AppPermissions.disapprovePerformanceGovernanceSystem,
    );
    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder, width: 0.8)),
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
                      color: kTextLight,
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
            _dataCell(_buildProcessCell(i), _fProcess, rowColor),
            _dataCell(_buildKraCell(i), _fKra, rowColor),
            _dataCell(
              Center(
                child: Tooltip(
                  message: 'Enable this if you anchor directly to the roadmap',
                  child: Checkbox(
                    value: row.isDirect,
                    activeColor: primaryColor,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged:
                        (_) =>
                            !hasDeletePermission
                                ? null
                                : setState(() => row.isDirect = true),
                  ),
                ),
              ),
              _fDirect,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Tooltip(
                  message:
                      'For internally initiated actions only (not tied to the roadmap)',
                  child: Checkbox(
                    value: !row.isDirect,
                    activeColor: primaryColor,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged:
                        (_) =>
                            !hasDeletePermission
                                ? null
                                : setState(() => row.isDirect = false),
                  ),
                ),
              ),
              _fIndirect,
              rowColor,
            ),
            _dataCell(_buildDeliverablesCell(i), _fDeliv, rowColor),
            _dataCell(Center(child: _byWhenBtn(i)), _fByWhen, rowColor),
            _dataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasDeletePermission)
                    Tooltip(
                      message: 'Remove row',
                      child: IconButton(
                        icon: const Icon(
                          CupertinoIcons.delete_simple,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to delete this row?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _removeRow(i);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ),
                  if (hasDeletePermission) const SizedBox(height: 8),
                  if (hasDisapprovePermission)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color:
                                    _selectedDisapproved[i] == false
                                        ? Colors.green
                                        : grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDisapproved[i] = false;
                                  _reasonCtrl[i]?.clear();
                                });
                              },
                            ),
                            const Text(
                              'Approve',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_down,
                                color:
                                    _selectedDisapproved[i] == true
                                        ? Colors.red
                                        : grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDisapproved[i] = true;
                                });
                              },
                            ),
                            const Text(
                              'Disapprove',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (hasDisapprovePermission &&
                      _selectedDisapproved[i] == true) ...[
                    gap14px,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reason for Disapproval",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller:
                                _reasonCtrl[i] ??= TextEditingController(),
                            maxLines: 3,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: "Enter reason...",
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildProcessCell(int i) {
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
        child: DropdownButtonFormField<int?>(
          dropdownColor: Colors.white,
          isExpanded: true,
          initialValue: _selectedKRA[i],
          hint:
              _processLoading
                  ? const Row(
                    children: [
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
                      _selectedKRAText[i] = '';
                      _kraCtrl[i]?.clear();
                      _kraDropdownOptions[i] = [];
                    });

                    List<dynamic> data;
                    if (_kraDescCache.containsKey(newValue)) {
                      data = _kraDescCache[newValue]!;
                    } else {
                      data = await _roadMapService.getAllKraDescriptions(
                        kraId: newValue,
                      );
                      _kraDescCache[newValue] = data;
                    }

                    if (!mounted) return;
                    setState(() {
                      _hasDataMap[i] = data.isNotEmpty;
                      _kraDescsByIndex[i] = data;
                      final List<String> opts =
                          data
                              .map<String>(
                                (d) => d['kraDescription']?.toString() ?? '',
                              )
                              .where((s) => s.isNotEmpty)
                              .toList();
                      opts.add('Others');
                      _kraDropdownOptions[i] = opts;
                    });
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
          validator: (value) => value == null ? "Please select process" : null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
        ),
      ),
    );
  }

  // Widget _buildKraCell(int i) {
  //   _kraCtrl.putIfAbsent(i, () => TextEditingController());
  //   _kraRoadmapCtrl.putIfAbsent(i, () => TextEditingController());

  //   final hasEditPermission = _permissionService.hasPermission(
  //     AppPermissions.editPerformanceGovernanceSystem,
  //   );

  //   final List<String> options = _kraDropdownOptions[i] ?? [];
  //   final bool hasOptions = options.isNotEmpty;
  //   final String savedKra = _kraCtrl[i]?.text ?? '';
  //   if ((_selectedKRAText[i] == null || _selectedKRAText[i]!.isEmpty) &&
  //       savedKra.isNotEmpty &&
  //       !_changingKRA.contains(i)) {
  //     final bool isRoadmapKra = options.contains(savedKra);
  //     _selectedKRAText[i] = isRoadmapKra ? savedKra : 'Others';
  //     _rows[i].isDirect = isRoadmapKra;
  //     _isRetrievedData.add(i);
  //   }

  //   final String currentSelection = _selectedKRAText[i] ?? '';
  //   final bool hasSelection = currentSelection.isNotEmpty;
  //   final bool isOthers = currentSelection == 'Others';
  //   final bool isChanging = _changingKRA.contains(i);
  //   final bool isLocked = _isRetrievedData.contains(i);

  //   Future<void> onChangeKraTapped() async {
  //     final confirm = await showDialog<bool>(
  //       context: context,
  //       builder:
  //           (ctx) => AlertDialog(
  //             title: const Text('Change KRA?'),
  //             content: const Text(
  //               'Changing the KRA will clear the current selection. Do you want to continue?',
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(ctx, false),
  //                 child: Text(
  //                   'Cancel',
  //                   style: TextStyle(color: primaryTextColor),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () => Navigator.pop(ctx, true),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: primaryColor,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'Yes, Change',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ],
  //           ),
  //     );

  //     if (confirm == true) {
  //       setState(() {
  //         _selectedKRAText[i] = '';
  //         _kraCtrl[i]?.clear();
  //         _rows[i].isDirect = true;
  //         _isRetrievedData.remove(i);
  //         _changingKRA.add(i);
  //       });
  //       final kraId = _selectedKRA[i];
  //       if (kraId != null) {
  //         await _loadKraDescriptionsForRow(i, kraId);
  //       }
  //     }
  //   }

  //   final changeKraButton = MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     child: GestureDetector(
  //       onTap: onChangeKraTapped,
  //       child: const Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(Icons.swap_horiz, color: Colors.blue, size: 15),
  //           Text(
  //             'Change KRA',
  //             style: TextStyle(fontSize: 11, color: Colors.blue),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  //   if (!hasOptions && !hasSelection && !isChanging) {
  //     return Padding(
  //       padding: const EdgeInsets.all(6),
  //       child: AbsorbPointer(
  //         child: TextFormField(
  //           readOnly: true,
  //           style: const TextStyle(fontSize: 11),
  //           decoration: const InputDecoration(
  //             hintText: 'Select a process first…',
  //             border: OutlineInputBorder(),
  //             isDense: true,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   if (!hasSelection || isChanging) {
  //     return Padding(
  //       padding: const EdgeInsets.all(6),
  //       child: DropdownButtonFormField<String>(
  //         key: ValueKey('kra_dropdown_$i'),
  //         initialValue: null,
  //         isExpanded: true,
  //         hint: const Text('-- Select KRA --', style: TextStyle(fontSize: 11)),
  //         items:
  //             options.map((opt) {
  //               final isOthersOpt = opt == 'Others';
  //               return DropdownMenuItem(
  //                 value: opt,
  //                 child: Row(
  //                   children: [
  //                     if (isOthersOpt)
  //                       const Icon(
  //                         Icons.edit,
  //                         size: 14,
  //                         color: Colors.blueAccent,
  //                       ),
  //                     if (isOthersOpt) const SizedBox(width: 6),
  //                     Expanded(
  //                       child: Text(
  //                         opt,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           color: isOthersOpt ? Colors.blueAccent : kText,
  //                           fontStyle:
  //                               isOthersOpt
  //                                   ? FontStyle.italic
  //                                   : FontStyle.normal,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //         onChanged:
  //             !hasEditPermission
  //                 ? null
  //                 : (value) {
  //                   if (value == null) return;
  //                   setState(() {
  //                     _selectedKRAText[i] = value;
  //                     _changingKRA.remove(i);
  //                     _isRetrievedData.remove(i);
  //                     if (value == 'Others') {
  //                       _rows[i].isDirect = false;
  //                       _kraCtrl[i]?.clear();
  //                     } else {
  //                       _rows[i].isDirect = true;
  //                       _kraCtrl[i]?.text = value;
  //                     }
  //                   });
  //                 },
  //         decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           isDense: true,
  //         ),
  //       ),
  //     );
  //   }

  //   if (isOthers) {
  //     return Padding(
  //       padding: const EdgeInsets.all(6),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           TextFormField(
  //             controller: _kraCtrl[i],
  //             readOnly: !hasEditPermission || isLocked,
  //             maxLines: null,
  //             style: const TextStyle(fontSize: 12),
  //             decoration: InputDecoration(
  //               hintText: 'Type your KRA here…',
  //               border: const OutlineInputBorder(),
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: primaryColor.withValues(alpha: 0.5),
  //                 ),
  //               ),
  //               focusedBorder: const OutlineInputBorder(
  //                 borderSide: BorderSide(color: primaryColor, width: 1.5),
  //               ),
  //               prefixIcon: Icon(
  //                 isLocked ? Icons.lock_outline : Icons.edit,
  //                 size: 14,
  //                 color: primaryColor,
  //               ),
  //             ),
  //             validator:
  //                 (value) =>
  //                     (value == null || value.isEmpty)
  //                         ? 'Please type your KRA'
  //                         : null,
  //           ),
  //           if (hasEditPermission) ...[
  //             const SizedBox(height: 6),
  //             changeKraButton,
  //           ],
  //         ],
  //       ),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(6),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextFormField(
  //           controller: _kraCtrl[i],
  //           readOnly: true,
  //           maxLines: null,
  //           style: const TextStyle(fontSize: 12),
  //           decoration: const InputDecoration(
  //             hintText: 'KRA description…',
  //             border: OutlineInputBorder(),
  //             isDense: true,
  //             prefixIcon: Icon(
  //               Icons.lock_outline,
  //               size: 12,
  //               color: primaryColor,
  //             ),
  //           ),
  //         ),
  //         if (hasEditPermission) ...[gap6px, changeKraButton],
  //       ],
  //     ),
  //   );
  // }
  Widget _buildKraCell(int i) {
    _kraCtrl.putIfAbsent(i, () => TextEditingController());
    _kraRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    final List<String> options = _kraDropdownOptions[i] ?? [];
    final bool hasOptions = options.isNotEmpty;
    final String savedKra = _kraCtrl[i]?.text ?? '';
    if ((_selectedKRAText[i] == null || _selectedKRAText[i]!.isEmpty) &&
        savedKra.isNotEmpty &&
        !_changingKRA.contains(i)) {
      final bool isRoadmapKra = options.contains(savedKra);
      _selectedKRAText[i] = isRoadmapKra ? savedKra : 'Others';
      // _rows[i].isDirect = isRoadmapKra;
      _isRetrievedData.add(i);
    }

    final String currentSelection = _selectedKRAText[i] ?? '';
    final bool hasSelection = currentSelection.isNotEmpty;
    final bool isOthers = currentSelection == 'Others';
    final bool isChanging = _changingKRA.contains(i);
    final bool isLocked = _isRetrievedData.contains(i);

    Future<void> onChangeKraTapped() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Change KRA?'),
              content: const Text(
                'Changing the KRA will clear the current selection. Do you want to continue?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: primaryTextColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Yes, Change',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );

      if (confirm == true) {
        final oldText = _kraCtrl[i]?.text ?? '';
        setState(() {
          if (oldText.isNotEmpty) _previousKRAText[i] = oldText;
          _selectedKRAText[i] = '';
          _kraCtrl[i]?.clear();
          _rows[i].isDirect = true;
          _isRetrievedData.remove(i);
          _changingKRA.add(i);
        });
        final kraId = _selectedKRA[i];
        if (kraId != null) {
          await _loadKraDescriptionsForRow(i, kraId);
        }
      }
    }

    final changeKraButton = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onChangeKraTapped,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, color: Colors.blue, size: 15),
            Text(
              'Change KRA',
              style: TextStyle(fontSize: 11, color: Colors.blue),
            ),
          ],
        ),
      ),
    );

    Widget buildPreviousSuggestion() {
      final prev = _previousKRAText[i];
      if (prev == null || prev.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Previous KRA:',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full text, no ellipsis — selectable para ma-copy
                  SelectableText(
                    prev,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Restore button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _kraCtrl[i]?.text = prev;
                            _selectedKRAText[i] = 'Others';
                            // _rows[i].isDirect = false;
                            _changingKRA.remove(i);
                            _previousKRAText.remove(i);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.restore,
                                size: 12,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Use this',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Dismiss button
                      GestureDetector(
                        onTap: () {
                          setState(() => _previousKRAText.remove(i));
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!hasOptions && !hasSelection && !isChanging) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: const TextStyle(fontSize: 11),
            decoration: const InputDecoration(
              hintText: 'Select a process first…',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      );
    }

    if (!hasSelection || isChanging) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              key: ValueKey('kra_dropdown_$i'),
              initialValue: null,
              isExpanded: true,
              hint: const Text(
                '-- Select KRA --',
                style: TextStyle(fontSize: 11),
              ),
              items:
                  options.map((opt) {
                    final isOthersOpt = opt == 'Others';
                    return DropdownMenuItem(
                      value: opt,
                      child: Row(
                        children: [
                          if (isOthersOpt)
                            const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.blueAccent,
                            ),
                          if (isOthersOpt) const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              opt,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: isOthersOpt ? Colors.blueAccent : kText,
                                fontStyle:
                                    isOthersOpt
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged:
                  !hasEditPermission
                      ? null
                      : (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedKRAText[i] = value;
                          _changingKRA.remove(i);
                          _isRetrievedData.remove(i);
                          if (value == 'Others') {
                            _rows[i].isDirect = false;
                            _kraCtrl[i]?.clear();
                          } else {
                            _rows[i].isDirect = true;
                            _kraCtrl[i]?.text = value;
                            _previousKRAText.remove(i);
                          }
                        });
                      },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            buildPreviousSuggestion(),
          ],
        ),
      );
    }

    if (isOthers) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _kraCtrl[i],
              readOnly: !hasEditPermission || isLocked,
              maxLines: null,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Type your KRA here…',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                prefixIcon: Icon(
                  isLocked ? Icons.lock_outline : Icons.edit,
                  size: 14,
                  color: primaryColor,
                ),
              ),
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please type your KRA'
                          : null,
            ),
            if (hasEditPermission) ...[
              const SizedBox(height: 6),
              changeKraButton,
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _kraCtrl[i],
            readOnly: true,
            maxLines: null,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              hintText: 'KRA description…',
              border: OutlineInputBorder(),
              isDense: true,
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 12,
                color: primaryColor,
              ),
            ),
          ),
          if (hasEditPermission) ...[gap6px, changeKraButton],
        ],
      ),
    );
  }

  Widget _buildDeliverablesCell(int i) {
    _delivCtrl.putIfAbsent(i, () => TextEditingController());
    _delivRoadmapCtrl.putIfAbsent(i, () => TextEditingController());
    originalDelivCtrl.putIfAbsent(i, () => TextEditingController());

    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    final isDisapproved = _savedDisapproved[i] == true;

    if (isDisapproved && clearedOnDisapprove[i] != true) {
      originalDelivCtrl[i]!.text = _delivCtrl[i]?.text ?? '';
      _delivCtrl[i]?.clear();
      clearedOnDisapprove[i] = true;
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDisapproved) ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE2554A).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC99591), width: 1),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC4137),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Disapproved",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  gap12px,
                  const Text(
                    "Reason for Disapproval",
                    style: TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
                  ),
                  gap4px,
                  SelectableText(
                    _reasonCtrl[i]?.text.isNotEmpty == true
                        ? _reasonCtrl[i]!.text
                        : 'No reason provided',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  gap12px,
                  const Divider(thickness: 0.3),
                  gap6px,
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Original Submission',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6B6B),
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
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SelectableText(
                      '"${originalDelivCtrl[i]?.text.isNotEmpty == true ? originalDelivCtrl[i]!.text : 'No deliverable'}"',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          CustomTooltip(
            message:
                'Specify the tangible results or outcomes tied to this responsibility.',
            child: TextFormField(
              readOnly: !hasEditPermission,
              controller: _delivCtrl[i],
              maxLines: null,
              style: const TextStyle(fontSize: 12, color: kText),
              decoration: const InputDecoration(
                hintText: 'Enter deliverable…',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return isDisapproved
                      ? "Please revise your deliverable"
                      : "Please enter your deliverable";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _delivRoadmapCtrl[i]!,
            builder: (context, val, _) {
              if (val.text.isEmpty ||
                  (_delivCtrl[i]?.text.isNotEmpty == true)) {
                return const SizedBox.shrink();
              }
              return Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: kBorder),
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
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'READINESS RATING – ${widget.officeName.toUpperCase()}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: isMobile ? 11 : 24,
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
                color: kText,
                letterSpacing: 1.2,
              ),
            ),
          ),
          gap6px,
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
          gap14px,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 20,
              vertical: isMobile ? 10 : 14,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryBg, Colors.white],
              ),
              border: Border.all(color: kBorder),
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
                    color: kText,
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
                        color: primaryColor.withValues(alpha: 0.3),
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

  Widget _scoreDropdown(double current, ValueChanged<double> onChange) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: kBg,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<double>(
          value: current,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 0, child: Center(child: Text("0"))),
            DropdownMenuItem(value: 0.5, child: Center(child: Text("0.5"))),
            DropdownMenuItem(value: 1, child: Center(child: Text("1"))),
          ],
          onChanged: (v) {
            if (v != null) onChange(v);
          },
        ),
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
            color: kText,
            letterSpacing: 0.5,
          ),
        ),
        gap6px,
        isMobile
            ? Column(
              children: [
                ...List.generate(descs.length, (i) {
                  final val = i * 0.5;
                  return GestureDetector(
                    onTap: () => onChange(val),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ratingBgColor(val),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kPrimaryLight),
                      ),
                      child: Row(
                        children: [
                          Text(
                            val.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: ratingTextColor(val),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              descs[i],
                              style: TextStyle(
                                fontSize: 12,
                                color: ratingTextColor(
                                  val,
                                ).withValues(alpha: 0.9),
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
                    color: kBg,
                    border: Border.all(color: kBorder),
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
                          color: ratingBgColor(val),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kPrimaryLight),
                          boxShadow:
                              sel
                                  ? [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.25,
                                      ),
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
                                color: ratingTextColor(val),
                              ),
                            ),
                            gap4px,
                            Text(
                              descs[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: ratingTextColor(
                                  val,
                                ).withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                _scoreDropdown(current, onChange),
              ],
            ),
      ],
    );
  }

  Widget _tab3Deliverables(bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _mobileOfficeHeader(),
            gap6px,
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
              border: Border.all(color: kBorder),
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
                  left: BorderSide(color: kBorder),
                  right: BorderSide(color: kBorder),
                  bottom: BorderSide(color: kBorder),
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
    final rowColor = i.isEven ? Colors.white : kBg;

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder, width: 0.8)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dataCell(
              Center(
                child: Icon(Icons.drag_indicator, size: 18, color: kBorder),
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
                  style: const TextStyle(fontSize: 12, color: kText),
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
                  style: const TextStyle(fontSize: 12, color: kText),
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
                  color: row.isDirect ? primaryColor : kTextLight,
                ),
              ),
              _fDirect,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Icon(
                  row.isDirect
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  size: 16,
                  color: !row.isDirect ? primaryColor : kTextLight,
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
                  style: const TextStyle(fontSize: 12, color: kText),
                ),
              ),
              _fDeliv,
              rowColor,
            ),
            _dataCell(
              Center(
                child: Text(
                  row.byWhen.isEmpty
                      ? '—'
                      : DateFormat(
                        'MMMM yyyy',
                      ).format(DateTime.parse(row.byWhen)),
                  style: const TextStyle(fontSize: 12, color: kTextMid),
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
                  _outlineBtn(
                    Icons.bar_chart,
                    'Accomplishment',
                    onTap: () => _showAccomplishmentDialog(i),
                  ),
                  gap6px,
                  _outlineBtn(
                    Icons.grade_outlined,
                    'Breakthrough Scoring',
                    onTap: () async {
                      final deliverableId = _deliverableIds[i] ?? 0;
                      if (deliverableId == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please save your deliverables first before viewing breakthrough scoring',
                            ),
                          ),
                        );
                        return;
                      }
                      await loadBreakThrough(deliverableId);
                      _showBreakthroughDialog(i);
                    },
                  ),
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
            color: Colors.white.withValues(alpha: .22),
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
    final hasDeletePermission = _permissionService.hasPermission(
      AppPermissions.deletePerformanceGovernanceSystem,
    );
    final hasDisapprovePermission = _permissionService.hasPermission(
      AppPermissions.disapprovePerformanceGovernanceSystem,
    );

    return Card(
      color: Colors.white,
      key: key,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: kBorder),
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
                        color: kTextLight,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: kPrimaryBg,
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
                    color: kText,
                  ),
                ),
                const Spacer(),
                if (hasDeletePermission)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                'Are you sure you want to delete this row?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _removeRow(i);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
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
            if (hasDisapprovePermission) ...[
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 6),
              _lbl('Approval'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDisapproved[i] = false;
                          _reasonCtrl[i]?.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _selectedDisapproved[i] == false
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _selectedDisapproved[i] == false
                                    ? Colors.green
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color:
                                  _selectedDisapproved[i] == false
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Approve",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDisapproved[i] = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _selectedDisapproved[i] == true
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _selectedDisapproved[i] == true
                                    ? Colors.red
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color:
                                  _selectedDisapproved[i] == true
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Disapprove",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectedDisapproved[i] == true) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _reasonCtrl[i] ??= TextEditingController(),
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Enter reason...",
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    prefixIcon: const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
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
        side: const BorderSide(color: kBorder),
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
                    color: kPrimaryBg,
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
                      color: kText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: row.isDirect ? kPrimaryBg : const Color(0xFFDEEBFF),
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
                color: kTextMid,
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
                color: kTextMid,
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
      color: kTextMid,
      letterSpacing: 0.4,
    ),
  );

  Widget _byWhenBtn(int i) {
    final hasEditPermission = _permissionService.hasPermission(
      AppPermissions.editPerformanceGovernanceSystem,
    );

    DateTime? safeParse(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }

    Future<void> pickMonth(FormFieldState<String> field) async {
      if (_selectedPeriodObject == null || _selectedPeriodObject!.isEmpty) {
        return;
      }

      final start = safeParse(_selectedPeriodObject?['startDate']);
      final end = safeParse(_selectedPeriodObject?['endDate']);
      if (start == null || end == null) return;

      final current = safeParse(field.value);
      final List<DateTime> months = [];
      DateTime cursor = DateTime(start.year, start.month);
      final endMonth = DateTime(end.year, end.month);
      while (!cursor.isAfter(endMonth)) {
        months.add(cursor);
        cursor = DateTime(cursor.year, cursor.month + 1);
      }
      if (months.isEmpty) return;

      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320, maxHeight: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Select Month',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: months.length,
                      separatorBuilder:
                          (_, __) => const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                      itemBuilder: (_, idx) {
                        final m = months[idx];
                        final isSelected =
                            current != null &&
                            current.year == m.year &&
                            current.month == m.month;
                        return ListTile(
                          dense: true,
                          selected: isSelected,
                          selectedTileColor: kPrimaryBg,
                          leading: Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: isSelected ? primaryColor : kTextLight,
                          ),
                          title: Text(
                            DateFormat('MMMM yyyy').format(m),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                              color: isSelected ? primaryColor : kText,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: primaryColor,
                                  )
                                  : null,
                          onTap: () => Navigator.pop(ctx, m),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (picked != null) {
        final lastDay = DateTime(picked.year, picked.month + 1, 0);
        final formatted = DateFormat('yyyy-MM-dd').format(lastDay);
        setState(() => _rows[i].byWhen = formatted);
        field.didChange(formatted);
      }
    }

    return FormField<String>(
      initialValue: _rows[i].byWhen,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please select a month";
        return null;
      },
      builder: (field) {
        final hasDate = field.value != null && field.value!.isNotEmpty;

        final periodNotSelected =
            _selectedPeriodObject == null || _selectedPeriodObject!.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: 'Specify when deliverable is expected to be finished',
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: !hasEditPermission ? null : () => pickMonth(field),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: primaryColor,
                      ),
                      Text(
                        periodNotSelected
                            ? 'Select PGS period first'
                            : hasDate
                            ? DateFormat(
                              'MMMM yyyy',
                            ).format(DateTime.parse(field.value!))
                            : 'Select month',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasDate ? primaryColor : kTextLight,
                          fontWeight:
                              hasDate ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
              child:
                  field.hasError
                      ? Text(
                        field.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      )
                      : null,
            ),
          ],
        );
      },
    );
  }

  Widget _outlineBtn(IconData icon, String label, {VoidCallback? onTap}) =>
      OutlinedButton.icon(
        onPressed: onTap ?? () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );

  void _showAccomplishmentDialog(int index) async {
    if (_selectedPeriodObject == null || _selectedPeriodObject!.isEmpty) {
      MotionToast.warning(
        description: const Text("Please select a period first."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    final String? byWhen =
        _rows[index].byWhen.isEmpty ? null : _rows[index].byWhen;
    if (byWhen == null) {
      MotionToast.warning(
        description: const Text("Please set a 'By When' date first."),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    final int deliverableId = _deliverableIds[index] ?? 0;
    if (deliverableId == 0) {
      MotionToast.warning(
        description: const Text(
          "Please save the record first before adding accomplishments.",
        ),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    final startDate = DateTime.parse(_selectedPeriodObject!['startDate']);
    final endDate = DateTime.parse(_selectedPeriodObject!['endDate']);

    final List<DateTime> startAndEndDates = [];
    DateTime cursor = DateTime(startDate.year, startDate.month);
    final endMonth = DateTime(endDate.year, endDate.month);
    while (!cursor.isAfter(endMonth)) {
      startAndEndDates.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    final int? kraId = _selectedKRA[index];
    final String kraName =
        _options.firstWhere(
          (o) => o['id'] == kraId,
          orElse: () => {'id': 0, 'name': 'Unknown'},
        )['name'];

    final String deliverableName = _delivCtrl[index]?.text ?? '';
    final bool isDirect = _rows[index].isDirect;
    final parsedByWhen = DateTime.parse(byWhen);
    final String formattedByWhen = DateFormat('MMMM yyyy').format(parsedByWhen);
    final formattedStart = DateFormat.yMMMMd().format(startDate);
    final formattedEnd = DateFormat.yMMMMd().format(endDate);

    final currentUser = await AuthUtil.fetchLoggedUser();
    final String userId = currentUser?.id ?? '';

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Accomplishment Form - $formattedStart to $formattedEnd",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                    Expanded(child: Text("KRA: $kraName")),
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
                                    Expanded(
                                      child: Text(
                                        "Deliverable: $deliverableName",
                                      ),
                                    ),
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
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
                                  child: const Row(
                                    children: [
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
                                const Divider(height: 1),
                                AccomplishmentListView(
                                  index: index,
                                  startAndEndDates: startAndEndDates,
                                  deliverableId: deliverableId,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PermissionWidget(
                    permission: AppPermissions.addPgsDeliverableAccomplishment,
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
                              description: const Text('Saved Successfully'),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBreakthroughDialog(int index) async {
    final int deliverableId = _deliverableIds[index] ?? 0;
    if (deliverableId == 0) {
      MotionToast.warning(
        description: const Text(
          "Please save the record first before adding breakthrough scoring.",
        ),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    final int? kraId = _selectedKRA[index];
    final String kraName =
        _options.firstWhere(
          (o) => o['id'] == kraId,
          orElse: () => {'id': 0, 'name': 'Unknown'},
        )['name'];

    final String deliverableName = _delivCtrl[index]?.text ?? '';
    final bool isDirect = _rows[index].isDirect;

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        final isMobile = size.width < 700;

        return Dialog(
          backgroundColor: const Color(0xFFF3F4F6),
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : 24,
            vertical: isMobile ? 0 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
          ),
          child: SizedBox(
            width: isMobile ? size.width : 720,
            height: isMobile ? size.height : size.height * 0.90,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DialogHeader(
                  isMobile: isMobile,
                  onClose: () => Navigator.pop(dialogContext),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 14 : 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InfoPanel(
                          kraName: kraName,
                          deliverableName: deliverableName,
                          isDirect: isDirect,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_outline_rounded,
                              size: 16,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Breakthrough Scoring',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        BreakthroughWidget(deliverableId: deliverableId),
                      ],
                    ),
                  ),
                ),
                DialogFooter(
                  isMobile: isMobile,
                  dialogContext: dialogContext,
                  deliverableId: deliverableId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
