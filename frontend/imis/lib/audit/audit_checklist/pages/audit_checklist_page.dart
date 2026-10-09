// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_checklist/models/audit_checklist.dart';
import 'package:imis/audit/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

enum _RowFilter { all, pending, conforming, nonConforming }

class AuditChecklistPage extends StatefulWidget {
  /// Optional. When provided, the page loads this schedule's checklist
  /// directly. When null/0, the page shows the schedule (team) list.
  final int auditScheduleId;

  const AuditChecklistPage({super.key, this.auditScheduleId = 0});

  @override
  State<AuditChecklistPage> createState() => _AuditChecklistPageState();
}

class _AuditChecklistPageState extends State<AuditChecklistPage> {
  static const List<String> _statusTabs = ['All', 'Confirmed', 'Approved'];
  static const double _wideBreakpoint = 860;
  static const double _panelMaxWidth = 1100;
  static const String _formCode = 'QP-03-F-05 Rev. 0';
  static const Color _panelBg = Color(0xFFF4F6F8);

  final AuditChecklistService _service = AuditChecklistService(Dio());

  // List (schedule) mode state.
  bool _isLoadingSchedules = false;
  String? _listError;
  List<AuditChecklistSummary> _schedules = [];
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;

  // Detail (checklist) mode state.
  int _currentAuditScheduleId = 0;
  AuditChecklistSummary? _summary;
  bool _isLoadingChecklist = false;
  String? _checklistError;
  bool _noClauses = false;
  List<AuditChecklist> _rows = [];
  final Map<int, TextEditingController> _remarksControllers = {};
  final Map<int, TextEditingController> _itemsControllers = {};
  final TextEditingController _auditeeTextController = TextEditingController();
  bool _isSaving = false;
  bool _dirty = false;
  _RowFilter _filter = _RowFilter.all;

  bool get _inDetailMode => _currentAuditScheduleId > 0;

  // ---------------------------------------------------------------------------
  // Derived values
  // ---------------------------------------------------------------------------
  int get _conformingCount => _rows.where((r) => r.conforming == true).length;
  int get _nonConformingCount => _rows.where((r) => r.conforming == false).length;
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

  String get _officeProcessText {
    final h = _rows.first;
    return (h.officeProcess?.isNotEmpty ?? false)
        ? h.officeProcess!
        : (_summary?.officeProcess ?? '');
  }

  String get _scopeText {
    final h = _rows.first;
    return (h.auditScope?.isNotEmpty ?? false)
        ? h.auditScope!
        : (_summary?.auditScope ?? '');
  }

  // The checklist row can come back without auditors; the schedule list
  // summary resolves the team from the schedule itself, so fall back to it.
  String get _auditorsText {
    final fromRow = (_rows.first.auditorNames ?? '').trim();
    if (fromRow.isNotEmpty) return fromRow;
    return (_summary?.auditorNames ?? '').trim();
  }

  bool get _canGoBack =>
      widget.auditScheduleId == 0 || Navigator.of(context).canPop();

  String _statusOf(AuditChecklistSummary s) =>
      (s.statusName?.isNotEmpty ?? false) ? s.statusName! : 'Confirmed';

  String _titleOf(AuditChecklistSummary s) {
    final process = (s.officeProcess?.isNotEmpty ?? false) ? s.officeProcess! : '';
    final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '';
    // The department/office is the human-friendly identity of a confirmed
    // checklist; fall back to the team, then the schedule id.
    if (process.isNotEmpty) return process;
    if (teamName.isNotEmpty) return teamName;
    return 'Schedule #${s.auditScheduleId}';
  }

  int _countFor(String tab) {
    if (tab == 'All') return _schedules.length;
    return _schedules.where((s) => _statusOf(s) == tab).length;
  }

  List<AuditChecklistSummary> get _filtered {
    if (_selectedTab == 'All') return _schedules;
    return _schedules.where((s) => _statusOf(s) == _selectedTab).toList();
  }

  List<AuditChecklistSummary> get _paged {
    final filtered = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    if (start >= filtered.length) return [];
    var end = start + _pageSize;
    if (end > filtered.length) end = filtered.length;
    return filtered.sublist(start, end);
  }

  void _ensurePageInRange() {
    final total = _filtered.length;
    final maxPage = total == 0 ? 1 : ((total + _pageSize - 1) ~/ _pageSize);
    if (_currentPage > maxPage) _currentPage = maxPage;
    if (_currentPage < 1) _currentPage = 1;
  }

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
      _currentPage = 1;
    });
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _currentAuditScheduleId = widget.auditScheduleId;
    if (_currentAuditScheduleId > 0) {
      _loadChecklist(_currentAuditScheduleId);
    } else {
      _loadSchedules();
    }
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

  // Disposes controllers after the next frame so TextFields that are still
  // attached for one more frame never touch a disposed controller.
  void _disposeControllersLater() {
    final old = [
      ..._remarksControllers.values,
      ..._itemsControllers.values,
    ];
    _remarksControllers.clear();
    _itemsControllers.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in old) {
        c.dispose();
      }
    });
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  // ---------------------------------------------------------------------------
  // Data loading
  // ---------------------------------------------------------------------------
  Future<void> _loadSchedules() async {
    setState(() {
      _isLoadingSchedules = true;
      _listError = null;
    });
    try {
      final schedules = await _service.getSchedulesWithChecklistData();
      if (mounted) {
        setState(() {
          _schedules = schedules;
          _ensurePageInRange();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _listError =
            'Unable to load audit checklist. ${e.toString().replaceFirst('Exception: ', '')}');
      }
    } finally {
      if (mounted) setState(() => _isLoadingSchedules = false);
    }
  }

  Future<void> _loadChecklist(int auditScheduleId) async {
    setState(() {
      _isLoadingChecklist = true;
      _checklistError = null;
      _noClauses = false;
      _dirty = false;
      _filter = _RowFilter.all;
      _rows = [];
      _disposeControllersLater();
    });
    try {
      final rows = await _service.getOrGenerateForAuditSchedule(auditScheduleId);
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

      // Opened directly by schedule id: no list summary yet, so quietly load
      // it for the auditors / office / scope fallbacks.
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
        setState(() => _checklistError =
            'Unable to load audit checklist. ${e.toString().replaceFirst('Exception: ', '')}');
      }
    } finally {
      if (mounted) setState(() => _isLoadingChecklist = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  void _openSchedule(AuditChecklistSummary s) {
    setState(() {
      _summary = s;
      _currentAuditScheduleId = s.auditScheduleId;
    });
    _loadChecklist(s.auditScheduleId);
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

  /// Back from the checklist: returns to the schedule list when this page owns
  /// the list, otherwise pops the route (if there is one to pop).
  Future<void> _goBack() async {
    if (_dirty && !await _confirmDiscard()) return;
    if (!mounted) return;
    if (widget.auditScheduleId == 0) {
      setState(() {
        _currentAuditScheduleId = 0;
        _rows = [];
        _summary = null;
        _dirty = false;
        _disposeControllersLater();
      });
      _loadSchedules();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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

      for (var i = 0; i < _rows.length; i++) {
        final id = _rows[i].id;
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

        // If the server did not keep the typed Items/Questions, show what it
        // really holds instead of pretending the edit was saved.
        if (sentItems != null &&
            (saved.itemsAndQuestions ?? '').trim() != sentItems.trim()) {
          itemsNotStored++;
          _itemsControllers[id]?.text = saved.itemsAndQuestions ?? '';
        }
      }

      if (!mounted) return;
      setState(() => _dirty = false);
      if (itemsNotStored > 0) {
        MotionToast.warning(
          toastAlignment: Alignment.topCenter,
          description: Text(
            'Saved, but the server did not store edits to Items/Questions '
            'on $itemsNotStored clause(s).',
          ),
        ).show(context);
      } else {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: const Text('Checklist saved'),
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
  // Shared styling (copied from the Audit Programme form)
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

  Color _statusColor(String status) =>
      status == 'Approved' ? Colors.green.shade700 : Colors.blue.shade700;

  IconData _statusIcon(String status) => status == 'Approved'
      ? Icons.check_circle_outline
      : Icons.verified_outlined;

  Widget _buildStatusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            status,
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

  /// Rounded pill with a count badge (same look as the Audit Programme tabs).
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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Intercept back while a checklist is open and this page owns the list, or
    // while there are unsaved edits.
    final interceptBack =
        _inDetailMode && (widget.auditScheduleId == 0 || _dirty);

    return PopScope(
      canPop: !interceptBack,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        body: _inDetailMode ? _buildChecklistBody() : _buildListBody(),
      ),
    );
  }

  // ===========================================================================
  // LIST MODE — same layout as the Audit Programme list.
  // Generated dynamically from confirmed Audit Schedules, nothing hardcoded.
  // ===========================================================================
  Widget _buildListBody() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final paged = _paged;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageHeader(
            isMobile: isMobile,
            title: 'Audit Checklist',
            totalCount: _schedules.length,
            itemLabel: 'checklist',
            icon: Icons.checklist_rtl,
            actionButton: ElevatedButton.icon(
              onPressed: _isLoadingSchedules ? null : _loadSchedules,
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
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusTabs
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildPill(
                        label: tab,
                        count: _countFor(tab),
                        isActive: tab == _selectedTab,
                        onTap: () => _selectTab(tab),
                      ),
                    ),
                  )
                  .toList(),
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
                  if (!isMobile) _buildListHeaderRow(),
                  if (!isMobile) const Divider(height: 1, color: kBorder),
                  Expanded(child: _buildListContent(paged, isMobile)),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PaginationInfo(
                          currentPage: _currentPage,
                          totalItems: _filtered.length,
                          itemsPerPage: _pageSize,
                        ),
                        PaginationControls(
                          currentPage: _currentPage,
                          totalItems: _filtered.length,
                          itemsPerPage: _pageSize,
                          isLoading: _isLoadingSchedules,
                          onPageChanged: (page) =>
                              setState(() => _currentPage = page),
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
    );
  }

  Widget _buildListHeaderRow() {
    const style = TextStyle(fontWeight: FontWeight.w600, color: kMuted);
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('#', style: style)),
          Expanded(flex: 3, child: Text('Office / Process', style: style)),
          Expanded(flex: 2, child: Text('Team', style: style)),
          SizedBox(width: 80, child: Text('Clauses', style: style)),
          Expanded(flex: 2, child: Text('Status', style: style)),
          SizedBox(width: 80, child: Text('Actions', style: style)),
        ],
      ),
    );
  }

  Widget _buildListContent(List<AuditChecklistSummary> paged, bool isMobile) {
    if (_isLoadingSchedules && _schedules.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    if (_listError != null) {
      return _MessageView(
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
        message: _listError!,
        messageColor: Colors.red,
        actionLabel: 'RETRY',
        onAction: _loadSchedules,
      );
    }
    if (paged.isEmpty) {
      return Center(
        child: Text(
          _schedules.isEmpty
              ? 'No confirmed audit checklists found.\nConfirm an Audit Schedule that has ISO clauses assigned to generate its checklist.'
              : 'No audit checklists found',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(color: kMuted),
        ),
      );
    }

    return ListView.separated(
      itemCount: paged.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.withValues(alpha: 0.2),
      ),
      itemBuilder: (context, index) {
        final s = paged[index];
        final rowNumber = (_currentPage - 1) * _pageSize + index + 1;
        return isMobile
            ? _buildMobileRow(s)
            : _buildDesktopRow(s, rowNumber);
      },
    );
  }

  Widget _buildDesktopRow(AuditChecklistSummary s, int rowNumber) {
    final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '—';

    return InkWell(
      onTap: () => _openSchedule(s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: Text('$rowNumber')),
            Expanded(
              flex: 3,
              child: Text(
                _titleOf(s),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                teamName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 80, child: Text('${s.clauseCount}')),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildStatusChip(_statusOf(s)),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Open checklist',
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _openSchedule(s),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileRow(AuditChecklistSummary s) {
    final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '';
    final subtitle = <String>[
      if (teamName.isNotEmpty && teamName != _titleOf(s)) teamName,
      if (s.clauseCount > 0) '${s.clauseCount} clause(s)',
    ].join(' • ');

    return InkWell(
      onTap: () => _openSchedule(s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titleOf(s),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                  ],
                  const SizedBox(height: 5),
                  _buildStatusChip(_statusOf(s)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: Theme.of(context).cardColor,
              icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
              onSelected: (value) {
                if (value == 'open') _openSchedule(s);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'open',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Open checklist'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DETAIL MODE — the CRMC Audit Checklist form, in the Audit Programme
  // form's panel style (maroon header, section cards, footer actions).
  // ===========================================================================
  Widget _buildChecklistBody() {
    if (_isLoadingChecklist) return const _LoadingView();
    if (_checklistError != null) {
      return _MessageView(
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
        message: _checklistError!,
        messageColor: Colors.red,
        actionLabel: 'RETRY',
        onAction: () => _loadChecklist(_currentAuditScheduleId),
      );
    }
    if (_noClauses) {
      return _MessageView(
        icon: Icons.rule_folder_outlined,
        message: 'No ISO clauses are assigned to this audit schedule.',
        actionLabel: _canGoBack ? 'BACK' : null,
        onAction: _canGoBack ? _goBack : null,
      );
    }
    if (_rows.isEmpty) {
      return const _MessageView(
        icon: Icons.info_outline,
        message: 'Unable to load audit checklist.',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _panelMaxWidth),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: _panelBg,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withValues(alpha: .05),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPanelHeader(),
                Expanded(
                  child: LayoutBuilder(
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
                          _buildItemsCard(wide),
                        ],
                      );
                    },
                  ),
                ),
                _buildPanelFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanelHeader() {
    final office = _officeProcessText;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(_canGoBack ? 8 : 20, 12, 20, 12),
      color: primaryColor,
      child: Row(
        children: [
          if (_canGoBack)
            IconButton(
              tooltip: 'Back',
              onPressed: _goBack,
              splashRadius: 20,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
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
  Widget _buildPanelFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (_canGoBack) ...[
            TextButton(
              onPressed: _isSaving ? null : _goBack,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          ElevatedButton(
            onPressed: _isSaving ? null : _saveAll,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _dirty ? Icons.edit_note : Icons.check_circle_outline,
                    size: 16,
                    color:
                        _dirty ? Colors.orange.shade800 : Colors.green.shade700,
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

// =============================================================================
// Small reusable widgets
// =============================================================================
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: primaryColor),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String message;
  final Color? messageColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageView({
    required this.icon,
    required this.message,
    this.iconColor,
    this.messageColor,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  actionLabel!,
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
}