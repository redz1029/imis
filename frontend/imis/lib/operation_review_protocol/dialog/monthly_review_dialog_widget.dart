// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/services/deliverable_status_monitoring_service.dart';
import 'package:imis/operation_review_protocol/models/operations_review_protocol.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/services/performance_governance_system_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/operation_review_protocol/dialog/operations_review_protocol_widget.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
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
  List<OperationsReviewProtocol> _filteredProtocols = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProtocols() async {
    setState(() => _isLoading = true);
    final list = await widget.onFetchAll(widget.pgsId);
    if (mounted) {
      setState(() {
        _protocols = list;
        _filteredProtocols = List.from(list);
        _isLoading = false;
      });
      if (_searchController.text.isNotEmpty) {
        _filterResults(_searchController.text);
      }
    }
  }

  void _filterResults(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filteredProtocols = List.from(_protocols));
      return;
    }
    setState(() {
      _filteredProtocols =
          _protocols.where((p) {
            final label =
                p.postingDate != null ? _monthLabel(p.postingDate!) : '';
            final status = _isSubmitted(p) ? 'submitted' : 'draft';
            return label.toLowerCase().contains(q) || status.contains(q);
          }).toList();
    });
  }

  bool _isSubmitted(OperationsReviewProtocol p) => p.isDraft != true;

  String _officeName() {
    final name = widget.data.office.name;
    return name.isEmpty ? '—' : name;
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
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
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
          (ctx) => DeleteDialog(
            title: 'Performance Validation',
            itemName: 'performance validation',
            onDelete: () async {
              Navigator.pop(ctx);
              await _pgsService.deleteOperationReviewProtocol(p.id.toString());
              await _loadProtocols();
              try {
                MotionToast.success(
                  description: Text(
                    'Performance validation deleted successfully',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              } catch (_) {
                MotionToast.error(
                  description: Text('Failed to delete performance validation'),
                ).show(context);
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    final dialogWidth =
        isMobile
            ? screenWidth
            : isTablet
            ? screenWidth * 0.92
            : screenWidth * 0.62;

    final dialogHeight = isMobile ? screenHeight : screenHeight * 0.85;

    final horizontalPadding =
        isMobile
            ? 0.0
            : isTablet
            ? 16.0
            : 24.0;
    final verticalPadding = isMobile ? 0.0 : 20.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: dialogHeight,
          minWidth: isMobile ? screenWidth : 320,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: mainBgColor,
            borderRadius:
                isMobile ? BorderRadius.zero : BorderRadius.circular(16),
            boxShadow:
                isMobile
                    ? null
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
          ),
          child: Column(
            children: [
              _buildHeader(isMobile, isTablet),
              if (isMobile) _buildMobileSearch(),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredProtocols.isEmpty
                        ? _buildEmptyState()
                        : isMobile
                        ? _buildMobileList()
                        : _buildDesktopTable(),
              ),
              _buildFooter(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            isMobile
                ? BorderRadius.zero
                : const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operations Review Protocol',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 14 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _officeName(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isMobile ? 10 : 12,
                    color: kMuted,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: isTablet ? 200 : 240,
              height: 36,
              child: _searchField(),
            ),
            const SizedBox(width: 12),
            PermissionWidget(
              permission: AppPermissions.addOperationReviewProtocol,
              child: TextButton.icon(
                onPressed: _showMonthPicker,
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
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
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(child: _searchField()),
          const SizedBox(width: 8),
          PermissionWidget(
            permission: AppPermissions.addOperationReviewProtocol,
            child: IconButton(
              onPressed: _showMonthPicker,
              icon: const Icon(Icons.add_circle, color: primaryColor, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: _filterResults,
      decoration: InputDecoration(
        hintText: 'Search month or status...',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        prefixIcon: const Icon(Icons.search, size: 18),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No operation review protocols yet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(OperationsReviewProtocol p) {
    final submitted = _isSubmitted(p);
    final Color color =
        submitted ? Colors.green.shade600 : Colors.grey.shade600;
    final label = submitted ? 'Submitted' : 'Draft';
    final tooltipMsg =
        submitted
            ? 'This protocol has been submitted and can no longer be edited.'
            : 'This protocol is still a draft and can still be edited.';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.radio_button_unchecked, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: submitted ? FontWeight.w600 : FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: tooltipMsg,
          child: Icon(Icons.info_outline, size: 14, color: color),
        ),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 12,
        headingRowColor: WidgetStatePropertyAll(Colors.grey.shade50),
        dataRowColor: WidgetStatePropertyAll(Colors.white),
        headingTextStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        horizontalMargin: 12,
        minWidth: 560,
        fixedTopRows: 1,
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade100),
        ),
        columns: const [
          DataColumn2(label: Text('#'), fixedWidth: 40),
          DataColumn2(label: Text('Month'), size: ColumnSize.L),
          DataColumn2(label: Text('Status'), size: ColumnSize.S),
          DataColumn(label: Text('Actions')),
        ],
        rows:
            _filteredProtocols.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              final label =
                  p.postingDate != null ? _monthLabel(p.postingDate!) : '—';

              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(_statusBadge(p)),
                  DataCell(_actionButtons(p)),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredProtocols.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final p = _filteredProtocols[index];
        final label = p.postingDate != null ? _monthLabel(p.postingDate!) : '—';

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _statusBadge(p),
                  ],
                ),
              ),
              _actionButtons(p, compact: true),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButtons(OperationsReviewProtocol p, {bool compact = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'View / Edit Protocol',
          child: IconButton(
            icon: Icon(
              Icons.reviews_outlined,
              size: compact ? 16 : 18,
              color: Colors.deepOrangeAccent,
            ),
            visualDensity: compact ? VisualDensity.compact : null,
            onPressed: () => _openSavedReview(p),
          ),
        ),
        Tooltip(
          message: 'Print Preview',
          child: IconButton(
            icon: Icon(
              Icons.description_outlined,
              size: compact ? 16 : 18,
              color: Colors.blueAccent,
            ),
            visualDensity: compact ? VisualDensity.compact : null,
            onPressed:
                p.postingDate == null ? null : () => _openPrintPreview(p),
          ),
        ),
        PermissionWidget(
          permission: AppPermissions.deleteOperationReviewProtocol,
          child: Tooltip(
            message: 'Delete',
            child: IconButton(
              icon: Icon(
                CupertinoIcons.delete_simple,
                size: compact ? 16 : 18,
                color: Colors.red,
              ),
              visualDensity: compact ? VisualDensity.compact : null,
              onPressed: () => _showDeleteDialog(p),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            isMobile
                ? BorderRadius.zero
                : const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
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
                final file = File('${tempDir.path}/opsreviewguide.pdf');
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
          if (isMobile)
            PermissionWidget(
              permission: AppPermissions.addOperationReviewProtocol,
              child: TextButton.icon(
                onPressed: _showMonthPicker,
                icon: const Icon(Icons.add, color: Colors.white, size: 16),
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
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: primaryTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
