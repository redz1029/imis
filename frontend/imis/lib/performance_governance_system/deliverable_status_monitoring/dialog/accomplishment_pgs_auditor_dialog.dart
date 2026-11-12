// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_role_string.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import '../../../constant/permissions.dart';
import '../../enum/pgs_status.dart';

final Dio dio = Dio();
final _accomplishmentService = DeliverableStatusMonitoringService(dio);
final Map<int, AchievementPeriodData> achievementsList = {};
final ValueNotifier<Set<int>> loadedDeliverables = ValueNotifier(<int>{});

class AchievementPeriodData {
  final List<TrackingRowData> rows;
  AchievementPeriodData({required this.rows});
}

class TrackingRowData {
  DateTime? date;
  final int? periodMonth;
  final int? periodYear;
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
    this.date,
    this.periodMonth,
    this.periodYear,
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

const double kAccomplishmentMobileBreakpoint = 768;

int _rank(PgsStatus s) =>
    s == PgsStatus.notStarted ? 0 : (s == PgsStatus.onGoing ? 1 : 2);

Color _statusColor(PgsStatus s) =>
    s == PgsStatus.notStarted
        ? Colors.red
        : (s == PgsStatus.onGoing ? Colors.orange : Colors.green);

void enforceAccomplishmentConsistency(List<TrackingRowData> rows) {
  PgsStatus? prevStatus;
  int prevPercent = 0;

  for (final row in rows) {
    var status = row.status.value;
    var percent = int.tryParse(row.percentageController.text) ?? 0;

    if (prevStatus != null) {
      if (prevStatus == PgsStatus.completed) {
        status = PgsStatus.completed;
      } else if (prevStatus == PgsStatus.onGoing &&
          status == PgsStatus.notStarted) {
        status = PgsStatus.onGoing;
      }
    }

    if (status == PgsStatus.completed) {
      percent = percent.clamp(100, 999).toInt();
    } else if (status == PgsStatus.onGoing) {
      final floor =
          (prevStatus == PgsStatus.onGoing && prevPercent > 1)
              ? prevPercent
              : 1;
      percent = percent.clamp(floor, 99).toInt();
    } else {
      percent = 0;
    }

    if (row.status.value != status) row.status.value = status;
    if (row.percentageController.text != percent.toString()) {
      row.percentageController.text = percent.toString();
    }

    prevStatus = status;
    prevPercent = percent;
  }
}

class _RowLimits {
  final PgsStatus minStatus;
  final int minPercent;
  final String? lockedBy;
  const _RowLimits(this.minStatus, this.minPercent, this.lockedBy);
  bool get locked => lockedBy != null;
}

String? firstCompletedMonthLabel(int deliverableId) {
  final rows = achievementsList[deliverableId]?.rows;
  if (rows == null) return null;
  for (int k = 0; k < rows.length - 1; k++) {
    final r = rows[k];
    if (r.status.value == PgsStatus.completed &&
        r.periodMonth != null &&
        r.periodYear != null) {
      return DateFormat(
        'MMMM yyyy',
      ).format(DateTime(r.periodYear!, r.periodMonth!));
    }
  }
  return null;
}

class AccomplishmentRulesInfo extends StatelessWidget {
  final String? lockedBy;

  const AccomplishmentRulesInfo({super.key, this.lockedBy});

  @override
  Widget build(BuildContext context) {
    final lb = lockedBy;
    final hasLock = lb != null;
    final color = hasLock ? Colors.green : primaryColor;
    final message =
        hasLock
            ? 'Progress carries forward: $lb is Completed, so the following '
                'months are automatically marked Completed. To change them, '
                'set $lb back to On Going.'
            : 'Progress carries forward: status only moves forward '
                '(Not Started → On Going → Completed) and On Going % cannot '
                'be lower than the previous month. Once a month is Completed, '
                'the following months are automatically Completed.';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasLock ? Icons.lock_outline : Icons.info_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class AccomplishmentRulesBanner extends StatelessWidget {
  final int deliverableId;
  const AccomplishmentRulesBanner({super.key, required this.deliverableId});

  @override
  Widget build(BuildContext context) {
    final rows = achievementsList[deliverableId]?.rows ?? const [];
    return ListenableBuilder(
      listenable: Listenable.merge(rows.map((r) => r.status).toList()),
      builder:
          (_, __) => AccomplishmentRulesInfo(
            lockedBy: firstCompletedMonthLabel(deliverableId),
          ),
    );
  }
}

// class AccomplishmentPgsAuditorDialog extends StatefulWidget {
//   final String period;
//   final int periodIndex;
//   final int totalPeriods;
//   final int deliverableId;
//   final int periodMonth;
//   final int periodYear;

//   const AccomplishmentPgsAuditorDialog({
//     super.key,
//     required this.period,
//     required this.periodIndex,
//     required this.totalPeriods,
//     required this.deliverableId,
//     required this.periodMonth,
//     required this.periodYear,
//   });

//   @override
//   State<AccomplishmentPgsAuditorDialog> createState() =>
//       AccomplishmentPgsAuditorDialogState();
// }

class AccomplishmentPgsAuditorDialog extends StatelessWidget {
  final String period;
  final int periodIndex;
  final int totalPeriods;
  final int deliverableId;
  final int periodMonth;
  final int periodYear;

  const AccomplishmentPgsAuditorDialog({
    super.key,
    required this.period,
    required this.periodIndex,
    required this.totalPeriods,
    required this.deliverableId,
    required this.periodMonth,
    required this.periodYear,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: loadedDeliverables,
      builder: (context, loaded, _) {
        if (!loaded.contains(deliverableId)) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Loading accomplishments...',
                    style: TextStyle(fontSize: 12, color: grey),
                  ),
                ],
              ),
            ),
          );
        }
        return _AuditorRowContent(
          period: period,
          periodIndex: periodIndex,
          totalPeriods: totalPeriods,
          deliverableId: deliverableId,
          periodMonth: periodMonth,
          periodYear: periodYear,
        );
      },
    );
  }
}

class _AuditorRowContent extends StatefulWidget {
  final String period;
  final int periodIndex;
  final int totalPeriods;
  final int deliverableId;
  final int periodMonth;
  final int periodYear;

  const _AuditorRowContent({
    required this.period,
    required this.periodIndex,
    required this.totalPeriods,
    required this.deliverableId,
    required this.periodMonth,
    required this.periodYear,
  });

  @override
  State<_AuditorRowContent> createState() =>
      AccomplishmentPgsAuditorDialogState();
}

class AccomplishmentPgsAuditorDialogState extends State<_AuditorRowContent> {
  String? fileName;
  bool isLoading = false;
  Uint8List? _serverImageCache;
  OverlayEntry? _overlayEntry;
  bool serverImageFetchAttempted = false;

  static const _statusDescriptions = {
    PgsStatus.notStarted:
        "Deliverable has been defined but work has not yet begun",
    PgsStatus.onGoing:
        "Deliverable is in progress and may be on hold pending decisions or resources",
    PgsStatus.completed:
        "Deliverable has been finished and meets PGS requirements",
  };

  static const _statusDisplayNames = {
    PgsStatus.notStarted: "Not Started",
    PgsStatus.onGoing: "On Going",
    PgsStatus.completed: "Completed",
  };
  String _progressCaption(PgsStatus status, int progress) {
    switch (status) {
      case PgsStatus.notStarted:
        return 'Work has not started yet (0%)';
      case PgsStatus.onGoing:
        return '$progress% done as reported by the department';
      case PgsStatus.completed:
        return 'Deliverable is fully completed (100%)';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToRefreshTrigger();
      _prefetchServerImage();
    });
  }

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
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
    if (row.accomplishmentId == null) {
      setState(() => serverImageFetchAttempted = true);
      return;
    }
    if (row.attachmentBytes != null) {
      setState(() => serverImageFetchAttempted = true);
      return;
    }

    final name = row.attachmentPath?.split("/").last ?? "";
    if (name.isEmpty || _isPdf(name)) {
      setState(() => serverImageFetchAttempted = true);
      return;
    }

    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      final token = loggedUser?.accessToken;
      if (token == null) {
        setState(() => serverImageFetchAttempted = true);
        return;
      }

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
          serverImageFetchAttempted = true;
        });
      }
    } catch (e) {
      debugPrint("Thumbnail prefetch failed: $e");
      if (mounted) setState(() => serverImageFetchAttempted = true);
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
        const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'];
        final ext = (file.extension ?? '').toLowerCase();
        if (!allowedExtensions.contains(ext)) {
          MotionToast.error(
            title: const Text("Invalid File Type"),
            description: Text(
              '".$ext" is not supported. Please upload a PDF or image (jpg, jpeg, png, gif, webp).',
            ),
            toastDuration: const Duration(seconds: 4),
            toastAlignment: Alignment.topCenter,
          ).show(context);
          setState(() => isLoading = false);
          return;
        }

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
      if (mounted) setState(() => isLoading = false);
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

  void _clearAttachment(TrackingRowData row) {
    setState(() {
      fileName = null;
      row.attachmentPath = null;
      row.attachmentBytes = null;
      _serverImageCache = null;
      row.attachmentDeleted = true;
    });
  }

  Widget _buildAttachmentCell(TrackingRowData row, {bool compact = false}) {
    const allowedRoles = [
      PermissionRoleString.roleAdmin,
      PermissionRoleString.roleStandardUser,
    ];

    final hasAttachment =
        row.attachmentPath != null && row.attachmentPath!.trim().isNotEmpty;

    if (!hasAttachment) {
      return PermissionWidget(
        allowedRoles: allowedRoles,
        fallback: Text(
          'No attachment',
          textAlign: TextAlign.center,
          style: TextStyle(color: grey, fontSize: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.upload_file_outlined, color: Colors.blue),
              onPressed: pickFile,
            ),
            Text(
              'Upload 1 supported file: PDF or image (Max 10 MB)',
              textAlign: TextAlign.center,
              style: TextStyle(color: grey, fontSize: 10),
            ),
          ],
        ),
      );
    }

    final rawName =
        fileName ?? row.attachmentPath?.split("/").last ?? "attachment";
    final displayName =
        rawName.contains('_')
            ? rawName.substring(rawName.indexOf('_') + 1)
            : rawName;
    final isPdf = _isPdf(rawName);

    final deleteButton = PermissionWidget(
      allowedRoles: allowedRoles,
      child: IconButton(
        icon: const Icon(Icons.delete, color: Colors.grey),
        tooltip: "Delete",
        onPressed: () => _clearAttachment(row),
      ),
    );

    void open() => _openPreview(context: context, row: row);

    if (isPdf) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: open,
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          deleteButton,
        ],
      );
    }

    final thumb = _thumbnailBytes;

    Widget thumbnail({double? width}) => GestureDetector(
      onTap: open,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child:
            thumb != null
                ? Image.memory(
                  thumb,
                  height: 80,
                  width: width ?? double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 80,
                        width: width ?? double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                )
                : Container(
                  height: 80,
                  width: width ?? double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (compact)
              thumbnail(width: 120)
            else
              Expanded(child: thumbnail()),
            const SizedBox(width: 6),
            deleteButton,
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: open,
          child: Text(
            displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
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
            left: offset.dx < 8 ? 8 : offset.dx,
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

  String _monthLabel(TrackingRowData r) {
    if (r.periodMonth != null && r.periodYear != null) {
      return DateFormat(
        'MMMM yyyy',
      ).format(DateTime(r.periodYear!, r.periodMonth!));
    }
    return 'A previous month';
  }

  _RowLimits _limits() {
    final rows =
        achievementsList[widget.deliverableId]?.rows ??
        const <TrackingRowData>[];
    final i = widget.periodIndex;
    if (i <= 0 || rows.length < i) {
      return const _RowLimits(PgsStatus.notStarted, 0, null);
    }

    final prev = rows[i - 1];
    final minStatus = prev.status.value;
    final minPercent =
        minStatus == PgsStatus.onGoing
            ? (int.tryParse(prev.percentageController.text) ?? 0)
            : 0;

    String? lockedBy;
    for (int k = 0; k < i; k++) {
      if (rows[k].status.value == PgsStatus.completed) {
        lockedBy = _monthLabel(rows[k]);
        break;
      }
    }
    return _RowLimits(minStatus, minPercent, lockedBy);
  }

  Listenable _prevListenable() {
    final rows = achievementsList[widget.deliverableId]?.rows;
    final i = widget.periodIndex;
    if (rows == null || i <= 0 || rows.length < i) {
      return Listenable.merge(<Listenable>[]);
    }
    return Listenable.merge([
      rows[i - 1].status,
      rows[i - 1].percentageController,
    ]);
  }

  bool _isStatusEnabled(PgsStatus s, _RowLimits limits) =>
      !limits.locked && _rank(s) >= _rank(limits.minStatus);

  String _disabledReason(_RowLimits limits) =>
      "Can't go back: previous month is already ${_statusDisplayNames[limits.minStatus]}";

  void _changeStatus(PgsStatus newValue, _RowLimits limits) {
    final rows = achievementsList[widget.deliverableId]!.rows;
    final row = rows[widget.periodIndex];
    final old = row.status.value;
    if (newValue == old) return;

    final pc = row.percentageController;
    final cur = int.tryParse(pc.text) ?? 0;

    row.status.value = newValue;

    if (newValue == PgsStatus.completed) {
      pc.text = cur >= 100 ? cur.toString() : '100';
    } else if (newValue == PgsStatus.notStarted) {
      pc.text = '0';
    } else {
      final floor = limits.minPercent < 1 ? 1 : limits.minPercent;
      pc.text = (cur >= floor && cur <= 99 ? cur : floor).toString();
    }

    if (old == PgsStatus.completed && newValue != PgsStatus.completed) {
      for (int j = widget.periodIndex + 1; j < rows.length; j++) {
        if (rows[j].status.value == PgsStatus.completed) {
          rows[j].status.value = newValue;
          rows[j].percentageController.text = pc.text;
        }
      }
    }

    enforceAccomplishmentConsistency(rows);
  }

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: grey),
    ),
  );

  Widget _lockedBadge(
    PgsStatus status,
    _RowLimits limits, {
    bool compact = false,
  }) {
    final color = _statusColor(status);
    final reason =
        "Locked because ${limits.lockedBy ?? 'a previous month'} is already Completed. "
        "Set it back to On Going to edit this month.";

    final badge = Tooltip(
      message: reason,
      child: Container(
        alignment: compact ? Alignment.centerLeft : Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 14, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                _statusDisplayNames[status]!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (compact) return badge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(height: 4),
        Text(
          'Locked: ${limits.lockedBy ?? 'previous month'} is Completed',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: grey),
        ),
      ],
    );
  }

  Widget _statusChip(PgsStatus s, PgsStatus current, _RowLimits limits) {
    final selected = s == current;
    final enabled = _isStatusEnabled(s, limits);
    final color = _statusColor(s);

    return Tooltip(
      message: enabled ? _statusDescriptions[s]! : _disabledReason(limits),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled && !selected ? () => _changeStatus(s, limits) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : Colors.grey.shade300,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                size: 14,
                color: enabled ? color : Colors.grey.shade400,
              ),
              const SizedBox(width: 4),
              Text(
                _statusDisplayNames[s]!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      enabled
                          ? (selected ? color : Colors.black87)
                          : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusField(
    TrackingRowData row,
    _RowLimits limits, {
    bool compact = false,
  }) {
    final selectedStatus = row.status;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: selectedStatus,
      builder: (context, status, _) {
        if (limits.locked) {
          return _lockedBadge(status, limits, compact: compact);
        }

        final readOnlyStatus = Center(
          child: Tooltip(
            message:
                _statusDescriptions[status] ?? _statusDisplayNames[status]!,
            child: Text(_statusDisplayNames[status]!),
          ),
        );

        final Widget editor =
            compact
                ? Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      PgsStatus.values
                          .map((s) => _statusChip(s, status, limits))
                          .toList(),
                )
                : DropdownButtonFormField<PgsStatus>(
                  key: ValueKey('${status.name}-${limits.minStatus.name}'),
                  initialValue: status,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                    isDense: true,
                  ),
                  onChanged: (newValue) {
                    if (newValue == null) return;
                    _changeStatus(newValue, limits);
                  },
                  items:
                      PgsStatus.values.map((value) {
                        final enabled = _isStatusEnabled(value, limits);
                        return DropdownMenuItem<PgsStatus>(
                          value: value,
                          enabled: enabled,
                          child: Tooltip(
                            message:
                                enabled
                                    ? (_statusDescriptions[value] ??
                                        _statusDisplayNames[value]!)
                                    : _disabledReason(limits),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 9,
                                  color:
                                      enabled
                                          ? _statusColor(value)
                                          : Colors.grey.shade300,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _statusDisplayNames[value]!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        enabled ? null : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );

        return PermissionWidget(
          allowedRoles: [
            PermissionRoleString.roleAdmin,
            PermissionRoleString.roleStandardUser,
          ],
          fallback: readOnlyStatus,
          child: editor,
        );
      },
    );
  }

  Widget _buildEditablePercentage(
    PgsStatus status,
    _RowLimits limits, {
    Color? color,
  }) {
    final row =
        achievementsList[widget.deliverableId]!.rows[widget.periodIndex];
    final percentageController = row.percentageController;
    final textStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: color,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            enforceAccomplishmentConsistency(
              achievementsList[widget.deliverableId]!.rows,
            );
          },
          child: SizedBox(
            width: 44,
            child: TextField(
              controller: percentageController,
              textAlign: TextAlign.center,
              style: textStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              // onTap: () => ,
              onChanged: (val) {
                if (val.isEmpty) return;
                final parsed = int.tryParse(val) ?? 0;

                if (status == PgsStatus.onGoing && parsed > 99) {
                  percentageController.text = '99';
                } else if (status == PgsStatus.completed && parsed > 999) {
                  percentageController.text = '999';
                }

                percentageController.selection = TextSelection.fromPosition(
                  TextPosition(offset: percentageController.text.length),
                );
              },
            ),
          ),
        ),
        Text('%', style: textStyle),
      ],
    );
  }

  Widget _buildProgressField(TrackingRowData row, _RowLimits limits) {
    final percentageController = row.percentageController;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: row.status,
      builder: (context, status, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: percentageController,
          builder: (context, value, __) {
            final progress = int.tryParse(value.text) ?? 0;
            final Color color =
                progress >= 100
                    ? Colors.green
                    : progress == 0
                    ? Colors.red
                    : Colors.orange;
            final fraction = (progress / 100).clamp(0.0, 1.0).toDouble();

            final readOnlyPercentage = Text(
              '$progress%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            );

            final editableNow =
                !limits.locked && status != PgsStatus.notStarted;

            return SizedBox(
              width: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: editableNow ? 0 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: editableNow ? color : Colors.grey.shade300,
                      ),
                    ),
                    child:
                        editableNow
                            ? PermissionWidget(
                              allowedRoles: const [
                                PermissionRoleString.roleAdmin,
                                PermissionRoleString.roleStandardUser,
                              ],
                              fallback: readOnlyPercentage,
                              child: _buildEditablePercentage(
                                status,
                                limits,
                                color: color,
                              ),
                            )
                            : readOnlyPercentage,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress == 0 ? 1.0 : fraction,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _progressCaption(status, progress),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: grey),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDeptHeadRemarks(
    TrackingRowData row, {
    TextAlign align = TextAlign.center,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: row.remarksController,
      builder: (context, value, _) {
        return Text(
          value.text.isEmpty ? "No remarks" : value.text,
          textAlign: align,
          style: const TextStyle(fontSize: 14),
        );
      },
    );
  }

  Widget _buildEvaluatorRemarks(
    TrackingRowData row,
    bool canEdit, {
    TextAlign align = TextAlign.center,
    int minLines = 1,
  }) {
    final controller = row.auditorRemarksController;
    if (canEdit) {
      return TextField(
        controller: controller,
        maxLines: null,
        minLines: minLines,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14.0),
        decoration: InputDecoration(
          hintText: 'Provide your feedback on the submitted proof',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: grey,
          ),
          border: OutlineInputBorder(borderSide: BorderSide(color: grey)),
          contentPadding: const EdgeInsets.all(8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      );
    }
    return Text(
      controller.text.isEmpty ? "No remarks" : controller.text,
      textAlign: align,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _statusPill(PgsStatus status, bool locked) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locked) ...[
            Icon(Icons.lock_outline, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            _statusDisplayNames[status]!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(
    TrackingRowData row,
    bool canEdit,
    _RowLimits limits,
  ) {
    return ValueListenableBuilder<PgsStatus>(
      valueListenable: row.status,
      builder: (context, status, _) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // status accent rail
                  Container(width: 4, color: _statusColor(status)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.period,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _statusPill(status, limits.locked),
                            ],
                          ),
                          if (limits.locked) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.lock_outline,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${limits.lockedBy ?? 'A previous month'} is already Completed, so this month is locked as Completed. Set ${limits.lockedBy ?? 'that month'} back to On Going to edit it.',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _fieldLabel('Status'),
                                    _buildStatusField(
                                      row,
                                      limits,
                                      compact: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  _fieldLabel('% Accomplishment'),
                                  _buildProgressField(row, limits),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _fieldLabel('Remarks (Dept Head)'),
                          _buildDeptHeadRemarks(row, align: TextAlign.start),
                          const SizedBox(height: 14),
                          _fieldLabel('Proof'),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildAttachmentCell(row, compact: true),
                          ),
                          const SizedBox(height: 14),
                          _fieldLabel('Remarks (Evaluator)'),
                          _buildEvaluatorRemarks(
                            row,
                            canEdit,
                            align: TextAlign.start,
                            minLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopRow(
    TrackingRowData row,
    bool canEdit,
    _RowLimits limits,
  ) {
    return ValueListenableBuilder<PgsStatus>(
      valueListenable: row.status,
      builder: (context, status, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color:
                limits.locked
                    ? Colors.green.withValues(alpha: 0.04)
                    : Colors.transparent,
            border: Border(
              left: BorderSide(color: _statusColor(status), width: 3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  widget.period,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildStatusField(row, limits),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(child: _buildProgressField(row, limits)),
              ),
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50.0),
                  child: Center(child: _buildDeptHeadRemarks(row)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildAttachmentCell(row),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50.0),
                  child: Center(child: _buildEvaluatorRemarks(row, canEdit)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    achievementsList.putIfAbsent(
      widget.deliverableId,
      () => AchievementPeriodData(rows: []),
    );

    final allRows = achievementsList[widget.deliverableId]!.rows;

    if (allRows.length <= widget.periodIndex) {
      allRows.add(
        TrackingRowData(
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
          auditorRemarksController: TextEditingController(),
          periodMonth: widget.periodMonth,
          periodYear: widget.periodYear,
        ),
      );
      enforceAccomplishmentConsistency(allRows);
    }

    final row = allRows[widget.periodIndex];

    final canEdit = permissionService.hasPermission(
      AppPermissions.editPgsDeliverableAccomplishment,
    );

    final isMobile =
        MediaQuery.of(context).size.width < kAccomplishmentMobileBreakpoint;

    return ListenableBuilder(
      listenable: _prevListenable(),
      builder: (context, _) {
        final limits = _limits();
        return isMobile
            ? _buildMobileCard(row, canEdit, limits)
            : _buildDesktopRow(row, canEdit, limits);
      },
    );
  }
}

Future<void> loadAccomplishments(
  int deliverableId,
  List<Map<String, dynamic>> monthlyPeriods,
) async {
  loadedDeliverables.value.remove(deliverableId);
  try {
    await _loadAccomplishmentsInner(deliverableId, monthlyPeriods);
  } finally {
    loadedDeliverables.value = {...loadedDeliverables.value, deliverableId};
  }
}

Future<void> _loadAccomplishmentsInner(
  int deliverableId,
  List<Map<String, dynamic>> monthlyPeriods,
) async {
  final accomplishments = await _accomplishmentService.fetchAccomplishments(
    deliverableId,
  );

  achievementsList[deliverableId] = AchievementPeriodData(
    rows:
        accomplishments.asMap().entries.map((entry) {
          final i = entry.key;
          final acc = entry.value;
          final percent = acc.percentAccomplished ?? 0;

          final int? month =
              monthlyPeriods.length > i
                  ? monthlyPeriods[i]['month'] as int?
                  : null;
          final int? year =
              monthlyPeriods.length > i
                  ? monthlyPeriods[i]['year'] as int?
                  : null;

          return TrackingRowData(
            remarksController: TextEditingController(text: acc.remarks),
            percentageController: TextEditingController(
              text: percent.toString(),
            ),
            status: ValueNotifier<PgsStatus>(
              acc.status != null
                  ? PgsStatusExtension.fromInt(acc.status!)
                  : _deriveStatusFromPercent(percent),
            ),
            attachmentPath:
                (acc.attachmentPath?.trim().isNotEmpty ?? false)
                    ? acc.attachmentPath
                    : null,
            attachmentBytes: null,
            accomplishmentId: acc.id,
            auditorRemarksController: TextEditingController(
              text: acc.auditorRemarks,
            ),
            periodMonth: month,
            periodYear: year,
          );
        }).toList(),
  );

  enforceAccomplishmentConsistency(achievementsList[deliverableId]!.rows);
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
  if (periodData == null) return;

  enforceAccomplishmentConsistency(periodData.rows);

  for (var row in periodData.rows) {
    final postingDate =
        (row.periodYear != null && row.periodMonth != null)
            ? DateTime(row.periodYear!, row.periodMonth!, 1).toIso8601String()
            : null;

    MultipartFile? attachment;
    if (!row.attachmentDeleted) {
      if (kIsWeb && row.attachmentBytes != null) {
        attachment = MultipartFile.fromBytes(
          row.attachmentBytes!,
          filename: row.attachmentPath?.split("/").last ?? "upload.bin",
        );
      } else if (!kIsWeb &&
          row.attachmentPath != null &&
          row.attachmentBytes != null) {
        attachment = await MultipartFile.fromFile(
          row.attachmentPath!,
          filename: row.attachmentPath!.split("/").last,
        );
      }
    }

    final data = {
      if (row.accomplishmentId != null) "id": row.accomplishmentId,
      "pgsDeliverableId": currentDeliverableId,
      if (postingDate != null) "postingDate": postingDate,
      "userId": userId,
      "status": row.status.value.toInt(),
      "percentAccomplished":
          double.tryParse(row.percentageController.text) ?? 0,
      "remarks": row.remarksController.text,
      "auditorRemarks": row.auditorRemarksController.text,
      "removeAttachment": row.attachmentDeleted,
    };

    final formData = FormData.fromMap({
      ...data,
      if (attachment != null) "file": attachment,
    });

    try {
      await _accomplishmentService.saveAccomplishment(
        formData,
        id: row.accomplishmentId,
      );
      row.attachmentBytes = null;
      row.attachmentDeleted = false;
    } catch (e) {
      debugPrint("Failed to save accomplishment: $e");
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

class AccomplishmentMonthsList extends StatefulWidget {
  final List<Widget> children;
  const AccomplishmentMonthsList({super.key, required this.children});

  @override
  State<AccomplishmentMonthsList> createState() =>
      _AccomplishmentMonthsListState();
}

class _AccomplishmentMonthsListState extends State<AccomplishmentMonthsList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _controller,
        child: Column(children: widget.children),
      ),
    );
  }
}
