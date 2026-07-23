import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/strategy_review_report/models/strategy_review_deliverable.dart';
import 'package:imis/strategy_review_report/models/strategy_review_kpi.dart';
import 'package:imis/strategy_review_report/models/strategy_review_report.dart';
import 'package:imis/strategy_review_report/services/strategy_review_report_services.dart';
import 'package:imis/strategy_review_report/strategy_review_period/models/strategy_review_period.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class StrategyReviewReportFormData {
  String objective = '';
  String contributingUnits = '';

  List<StrategyReviewMeasureRow> measures = [];
  List<StrategyReviewKraDeliverableRow> kraDeliverables = [];

  String continueText = '';
  String stopText = '';
  String startText = '';
}

class StrategyReviewMeasureRow {
  final String measure;
  final String targetYear;
  String actualToDate = '';
  String status = '';

  StrategyReviewMeasureRow({required this.measure, required this.targetYear});
}

class StrategyReviewKraDeliverableRow {
  final String keyResultArea;
  final String deliverable;
  String actualToDate = '';
  String status = '';

  StrategyReviewKraDeliverableRow({
    required this.keyResultArea,
    required this.deliverable,
  });
}

Future<StrategyReviewReportFormData?> showStrategyReviewReportDialog(
  BuildContext context, {
  required int kraRoadMapId,
  required int year,
  required String kraName,
  required String strategicObjectives,
  StrategyReviewReport? existingReview,
}) {
  return showDialog<StrategyReviewReportFormData>(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => StrategyReviewReportDialog(
          kraRoadMapId: kraRoadMapId,
          year: year,
          kraName: kraName,
          strategicObjectives: strategicObjectives,
          existingReview: existingReview,
        ),
  );
}

class StrategyReviewReportDialog extends StatefulWidget {
  final int kraRoadMapId;
  final int year;
  final String kraName;
  final String strategicObjectives;
  final StrategyReviewReport? existingReview;
  const StrategyReviewReportDialog({
    super.key,
    required this.kraRoadMapId,
    required this.year,
    required this.kraName,
    required this.strategicObjectives,
    this.existingReview,
  });

  @override
  State<StrategyReviewReportDialog> createState() =>
      StrategyReviewReportDialogState();
}

class StrategyReviewReportDialogState
    extends State<StrategyReviewReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = StrategyReviewReportServices(Dio());
  final _commonService = CommonService(Dio());
  final _contributingUnitsCtrl = TextEditingController();
  final _continueCtrl = TextEditingController();
  final _stopCtrl = TextEditingController();
  final _startCtrl = TextEditingController();

  List<TextEditingController> _measureActualCtrls = [];
  List<PgsStatus> _measureStatuses = [];

  List<TextEditingController> _kraActualCtrls = [];
  List<PgsStatus> _kraStatuses = [];

  List<StrategyReviewKpi> _kpiItems = [];
  List<StrategyReviewDeliverable> _deliverableItems = [];

  List<StrategyReviewPeriod> _periods = [];
  StrategyReviewPeriod? _selectedPeriod;
  String roleId = "";
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSaving = false;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadCurrentRoleId();
  }

  Future<void> _loadCurrentRoleId() async {
    await AuthUtil.processTokenValidity(dio, context);
    final roles = await AuthUtil.fetchRoles();
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {}
      }
      if (mounted) setState(() => roleId = currentRole.id);
    }
  }

  Future<void> _fetchData() async {
    try {
      final existing = widget.existingReview;
      if (existing != null) {
        final periods = await _commonService.fetchSrategyPeriod();

        if (!mounted) return;
        setState(() {
          _periods = periods;

          if (existing.strategyReviewPeriodId != null) {
            _selectedPeriod = periods.firstWhere(
              (p) => p.id == existing.strategyReviewPeriodId,
              orElse: () => periods.isNotEmpty ? periods.first : periods.first,
            );
          } else if (periods.isNotEmpty) {
            _selectedPeriod = periods.first;
          }

          _contributingUnitsCtrl.text = existing.officeNames ?? '';
          _continueCtrl.text = existing.continueText ?? '';
          _stopCtrl.text = existing.stop ?? '';
          _startCtrl.text = existing.start ?? '';

          // Build measure/target directly from the saved flat fields
          _kpiItems =
              existing.strategyReviewDeliverableKpi
                  ?.map(
                    (k) => StrategyReviewKpi(
                      k.kpiId,
                      kpiDescription: k.measure,
                      target: k.target,
                    ),
                  )
                  .toList() ??
              [];

          // Build keyResultArea/deliverable directly from the saved flat fields
          _deliverableItems =
              existing.strategyReviewDeliverable
                  ?.map(
                    (d) => StrategyReviewDeliverable(
                      d.kraRoadmapid,
                      kraDescription: d.keyResultArea,
                      deliverableDescription: d.deliverable,
                    ),
                  )
                  .toList() ??
              [];

          _measureActualCtrls = List.generate(
            _kpiItems.length,
            (_) => TextEditingController(),
          );
          _measureStatuses = List.generate(
            _kpiItems.length,
            (_) => PgsStatus.notStarted,
          );
          _kraActualCtrls = List.generate(
            _deliverableItems.length,
            (_) => TextEditingController(),
          );
          _kraStatuses = List.generate(
            _deliverableItems.length,
            (_) => PgsStatus.notStarted,
          );

          for (int i = 0; i < _kpiItems.length; i++) {
            final match = existing.strategyReviewDeliverableKpi?.firstWhere(
              (k) => k.kpiId == _kpiItems[i].id,
              orElse: () => StrategyReviewDeliverableKpiRequest.empty(),
            );
            if (match != null) {
              _measureActualCtrls[i].text = match.actualDate ?? '';
              _measureStatuses[i] = PgsStatus.values[match.status];
            }
          }

          for (int i = 0; i < _deliverableItems.length; i++) {
            final match = existing.strategyReviewDeliverable?.firstWhere(
              (d) => d.kraRoadmapid == _deliverableItems[i].id,
              orElse: () => StrategyReviewDeliverableRequest.empty(),
            );
            if (match != null) {
              _kraActualCtrls[i].text = match.actualDate ?? '';
              _kraStatuses[i] = PgsStatus.values[match.status];
            }
          }

          _isLoading = false;
        });
        return;
      }

      final results = await Future.wait([
        _commonService.fetchSrategyPeriod(),
        _service.getStrategyReviewDeliverables(
          widget.kraRoadMapId,
          widget.year,
        ),
        _service.getStrategyReviewKpis(widget.kraRoadMapId, widget.year),
      ]);

      final periods = results[0] as List<StrategyReviewPeriod>;
      final deliverablesResponse = results[1] as StrategyReviewDeliverableItem?;
      final kpisResponse = results[2] as StrategyReviewKpiItem?;

      if (!mounted) return;

      setState(() {
        _periods = periods;
        _selectedPeriod = periods.isNotEmpty ? periods.first : null;

        _deliverableItems = deliverablesResponse?.deliverables ?? [];
        _kpiItems = kpisResponse?.kpiDeliverable ?? [];

        _kraActualCtrls = List.generate(
          _deliverableItems.length,
          (_) => TextEditingController(),
        );
        _kraStatuses = List.generate(
          _deliverableItems.length,
          (_) => PgsStatus.notStarted,
        );
        _measureActualCtrls = List.generate(
          _kpiItems.length,
          (_) => TextEditingController(),
        );
        _measureStatuses = List.generate(
          _kpiItems.length,
          (_) => PgsStatus.notStarted,
        );

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load data. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _contributingUnitsCtrl.dispose();
    _continueCtrl.dispose();
    _stopCtrl.dispose();
    _startCtrl.dispose();
    for (final c in _measureActualCtrls) {
      c.dispose();
    }
    for (final c in _kraActualCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   final request = StrategyReviewSaveRequest(
  //     id: widget.existingReview?.id ?? 0,
  //     isDeleted: false,
  //     rowVersion: widget.existingReview?.rowVersion,
  //     postingDate: DateTime.now().toUtc().toIso8601String(),
  //     kraRoadMapId: widget.kraRoadMapId,
  //     strategyReviewPeriodId: _selectedPeriod?.id.toString(),
  //     strategicObjective: _strategicObjective,
  //     officeNames: _contributingUnitsCtrl.text.trim(),
  //     strategyReviewDeliverableKpi: List.generate(_kpiItems.length, (i) {
  //       final existing = widget.existingReview?.strategyReviewDeliverableKpi
  //           ?.firstWhere(
  //             (k) => k.kpiId == _kpiItems[i].id,
  //             orElse: () => StrategyReviewDeliverableKpiRequest.empty(),
  //           );
  //       return StrategyReviewDeliverableKpiRequest(
  //         id: existing?.kpiId != 0 ? existing?.id ?? 0 : 0,
  //         strategyReviewId: widget.existingReview?.id ?? 0,
  //         isDeleted: false,
  //         rowVersion: existing?.rowVersion,
  //         kpiId: _kpiItems[i].id,
  //         actualDate: _measureActualCtrls[i].text.trim(),
  //         status: _measureStatuses[i].index,
  //       );
  //     }),
  //     strategyReviewDeliverable: List.generate(_deliverableItems.length, (i) {
  //       final existing = widget.existingReview?.strategyReviewDeliverable
  //           ?.firstWhere(
  //             (d) => d.kraRoadmapid == _deliverableItems[i].id,
  //             orElse: () => StrategyReviewDeliverableRequest.empty(),
  //           );
  //       return StrategyReviewDeliverableRequest(
  //         id: existing?.kraRoadmapid != 0 ? existing?.id ?? 0 : 0,
  //         isDeleted: false,
  //         rowVersion: existing?.rowVersion,
  //         strategyReviewId: widget.existingReview?.id ?? 0,
  //         kraRoadmapid: _deliverableItems[i].id,
  //         actualDate: _kraActualCtrls[i].text.trim(),
  //         status: _kraStatuses[i].index,
  //       );
  //     }),
  //     continueText: _continueCtrl.text.trim(),
  //     stop: _stopCtrl.text.trim(),
  //     start: _startCtrl.text.trim(),
  //     roleId: roleId,
  //   );

  //   setState(() => _isSaving = true);
  //   try {
  //     if (widget.existingReview != null) {
  //       await _service.updateStrategyReview(request);
  //     } else {
  //       await _service.saveStrategyReview(request);
  //     }

  //     if (!mounted) return;
  //     MotionToast.success(
  //       toastAlignment: Alignment.topCenter,
  //       description: Text(
  //         widget.existingReview != null
  //             ? 'Strategy review updated successfully'
  //             : 'Strategy review saved successfully',
  //       ),
  //     ).show(context);
  //     await Future.delayed(const Duration(milliseconds: 800));
  //     if (!mounted) return;
  //     Navigator.of(context).pop();
  //   } catch (e) {
  //     debugPrint('Submit error: $e');
  //     if (!mounted) return;
  //     setState(() => _isSaving = false);
  //     MotionToast.error(
  //       toastAlignment: Alignment.topCenter,
  //       description: const Text('Failed to save. Please try again.'),
  //     ).show(context);
  //   }
  // }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = StrategyReviewSaveRequest(
      id: widget.existingReview?.id ?? 0,
      isDeleted: false,
      rowVersion: widget.existingReview?.rowVersion,
      postingDate: DateTime.now().toUtc().toIso8601String(),
      kraRoadMapId: widget.kraRoadMapId,
      strategyReviewPeriodId: _selectedPeriod?.id.toString(),
      strategicObjective: _strategicObjective,
      officeNames: _contributingUnitsCtrl.text.trim(),
      strategyReviewDeliverableKpi: List.generate(_kpiItems.length, (i) {
        final existing = widget.existingReview?.strategyReviewDeliverableKpi
            ?.firstWhere(
              (k) => k.kpiId == _kpiItems[i].id,
              orElse: () => StrategyReviewDeliverableKpiRequest.empty(),
            );
        return StrategyReviewDeliverableKpiRequest(
          id: existing?.kpiId != 0 ? existing?.id ?? 0 : 0,
          strategyReviewId: widget.existingReview?.id ?? 0,
          isDeleted: false,
          rowVersion: existing?.rowVersion,
          kpiId: _kpiItems[i].id,
          actualDate: _measureActualCtrls[i].text.trim(),
          status: _measureStatuses[i].index,
          measure: _kpiItems[i].kpiDescription,
          target: _kpiItems[i].target,
        );
      }),
      strategyReviewDeliverable: List.generate(_deliverableItems.length, (i) {
        final existing = widget.existingReview?.strategyReviewDeliverable
            ?.firstWhere(
              (d) => d.kraRoadmapid == _deliverableItems[i].id,
              orElse: () => StrategyReviewDeliverableRequest.empty(),
            );
        return StrategyReviewDeliverableRequest(
          id: existing?.kraRoadmapid != 0 ? existing?.id ?? 0 : 0,
          isDeleted: false,
          rowVersion: existing?.rowVersion,
          strategyReviewId: widget.existingReview?.id ?? 0,
          kraRoadmapid: _deliverableItems[i].id,
          actualDate: _kraActualCtrls[i].text.trim(),
          status: _kraStatuses[i].index,
          keyResultArea: _deliverableItems[i].kraDescription,
          deliverable: _deliverableItems[i].deliverableDescription,
        );
      }),
      continueText: _continueCtrl.text.trim(),
      stop: _stopCtrl.text.trim(),
      start: _startCtrl.text.trim(),
      roleId: roleId,
    );

    setState(() => _isSaving = true);
    try {
      if (widget.existingReview != null) {
        await _service.updateStrategyReview(request);
      } else {
        await _service.saveStrategyReview(request);
      }

      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(
          widget.existingReview != null
              ? 'Strategy review updated successfully'
              : 'Strategy review saved successfully',
        ),
      ).show(context);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Submit error: $e');
      if (!mounted) return;
      setState(() => _isSaving = false);
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: const Text('Failed to save. Please try again.'),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final dialogWidth =
        isMobile ? width * 0.95 : (width * 0.85).clamp(0.0, 900.0).toDouble();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogHeader(),
            Flexible(
              child:
                  _isLoading
                      ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : _errorMessage != null
                      ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = null;
                                });
                                _fetchData();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              _buildPeriodDropdown(),
                              const SizedBox(height: 16),
                              _buildSection1(isMobile),
                              const SizedBox(height: 16),
                              _buildSection2(isMobile),
                              const SizedBox(height: 16),
                              _buildSection3(isMobile),
                              const SizedBox(height: 16),
                              _buildSection4(isMobile),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildActions(widget.existingReview?.id.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.add_chart, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Strategy Review Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.kraName,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Quarter'),
        const SizedBox(height: 8),
        DropdownButtonFormField<StrategyReviewPeriod>(
          value: _selectedPeriod,
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          items:
              _periods.map((p) {
                return DropdownMenuItem<StrategyReviewPeriod>(
                  value: p,
                  child: Text(
                    p.quarter ?? '—',
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
          onChanged: (val) => setState(() => _selectedPeriod = val),
          validator: (val) => val == null ? 'Please select a quarter' : null,
        ),
      ],
    );
  }

  Widget _sectionHeader(List<String> labels, List<int> flexes) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              flex: flexes[i],
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String get _strategicObjective =>
      widget.existingReview?.strategicObjective?.isNotEmpty == true
          ? widget.existingReview!.strategicObjective!
          : widget.strategicObjectives;

  Widget _buildSection1(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Objective & Contributing Units'),
        const SizedBox(height: 8),
        isMobile
            ? Column(
              children: [
                _readOnlyField('Objective', _strategicObjective),
                const SizedBox(height: 10),
                _readOnlyField(
                  'Contributing Units',
                  _contributingUnitsCtrl.text,
                ),
              ],
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _readOnlyField('Objective', _strategicObjective),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _readOnlyField(
                    'Contributing Units',
                    _contributingUnitsCtrl.text,
                  ),
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildSection2(bool isMobile) {
    if (_kpiItems.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Measures'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'No KPI measures found for this roadmap.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Measures'),
        const SizedBox(height: 8),
        if (!isMobile) ...[
          _sectionHeader(
            ['Measure', 'Target (Year)', 'Actual to Date', 'Status'],
            [3, 2, 2, 2],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(6),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _kpiItems.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                  _measureRowDesktop(i),
                ],
              ],
            ),
          ),
        ] else
          Column(
            children: [
              for (int i = 0; i < _kpiItems.length; i++) _measureRowMobile(i),
            ],
          ),
      ],
    );
  }

  Widget _measureRowDesktop(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _readOnlyCompact(_kpiItems[i].kpiDescription ?? '—'),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _readOnlyCompact(
              _kpiItems[i].target?.isEmpty ?? true ? '—' : _kpiItems[i].target!,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _compactField(_measureActualCtrls[i], 'e.g. 75%'),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _inlineStatusDropdown(
              value: _measureStatuses[i],
              onChanged: (val) {
                if (val != null) setState(() => _measureStatuses[i] = val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _measureRowMobile(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Row ${i + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _readOnlyCompact(_kpiItems[i].kpiDescription ?? '—'),
          const SizedBox(height: 8),
          _readOnlyCompact(
            _kpiItems[i].target?.isEmpty ?? true ? '—' : _kpiItems[i].target!,
          ),
          const SizedBox(height: 8),
          _labeledField('Actual to Date', _measureActualCtrls[i]),
          const SizedBox(height: 8),
          _labeledStatusDropdown(
            label: 'Status',
            value: _measureStatuses[i],
            onChanged: (val) {
              if (val != null) setState(() => _measureStatuses[i] = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection3(bool isMobile) {
    if (_deliverableItems.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Key Result Area & Deliverables'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'No deliverables found for this roadmap.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Key Result Area & Deliverables'),
        const SizedBox(height: 8),
        if (!isMobile) ...[
          _sectionHeader(
            ['Key Result Area', 'Deliverable', 'Actual to Date', 'Status'],
            [3, 3, 2, 2],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(6),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _deliverableItems.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                  _kraRowDesktop(i),
                ],
              ],
            ),
          ),
        ] else
          Column(
            children: [
              for (int i = 0; i < _deliverableItems.length; i++)
                _kraRowMobile(i),
            ],
          ),
      ],
    );
  }

  Widget _kraRowDesktop(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _readOnlyCompact(_deliverableItems[i].kraDescription ?? '—'),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _readOnlyCompact(
              _deliverableItems[i].deliverableDescription ?? '—',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _compactField(_kraActualCtrls[i], 'Actual to Date'),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _inlineStatusDropdown(
              value: _kraStatuses[i],
              onChanged: (val) {
                if (val != null) setState(() => _kraStatuses[i] = val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _kraRowMobile(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Row ${i + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _readOnlyCompact(_deliverableItems[i].kraDescription ?? '—'),
          const SizedBox(height: 8),
          _readOnlyCompact(_deliverableItems[i].deliverableDescription ?? '—'),
          const SizedBox(height: 8),
          _labeledField('Actual to Date', _kraActualCtrls[i]),
          const SizedBox(height: 8),
          _labeledStatusDropdown(
            label: 'Status',
            value: _kraStatuses[i],
            onChanged: (val) {
              if (val != null) setState(() => _kraStatuses[i] = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection4(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Action Plan'),
        const SizedBox(height: 8),
        if (!isMobile) _sectionHeader(['Continue', 'Stop', 'Start'], [1, 1, 1]),
        isMobile
            ? Column(
              children: [
                _labeledField('Continue', _continueCtrl, maxLines: 3),
                const SizedBox(height: 10),
                _labeledField('Stop', _stopCtrl, maxLines: 3),
                const SizedBox(height: 10),
                _labeledField('Start', _startCtrl, maxLines: 3),
              ],
            )
            : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(6),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _compactField(
                      _continueCtrl,
                      'Enter continue actions...',
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactField(
                      _stopCtrl,
                      'Enter stop actions...',
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactField(
                      _startCtrl,
                      'Enter start actions...',
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildActions(String? id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () async {
            final byteData = await rootBundle.load(
              'assets/strategy-review-guide.pdf',
            );
            final bytes = byteData.buffer.asUint8List();
            if (kIsWeb) {
              final blob = html.Blob([bytes], 'application/pdf');
              final url = html.Url.createObjectUrlFromBlob(blob);
              html.window.open(url, '_blank');
              Future.delayed(const Duration(seconds: 15), () {
                html.Url.revokeObjectUrl(url);
              });
            } else {
              final tempDir = await getTemporaryDirectory();
              final file = File('${tempDir.path}/strategy-review-guide.pdf');
              await file.writeAsBytes(bytes);
              await OpenFile.open(file.path);
            }
          },
          icon: const Icon(
            Icons.menu_book_outlined,
            size: 16,
            color: primaryColor,
          ),
          label: Text(
            'View Guide',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: primaryTextColor)),
        ),

        const SizedBox(width: 12),
        PermissionWidget(
          permission: AppPermissions.addStrategyReview,
          child: ElevatedButton(
            onPressed:
                _isSaving
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        bool? confirmAction = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  width: 380,
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: kSurface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 32,
                                        offset: Offset(0, 12),
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
                                          color: kPrimaryBg,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.save_outlined,
                                          color: primaryColor,
                                          size: 28,
                                        ),
                                      ),
                                      gap16px,
                                      Text(
                                        id == null
                                            ? "Confirm Save"
                                            : "Confirm Update",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: kText,
                                        ),
                                      ),
                                      gap8px,
                                      Text(
                                        id == null
                                            ? "Are you sure you want to save this record?"
                                            : "Are you sure you want to update this record?",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: kMuted,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      gap24px,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, false),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: kBorder,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: kMuted,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed:
                                                  () =>
                                                      Navigator.pop(ctx, true),
                                              label: Text(
                                                'Save',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                elevation: 0,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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

                        if (confirmAction == true) {
                          await _submit();
                        }
                      }
                    },

            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            child:
                _isSaving
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      id == null ? 'Save' : 'Update',
                      style: const TextStyle(color: Colors.white),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value.isEmpty ? '—' : value,
            style: TextStyle(
              fontSize: 13,
              color: value.isEmpty ? Colors.grey.shade400 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _readOnlyCompact(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        value.isEmpty ? '—' : value,
        style: TextStyle(
          fontSize: 13,
          color: value.isEmpty ? Colors.grey.shade400 : Colors.black87,
        ),
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _compactField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _inlineStatusDropdown({
    required PgsStatus value,
    required ValueChanged<PgsStatus?> onChanged,
  }) {
    return DropdownButtonFormField<PgsStatus>(
      value: value,
      isDense: true,
      isExpanded: true,
      style: const TextStyle(fontSize: 12, color: Colors.black87),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      items:
          PgsStatus.values.map((status) {
            return DropdownMenuItem<PgsStatus>(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor(status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      statusLabel(status),
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _labeledStatusDropdown({
    required String label,
    required PgsStatus value,
    required ValueChanged<PgsStatus?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        _inlineStatusDropdown(value: value, onChanged: onChanged),
      ],
    );
  }
}
