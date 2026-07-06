import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/auditor_team/models/auditor_team_member.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_validation_tool/models/performance_validation_tool.dart';
import 'package:imis/performance_validation_tool/models/pvt_conclusion.dart';
import 'package:imis/performance_validation_tool/models/pvt_deliverable_findings.dart';
import 'package:imis/performance_validation_tool/models/pvt_objectives.dart';
import 'package:imis/performance_validation_tool/models/pvt_validators.dart';
import 'package:imis/performance_validation_tool/performance_validation_tool_period/models/performance_validation_tool_period.dart';
import 'package:imis/performance_validation_tool/services/performance_validation_services.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:motion_toast/motion_toast.dart';

class PerformanceValidationDialog extends StatefulWidget {
  final PerformanceGovernanceSystem pgs;
  final PerformanceValidationTool? existing;
  const PerformanceValidationDialog({
    super.key,
    required this.pgs,
    this.existing,
  });

  @override
  State<PerformanceValidationDialog> createState() =>
      _PerformanceValidationDialogState();
}

class _PerformanceValidationDialogState
    extends State<PerformanceValidationDialog> {
  final _formKey = GlobalKey<FormState>();

  AuditorTeamDetail? _currentTeamDetail;
  bool _teamLoading = true;
  bool _membersLoading = false;
  String? _teamLoadError;

  List<PerformanceValidationToolPeriod> _periods = [];
  PerformanceValidationToolPeriod? _selectedPeriod;
  bool _periodsLoading = true;
  final List<PvtValidators> _existingValidators = [];

  List<PgsDeliverables> _deliverables = [];
  List<String> _deliverableNames = [];
  bool _deliverablesLoading = false;
  List<int?> _deliverableIds = [];
  String _headName = '';
  String? _headUserId;
  bool _headLoading = true;
  String userId = "";
  final _validationDateCtrl = TextEditingController();
  DateTime? _validationDate;

  final List<TextEditingController> _findingsCtrls = [];
  final List<bool> _ncFlags = [];
  final List<bool> _ofiFlags = [];

  final TextEditingController _commendationCtrl = TextEditingController();

  String? _conclusion;
  final List<String> _conclusionOptions = [
    'Fully Compliant',
    'Compliant with Minor Opportunities for Improvement',
    'Partially Compliant',
    'Requires Immediate Corrective Action',
  ];

  final List<String> _objectives = [
    'Assess compliance with the Performance Governance System (PGS)',
    'Verify implementation of approved strategic initiatives',
    'Monitor progress of deliverables',
    'Identify opportunities for improvement',
    'Validate submitted reports and supporting documents',
  ];
  late final List<bool> _objectiveChecked;
  final _preparedByCtrl = TextEditingController();
  final _preparedDateCtrl = TextEditingController();
  final _acknowledgedByCtrl = TextEditingController();
  final _acknowledgedDateCtrl = TextEditingController();
  final _approvedByCtrl = TextEditingController();
  final _approvedDateCtrl = TextEditingController();

  bool _submitting = false;

  final CommonService _commonService = CommonService(Dio());
  final _pvtSaveService = PerformanceValidationServices(Dio());

  @override
  void initState() {
    super.initState();
    _objectiveChecked = List.filled(_objectives.length, false);
    if (widget.existing == null) {
      _loadCurrentUserTeam();
    } else {
      _teamLoading = false;
    }
    _loadPeriods();
    _loadSignatory(widget.pgs.id);

    if (widget.existing != null) {
      _populateFromExisting(widget.existing!);
      _loadDeliverablesFromExisting(widget.existing!);
    } else {
      _loadDeliverables(widget.pgs.id);
    }
  }

  void _populateFromExisting(PerformanceValidationTool v) {
    _existingValidators
      ..clear()
      ..addAll(v.validators ?? []);

    _validationDate = v.validateDate;
    if (v.validateDate != null) {
      _validationDateCtrl.text =
          '${_monthName(v.validateDate!.month)} ${v.validateDate!.day}, ${v.validateDate!.year}';
    }
    _commendationCtrl.text = v.comment ?? '';

    final c = v.conclusion;
    if (c != null) {
      if (c.isCompliant == true) {
        _conclusion = 'Fully Compliant';
      } else if (c.isImprovement == true) {
        _conclusion = 'Compliant with Minor Opportunities for Improvement';
      } else if (c.isPartial == true) {
        _conclusion = 'Partially Compliant';
      } else if (c.isCritical == true) {
        _conclusion = 'Requires Immediate Corrective Action';
      }
    }

    if (v.objectives != null) {
      final o = v.objectives!;
      _objectiveChecked[0] = o.isAssessmentCompliant!;
      _objectiveChecked[1] = o.isImplementationVerified!;
      _objectiveChecked[2] = o.isDeliverableProgressMonitored!;
      _objectiveChecked[3] = o.hasOpportunitiesForImprovement!;
      _objectiveChecked[4] = o.isValidated!;
    }

    for (final sig in v.pvtSignatories ?? []) {
      switch (sig.label) {
        case 'Prepared by':
          _preparedByCtrl.text = sig.signatoryName ?? '';
          break;
        case 'Acknowledged by':
          _acknowledgedByCtrl.text = sig.signatoryName ?? '';
          break;
        case 'Approved by':
          _approvedByCtrl.text = sig.signatoryName ?? '';
          break;
      }
    }
  }

  Future<void> _loadCurrentUserTeam() async {
    setState(() {
      _teamLoading = true;
      _teamLoadError = null;
      _currentTeamDetail = null;
    });

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        if (mounted) {
          setState(
            () => _teamLoadError = 'Unable to determine the logged-in user.',
          );
        }
        return;
      }

      final userId = user.id ?? "";
      if (userId.isEmpty) {
        if (mounted) {
          setState(
            () => _teamLoadError = 'Unable to determine the logged-in user.',
          );
        }
        return;
      }

      final team = await _commonService.fetchTeamByUserId(userId);
      if (!mounted) return;

      await _loadTeamMembers(team.id);
    } catch (e) {
      debugPrint('Failed to resolve current user team: $e');
      if (mounted) {
        setState(
          () => _teamLoadError = 'No team found for the logged-in user.',
        );
      }
    } finally {
      if (mounted) setState(() => _teamLoading = false);
    }
  }

  Future<void> _loadTeamMembers(int teamId) async {
    setState(() => _membersLoading = true);
    try {
      final detail = await _commonService.fetchAuditorTeamByTeamId(teamId);
      if (mounted) setState(() => _currentTeamDetail = detail);
    } catch (e) {
      if (mounted) setState(() => _currentTeamDetail = null);
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadPeriods() async {
    setState(() => _periodsLoading = true);
    try {
      final periods = await _commonService.fetchValidationPeriod();
      if (mounted) {
        setState(() {
          _periods = periods;
          if (widget.existing != null) {
            _selectedPeriod = _periods.firstWhereOrNull(
              (p) => p.id == widget.existing!.performanceValidationToolPeriodId,
            );
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _periods = []);
    } finally {
      if (mounted) setState(() => _periodsLoading = false);
    }
  }

  Future<void> _loadDeliverables(int pgsId) async {
    setState(() {
      _deliverablesLoading = true;
      _deliverables = [];
      _deliverableNames = [];
      _deliverableIds = [];
    });
    try {
      final result = await _commonService.fetchValidationToolDeliverables(
        pgsId,
      );

      if (mounted) {
        setState(() {
          _deliverables = result;
          _deliverableNames = result.map((d) => d.deliverableName).toList();
          _deliverableIds = result.map((d) => d.id ?? 0).toList();
          _rebuildFindingsControllers(result.length);
        });
      }
    } catch (e, st) {
      debugPrint(st.toString());
      if (mounted) {
        setState(() {
          _deliverables = [];
          _deliverableNames = [];
          _deliverableIds = [];
          _rebuildFindingsControllers(0);
        });
      }
    } finally {
      if (mounted) setState(() => _deliverablesLoading = false);
    }
  }

  void _loadDeliverablesFromExisting(PerformanceValidationTool v) {
    final findings = v.deliverableFindings ?? [];

    setState(() {
      _deliverables = [];
      _deliverableNames = findings.map((f) => f.deliverableName ?? '').toList();
      _deliverableIds = findings.map((f) => f.pgsDeliverableId).toList();
      _rebuildFindingsControllers(findings.length);

      for (int i = 0; i < findings.length; i++) {
        _findingsCtrls[i].text = findings[i].findings ?? '';
        _ncFlags[i] = findings[i].isNC ?? false;
        _ofiFlags[i] = findings[i].isOFI ?? false;
      }

      _deliverablesLoading = false;
    });
  }

  Future<void> _loadSignatory(int pgsId) async {
    setState(() => _headLoading = true);
    try {
      final signatories = await _commonService.fetchPgsSignatories(pgsId);
      if (mounted && signatories.isNotEmpty) {
        final firstSignatory = signatories.first;
        setState(() {
          _headName = firstSignatory.signatoryName ?? '';
          _headUserId = firstSignatory.signatoryId;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _headName = '';
          _headUserId = null;
        });
      }
    } finally {
      if (mounted) setState(() => _headLoading = false);
    }
  }

  void _rebuildFindingsControllers(int deliverableCount) {
    for (final c in _findingsCtrls) {
      c.dispose();
    }

    _findingsCtrls.clear();
    _ncFlags.clear();
    _ofiFlags.clear();

    for (int i = 0; i < deliverableCount; i++) {
      _findingsCtrls.add(TextEditingController());
      _ncFlags.add(false);
      _ofiFlags.add(false);
    }
  }

  void _onPeriodSelected(PerformanceValidationToolPeriod period) {
    setState(() {
      _selectedPeriod = period;
      _validationDate = null;
      _validationDateCtrl.clear();
    });
  }

  Future<void> _pickValidationDate() async {
    if (_selectedPeriod == null) return;

    final firstDate = _selectedPeriod!.startDate;
    final lastDate = _selectedPeriod!.endDate;

    final picked = await showDatePicker(
      context: context,
      initialDate:
          _validationDate != null &&
                  !_validationDate!.isBefore(firstDate) &&
                  !_validationDate!.isAfter(lastDate)
              ? _validationDate!
              : firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
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

    if (picked != null && mounted) {
      setState(() {
        _validationDate = picked;
        _validationDateCtrl.text =
            '${_monthName(picked.month)} ${picked.day}, ${picked.year}';
      });
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

  Future<void> _saveValidation({required bool isSubmit}) async {
    if (!_formKey.currentState!.validate()) return;
    if (_conclusion == null) {
      MotionToast.error(
        description: const Text('Please select a Validation Conclusion.'),
      ).show(context);
      return;
    }
    if (_selectedPeriod == null) {
      MotionToast.error(
        description: const Text('Please select a Validation Period.'),
      ).show(context);
      return;
    }
    if (_validationDate == null) {
      MotionToast.error(
        description: const Text('Please select a Validation Date.'),
      ).show(context);
      return;
    }

    setState(() => _submitting = true);

    try {
      final postingDate = DateTime.now();
      final validators = <PvtValidators>[];
      if (_currentTeamDetail != null) {
        for (final auditor in _currentTeamDetail!.auditors) {
          validators.add(PvtValidators(0, false, 0, auditor.id, postingDate));
        }
      } else if (_existingValidators.isNotEmpty) {
        for (final v in _existingValidators) {
          validators.add(PvtValidators(0, false, 0, v.auditorId, postingDate));
        }
      }
      final objectives = PvtObjectives(
        0,
        0,
        isDeleted: false,
        isAssessmentCompliant: _objectiveChecked[0],
        isImplementationVerified: _objectiveChecked[1],
        isDeliverableProgressMonitored: _objectiveChecked[2],
        hasOpportunitiesForImprovement: _objectiveChecked[3],
        isValidated: _objectiveChecked[4],
        postingDate: postingDate,
      );

      final conclusion = PvtConclusion(
        0,
        0,
        postingDate,
        false,
        isCompliant: _conclusion == 'Fully Compliant',
        isImprovement:
            _conclusion == 'Compliant with Minor Opportunities for Improvement',
        isPartial: _conclusion == 'Partially Compliant',
        isCritical: _conclusion == 'Requires Immediate Corrective Action',
      );

      final deliverableFindings = <PvtDeliverableFindings>[];
      for (int i = 0; i < _deliverableIds.length; i++) {
        deliverableFindings.add(
          PvtDeliverableFindings(
            0,
            false,
            0,
            _deliverableIds[i]!,
            findings: _findingsCtrls[i].text.trim(),
            isNC: _ncFlags[i],
            isOFI: _ofiFlags[i],
            postingDate: postingDate,
          ),
        );
      }

      final pvt = PerformanceValidationTool(
        id: widget.existing?.id ?? 0,
        isDeleted: false,
        performanceValidationToolPeriodId: _selectedPeriod!.id,
        officeId: widget.pgs.office.id,
        officeHeadUserId: _headUserId,
        validateDate: _validationDate,
        comment: _commendationCtrl.text.trim(),
        postingDate: DateTime.now(),
        validators: validators,
        objectives: objectives,
        deliverableFindings: deliverableFindings,
        conclusion: conclusion,
        pvtSignatories: [],
        isDraft: !isSubmit,
        performanceGovernanceSystemId: widget.pgs.id,
      );

      final statusCode =
          isSubmit
              ? await _pvtSaveService.submit(pvt)
              : await _pvtSaveService.saveAsDraft(pvt);

      if (mounted) {
        setState(() => _submitting = false);
        if (statusCode == 200 || statusCode == 201) {
          MotionToast.success(
            description: Text(
              isSubmit ? 'Validation submitted.' : 'Validation saved as draft.',
            ),
          ).show(context);
          Navigator.pop(context, true);
        } else {
          MotionToast.error(
            description: Text(
              isSubmit
                  ? 'Failed to submit validation.'
                  : 'Failed to save validation.',
            ),
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
    _validationDateCtrl.dispose();
    for (final c in _findingsCtrls) {
      c.dispose();
    }
    _commendationCtrl.dispose();
    _preparedByCtrl.dispose();
    _preparedDateCtrl.dispose();
    _acknowledgedByCtrl.dispose();
    _acknowledgedDateCtrl.dispose();
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

  Widget _readOnlyBox(String value, {String fallback = '—'}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6FA),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: kBorder),
    ),
    child: Text(
      value.isNotEmpty ? value : fallback,
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: primaryTextColor),
    ),
  );

  Widget _buildGeneralInfo(bool isMobile) {
    final validatorNames =
        widget.existing != null
            ? _existingValidators
                .map((v) => _ValidatorDisplay(v.auditorName ?? ''))
                .toList()
            : (_currentTeamDetail?.auditors ?? [])
                .map((a) => _ValidatorDisplay(a.name))
                .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('I. GENERAL INFORMATION'),
        _fieldLabel('Validators'),
        widget.existing != null
            ? (validatorNames.isEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'No validators found for this record.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                : _ValidatorGrid(
                  key: ValueKey('existing-${widget.existing!.id}'),
                  validators: validatorNames,
                ))
            : _teamLoading
            ? const _MiniLoader()
            : _teamLoadError != null
            ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _teamLoadError!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )
            : _membersLoading
            ? const _MiniLoader()
            : (validatorNames.isEmpty
                ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'No validators found for this team.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _ValidatorGrid(
                    key: ValueKey(_currentTeamDetail!.id),
                    validators: validatorNames,
                  ),
                )),
        const SizedBox(height: 10),
        _fieldLabel('Validated Office/Department/Section/Unit/Committee'),
        _readOnlyBox(widget.pgs.office.name),
        const SizedBox(height: 10),
        _fieldLabel('Head of Validated Office/Unit'),
        _headLoading
            ? const _MiniLoader()
            : _readOnlyBox(_headName, fallback: 'No signatory found'),
        const SizedBox(height: 10),
        isMobile
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Validation Period Covered'),
                _buildPeriodDropdown(),
                const SizedBox(height: 10),
                _fieldLabel('Validation Date'),
                _buildDatePickerField(),
              ],
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Validation Period Covered'),
                      _buildPeriodDropdown(),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Validation Date'),
                      _buildDatePickerField(),
                    ],
                  ),
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    final permissionService = PermissionService();

    final hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceValidationTool,
    );
    if (_periodsLoading) return const _MiniLoader();

    return DropdownButtonFormField<PerformanceValidationToolPeriod>(
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
                (p) => DropdownMenuItem<PerformanceValidationToolPeriod>(
                  value: p,
                  child: Text(
                    (p.period != null && p.period!.isNotEmpty)
                        ? p.period!
                        : '${_monthName(p.startDate.month)} ${p.startDate.year} – '
                            '${_monthName(p.endDate.month)} ${p.endDate.year}',
                  ),
                ),
              )
              .toList(),
      onChanged:
          hasEditPermission
              ? (p) {
                if (p != null) _onPeriodSelected(p);
              }
              : null,
    );
  }

  // Widget _buildDatePickerField() {
  //   final permissionService = PermissionService();

  //   final hasEditPermission = permissionService.hasPermission(
  //     AppPermissions.editPerformanceValidationTool,
  //   );
  //   final disabled = _selectedPeriod == null;
  //   return TextFormField(
  //     controller: _validationDateCtrl,
  //     readOnly: true,
  //     onTap: disabled ? null : _pickValidationDate,
  //     style: GoogleFonts.plusJakartaSans(fontSize: 12),
  //     decoration: _inputDeco(
  //       hint: disabled ? 'Select period first…' : 'Pick a date',
  //     ).copyWith(
  //       fillColor: disabled ? const Color(0xFFF5F6FA) : Colors.white,
  //       suffixIcon: Icon(
  //         Icons.calendar_today_outlined,
  //         size: 16,
  //         color: disabled ? Colors.grey.shade400 : primaryColor,
  //       ),
  //     ),
  //     validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
  //   );
  // }
  Widget _buildDatePickerField() {
    final permissionService = PermissionService();

    final hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceValidationTool,
    );

    final disabled = _selectedPeriod == null || !hasEditPermission;

    return TextFormField(
      controller: _validationDateCtrl,
      readOnly: true,
      onTap: disabled ? null : _pickValidationDate,
      style: GoogleFonts.plusJakartaSans(fontSize: 12),
      decoration: _inputDeco(
        hint: _selectedPeriod == null ? 'Select period first…' : 'Pick a date',
      ).copyWith(
        fillColor: disabled ? const Color(0xFFF5F6FA) : Colors.white,
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: disabled ? Colors.grey.shade400 : primaryColor,
        ),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildValidationObjectives() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('II. VALIDATION OBJECTIVES'),
        Text(
          'The validation was conducted to:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 6),
        ...List.generate(
          _objectives.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap:
                  () => setState(
                    () => _objectiveChecked[i] = !_objectiveChecked[i],
                  ),
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
                        color:
                            _objectiveChecked[i] ? primaryColor : Colors.black,
                        width: _objectiveChecked[i] ? 1.5 : 1,
                      ),
                      color:
                          _objectiveChecked[i]
                              ? primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child:
                        _objectiveChecked[i]
                            ? const Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            )
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _objectives[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriteriaDocuments() {
    final items = [
      'PGS Framework',
      'Strategy Map',
      'Scorecard/KPIs',
      'Office Performance Commitment',
      'Approved Policies and Procedures',
      'Monthly Accomplishment Reports',
      'Relevant Documented Information (such as SPCR, IPCR, WFP, 5-Year Development Plan, RMR, SWOT, QOTP)',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('III. VALIDATION CRITERIA / REFERENCE DOCUMENTS'),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: primaryTextColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationFindings(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('IV. VALIDATION FINDINGS'),
        const SizedBox(height: 4),
        if (_deliverablesLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            ),
          )
        else if (_deliverableNames.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No deliverables found.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: kBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                _FindingsTableHeader(isMobile: isMobile),
                const Divider(height: 1, color: kBorder),
                ...List.generate(_deliverableNames.length, (i) {
                  return _FindingRow(
                    key: ValueKey(i),
                    index: i,
                    deliverableName: _deliverableNames[i],
                    kraName:
                        _deliverables.length > i
                            ? (_deliverables[i].kra?.name ?? '')
                            : '',
                    findingsCtrl:
                        _findingsCtrls.length > i
                            ? _findingsCtrls[i]
                            : TextEditingController(),
                    nc: _ncFlags.length > i ? _ncFlags[i] : false,
                    ofi: _ofiFlags.length > i ? _ofiFlags[i] : false,
                    isMobile: isMobile,
                    onNcChanged:
                        (v) => setState(() {
                          _ncFlags[i] = v ?? false;
                          if (v == true) _ofiFlags[i] = false;
                        }),
                    onOfiChanged:
                        (v) => setState(() {
                          _ofiFlags[i] = v ?? false;
                          if (v == true) _ncFlags[i] = false;
                        }),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCommendations() {
    final permissionService = PermissionService();

    final hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceValidationTool,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('V. COMMENDATIONS'),
        _inputField(
          readOnly: !hasEditPermission,
          _commendationCtrl,
          hint: 'Enter commendations here…',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildConclusion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('VI. VALIDATION CONCLUSION'),
        Text(
          'Based on the validation conducted, the validated office/unit is assessed as:',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        ..._conclusionOptions.map(
          (opt) => RadioListTile<String>(
            dense: true,
            activeColor: primaryColor,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: Text(opt, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
            value: opt,
            groupValue: _conclusion,
            onChanged: (v) => setState(() => _conclusion = v),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatories(bool isMobile) {
    Widget sigField(
      String label,
      TextEditingController nameCtrl,
      TextEditingController dateCtrl,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          _inputField(nameCtrl, hint: 'Full name'),
          const SizedBox(height: 4),
          _inputField(dateCtrl, hint: 'Date'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24, color: kBorder),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sigField(
                'Prepared by (Head of Validated Office)',
                _preparedByCtrl,
                _preparedDateCtrl,
              ),
              const SizedBox(height: 12),
              sigField(
                'Acknowledged by (Validation Team Leader)',
                _acknowledgedByCtrl,
                _acknowledgedDateCtrl,
              ),
              const SizedBox(height: 12),
              sigField(
                'Approved by (Team Leader, OSM – Performance Management and Analytics)',
                _approvedByCtrl,
                _approvedDateCtrl,
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: sigField(
                      'Prepared by (Head of Validated Office)',
                      _preparedByCtrl,
                      _preparedDateCtrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: sigField(
                      'Acknowledged by (Validation Team Leader)',
                      _acknowledgedByCtrl,
                      _acknowledgedDateCtrl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: sigField(
                      'Approved by (Team Leader, OSM – Performance Management and Analytics)',
                      _approvedByCtrl,
                      _approvedDateCtrl,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
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
                _submitting ? null : () => _saveValidation(isSubmit: false),
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
                _submitting ? null : () => _saveValidation(isSubmit: true),
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
                    Icons.fact_check_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance Validation Tool',
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
                      _buildValidationObjectives(),
                      _buildCriteriaDocuments(),
                      _buildValidationFindings(isMobile),
                      _buildCommendations(),
                      _buildConclusion(),
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

class _MiniLoader extends StatelessWidget {
  const _MiniLoader();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
    ),
  );
}

class _ValidatorDisplay {
  final String name;
  const _ValidatorDisplay(this.name);
}

class _ValidatorGrid extends StatelessWidget {
  final List<_ValidatorDisplay> validators;
  const _ValidatorGrid({super.key, required this.validators});

  @override
  Widget build(BuildContext context) {
    final half = (validators.length / 2).ceil();
    final leftList = validators.sublist(0, half);
    final rightList = validators.sublist(half);

    Widget memberTile(_ValidatorDisplay validator, int index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              validator.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    Widget column(List<_ValidatorDisplay> list, int startIndex) => Column(
      children: List.generate(list.length, (i) {
        final isLast = i == list.length - 1;
        return Column(
          children: [
            memberTile(list[i], startIndex + i),
            if (!isLast) const Divider(height: 1, color: kBorder),
          ],
        );
      }),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
        color: kSurface,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: column(leftList, 0)),
            if (rightList.isNotEmpty) ...[
              const VerticalDivider(width: 1, color: kBorder),
              Expanded(child: column(rightList, half)),
            ],
          ],
        ),
      ),
    );
  }
}

class _FindingsTableHeader extends StatelessWidget {
  final bool isMobile;
  const _FindingsTableHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService();

    permissionService.hasPermission(
      AppPermissions.editPerformanceValidationTool,
    );
    final headerStyle = GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: primaryColor,
    );
    return Container(
      color: kPrimaryLight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 6 : 8,
      ),
      child: Row(
        children: [
          SizedBox(
            width: isMobile ? 28 : 32,
            child: Text('No.', style: headerStyle),
          ),
          Expanded(flex: 3, child: Text('Deliverable', style: headerStyle)),
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(
            flex: isMobile ? 2 : 3,
            child: Text('Findings', style: headerStyle),
          ),
          SizedBox(width: isMobile ? 6 : 8),
          SizedBox(
            width: isMobile ? 36 : 44,
            child: Text('NC', textAlign: TextAlign.center, style: headerStyle),
          ),
          SizedBox(
            width: isMobile ? 36 : 44,
            child: Text('OFI', textAlign: TextAlign.center, style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class _FindingRow extends StatelessWidget {
  final int index;
  final String deliverableName;
  final String kraName;
  final TextEditingController findingsCtrl;
  final bool nc;
  final bool ofi;
  final bool isMobile;
  final ValueChanged<bool?> onNcChanged;
  final ValueChanged<bool?> onOfiChanged;

  const _FindingRow({
    super.key,
    required this.index,
    required this.deliverableName,
    required this.kraName,
    required this.findingsCtrl,
    required this.nc,
    required this.ofi,
    required this.isMobile,
    required this.onNcChanged,
    required this.onOfiChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isEven = index.isEven;
    final permissionService = PermissionService();

    final hasEditPermission = permissionService.hasPermission(
      AppPermissions.editPerformanceValidationTool,
    );
    Widget deliverableCell() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deliverableName,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

    Widget findingsCell() => TextFormField(
      readOnly: !hasEditPermission,
      controller: findingsCtrl,
      maxLines: 2,
      style: GoogleFonts.plusJakartaSans(fontSize: 11),
      decoration: InputDecoration(
        hintText: 'Findings…',
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
      ),
    );

    Widget checkbox(bool value, ValueChanged<bool?> onChanged) => Checkbox(
      value: value,
      activeColor: primaryColor,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (v) {
        if (!hasEditPermission) return;
        onChanged(v);
      },
    );

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
              width: isMobile ? 28 : 32,
              child: Text(
                '${index + 1}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
            Expanded(flex: 3, child: deliverableCell()),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(flex: isMobile ? 2 : 3, child: findingsCell()),
            SizedBox(width: isMobile ? 6 : 8),
            SizedBox(
              width: isMobile ? 36 : 44,
              child: Center(child: checkbox(nc, onNcChanged)),
            ),
            SizedBox(
              width: isMobile ? 36 : 44,
              child: Center(child: checkbox(ofi, onOfiChanged)),
            ),
          ],
        ),
      ),
    );
  }
}
