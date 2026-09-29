import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_signatory.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_annual_performance_commitments.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_strategic_contribution.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_strategic_objective_supported.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:motion_toast/motion_toast.dart';

import '../services/isat_services.dart';

class IsatCommitmentRow {
  final TextEditingController keyTaskCtrl;
  final TextEditingController targetCtrl;
  final TextEditingController timelineCtrl;
  final TextEditingController statusCtrl;
  final TextEditingController accomplishmentCtrl;

  IsatCommitmentRow({
    String keyTask = '',
    String target = '',
    String timeline = '',
    String status = '',
    String accomplishment = '',
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
      accomplishmentCtrl.text.trim().isEmpty;

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

  /// Fallback names galing sa saved record (in case wala sa fetched list).
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

  bool _employeeCommitted = false;
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

  List<IsatRoadmap> _roadmapItems = [];
  final List<_RoadmapSelection> _selectedRoadmaps = [];
  bool _loadingRoadmap = false;
  List<IsatPgsDeliverables> _pgsDeliverableOptions = [];
  final List<IsatPgsDeliverables> _selectedContributions = [];
  bool _loadingPgsDeliverables = false;
  int? _officeId;
  String? _employeeUserId;
  String? get _selectedYear => _selectedPeriod?.startDate.year.toString();
  int? _existingId;

  /// Full record galing sa get-by-id (raw JSON).
  Map<String, dynamic>? _existing;

  @override
  void initState() {
    super.initState();
    if (_commitmentRows.isEmpty) {
      _commitmentRows.add(IsatCommitmentRow());
    }
    _initData();
  }

  Future<void> _initData() async {
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
      await _loadEmployeeInfo(
        userId: e['employeeUserId']?.toString(),
        keepOffice: true,
      );
    } else {
      await _loadEmployeeInfo();
    }
    await _loadRoadmap();
    await _loadPgsDeliverables();
  }

  List<Map<String, dynamic>> _buildSignatoryPayload() {
    final existing =
        ((_existing?['isatSignatories'] as List?) ?? [])
            .where((s) => s['isDeleted'] != true)
            .map(
              (s) =>
                  Map<String, dynamic>.from(s as Map)
                    ..['isatId'] = _existingId ?? 0,
            )
            .toList();
    if (existing.isNotEmpty) return existing;

    return [
      {
        'isatId': _existingId ?? 0,
        'isatSignatoryTemplateId': null,
        'signatoryId': _employeeUserId,
        'signatoryName': _employeeNameCtrl.text,
        'dateSigned': DateTime.now(),
        'label': 'Employee',
        'status': 'Pending',
        'orderLevel': 0,
        'isNextStatus': true,
        'id': 0,
        'isDeleted': false,
        'rowVersion': null,
      },
    ];
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

  Future<void> _loadRoadmap() async {
    setState(() => _loadingRoadmap = true);
    try {
      final items = await _isatService.fetchIsatRoadmap();
      setState(() => _roadmapItems = items);

      final existingSelections =
          ((_existing?['isatStrategicObjectiveSupported'] as List?) ?? [])
              .where((r) => r['isDeleted'] != true)
              .toList();

      if (existingSelections.isNotEmpty) {
        final byRoadmap = <int, _RoadmapSelection>{};
        for (final raw in existingSelections) {
          final roadmapId = raw['kraRoadMapId'] as int;
          final match = _roadmapItems.firstWhereOrNull(
            (r) => r.id == roadmapId,
          );
          if (match == null) continue;
          final entry = byRoadmap.putIfAbsent(
            roadmapId,
            () => _RoadmapSelection(roadmap: match),
          );
          final did = raw['kraRoadMapDeliverableId'] as int;
          entry.selectedDeliverableIds.add(did);
          entry.savedNames[did] =
              raw['kraRoadMapDeliverableName']?.toString() ?? '';
        }
        final restored = byRoadmap.values.toList();
        if (mounted) {
          setState(() => _selectedRoadmaps.addAll(restored));
        }
        for (final entry in restored) {
          _loadDeliverablesFor(entry);
        }
      }
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          description: Text('Failed to load roadmap: ${e.toString()}'),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _loadingRoadmap = false);
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

  Future<void> _showAddRoadmapSheet() async {
    if (_selectedPeriod == null) {
      MotionToast.warning(
        description: const Text('Please select a Review Period first.'),
      ).show(context);
      return;
    }

    final available =
        _roadmapItems
            .where((r) => !_selectedRoadmaps.any((s) => s.roadmap.id == r.id))
            .toList();

    if (available.isEmpty) {
      MotionToast.info(
        description: const Text('All roadmap items have been added.'),
      ).show(context);
      return;
    }

    final picked = await showModalBottomSheet<IsatRoadmap>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            'Select Roadmap / Strategic Objective',
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
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: available.length,
                      separatorBuilder:
                          (_, __) => const Divider(height: 1, color: kBorder),
                      itemBuilder: (ctx, i) {
                        final item = available[i];
                        return InkWell(
                          onTap: () => Navigator.pop(ctx, item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.kraName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.strategicObjective,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: kMuted,
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
            );
          },
        );
      },
    );

    if (picked != null) {
      final entry = _RoadmapSelection(roadmap: picked);
      setState(() => _selectedRoadmaps.add(entry));
      _loadDeliverablesFor(entry);
    }
  }

  void _removeRoadmap(_RoadmapSelection entry) {
    setState(() => _selectedRoadmaps.remove(entry));
  }

  void _populateFromExisting(Map<String, dynamic> v) {
    _existingId = v['id'] is int ? v['id'] as int : int.tryParse('${v['id']}');
    _officeId = int.tryParse(v['officeId']?.toString() ?? '');

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

  void _addContribution(IsatPgsDeliverables d) {
    setState(() => _selectedContributions.add(d));
  }

  void _removeContribution(IsatPgsDeliverables d) {
    setState(() => _selectedContributions.removeWhere((e) => e.id == d.id));
  }

  Future<void> _showAddContributionSheet() async {
    if (_officeId == null || _selectedPeriod == null) {
      MotionToast.warning(
        description: const Text('Please select a Review Period first.'),
      ).show(context);
      return;
    }

    final available =
        _pgsDeliverableOptions
            .where((d) => !_selectedContributions.any((s) => s.id == d.id))
            .toList();

    if (available.isEmpty) {
      MotionToast.info(
        description: const Text('No more items to add.'),
      ).show(context);
      return;
    }

    final picked = await showModalBottomSheet<IsatPgsDeliverables>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            'Select Contribution',
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
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: available.length,
                      separatorBuilder:
                          (_, __) => const Divider(height: 1, color: kBorder),
                      itemBuilder: (ctx, i) {
                        final d = available[i];
                        return InkWell(
                          onTap: () => Navigator.pop(ctx, d),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              d.deliverableName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: primaryTextColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      _addContribution(picked);
    }
  }

  Future<DateTime?> _pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ctrl.text = '${_monthName(picked.month)} ${picked.day}, ${picked.year}';
    }
    return picked;
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

  Future<void> _saveIsat({required bool isSubmit}) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRoadmaps.isEmpty) {
      MotionToast.error(
        description: const Text(
          'Please add at least one roadmap / strategic objective.',
        ),
      ).show(context);
      return;
    }

    if (isSubmit && !_employeeCommitted) {
      MotionToast.error(
        description: const Text(
          'Please confirm the Employee Commitment before submitting.',
        ),
      ).show(context);
      return;
    }

    if (_selectedPeriod == null ||
        _officeId == null ||
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
      // I. Strategic alignment (roadmap + selected deliverables)
      final strategicObjectiveSupportedList =
          <IsatStrategicObjectiveSupported>[];
      for (final entry in _selectedRoadmaps) {
        for (final id in entry.selectedDeliverableIds) {
          strategicObjectiveSupportedList.add(
            IsatStrategicObjectiveSupported(
              0,
              0,
              entry.roadmap.id,
              entry.roadmap.kraName,
              id,
              entry.deliverableText(id),
              entry.roadmap.strategicObjective,
              DateTime.now(),
              false,
            ),
          );
        }
      }

      final annualPerformanceCommitmentsList =
          _commitmentRows
              .where((r) => !r.isEmpty)
              .map(
                (r) => IsatAnnualPerformanceCommitments(
                  0,
                  0,
                  r.keyTaskCtrl.text.trim(),
                  r.targetCtrl.text.trim(),
                  r.timelineCtrl.text.trim(),
                  r.statusCtrl.text.trim(),
                  r.accomplishmentCtrl.text.trim(),
                  false, // isDeleted
                  DateTime.now(),
                ),
              )
              .toList();

      final strategyContributionList =
          _selectedContributions
              .map(
                (d) => IsatStrategicContribution(
                  0,
                  false,
                  0,
                  d.id,
                  DateTime.now(),
                  d.deliverableName,
                ),
              )
              .toList();

      final signatoriesList = <IsatSignatory>[];

      final isat = Isat(
        _existingId ?? 0,
        _selectedPeriod!.id,
        _employeeUserId!,
        _officeId!,
        strategicObjectiveSupportedList,
        annualPerformanceCommitmentsList,
        strategyContributionList,
        DateTime.now(),
        !isSubmit,
        false,
        signatoriesList,
      );

      final success =
          isSubmit
              ? await _isatService.submitIsat(
                isat,
                _employeeUserId!,
                signatories: _buildSignatoryPayload(),
              )
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
            children: [
              _fieldLabel('Department/Unit'),
              _inputField(_departmentUnitCtrl, required: true, readOnly: true),
            ],
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

  Widget _buildStrategicAlignment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle('I. STRATEGIC ALIGNMENT')),
            TextButton.icon(
              onPressed: _loadingRoadmap ? null : _showAddRoadmapSheet,
              icon: const Icon(Icons.add, size: 16, color: primaryColor),
              label: Text(
                'Add Roadmap',
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
        if (_loadingRoadmap)
          const LinearProgressIndicator(minHeight: 2, color: primaryColor),
        if (!_loadingRoadmap && _selectedRoadmaps.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorder),
            ),
            child: Center(
              child: Text(
                'No roadmap added yet. Tap "Add Roadmap" to select one.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kMuted),
              ),
            ),
          ),
        ..._selectedRoadmaps.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildRoadmapCard(entry),
          ),
        ),
        gap32px,
        Row(
          children: [
            Expanded(child: _fieldLabel('My Contribution to the Strategy')),
            TextButton.icon(
              onPressed:
                  _loadingPgsDeliverables ? null : _showAddContributionSheet,
              icon: const Icon(Icons.add, size: 14, color: primaryColor),
              label: Text(
                'Add',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        if (_loadingPgsDeliverables)
          const LinearProgressIndicator(minHeight: 2, color: primaryColor),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: kBorder),
          ),
          child:
              _selectedContributions.isEmpty
                  ? Text(
                    'No contribution added yet. Tap "Add" to select one.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: kMuted,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _selectedContributions.map((d) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.only(
                                    top: 6,
                                    right: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    d.deliverableName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: primaryTextColor,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                  onPressed: () => _removeContribution(d),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
        ),
      ],
    );
  }

  Widget _buildRoadmapCard(_RoadmapSelection entry) {
    // id -> text (fetched list muna, fallback sa saved name)
    final selectedDeliverables =
        entry.selectedDeliverableIds
            .map((id) => MapEntry(id, entry.deliverableText(id)))
            .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.roadmap.kraName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        entry.roadmap.strategicObjective,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: primaryTextColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    size: 16,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () => _removeRoadmap(entry),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Deliverables${_selectedYear != null ? ' ($_selectedYear)' : ''}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: kMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed:
                          entry.loadingDeliverables
                              ? null
                              : () => _showAddDeliverableSheet(entry),
                      icon: const Icon(
                        Icons.add,
                        size: 14,
                        color: primaryColor,
                      ),
                      label: Text(
                        'Add Deliverable',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (entry.loadingDeliverables)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: primaryColor,
                    ),
                  )
                else if (entry.error != null)
                  Text(
                    entry.error!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.redAccent,
                    ),
                  )
                else if (selectedDeliverables.isEmpty)
                  Text(
                    'No deliverables added yet. Tap "Add Deliverable" to select one.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: kMuted,
                    ),
                  )
                else
                  ...selectedDeliverables.map((d) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              d.value,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: primaryTextColor,
                                height: 1.45,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            onPressed: () => _removeDeliverable(entry, d.key),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addDeliverable(_RoadmapSelection entry, int deliverableId) {
    setState(() => entry.selectedDeliverableIds.add(deliverableId));
  }

  void _removeDeliverable(_RoadmapSelection entry, int deliverableId) {
    setState(() => entry.selectedDeliverableIds.remove(deliverableId));
  }

  Future<void> _showAddDeliverableSheet(_RoadmapSelection entry) async {
    final available =
        entry.deliverables
            .where(
              (d) =>
                  !entry.selectedDeliverableIds.contains(d.id) &&
                  d.deliverableDescription.trim().isNotEmpty,
            )
            .toList();

    if (available.isEmpty) {
      MotionToast.info(
        description: const Text('No more deliverables to add.'),
      ).show(context);
      return;
    }

    final picked = await showModalBottomSheet<IsatRoadmapDeliverables>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                            'Select Deliverable',
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
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: available.length,
                      separatorBuilder:
                          (_, __) => const Divider(height: 1, color: kBorder),
                      itemBuilder: (ctx, i) {
                        final d = available[i];
                        return InkWell(
                          onTap: () => Navigator.pop(ctx, d),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              d.deliverableDescription,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: primaryTextColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      _addDeliverable(entry, picked.id);
    }
  }

  Widget _buildCommitmentsTable(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionTitle('II. ANNUAL PERFORMANCE COMMITMENTS'),
            ),
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
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('III. EMPLOYEE COMMITMENT'),
        InkWell(
          onTap: () => setState(() => _employeeCommitted = !_employeeCommitted),
          borderRadius: BorderRadius.circular(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _employeeCommitted ? primaryColor : Colors.black,
                    width: _employeeCommitted ? 1.5 : 1,
                  ),
                  color: _employeeCommitted ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
                child:
                    _employeeCommitted
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I understand that the tasks listed above contribute to '
                  'the achievement of the CRMC Strategic Objectives and '
                  'commit to accomplishing them during the review period.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: primaryTextColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _signatureBlock({
    required String sectionLabel,
    required String nameLabel,
    required TextEditingController nameCtrl,
    required TextEditingController dateCtrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(sectionLabel),
        _inputField(nameCtrl, hint: nameLabel),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: kBorder,
          margin: const EdgeInsets.symmetric(vertical: 4),
        ),
        Text(
          'Signature',
          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: kMuted),
        ),
        const SizedBox(height: 8),
        _fieldLabel('Date'),
        _inputField(
          dateCtrl,
          hint: 'Pick a date',
          readOnly: true,
          onTap: () => _pickDate(dateCtrl).then((_) => setState(() {})),
        ),
      ],
    );
  }

  Widget _buildSignatories(bool isMobile) {
    final blocks = [
      _signatureBlock(
        sectionLabel: 'Prepared by (Employee)',
        nameLabel: 'Employee name',
        nameCtrl: _preparedByCtrl,
        dateCtrl: _preparedDateCtrl,
      ),
      _signatureBlock(
        sectionLabel: 'Reviewed by (Immediate Supervisor)',
        nameLabel: 'Supervisor name',
        nameCtrl: _reviewedByCtrl,
        dateCtrl: _reviewedDateCtrl,
      ),
      _signatureBlock(
        sectionLabel: 'Approved by (Department/Service Head)',
        nameLabel: 'Department/Service head name',
        nameCtrl: _approvedByCtrl,
        dateCtrl: _approvedDateCtrl,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('IV. SIGNATORIES'),
        isMobile
            ? Column(
              children:
                  blocks
                      .expand((b) => [b, const SizedBox(height: 16)])
                      .toList(),
            )
            : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    blocks
                        .expand(
                          (b) => [
                            Expanded(child: b),
                            const SizedBox(width: 16),
                          ],
                        )
                        .toList()
                      ..removeLast(),
              ),
            ),
      ],
    );
  }

  Widget _buildFooter(bool isMobile) {
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
          OutlinedButton(
            onPressed:
                _submitting
                    ? null
                    : () async {
                      final confirmed = await _showConfirmDialog(
                        title: 'Confirm Save',
                        message: 'Are you sure you want to save this as draft?',
                        confirmLabel: 'Save',
                        icon: Icons.save_outlined,
                      );
                      if (confirmed) _saveIsat(isSubmit: false);
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
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed:
                _submitting
                    ? null
                    : () async {
                      final confirmed = await _showConfirmDialog(
                        title: 'Confirm Submit',
                        message: 'Are you sure you want to submit this ISAT?',
                        confirmLabel: 'Submit',
                        icon: Icons.send_outlined,
                      );
                      if (confirmed) _saveIsat(isSubmit: true);
                    },
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
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
                    children: [
                      _buildGeneralInfo(isMobile),
                      _buildStrategicAlignment(),
                      _buildCommitmentsTable(isMobile),
                      _buildEmployeeCommitment(),
                      _buildSignatories(isMobile),
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
            child: Text('Key Task / Deliverable', style: headerStyle),
          ),
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(flex: 2, child: Text('Target/Measure', style: headerStyle)),
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(flex: 2, child: Text('Timeline', style: headerStyle)),
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(flex: 2, child: Text('Status', style: headerStyle)),
          SizedBox(width: isMobile ? 6 : 8),
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

  const _CommitmentRow({
    super.key,
    required this.index,
    required this.row,
    required this.isMobile,
    required this.canRemove,
    required this.onRemove,
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
            Expanded(
              flex: 3,
              child: _cell(row.keyTaskCtrl, 'Key task / deliverable…'),
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(flex: 2, child: _cell(row.targetCtrl, 'Target…')),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(flex: 2, child: _cell(row.timelineCtrl, 'Timeline…')),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(flex: 2, child: _cell(row.statusCtrl, 'Status…')),
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
