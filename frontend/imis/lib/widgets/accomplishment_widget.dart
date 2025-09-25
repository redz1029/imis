import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
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

class TrackingRowWidget extends StatefulWidget {
  final String period;
  final int periodIndex;
  final int totalPeriods;
  final int deliverableId;

  const TrackingRowWidget({
    super.key,
    required this.period,
    required this.periodIndex,
    required this.totalPeriods,
    required this.deliverableId,
  });

  @override
  State<TrackingRowWidget> createState() => _TrackingRowWidgetState();
}

class _TrackingRowWidgetState extends State<TrackingRowWidget> {
  File? mobileImage;
  Uint8List? webImage;
  String? fileName;
  bool _isHovering = false;
  bool isLoading = false;

  Future<void> pickPhoto() async {
    setState(() {
      isLoading = true;
    });

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      if (kIsWeb) {
        Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
          fileName = pickedFile.name;
          isLoading = false;
        });
      } else {
        File file = File(pickedFile.path);
        setState(() {
          mobileImage = file;
          fileName = file.path.split('/').last;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    achievementsList.putIfAbsent(
      widget.deliverableId,
      () => AchievementPeriodData(rows: []),
    );

    if (achievementsList[widget.deliverableId]!.rows.length <=
        widget.periodIndex) {
      achievementsList[widget.deliverableId]!.rows.add(
        TrackingRowData(
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
        ),
      );
    }

    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
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
                widget.period,
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: grey),
                  ),
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
              child:
                  webImage != null || mobileImage != null
                      ? MouseRegion(
                        onEnter: (_) => setState(() => _isHovering = true),
                        onExit: (_) => setState(() => _isHovering = false),
                        child: Stack(
                          children: [
                            AnimatedOpacity(
                              opacity: _isHovering ? 0.6 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    kIsWeb
                                        ? Image.memory(
                                          webImage!,
                                          fit: BoxFit.contain,
                                          height: 200,
                                          width: 200,
                                        )
                                        : Image.file(
                                          mobileImage!,
                                          fit: BoxFit.contain,
                                          height: 200,
                                          width: 200,
                                        ),
                              ),
                            ),
                            if (_isHovering)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        showDialog(
                                          
                                          context: context,
                                          builder:
                                              (context) => Dialog(
                                                backgroundColor: mainBgColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: SizedBox(
                                                  width: 400,
                                                  height: 400,
                                                  child: Center(
                                                    child:
                                                        kIsWeb
                                                            ? Image.memory(
                                                              webImage!,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                            )
                                                            : Image.file(
                                                              mobileImage!,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                        );
                                      },
                                      tooltip: "View",
                                      color: grey,
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          if (kIsWeb) {
                                            webImage = null;
                                          } else {
                                            mobileImage = null;
                                          }
                                          fileName = null;
                                        });
                                      },
                                      tooltip: "Delete",
                                      color: grey,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                      : IconButton(
                        icon: const Icon(
                          Icons.image_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: pickPhoto,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> saveAccomplishmentData(
  int currentDeliverableId,
  String userId,
) async {
  final accomplishments = <PgsDeliverableAccomplishment>[];

  final periodData = achievementsList[currentDeliverableId];
  if (periodData != null) {
    for (var row in periodData.rows) {
      accomplishments.add(
        PgsDeliverableAccomplishment(
          0,
          currentDeliverableId,
          DateTime.now(),
          userId,
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
