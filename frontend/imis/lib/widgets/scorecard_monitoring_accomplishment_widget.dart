// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import '../performance_governance_system/enum/pgs_status.dart';
import '../scorecard_monitoring/services/score_card_monitoring_services.dart';

final Dio dio = Dio();
final _scorecardAccomplishmentService = ScoreCardMonitoringServices(dio);
final Map<int, AchievementPeriodData> achievementsList = {};
final Map<int, ValueNotifier<int>> totalScores = {};
final permissionService = PermissionService();

class AchievementPeriodData {
  final List<ScorecardMonitoringRowData> rows;

  AchievementPeriodData({required this.rows});
}

class ScorecardMonitoringRowData {
  final TextEditingController auditorRemarksController;
  final TextEditingController percentageController;
  final ValueNotifier<PgsStatus> status;
  String? attachmentPath;
  Uint8List? attachmentBytes;
  int? accomplishmentId;

  ScorecardMonitoringRowData({
    required this.percentageController,
    required this.status,
    this.attachmentPath,
    this.attachmentBytes,
    this.accomplishmentId,
    required this.auditorRemarksController,
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

class ScorecardAccomplishmentRowWidget extends StatefulWidget {
  final String period;
  final int periodIndex;
  final int totalPeriods;
  final int deliverableId;

  const ScorecardAccomplishmentRowWidget({
    super.key,
    required this.period,
    required this.periodIndex,
    required this.totalPeriods,
    required this.deliverableId,
  });

  @override
  State<ScorecardAccomplishmentRowWidget> createState() =>
      _ScorecardAccomplishmentRowWidgetState();
}

class _ScorecardAccomplishmentRowWidgetState
    extends State<ScorecardAccomplishmentRowWidget> {
  File? mobileImage;
  Uint8List? webImage;
  String? fileName;
  bool isLoading = false;
  OverlayEntry? _overlayEntry;
  Future<void> pickFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        final file = result.files.first;
        final fileSizeInMB = file.size / (1024 * 1024);

        if (fileSizeInMB > 10) {
          MotionToast.warning(
            description: const Text(
              "File too large! Maximum allowed size is 10 MB.",
            ),
            toastDuration: const Duration(seconds: 3),
            toastAlignment: Alignment.topCenter,
          ).show(context);

          setState(() {
            isLoading = false;
          });
          return;
        }

        if (kIsWeb) {
          Uint8List? bytes = file.bytes;
          setState(() {
            webImage = bytes;
            fileName = file.name;
            final row =
                achievementsList[widget.deliverableId]!.rows[widget
                    .periodIndex];
            row.attachmentPath = file.name;
            row.attachmentBytes = bytes;
          });
        } else {
          File pickedFile = File(file.path!);
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            mobileImage = pickedFile;
            fileName = file.name;
            final row =
                achievementsList[widget.deliverableId]!.rows[widget
                    .periodIndex];
            row.attachmentPath = pickedFile.path;
            row.attachmentBytes = bytes;
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

  Widget _buildEditablePercentage(PgsStatus status) {
    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
    final percentageController = row.percentageController;
    final selectedStatus = row.status;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30,
          child: TextField(
            controller: percentageController,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
            readOnly: status == PgsStatus.notStarted,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),

            onTap: () {
              if (status == PgsStatus.onGoing) {
                _showTooltip(context, 'Enter value from 1–99 only');
              } else if (status == PgsStatus.completed) {
                _showTooltip(context, 'Enter value from 100–999 only');
              }
            },

            onChanged: (val) {
              if (val.isEmpty) return;

              int parsed = int.tryParse(val) ?? 0;

              if (selectedStatus.value == PgsStatus.completed) {
                if (parsed < 100) {
                  percentageController.text = '100';
                } else if (parsed > 999) {
                  percentageController.text = '999';
                }
              } else if (selectedStatus.value == PgsStatus.onGoing) {
                if (parsed < 1) {
                  percentageController.text = '1';
                } else if (parsed > 99) {
                  percentageController.text = '99';
                }
              } else {
                percentageController.text = '0';
              }

              percentageController.selection = TextSelection.collapsed(
                offset: percentageController.text.length,
              );

              _notifyTotalScore();
            },
          ),
        ),

        const Text(
          '%',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showTooltip(BuildContext context, String message) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx - 20,
            top: offset.dy - 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), _removeTooltip);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
        ScorecardMonitoringRowData(
          auditorRemarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
        ),
      );
      _ensureTotalNotifier();
      _notifyTotalScore();
    }

    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
    final percentageController = row.percentageController;
    final selectedStatus = row.status;
    final remarksControllerAuditor = row.auditorRemarksController;
    final statusDescriptions = {
      PgsStatus.notStarted:
          "Deliverable has been defined but work has not yet begun",
      PgsStatus.onGoing:
          "Deliverable is in progress and may be on hold pending decisions or resources",
      PgsStatus.completed:
          "Deliverable has been finished and meets PGS requirements",
    };
    final statusDisplayNames = {
      PgsStatus.notStarted: "Not Started",
      PgsStatus.onGoing: "On Going",
      PgsStatus.completed: "Completed",
    };
    final canEdit = permissionService.hasPermission(
      AppPermissions.editKraRoadMapAccomplishment,
    );
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
            child: ValueListenableBuilder<PgsStatus>(
              valueListenable: selectedStatus,
              builder: (context, status, _) {
                if (!canEdit) {
                  return Center(
                    child: Tooltip(
                      message:
                          statusDescriptions[status] ??
                          statusDisplayNames[status]!,
                      child: Text(statusDisplayNames[status]!),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: DropdownButtonFormField<PgsStatus>(
                    value: status,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    onChanged: (newValue) {
                      if (newValue == null) return;

                      selectedStatus.value = newValue;

                      if (newValue == PgsStatus.completed) {
                        percentageController.text = '100';
                      } else if (newValue == PgsStatus.notStarted) {
                        percentageController.text = '0';
                      } else if (newValue == PgsStatus.onGoing &&
                          percentageController.text == '100') {
                        percentageController.text = '1';
                      }
                      _notifyTotalScore();
                    },
                    items:
                        PgsStatus.values.map((value) {
                          return DropdownMenuItem<PgsStatus>(
                            value: value,
                            child: Tooltip(
                              message:
                                  statusDescriptions[value] ??
                                  statusDisplayNames[value],
                              child: Text(
                                statusDisplayNames[value]!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            ),
          ),

          Expanded(
            flex: 2,
            child: ValueListenableBuilder<PgsStatus>(
              valueListenable: selectedStatus,
              builder: (context, status, _) {
                if (status == PgsStatus.onGoing &&
                    percentageController.text == '0') {
                  percentageController.text = '1';
                } else if (status == PgsStatus.notStarted &&
                    percentageController.text != '0') {
                  percentageController.text = '0';
                } else if (status == PgsStatus.completed &&
                    (int.tryParse(percentageController.text) ?? 0) < 100) {
                  percentageController.text = '100';
                }
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
                                child:
                                    canEdit
                                        ? _buildEditablePercentage(status)
                                        : Text(
                                          '${value.text}%',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
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

          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child:
                  row.attachmentPath != null ||
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
                                    row.attachmentPath?.split("/").last ??
                                    "download.bin";

                                if (kIsWeb) {
                                  Uint8List? bytes;

                                  if (webImage != null) {
                                    bytes = webImage!;
                                  } else if (row.accomplishmentId != null) {
                                    final downloadUrl =
                                        "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/download";
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
                                    final _ =
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
                                  } else if (row.accomplishmentId != null) {
                                    final downloadUrl =
                                        "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/download";
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
                                    row.attachmentPath?.split("/").last ??
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
                                row.attachmentPath = null;
                                row.attachmentBytes = null;
                              });
                            },
                            tooltip: "Delete",
                            color: grey,
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.upload_file_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: canEdit ? pickFile : null,
                          ),
                          Text(
                            'Upload 1 supported file: PDF, document, or image: Max 10 MB',
                            style: TextStyle(color: grey, fontSize: 10),
                          ),
                        ],
                      ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50.0),
              child:
                  canEdit
                      ? TextField(
                        controller: remarksControllerAuditor,
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
                      )
                      : Center(
                        child: Text(
                          remarksControllerAuditor.text.isEmpty
                              ? "No remarks"
                              : remarksControllerAuditor.text,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _ensureTotalNotifier() {
    totalScores.putIfAbsent(widget.deliverableId, () => ValueNotifier<int>(0));
  }

  void _notifyTotalScore() {
    _ensureTotalNotifier();
    final data = achievementsList[widget.deliverableId];
    if (data == null) return;
    int sum = 0;
    for (final row in data.rows) {
      final val = int.tryParse(row.percentageController.text) ?? 0;
      sum += val;
    }
    totalScores[widget.deliverableId]!.value = sum;
  }
}

Future<void> loadScorecardAccomplishments(int deliverableId) async {
  final accomplishments = await _scorecardAccomplishmentService
      .fetchAccomplishments(deliverableId);
  achievementsList[deliverableId] = AchievementPeriodData(
    rows:
        accomplishments.map((acc) {
          final percent = acc.percentAccomplished ?? 0;
          final percentageController = TextEditingController(
            text: percent.toString(),
          );
          percentageController.addListener(() {
            final data = achievementsList[deliverableId];
            if (data == null) return;

            int sum = 0;
            for (final row in data.rows) {
              sum += int.tryParse(row.percentageController.text) ?? 0;
            }
            totalScores.putIfAbsent(deliverableId, () => ValueNotifier<int>(0));
            totalScores[deliverableId]!.value = sum;
          });

          return ScorecardMonitoringRowData(
            auditorRemarksController: TextEditingController(text: acc.remarks),
            percentageController: percentageController,
            status: ValueNotifier<PgsStatus>(_deriveStatusFromPercent(percent)),
            attachmentPath: acc.attachmentPath,
            attachmentBytes: null,
            accomplishmentId: acc.id,
          );
        }).toList(),
  );

  _ensureTotalNotifier(deliverableId);

  int sum = 0;
  for (final row in achievementsList[deliverableId]!.rows) {
    sum += int.tryParse(row.percentageController.text) ?? 0;
  }
  totalScores[deliverableId]!.value = sum;
}

void _ensureTotalNotifier(int deliverableId) {
  totalScores.putIfAbsent(deliverableId, () => ValueNotifier<int>(0));
}

PgsStatus _deriveStatusFromPercent(int percent) {
  if (percent >= 100) return PgsStatus.completed;
  if (percent > 0) return PgsStatus.onGoing;
  return PgsStatus.notStarted;
}

Future<void> saveScorecardAccomplishmentData(
  int kraRoadMapDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[kraRoadMapDeliverableId];
  if (periodData != null) {
    for (var row in periodData.rows) {
      File? file =
          (!kIsWeb && row.attachmentPath != null)
              ? File(row.attachmentPath!)
              : null;
      Uint8List? bytes = row.attachmentBytes;
      final data = {
        if (row.accomplishmentId != null) "id": row.accomplishmentId,
        "kraRoadMapDeliverableId": kraRoadMapDeliverableId,
        "postingDate": DateTime.now().toIso8601String(),
        "userId": userId,
        "percentAccomplished":
            double.tryParse(row.percentageController.text) ?? 0,
        "remarks": row.auditorRemarksController.text,
      };
      final formData = FormData.fromMap({
        ...data,
        if (bytes != null)
          "file": MultipartFile.fromBytes(
            bytes,
            filename: row.attachmentPath?.split("/").last ?? "upload.bin",
          ),
        if (file != null)
          "file": await MultipartFile.fromFile(
            file.path,
            filename: row.attachmentPath?.split("/").last,
          ),
      });

      await _scorecardAccomplishmentService.saveAccomplishment(formData);
    }
  }
}

class AccomplishmentRowData {
  final DateTime date;
  PgsStatus status;
  String remarks;

  AccomplishmentRowData({
    required this.date,
    this.status = PgsStatus.notStarted,
    this.remarks = "",
  });
}
