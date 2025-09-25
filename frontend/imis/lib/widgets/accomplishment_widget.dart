import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';

import '../performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import '../performance_governance_system/enum/pgs_status.dart';

final Dio dio = Dio();
final _accomplishmentService = DeliverableStatusMonitoringService(dio);

final Map<int, AchievementPeriodData> achievementsList = {};

class AchievementPeriodData {
  final List<TrackingRowData> rows;

  AchievementPeriodData({required this.rows});
}

class TrackingRowData {
  final TextEditingController remarksController;
  final TextEditingController percentageController;
  final ValueNotifier<PgsStatus> status;
  String? attachmentPath;

  TrackingRowData({
    required this.remarksController,
    required this.percentageController,
    required this.status,
    this.attachmentPath,
  });
}

Color getStatusColor(String status) {
  switch (status) {
    case 'NotStarted':
      return const Color.fromARGB(255, 151, 70, 64);
    case 'Ongoing':
      return Colors.orange;
    case 'Completed':
      return Colors.green;
    default:
      return const Color.fromARGB(255, 151, 70, 64);
  }
}

Color getStatusTextColor(String status) {
  return Colors.white;
}

Widget buildTrackingRow({
  required String period,
  required int periodIndex,
  required int totalPeriods,
  required int deliverableId,
}) {
  achievementsList.putIfAbsent(
    deliverableId,
    () => AchievementPeriodData(rows: []),
  );

  if (achievementsList[deliverableId]!.rows.length <= periodIndex) {
    achievementsList[deliverableId]!.rows.add(
      TrackingRowData(
        remarksController: TextEditingController(),
        percentageController: TextEditingController(text: '0'),
        status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
      ),
    );
  }

  final row = achievementsList[deliverableId]!.rows[periodIndex];
  final remarksController = row.remarksController;
  final percentageController = row.percentageController;
  final selectedStatus = row.status;

  final statusDescriptions = {
    PgsStatus.notStarted:
        "Deliverable has been defined but work has not yet begun",
    PgsStatus.onGoing:
        "Deliverable is in progress and may be on hold pending decisions or resources",
    PgsStatus.completed:
        "Deliverable has been finished and meets PGS requirements",
  };

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              period,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: ValueListenableBuilder<PgsStatus>(
              valueListenable: selectedStatus,
              builder: (context, status, _) {
                return DropdownButtonFormField<PgsStatus>(
                  value: status,
                  onChanged: (PgsStatus? newValue) {
                    if (newValue != null) {
                      selectedStatus.value = newValue;
                      if (newValue == PgsStatus.completed) {
                        percentageController.text = '100';
                      } else if (newValue == PgsStatus.notStarted) {
                        percentageController.text = '0';
                      } else if (newValue == PgsStatus.onGoing &&
                          (percentageController.text.isEmpty ||
                              percentageController.text == '0')) {
                        percentageController.text = '0';
                      }
                    }
                  },
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  items:
                      PgsStatus.values.map((value) {
                        return DropdownMenuItem<PgsStatus>(
                          value: value,
                          child: Tooltip(
                            message: statusDescriptions[value] ?? value.name,
                            child: Text(
                              value.name,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ValueListenableBuilder<PgsStatus>(
            valueListenable: selectedStatus,
            builder: (context, status, _) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: percentageController,
                builder: (context, value, __) {
                  int progress = int.tryParse(value.text) ?? 0;
                  double progressFraction;
                  Color progressColor;

                  if (status == PgsStatus.onGoing && progress == 0) {
                    progressFraction = 0.0;
                    progressColor = Colors.orange;
                  } else if (progress == 100) {
                    progressFraction = 1.0;
                    progressColor = Colors.green;
                  } else if (progress == 0) {
                    progressFraction = 1.0;
                    progressColor = Colors.red;
                  } else {
                    progressFraction = progress / 100.0;
                    progressColor = Colors.orange;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: TextField(
                                      controller: percentageController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      keyboardType: TextInputType.number,
                                      readOnly:
                                          progress == 100 ||
                                          (progress == 0 &&
                                              status != PgsStatus.onGoing),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 12,
                                        ),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      onChanged: (val) {
                                        int parsed = int.tryParse(val) ?? 0;
                                        if (parsed > 100) {
                                          percentageController.text = '100';
                                        }
                                      },
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
                    ],
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50.0),
            child: TextField(
              controller: remarksController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: grey)),
                contentPadding: const EdgeInsets.all(8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: IconButton(
              icon: const Icon(Icons.upload_file, color: Colors.blue),
              onPressed: () {
                uploadDocument(deliverableId, periodIndex, period);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> saveAccomplishmentData(int currentDeliverableId) async {
  final accomplishments = <PgsDeliverableAccomplishment>[];

  final periodData = achievementsList[currentDeliverableId];
  if (periodData != null) {
    for (var row in periodData.rows) {
      accomplishments.add(
        PgsDeliverableAccomplishment(
          0,
          currentDeliverableId,
          DateTime.now(),
          '176bcfeb-f12a-4d42-b790-5d2312660801',
          int.tryParse(row.percentageController.text) ?? 0,
          row.remarksController.text,
          row.attachmentPath,
          isDeleted: false,
          rowVersion: '',
        ),
      );
    }
  }

  final jsonList = accomplishments.map((e) => e.toJson()).toList();
  await _accomplishmentService.saveAccomplishment(jsonList);
}

void uploadDocument(int deliverableId, int periodIndex, String period) async {
  debugPrint(
    "Upload document for Deliverable: $deliverableId, Period: $period",
  );
}
