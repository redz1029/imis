// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_checklist/models/audit_checklist.dart';
import 'package:imis/ISO/IQA/audit_checklist/pages/audit_checklist_page.dart';
import 'package:imis/ISO/IQA/audit_checklist/pages/audit_checklist_print_preview_page.dart';
import 'package:imis/ISO/IQA/audit_checklist/services/audit_checklist_service.dart';
import 'package:imis/ISO/IQA/audit_programme/services/audit_programme_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

/// One entry of the top-level list ("IQA Checklist · Ref# · Year"). It groups
/// the team checklists that belong together.
class _ChecklistBook {
  _ChecklistBook({
    required this.key,
    required this.refNo,
    required this.year,
    required this.items,
  });

  final String key;
  final String refNo;
  final int? year;
  final List<AuditChecklistSummary> items;
}

// -----------------------------------------------------------------------------
// Grouping helpers. The schedule summary is read through its JSON form so this
// page keeps compiling whatever extra fields the model has.
// -----------------------------------------------------------------------------
Map<String, dynamic> _summaryJson(AuditChecklistSummary s) {
  try {
    final raw = (s as dynamic).toJson();
    if (raw is Map) return Map<String, dynamic>.from(raw);
  } catch (_) {
    // The model has no toJson(): no extra fields are available.
  }
  return const <String, dynamic>{};
}

Object? _pickKey(Map<String, dynamic> json, List<String> keys) {
  for (final k in keys) {
    final pascal = k[0].toUpperCase() + k.substring(1);
    final v = json[k] ?? json[pascal];
    if (v != null && v.toString().trim().isNotEmpty) return v;
  }
  return null;
}

String? _refFromJson(Map<String, dynamic> json) {
  final v = _pickKey(json, const [
    'auditProgrammeId',
    'programmeId',
    'auditPlanId',
    'planId',
  ]);
  final text = v?.toString().trim();
  if (text == null || text.isEmpty || text == '0') return null;
  return text;
}

int? _yearFromJson(Map<String, dynamic> json) {
  final direct = _pickKey(json, const ['year', 'auditYear']);
  final y = int.tryParse('${direct ?? ''}');
  if (y != null && y > 1900) return y;

  final date = _pickKey(json, const [
    'scheduleDate',
    'scheduledDate',
    'auditDate',
    'dateOfAudit',
    'startDate',
    'date',
    'time',
  ]);
  return DateTime.tryParse('${date ?? ''}')?.year;
}

class AuditChecklistListPage extends StatefulWidget {
  const AuditChecklistListPage({super.key});

  @override
  State<AuditChecklistListPage> createState() => _AuditChecklistListPageState();
}

class _AuditChecklistListPageState extends State<AuditChecklistListPage> {
  static const List<String> _statusTabs = ['All', 'Confirmed', 'Approved'];

  /// Name shown on the top-level list.
  static const String _bookTitle = 'IQA Checklist';

  final AuditChecklistService _service = AuditChecklistService(Dio());
  final AuditProgrammeService _programmeService = AuditProgrammeService(Dio());

  bool _isLoading = false;
  String? _error;
  List<AuditChecklistSummary> _schedules = [];
  List<_ChecklistBook> _books = [];
  Map<int, int> _programmeYears = {};

  // Level 1 (checklists) state.
  String _bookTab = 'All';
  int _bookPage = 1;

  // Level 2 (team checklists inside one checklist) state.
  String? _openBookKey;
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------
  Future<void> _loadSchedules() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final schedules = await _service.getSchedulesWithChecklistData();

      // Best effort: programme years let a checklist show its year when the
      // schedule data only carries the programme reference.
      final years = <int, int>{};
      try {
        final programmes = await _programmeService.getAllAuditProgrammes();
        for (final p in programmes) {
          final j = p.toJson();
          final y = int.tryParse('${j['year'] ?? j['Year'] ?? ''}');
          if (y != null) years[p.id] = y;
        }
      } catch (e) {
        debugPrint('Audit checklist: could not load programme years: $e');
      }

      if (mounted) {
        setState(() {
          _schedules = schedules;
          _programmeYears = years;
          _rebuildBooks();
          _ensureBookPageInRange();
          _ensurePageInRange();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Unable to load audit checklist. ${e.toString().replaceFirst('Exception: ', '')}';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _rebuildBooks() {
    final map = <String, _ChecklistBook>{};
    for (final s in _schedules) {
      final json = _summaryJson(s);
      final ref = _refFromJson(json);
      var year = _yearFromJson(json);
      final refId = int.tryParse(ref ?? '');
      if (year == null && refId != null) year = _programmeYears[refId];

      final key =
          ref != null ? 'ref:$ref' : (year != null ? 'year:$year' : 'all');
      final book = map.putIfAbsent(
        key,
        () => _ChecklistBook(
          key: key,
          refNo: ref ?? '—',
          year: year,
          items: <AuditChecklistSummary>[],
        ),
      );
      book.items.add(s);
    }
    final list = map.values.toList()
      ..sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
    _books = list;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  String _statusOf(AuditChecklistSummary s) =>
      (s.statusName?.isNotEmpty ?? false) ? s.statusName! : 'Confirmed';

  String _titleOf(AuditChecklistSummary s) {
    final process =
        (s.officeProcess?.isNotEmpty ?? false) ? s.officeProcess! : '';
    final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '';
    if (process.isNotEmpty) return process;
    if (teamName.isNotEmpty) return teamName;
    return 'Schedule #${s.auditScheduleId}';
  }

  String _bookStatus(_ChecklistBook b) =>
      b.items.isNotEmpty && b.items.every((s) => _statusOf(s) == 'Approved')
          ? 'Approved'
          : 'Confirmed';

  String _yearText(_ChecklistBook b) => b.year?.toString() ?? '—';

  _ChecklistBook? get _openBook {
    final key = _openBookKey;
    if (key == null) return null;
    for (final b in _books) {
      if (b.key == key) return b;
    }
    return null;
  }

  // ---- level 1 ---------------------------------------------------------------
  int _countForBookTab(String tab) {
    if (tab == 'All') return _books.length;
    return _books.where((b) => _bookStatus(b) == tab).length;
  }

  List<_ChecklistBook> get _filteredBooks {
    if (_bookTab == 'All') return _books;
    return _books.where((b) => _bookStatus(b) == _bookTab).toList();
  }

  List<_ChecklistBook> get _pagedBooks {
    final filtered = _filteredBooks;
    final start = (_bookPage - 1) * _pageSize;
    if (start >= filtered.length) return [];
    final end = (start + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  void _ensureBookPageInRange() {
    final total = _filteredBooks.length;
    final maxPage = total == 0 ? 1 : ((total + _pageSize - 1) ~/ _pageSize);
    if (_bookPage > maxPage) _bookPage = maxPage;
    if (_bookPage < 1) _bookPage = 1;
  }

  void _selectBookTab(String tab) {
    setState(() {
      _bookTab = tab;
      _bookPage = 1;
    });
  }

  void _openBookEntry(_ChecklistBook b) {
    setState(() {
      _openBookKey = b.key;
      _selectedTab = 'All';
      _currentPage = 1;
    });
  }

  void _closeBook() {
    setState(() {
      _openBookKey = null;
      _selectedTab = 'All';
      _currentPage = 1;
    });
  }

  // ---- level 2 ---------------------------------------------------------------
  List<AuditChecklistSummary> get _currentItems =>
      _openBook?.items ?? const <AuditChecklistSummary>[];

  int _countFor(String tab) {
    final items = _currentItems;
    if (tab == 'All') return items.length;
    return items.where((s) => _statusOf(s) == tab).length;
  }

  List<AuditChecklistSummary> get _filtered {
    final items = _currentItems;
    if (_selectedTab == 'All') return items;
    return items.where((s) => _statusOf(s) == _selectedTab).toList();
  }

  List<AuditChecklistSummary> get _paged {
    final filtered = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    if (start >= filtered.length) return [];
    final end = (start + _pageSize).clamp(0, filtered.length);
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

  // ---- actions ---------------------------------------------------------------
  Future<void> _openChecklist(AuditChecklistSummary s) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditChecklistPage(
        auditScheduleId: s.auditScheduleId,
        summary: s,
      ),
    );
    if (mounted) _loadSchedules();
  }

  void _printPreview(AuditChecklistSummary s) {
    if (s.auditScheduleId <= 0) {
      MotionToast.warning(
        description: const Text('This checklist has no schedule to print.'),
      ).show(context);
      return;
    }
    openAuditChecklistPrintPreview(context, s.auditScheduleId);
  }

  // ---------------------------------------------------------------------------
  // Shared widgets (same look as the Audit Programme list)
  // ---------------------------------------------------------------------------
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

  Widget _buildTab({
    required String tab,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
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
                tab,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? primaryColor : kMuted,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
      ),
    );
  }

  Widget _refreshButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _loadSchedules,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      icon: const Icon(Icons.refresh, color: Colors.white),
      label: const Text('Refresh', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _cardShell({required Widget child}) {
    return Container(
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
      child: child,
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
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final inTeamList = _openBook != null;

    return PopScope(
      canPop: !inTeamList,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _closeBook();
      },
      child: Scaffold(
        body: inTeamList ? _buildTeamsBody() : _buildBooksBody(),
      ),
    );
  }

  // ===========================================================================
  // LEVEL 1 — list of checklists ("IQA Checklist · Ref# · Year")
  // ===========================================================================
  Widget _buildBooksBody() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final paged = _pagedBooks;
    final filteredTotal = _filteredBooks.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageHeader(
            isMobile: isMobile,
            title: 'Audit Checklist',
            totalCount: _books.length,
            itemLabel: 'checklist',
            icon: Icons.checklist_rtl,
            actionButton: _refreshButton(),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusTabs
                  .map(
                    (tab) => _buildTab(
                      tab: tab,
                      count: _countForBookTab(tab),
                      isActive: tab == _bookTab,
                      onTap: () => _selectBookTab(tab),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _cardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile) _buildBooksHeaderRow(),
                  if (!isMobile) const Divider(height: 1, color: kBorder),
                  Expanded(child: _buildBooksContent(paged, isMobile)),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PaginationInfo(
                          currentPage: _bookPage,
                          totalItems: filteredTotal,
                          itemsPerPage: _pageSize,
                        ),
                        PaginationControls(
                          currentPage: _bookPage,
                          totalItems: filteredTotal,
                          itemsPerPage: _pageSize,
                          isLoading: _isLoading,
                          onPageChanged: (page) =>
                              setState(() => _bookPage = page),
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

  Widget _buildBooksHeaderRow() {
    const style = TextStyle(fontWeight: FontWeight.w600, color: kMuted);
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('#', style: style)),
          Expanded(flex: 3, child: Text('Checklist', style: style)),
          Expanded(flex: 2, child: Text('Ref #', style: style)),
          SizedBox(width: 90, child: Text('Year', style: style)),
          SizedBox(width: 90, child: Text('Teams', style: style)),
          Expanded(flex: 2, child: Text('Status', style: style)),
          SizedBox(width: 120, child: Text('Actions', style: style)),
        ],
      ),
    );
  }

  Widget _buildBooksContent(List<_ChecklistBook> paged, bool isMobile) {
    if (_isLoading && _schedules.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    if (_error != null) {
      return _messageView(
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
        message: _error!,
        messageColor: Colors.red,
        actionLabel: 'RETRY',
        onAction: _loadSchedules,
      );
    }
    if (paged.isEmpty) {
      return Center(
        child: Text(
          'No audit checklists found.\nConfirm an Audit Schedule that has ISO clauses assigned to generate its checklist.',
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
        final b = paged[index];
        final rowNumber = (_bookPage - 1) * _pageSize + index + 1;
        return isMobile
            ? _buildBookMobileRow(b)
            : _buildBookDesktopRow(b, rowNumber);
      },
    );
  }

  Widget _buildBookDesktopRow(_ChecklistBook b, int rowNumber) {
    return InkWell(
      onTap: () => _openBookEntry(b),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: Text('$rowNumber')),
            const Expanded(
              flex: 3,
              child: Text(
                _bookTitle,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(flex: 2, child: Text('Ref# ${b.refNo}')),
            SizedBox(width: 90, child: Text(_yearText(b))),
            SizedBox(width: 90, child: Text('${b.items.length}')),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildStatusChip(_bookStatus(b)),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Open team checklists',
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _openBookEntry(b),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookMobileRow(_ChecklistBook b) {
    return InkWell(
      onTap: () => _openBookEntry(b),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    _bookTitle,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Ref# ${b.refNo} • ${_yearText(b)} • ${b.items.length} team(s)',
                    style: const TextStyle(fontSize: 12, color: kMuted),
                  ),
                  const SizedBox(height: 5),
                  _buildStatusChip(_bookStatus(b)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: Theme.of(context).cardColor,
              icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
              onSelected: (value) {
                if (value == 'open') _openBookEntry(b);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'open',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Open team checklists'),
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
  // LEVEL 2 — the team checklists inside one checklist
  // ===========================================================================
  Widget _buildTeamsBody() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final book = _openBook!;
    final paged = _paged;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPageHeader(
            isMobile: isMobile,
            title: '$_bookTitle • Ref# ${book.refNo} • ${_yearText(book)}',
            totalCount: book.items.length,
            itemLabel: 'team checklist',
            icon: Icons.checklist_rtl,
            actionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: _closeBook,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: primaryColor,
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                const SizedBox(width: 8),
                _refreshButton(),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusTabs
                  .map(
                    (tab) => _buildTab(
                      tab: tab,
                      count: _countFor(tab),
                      isActive: tab == _selectedTab,
                      onTap: () => _selectTab(tab),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _cardShell(
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
                          isLoading: _isLoading,
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
          SizedBox(width: 120, child: Text('Actions', style: style)),
        ],
      ),
    );
  }

  Widget _buildListContent(List<AuditChecklistSummary> paged, bool isMobile) {
    if (_isLoading && _schedules.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }
    if (_error != null) {
      return _messageView(
        icon: Icons.error_outline,
        iconColor: Colors.redAccent,
        message: _error!,
        messageColor: Colors.red,
        actionLabel: 'RETRY',
        onAction: _loadSchedules,
      );
    }
    if (paged.isEmpty) {
      return Center(
        child: Text(
          'No audit checklists found',
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
        return isMobile ? _buildMobileRow(s) : _buildDesktopRow(s, rowNumber);
      },
    );
  }

  Widget _buildDesktopRow(AuditChecklistSummary s, int rowNumber) {
    final teamName = (s.teamName?.isNotEmpty ?? false) ? s.teamName! : '—';

    return InkWell(
      onTap: () => _openChecklist(s),
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
              width: 120,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Open checklist',
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _openChecklist(s),
                  ),
                  IconButton(
                    tooltip: 'Print preview',
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                    onPressed: () => _printPreview(s),
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
      onTap: () => _openChecklist(s),
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
                if (value == 'open') _openChecklist(s);
                if (value == 'print') _printPreview(s);
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
                PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Print preview'),
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
}