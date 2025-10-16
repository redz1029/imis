import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/utils/range_input_formatter.dart';

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

class BreakthroughWidget extends StatefulWidget {
  final int deliverableId;

  const BreakthroughWidget({super.key, required this.deliverableId});

  @override
  State<BreakthroughWidget> createState() => _BreakthroughWidgetState();
}

class _BreakthroughWidgetState extends State<BreakthroughWidget> {
  late TextEditingController _percentageController;
  late TextEditingController strategicController;
  late TextEditingController breakthroughController;
  late ValueNotifier<double> finalScoreNotifier;
  String latestDisplayText = '';

  @override
  void initState() {
    super.initState();

    final existingData = accomplishmentsMap[widget.deliverableId];
    if (existingData != null) {
      _percentageController = existingData.percentageController;
      strategicController = existingData.strategicController;
      breakthroughController = existingData.breakthroughController;
      finalScoreNotifier = existingData.finalScoreNotifier;
      latestDisplayText = existingData.latestDisplayText;
    } else {
      _percentageController = TextEditingController(text: '0');
      strategicController = TextEditingController();
      breakthroughController = TextEditingController();
      finalScoreNotifier = ValueNotifier(0.0);
      accomplishmentsMap[widget.deliverableId] = TrackingRowData(
        percentageController: _percentageController,
        strategicController: strategicController,
        breakthroughController: breakthroughController,
        finalScoreNotifier: finalScoreNotifier,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateFinalScore() {
      final targetAchievementText = double.tryParse(latestDisplayText) ?? 0.0;
      final strategicText = strategicController.text.trim();
      final breakthroughText = breakthroughController.text.trim();

      if (strategicText.isEmpty || breakthroughText.isEmpty) {
        finalScoreNotifier.value = 0.0;
        return;
      }

      final B = double.tryParse(strategicText) ?? 0.0;
      final C = double.tryParse(breakthroughText) ?? 0.0;
      final double finalScore =
          (targetAchievementText * 0.6) + (B * 0.25) + (C * 0.15);
      finalScoreNotifier.value = finalScore;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Center(
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _percentageController,
          builder: (context, value, _) {
            int progress = int.tryParse(value.text) ?? 0;
            double progressFraction = (progress.clamp(0, 100)) / 100.0;
            Color progressColor =
                progress == 100
                    ? Colors.green
                    : (progress > 0 ? Colors.orange : Colors.red);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 55,
                              height: 55,
                              child: CircularProgressIndicator(
                                value: progressFraction,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progressColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      child: TextField(
                                        readOnly: true,
                                        controller: _percentageController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                          RangeInputFormatter(0, 100),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Target Achievement Display
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Builder(
                          builder: (context) {
                            final percentage =
                                double.tryParse(_percentageController.text) ??
                                0.0;
                            String displayTargetAchievement = '';

                            if (percentage >= 0 && percentage <= 49) {
                              displayTargetAchievement = '1';
                            } else if (percentage >= 50 && percentage <= 74) {
                              displayTargetAchievement = '2';
                            } else if (percentage >= 75 && percentage <= 99) {
                              displayTargetAchievement = '3';
                            } else if (percentage == 100) {
                              displayTargetAchievement = '4';
                            } else if (percentage > 100) {
                              displayTargetAchievement = '5';
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              latestDisplayText = displayTargetAchievement;
                              final trackingData =
                                  accomplishmentsMap[widget.deliverableId];
                              if (trackingData != null) {
                                trackingData.target =
                                    displayTargetAchievement; // ✅ store target
                              }
                              updateFinalScore();
                            });

                            return Center(
                              child: Text(
                                displayTargetAchievement,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Strategic input
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: strategicController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (_) => updateFinalScore(),
                        ),
                      ),
                    ),

                    // Breakthrough input
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: breakthroughController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (_) => updateFinalScore(),
                        ),
                      ),
                    ),

                    // Final Score Display
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: ValueListenableBuilder<double>(
                          valueListenable: finalScoreNotifier,
                          builder: (context, finalScore, _) {
                            return Text(
                              finalScore.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Circle indicator
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ValueListenableBuilder<double>(
                          valueListenable: finalScoreNotifier,
                          builder: (context, finalScore, _) {
                            Color circleColor;
                            if (finalScore >= 4.5) {
                              circleColor = Colors.green;
                            } else if (finalScore >= 3.0 && finalScore < 4.5) {
                              circleColor = Colors.yellow;
                            } else {
                              circleColor = Colors.red;
                            }
                            return Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: circleColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Performance Status – Traffic Light Legend",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(
                        Colors.green,
                        "Green (≥4.5)",
                        "High-performing / breakthrough deliverables",
                      ),
                      _buildLegendItem(
                        Colors.yellow,
                        "Yellow (3.0–4.4)",
                        "On track but needs improvement",
                      ),
                      _buildLegendItem(
                        Colors.red,
                        "Red (<3.0)",
                        "At risk / underperforming",
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13),
                children: [
                  TextSpan(
                    text: "$title ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "= $description"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> loadBreakThrough(int deliverableId) async {
  try {
    final breakthrough = await _accomplishmentService.fetchBreakthrough(
      deliverableId,
    );

    final double targetAchievementText =
        double.tryParse(breakthrough.target.toString()) ?? 0.0;
    final double strategicText =
        double.tryParse(breakthrough.strategic.toString()) ?? 0.0;
    final double breakthroughText =
        double.tryParse(breakthrough.breakThrough.toString()) ?? 0.0;

    final double finalScore =
        (targetAchievementText * 0.6) +
        (strategicText * 0.25) +
        (breakthroughText * 0.15);

    accomplishmentsMap[deliverableId] = TrackingRowData(
      percentageController: TextEditingController(
        text: breakthrough.percentAccomplishment.toString(),
      ),
      accomplishmentId: breakthrough.id,
      target: breakthrough.target.toString(),
      strategicController: TextEditingController(
        text: breakthrough.strategic.toString(),
      ),
      breakthroughController: TextEditingController(
        text: breakthrough.breakThrough.toString(),
      ),
      finalScoreNotifier: ValueNotifier(finalScore),
    );
    // ignore: empty_catches
  } catch (e) {}
}

Future<void> saveBreakthroughData(int currentDeliverableId) async {
  final trackingData = accomplishmentsMap[currentDeliverableId];
  if (trackingData == null) return;

  final id = trackingData.accomplishmentId;
  if (id == null) {
    return;
  }

  final percentAccomplishment =
      int.tryParse(trackingData.percentageController.text) ?? 0;
  final strategic = int.tryParse(trackingData.strategicController.text) ?? 0;
  final breakThrough =
      int.tryParse(trackingData.breakthroughController.text) ?? 0;
  final finalScore = trackingData.finalScoreNotifier.value;
  final target = int.tryParse(trackingData.target) ?? 0;
  try {
    final updated = await _accomplishmentService.updateBreakthrough(
      id,
      pgsDeliverableId: currentDeliverableId,
      percentAccomplishment: percentAccomplishment,
      target: target,
      strategic: strategic,
      breakThrough: breakThrough,
      finalScore: finalScore,
    );

    accomplishmentsMap[currentDeliverableId] = TrackingRowData(
      percentageController: TextEditingController(
        text: updated.percentAccomplishment?.toString() ?? '0',
      ),
      accomplishmentId: updated.id,
    );
    // ignore: empty_catches
  } catch (e) {}
}
