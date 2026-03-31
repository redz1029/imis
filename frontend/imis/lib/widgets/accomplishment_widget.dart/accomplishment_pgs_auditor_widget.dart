// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import '../../constant/permissions.dart';
import '../../performance_governance_system/enum/pgs_status.dart';

final Dio dio = Dio();
final _accomplishmentService = DeliverableStatusMonitoringService(dio);
final Map<int, AchievementPeriodData> achievementsList = {};

class AchievementPeriodData {
  final List<TrackingRowData> rows;
  AchievementPeriodData({required this.rows});
}

class TrackingRowData {
  final TextEditingController remarksController;
  final TextEditingController auditorRemarksController;
  final TextEditingController percentageController;
  final ValueNotifier<PgsStatus> status;
  String? attachmentPath;
  Uint8List? attachmentBytes;
  int? accomplishmentId;
  bool attachmentDeleted = false;
  String? existingAttachmentId;

  final ValueNotifier<int> refreshTrigger = ValueNotifier(0);

  TrackingRowData({
    required this.remarksController,
    required this.percentageController,
    required this.status,
    this.attachmentPath,
    this.attachmentBytes,
    this.accomplishmentId,
    required this.auditorRemarksController,
    this.existingAttachmentId,
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

Color getStatusTextColor(String status) => Colors.white;

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
  String? fileName;
  bool isLoading = false;
  Uint8List? _serverImageCache;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToRefreshTrigger();
      _prefetchServerImage();
    });
  }

  void _listenToRefreshTrigger() {
    final row =
        achievementsList[widget.deliverableId]?.rows[widget.periodIndex];
    if (row == null) return;

    row.refreshTrigger.addListener(() {
      if (!mounted) return;
      setState(() {
        _serverImageCache = null;
        fileName = null;
      });
      _prefetchServerImage();
    });
  }

  Future<void> _prefetchServerImage() async {
    final row =
        achievementsList[widget.deliverableId]?.rows[widget.periodIndex];
    if (row == null) return;
    if (row.accomplishmentId == null) return;
    if (row.attachmentBytes != null) return;

    final name = row.attachmentPath?.split("/").last ?? "";
    if (_isPdf(name)) return;
    if (name.isEmpty) return;

    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      final token = loggedUser?.accessToken;
      if (token == null) return;

      final previewUrl =
          "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview";

      final response = await dio.get<List<int>>(
        previewUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (mounted) {
        setState(() {
          _serverImageCache = Uint8List.fromList(response.data!);
        });
      }
    } catch (e) {
      debugPrint("Thumbnail prefetch failed: $e");
    }
  }

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

        if (kIsWeb) {
          Uint8List? bytes = file.bytes;
          setState(() {
            fileName = file.name;
            final row =
                achievementsList[widget.deliverableId]!.rows[widget
                    .periodIndex];
            row.attachmentPath = file.name;
            row.attachmentBytes = bytes;
            row.attachmentDeleted = false;
          });
        } else {
          File pickedFile = File(file.path!);
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            fileName = file.name;
            final row =
                achievementsList[widget.deliverableId]!.rows[widget
                    .periodIndex];
            row.attachmentPath = pickedFile.path;
            row.attachmentBytes = bytes;
            row.attachmentDeleted = false;
          });
        }
      }
    } catch (e) {
      debugPrint("File picking failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _isPdf(String? name) =>
      name != null && name.toLowerCase().endsWith('.pdf');

  Future<void> _openPreview({
    required BuildContext context,
    required TrackingRowData row,
  }) async {
    final loggedUser = await AuthUtil.processTokenValidity(dio, context);
    final token = loggedUser?.accessToken;
    if (token == null) return;

    final fileNameToUse =
        fileName ?? row.attachmentPath?.split("/").last ?? "attachment";
    final isPdf = _isPdf(fileNameToUse);

    if (row.attachmentBytes != null) {
      if (kIsWeb) {
        if (isPdf) {
          final blob = html.Blob([row.attachmentBytes!], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(url, '_blank');
          Future.delayed(
            const Duration(seconds: 5),
            () => html.Url.revokeObjectUrl(url),
          );
        } else {
          _showImageDialog(
            context,
            MemoryImage(row.attachmentBytes!),
            fileNameToUse,
          );
        }
      } else {
        if (isPdf) {
          final tempFile = File('${Directory.systemTemp.path}/$fileNameToUse');
          await tempFile.writeAsBytes(row.attachmentBytes!);
          await OpenFile.open(tempFile.path);
        } else {
          _showImageDialog(
            context,
            MemoryImage(row.attachmentBytes!),
            fileNameToUse,
          );
        }
      }
      return;
    }

    if (row.accomplishmentId != null) {
      final previewUrl =
          "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview";

      if (kIsWeb) {
        if (isPdf) {
          html.window.open(previewUrl, '_blank');
        } else {
          try {
            final response = await dio.get<List<int>>(
              previewUrl,
              options: Options(
                responseType: ResponseType.bytes,
                headers: {"Authorization": "Bearer $token"},
              ),
            );
            final bytes = Uint8List.fromList(response.data!);
            _showImageDialog(context, MemoryImage(bytes), fileNameToUse);
          } catch (e) {
            debugPrint("Preview fetch failed: $e");
          }
        }
      } else {
        try {
          final tempFile = File('${Directory.systemTemp.path}/$fileNameToUse');
          await dio.download(
            previewUrl,
            tempFile.path,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );
          if (await tempFile.exists()) {
            if (isPdf) {
              await OpenFile.open(tempFile.path);
            } else {
              final bytes = await tempFile.readAsBytes();
              _showImageDialog(context, MemoryImage(bytes), fileNameToUse);
            }
          }
        } catch (e) {
          debugPrint("Preview download failed: $e");
        }
      }
    }
  }

  void _showImageDialog(
    BuildContext context,
    ImageProvider image,
    String title,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black87,
            insetPadding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: InteractiveViewer(
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              "Unable to load image.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  Uint8List? get _thumbnailBytes {
    final row =
        achievementsList[widget.deliverableId]?.rows[widget.periodIndex];
    if (row?.attachmentBytes != null) return row!.attachmentBytes;
    return _serverImageCache;
  }

  Widget _buildAttachmentCell(TrackingRowData row, bool canEdit) {
    final hasAttachment = row.attachmentPath != null;

    if (!hasAttachment) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined, color: Colors.blue),
            onPressed: canEdit ? pickFile : null,
          ),
          Text(
            'Upload 1 supported file: PDF or image. Max 10 MB',
            style: TextStyle(color: grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    final attachName =
        fileName ?? row.attachmentPath?.split("/").last ?? "attachment";
    final isPdf = _isPdf(attachName);
    final thumbBytes = _thumbnailBytes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _openPreview(context: context, row: row),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child:
                isPdf
                    ? _buildPdfThumbnail(attachName)
                    : thumbBytes != null
                    ? Image.memory(
                      thumbBytes,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageErrorBox(),
                    )
                    : _buildImageLoadingBox(),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => _openPreview(context: context, row: row),
                child: Text(
                  attachName,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            if (canEdit)
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  icon: Icon(Icons.delete, size: 16, color: grey),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      fileName = null;
                      row.attachmentPath = null;
                      row.attachmentBytes = null;
                      _serverImageCache = null;
                      row.attachmentDeleted = true;
                    });
                  },
                  tooltip: "Delete",
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageLoadingBox() => Container(
    width: 72,
    height: 72,
    color: Colors.grey[200],
    child: const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );

  Widget _buildImageErrorBox() => Container(
    width: 72,
    height: 72,
    color: Colors.grey[200],
    child: const Icon(Icons.broken_image, color: Colors.grey),
  );

  Widget _buildPdfThumbnail(String name) => Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      border: Border.all(color: Colors.red.shade200),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.picture_as_pdf, color: Colors.red.shade400, size: 32),
        const SizedBox(height: 4),
        const Text(
          'PDF',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );

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
            style: const TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
            readOnly: status == PgsStatus.notStarted,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            onTap: () {
              if (status == PgsStatus.onGoing) {
                _showTooltip(context, 'Enter value from 1-99 only');
              } else if (status == PgsStatus.completed) {
                _showTooltip(context, 'Enter value from 100-999 only');
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
    _removeTooltip();

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
                  boxShadow: const [
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
        TrackingRowData(
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
          auditorRemarksController: TextEditingController(),
        ),
      );
    }

    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
    final remarksController = row.remarksController;
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

    final canEdit = permissionService.hasPermission(
      AppPermissions.editPgsDeliverableAccomplishment,
    );

    final statusDisplayNames = {
      PgsStatus.notStarted: "Not Started",
      PgsStatus.onGoing: "On Going",
      PgsStatus.completed: "Completed",
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
                    initialValue: status,
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

          Expanded(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50.0),
              child: Center(
                child: Text(
                  remarksController.text.isEmpty
                      ? "No remarks"
                      : remarksController.text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildAttachmentCell(row, canEdit),
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
}

Future<void> loadAccomplishments(int deliverableId) async {
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
            status: ValueNotifier<PgsStatus>(_deriveStatusFromPercent(percent)),
            attachmentPath: acc.attachmentPath,
            attachmentBytes: null,
            accomplishmentId: acc.id,
            auditorRemarksController: TextEditingController(
              text: acc.auditorRemarks,
            ),
          );
        }).toList(),
  );
}

PgsStatus _deriveStatusFromPercent(int percent) {
  if (percent >= 100) return PgsStatus.completed;
  if (percent > 0) return PgsStatus.onGoing;
  return PgsStatus.notStarted;
}

Future<void> saveAccomplishmentData(
  int currentDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[currentDeliverableId];
  if (periodData != null) {
    for (var row in periodData.rows) {
      final hasNewFile = row.attachmentBytes != null;
      final isUpdate = row.accomplishmentId != null;

      final Map<String, dynamic> fields = {
        if (isUpdate) "id": row.accomplishmentId,
        "pgsDeliverableId": currentDeliverableId,
        "postingDate": DateTime.now().toIso8601String(),
        "userId": userId,
        "percentAccomplished":
            double.tryParse(row.percentageController.text) ?? 0,
        "remarks": row.remarksController.text,
        "auditorRemarks": row.auditorRemarksController.text,
        if (row.attachmentDeleted) "removeAttachment": true,
      };

      final Map<String, dynamic> formMap = {...fields};

      if ((!row.attachmentDeleted) &&
          (hasNewFile || (!kIsWeb && row.attachmentPath != null))) {
        if (kIsWeb) {
          final bytesToSend =
              hasNewFile
                  ? row.attachmentBytes!
                  : await File(row.attachmentPath!).readAsBytes();
          formMap["file"] = MultipartFile.fromBytes(
            bytesToSend,
            filename: row.attachmentPath?.split("/").last ?? "upload.bin",
          );
        } else {
          final pathToSend =
              hasNewFile ? row.attachmentPath! : row.attachmentPath!;
          formMap["file"] = await MultipartFile.fromFile(
            pathToSend,
            filename: pathToSend.split("/").last,
          );
        }
      }

      final formData = FormData.fromMap(formMap);
      await _accomplishmentService.saveAccomplishment(formData);

      row.attachmentBytes = null;
      row.attachmentDeleted = false;
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
