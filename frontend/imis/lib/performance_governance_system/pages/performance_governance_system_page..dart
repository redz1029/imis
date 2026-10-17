// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/dialog/pgs_action_dialog.dart';
import 'package:imis/performance_governance_system/dialog/pgs_form_dialog.dart';
import 'package:imis/performance_governance_system/enum/pgs_action_type.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/table_sorter.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/no_permission_to_view_widget.dart';
import 'package:imis/performance_governance_system/pgs_operation_review_protocol/dialog/monthly_review_dialog_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../performance_governance_system/models/pgs_deliverables.dart';
import '../../performance_governance_system/models/pgs_readiness.dart';
import '../../performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import '../../utils/auth_util.dart';
import '../../utils/permission_service.dart';

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
  bool _isLoading = true;
  final int _pageSize = 15;
  final dio = Dio();
  final _dateConverter = const LongDateOnlyConverter();
  String? selectedEndDateText;
  int? _lastResponseStatusCode;
  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  List<Office> officeList = [];
  List<Office> serviceList = [];
  int? _selectedPeriodId;
  bool _sortActive = false;
  String? selectedPeriodText = "All Periods";
  List<PerformanceGovernanceSystem> deliverableLists = [];
  List<PerformanceGovernanceSystem> filteredList = [];
  List<PerformanceGovernanceSystem> _allItems = [];
  Map<String, int> _statusCounts = {
    'All': 0,
    'Draft': 0,
    'For Approval': 0,
    'Approved': 0,
    'Disapproved': 0,
  };
  bool _mobileFiltersExpanded = false;
  String? _lastResponseMessage;
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
    _initPgsPageData();
  }

  // Future<void> _initPgsPageData() async {
  //   await _fetchData();
  //   await _applyDefaultActivePeriod();
  // }
  Future<void> _initPgsPageData() async {
    try {
      await _fetchData();
      await _applyDefaultActivePeriod();
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  String? _formatSignedDate(dynamic rawDate) {
    if (rawDate == null) return null;
    try {
      final date =
          rawDate is DateTime ? rawDate : DateTime.parse(rawDate.toString());
      return const LongDateOnlyConverter().toJson(date);
    } catch (_) {
      return null;
    }
  }

  // Future<void> _applyDefaultActivePeriod() async {
  //   final activePeriod = filteredListPeriod.firstWhere(
  //     (p) => p['isActive'] == true,
  //     orElse: () => {},
  //   );

  //   if (!mounted) return;

  //   if (activePeriod.isNotEmpty) {
  //     final start = _dateConverter.toJson(
  //       DateTime.parse(activePeriod['startDate']),
  //     );
  //     final end = _dateConverter.toJson(
  //       DateTime.parse(activePeriod['endDate']),
  //     );
  //     setState(() {
  //       _selectedPeriodId = activePeriod['id'];
  //       selectedPeriodText = "$start - $end";
  //       selectedStartPeriod = activePeriod['startDate'];
  //       selectedEndDate = activePeriod['endDate'];
  //     });
  //   }

  //   await fetchPgsFilter();
  // }
  Future<void> _applyDefaultActivePeriod() async {
    final activePeriod = filteredListPeriod.firstWhere(
      (p) => p['isActive'] == true,
      orElse: () => {},
    );

    if (!mounted) return;

    if (activePeriod.isNotEmpty) {
      final start = _dateConverter.toJson(
        DateTime.parse(activePeriod['startDate']),
      );
      final end = _dateConverter.toJson(
        DateTime.parse(activePeriod['endDate']),
      );
      setState(() {
        _selectedPeriodId = activePeriod['id'];
        selectedPeriodText = "$start - $end";
        selectedStartPeriod = activePeriod['startDate'];
        selectedEndDate = activePeriod['endDate'];
      });
    }

    await fetchPgsFilter();
  }

  String _statusOf(PerformanceGovernanceSystem pgs) {
    if ((pgs.pgsDeliverables ?? []).any((d) => d.isDisapproved == true)) {
      return 'Disapproved';
    }
    if (pgs.isDraft ?? false) return 'Draft';
    final hasNext = (pgs.pgsSignatories ?? []).any(
      (s) => s.isNextStatus == true,
    );
    return hasNext ? 'Pending' : 'Approved';
  }

  late final _sorter = TableSorter<PerformanceGovernanceSystem>(
    accessors: {
      'office': (p) => p.office.name.toLowerCase(),
      'period': (p) => p.pgsPeriod.startDate,
      'status': (p) => _statusOf(p),
    },
  );

  // void _onSort() {
  //   _sortActive = true;
  //   fetchPgsFilter(page: 1);
  // }
  void _onSort() {
    _sortActive = true;
    fetchPgsFilter(page: 1, refetch: false);
  }
  // Future<void> fetchPgsFilter({int? page, int pageSize = 15}) async {
  //   if (!mounted) return;
  //   setState(() => _isLoading = true);
  //   final targetPage = page ?? _currentPage;

  //   String filterKey() =>
  //       '$selectedStartPeriod|$selectedEndDate|${_getOfficeOrServiceId()}|$_statusFilter|$_sortActive';
  //   final myKey = filterKey();
  //   bool stale = false;

  //   try {
  //     UserRegistration? user = await AuthUtil.fetchLoggedUser();
  //     if (user == null) return;
  //     if (!mounted) return;
  //     setState(() => userId = user.id ?? "");

  //     final roleIdParam = await _getRoleId();
  //     final officeOrServiceId = _getOfficeOrServiceId();

  //     final result = await _pgsService.fetchFilteredPgsWithCounts(
  //       roleId: roleIdParam,
  //       page: _sortActive ? 1 : targetPage,
  //       pageSize: _sortActive ? 80 : pageSize,
  //       fromDate:
  //           selectedStartPeriod != null
  //               ? DateFormat(
  //                 'yyyy-MM-dd',
  //               ).format(DateTime.parse(selectedStartPeriod!))
  //               : null,
  //       toDate:
  //           selectedEndDate != null
  //               ? DateFormat(
  //                 'yyyy-MM-dd',
  //               ).format(DateTime.parse(selectedEndDate!))
  //               : null,
  //       officeId: officeOrServiceId,
  //       statusFilter: _statusFilter,
  //     );

  //     if (!mounted || myKey != filterKey()) {
  //       stale = true;
  //       return;
  //     }

  //     final all = List<PerformanceGovernanceSystem>.from(result['items']);
  //     List<PerformanceGovernanceSystem> pageItems = all;
  //     int total = result['totalCount'];
  //     int pageNo = result['page'];

  //     if (_sortActive) {
  //       _sorter.apply(all);
  //       final start = (targetPage - 1) * pageSize;
  //       final end = (start + pageSize).clamp(0, all.length);
  //       pageItems = start >= all.length ? [] : all.sublist(start, end);
  //       total = all.length;
  //       pageNo = targetPage;
  //     }

  //     setState(() {
  //       deliverableLists = pageItems;
  //       filteredList = pageItems;
  //       _currentPage = pageNo;
  //       _totalCount = total;
  //       _statusCounts = result['statusCounts'];
  //     });
  //   } on DioException {
  //     debugPrint("Dio error");
  //   } catch (e) {
  //     debugPrint("Unexpected error");
  //   } finally {
  //     if (mounted && !stale) setState(() => _isLoading = false);
  //   }
  // }
  Future<void> fetchPgsFilter({int? page, bool refetch = true}) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      if (refetch) {
        final user = await AuthUtil.fetchLoggedUser();
        if (user == null) return;
        userId = user.id ?? "";

        final result = await _pgsService.fetchFilteredPgsWithCounts(
          roleId: await _getRoleId(),
          page: 1,
          pageSize: 1000,
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
          officeId: _getOfficeOrServiceId(),
          statusFilter: 'All',
        );
        _allItems = List<PerformanceGovernanceSystem>.from(result['items']);
      }

      if (!mounted) return;

      final counts = {
        'All': _allItems.length,
        'Draft': 0,
        'For Approval': 0,
        'Approved': 0,
        'Disapproved': 0,
      };
      for (final p in _allItems) {
        final s = _statusOf(p);
        final key = s == 'Pending' ? 'For Approval' : s;
        counts[key] = (counts[key] ?? 0) + 1;
      }

      final filtered =
          _statusFilter == 'All'
              ? List<PerformanceGovernanceSystem>.from(_allItems)
              : _allItems.where((p) {
                final s = _statusOf(p);
                return _statusFilter == 'For Approval'
                    ? s == 'Pending'
                    : s == _statusFilter;
              }).toList();

      if (_sortActive) _sorter.apply(filtered);

      final start = (targetPage - 1) * _pageSize;
      final end = (start + _pageSize).clamp(0, filtered.length);
      final pageItems =
          start >= filtered.length
              ? <PerformanceGovernanceSystem>[]
              : filtered.sublist(start, end);

      setState(() {
        deliverableLists = pageItems;
        filteredList = pageItems;
        _currentPage = targetPage;
        _totalCount = filtered.length;
        _statusCounts = counts;
      });
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Future<bool> pgsSaveAsDraft(PerformanceGovernanceSystem pgs) async {
    final (statusCode, message) = await _pgsService.saveAsDraft(pgs);
    _lastResponseStatusCode = statusCode;
    _lastResponseMessage = message;

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

    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => PgsActionDialog(
            title: title,
            content: content,
            actionType: actionType,
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
        bool isDeleting = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Future<void> handleDelete() async {
              final confirm = await showDialog<bool>(
                context: ctx,
                builder:
                    (confirmCtx) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: 340,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: kDangerLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: kDanger,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Delete Approval Timeline',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: kText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This will remove all signatory records for this PGS. This action cannot be undone.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: kMuted,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed:
                                        () => Navigator.pop(confirmCtx, false),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: kBorder),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: kMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => Navigator.pop(confirmCtx, true),
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Delete',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kDanger,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              );

              if (confirm != true) return;

              setDialogState(() => isDeleting = true);
              try {
                await _pgsService.deleteSignatoryTimeline(pgs.id.toString());
                if (!mounted) return;
                MotionToast.success(
                  description: const Text('Timeline deleted successfully'),
                  toastAlignment: Alignment.topCenter,
                ).show(context);
                Navigator.pop(ctx);
                fetchPgsFilter();
              } catch (_) {
                setDialogState(() => isDeleting = false);
                if (!mounted) return;
                MotionToast.error(
                  description: const Text('Failed to delete timeline'),
                  toastAlignment: Alignment.topCenter,
                ).show(context);
              }
            }

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 380,
                  maxHeight: 560,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    status,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.route_outlined,
                                  color: getStatusColor(status),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Approval Timeline',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed:
                                    isDeleting
                                        ? null
                                        : () => Navigator.pop(ctx),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pgs.office.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Column(
                          children: [
                            if (isDraft)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
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
                                          ? true
                                          : index < nextIndex;
                                  final bool isPending = isNext;

                                  final Color dotColor =
                                      isDone
                                          ? kSuccess
                                          : isPending
                                          ? Colors.orange.shade600
                                          : Colors.grey.shade300;

                                  final Color lineColor =
                                      isDone ? kSuccess : Colors.grey.shade200;

                                  final String label =
                                      signatoryJson['label']?.toString() ??
                                      signatoryJson['designation']
                                          ?.toString() ??
                                      signatoryJson['role']?.toString() ??
                                      'Signatory';

                                  final String name =
                                      signatoryJson['signatoryName']
                                          ?.toString() ??
                                      signatoryJson['name']?.toString() ??
                                      signatoryJson['fullName']?.toString() ??
                                      'Unknown';

                                  final bool isLast =
                                      index == signatories.length - 1;
                                  return IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 28,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 14,
                                                height: 14,
                                                margin: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: dotColor,
                                                  shape: BoxShape.circle,
                                                  border:
                                                      isPending
                                                          ? Border.all(
                                                            color:
                                                                Colors
                                                                    .orange
                                                                    .shade600,
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
                                                          margin:
                                                              const EdgeInsets.all(
                                                                3,
                                                              ),
                                                          decoration:
                                                              const BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                        )
                                                        : null,
                                              ),
                                              if (!isLast)
                                                Expanded(
                                                  child: Container(
                                                    width: 2,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 2,
                                                        ),
                                                    color: lineColor,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
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
                                                            ? kSuccess
                                                            : isPending
                                                            ? Colors
                                                                .orange
                                                                .shade600
                                                            : Colors
                                                                .grey
                                                                .shade500,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  name,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1A1D23),
                                                  ),
                                                ),
                                                if (isDone) ...[
                                                  Builder(
                                                    builder: (_) {
                                                      final signedDate = _formatSignedDate(
                                                        signatoryJson['dateSigned'] ??
                                                            signatoryJson['signedDate'] ??
                                                            signatoryJson['postingDate'],
                                                      );
                                                      if (signedDate == null) {
                                                        return const SizedBox.shrink();
                                                      }
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 2,
                                                            ),
                                                        child: Text(
                                                          'Signed on $signedDate',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors
                                                                    .grey
                                                                    .shade600,
                                                            fontStyle:
                                                                FontStyle
                                                                    .italic,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                                gap8px,
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isDone
                                                            ? kSuccess
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                )
                                                            : isPending
                                                            ? Colors
                                                                .orangeAccent
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                )
                                                            : Colors.grey
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          isDone
                                                              ? kSuccess
                                                              : isPending
                                                              ? Colors
                                                                  .orange
                                                                  .shade600
                                                              : Colors
                                                                  .grey
                                                                  .shade500,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: PermissionWidget(
                          permission: AppPermissions.deleteSignatory,
                          child: ElevatedButton.icon(
                            onPressed: isDeleting ? null : handleDelete,
                            icon:
                                isDeleting
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Icon(
                                      CupertinoIcons.delete_simple,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                            label: Text(
                              isDeleting ? 'Deleting...' : 'Delete Signatory',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDanger,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          (_) => PgsFormDialog(
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
            lastResponseMessage: () => _lastResponseMessage,
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 32,
                ),
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
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;
    final isXSmall = width < 700;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isXSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  color: primaryColor,
                  size: isXSmall ? 18 : 22,
                ),
              ),
              SizedBox(width: isXSmall ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PGS Deliverables Information",
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "$_totalCount PGS deliverable${_totalCount != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: isXSmall ? 10 : 12,
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
                      padding: EdgeInsets.symmetric(
                        vertical: isXSmall ? 8 : 10,
                        horizontal: isXSmall ? 10 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: isXSmall ? 14 : 16,
                    ),
                    label: Text(
                      isXSmall ? 'Add' : 'Add New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isXSmall ? 11 : 13,
                      ),
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
      _selectedOfficeId = null;
      _selectedPeriodId = null;
      selectedPeriodText = "All Periods";
      selectedStartPeriod = null;
      selectedEndDate = null;
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(
                  () => _mobileFiltersExpanded = !_mobileFiltersExpanded,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune, size: 16, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _mobileFiltersExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child:
                  _hasActiveFilters
                      ? TextButton.icon(
                        key: const ValueKey('clear'),
                        onPressed: _resetFilters,
                        icon: Icon(
                          Icons.refresh,
                          size: 14,
                          color: Colors.red.shade400,
                        ),
                        label: Text(
                          'Clear filters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade400,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child:
              _mobileFiltersExpanded
                  ? Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 38,
                          child: PermissionWidget(
                            permission: AppPermissions.viewOffice,
                            child: _servicesDropdown(),
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
                        SizedBox(height: 38, child: _periodDropdown()),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  bool get _hasActiveFilters =>
      _selectedServiceId != null ||
      _selectedOfficeId != null ||
      _selectedPeriodId != null;

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _servicesDropdown(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PermissionWidget(
                permission: AppPermissions.viewOffice,
                child: _officeDropdown(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _periodDropdown()),
            if (_hasActiveFilters) ...[
              const SizedBox(width: 10),
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 13, color: Colors.red.shade400),
                label: Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ],
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

  Widget _periodDropdown() {
    String labelFor(Map<String, dynamic> p) {
      final start = _dateConverter.toJson(DateTime.parse(p['startDate']));
      final end = _dateConverter.toJson(DateTime.parse(p['endDate']));
      return "$start - $end";
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,

        child: SearchableDropdown(
          items: ["All Periods", ...filteredListPeriod.map(labelFor)],
          selectedItem: selectedPeriodText,
          prefixIcon: Icons.calendar_today_outlined,
          hintText: "All Periods",
          searchHint: "Search period...",
          onChanged: (value) {
            setState(() {
              if (value == "All Periods") {
                _selectedPeriodId = null;
                selectedPeriodText = "All Periods";
                selectedStartPeriod = null;
                selectedEndDate = null;
              } else {
                final selected = filteredListPeriod.firstWhere(
                  (p) => labelFor(p) == value,
                );
                _selectedPeriodId = selected['id'];
                selectedPeriodText = value;
                selectedStartPeriod = selected['startDate'];
                selectedEndDate = selected['endDate'];
              }
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

  Widget _buildDesktopHeader() {
    return Column(
      children: [
        _buildStatusTabs(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 60,
                child: Text(
                  "#",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              SortHeader<PerformanceGovernanceSystem>(
                label: 'Office',
                column: 'office',
                flex: 3,
                sorter: _sorter,
                onChanged: _onSort,
              ),
              SortHeader<PerformanceGovernanceSystem>(
                label: 'Period',
                column: 'period',
                flex: 2,
                sorter: _sorter,
                onChanged: _onSort,
              ),
              const SizedBox(width: 24),
              SortHeader<PerformanceGovernanceSystem>(
                label: 'Status',
                column: 'status',
                flex: 2,
                sorter: _sorter,
                onChanged: _onSort,
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  "Actions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _statusTabIcon(String label) {
    switch (label) {
      case 'Draft':
        return Icons.edit_note_rounded;
      case 'For Approval':
        return Icons.pending_actions_rounded;
      case 'Approved':
        return Icons.check_circle_rounded;
      case 'Disapproved':
        return Icons.cancel_rounded;
      default:
        return Icons.list_alt_rounded;
    }
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
      ('Approved', _statusCounts['Approved'] ?? 0, kSuccess),
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
                    // _statusFilter = label;
                    // _currentPage = 1;
                    // deliverableLists = [];
                    // filteredList = [];
                    // _totalCount = 0;
                    _statusFilter = label;
                    _currentPage = 1;
                  });
                  fetchPgsFilter(page: 1, refetch: false);
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
                      Icon(
                        _statusTabIcon(label),
                        size: 14,
                        color:
                            isSelected
                                ? primaryColor
                                : (color ?? Colors.grey.shade600),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
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

  Widget _statusCell(PerformanceGovernanceSystem pgs, String status) {
    final bool isDraft = status == 'Draft';
    final Color color = isDraft ? Colors.grey.shade600 : getStatusColor(status);
    String nextName = '';
    if (status == 'Pending') {
      final next =
          (pgs.pgsSignatories ?? [])
              .where((s) => s.isNextStatus == true)
              .firstOrNull;
      if (next != null) {
        nextName =
            (next.signatoryName ?? '').toString().replaceAll('..', '.').trim();
      }
    }

    return Tooltip(
      message: 'View approval timeline',

      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showSignatoryTimeline(context, pgs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isDraft
                          ? Colors.grey.shade200
                          : color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isDraft ? FontWeight.w500 : FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              if (nextName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Awaiting ',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          TextSpan(
                            text: nextName,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    final displayList = filteredList;
    if (displayList.isEmpty) {
      String emptyText = 'No deliverables found';
      if (selectedStartPeriod != null && selectedEndDate != null) {
        final start = DateFormat(
          'MMMM',
        ).format(DateTime.parse(selectedStartPeriod!));
        final end = DateFormat(
          'MMMM yyyy',
        ).format(DateTime.parse(selectedEndDate!));
        emptyText = 'No deliverables found on $start to $end period';
      }
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
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text("$itemNumber", style: TextStyle(fontSize: 12)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(officeName, style: const TextStyle(fontSize: 12)),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "$start - $end",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _statusCell(pgs, status)),
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
                            icon: const Icon(size: 16, Icons.edit_outlined),
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
                              size: 16,
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
                            size: 16,
                            color: blue,
                          ),
                          onSelected: (value) async {
                            if (value == 'AllCombinedView') {
                              await openAllCombinedPGSPreview(
                                pgs.id.toString(),
                                officeName,
                                context: context,
                              );
                            }
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
                          },
                          itemBuilder:
                              (_) => [
                                const PopupMenuItem(
                                  value: 'AllCombinedView',
                                  child: Text('All Combined View'),
                                ),
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
                              ],
                        ),
                      ),
                      if (status != 'Approved' && status != 'Pending')
                        PermissionWidget(
                          permission:
                              AppPermissions.deletePerformanceGovernanceSystem,
                          child: IconButton(
                            icon: const Icon(
                              size: 16,
                              CupertinoIcons.delete_simple,
                              color: Colors.redAccent,
                            ),
                            onPressed:
                                () => showDeleteDialog(pgs.id.toString()),
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
                        showDeleteDialog(pgs.id.toString());
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
                                  Icon(Icons.edit_outlined, size: 16),
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
                                    size: 16,
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
                                      size: 16,
                                      color: blue,
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
                                      size: 16,
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
              _statusCell(pgs, status),
              gap4px,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      officeName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              gap4px,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "$start - $end",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            onPageChanged: (page) => fetchPgsFilter(page: page, refetch: false),
            // onPageChanged: (page) => fetchPgsFilter(page: page),
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'PGS',
            itemName: 'PGS',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _pgsService.deletePgs(id);
                await fetchPgsList();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'PGS deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete PGS',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
