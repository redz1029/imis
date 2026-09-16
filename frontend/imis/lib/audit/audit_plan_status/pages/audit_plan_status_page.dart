// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_plan_status/models/audit_plan_status.dart';
import 'package:imis/audit/audit_plan_status/services/audit_plan_status_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditPlanStatusPage extends StatefulWidget {
  const AuditPlanStatusPage({super.key});

  @override
  State<AuditPlanStatusPage> createState() => _AuditPlanStatusPageState();
}

class _AuditPlanStatusPageState extends State<AuditPlanStatusPage> {
  final _service = AuditPlanStatusService(Dio());
  final _formKey = GlobalKey<FormState>();

  List<AuditPlanStatus> _statusList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStatuses();
  }

  Future<void> _fetchStatuses({int? page}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      final pageList = await _service.getPaginated(
        page: targetPage,
        pageSize: _pageSize,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          _statusList = pageList.items;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showFormDialog({AuditPlanStatus? status}) {
    final isEdit = status != null;
    final codeController = TextEditingController(text: status?.code ?? '');
    final nameController = TextEditingController(text: status?.name ?? '');
    final sortOrderController = TextEditingController(
      text: (status?.sortOrder ?? 0).toString(),
    );
    bool isActive = status?.isActive ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.flag_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit
                                    ? 'Edit Audit Plan Status'
                                    : 'Create Audit Plan Status',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update this status'
                                    : 'Add a new status',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: kBorder, height: 1),
                      const SizedBox(height: 20),
                      dialogField(
                        label: 'Code',
                        controller: codeController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please fill out this field'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      dialogField(
                        label: 'Name',
                        controller: nameController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please fill out this field'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      dialogField(
                        label: 'Sort Order',
                        controller: sortOrderController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please fill out this field';
                          }
                          return int.tryParse(v.trim()) == null
                              ? 'Must be a whole number'
                              : null;
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: primaryColor,
                        title: Text(
                          'Active',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kText,
                          ),
                        ),
                        value: isActive,
                        onChanged: (v) => setStateDialog(() => isActive = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                isEdit ? Icons.save_rounded : Icons.add_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final newStatus = AuditPlanStatus(
                                  id: status?.id ?? 0,
                                  code: codeController.text.trim(),
                                  name: nameController.text.trim(),
                                  sortOrder: int.parse(
                                    sortOrderController.text.trim(),
                                  ),
                                  isActive: isActive,
                                  rowVersion: status?.rowVersion,
                                );

                                try {
                                  await _service.saveAuditPlanStatus(
                                    newStatus,
                                  );
                                  await _fetchStatuses();
                                  if (mounted) {
                                    Navigator.pop(context);
                                    MotionToast.success(
                                      toastAlignment: Alignment.topCenter,
                                      description: Text(
                                        isEdit
                                            ? 'Updated successfully'
                                            : 'Saved successfully',
                                      ),
                                    ).show(context);
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    MotionToast.error(
                                      description: Text(
                                        isEdit
                                            ? 'Failed to update status'
                                            : 'Failed to save status',
                                      ),
                                    ).show(context);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(AuditPlanStatus status) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Audit Plan Status',
        itemName: status.name,
        onDelete: () async {
          Navigator.pop(ctx);
          try {
            await _service.deleteAuditPlanStatus(status.id);
            await _fetchStatuses();
            if (mounted) {
              MotionToast.success(
                description: Text(
                  'Deleted successfully',
                  style: GoogleFonts.plusJakartaSans(),
                ),
              ).show(context);
            }
          } catch (e) {
            if (mounted) {
              MotionToast.error(
                description: Text(
                  e.toString().replaceFirst('Exception: ', ''),
                ),
              ).show(context);
            }
          }
        },
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    final color = isActive ? Colors.green.shade700 : kMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'Audit Plan Status',
              totalCount: _totalCount,
              itemLabel: 'status',
              icon: Icons.flag_outlined,
              actionButton: ElevatedButton.icon(
                onPressed: () => _showFormDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 40,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Sort Order',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 90,
                              child: Text(
                                'Actions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isMobile) const Divider(height: 1, color: kBorder),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : ListView.separated(
                              itemCount: _statusList.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                              itemBuilder: (context, index) {
                                final status = _statusList[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;

                                if (!isMobile) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text('$rowNumber'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            status.code,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(status.name),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text('${status.sortOrder}'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: _buildStatusChip(
                                            status.isActive,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    _showFormDialog(
                                                      status: status,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  CupertinoIcons.delete_simple,
                                                  size: 16,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () =>
                                                    _showDeleteDialog(status),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${status.code} — ${status.name}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            _buildStatusChip(status.isActive),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        color: Theme.of(context).cardColor,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.shade500,
                                        ),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showFormDialog(status: status);
                                          }
                                          if (value == 'delete') {
                                            _showDeleteDialog(status);
                                          }
                                        },
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons
                                                      .delete_simple,
                                                  color: Colors.redAccent,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) =>
                                _fetchStatuses(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => _showFormDialog(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
