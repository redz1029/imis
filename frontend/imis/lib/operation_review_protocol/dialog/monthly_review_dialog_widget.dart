// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/performance_governance_system/models/operations_review_protocol.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/dialog/operations_review_protocol_widget.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class MonthlyReviewListDialog extends StatefulWidget {
  final String pgsId;
  final DateTime startDate;
  final DateTime endDate;
  final PerformanceGovernanceSystem data;
  final Future<List<PgsDeliverableAccomplishment>> Function(
    String id,
    String month,
    String year,
  )
  onFetch;
  final Future<List<OperationsReviewProtocol>> Function(String pgsId)
  onFetchAll;
  final Future<OperationsReviewProtocol?> Function(int id) onFetchById;
  final Future<bool> Function(
    OperationsReviewProtocol request, {
    Uint8List? minutesBytes,
    String? minutesFileName,
  })
  onSave;
  final Future<List<PgsDeliverables>> Function(String pgsId)
  onFetchDeliverables;

  const MonthlyReviewListDialog({
    super.key,
    required this.pgsId,
    required this.startDate,
    required this.endDate,
    required this.data,
    required this.onFetch,
    required this.onFetchAll,
    required this.onFetchById,
    required this.onSave,
    required this.onFetchDeliverables,
  });

  @override
  State<MonthlyReviewListDialog> createState() =>
      _MonthlyReviewListDialogState();
}

class _MonthlyReviewListDialogState extends State<MonthlyReviewListDialog> {
  List<OperationsReviewProtocol> _protocols = [];
  bool _isLoading = true;
  final deliverableAccomplishment = DeliverableStatusMonitoringService(Dio());
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final _pgsService = PerformanceGovernanceSystemService(Dio());

  @override
  void initState() {
    super.initState();
    _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    setState(() => _isLoading = true);
    final list = await widget.onFetchAll(widget.pgsId);
    if (mounted) {
      setState(() {
        _protocols = list;
        _isLoading = false;
      });
    }
  }

  List<DateTime> get _allMonths {
    final months = <DateTime>[];
    var current = DateTime(widget.startDate.year, widget.startDate.month);
    final last = DateTime(widget.endDate.year, widget.endDate.month);
    while (!current.isAfter(last)) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  List<DateTime> get _availableMonths {
    final savedMonths =
        _protocols
            .where((p) => p.postingDate != null)
            .map((p) => DateTime(p.postingDate!.year, p.postingDate!.month))
            .toSet();
    return _allMonths.where((m) => !savedMonths.contains(m)).toList();
  }

  String _monthLabel(DateTime date) =>
      '${_monthNames[date.month - 1]} ${date.year}';

  void _showMonthPicker() {
    if (_availableMonths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All months already have a protocol.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            insetPadding: const EdgeInsets.all(24),
            backgroundColor: Colors.transparent,
            child: Container(
              width: 360,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryLightColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Select Month',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 320),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        itemCount: _availableMonths.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final m = _availableMonths[i];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _monthLabel(m),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _openNewReview(m);
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: primaryTextColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Future<void> _openNewReview(DateTime month) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
    );

    final results = await Future.wait([
      widget.onFetch(
        widget.pgsId,
        month.month.toString(),
        month.year.toString(),
      ),
      widget.onFetchDeliverables(widget.pgsId),
    ]);

    if (!context.mounted) return;
    Navigator.pop(context);

    final accomplishments = results[0] as List<PgsDeliverableAccomplishment>;
    final allDeliverables = results[1] as List<PgsDeliverables>;

    if (accomplishments.length < allDeliverables.length) {
      final missing = allDeliverables.length - accomplishments.length;
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Incomplete accomplishments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'All deliverables must have accomplishments recorded for '
                '${_monthLabel(month)} before creating an Operations Review Protocol.\n\n'
                '$missing out of ${allDeliverables.length} deliverable(s) '
                '${missing == 1 ? 'has' : 'have'} no accomplishment yet.\n\n'
                'Please encode all accomplishments first.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Got it',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => OperationsReviewDialog(
            data: widget.data,
            accomplishments: accomplishments,
            month: month,
            existingProtocol: null,
            onSave: (
              request, {
              Uint8List? minutesBytes,
              String? minutesFileName,
            }) async {
              final success = await widget.onSave(
                request,
                minutesBytes: minutesBytes,
                minutesFileName: minutesFileName,
              );
              if (success) await _loadProtocols();
              return success;
            },
            onSaveAccomplishments: (updates) async {
              try {
                await Future.wait(
                  updates.map((u) {
                    final acc = accomplishments.firstWhere((a) => a.id == u.id);
                    return deliverableAccomplishment.updateAccomplishmentStatus(
                      acc,
                      u.status,
                    );
                  }),
                );
                return true;
              } catch (e) {
                debugPrint('Accomplishment update failed: $e');
                return false;
              }
            },
          ),
    );
  }

  Future<void> _openSavedReview(OperationsReviewProtocol saved) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final postingDate = saved.postingDate ?? DateTime.now();

    final results = await Future.wait([
      widget.onFetch(
        widget.pgsId,
        postingDate.month.toString(),
        postingDate.year.toString(),
      ),
      widget.onFetchById(saved.id),
    ]);

    if (!context.mounted) return;
    Navigator.pop(context);

    final accomplishments = results[0] as List<PgsDeliverableAccomplishment>;
    final protocol = results[1] as OperationsReviewProtocol?;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => OperationsReviewDialog(
            data: widget.data,
            accomplishments: accomplishments,
            month: postingDate,
            existingProtocol: protocol,
            onSave: (
              request, {
              Uint8List? minutesBytes,
              String? minutesFileName,
            }) async {
              final success = await widget.onSave(
                request,
                minutesBytes: minutesBytes,
                minutesFileName: minutesFileName,
              );
              if (success) await _loadProtocols();
              return success;
            },
            onSaveAccomplishments: (updates) async {
              try {
                await Future.wait(
                  updates.map((u) {
                    final acc = accomplishments.firstWhere((a) => a.id == u.id);
                    return deliverableAccomplishment.updateAccomplishmentStatus(
                      acc,
                      u.status,
                    );
                  }),
                );
                return true;
              } catch (e) {
                debugPrint('Accomplishment update failed: $e');
                return false;
              }
            },
          ),
    );
  }

  Future<void> _openPrintPreview(OperationsReviewProtocol p) async {
    if (p.postingDate == null) return;

    final dio = Dio();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(width: 16),
                Text(
                  'Generating PDF...',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
    );

    try {
      final url =
          '${ApiEndpoint().reportProtocol}/${p.id}'
          '?pgsId=${widget.pgsId}&month=${p.postingDate!.month}&year=${p.postingDate!.year}';

      if (kIsWeb) {
        final response = await AuthenticatedRequest.get(
          dio,
          url,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {'Accept': 'application/pdf'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final bytes = Uint8List.fromList(response.data);
          final blob = html.Blob([bytes], 'application/pdf');
          final blobUrl = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(blobUrl, '_blank');
          Future.delayed(const Duration(seconds: 15), () {
            html.Url.revokeObjectUrl(blobUrl);
          });
        }
      } else if (Platform.isAndroid || Platform.isIOS) {
        final response = await AuthenticatedRequest.get(
          dio,
          url,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {'Accept': 'application/pdf'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final bytes = Uint8List.fromList(response.data);
          final tempDir = await getTemporaryDirectory();
          final filePath =
              '${tempDir.path}/operations_review_${p.id}_${p.postingDate!.month}${p.postingDate!.year}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      } else {
        final response = await AuthenticatedRequest.get(
          dio,
          url,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {'Accept': 'application/pdf'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final bytes = Uint8List.fromList(response.data);
          final dir =
              Platform.isWindows
                  ? await getDownloadsDirectory()
                  : await getApplicationDocumentsDirectory();
          final filePath =
              '${dir!.path}/operations_review_${p.id}_${p.postingDate!.month}${p.postingDate!.year}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening Operations Review PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open PDF. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _showDeleteDialog(OperationsReviewProtocol p) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Confirm Delete"),
            content: Text(
              "Are you sure you want to delete the protocol for "
              "${p.postingDate != null ? _monthLabel(p.postingDate!) : 'this record'}? "
              "This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: primaryTextColor),
                ),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    await _pgsService.deleteOperationReviewProtocol(
                      p.id.toString(),
                    );
                    await _loadProtocols();
                    if (mounted) {
                      MotionToast.success(
                        toastAlignment: Alignment.topCenter,
                        description: const Text('Deleted successfully'),
                      ).show(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      MotionToast.error(
                        description: const Text('Failed to delete'),
                      ).show(context);
                    }
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: isMobile ? double.infinity : 520,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.star_outline,
                              color: primaryColor,
                              size: isMobile ? 18 : 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Operations Review Protocol',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PermissionWidget(
                      permission: AppPermissions.addOperationReviewProtocol,
                      child: TextButton.icon(
                        onPressed: _showMonthPicker,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Add New',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height * 0.55),
                child:
                    _isLoading
                        ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                        : _protocols.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No operation review protocols yet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          itemCount: _protocols.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final p = _protocols[i];
                            final label =
                                p.postingDate != null
                                    ? _monthLabel(p.postingDate!)
                                    : '—';
                            return _SavedMonthRow(
                              label: label,
                              onTap: () => _openSavedReview(p),
                              onPrintPreview:
                                  p.postingDate == null
                                      ? null
                                      : () => _openPrintPreview(p),
                              onDelete: () => _showDeleteDialog(p),
                            );
                          },
                        ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final byteData = await rootBundle.load(
                          'assets/opsreviewguide.pdf',
                        );
                        final bytes = byteData.buffer.asUint8List();
                        if (kIsWeb) {
                          final blob = html.Blob([bytes], 'application/pdf');
                          final url = html.Url.createObjectUrlFromBlob(blob);
                          html.window.open(url, '_blank');
                          Future.delayed(const Duration(seconds: 15), () {
                            html.Url.revokeObjectUrl(url);
                          });
                        } else {
                          final tempDir = await getTemporaryDirectory();
                          final file = File(
                            '${tempDir.path}/opsreviewguide.pdf',
                          );
                          await file.writeAsBytes(bytes);
                          await OpenFile.open(file.path);
                        }
                      },
                      icon: const Icon(
                        Icons.menu_book_outlined,
                        size: 16,
                        color: primaryColor,
                      ),
                      label: const Text(
                        'View Guide',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // existing Close button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: primaryTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedMonthRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onPrintPreview;
  final VoidCallback? onDelete; // ← new

  const _SavedMonthRow({
    required this.label,
    required this.onTap,
    this.onPrintPreview,
    this.onDelete, // ← new
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Tooltip(
                message: 'View / Edit Protocol',
                child: IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.reviews_outlined,
                    size: 20,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
              Tooltip(
                message: 'Print Preview',
                child: IconButton(
                  onPressed: onPrintPreview,
                  icon: const Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              PermissionWidget(
                permission: AppPermissions.deleteOperationReviewProtocol,
                child: Tooltip(
                  message: 'Delete',
                  child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      CupertinoIcons.delete_simple,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
