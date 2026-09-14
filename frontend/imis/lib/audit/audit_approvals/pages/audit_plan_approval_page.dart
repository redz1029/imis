import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit/audit_approvals/models/audit_plan_approval.dart';
import 'package:imis/audit/audit_approvals/services/audit_plan_approval_service.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/constant/constant.dart';

const List<String> _kApprovalActions = ['Pending', 'Approved', 'Rejected'];

class AuditPlanApprovalPage extends StatefulWidget {
  final int? auditPlanId;

  const AuditPlanApprovalPage({super.key, this.auditPlanId});

  @override
  State<AuditPlanApprovalPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<AuditPlanApprovalPage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final AuditPlanService _auditPlanService = AuditPlanService(Dio());
  final AuditPlanApprovalService _approvalService = AuditPlanApprovalService(
    Dio(),
  );

  bool _isLoading = true;
  String? _errorMessage;

  int? _resolvedAuditPlanId;
  List<AuditPlan> _allAuditPlans = [];

  List<AuditPlanApproval> _approvals = [];

  @override
  void initState() {
    super.initState();
    _resolvedAuditPlanId = widget.auditPlanId;
    if (_resolvedAuditPlanId != null) {
      _loadApprovals();
    } else {
      _loadAuditPlanList();
    }
  }

  Future<void> _loadAuditPlanList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _allAuditPlans = await _auditPlanService.getAllAuditPlans();
    } catch (e) {
      _errorMessage = 'Failed to load Audit Plans: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadApprovals() async {
    if (_resolvedAuditPlanId == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _approvals = await _approvalService.getByAuditPlanId(
        _resolvedAuditPlanId!,
      );
      _approvals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _errorMessage = 'Failed to load approvals: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openEditor({AuditPlanApproval? existing}) async {
    final result = await showDialog<AuditPlanApproval>(
      context: context,
      builder: (context) => _ApprovalEditorDialog(existing: existing),
    );
    if (result == null) return;

    result.auditPlanId = _resolvedAuditPlanId!;

    try {
      await _approvalService.createOrUpdateAuditPlanApproval(result);
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(
          existing == null ? 'Approval added' : 'Approval updated',
        ),
      ).show(context);
      await _loadApprovals();
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed to save: $e'),
      ).show(context);
    }
  }

  Future<void> _confirmDelete(AuditPlanApproval approval) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Approval'),
            content: Text(
              'Remove the approval record from Approver #${approval.approverId}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: primaryThemeColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirm != true) return;
    if (approval.id == null) return;

    try {
      final ok = await _approvalService.delete(approval.id!);
      if (!mounted) return;
      if (ok) {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: const Text('Approval deleted'),
        ).show(context);
        await _loadApprovals();
      } else {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text('Approval not found'),
        ).show(context);
      }
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed to delete: $e'),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Audit Plan Approvals'),
        backgroundColor: mainBgColor,
        leading:
            (_resolvedAuditPlanId != null && widget.auditPlanId == null)
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back to Audit Plans',
                  onPressed:
                      () => setState(() {
                        _resolvedAuditPlanId = null;
                        _approvals = [];
                        _errorMessage = null;
                      }),
                )
                : null,
      ),
      floatingActionButton:
          _resolvedAuditPlanId == null
              ? null
              : FloatingActionButton.extended(
                backgroundColor: primaryThemeColor,
                onPressed: () => _openEditor(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Approver',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: primaryThemeColor),
              )
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : _resolvedAuditPlanId == null
              ? _buildAuditPlanPicker()
              : _buildApprovalsList(),
    );
  }

  Widget _buildAuditPlanPicker() {
    if (_allAuditPlans.isEmpty) {
      return const Center(child: Text('No Audit Plans found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _allAuditPlans.length,
      itemBuilder: (context, i) {
        final p = _allAuditPlans[i];
        final dateRange =
            '${DateFormat('MMM d, yyyy').format(p.startDate)} – ${DateFormat('MMM d, yyyy').format(p.endDate)}';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              'Audit Plan #${p.id}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${p.planStatus} • $dateRange',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: const Icon(Icons.chevron_right, color: primaryThemeColor),
            onTap: () {
              setState(() => _resolvedAuditPlanId = p.id);
              _loadApprovals();
            },
          ),
        );
      },
    );
  }

  Widget _buildApprovalsList() {
    if (_approvals.isEmpty) {
      return const Center(
        child: Text('No approvers added yet. Tap "Add Approver" to start.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: _approvals.length,
      itemBuilder: (context, i) {
        final approval = _approvals[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Approver #${approval.approverId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _statusChip(approval.action),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'MMM d, yyyy • h:mm a',
                      ).format(approval.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (approval.comments != null &&
                        approval.comments!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        approval.comments!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: primaryThemeColor,
                  size: 20,
                ),
                tooltip: 'Edit',
                onPressed: () => _openEditor(existing: approval),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(approval),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusChip(String? action) {
    Color color;
    switch (action) {
      case 'Approved':
        color = Colors.green;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        action ?? 'Pending',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Add/Edit dialog. Returns the built [AuditPlanApproval] on save, or null
/// on cancel. The caller is responsible for setting auditPlanId before
/// persisting.
class _ApprovalEditorDialog extends StatefulWidget {
  final AuditPlanApproval? existing;

  const _ApprovalEditorDialog({this.existing});

  @override
  State<_ApprovalEditorDialog> createState() => _ApprovalEditorDialogState();
}

class _ApprovalEditorDialogState extends State<_ApprovalEditorDialog> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _approverIdController;
  late final TextEditingController _commentsController;
  late String _selectedAction;
  late DateTime _timestamp;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _approverIdController = TextEditingController(
      text: e != null ? e.approverId.toString() : '',
    );
    _commentsController = TextEditingController(text: e?.comments ?? '');
    _selectedAction =
        e?.action != null && _kApprovalActions.contains(e!.action)
            ? e.action!
            : _kApprovalActions.first;
    _timestamp = e?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
    _approverIdController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _pickTimestamp() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryThemeColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;
    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timestamp),
    );
    if (pickedTime == null) return;

    setState(() {
      _timestamp = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final approverId = int.parse(_approverIdController.text.trim());

    final result = AuditPlanApproval(
      id: widget.existing?.id,
      auditPlanId: widget.existing?.auditPlanId ?? 0,
      approverId: approverId,
      action: _selectedAction,
      timestamp: _timestamp,
      comments:
          _commentsController.text.trim().isEmpty
              ? null
              : _commentsController.text.trim(),
      isDeleted: widget.existing?.isDeleted ?? false,
      rowVersion: widget.existing?.rowVersion,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Approval' : 'Add Approver'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _approverIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Approver ID',
                  helperText:
                      'Numeric ID of the approver record (not linked to '
                      'the user list yet — enter the correct ID directly).',
                  helperMaxLines: 3,
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return 'Approver ID is required';
                  if (int.tryParse(trimmed) == null) {
                    return 'Must be a whole number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedAction,
                decoration: const InputDecoration(
                  labelText: 'Action',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items:
                    _kApprovalActions
                        .map(
                          (a) => DropdownMenuItem<String>(
                            value: a,
                            child: Text(a),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAction = val);
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickTimestamp,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Timestamp',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM d, yyyy • h:mm a').format(_timestamp),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: primaryThemeColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comments (optional)',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: primaryThemeColor),
          child: Text(
            isEdit ? 'Save' : 'Add',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
