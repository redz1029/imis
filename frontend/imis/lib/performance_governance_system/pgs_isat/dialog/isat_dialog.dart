import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_employee_office.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_signatory.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_annual_performance_commitments.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import '../services/isat_services.dart';

class IsatCommitmentRow {
  final TextEditingController keyTaskCtrl;
  final TextEditingController targetCtrl;
  final TextEditingController timelineCtrl;
  final TextEditingController statusCtrl;
  final TextEditingController accomplishmentCtrl;

  int? kraId;
  int? pgsDeliverableId;
  String contributionName;
  String? kraName;

  IsatCommitmentRow({
    String keyTask = '',
    String target = '',
    String timeline = '',
    String status = '',
    String accomplishment = '',
    this.kraId,
    this.pgsDeliverableId,
    this.contributionName = '',
    this.kraName,
  }) : keyTaskCtrl = TextEditingController(text: keyTask),
       targetCtrl = TextEditingController(text: target),
       timelineCtrl = TextEditingController(text: timeline),
       statusCtrl = TextEditingController(text: status),
       accomplishmentCtrl = TextEditingController(text: accomplishment);

  bool get isEmpty =>
      keyTaskCtrl.text.trim().isEmpty &&
      targetCtrl.text.trim().isEmpty &&
      timelineCtrl.text.trim().isEmpty &&
      statusCtrl.text.trim().isEmpty &&
      accomplishmentCtrl.text.trim().isEmpty &&
      pgsDeliverableId == null;

  void dispose() {
    keyTaskCtrl.dispose();
    targetCtrl.dispose();
    timelineCtrl.dispose();
    statusCtrl.dispose();
    accomplishmentCtrl.dispose();
  }
}

class _RoadmapSelection {
  final IsatRoadmap roadmap;
  List<IsatRoadmapDeliverables> deliverables;
  Set<int> selectedDeliverableIds;

  final Map<int, String> savedNames;
  bool loadingDeliverables;
  String? error;

  _RoadmapSelection({required this.roadmap})
    : deliverables = [],
      selectedDeliverableIds = {},
      savedNames = {},
      loadingDeliverables = false,
      error = null;

  String deliverableText(int id) {
    final fetched = deliverables.firstWhereOrNull((d) => d.id == id);
    return fetched?.deliverableDescription ?? savedNames[id] ?? '';
  }
}

class IsatDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;

  const IsatDialog({super.key, this.existing});

  @override
  State<IsatDialog> createState() => _IsatDialogState();
}

class _IsatDialogState extends State<IsatDialog> {
  final _formKey = GlobalKey<FormState>();

  final _reviewPeriodCtrl = TextEditingController();
  final _employeeNameCtrl = TextEditingController();
  final _departmentUnitCtrl = TextEditingController();
  final _immediateSupervisorCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _serviceCtrl = TextEditingController();

  final _myContributionCtrl = TextEditingController();

  final List<IsatCommitmentRow> _commitmentRows = [];

  final _isatService = IsatServices(Dio());
  bool loadingEmployeeInfo = false;
  final _preparedByCtrl = TextEditingController();
  final _preparedDateCtrl = TextEditingController();
  final _reviewedByCtrl = TextEditingController();
  final _reviewedDateCtrl = TextEditingController();
  final _approvedByCtrl = TextEditingController();
  final _approvedDateCtrl = TextEditingController();
  bool _submitting = false;
  final _commonService = CommonService(Dio());
  List<PgsPeriod> _periods = [];
  PgsPeriod? _selectedPeriod;
  bool _loadingPeriods = false;
  String? userId;
  final List<_RoadmapSelection> _selectedRoadmaps = [];
  List<IsatPgsDeliverables> _pgsDeliverableOptions = [];
  final List<IsatPgsDeliverables> _selectedContributions = [];
  bool _loadingPgsDeliverables = false;
  int? _officeId;
  String? _employeeUserId;
  String? _supervisorUserId;
  int? _serviceId;
  String? get _selectedYear => _selectedPeriod?.startDate.year.toString();
  int? _existingId;
  Map<String, dynamic>? _existing;
  bool _initialized = false;
  bool _isPending = false;
  bool _isApproved = false;
  bool get _isLocked => _isPending || _isApproved;
  bool get _canShowCommitments => _selectedPeriod != null && _officeId != null;
  List<IsatEmployeeOffice> _offices = [];
  bool _loadingOffices = false;

  @override
  void initState() {
    super.initState();
    _initialized = widget.existing == null;
    if (_commitmentRows.isEmpty) {
      _commitmentRows.add(IsatCommitmentRow());
    }
    _initData();
  }

  Future<void> _initData() async {
    try {
      final passed = widget.existing;
      if (passed != null && passed['id'] != null) {
        try {
          _existing = await _isatService.getIsatRawById(
            int.parse(passed['id'].toString()),
          );
        } catch (e) {
          _existing = passed;
          if (mounted) {
            MotionToast.error(
              description: Text('Failed to load ISAT: ${e.toString()}'),
            ).show(context);
          }
        }
      } else {
        _existing = passed;
      }

      await _loadPeriods();
      final e = _existing;
      if (e != null) {
        if (mounted) setState(() => _populateFromExisting(e));
      } else {
        await _loadEmployeeInfo();
      }
      await _loadOffices();
      await _loadPgsDeliverables();
    } finally {
      if (mounted) setState(() => _initialized = true);
    }
  }

  Future<void> _loadPeriods() async {
    setState(() => _loadingPeriods = true);
    try {
      final periods = await _commonService.fetchPgsPeriod();
      setState(() {
        _periods = periods;
        if (_existing != null) {
          final existingId = _existing!['isatPeriodId'];
          _selectedPeriod = _periods.firstWhereOrNull(
            (p) => p.id == existingId,
          );
          if (_selectedPeriod != null) {
            _reviewPeriodCtrl.text =
                (_selectedPeriod!.remarks != null &&
                        _selectedPeriod!.remarks!.isNotEmpty)
                    ? _selectedPeriod!.remarks!
                    : '${_monthName(_selectedPeriod!.startDate.month)} ${_selectedPeriod!.startDate.year} – '
                        '${_monthName(_selectedPeriod!.endDate.month)} ${_selectedPeriod!.endDate.year}';
          }
        }
      });
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          description: Text('Failed to load periods: ${e.toString()}'),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _loadingPeriods = false);
    }
  }

  void _onPeriodSelected(PgsPeriod p) {
    setState(() {
      _selectedPeriod = p;
      _reviewPeriodCtrl.text =
          (p.remarks != null && p.remarks!.isNotEmpty)
              ? p.remarks!
              : '${_monthName(p.startDate.month)} ${p.startDate.year} – '
                  '${_monthName(p.endDate.month)} ${p.endDate.year}';
    });
    for (final entry in _selectedRoadmaps) {
      setState(() {
        entry.selectedDeliverableIds.clear();
        entry.savedNames.clear();
      });
      _loadDeliverablesFor(entry);
    }
    setState(() => _selectedContributions.clear());
    _loadPgsDeliverables();
  }

  Future<void> _loadDeliverablesFor(_RoadmapSelection entry) async {
    final year = _selectedYear;
    if (year == null) return;
    setState(() {
      entry.loadingDeliverables = true;
      entry.error = null;
    });
    try {
      final items = await _isatService.fetchRoadmapDeliverables(
        roadmapId: entry.roadmap.id.toString(),
        year: year,
      );
      if (!mounted) return;
      setState(() => entry.deliverables = items);
    } catch (e) {
      if (!mounted) return;
      setState(() => entry.error = 'Failed to load deliverables.');
    } finally {
      if (mounted) setState(() => entry.loadingDeliverables = false);
    }
  }

  void _populateFromExisting(Map<String, dynamic> v) {
    final isDraft = v['isDraft'] == true;
    final sigs = (v['isatSignatories'] as List?) ?? [];
    final hasSignatories = sigs.isNotEmpty;
    final hasNext = sigs.any((s) => s['isNextStatus'] == true);

    _isPending = !isDraft && hasSignatories && hasNext;
    _isApproved = !isDraft && hasSignatories && !hasNext;

    _existingId = v['id'] is int ? v['id'] as int : int.tryParse('${v['id']}');
    _officeId = int.tryParse(v['officeId']?.toString() ?? '');
    _supervisorUserId = v['immediateSupervisorUserId']?.toString();
    _serviceId = int.tryParse(v['serviceId']?.toString() ?? '');
    _employeeUserId = v['employeeUserId']?.toString();
    _employeeNameCtrl.text = v['employeeName']?.toString() ?? '';
    _departmentUnitCtrl.text = v['office']?['name']?.toString() ?? '';
    _immediateSupervisorCtrl.text =
        v['immediateSupervisorName']?.toString() ?? '';
    _positionCtrl.text = v['position']?.toString() ?? '';
    _serviceCtrl.text = v['service']?['name']?.toString() ?? '';

    _selectedContributions
      ..clear()
      ..addAll(
        ((v['isatStrategyContribution'] as List?) ?? [])
            .where((r) => r['isDeleted'] != true)
            .map(
              (r) => IsatPgsDeliverables(
                r['pgsDeliverableId'] as int,
                r['pgsDeliverableName']?.toString() ?? '',
              ),
            ),
      );

    final rows =
        ((v['isatAnnualPerformanceCommitments'] as List?) ?? [])
            .where((r) => r['isDeleted'] != true)
            .toList();
    if (rows.isNotEmpty) {
      for (final r in _commitmentRows) {
        r.dispose();
      }
      _commitmentRows.clear();
      for (final r in rows) {
        _commitmentRows.add(
          IsatCommitmentRow(
            keyTask: r['deliverable']?.toString() ?? '',
            target: r['target']?.toString() ?? '',
            timeline: r['timeLine']?.toString() ?? '',
            status: r['status']?.toString() ?? '',
            accomplishment: r['accomplishment']?.toString() ?? '',
            kraId: int.tryParse(r['kraId']?.toString() ?? ''),
            pgsDeliverableId: int.tryParse(
              r['pgsDeliverableId']?.toString() ?? '',
            ),
            contributionName: r['deliverableMName']?.toString() ?? '',
            kraName: r['kraMName']?.toString(),
          ),
        );
      }
    }

    for (final s in (v['isatSignatories'] as List?) ?? []) {
      final label = (s['label'] ?? '').toString().toLowerCase();
      final name = s['signatoryName']?.toString() ?? '';
      final signed = DateTime.tryParse(s['dateSigned']?.toString() ?? '');
      final dateText =
          (signed != null && signed.year > 1)
              ? '${_monthName(signed.month)} ${signed.day}, ${signed.year}'
              : '';

      if (label.contains('employee')) {
        _preparedByCtrl.text = name;
        _preparedDateCtrl.text = dateText;
      } else if (label.contains('supervisor')) {
        _reviewedByCtrl.text = name;
        _reviewedDateCtrl.text = dateText;
      } else if (label.contains('head')) {
        _approvedByCtrl.text = name;
        _approvedDateCtrl.text = dateText;
      }
    }
  }

  void _addRow() {
    setState(() => _commitmentRows.add(IsatCommitmentRow()));
  }

  void _removeRow(int index) {
    setState(() {
      _commitmentRows[index].dispose();
      _commitmentRows.removeAt(index);
      if (_commitmentRows.isEmpty) {
        _commitmentRows.add(IsatCommitmentRow());
      }
    });
  }

  Future<void> _loadEmployeeInfo({
    String? userId,
    bool keepOffice = false,
  }) async {
    setState(() => loadingEmployeeInfo = true);
    try {
      String? id = userId;
      if (id == null || id.isEmpty) {
        final user = await AuthUtil.fetchLoggedUser();
        id = user?.id;
      }
      if (id == null || id.isEmpty) return;

      _employeeUserId = id;

      final info = await _isatService.fetchEmployeeInfo(userId: id);
      if (info != null && mounted) {
        setState(() {
          _employeeNameCtrl.text = info.employeeName ?? '';
          _departmentUnitCtrl.text = info.officeName ?? '';
          _immediateSupervisorCtrl.text = info.supervisorName ?? '';
          _positionCtrl.text = info.position ?? '';
          _serviceCtrl.text = info.parentOfficeName ?? '';
          if (!keepOffice) {
            _officeId = int.tryParse(info.officeId.toString());
            _supervisorUserId = info.supervisorUserId.toString();
            _serviceId = int.tryParse(info.parentOfficeId.toString());
          }
        });
      }
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          description: Text('Failed to load employee info: ${e.toString()}'),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => loadingEmployeeInfo = false);
    }
  }

  Future<void> _loadOffices() async {
    final uid = _employeeUserId;
    if (uid == null || uid.isEmpty) return;
    setState(() => _loadingOffices = true);
    try {
      final offices = await _isatService.fetchEmployeeOffices(userId: uid);
      if (!mounted) return;
      setState(() {
        _offices = offices;
        final match = offices.firstWhereOrNull((o) => o.id == _officeId);
        if (match != null) _departmentUnitCtrl.text = match.name;
      });
    } finally {
      if (mounted) setState(() => _loadingOffices = false);
    }
  }

  void _onOfficeSelected(int id) {
    final o = _offices.firstWhereOrNull((e) => e.id == id);
    if (o == null) return;
    setState(() {
      _officeId = o.id;
      _departmentUnitCtrl.text = o.name;
      _serviceId = o.parentOfficeId;
      _serviceCtrl.text = o.parentOfficeName;
      _selectedContributions.clear();
      _pgsDeliverableOptions = [];
      // clear napiling contribution sa rows kasi iba na ang office
      for (final r in _commitmentRows) {
        r.kraId = null;
        r.pgsDeliverableId = null;
        r.contributionName = '';
        r.kraName = null;
      }
    });
    _loadPgsDeliverables();
  }

  Widget _buildOfficeDropdown() {
    if (_loadingOffices) {
      return const LinearProgressIndicator(minHeight: 2, color: primaryColor);
    }
    // fallback kung walang nakuhang offices
    if (_offices.isEmpty) {
      return _inputField(_departmentUnitCtrl, required: true, readOnly: true);
    }

    final value = _offices.any((o) => o.id == _officeId) ? _officeId : null;

    return DropdownButtonFormField<int>(
      dropdownColor: mainBgColor,
      value: value,
      isExpanded: true,
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: primaryTextColor),
      hint: Text(
        'Select department/unit…',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade400,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        ),
      ),
      decoration: _inputDeco(),
      validator: (v) => v == null ? 'Required' : null,
      items:
          _offices
              .map(
                (o) => DropdownMenuItem<int>(
                  value: o.id,
                  child: Text(o.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
      onChanged:
          _isLocked
              ? null
              : (id) {
                if (id != null) _onOfficeSelected(id);
              },
    );
  }

  Future<void> _loadPgsDeliverables() async {
    if (_officeId == null || _selectedPeriod == null) return;
    setState(() => _loadingPgsDeliverables = true);
    try {
      final items = await _isatService.fetchPgsDeliverables(
        officeId: _officeId.toString(),
        periodId: _selectedPeriod!.id.toString(),
      );
      if (!mounted) return;
      setState(() => _pgsDeliverableOptions = items);
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load contribution options: ${e.toString()}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _loadingPgsDeliverables = false);
    }
  }

  String _monthName(int m) =>
      const [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ][m];

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    IconData icon = Icons.help_outline,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: primaryColor, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
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
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            confirmLabel,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
    return confirmed == true;
  }

  Future<void> _confirmAndSave({
    required bool isDraft,
    String? title,
    String? message,
    String? confirmLabel,
    IconData? icon,
  }) async {
    final confirmed = await _showConfirmDialog(
      title: title ?? (isDraft ? 'Confirm Save as Draft' : 'Confirm Submit'),
      message:
          message ??
          (isDraft
              ? 'Save this as a draft? You can continue editing it later.'
              : "Are you sure you want to submit this record? You won't be able to make any changes."),
      confirmLabel: confirmLabel ?? (isDraft ? 'Save as Draft' : 'Submit'),
      icon: icon ?? (isDraft ? Icons.drafts_outlined : Icons.send_outlined),
    );
    if (confirmed) await _saveIsat(isSubmit: !isDraft);
  }

  Widget _buildActionsDropdown(bool isMobile) {
    return PopupMenuButton<String>(
      enabled: !_submitting,
      offset: const Offset(0, -100),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      itemBuilder:
          (context) => [
            PopupMenuItem<String>(
              value: 'draft',
              height: 44,
              child: Row(
                children: [
                  const Icon(
                    Icons.save_outlined,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Save as Draft',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'submit',
              height: 44,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Submit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
      onSelected: (value) => _confirmAndSave(isDraft: value == 'draft'),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 16 : 22,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _submitting ? 'Saving...' : 'Actions',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 11 : 13,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(bool isMobile) {
    return ElevatedButton.icon(
      onPressed:
          _submitting
              ? null
              : () => _confirmAndSave(
                isDraft: false,
                title: 'Confirm ISAT',
                message: 'Are you sure you want to confirm this record?',
                confirmLabel: 'Confirm',
                icon: Icons.verified_outlined,
              ),
      icon: const Icon(Icons.verified_outlined, size: 16, color: Colors.white),
      label: Text(
        'Confirm',
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: isMobile ? 11 : 13,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 12,
          horizontal: isMobile ? 16 : 22,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _saveIsat({required bool isSubmit}) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPeriod == null ||
        _officeId == null ||
        _serviceId == null ||
        _employeeUserId == null) {
      MotionToast.error(
        description: const Text(
          'Missing required data (period, office, or user). Please try again.',
        ),
      ).show(context);
      return;
    }

    setState(() => _submitting = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null || user.id == null) {
        if (mounted) setState(() => _submitting = false);
        return;
      }

      final String userId = user.id!;

      final annualPerformanceCommitmentsList =
          _commitmentRows
              .where((r) => !r.isEmpty)
              .map(
                (r) => IsatAnnualPerformanceCommitments(
                  0,
                  0,
                  r.keyTaskCtrl.text.trim(),
                  r.targetCtrl.text.trim(),
                  r.accomplishmentCtrl.text.trim(),
                  false, // isDeleted
                  DateTime.now(),
                  kraId: r.kraId,
                  pgsDeliverableId: r.pgsDeliverableId,
                ),
              )
              .toList();

      final signatoriesList = <IsatSignatory>[];

      final isat = Isat(
        _existingId ?? 0,
        _selectedPeriod!.id,
        _employeeUserId!,
        _officeId!,
        _supervisorUserId,
        _positionCtrl.text.trim(),
        _serviceId!,
        annualPerformanceCommitmentsList,
        DateTime.now(),
        !isSubmit,
        false,
        signatoriesList,
      );
      final success =
          isSubmit
              ? await _isatService.submitIsat(isat, userId)
              : (_existingId != null
                  ? await _isatService.updateIsat(isat)
                  : await _isatService.saveIsat(isat));

      if (mounted) {
        setState(() => _submitting = false);
        if (success) {
          MotionToast.success(
            description: Text(
              isSubmit ? 'ISAT submitted.' : 'ISAT saved as draft.',
            ),
          ).show(context);
          Navigator.pop(context, true);
        } else {
          MotionToast.error(
            description: const Text('Failed to save ISAT. Please try again.'),
          ).show(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        MotionToast.error(
          description: Text('Error: ${e.toString()}'),
        ).show(context);
      }
    }
  }

  @override
  void dispose() {
    _reviewPeriodCtrl.dispose();
    _employeeNameCtrl.dispose();
    _departmentUnitCtrl.dispose();
    _immediateSupervisorCtrl.dispose();
    _positionCtrl.dispose();
    _serviceCtrl.dispose();
    _myContributionCtrl.dispose();
    for (final r in _commitmentRows) {
      r.dispose();
    }
    _preparedByCtrl.dispose();
    _preparedDateCtrl.dispose();
    _reviewedByCtrl.dispose();
    _reviewedDateCtrl.dispose();
    _approvedByCtrl.dispose();
    _approvedDateCtrl.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
    ),
  );

  Widget _buildPeriodDropdown() {
    return DropdownButtonFormField<PgsPeriod>(
      dropdownColor: mainBgColor,
      value: _selectedPeriod,
      isExpanded: true,
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: primaryTextColor),
      hint: Text(
        'Select period…',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade400,
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        ),
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      validator: (v) => v == null ? 'Required' : null,
      items:
          _periods
              .map(
                (p) => DropdownMenuItem<PgsPeriod>(
                  value: p,
                  child: Text(
                    '${_monthName(p.startDate.month)} ${p.startDate.year} – '
                    '${_monthName(p.endDate.month)} ${p.endDate.year}',
                  ),
                ),
              )
              .toList(),
      onChanged: (p) {
        if (p != null) _onPeriodSelected(p);
      },
    );
  }

  InputDecoration _inputDeco({String hint = ''}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  );

  Widget _inputField(
    TextEditingController ctrl, {
    String hint = '',
    bool required = false,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) => TextFormField(
    controller: ctrl,
    maxLines: maxLines,
    readOnly: readOnly,
    onTap: onTap,
    style: GoogleFonts.plusJakartaSans(fontSize: 12),
    decoration: _inputDeco(hint: hint),
    validator:
        required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
  );

  Widget _buildGeneralInfo(bool isMobile) {
    Widget row(List<Widget> children) =>
        isMobile
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  children
                      .expand((w) => [w, const SizedBox(height: 10)])
                      .toList(),
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  children
                      .expand(
                        (w) => [Expanded(child: w), const SizedBox(width: 12)],
                      )
                      .toList()
                    ..removeLast(),
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('PURPOSE'),
        Text(
          'To align each employee\'s individual work with the CRMC '
          'Strategy Map and departmental objectives.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: primaryTextColor,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        _fieldLabel('Review Period'),
        _loadingPeriods
            ? const LinearProgressIndicator(minHeight: 2, color: primaryColor)
            : _buildPeriodDropdown(),
        const SizedBox(height: 14),
        row([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Employee Name'),
              _inputField(_employeeNameCtrl, required: true, readOnly: true),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_fieldLabel('Department/Unit'), _buildOfficeDropdown()],
          ),
        ]),
        const SizedBox(height: 10),
        row([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Immediate Supervisor'),
              _inputField(_immediateSupervisorCtrl, readOnly: true),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Position'),
              _inputField(_positionCtrl, readOnly: true),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Service'),
              _inputField(_serviceCtrl, readOnly: true),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildCommitmentsTable(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle('I. ANNUAL PERFORMANCE COMMITMENTS')),
            TextButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add, size: 16, color: primaryColor),
              label: Text(
                'Add Row',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              _CommitmentsTableHeader(isMobile: isMobile),
              const Divider(height: 1, color: kBorder),
              ...List.generate(_commitmentRows.length, (i) {
                return _CommitmentRow(
                  key: ValueKey(_commitmentRows[i]),
                  index: i,
                  row: _commitmentRows[i],
                  isMobile: isMobile,
                  canRemove: _commitmentRows.length > 1,
                  onRemove: () => _removeRow(i),
                  options: _pgsDeliverableOptions,
                  loadingOptions: _loadingPgsDeliverables,
                  onContributionChanged:
                      (picked) => setState(() {
                        final r = _commitmentRows[i];
                        r.kraId = picked.kraId;
                        r.pgsDeliverableId = picked.id;
                        r.contributionName = picked.deliverableName;
                        r.kraName = picked.kraName;
                      }),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isMobile) {
    final showActions = _initialized && !_isLocked; // draft / new only
    final showConfirm = _initialized && _isPending; // pending only

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFD),
        border: Border(top: BorderSide(color: kBorder)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              !_initialized
                  ? ''
                  : _isApproved
                  ? "This record has been approved and can no longer be edited."
                  : _isPending
                  ? "This record is pending approval and can no longer be edited."
                  : "Note: Once submitted, this record is not editable. Save as Draft if you need to make changes later.",
              style: GoogleFonts.plusJakartaSans(
                color: kMuted,
                fontSize: 10,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_submitting)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ),
            ),
          if (showActions)
            PermissionWidget(
              permission: AppPermissions.draftISAT,
              child: _buildActionsDropdown(isMobile),
            ),
          if (showConfirm) ...[
            const SizedBox(width: 8),
            PermissionWidget(
              permission: AppPermissions.confirmISAT,
              child: _buildConfirmButton(isMobile),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 640;
    final dWidth =
        isMobile
            ? size.width * 0.97
            : size.width < 900
            ? size.width * 0.92
            : size.width < 1200
            ? size.width * 0.80
            : size.width * 0.65;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 24,
        vertical: isMobile ? 8 : 20,
      ),
      child: Container(
        width: dWidth,
        constraints: BoxConstraints(maxHeight: size.height * 0.93),
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
            Container(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 24,
                isMobile ? 14 : 18,
                14,
                12,
              ),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_tree_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Individual Strategic Alignment Tree (ISAT)',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: isMobile ? 13 : 15,
                          ),
                        ),
                        Text(
                          'Cotabato Regional and Medical Center',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(.75),
                            fontSize: isMobile ? 10 : 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 28,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    // children: [
                    //   _buildGeneralInfo(isMobile),
                    //   _buildCommitmentsTable(isMobile),
                    //   const SizedBox(height: 8),
                    // ],
                    children: [
                      _buildGeneralInfo(isMobile),
                      if (_canShowCommitments)
                        _buildCommitmentsTable(isMobile)
                      else
                        _buildCommitmentsPlaceholder(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentsPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_outline, size: 22, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Select a Review Period and Department/Unit to view the Annual Performance Commitments.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: kMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommitmentsTableHeader extends StatelessWidget {
  final bool isMobile;
  const _CommitmentsTableHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final headerStyle = GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: primaryColor,
    );
    final gap = SizedBox(width: isMobile ? 6 : 8);

    return Container(
      color: primaryColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 6 : 8,
      ),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 24 : 28,
            child: Text('No.', style: headerStyle),
          ),
          Expanded(
            flex: 3,
            child: Text('Strategic Contribution', style: headerStyle),
          ),
          gap,
          Expanded(
            flex: 3,
            child: Text('Key Task / Deliverable', style: headerStyle),
          ),
          gap,
          Expanded(flex: 2, child: Text('Target/Measure', style: headerStyle)),
          gap,
          Expanded(flex: 2, child: Text('Accomplishment', style: headerStyle)),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class _CommitmentRow extends StatelessWidget {
  final int index;
  final IsatCommitmentRow row;
  final bool isMobile;
  final bool canRemove;
  final VoidCallback onRemove;
  final List<IsatPgsDeliverables> options;
  final bool loadingOptions;
  final ValueChanged<IsatPgsDeliverables> onContributionChanged;

  const _CommitmentRow({
    super.key,
    required this.index,
    required this.row,
    required this.isMobile,
    required this.canRemove,
    required this.onRemove,
    required this.options,
    required this.loadingOptions,
    required this.onContributionChanged,
  });

  InputDecoration _cellDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade400),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
  );

  Widget _cell(TextEditingController ctrl, String hint) => TextFormField(
    controller: ctrl,
    maxLines: null,
    style: GoogleFonts.plusJakartaSans(fontSize: 11),
    decoration: _cellDeco(hint),
  );

  List<IsatPgsDeliverables> _entries() {
    final seen = <int>{};
    return options.where((o) => seen.add(o.id)).toList();
  }

  Future<void> _pickContribution(BuildContext context) async {
    final entries = _entries();
    if (entries.isEmpty) return;

    final picked = await showModalBottomSheet<IsatPgsDeliverables>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (ctx, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Strategic Contribution',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => Navigator.pop(ctx),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: kBorder),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: entries.length,
                          separatorBuilder:
                              (_, __) =>
                                  const Divider(height: 1, color: kBorder),
                          itemBuilder: (ctx, i) {
                            final e = entries[i];
                            return InkWell(
                              onTap: () => Navigator.pop(ctx, e),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (e.kraName != null &&
                                        e.kraName!.isNotEmpty)
                                      Text(
                                        e.kraName!,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: primaryColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      e.deliverableName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: primaryTextColor,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
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
    );

    if (picked != null) onContributionChanged(picked);
  }

  Widget _contributionDropdown(BuildContext context) {
    if (loadingOptions) {
      return const LinearProgressIndicator(minHeight: 2, color: primaryColor);
    }

    final current = row.contributionName.trim();
    final kra = row.kraName;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => _pickContribution(context),
      child: InputDecorator(
        decoration: _cellDeco('Select…').copyWith(
          suffixIcon: const Icon(Icons.arrow_drop_down, size: 20),
          suffixIconConstraints: const BoxConstraints(minWidth: 28),
        ),
        isEmpty: current.isEmpty,
        child:
            current.isEmpty
                ? Text(
                  'Select…',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kra != null && kra.isNotEmpty)
                      Text(
                        kra,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    Text(
                      current,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;
    return Container(
      color: isEven ? Colors.white : const Color(0xFFF8FAFD),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 10,
          vertical: 6,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: isMobile ? 24 : 28,
              child: Text(
                '${index + 1}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(flex: 3, child: _contributionDropdown(context)),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(
              flex: 3,
              child: _cell(row.keyTaskCtrl, 'Key task / deliverable…'),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(flex: 2, child: _cell(row.targetCtrl, 'Target…')),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(
              flex: 2,
              child: _cell(row.accomplishmentCtrl, 'Accomplishment…'),
            ),
            SizedBox(
              width: 32,
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.delete_simple,
                  size: 18,
                  color: canRemove ? Colors.red.shade400 : Colors.grey.shade300,
                ),
                onPressed: canRemove ? onRemove : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
