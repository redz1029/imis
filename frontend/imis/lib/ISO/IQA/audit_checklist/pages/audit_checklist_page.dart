// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_checklist/models/audit_checklist.dart';
import 'package:imis/ISO/IQA/audit_checklist/models/checklist_assignment.dart';
import 'package:imis/ISO/IQA/audit_checklist/pages/audit_checklist_print_preview_page.dart';
import 'package:imis/ISO/IQA/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:motion_toast/motion_toast.dart';

enum _RowFilter { all, pending, conforming, nonConforming }

/// The Audit Checklist form. Opened as a dialog from
/// [AuditChecklistListPage] (same pattern as AuditProgrammePage).
/// Pops with `true` when something was saved.
class AuditChecklistPage extends StatefulWidget {
  final int auditScheduleId;

  /// Optional list summary, used as a fallback for the header fields.
  final AuditChecklistSummary? summary;

  const AuditChecklistPage({
    super.key,
    required this.auditScheduleId,
    this.summary,
  });

  @override
  State<AuditChecklistPage> createState() => _AuditChecklistPageState();
}

class _AuditChecklistPageState extends State<AuditChecklistPage> {
  static const double _wideBreakpoint = 860;
  static const String _formCode = 'QP-03-F-05 Rev. 0';
  static const Color _panelBg = Color(0xFFF4F6F8);

  final AuditChecklistService _service = AuditChecklistService(Dio());

  AuditChecklistSummary? _summary;
  bool _isLoadingChecklist = true;
  String? _checklistError;
  bool _noClauses = false;
  List<AuditChecklist> _rows = [];
  final Map<int, TextEditingController> _remarksControllers = {};
  final Map<int, TextEditingController> _itemsControllers = {};
  final TextEditingController _auditeeTextController = TextEditingController();
  bool _isSaving = false;
  bool _dirty = false;
  bool _saved = false;
  _RowFilter _filter = _RowFilter.all;

  // Clause assignment (Team Leader -> Auditors). The draft maps a plan clause
  // id to the auditor picked in the dropdown (null = unassigned).
  ChecklistAssignments? _assignments;
  final Map<int, int?> _assignDraft = {};
  bool _isSavingAssignments = false;

  // ---------------------------------------------------------------------------
  // Derived values
  // ---------------------------------------------------------------------------
  int get _conformingCount => _rows.where((r) => r.conforming == true).length;
  int get _nonConformingCount =>
      _rows.where((r) => r.conforming == false).length;
  int get _pendingCount => _rows.where((r) => r.conforming == null).length;
  int get _answeredCount => _rows.length - _pendingCount;

  List<int> get _visibleIndices {
    final result = <int>[];
    for (var i = 0; i < _rows.length; i++) {
      final c = _rows[i].conforming;
      final show = switch (_filter) {
        _RowFilter.all => true,
        _RowFilter.pending => c == null,
        _RowFilter.conforming => c == true,
        _RowFilter.nonConforming => c == false,
      };
      if (show) result.add(i);
    }
    return result;
  }

  AuditChecklist? get _head => _rows.isEmpty ? null : _rows.first;

  String get _officeProcessText {
    final v = _head?.officeProcess;
    if (v != null && v.isNotEmpty) return v;
    return _summary?.officeProcess ?? '';
  }

  String get _scopeText {
    final v = _head?.auditScope;
    if (v != null && v.isNotEmpty) return v;
    return _summary?.auditScope ?? '';
  }

  // The checklist row can come back without auditors; the schedule list
  // summary resolves the team from the schedule itself, so fall back to it.
  String get _auditorsText {
    final fromRow = (_head?.auditorNames ?? '').trim();
    if (fromRow.isNotEmpty) return fromRow;
    return (_summary?.auditorNames ?? '').trim();
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _summary = widget.summary;
    _loadChecklist(widget.auditScheduleId);
  }

  @override
  void dispose() {
    for (final c in _remarksControllers.values) {
      c.dispose();
    }
    for (final c in _itemsControllers.values) {
      c.dispose();
    }
    _auditeeTextController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  // ---------------------------------------------------------------------------
  // Data loading
  // ---------------------------------------------------------------------------
  Future<void> _loadChecklist(int auditScheduleId) async {
    setState(() {
      _isLoadingChecklist = true;
      _checklistError = null;
      _noClauses = false;
      _dirty = false;
      _filter = _RowFilter.all;
    });
    try {
      final rows =
          await _service.getOrGenerateForAuditSchedule(auditScheduleId);
      if (!mounted) return;

      final remarks = <int, TextEditingController>{
        for (final r in rows)
          r.id: TextEditingController(text: r.findingAndRemarks ?? ''),
      };
      final items = <int, TextEditingController>{
        for (final r in rows)
          r.id: TextEditingController(text: r.itemsAndQuestions ?? ''),
      };

      setState(() {
        for (final c in _remarksControllers.values) {
          c.dispose();
        }
        for (final c in _itemsControllers.values) {
          c.dispose();
        }
        _remarksControllers
          ..clear()
          ..addAll(remarks);
        _itemsControllers
          ..clear()
          ..addAll(items);
        _rows = rows;
        if (rows.isEmpty) {
          _noClauses = true;
        } else {
          _auditeeTextController.text =
              rows.first.auditees ?? rows.first.auditeeName ?? '';
        }
      });

      await _loadAssignments();

      // No list summary supplied: quietly load it for the
      // auditors / office / scope fallbacks.
      if (_summary == null && rows.isNotEmpty) {
        try {
          final all = await _service.getSchedulesWithChecklistData();
          final match = all.where((s) => s.auditScheduleId == auditScheduleId);
          if (match.isNotEmpty && mounted) {
            setState(() => _summary = match.first);
          }
        } catch (_) {
          // Best effort only: the header just keeps showing "—".
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _checklistError =
              'Unable to load audit checklist. ${e.toString().replaceFirst('Exception: ', '')}';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingChecklist = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  Future<void> _loadAssignments() async {
    try {
      final loaded = await _service.getAssignments(widget.auditScheduleId);
      if (!mounted) return;
      setState(() {
        _assignments = loaded;
        _assignDraft
          ..clear()
          ..addEntries(
            loaded.clauses.map((c) => MapEntry(c.isoStandardId, c.assignedAuditorId)),
          );
      });
    } catch (e) {
      // The assignment board is an add-on: the checklist itself still works.
      debugPrint('Failed to load clause assignments: $e');
    }
  }

  bool get _assignDirty {
    final a = _assignments;
    if (a == null) return false;
    return a.clauses.any((c) => _assignDraft[c.isoStandardId] != c.assignedAuditorId);
  }

  Future<void> _saveAssignments() async {
    final a = _assignments;
    if (a == null || !_assignDirty) return;

    final changes = <int, int?>{
      for (final c in a.clauses)
        if (_assignDraft[c.isoStandardId] != c.assignedAuditorId)
          c.isoStandardId: _assignDraft[c.isoStandardId],
    };

    setState(() => _isSavingAssignments = true);
    try {
      await _service.saveAssignments(widget.auditScheduleId, changes);
      await _loadAssignments();
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: const Text('Clause assignments saved'),
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text(e.toString().replaceFirst('Exception: ', '')),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSavingAssignments = false);
    }
  }

  Future<bool> _confirmDiscard() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes on this checklist.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing',
                style: TextStyle(color: primaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _close() async {
    if (_dirty && !await _confirmDiscard()) return;
    if (!mounted) return;
    Navigator.pop(context, _saved);
  }

  void _openPrintPreview() {
    if (_dirty) {
      MotionToast.warning(
        toastAlignment: Alignment.topCenter,
        description: const Text(
          'Save the checklist first — the print preview shows the saved version.',
        ),
      ).show(context);
      return;
    }
    openAuditChecklistPrintPreview(context, widget.auditScheduleId);
  }

  void _setConforming(int index, bool? value) {
    setState(() {
      _rows[index] = _rows[index].copyWithResponse(
        conforming: value,
        clearConforming: value == null,
      );
      _dirty = true;
    });
  }

  Future<void> _saveAll() async {
    setState(() => _isSaving = true);
    try {
      final auditeeText = _auditeeTextController.text.trim();
      var itemsNotStored = 0;
      var ncarsCreated = 0;
      var ncarsUpdated = 0;
      var ncarsWithdrawn = 0;

      for (var i = 0; i < _rows.length; i++) {
        final id = _rows[i].id;
        final previous = _rows[i];
        final sentItems = _itemsControllers[id]?.text;

        var updated = _rows[i].copyWithResponse(
          findingAndRemarks: _remarksControllers[id]?.text,
          itemsAndQuestions: sentItems,
        );
        // Multi-value auditee string — saved as the checklist's display
        // auditee name (backend keeps it as a string).
        updated =
            updated.copyWithAuditees(auditeeText.isEmpty ? null : auditeeText);

        final saved = await _service.save(updated);
        _rows[i] = saved;

        // The server raises one NCAR per non-conforming clause: count what
        // this save did to it.
        if (previous.ncarId == null && saved.ncarId != null) {
          ncarsCreated++;
        } else if (previous.ncarId != null && saved.ncarId == null) {
          ncarsWithdrawn++;
        } else if (saved.ncarId != null &&
            (previous.findingAndRemarks ?? '').trim() !=
                (updated.findingAndRemarks ?? '').trim()) {
          ncarsUpdated++;
        }

        // If the server did not keep the typed Items/Questions, show what it
        // really holds instead of pretending the edit was saved.
        if (sentItems != null &&
            (saved.itemsAndQuestions ?? '').trim() != sentItems.trim()) {
          itemsNotStored++;
          _itemsControllers[id]?.text = saved.itemsAndQuestions ?? '';
        }
      }

      if (!mounted) return;
      setState(() {
        _dirty = false;
        _saved = true;
      });
      final ncarNotes = [
        if (ncarsCreated > 0) '$ncarsCreated NCAR(s) created',
        if (ncarsUpdated > 0) '$ncarsUpdated NCAR(s) updated',
        if (ncarsWithdrawn > 0) '$ncarsWithdrawn NCAR(s) withdrawn',
      ];
      final ncarSummary = ncarNotes.isEmpty ? '' : ' (${ncarNotes.join(', ')})';
      if (itemsNotStored > 0) {
        MotionToast.warning(
          toastAlignment: Alignment.topCenter,
          description: Text(
            'Saved$ncarSummary, but the server did not store edits to '
            'Items/Questions on $itemsNotStored clause(s).',
          ),
        ).show(context);
      } else {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: Text('Checklist saved$ncarSummary'),
        ).show(context);
      }
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed to save: $e'),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Shared styling (same as the Audit Programme form)
  // ---------------------------------------------------------------------------
  InputDecoration _inputDecoration(
    String? label, {
    String? hint,
    bool dense = false,
  }) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior:
          label == null ? null : FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        color: primaryColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFFBFBFB),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: dense ? 10 : 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return InputDecorator(
      isEmpty: false,
      decoration: _inputDecoration(label),
      child: Text(
        value.isEmpty ? '—' : value,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  /// Rounded pill with a count badge (same look as the list tabs).
  Widget _buildPill({
    required String label,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? primaryColor : kBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? primaryColor : kMuted,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : kBorder,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : kMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageView({
    required IconData icon,
    required String message,
    Color? iconColor,
    Color? messageColor,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: iconColor ?? kMuted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: messageColor ?? kMuted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build — dialog shell identical to AuditProgrammePage
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _close();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 960,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Expanded(child: _buildContent()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoadingChecklist) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    if (_checklistError != null) {
      return _messageView(
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
        message: _checklistError!,
        messageColor: Colors.red,
        actionLabel: 'RETRY',
        onAction: () => _loadChecklist(widget.auditScheduleId),
      );
    }
    if (_noClauses) {
      return _messageView(
        icon: Icons.rule_folder_outlined,
        message: _assignments?.ownClausesOnly == true
            ? 'No clauses have been assigned to you yet. Your Auditor Team '
                'Leader assigns the clauses of this checklist.'
            : 'No ISO clauses are assigned to this audit schedule.',
      );
    }
    if (_rows.isEmpty) {
      return _messageView(
        icon: Icons.info_outline,
        message: 'Unable to load audit checklist.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideBreakpoint;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildCard(
              title: 'CHECKLIST HEADER',
              child: _buildHeaderFields(),
            ),
            const SizedBox(height: 16),
            if (_assignments != null &&
                (_assignments!.canAssign || _assignments!.ownClausesOnly)) ...[
              _buildAssignmentsCard(),
              const SizedBox(height: 16),
            ],
            _buildItemsCard(wide),
          ],
        );
      },
    );
  }

  /// "Assign clauses" panel. The Team Leader divides the plan clauses among
  /// the team's auditors; an auditor only sees the clauses assigned to them.
  Widget _buildAssignmentsCard() {
    final a = _assignments!;
    final unassigned = a.clauses.where((c) => c.assignedAuditorId == null).length;

    return _buildCard(
      title: a.canAssign ? 'ASSIGN CLAUSES TO AUDITORS' : 'MY ASSIGNED CLAUSES',
      trailing: a.canAssign && unassigned > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unassigned unassigned',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final au in a.auditors)
                Chip(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: primaryColor.withValues(alpha: 0.08),
                  side: BorderSide.none,
                  label: Text(
                    '${au.name}${au.isTeamLeader ? ' (Team Leader)' : ''}: '
                    '${au.assignedClauseCount} clause(s) · '
                    '${au.answeredCount}/${au.questionCount} answered',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (a.clauses.isEmpty)
            const Text(
              'No clauses have been assigned to you yet.',
              style: TextStyle(fontSize: 12, color: kMuted),
            ),
          for (final c in a.clauses) _buildAssignmentRow(a, c),
          if (a.canAssign) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _assignDirty && !_isSavingAssignments
                    ? _saveAssignments
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: _isSavingAssignments
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'SAVE ASSIGNMENTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAssignmentRow(ChecklistAssignments a, ChecklistClauseAssignment c) {
    final isUnassigned = c.assignedAuditorId == null;
    final label = Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            c.clauseRef,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${c.particulars ?? ''}'
            '${c.questionCount > 0 ? '  (${c.answeredCount}/${c.questionCount} answered)' : ''}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );

    Widget trailing;
    if (a.canAssign) {
      trailing = SizedBox(
        width: 230,
        child: DropdownButtonFormField<int?>(
          key: ValueKey('${c.isoStandardId}-${c.assignedAuditorId}'),
          initialValue: _assignDraft[c.isoStandardId],
          isExpanded: true,
          decoration: _inputDecoration(null, dense: true),
          hint: const Text('Unassigned', style: TextStyle(fontSize: 12)),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Unassigned', style: TextStyle(fontSize: 12)),
            ),
            for (final au in a.auditors)
              DropdownMenuItem<int?>(
                value: au.auditorId,
                child: Text(
                  au.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
          onChanged: (v) => setState(() => _assignDraft[c.isoStandardId] = v),
        ),
      );
    } else {
      trailing = const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnassigned && a.canAssign
            ? Colors.orange.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isUnassigned && a.canAssign
              ? Colors.orange.shade300
              : Colors.grey.shade300,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (!a.canAssign) return label;
          if (constraints.maxWidth < 560) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [label, const SizedBox(height: 8), trailing],
            );
          }
          return Row(
            children: [
              Expanded(child: label),
              const SizedBox(width: 12),
              trailing,
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final office = _officeProcessText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AUDIT CHECKLIST',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                if (office.isNotEmpty)
                  Text(
                    office,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (_rows.isNotEmpty)
            IconButton(
              tooltip: 'Print Preview',
              onPressed: _openPrintPreview,
              splashRadius: 20,
              icon: const Icon(Icons.print_outlined, color: Colors.white),
            ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              _formCode,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _close,
            icon: const Icon(Icons.close, color: Colors.white),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final office = _readOnlyField('OFFICE/PROCESS', _officeProcessText);
            final scope = _readOnlyField('AUDIT SCOPE', _scopeText);
            if (c.maxWidth >= 560) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: office),
                  const SizedBox(width: 12),
                  Expanded(child: scope),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [office, const SizedBox(height: 12), scope],
            );
          },
        ),
        const SizedBox(height: 12),
        _readOnlyField('AUDITOR/S', _auditorsText),
        const SizedBox(height: 12),
        TextFormField(
          controller: _auditeeTextController,
          // The header is the Team Leader's: an auditor only answers clauses.
          readOnly: _assignments?.ownClausesOnly == true,
          onChanged: (_) => _markDirty(),
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            'AUDITEE/S',
            hint: 'e.g. Chief of Hospital, Medical Records Officer, Section Head',
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard(bool wide) {
    final indices = _visibleIndices;
    final total = _rows.length;
    final progress = total == 0 ? 0.0 : _answeredCount / total;

    return _buildCard(
      title: 'AUDIT CHECKLIST',
      trailing: Text(
        '$_answeredCount of $total answered',
        style: const TextStyle(fontSize: 12, color: kMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: primaryColor,
              backgroundColor: primaryColor.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPill(
                label: 'All',
                count: total,
                isActive: _filter == _RowFilter.all,
                onTap: () => setState(() => _filter = _RowFilter.all),
              ),
              _buildPill(
                label: 'Pending',
                count: _pendingCount,
                isActive: _filter == _RowFilter.pending,
                onTap: () => setState(() => _filter = _RowFilter.pending),
              ),
              _buildPill(
                label: 'Conforming',
                count: _conformingCount,
                isActive: _filter == _RowFilter.conforming,
                onTap: () => setState(() => _filter = _RowFilter.conforming),
              ),
              _buildPill(
                label: 'Non-conforming',
                count: _nonConformingCount,
                isActive: _filter == _RowFilter.nonConforming,
                onTap: () =>
                    setState(() => _filter = _RowFilter.nonConforming),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (indices.isEmpty)
            _buildNoMatch()
          else if (wide)
            _buildWideTable(indices)
          else
            Column(
              children: [for (final i in indices) _buildClauseCard(i)],
            ),
        ],
      ),
    );
  }

  Widget _buildNoMatch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          const Icon(Icons.filter_alt_off_outlined, size: 40, color: kMuted),
          const SizedBox(height: 8),
          const Text(
            'No clauses match this filter.',
            style: TextStyle(color: kMuted),
          ),
          TextButton(
            onPressed: () => setState(() => _filter = _RowFilter.all),
            child: const Text(
              'Show all',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Conforming control (shared by table + cards) -------------------------
  Widget _conformingControl(int index, {required bool longLabels}) {
    final value = _rows[index].conforming;
    final selectedBg =
        value == true ? Colors.green.shade100 : Colors.red.shade100;
    final selectedFg =
        value == true ? Colors.green.shade900 : Colors.red.shade900;

    return SegmentedButton<bool>(
      emptySelectionAllowed: true,
      multiSelectionEnabled: false,
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? selectedBg : null,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? selectedFg : null,
        ),
      ),
      segments: [
        ButtonSegment<bool>(
          value: true,
          label: Text(longLabels ? 'Conforming' : 'Y'),
          tooltip: 'Conforming',
        ),
        ButtonSegment<bool>(
          value: false,
          label: Text(longLabels ? 'Non-conforming' : 'N'),
          tooltip: 'Non-conforming',
        ),
      ],
      selected: value == null ? <bool>{} : <bool>{value},
      onSelectionChanged: (s) =>
          _setConforming(index, s.isEmpty ? null : s.first),
    );
  }

  // ---- WIDE layout: the CRMC form as an editable table ----------------------
  Widget _buildWideTable(List<int> indices) {
    Widget headerCell(String text) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: kMuted,
            ),
          ),
        );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kBorder),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        columnWidths: const {
          0: FixedColumnWidth(110),
          1: FlexColumnWidth(3),
          2: FixedColumnWidth(120),
          3: FlexColumnWidth(2.2),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF7F5F5)),
            children: [
              headerCell('CRITERIA/\nCLAUSE'),
              headerCell('ITEMS/QUESTIONS'),
              headerCell('CONFORMING\nY/N'),
              headerCell('FINDINGS/ REMARKS'),
            ],
          ),
          for (final i in indices) _buildWideRow(i),
        ],
      ),
    );
  }

  TableRow _buildWideRow(int index) {
    final row = _rows[index];
    final criteria = (row.criteria ?? '').trim();

    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              criteria.isEmpty ? '${index + 1}' : criteria,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _itemsControllers[row.id],
            onChanged: (_) => _markDirty(),
            minLines: 1,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 13, height: 1.35),
            decoration: _inputDecoration(
              null,
              hint: 'Type the item / question…',
              dense: true,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Center(child: _conformingControl(index, longLabels: false)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _remarksControllers[row.id],
            onChanged: (_) => _markDirty(),
            minLines: 1,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 13, height: 1.35),
            decoration: _inputDecoration(
              null,
              hint: 'Findings / remarks…',
              dense: true,
            ),
          ),
        ),
      ],
    );
  }

  // ---- NARROW layout: one card per clause -----------------------------------
  Widget _buildClauseCard(int index) {
    final row = _rows[index];
    final criteria = (row.criteria ?? '').trim();
    final accent = row.conforming == null
        ? Colors.grey.shade400
        : (row.conforming! ? Colors.green.shade600 : Colors.red.shade600);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            criteria.isEmpty ? 'Clause ${index + 1}' : criteria,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${index + 1}/${_rows.length}',
                          style: const TextStyle(fontSize: 11, color: kMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _itemsControllers[row.id],
                      onChanged: (_) => _markDirty(),
                      minLines: 1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 13, height: 1.35),
                      decoration: _inputDecoration(
                        'ITEMS / QUESTIONS',
                        hint: 'Type the item / question…',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _conformingControl(index, longLabels: true),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _remarksControllers[row.id],
                      onChanged: (_) => _markDirty(),
                      minLines: 2,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 13, height: 1.35),
                      decoration: _inputDecoration(
                        'FINDINGS / REMARKS',
                        hint: 'Findings / remarks…',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Footer (same structure as the Audit Programme form footer) -----------
  Widget _buildFooter() {
    // Only a role that may edit checklists can save one. Read-only roles
    // (QMR, QMS, Department Head) still see the form, just not the save.
    final canEdit = permissionService.hasPermission(
          AppPermissions.editAuditChecklist,
        ) ||
        permissionService.hasPermission(AppPermissions.addAuditChecklist);
    final canSave =
        canEdit && !_isSaving && !_isLoadingChecklist && _rows.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: _isSaving ? null : _close,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: canSave ? _saveAll : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'SAVE CHECKLIST',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _rows.isEmpty
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _dirty ? Icons.edit_note : Icons.check_circle_outline,
                          size: 16,
                          color: _dirty
                              ? Colors.orange.shade800
                              : Colors.green.shade700,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _dirty ? 'Unsaved changes' : 'All changes saved',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: _dirty
                                  ? Colors.orange.shade800
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}