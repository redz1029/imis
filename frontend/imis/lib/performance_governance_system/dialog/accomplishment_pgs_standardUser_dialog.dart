// ignore_for_file: use_build_context_synchronously, file_names

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
import 'package:imis/performance_governance_system/deliverable_status_monitoring/dialog/accomplishment_pgs_auditor_dialog.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:universal_html/html.dart' as html;
import '../../constant/permissions.dart';
import '../../utils/permission_service.dart';

final _accomplishmentService = DeliverableStatusMonitoringService(dio);
final permissionService = PermissionService();

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

class AccomplishmentPgsStandarduserDialog extends StatefulWidget {
  final DateTime date;
  final TrackingRowData row;

  final bool locked;

  final String? lockedBy;

  final PgsStatus minStatus;

  final int minPercent;

  final void Function(PgsStatus oldStatus, PgsStatus newStatus)?
  onStatusChanged;
  final VoidCallback? onProgressCommitted;

  const AccomplishmentPgsStandarduserDialog({
    super.key,
    required this.date,
    required this.row,
    this.locked = false,
    this.lockedBy,
    this.minStatus = PgsStatus.notStarted,
    this.minPercent = 0,
    this.onStatusChanged,
    this.onProgressCommitted,
  });

  @override
  State<AccomplishmentPgsStandarduserDialog> createState() =>
      AccomplishmentStandarduserDialogState();
}

class AccomplishmentStandarduserDialogState
    extends State<AccomplishmentPgsStandarduserDialog> {
  Uint8List? webImage;
  File? mobileImage;
  String? fileName;
  final Dio dio = Dio();
  bool isLoading = false;
  Uint8List? _serverImageCache;

  OverlayEntry? _overlayEntry;

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

  @override
  void initState() {
    super.initState();
    _prefetchServerImage();
  }

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  Future<void> _prefetchServerImage() async {
    final row = widget.row;
    if (row.accomplishmentId == null) return;
    if (row.attachmentBytes != null) return;

    final name = row.attachmentPath?.split("/").last ?? "";
    if (name.toLowerCase().endsWith('.pdf')) return;
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
      debugPrint("Thumbnail prefetch failed");
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
        final pickedFile = result.files.first;

        const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'];
        final ext = (pickedFile.extension ?? '').toLowerCase();
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
          Uint8List? bytes = pickedFile.bytes;
          if (bytes != null) {
            setState(() {
              webImage = bytes;
              fileName = pickedFile.name;
              widget.row.attachmentPath = pickedFile.name;
              widget.row.attachmentBytes = bytes;
              widget.row.attachmentDeleted = false;
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
            widget.row.attachmentDeleted = false;
          });
        }
      }
    } catch (e) {
      debugPrint("File picking failed");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Uint8List? get _thumbnailBytes {
    if (widget.row.attachmentBytes != null) return widget.row.attachmentBytes;
    return _serverImageCache;
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

  void _clearAttachment() {
    setState(() {
      webImage = null;
      mobileImage = null;
      fileName = null;
      _serverImageCache = null;

      widget.row.attachmentBytes = null;
      widget.row.attachmentPath = null;
      widget.row.attachmentDeleted = true;
    });
  }

  bool _isStatusEnabled(PgsStatus s) =>
      !widget.locked && _rank(s) >= _rank(widget.minStatus);

  String _disabledReason() =>
      "Can't go back: previous month is already ${_statusDisplayNames[widget.minStatus]}";

  String _rangeHint(PgsStatus status) {
    if (status == PgsStatus.completed) return 'Enter score from 100–999 only';
    final floor = widget.minPercent < 1 ? 1 : widget.minPercent;
    return floor > 1
        ? 'Enter $floor–99 (not lower than previous month)'
        : 'Enter value from 1–99 only';
  }

  void _changeStatus(PgsStatus newValue) {
    final old = widget.row.status.value;
    if (newValue == old) return;

    final pc = widget.row.percentageController;
    final cur = int.tryParse(pc.text) ?? 0;

    widget.row.status.value = newValue;

    if (newValue == PgsStatus.completed) {
      pc.text = cur >= 100 ? cur.toString() : '100';
    } else if (newValue == PgsStatus.notStarted) {
      pc.text = '0';
    } else {
      final floor = widget.minPercent < 1 ? 1 : widget.minPercent;
      pc.text = (cur >= floor && cur <= 99 ? cur : floor).toString();
    }

    widget.onStatusChanged?.call(old, newValue);
  }

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: grey),
    ),
  );

  Widget _lockedBadge(PgsStatus status, {bool compact = false}) {
    final color = _statusColor(status);
    final reason =
        "Locked because ${widget.lockedBy ?? 'a previous month'} is already Completed. "
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
          'Locked: ${widget.lockedBy ?? 'previous month'} is Completed',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: grey),
        ),
      ],
    );
  }

  Widget _statusChip(PgsStatus s, PgsStatus current) {
    final selected = s == current;
    final enabled = _isStatusEnabled(s);
    final color = _statusColor(s);

    return Tooltip(
      message: enabled ? _statusDescriptions[s]! : _disabledReason(),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled && !selected ? () => _changeStatus(s) : null,
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

  Widget _buildStatusField(bool canEdit, {bool compact = false}) {
    final selectedStatus = widget.row.status;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: selectedStatus,
      builder: (context, status, _) {
        if (widget.locked) return _lockedBadge(status, compact: compact);

        if (!canEdit) {
          return Center(
            child: Tooltip(
              message:
                  _statusDescriptions[status] ?? _statusDisplayNames[status]!,
              child: Text(_statusDisplayNames[status]!),
            ),
          );
        }

        if (compact) {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                PgsStatus.values.map((s) => _statusChip(s, status)).toList(),
          );
        }

        return DropdownButtonFormField<PgsStatus>(
          key: ValueKey('${status.name}-${widget.minStatus.name}'),
          initialValue: status,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
            isDense: true,
          ),
          onChanged: (newValue) {
            if (newValue == null) return;
            _changeStatus(newValue);
          },
          items:
              PgsStatus.values.map((value) {
                final enabled = _isStatusEnabled(value);
                return DropdownMenuItem<PgsStatus>(
                  value: value,
                  enabled: enabled,
                  child: Tooltip(
                    message:
                        enabled
                            ? (_statusDescriptions[value] ??
                                _statusDisplayNames[value]!)
                            : _disabledReason(),
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
                            color: enabled ? null : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildProgressField(bool canEdit) {
    final percentageController = widget.row.percentageController;
    final selectedStatus = widget.row.status;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: selectedStatus,
      builder: (context, status, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: percentageController,
          builder: (context, value, __) {
            int progress = int.tryParse(value.text) ?? 0;
            double progressFraction;
            Color progressColor;

            if (progress >= 100) {
              progressFraction = 1.0;
              progressColor = Colors.green;
            } else if (progress == 0) {
              progressFraction = 1.0;
              progressColor = Colors.red;
            } else {
              progressFraction = progress / 100.0;
              progressColor = Colors.orange;
            }

            final editableNow = canEdit && status != PgsStatus.notStarted;

            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progressFraction,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 40,
                  child: Center(
                    child:
                        editableNow
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    if (hasFocus) {
                                      _showTooltip(context, _rangeHint(status));
                                    } else {
                                      widget.onProgressCommitted?.call();
                                    }
                                  },
                                  child: SizedBox(
                                    width: 34,
                                    child: TextField(
                                      controller: percentageController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 12,
                                        ),
                                      ),
                                      onTap:
                                          () => _showTooltip(
                                            context,
                                            _rangeHint(status),
                                          ),
                                      onChanged: (val) {
                                        if (val.isEmpty) return;
                                        final parsed = int.tryParse(val) ?? 0;

                                        if (status == PgsStatus.onGoing &&
                                            parsed > 99) {
                                          percentageController.text = '99';
                                        } else if (status ==
                                                PgsStatus.completed &&
                                            parsed > 999) {
                                          percentageController.text = '999';
                                        }

                                        percentageController.selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset:
                                                    percentageController
                                                        .text
                                                        .length,
                                              ),
                                            );
                                      },
                                    ),
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
                            )
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
            );
          },
        );
      },
    );
  }

  Widget _buildRemarksField(bool canEdit, {bool compact = false}) {
    final remarksController = widget.row.remarksController;
    if (canEdit) {
      return TextField(
        controller: remarksController,
        maxLines: null,
        minLines: compact ? 3 : 1,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14.0),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: grey)),
          contentPadding: const EdgeInsets.all(8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      );
    }
    return Text(
      remarksController.text.isEmpty ? "No remarks" : remarksController.text,
      textAlign: compact ? TextAlign.start : TextAlign.center,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildEvaluatorRemarks({bool compact = false}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.row.auditorRemarksController,
      builder: (context, value, _) {
        return Text(
          value.text.isEmpty ? 'No remarks' : value.text,
          textAlign: compact ? TextAlign.start : TextAlign.center,
          style: const TextStyle(fontSize: 14.0),
        );
      },
    );
  }

  Widget _buildAttachmentField(bool canEdit, {bool compact = false}) {
    final hasAttachment =
        widget.row.attachmentPath != null &&
        widget.row.attachmentPath!.isNotEmpty;

    final rawName =
        fileName ?? widget.row.attachmentPath?.split("/").last ?? "Attachment";

    final fileNameToUse =
        rawName.contains('_')
            ? rawName.substring(rawName.indexOf('_') + 1)
            : rawName;
    final isPdf = fileNameToUse.toLowerCase().endsWith('.pdf');
    final isImage = !isPdf;

    if (!hasAttachment && webImage == null && mobileImage == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined, color: Colors.blue),
            onPressed: canEdit ? pickFile : null,
          ),
          Text(
            'Upload 1 supported file: PDF or image (Max 10 MB)',
            textAlign: TextAlign.center,
            style: TextStyle(color: grey, fontSize: 10),
          ),
        ],
      );
    }

    if (isImage) {
      final thumb = _thumbnailBytes;

      Widget thumbnail({double? width}) => GestureDetector(
        onTap: () {
          final imageBytes = _thumbnailBytes;
          if (imageBytes == null) return;
          showDialog(
            context: context,
            builder:
                (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.memory(imageBytes, fit: BoxFit.contain),
                  ),
                ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child:
              thumb != null
                  ? Image.memory(
                    thumb,
                    height: 80,
                    width: width ?? double.infinity,
                    fit: BoxFit.cover,
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
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: _clearAttachment,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fileNameToUse,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.picture_as_pdf, color: Colors.red),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () async {
              if (widget.row.attachmentBytes != null) {
                final blob = html.Blob([
                  widget.row.attachmentBytes!,
                ], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, "_blank");
                Future.delayed(
                  const Duration(minutes: 1),
                  () => html.Url.revokeObjectUrl(url),
                );
                return;
              }

              if (widget.row.accomplishmentId == null) return;
              final url =
                  '${ApiEndpoint.baseUrl}/${widget.row.accomplishmentId}/preview';
              html.window.open(url, "_blank");
            },
            child: Text(
              fileNameToUse,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (canEdit)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: _clearAttachment,
          ),
      ],
    );
  }

  Widget _statusPill(PgsStatus status) {
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
          if (widget.locked) ...[
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

  Widget _buildMobileCard(bool canEdit) {
    final canEditStatus = canEdit && !widget.locked;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: widget.row.status,
      builder: (context, status, _) {
        final accent = _statusColor(status);

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
                  Container(width: 4, color: accent),
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
                                  DateFormat("MMMM yyyy").format(widget.date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _statusPill(status),
                            ],
                          ),
                          if (widget.locked) ...[
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
                                      '${widget.lockedBy ?? 'A previous month'} is already Completed, so this month is locked as Completed. Set ${widget.lockedBy ?? 'that month'} back to On Going to edit it.',
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
                                    _buildStatusField(canEdit, compact: true),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  _fieldLabel('% Accomplishment'),
                                  _buildProgressField(canEditStatus),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _fieldLabel('Remarks (Dept Head)'),
                          _buildRemarksField(canEdit, compact: true),
                          const SizedBox(height: 14),
                          _fieldLabel('Proof'),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildAttachmentField(
                              canEdit,
                              compact: true,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _fieldLabel('Remarks (Evaluator)'),
                          _buildEvaluatorRemarks(compact: true),
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

  Widget _buildDesktopRow(bool canEdit) {
    final canEditStatus = canEdit && !widget.locked;

    return ValueListenableBuilder<PgsStatus>(
      valueListenable: widget.row.status,
      builder: (context, status, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color:
                widget.locked
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
                  DateFormat("MMMM yyyy").format(widget.date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildStatusField(canEdit),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(child: _buildProgressField(canEditStatus)),
              ),
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50.0),
                  child: _buildRemarksField(canEdit),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildAttachmentField(canEdit),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(flex: 3, child: Center(child: _buildEvaluatorRemarks())),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = permissionService.hasPermission(
      AppPermissions.editPgsDeliverableAccomplishment,
    );
    final isMobile =
        MediaQuery.of(context).size.width < kAccomplishmentMobileBreakpoint;

    return isMobile ? _buildMobileCard(canEdit) : _buildDesktopRow(canEdit);
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadAccomplishments(widget.deliverableId, widget.startAndEndDates).then((
      _,
    ) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshConsistency() {
    final rows = achievementsList[widget.deliverableId]!.rows;
    enforceAccomplishmentConsistency(rows);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    achievementsList.putIfAbsent(
      widget.deliverableId,
      () => AchievementPeriodData(rows: []),
    );

    final allRows = achievementsList[widget.deliverableId]!.rows;
    final beforeCount = allRows.length;

    while (allRows.length < widget.startAndEndDates.length) {
      final idx = allRows.length;
      allRows.add(
        TrackingRowData(
          date: widget.startAndEndDates[idx],
          remarksController: TextEditingController(),
          percentageController: TextEditingController(text: '0'),
          status: ValueNotifier<PgsStatus>(PgsStatus.notStarted),
          auditorRemarksController: TextEditingController(),
        ),
      );
    }
    if (allRows.length != beforeCount) {
      enforceAccomplishmentConsistency(allRows);
    }

    final isMobile =
        MediaQuery.of(context).size.width < kAccomplishmentMobileBreakpoint;
    final maxH = MediaQuery.of(context).size.height * (isMobile ? 0.6 : 0.5);
    String? firstCompletedLabel;
    for (int k = 0; k < widget.startAndEndDates.length - 1; k++) {
      if (allRows[k].status.value == PgsStatus.completed) {
        firstCompletedLabel = DateFormat(
          "MMMM yyyy",
        ).format(allRows[k].date ?? widget.startAndEndDates[k]);
        break;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: widget.startAndEndDates.length,
              itemBuilder: (context, i) {
                final rows = achievementsList[widget.deliverableId]!.rows;
                final row = rows[i];

                PgsStatus minStatus = PgsStatus.notStarted;
                int minPercent = 0;
                String? lockedBy;

                if (i > 0) {
                  final prev = rows[i - 1];
                  minStatus = prev.status.value;
                  if (minStatus == PgsStatus.onGoing) {
                    minPercent =
                        int.tryParse(prev.percentageController.text) ?? 0;
                  }
                  for (int k = 0; k < i; k++) {
                    if (rows[k].status.value == PgsStatus.completed) {
                      lockedBy = DateFormat(
                        "MMMM yyyy",
                      ).format(rows[k].date ?? widget.startAndEndDates[k]);
                      break;
                    }
                  }
                }

                return Column(
                  children: [
                    AccomplishmentPgsStandarduserDialog(
                      date: widget.startAndEndDates[i],
                      row: row,
                      locked: lockedBy != null,
                      lockedBy: lockedBy,
                      minStatus: minStatus,
                      minPercent: minPercent,
                      onStatusChanged: (oldStatus, newStatus) {
                        if (oldStatus == PgsStatus.completed &&
                            newStatus != PgsStatus.completed) {
                          final pct = rows[i].percentageController.text;
                          for (int j = i + 1; j < rows.length; j++) {
                            if (rows[j].status.value == PgsStatus.completed) {
                              rows[j].status.value = newStatus;
                              rows[j].percentageController.text = pct;
                            }
                          }
                        }
                        _refreshConsistency();
                      },
                      onProgressCommitted: _refreshConsistency,
                    ),
                    if (!isMobile && i != widget.startAndEndDates.length - 1)
                      const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ),
        AccomplishmentRulesInfo(lockedBy: firstCompletedLabel),
      ],
    );
  }
}

Future<void> saveAccomplishmentDataStandardUser(
  int currentDeliverableId,
  String userId,
) async {
  final periodData = achievementsList[currentDeliverableId];
  if (periodData == null) return;

  enforceAccomplishmentConsistency(periodData.rows);

  for (var row in periodData.rows) {
    final postingDate =
        row.date != null
            ? DateTime(row.date!.year, row.date!.month, 1).toIso8601String()
            : null;

    final hasNewFile = row.attachmentBytes != null;

    MultipartFile? attachment;
    if (hasNewFile) {
      if (!kIsWeb && row.attachmentPath != null) {
        attachment = await MultipartFile.fromFile(
          row.attachmentPath!,
          filename: row.attachmentPath!.split("/").last,
        );
      } else if (kIsWeb) {
        attachment = MultipartFile.fromBytes(
          row.attachmentBytes!,
          filename: row.attachmentPath?.split("/").last ?? "upload.bin",
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
      "removeAttachment": row.attachmentDeleted && !hasNewFile,
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
    } catch (e) {
      debugPrint("Failed to save accomplishment");
    }
  }
}

Future<void> loadAccomplishments(
  int deliverableId,
  List<DateTime> startAndEndDates,
) async {
  try {
    final accomplishments = await _accomplishmentService.fetchAccomplishments(
      deliverableId,
    );

    final rows =
        accomplishments.asMap().entries.map((entry) {
          final i = entry.key;
          final acc = entry.value;
          final percent = acc.percentAccomplished ?? 0;

          final DateTime rowDate =
              i < startAndEndDates.length
                  ? DateTime(
                    startAndEndDates[i].year,
                    startAndEndDates[i].month,
                    1,
                  )
                  : DateTime(acc.postingDate.year, acc.postingDate.month, 1);

          return TrackingRowData(
            date: rowDate,
            remarksController: TextEditingController(text: acc.remarks),
            percentageController: TextEditingController(
              text: percent.toString(),
            ),
            status: ValueNotifier<PgsStatus>(
              acc.status != null
                  ? PgsStatusExtension.fromInt(acc.status!)
                  : _deriveStatusFromPercent(percent),
            ),
            auditorRemarksController: TextEditingController(
              text: acc.auditorRemarks,
            ),
            attachmentPath: acc.attachmentPath,
            attachmentBytes: null,
            accomplishmentId: acc.id,
          );
        }).toList();

    final dio = Dio();
    final loggedUser = await AuthUtil.processTokenValidity(dio, null);
    final token = loggedUser?.accessToken;

    if (token != null) {
      await Future.wait(
        rows.map((row) async {
          if (row.accomplishmentId == null) return;
          final name = row.attachmentPath?.split("/").last ?? "";
          if (name.isEmpty || name.toLowerCase().endsWith('.pdf')) return;

          try {
            final response = await dio.get<List<int>>(
              "${ApiEndpoint.baseUrl}/${row.accomplishmentId}/preview",
              options: Options(
                responseType: ResponseType.bytes,
                headers: {"Authorization": "Bearer $token"},
              ),
            );
            row.attachmentBytes = Uint8List.fromList(response.data!);
          } catch (e) {
            debugPrint("Thumbnail fetch failed for");
          }
        }),
      );
    }

    enforceAccomplishmentConsistency(rows);

    achievementsList[deliverableId] = AchievementPeriodData(rows: rows);
  } catch (e) {
    debugPrint("Failed to load accomplishments for deliverable");
  }
}

PgsStatus _deriveStatusFromPercent(int percent) {
  if (percent >= 100) return PgsStatus.completed;
  if (percent > 0) return PgsStatus.onGoing;
  return PgsStatus.notStarted;
}
