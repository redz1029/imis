// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_validation_tool/dialog/performance_validation_dialog.dart';
import 'package:imis/performance_validation_tool/models/performance_validation_tool.dart';
import 'package:imis/widgets/permission/permission_widget.dart';

class PerformanceValidationListDialog extends StatefulWidget {
  final PerformanceGovernanceSystem pgs;

  /// Fetch all saved validations for this PGS
  final Future<List<PerformanceValidationTool>> Function(String pgsId)
  onFetchAll;

  /// Fetch single validation by id (for edit)
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

  void _openNewValidation() {
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

    final data = await widget.onFetchById(v.id);
    if (!mounted) return;
    Navigator.pop(context);

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
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete this validation for '
              '"${widget.pgs.office.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
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
                  final success = await widget.onDelete(v.id);
                  if (mounted) {
                    if (success) {
                      await _loadValidations();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted successfully.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete.')),
                      );
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

  // ── build ──────────────────────────────────────────────────────────────
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
                        onPressed: _openNewValidation,
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

              // ── List body ──────────────────────────────────────────────
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
                              onDelete: () => _showDeleteDialog(v),
                            );
                          },
                        ),
              ),

              // ── Footer ─────────────────────────────────────────────────
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

// ── Row widget ───────────────────────────────────────────────────────────
class _ValidationRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _ValidationRow({
    required this.label,
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
                    Icons.reviews_outlined,
                    size: 20,
                    color: Colors.deepOrangeAccent,
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
