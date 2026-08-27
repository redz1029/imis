// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_validation_tool/dialog/performance_validation_dialog.dart';
import 'package:imis/performance_validation_tool/models/performance_validation_tool.dart';
import 'package:imis/performance_validation_tool/services/performance_validation_services.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import '../../utils/http_util.dart';

class PerformanceValidationListDialog extends StatefulWidget {
  final PerformanceGovernanceSystem pgs;

  final Future<List<PerformanceValidationTool>> Function(String pgsId)
  onFetchAll;

  final Future<PerformanceValidationTool?> Function(int id) onFetchById;

  final Future<bool> Function(int id) onDelete;

  const PerformanceValidationListDialog({
    super.key,
    required this.pgs,
    required this.onFetchAll,
    required this.onFetchById,
    required this.onDelete,
  });

  @override
  State<PerformanceValidationListDialog> createState() =>
      _PerformanceValidationListDialogState();
}

class _PerformanceValidationListDialogState
    extends State<PerformanceValidationListDialog> {
  List<PerformanceValidationTool> _validations = [];
  List<PerformanceValidationTool> _filteredValidations = [];
  bool _isLoading = true;
  bool _checkingSignatory = false;
  final _searchController = TextEditingController();
  final _performanceValidationService = PerformanceValidationServices(Dio());
  final _commonService = CommonService(Dio());
  static const _months = [
    '',
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

  @override
  void initState() {
    super.initState();
    _loadValidations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadValidations() async {
    setState(() => _isLoading = true);
    final list = await widget.onFetchAll(widget.pgs.id.toString());
    if (mounted) {
      setState(() {
        _validations = list;
        _filteredValidations = List.from(list);
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
      setState(() => _filteredValidations = List.from(_validations));
      return;
    }
    setState(() {
      _filteredValidations =
          _validations
              .where((v) => _periodLabel(v).toLowerCase().contains(q))
              .toList();
    });
  }

  String _officeName() {
    final name = widget.pgs.office.name;
    return name.isEmpty ? '—' : name;
  }

  String _periodLabel(PerformanceValidationTool v) {
    if (v.validateDate != null) {
      return '${_months[v.validateDate!.month]} ${v.validateDate!.year}';
    }
    return '—';
  }

  Future<void> _showNoSignatoryDialog() async {
    await showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.pending_actions_outlined,
                      color: Colors.orange.shade700,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Deliverables Not Yet Submitted',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The head of ${widget.pgs.office.name} has not submitted their '
                    'deliverables yet. Performance validation cannot be created '
                    'until the head department has submitted.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _openNewValidation() async {
    setState(() => _checkingSignatory = true);

    String? headUserId;
    try {
      final signatories = await _commonService.fetchPgsSignatories(
        widget.pgs.id,
      );
      if (signatories.isNotEmpty) {
        headUserId = signatories.first.signatoryId;
      }
    } catch (_) {
      headUserId = null;
    }

    if (mounted) setState(() => _checkingSignatory = false);

    if (headUserId == null || headUserId.isEmpty) {
      if (mounted) await _showNoSignatoryDialog();
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PerformanceValidationDialog(pgs: widget.pgs),
    ).then((saved) {
      if (saved == true) _loadValidations();
    });
  }

  Future<void> _openSavedValidation(PerformanceValidationTool v) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
    );

    final user = await AuthUtil.fetchLoggedUser();

    final results = await Future.wait([
      widget.onFetchById(v.id),
      if (user != null && user.id != null && user.id!.isNotEmpty)
        _performanceValidationService.getPerformanceValidationByUserId(
          userId: user.id!,
          performanceValidationToolId: v.id,
        )
      else
        Future.value(null),
    ]);

    final data = results[0] as PerformanceValidationTool?;
    final userCheckStatusCode = results[1] as int?;

    if (!mounted) return;
    Navigator.pop(context);

    debugPrint('getPerformanceValidationByUserId status: $userCheckStatusCode');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => PerformanceValidationDialog(pgs: widget.pgs, existing: data),
    ).then((saved) {
      if (saved == true) _loadValidations();
    });
  }

  void _showDeleteDialog(PerformanceValidationTool v) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Performance Validation',
            itemName: 'performance validation',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _performanceValidationService.deletePerformanceValidation(
                  v.id.toString(),
                );
                await _loadValidations();
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'Performance validation deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  description: Text(
                    'Failed to deleted performance validation tool',
                  ),
                ).show(context);
              }
            },
          ),
    );
  }

  Future<void> _openPrintPreview(PerformanceValidationTool v) async {
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
      final url = '${ApiEndpoint().performanceValidationPdfReport}/${v.id}';

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

        if (kIsWeb) {
          final blob = html.Blob([bytes], 'application/pdf');
          final blobUrl = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(blobUrl, '_blank');
          Future.delayed(const Duration(seconds: 15), () {
            html.Url.revokeObjectUrl(blobUrl);
          });
        } else if (Platform.isAndroid || Platform.isIOS) {
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/performance_validation_${v.id}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        } else {
          final dir =
              Platform.isWindows
                  ? await getDownloadsDirectory()
                  : await getApplicationDocumentsDirectory();
          final filePath = '${dir!.path}/performance_validation_${v.id}.pdf';
          await File(filePath).writeAsBytes(bytes);
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFile error: ${result.message}');
          }
        }
      }
    } catch (e) {
      debugPrint('Error opening Performance Validation PDF: $e');
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
                        ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                        : _filteredValidations.isEmpty
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
              Icons.fact_check_outlined,
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
                  'Performance Validation',
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
              permission: AppPermissions.addPerformanceValidationTool,
              child: TextButton.icon(
                onPressed: _checkingSignatory ? null : _openNewValidation,
                icon:
                    _checkingSignatory
                        ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.add, color: Colors.white, size: 18),
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
            permission: AppPermissions.addPerformanceValidationTool,
            child:
                _checkingSignatory
                    ? const Padding(
                      padding: EdgeInsets.all(6),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    )
                    : IconButton(
                      onPressed: _openNewValidation,
                      icon: const Icon(
                        Icons.add_circle,
                        color: primaryColor,
                        size: 30,
                      ),
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
        hintText: 'Search period...',
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
            'No performance validations yet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
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
        minWidth: 480,
        fixedTopRows: 1,
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade100),
        ),
        columns: const [
          DataColumn2(label: Text('#'), fixedWidth: 40),
          DataColumn2(label: Text('Period'), size: ColumnSize.L),
          DataColumn(label: Text('Actions')),
        ],
        rows:
            _filteredValidations.asMap().entries.map((entry) {
              final index = entry.key;
              final v = entry.value;

              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(
                    Text(
                      _periodLabel(v),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(_actionButtons(v)),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _filteredValidations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final v = _filteredValidations[index];

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
                child: Text(
                  _periodLabel(v),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              _actionButtons(v, compact: true),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButtons(PerformanceValidationTool v, {bool compact = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'View / Edit Validation',
          child: IconButton(
            icon: Icon(
              Icons.fact_check_outlined,
              size: compact ? 16 : 18,
              color: primaryColor,
            ),
            visualDensity: compact ? VisualDensity.compact : null,
            onPressed: () => _openSavedValidation(v),
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
            onPressed: () => _openPrintPreview(v),
          ),
        ),
        PermissionWidget(
          permission: AppPermissions.deletePerformanceValidationTool,
          child: Tooltip(
            message: 'Delete',
            child: IconButton(
              icon: Icon(
                CupertinoIcons.delete_simple,
                size: compact ? 16 : 18,
                color: Colors.red,
              ),
              visualDensity: compact ? VisualDensity.compact : null,
              onPressed: () => _showDeleteDialog(v),
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
          if (isMobile)
            PermissionWidget(
              permission: AppPermissions.addPerformanceValidationTool,
              child: TextButton.icon(
                onPressed: _checkingSignatory ? null : _openNewValidation,
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
            )
          else
            const SizedBox.shrink(),
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
