import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit/audit_approvals/models/audit_plan_approval.dart';
import 'package:imis/audit/audit_approvals/services/audit_plan_approval_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
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
  final CommonService _commonService = CommonService(Dio());

  bool _isLoading = true;
  String? _errorMessage;

  int? _resolvedAuditPlanId;
  List<AuditPlan> _allAuditPlans = [];

  List<AuditPlanApproval> _approvals = [];

  // Users are fetched once here and passed down to the editor dialog so
  // every "Add/Edit" open doesn't re-hit the network.
  List<User> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _resolvedAuditPlanId = widget.auditPlanId;
    _loadUsers();
    if (_resolvedAuditPlanId != null) {
      _loadApprovals();
    } else {
      _loadAuditPlanList();
    }
  }

  Future<void> _loadUsers() async {
    try {
      _allUsers = await _commonService.fetchUsers();
      if (mounted) setState(() {});
    } catch (e) {
      // Non-fatal for the list screen — only the editor dialog needs this,
      // and it will show its own error if the list is empty.
      debugPrintUsersError(e);
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
      builder: (context) => _ApprovalEditorDialog(
        existing: existing,
        allUsers: _allUsers,
      ),
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
      builder: (context) => AlertDialog(
        title: const Text('Delete Approval'),
        content: Text(
          'Remove the approval record from ${_approverLabel(approval.approverId)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: primaryThemeColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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

  /// Resolves a stored approverId (User.id GUID) to a display name, falling
  /// back to the raw id if the user list hasn't loaded yet or the id is
  /// stale/unknown.
  String _approverLabel(String approverId) {
    for (final u in _allUsers) {
      if (u.id == approverId) return u.fullName;
    }
    return 'Approver ($approverId)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Audit Plan Approvals'),
        backgroundColor: mainBgColor,
        leading: (_resolvedAuditPlanId != null && widget.auditPlanId == null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Audit Plans',
                onPressed: () => setState(() {
                  _resolvedAuditPlanId = null;
                  _approvals = [];
                  _errorMessage = null;
                }),
              )
            : null,
      ),
      floatingActionButton: _resolvedAuditPlanId == null
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
      body: _isLoading
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
              '${p.effectiveStatusName} • $dateRange',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: primaryThemeColor,
            ),
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
                        Expanded(
                          child: Text(
                            _approverLabel(approval.approverId),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
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

void debugPrintUsersError(Object e) {
  // Kept separate/tiny so it's obvious this is non-fatal telemetry, not
  // swallowed error handling.
  // ignore: avoid_print
  print('Failed to load users for approver dropdown: $e');
}

/// Add/Edit dialog. Returns the built [AuditPlanApproval] on save, or null
/// on cancel. The caller is responsible for setting auditPlanId before
/// persisting.
class _ApprovalEditorDialog extends StatefulWidget {
  final AuditPlanApproval? existing;
  final List<User> allUsers;

  const _ApprovalEditorDialog({this.existing, required this.allUsers});

  @override
  State<_ApprovalEditorDialog> createState() => _ApprovalEditorDialogState();
}

class _ApprovalEditorDialogState extends State<_ApprovalEditorDialog> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final _formKey = GlobalKey<FormState>();
  String? _selectedApproverId;
  late final TextEditingController _commentsController;
  late String _selectedAction;
  late DateTime _timestamp;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;

    // Only pre-select if that user id still exists in the fetched list —
    // otherwise leave it null so the validator catches a stale/deleted
    // approver instead of silently keeping an invalid selection.
    if (e != null &&
        widget.allUsers.any((u) => u.id == e.approverId)) {
      _selectedApproverId = e.approverId;
    }

    _commentsController = TextEditingController(text: e?.comments ?? '');
    _selectedAction = e?.action != null && _kApprovalActions.contains(e!.action)
        ? e.action!
        : _kApprovalActions.first;
    _timestamp = e?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
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

    final result = AuditPlanApproval(
      id: widget.existing?.id,
      auditPlanId: widget.existing?.auditPlanId ?? 0,
      approverId: _selectedApproverId!,
      action: _selectedAction,
      timestamp: _timestamp,
      comments: _commentsController.text.trim().isEmpty
          ? null
          : _commentsController.text.trim(),
      isDeleted: widget.existing?.isDeleted ?? false,
      rowVersion: widget.existing?.rowVersion,
    );

    Navigator.pop(context, result);
  }

  String _userLabel(User u) =>
      u.position != null && u.position!.trim().isNotEmpty
          ? '${u.fullName} — ${u.position}'
          : u.fullName;

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
              if (widget.allUsers.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'No users available — check your connection and reopen this dialog.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              DropdownButtonFormField<String>(
                initialValue: _selectedApproverId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Approver',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: widget.allUsers
                    .map(
                      (u) => DropdownMenuItem<String>(
                        value: u.id,
                        child: Text(
                          _userLabel(u),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedApproverId = val),
                validator: (val) =>
                    val == null ? 'Please select an approver' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedAction,
                decoration: const InputDecoration(
                  labelText: 'Action',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: _kApprovalActions
                    .map(
                      (a) => DropdownMenuItem<String>(value: a, child: Text(a)),
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