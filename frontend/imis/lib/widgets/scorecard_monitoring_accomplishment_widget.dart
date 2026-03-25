// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:motion_toast/motion_toast.dart';
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
  bool? isKpi;
  String? fileName;
  ScorecardMonitoringRowData({
    required this.percentageController,
    required this.status,
    this.attachmentPath,
    this.attachmentBytes,
    this.accomplishmentId,
    required this.auditorRemarksController,
    this.isKpi,
    this.fileName,
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
    setState(() => isLoading = true);

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
          setState(() => isLoading = false);
          return;
        }

        final row =
            achievementsList[widget.deliverableId]!.rows[widget.periodIndex];

        if (kIsWeb) {
          setState(() {
            webImage = file.bytes;
            row.fileName = file.name;
            row.attachmentPath = file.name;
            row.attachmentBytes = file.bytes;
          });
        } else {
          File pickedFile = File(file.path!);
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            mobileImage = pickedFile;
            row.fileName = file.name;
            row.attachmentPath = pickedFile.path;
            row.attachmentBytes = bytes;
          });
        }
      }
    } catch (e) {
      debugPrint("File picking failed: $e");
    } finally {
      setState(() => isLoading = false);
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
      final row = ScorecardMonitoringRowData(
        auditorRemarksController: TextEditingController(),
        percentageController: TextEditingController(text: ''),
        status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
      );

      row.percentageController.addListener(() {
        _notifyTotalScore();
      });
      achievementsList[widget.deliverableId]!.rows.add(row);
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
              child: Builder(
                builder: (context) {
                  final row =
                      achievementsList[widget.deliverableId]!.rows[widget
                          .periodIndex];

                  final hasAttachment =
                      (row.accomplishmentId != null &&
                          row.attachmentPath != null &&
                          row.attachmentPath!.isNotEmpty) ||
                      row.attachmentBytes != null;
                  String? getPreviewUrl() {
                    if (row.accomplishmentId == null) return null;
                    if (row.isKpi == true) {
                      return "${ApiEndpoint.baseUrl}/kraroadmapkpi-accomplishment/${row.accomplishmentId}/preview";
                    } else {
                      return "${ApiEndpoint.baseUrl}/kraroadmap-accomplishment/${row.accomplishmentId}/preview";
                    }
                  }

                  final previewUrl = getPreviewUrl();

                  final fileNameToUse =
                      row.fileName ??
                      row.attachmentPath?.split("/").last ??
                      "Attachment";

                  final isPdf = fileNameToUse.toLowerCase().endsWith('.pdf');

                  if (!hasAttachment) {
                    return Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.upload_file_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: canEdit ? pickFile : null,
                        ),
                        Text(
                          'Upload 1 supported file: PDF or image (Max 10 MB)',
                          style: TextStyle(color: grey, fontSize: 10),
                        ),
                      ],
                    );
                  }

                  if (!isPdf) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => Dialog(
                                          child: InteractiveViewer(
                                            child:
                                                previewUrl != null
                                                    ? Image.network(
                                                      previewUrl,
                                                      fit: BoxFit.contain,
                                                    )
                                                    : Image.memory(
                                                      row.attachmentBytes!,
                                                      fit: BoxFit.contain,
                                                    ),
                                          ),
                                        ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child:
                                      previewUrl != null
                                          ? Image.network(
                                            previewUrl,
                                            height: 80,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              progress,
                                            ) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return const SizedBox(
                                                height: 60,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  height: 60,
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                                  ),
                                                ),
                                          )
                                          : Image.memory(
                                            row.attachmentBytes!,
                                            height: 80,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  height: 80,
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  row.accomplishmentId = null;
                                  row.attachmentPath = null;
                                  row.attachmentBytes = null;
                                  row.fileName = null;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fileNameToUse,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),

                      const SizedBox(height: 6),

                      GestureDetector(
                        onTap: () {
                          if (previewUrl != null) {
                            html.window.open(previewUrl, "_blank");
                          } else if (row.attachmentBytes != null && kIsWeb) {
                            final blob = html.Blob([
                              row.attachmentBytes!,
                            ], 'application/pdf');
                            final url = html.Url.createObjectUrlFromBlob(blob);
                            html.window.open(url, "_blank");
                          }
                        },
                        child: Text(
                          fileNameToUse,
                          textAlign: TextAlign.center, // 👈 CENTER TEXT
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),

                      const SizedBox(height: 4),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            row.accomplishmentId = null;
                            row.attachmentPath = null;
                            row.attachmentBytes = null;
                            row.fileName = null;
                          });
                        },
                      ),
                    ],
                  );
                },
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

          final hasFile =
              acc.id != null &&
              acc.attachmentPath != null &&
              acc.attachmentPath!.isNotEmpty;

          return ScorecardMonitoringRowData(
            auditorRemarksController: TextEditingController(text: acc.remarks),
            percentageController: percentageController,
            status: ValueNotifier<PgsStatus>(_deriveStatusFromPercent(percent)),
            attachmentPath: hasFile ? acc.attachmentPath : null,
            attachmentBytes: null,
            accomplishmentId: acc.id,
            isKpi: false,
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

          final hasFile =
              acc.id != null &&
              acc.attachmentPath != null &&
              acc.attachmentPath!.isNotEmpty;

          return ScorecardMonitoringRowData(
            auditorRemarksController: TextEditingController(text: acc.remarks),
            percentageController: percentageController,
            status: ValueNotifier<PgsStatus>(_deriveStatusFromPercent(percent)),
            attachmentPath: hasFile ? acc.attachmentPath : null,
            attachmentBytes: null,
            accomplishmentId: acc.id,
            isKpi: true, // ✅
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
