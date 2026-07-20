// ignore_for_file: use_build_context_synchronously

import 'dart:io';
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

  /// Delete
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
  bool _isLoading = true;
  bool _checkingSignatory = false;
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

  Future<void> _loadValidations() async {
    setState(() => _isLoading = true);
    final list = await widget.onFetchAll(widget.pgs.id.toString());
    if (mounted) {
      setState(() {
        _validations = list;
        _isLoading = false;
      });
    }
  }

  String _validationLabel(PerformanceValidationTool v) {
    final office = widget.pgs.office.name;
    if (v.validateDate != null) {
      return '$office — ${_months[v.validateDate!.month]} ${v.validateDate!.year}';
    }
    return office;
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
              // ── Header ─────────────────────────────────────────────────
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
                              Icons.fact_check_outlined,
                              color: primaryColor,
                              size: isMobile ? 18 : 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Performance Validation',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PermissionWidget(
                      permission: AppPermissions.addPerformanceValidationTool,
                      child: TextButton.icon(
                        onPressed:
                            _checkingSignatory ? null : _openNewValidation,
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
                                : const Icon(
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
                        : _validations.isEmpty
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
                                'No performance validations yet.',
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
                          itemCount: _validations.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final v = _validations[i];
                            return _ValidationRow(
                              label: _validationLabel(v),
                              onTap: () => _openSavedValidation(v),
                              onPrintPreview: () => _openPrintPreview(v),
                              onDelete: () => _showDeleteDialog(v),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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

class _ValidationRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onPrintPreview;

  final VoidCallback? onDelete;

  const _ValidationRow({
    required this.label,
    this.onPrintPreview,
    required this.onTap,
    this.onDelete,
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
                message: 'View / Edit Validation',
                child: IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.fact_check_outlined,
                    size: 20,
                    color: primaryColor,
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
                permission: AppPermissions.deletePerformanceValidationTool,
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
