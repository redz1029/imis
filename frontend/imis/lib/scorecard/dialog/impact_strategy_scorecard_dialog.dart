import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/scorecard/models/impact_strategic_goal_scorecard.dart';
import 'package:imis/scorecard/services/impact_strategy_scorecard_services.dart';
import 'package:motion_toast/motion_toast.dart';

class ScorecardMeasure {
  ScorecardMeasure({
    this.id = 0,
    this.rowVersion,
    String description = '',
    String baseline = '',
    List<String>? targets,
    // ids of each target, aligned by index to [targets]. index 0 = baseline,
    // 1..n = yearControllers[0..n-1]. Pass these when loading EXISTING data
    // so updates edit the same rows instead of inserting new ones.
    List<int>? targetIds,
    // rowVersion of each target, aligned the same way as targetIds.
    List<String?>? targetRowVersions,
    int yearCount = 5,
  }) : descController = TextEditingController(text: description),
       baselineController = TextEditingController(text: baseline),
       baselineTargetId =
           targetIds != null && targetIds.isNotEmpty ? targetIds[0] : 0,
       baselineTargetRowVersion =
           targetRowVersions != null && targetRowVersions.isNotEmpty
               ? targetRowVersions[0]
               : null,
       yearTargetIds = List.generate(
         yearCount,
         (i) =>
             targetIds != null && targetIds.length > i + 1
                 ? targetIds[i + 1]
                 : 0,
       ),
       yearTargetRowVersions = List.generate(
         yearCount,
         (i) =>
             targetRowVersions != null && targetRowVersions.length > i + 1
                 ? targetRowVersions[i + 1]
                 : null,
       ),
       yearControllers = List.generate(
         yearCount,
         (i) => TextEditingController(
           text: targets != null && targets.length > i ? targets[i] : '',
         ),
       );

  /// id of this measure/indicator itself. 0 = new (not yet saved).
  final int id;

  /// concurrency token for this measure/indicator. null for new rows.
  final String? rowVersion;

  final TextEditingController descController;
  final TextEditingController baselineController;
  final List<TextEditingController> yearControllers;

  /// id of the baseline target row (0 = new).
  final int baselineTargetId;
  final String? baselineTargetRowVersion;

  /// ids of each year target row, aligned to [yearControllers] (0 = new).
  final List<int> yearTargetIds;
  final List<String?> yearTargetRowVersions;

  List<ImpactScoreCardTarget> _impactTargets(
    List<String> years,
    String baselineYear,
  ) {
    return [
      ImpactScoreCardTarget(
        baselineTargetId,
        int.tryParse(baselineYear) ?? 0,
        baselineController.text.trim(),
        id,
        rowVersion: baselineTargetRowVersion,
      ),
      for (int i = 0; i < yearControllers.length && i < years.length; i++)
        ImpactScoreCardTarget(
          yearTargetIds[i],
          int.tryParse(years[i]) ?? 0,
          yearControllers[i].text.trim(),
          id,
          rowVersion: yearTargetRowVersions[i],
        ),
    ];
  }

  List<ImpactStrategicScoreCardTarget> _strategicTargets(
    List<String> years,
    String baselineYear,
  ) {
    return [
      ImpactStrategicScoreCardTarget(
        baselineTargetId,
        int.tryParse(baselineYear) ?? 0,
        baselineController.text.trim(),
        id,
        rowVersion: baselineTargetRowVersion,
      ),
      for (int i = 0; i < yearControllers.length && i < years.length; i++)
        ImpactStrategicScoreCardTarget(
          yearTargetIds[i],
          int.tryParse(years[i]) ?? 0,
          yearControllers[i].text.trim(),
          id,
          rowVersion: yearTargetRowVersions[i],
        ),
    ];
  }

  ImpactScoreCardIndicator toImpactIndicator(
    List<String> years,
    String baselineYear, {
    required int impactScoreCardId,
  }) {
    return ImpactScoreCardIndicator(
      id,
      descController.text.trim(),
      impactScoreCardId,
      _impactTargets(years, baselineYear),
      rowVersion: rowVersion,
    );
  }

  ImpactStrategicScoreCardMeasure toStrategicMeasure(
    List<String> years,
    String baselineYear, {
    required int impactStrategicScoreCardId,
  }) {
    return ImpactStrategicScoreCardMeasure(
      id,
      descController.text.trim(),
      impactStrategicScoreCardId,
      _strategicTargets(years, baselineYear),
      rowVersion: rowVersion,
    );
  }

  void dispose() {
    descController.dispose();
    baselineController.dispose();
    for (final c in yearControllers) {
      c.dispose();
    }
  }
}

class ScorecardGroup {
  ScorecardGroup({
    this.id = 0,
    this.rowVersion,
    String label = '',
    List<ScorecardMeasure>? measures,
    int yearCount = 5,
  }) : labelController = TextEditingController(text: label),
       measures = measures ?? [ScorecardMeasure(yearCount: yearCount)];

  /// id of this group (ImpactScoreCard / ImpactStrategicScoreCard). 0 = new.
  final int id;

  /// concurrency token for this group. null for new rows.
  final String? rowVersion;

  final TextEditingController labelController;
  final List<ScorecardMeasure> measures;

  ImpactScoreCard toImpactScoreCard(
    List<String> years,
    String baselineYear, {
    required int scorecardId,
  }) {
    return ImpactScoreCard(
      id,
      labelController.text.trim(),
      scorecardId,
      measures
          .map(
            (m) =>
                m.toImpactIndicator(years, baselineYear, impactScoreCardId: id),
          )
          .toList(),
      rowVersion: rowVersion,
    );
  }

  ImpactStrategicScoreCard toImpactStrategicScoreCard(
    List<String> years,
    String baselineYear, {
    required int scorecardId,
  }) {
    return ImpactStrategicScoreCard(
      id,
      labelController.text.trim(),
      scorecardId,
      measures
          .map(
            (m) => m.toStrategicMeasure(
              years,
              baselineYear,
              impactStrategicScoreCardId: id,
            ),
          )
          .toList(),
      rowVersion: rowVersion,
    );
  }

  void dispose() {
    labelController.dispose();
    for (final m in measures) {
      m.dispose();
    }
  }
}

Future<void> showImpactStrategyScorecardDialog(
  BuildContext context, {
  required int periodId,
  required List<String> targetYears,
  required String baselineYear,
  int? scorecardId,
  String? scorecardRowVersion,
  List<ScorecardGroup>? initialImpactGroups,
  List<ScorecardGroup>? initialStrategicGroups,
  VoidCallback? onSaved,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => ImpactStrategyScorecardDialog(
          periodId: periodId,
          targetYears: targetYears,
          baselineYear: baselineYear,
          scorecardId: scorecardId,
          scorecardRowVersion: scorecardRowVersion,
          initialImpactGroups: initialImpactGroups,
          initialStrategicGroups: initialStrategicGroups,
          onSaved: onSaved,
        ),
  );
}

class ImpactStrategyScorecardDialog extends StatefulWidget {
  const ImpactStrategyScorecardDialog({
    super.key,
    required this.periodId,
    required this.targetYears,
    required this.baselineYear,
    this.scorecardId,
    this.scorecardRowVersion,
    this.initialImpactGroups,
    this.initialStrategicGroups,
    this.onSaved,
  });

  final int periodId;
  final List<String> targetYears;
  final String baselineYear;

  /// Pass the existing scorecard's id when opening this dialog to EDIT an
  /// already-saved scorecard. Leave null (or 0) when creating a brand new
  /// one. This is what tells the service whether to PUT (update) or POST
  /// (create) — without it, every save creates a new duplicate entry.
  final int? scorecardId;

  /// concurrency token for the root scorecard. Pass this together with
  /// [scorecardId] when editing an existing one.
  final String? scorecardRowVersion;
  final List<ScorecardGroup>? initialImpactGroups;
  final List<ScorecardGroup>? initialStrategicGroups;
  final VoidCallback? onSaved;

  @override
  State<ImpactStrategyScorecardDialog> createState() =>
      _ImpactStrategyScorecardDialogState();
}

class _ImpactStrategyScorecardDialogState
    extends State<ImpactStrategyScorecardDialog> {
  final _service = ImpactStrategyScorecardService(Dio());

  late final List<ScorecardGroup> _impactGroups;
  late final List<ScorecardGroup> _strategicGroups;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _impactGroups =
        widget.initialImpactGroups ??
        [ScorecardGroup(yearCount: widget.targetYears.length)];
    _strategicGroups =
        widget.initialStrategicGroups ??
        [ScorecardGroup(yearCount: widget.targetYears.length)];
  }

  @override
  void dispose() {
    for (final g in _impactGroups) {
      g.dispose();
    }
    for (final g in _strategicGroups) {
      g.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final confirm = await showDialog<bool>(
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
                      color: kPrimaryBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.save_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  gap16px,
                  Text(
                    'Confirm Save',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: kText,
                    ),
                  ),
                  gap8px,
                  Text(
                    'Are you sure you want to save this scorecard?',
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
                          onPressed: () => Navigator.pop(ctx, false),
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
                            'Save',
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

    if (confirm != true) return;
    if (!mounted) return;

    setState(() => _isSaving = true);

    final rootId = widget.scorecardId ?? 0;

    final scorecard = ImpactStrategicGoalScoreCard(
      rootId,
      widget.periodId,
      null,
      _impactGroups
          .map(
            (g) => g.toImpactScoreCard(
              widget.targetYears,
              widget.baselineYear,
              scorecardId: rootId,
            ),
          )
          .toList(),
      _strategicGroups
          .map(
            (g) => g.toImpactStrategicScoreCard(
              widget.targetYears,
              widget.baselineYear,
              scorecardId: rootId,
            ),
          )
          .toList(),
      rowVersion: widget.scorecardRowVersion,
    );

    try {
      await _service.saveScorecard(scorecard);
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: const Text('Scorecard saved successfully'),
      ).show(context);
      widget.onSaved?.call();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: const Text('Failed to save scorecard'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;
    final dialogWidth = isMobile ? size.width * 0.96 : size.width * 0.92;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth.clamp(360, 1280).toDouble(),
        constraints: BoxConstraints(maxHeight: size.height * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const Divider(height: 1, color: kBorder),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      sectionTitle: 'IMPACT SCORECARD',
                      groupLabel: 'Impact',
                      measureLabel: 'Indicator',
                      groups: _impactGroups,
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      sectionTitle: 'STRATEGIC GOAL SCORECARD',
                      groupLabel: 'Goal',
                      measureLabel: 'Measure',
                      groups: _strategicGroups,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: kBorder),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.lightbulb_outline, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Impact Strategy Scorecard',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                Text(
                  '${widget.targetYears.first}-${widget.targetYears.last} target year',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: kMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: kMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _isSaving ? null : _handleSave,
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
                      'Save',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String sectionTitle,
    required String groupLabel,
    required String measureLabel,
    required List<ScorecardGroup> groups,
    List<String> footnotes = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: primaryColor, width: 1.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            sectionTitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (int g = 0; g < groups.length; g++)
          _buildGroupCard(
            groupLabel: groupLabel,
            measureLabel: measureLabel,
            group: groups[g],
            groupIndex: g,
            canDeleteGroup: groups.length > 1,
            onDeleteGroup:
                () => setState(() {
                  groups[g].dispose();
                  groups.removeAt(g);
                }),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed:
                () => setState(
                  () => groups.add(
                    ScorecardGroup(yearCount: widget.targetYears.length),
                  ),
                ),
            icon: Icon(Icons.add, size: 16, color: primaryColor),
            label: Text(
              'Add $groupLabel',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        if (footnotes.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final f in footnotes)
            Text(
              f,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: kMuted,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildGroupCard({
    required String groupLabel,
    required String measureLabel,
    required ScorecardGroup group,
    required int groupIndex,
    required VoidCallback onDeleteGroup,
    required bool canDeleteGroup,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$groupLabel ${groupIndex + 1}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: group.labelController,
                    maxLines: null,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter $groupLabel name',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: kMuted,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    size: 18,
                    color: canDeleteGroup ? kDanger : Colors.grey.shade300,
                  ),
                  onPressed: canDeleteGroup ? onDeleteGroup : null,
                  splashRadius: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (int i = 0; i < group.measures.length; i++)
                  _buildMeasureCard(
                    descLabel: measureLabel,
                    measure: group.measures[i],
                    index: i,
                    canDelete: group.measures.length > 1,
                    onDelete:
                        () => setState(() {
                          group.measures[i].dispose();
                          group.measures.removeAt(i);
                        }),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed:
                        () => setState(
                          () => group.measures.add(
                            ScorecardMeasure(
                              yearCount: widget.targetYears.length,
                            ),
                          ),
                        ),
                    icon: Icon(Icons.add, size: 14, color: primaryColor),
                    label: Text(
                      'Add $measureLabel',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
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

  Widget _buildMeasureCard({
    required String descLabel,
    required ScorecardMeasure measure,
    required int index,
    required VoidCallback onDelete,
    required bool canDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6, right: 8),
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: measure.descController,
                  maxLines: null,
                  minLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: kText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter $descLabel',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: kMuted,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: canDelete ? kDanger : Colors.grey.shade300,
                ),
                onPressed: canDelete ? onDelete : null,
                splashRadius: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _labeledField(
                label: 'Baseline (${widget.baselineYear})',
                controller: measure.baselineController,
                width: 300,
              ),
              for (int y = 0; y < widget.targetYears.length; y++)
                _labeledField(
                  label: widget.targetYears[y],
                  controller: measure.yearControllers[y],
                  width: 200,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labeledField({
    required String label,
    required TextEditingController controller,
    double width = 130,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kMuted,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            constraints: const BoxConstraints(minHeight: 44),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorder),
            ),
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kText,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
