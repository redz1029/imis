// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/utils/range_input_formatter.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';

final Dio dio = Dio();
final _accomplishmentService = DeliverableStatusMonitoringService(dio);
final Map<int, TrackingRowData> accomplishmentsMap = {};

class TrackingRowData {
  final TextEditingController percentageController;
  final TextEditingController strategicController;
  final TextEditingController breakthroughController;
  final ValueNotifier<double> finalScoreNotifier;
  String latestDisplayText;
  int? accomplishmentId;
  String target;

  TrackingRowData({
    required this.percentageController,
    TextEditingController? strategicController,
    TextEditingController? breakthroughController,
    ValueNotifier<double>? finalScoreNotifier,
    this.accomplishmentId,
    this.target = '',
    this.latestDisplayText = '',
  }) : strategicController = strategicController ?? TextEditingController(),
       breakthroughController =
           breakthroughController ?? TextEditingController(),
       finalScoreNotifier = finalScoreNotifier ?? ValueNotifier(0.0);
}

int getDropdownValue(TextEditingController c) {
  final v = int.tryParse(c.text);
  return (v == null || v < 0 || v > 5) ? 0 : v;
}

String _targetScore(double pct) {
  if (pct <= 49) return '1';
  if (pct <= 74) return '2';
  if (pct <= 99) return '3';
  if (pct == 100) return '4';
  return '5';
}

Color _scoreColor(double score) {
  if (score >= 4.5) return const Color(0xFF22C55E);
  if (score >= 3.0) return const Color(0xFFF59E0B);
  return const Color(0xFFEF4444);
}

String _scoreLabel(double score) {
  if (score >= 4.5) return 'High Performing';
  if (score >= 3.0) return 'On Track';
  return 'At Risk';
}

class BreakthroughWidget extends StatefulWidget {
  final int deliverableId;

  const BreakthroughWidget({super.key, required this.deliverableId});

  @override
  State<BreakthroughWidget> createState() => _BreakthroughWidgetState();
}

class _BreakthroughWidgetState extends State<BreakthroughWidget> {
  late TextEditingController _percentageController;
  late TextEditingController _strategicController;
  late TextEditingController _breakthroughController;
  late ValueNotifier<double> _finalScoreNotifier;
  String _latestTargetScore = '';

  @override
  void initState() {
    super.initState();
    final existing = accomplishmentsMap[widget.deliverableId];
    if (existing != null) {
      _percentageController = existing.percentageController;
      _strategicController = existing.strategicController;
      _breakthroughController = existing.breakthroughController;
      _finalScoreNotifier = existing.finalScoreNotifier;
      _latestTargetScore = existing.latestDisplayText;
    } else {
      _percentageController = TextEditingController(text: '0');
      _strategicController = TextEditingController();
      _breakthroughController = TextEditingController();
      _finalScoreNotifier = ValueNotifier(0.0);
      accomplishmentsMap[widget.deliverableId] = TrackingRowData(
        percentageController: _percentageController,
        strategicController: _strategicController,
        breakthroughController: _breakthroughController,
        finalScoreNotifier: _finalScoreNotifier,
      );
    }
  }

  void _updateFinalScore() {
    final a = double.tryParse(_latestTargetScore) ?? 0.0;
    final b = double.tryParse(_strategicController.text.trim()) ?? 0.0;
    final c = double.tryParse(_breakthroughController.text.trim()) ?? 0.0;

    if (_strategicController.text.trim().isEmpty ||
        _breakthroughController.text.trim().isEmpty) {
      _finalScoreNotifier.value = 0.0;
      return;
    }
    _finalScoreNotifier.value = (a * 0.6) + (b * 0.25) + (c * 0.15);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _percentageController,
      builder: (context, pctValue, _) {
        final pct = double.tryParse(pctValue.text) ?? 0.0;
        final targetScore = _targetScore(pct);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _latestTargetScore = targetScore;
          final td = accomplishmentsMap[widget.deliverableId];
          if (td != null) td.target = targetScore;
          _updateFinalScore();
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScoringCard(
              pct: pct,
              targetScore: targetScore,
              percentageController: _percentageController,
              strategicController: _strategicController,
              breakthroughController: _breakthroughController,
              finalScoreNotifier: _finalScoreNotifier,
              onDropdownChanged: (_) => _updateFinalScore(),
            ),
            const SizedBox(height: 20),
            _RubricSection(),
          ],
        );
      },
    );
  }
}

class _ScoringCard extends StatelessWidget {
  final double pct;
  final String targetScore;
  final TextEditingController percentageController;
  final TextEditingController strategicController;
  final TextEditingController breakthroughController;
  final ValueNotifier<double> finalScoreNotifier;
  final ValueChanged<int?> onDropdownChanged;

  const _ScoringCard({
    required this.pct,
    required this.targetScore,
    required this.percentageController,
    required this.strategicController,
    required this.breakthroughController,
    required this.finalScoreNotifier,
    required this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final progressFraction = (pct.clamp(0, 100)) / 100.0;
    final progressColor =
        pct == 100
            ? const Color(0xFF22C55E)
            : pct > 0
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Step 1: Score Entry',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 480;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ProgressTile(
                        label: 'Percent\nAccomplishment',
                        progressFraction: progressFraction,
                        progressColor: progressColor,
                        pct: pct,
                        controller: percentageController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ScoreTile(
                        label: 'Target\nAchievement',
                        value: targetScore,
                        subtitle: '60% weight',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _DropdownTile(
                        label: 'Strategic\nContribution',
                        subtitle: '25% weight',
                        controller: strategicController,
                        onChanged: onDropdownChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _DropdownTile(
                        label: 'Breakthrough\nImpact',
                        subtitle: '15% weight',
                        controller: breakthroughController,
                        onChanged: onDropdownChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _FinalScoreTile(
                        finalScoreNotifier: finalScoreNotifier,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ProgressTile(
                          label: 'Percent\nAccomplishment',
                          progressFraction: progressFraction,
                          progressColor: progressColor,
                          pct: pct,
                          controller: percentageController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ScoreTile(
                          label: 'Target\nAchievement',
                          value: targetScore,
                          subtitle: '60% weight',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownTile(
                          label: 'Strategic\nContribution',
                          subtitle: '25% weight',
                          controller: strategicController,
                          onChanged: onDropdownChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DropdownTile(
                          label: 'Breakthrough\nImpact',
                          subtitle: '15% weight',
                          controller: breakthroughController,
                          onChanged: onDropdownChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _FinalScoreTile(finalScoreNotifier: finalScoreNotifier),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final String label;
  final double progressFraction;
  final Color progressColor;
  final double pct;
  final TextEditingController controller;

  const _ProgressTile({
    required this.label,
    required this.progressFraction,
    required this.progressColor,
    required this.pct,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _MetricTile(
      label: label,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              value: progressFraction,
              strokeWidth: 5,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                child: TextField(
                  readOnly: true,
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                    RangeInputFormatter(0, 100),
                  ],
                ),
              ),
              const Text(
                '%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _ScoreTile({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _MetricTile(
      label: label,
      subtitle: subtitle,
      child: Text(
        value.isEmpty ? '–' : value,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF3B82F6),
        ),
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;

  const _DropdownTile({
    required this.label,
    required this.subtitle,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _MetricTile(
      label: label,
      subtitle: subtitle,
      child: DropdownButtonFormField<int>(
        initialValue: getDropdownValue(controller),
        isDense: true,
        isExpanded: true,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
        ),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        items: List.generate(
          6,
          (i) => DropdownMenuItem(value: i, child: Text(i.toString())),
        ),
        onChanged: (v) {
          if (v != null) {
            controller.text = v.toString();
            onChanged(v);
          }
        },
      ),
    );
  }
}

class _FinalScoreTile extends StatelessWidget {
  final ValueNotifier<double> finalScoreNotifier;

  const _FinalScoreTile({required this.finalScoreNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: finalScoreNotifier,
      builder: (context, score, _) {
        final color = _scoreColor(score);
        final label = _scoreLabel(score);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withValues(alpha: 0.08),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Final Score',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 2),
                    child: Text(
                      '/ 5',
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      score >= 4.5
                          ? Icons.trending_up
                          : score >= 3.0
                          ? Icons.remove
                          : Icons.trending_down,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final Widget child;

  const _MetricTile({required this.label, required this.child, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.3,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
            ),
          ],
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _RubricSection extends StatelessWidget {
  const _RubricSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Step 2: Scoring Rubric per Dimension',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _rubricTable(
            title: 'A. Target Achievement',
            weight: '60%',
            color: primaryColor,
            headers: const ['% Accomplishment', 'Score'],
            rows: const [
              ['0–49%', '1'],
              ['50–74%', '2'],
              ['75–99%', '3'],
              ['100% (infra not yet functional)', '4'],
              ['>100% (fully functional and used)', '5'],
            ],
          ),
          const SizedBox(height: 16),
          _rubricTable(
            title: 'B. Strategic Contribution',
            weight: '25%',
            color: primaryColor,
            headers: const ['Contribution Level', 'Score'],
            rows: const [
              ['Low (minor activity)', '1'],
              ['Moderate (important project)', '2'],
              ['High (direct strategic goal)', '3'],
              ['Very High (core priority)', '4'],
              ['Excellent (roadmap enabler)', '5'],
            ],
          ),
          const SizedBox(height: 16),
          _rubricTable(
            title: 'C. Breakthrough Impact',
            weight: '15%',
            color: primaryColor,
            headers: const ['Breakthrough Level', 'Score'],
            rows: const [
              ['None', '0'],
              ['Incremental improvement', '1'],
              ['Significant process innovation', '2'],
              ['System-wide / cross-sector', '3'],
              ['Transformational breakthrough', '4'],
              ['National / global model', '5'],
            ],
          ),
          const SizedBox(height: 24),
          _TrafficLegend(),
        ],
      ),
    );
  }

  Widget _rubricTable({
    required String title,
    required String weight,
    required Color color,
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Text(
                weight,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Table(
            border: TableBorder.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
              borderRadius: BorderRadius.circular(8),
            ),
            columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(1)},
            children: [
              TableRow(
                decoration: BoxDecoration(color: color.withValues(alpha: 0.08)),
                children:
                    headers
                        .map(
                          (h) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            child: Text(
                              h,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              ...rows.asMap().entries.map((entry) {
                final isEven = entry.key % 2 == 0;
                return TableRow(
                  decoration: BoxDecoration(
                    color: isEven ? Colors.white : const Color(0xFFFAFAFA),
                  ),
                  children:
                      entry.value
                          .asMap()
                          .entries
                          .map(
                            (cell) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 10,
                              ),
                              child: Text(
                                cell.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF374151),
                                  fontWeight:
                                      cell.key == 1
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrafficLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      (Color(0xFF22C55E), '≥ 4.5', 'High Performing / Breakthrough'),
      (Color(0xFFF59E0B), '3.0 – 4.4', 'On Track — Needs Improvement'),
      (Color(0xFFEF4444), '< 3.0', 'At Risk / Underperforming'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Status — Traffic Light Legend',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.$1,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '— ${item.$3}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
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
}

Future<void> loadBreakThrough(int deliverableId) async {
  try {
    final bt = await _accomplishmentService.fetchBreakthrough(deliverableId);
    final double a = double.tryParse(bt.target.toString()) ?? 0.0;
    final double b = double.tryParse(bt.strategic.toString()) ?? 0.0;
    final double c = double.tryParse(bt.breakThrough.toString()) ?? 0.0;
    final double finalScore = (a * 0.6) + (b * 0.25) + (c * 0.15);

    accomplishmentsMap[deliverableId] = TrackingRowData(
      percentageController: TextEditingController(
        text: bt.percentAccomplishment.toString(),
      ),
      accomplishmentId: bt.id,
      target: bt.target.toString(),
      strategicController: TextEditingController(text: bt.strategic.toString()),
      breakthroughController: TextEditingController(
        text: bt.breakThrough.toString(),
      ),
      finalScoreNotifier: ValueNotifier(finalScore),
    );
    // ignore: empty_catches
  } catch (_) {}
}

Future<void> saveBreakthroughData(int currentDeliverableId) async {
  final td = accomplishmentsMap[currentDeliverableId];
  if (td == null || td.accomplishmentId == null) return;

  try {
    final updated = await _accomplishmentService.updateBreakthrough(
      td.accomplishmentId!,
      pgsDeliverableId: currentDeliverableId,
      percentAccomplishment: int.tryParse(td.percentageController.text) ?? 0,
      target: int.tryParse(td.target) ?? 0,
      strategic: int.tryParse(td.strategicController.text) ?? 0,
      breakThrough: int.tryParse(td.breakthroughController.text) ?? 0,
      finalScore: td.finalScoreNotifier.value,
    );

    accomplishmentsMap[currentDeliverableId] = TrackingRowData(
      percentageController: TextEditingController(
        text: updated.percentAccomplishment?.toString() ?? '0',
      ),
      accomplishmentId: updated.id,
    );
    // ignore: empty_catches
  } catch (_) {}
}

class DialogHeader extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onClose;

  const DialogHeader({
    super.key,
    required this.isMobile,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 24,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.leaderboard_rounded,
              size: 18,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breakthrough Form',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  'Performance Governance System',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            color: const Color(0xFF6B7280),
            splashRadius: 20,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class InfoPanel extends StatelessWidget {
  final String kraName;
  final String deliverableName;
  final bool isDirect;

  const InfoPanel({
    super.key,
    required this.kraName,
    required this.deliverableName,
    required this.isDirect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.assignment_outlined,
            label: 'KRA',
            value: kraName,
            isFirst: true,
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _InfoRow(
            icon: Icons.task_alt_rounded,
            label: 'Deliverable',
            value: deliverableName,
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          _InfoRow(
            icon: Icons.swap_horiz_rounded,
            label: 'Type',
            value: isDirect ? 'Direct' : 'Indirect',
            valueColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isFirst;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor ?? const Color(0xFF1F2937),
                fontWeight:
                    valueColor != null ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class DialogFooter extends StatelessWidget {
  final bool isMobile;
  final BuildContext dialogContext;
  final int deliverableId;

  const DialogFooter({
    super.key,
    required this.isMobile,
    required this.dialogContext,
    required this.deliverableId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 24,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: PermissionWidget(
        permission: AppPermissions.addBreakThroughScoring,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 10 : 12,
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 10 : 12,
                ),
              ),
              icon: const Icon(Icons.save_rounded, size: 16),
              label: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                final shouldSave = await showDialog<bool>(
                  context: dialogContext,
                  builder:
                      (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text(
                          'Confirm Save',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to save this breakthrough data?',
                          style: TextStyle(fontSize: 13),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                );
                if (shouldSave != true) return;
                await saveBreakthroughData(deliverableId);
                MotionToast.success(
                  description: const Text('Saved Successfully'),
                  toastAlignment: Alignment.topCenter,
                ).show(dialogContext);
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
