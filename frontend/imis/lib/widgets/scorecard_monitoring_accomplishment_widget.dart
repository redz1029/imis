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
import '../scorecard/services/score_card_monitoring_services.dart';

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
  Future<void> pickFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'],
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
          percentageController: TextEditingController(text: ''),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
        ),
      );
      _ensureTotalNotifier();
      _notifyTotalScore();
    }

    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
    final percentageController = row.percentageController;
    final remarksControllerAuditor = row.auditorRemarksController;

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
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 50.0),
              child:
                  canEdit
                      ? TextField(
                        controller: percentageController,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14.0),
                        onTap: () {
                          if (percentageController.text == "0") {
                            percentageController.clear();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      : Center(
                        child: Text(
                          percentageController.text.isEmpty
                              ? "0"
                              : percentageController.text,
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
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
                            'Upload 1 supported file: PDF or image: Max 10 MB',
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
      .fetchKRAccomplishments(deliverableId);
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

Future<void> loadKPIAccomplishments(int kpi) async {
  final accomplishments = await _scorecardAccomplishmentService
      .fetchKPIAccomplishments(kpi);
  achievementsList[kpi] = AchievementPeriodData(
    rows:
        accomplishments.map((acc) {
          final percent = acc.percentAccomplished ?? 0;
          final percentageController = TextEditingController(
            text: percent.toString(),
          );
          percentageController.addListener(() {
            final data = achievementsList[kpi];
            if (data == null) return;

            int sum = 0;
            for (final row in data.rows) {
              sum += int.tryParse(row.percentageController.text) ?? 0;
            }
            totalScores.putIfAbsent(kpi, () => ValueNotifier<int>(0));
            totalScores[kpi]!.value = sum;
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

  _ensureTotalNotifier(kpi);

  int sum = 0;
  for (final row in achievementsList[kpi]!.rows) {
    sum += int.tryParse(row.percentageController.text) ?? 0;
  }
  totalScores[kpi]!.value = sum;
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

      await _scorecardAccomplishmentService.saveKRAAccomplishment(formData);
    }
  }
}

Future<void> saveKPIAccomplishmentData(
  int kpiRoadMapDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[kpiRoadMapDeliverableId];
  if (periodData != null) {
    for (var row in periodData.rows) {
      File? file =
          (!kIsWeb && row.attachmentPath != null)
              ? File(row.attachmentPath!)
              : null;
      Uint8List? bytes = row.attachmentBytes;
      final data = {
        if (row.accomplishmentId != null) "id": row.accomplishmentId,
        "kraRoadMapKpiId": kpiRoadMapDeliverableId,
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

      await _scorecardAccomplishmentService.saveKPIAccomplishment(formData);
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
