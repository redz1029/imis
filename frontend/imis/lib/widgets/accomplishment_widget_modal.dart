// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/accomplishment_widget.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:open_file/open_file.dart';

final _accomplishmentService = DeliverableStatusMonitoringService(dio);

class AccomplishmentRowWidget extends StatefulWidget {
  final DateTime date;
  final TrackingRowData row;

  const AccomplishmentRowWidget({
    super.key,
    required this.date,
    required this.row,
  });

  @override
  State<AccomplishmentRowWidget> createState() =>
      _AccomplishmentRowWidgetState();
}

class _AccomplishmentRowWidgetState extends State<AccomplishmentRowWidget> {
  Uint8List? webImage;
  File? mobileImage;
  String? fileName;
  final Dio dio = Dio();

  bool isLoading = false;
  Future<void> pickFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null) {
        final pickedFile = result.files.first;

        if (kIsWeb) {
          Uint8List? bytes = pickedFile.bytes;
          if (bytes != null) {
            setState(() {
              webImage = bytes;
              fileName = pickedFile.name;
              widget.row.attachmentPath = pickedFile.name;
              widget.row.attachmentBytes = bytes;
            });
          }
        } else {
          File file = File(pickedFile.path!);
          Uint8List bytes = await file.readAsBytes();

          setState(() {
            mobileImage = file;
            fileName = pickedFile.name;
            widget.row.attachmentPath = file.path;
            widget.row.attachmentBytes = bytes;
          });
        }
      }
    } catch (e) {
      debugPrint("File picking failed: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final remarksController = widget.row.remarksController;
    final percentageController = widget.row.percentageController;
    final selectedStatus = widget.row.status;

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
          // PERIOD
          Expanded(
            flex: 2,
            child: Text(
              DateFormat("MMMM yyyy").format(widget.date),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
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
                      } else if (newValue == PgsStatus.onGoing) {
                        if (percentageController.text == '100') {
                          percentageController.text = '0';
                        }
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

          // PROGRESS CIRCLE
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

          // REMARKS
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
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child:
                  widget.row.attachmentPath != null ||
                          webImage != null ||
                          mobileImage != null
                      ? Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final loggedUser =
                                    await AuthUtil.processTokenValidity(
                                      dio,
                                      context,
                                    );
                                final token = loggedUser?.accessToken;
                                if (token == null) return;

                                final fileNameToUse =
                                    fileName ??
                                    widget.row.attachmentPath
                                        ?.split("/")
                                        .last ??
                                    "download.bin";

                                if (kIsWeb) {
                                  Uint8List? bytes;
                                  if (webImage != null) {
                                    bytes = webImage!;
                                  } else if (widget.row.accomplishmentId !=
                                      null) {
                                    final downloadUrl =
                                        "${ApiEndpoint.baseUrl}/${widget.row.accomplishmentId}/download";
                                    final response = await dio.get<List<int>>(
                                      downloadUrl,
                                      options: Options(
                                        responseType: ResponseType.bytes,
                                        headers: {
                                          "Authorization": "Bearer $token",
                                        },
                                      ),
                                    );
                                    bytes = Uint8List.fromList(response.data!);
                                  }

                                  if (bytes != null) {
                                    final blob = html.Blob([bytes]);
                                    final url = html
                                        .Url.createObjectUrlFromBlob(blob);
                                    final anchor =
                                        html.AnchorElement(href: url)
                                          ..setAttribute(
                                            "download",
                                            fileNameToUse,
                                          )
                                          ..click();
                                    html.Url.revokeObjectUrl(url);
                                  }
                                } else {
                                  File? fileToOpen;
                                  if (mobileImage != null) {
                                    fileToOpen = File(mobileImage!.path);
                                  } else if (widget.row.accomplishmentId !=
                                      null) {
                                    final downloadUrl =
                                        "${ApiEndpoint.baseUrl}/${widget.row.accomplishmentId}/download";
                                    final tempDir = Directory.systemTemp;
                                    final tempFile = File(
                                      '${tempDir.path}/$fileNameToUse',
                                    );

                                    await dio.download(
                                      downloadUrl,
                                      tempFile.path,
                                      options: Options(
                                        headers: {
                                          "Authorization": "Bearer $token",
                                        },
                                      ),
                                    );

                                    if (await tempFile.exists()) {
                                      fileToOpen = tempFile;
                                    }
                                  }

                                  if (fileToOpen != null) {
                                    await OpenFile.open(fileToOpen.path);
                                  }
                                }
                              },
                              child: Text(
                                fileName ??
                                    widget.row.attachmentPath
                                        ?.split("/")
                                        .last ??
                                    "Attachment",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                if (kIsWeb) webImage = null;
                                if (!kIsWeb) mobileImage = null;
                                fileName = null;
                                widget.row.attachmentPath = null;
                                widget.row.attachmentBytes = null;
                              });
                            },
                            tooltip: "Delete",
                            color: grey,
                          ),
                        ],
                      )
                      : IconButton(
                        icon: const Icon(
                          Icons.attach_file_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: pickFile,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccomplishmentListView extends StatefulWidget {
  final int index;
  final int deliverableId;
  final List<DateTime> startAndEndDates;

  const AccomplishmentListView({
    super.key,
    required this.index,
    required this.startAndEndDates,
    required this.deliverableId,
  });

  @override
  State<AccomplishmentListView> createState() => _AccomplishmentListViewState();
}

class _AccomplishmentListViewState extends State<AccomplishmentListView> {
  @override
  void initState() {
    super.initState();
    loadAccomplishments(widget.deliverableId).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    achievementsList.putIfAbsent(
      widget.deliverableId,
      () => AchievementPeriodData(rows: []),
    );

    while (achievementsList[widget.deliverableId]!.rows.length <
        widget.startAndEndDates.length) {
      achievementsList[widget.deliverableId]!.rows.add(
        TrackingRowData(
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.startAndEndDates.length,
      itemBuilder: (context, i) {
        final row = achievementsList[widget.deliverableId]!.rows[i];
        return Column(
          children: [
            AccomplishmentRowWidget(date: widget.startAndEndDates[i], row: row),
            if (i != widget.startAndEndDates.length - 1)
              const Divider(height: 1),
          ],
        );
      },
    );
  }
}

Future<void> saveAccomplishmentData(
  int currentDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[currentDeliverableId];

  if (periodData == null) return;

  for (var row in periodData.rows) {
    MultipartFile? attachment;
    if (!kIsWeb && row.attachmentPath != null) {
      attachment = await MultipartFile.fromFile(
        row.attachmentPath!,
        filename: row.attachmentPath!.split("/").last,
      );
    } else if (row.attachmentBytes != null) {
      attachment = MultipartFile.fromBytes(
        row.attachmentBytes!,
        filename: row.attachmentPath?.split("/").last ?? "upload.bin",
      );
    }

    final data = {
      if (row.accomplishmentId != null) "id": row.accomplishmentId,
      "pgsDeliverableId": currentDeliverableId,
      "postingDate": DateTime.now().toIso8601String(),
      "userId": userId,
      "percentAccomplished":
          double.tryParse(row.percentageController.text) ?? 0,
      "remarks": row.remarksController.text,
    };

    final formData = FormData.fromMap({
      ...data,
      if (attachment != null) "file": attachment,
    });

    try {
      await _accomplishmentService.saveAccomplishment(formData);
    } catch (e) {
      debugPrint("Failed to save accomplishment: $e");
    }
  }
}

Future<void> loadAccomplishments(int deliverableId) async {
  try {
    final accomplishments = await _accomplishmentService.fetchAccomplishments(
      deliverableId,
    );

    achievementsList[deliverableId] = AchievementPeriodData(
      rows:
          accomplishments.map((acc) {
            final percent = acc.percentAccomplished ?? 0;

            return TrackingRowData(
              remarksController: TextEditingController(text: acc.remarks),
              percentageController: TextEditingController(
                text: percent.toString(),
              ),
              status: ValueNotifier<PgsStatus>(
                _deriveStatusFromPercent(percent),
              ),
              attachmentPath: acc.attachmentPath,
              attachmentBytes: null,
              accomplishmentId: acc.id,
            );
          }).toList(),
    );
  } catch (e) {
    debugPrint(
      "Failed to load accomplishments for deliverable $deliverableId: $e",
    );
  }
}

PgsStatus _deriveStatusFromPercent(int percent) {
  if (percent >= 100) return PgsStatus.completed;
  if (percent > 0) return PgsStatus.onGoing;
  return PgsStatus.notStarted;
}
