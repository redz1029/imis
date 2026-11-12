import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/ncar/dialogs/ncar_attachments_dialog.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_form_page.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_monitoring_print_preview_page.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_print_preview_page.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/ISO/IQA/widgets/iqa_list_toolbar.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

class NcarListPage extends StatefulWidget {
  const NcarListPage({super.key});

  @override
  State<NcarListPage> createState() => _NcarListPageState();
}

class _NcarListPageState extends State<NcarListPage> {
  final NcarService _service = NcarService(Dio());

  List<NonconformingActionReport> _allNcars = [];
  bool _isLoading = true;
  String _selectedFilter = IqaStatus.all;
  DateTimeRange _range = IqaPeriod.currentYear();
  bool isAdmin = false;
  int _currentPage = 1;
  final int _pageSize = 15;

  /// The Service the list is narrowed to; null shows every Service.
  String? _serviceFilter;

  /// Stands for the NCARs whose office could not be placed under a Service.
  static const String _noService = '\u0000none';

  // Acknowledging and responding follow the permissions switched on for the
  // user in Settings > User Roles.
  bool _can(String permission) =>
      isAdmin || permissionService.hasPermission(permission);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      isAdmin = await AuthUtil.isCurrentUserAdmin();
      // One audit can raise many NCARs (one per non-conforming clause).
      final ncars = await _service.getAllNcars(pageSize: 500);
      if (mounted) {
        setState(() {
          _allNcars = ncars;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MotionToast.error(description: Text('Error loading NCARs: $e')).show(context);
      }
    }
  }

  // An NCAR belongs to the year of the audit that raised it.
  List<NonconformingActionReport> get _inPeriod =>
      _allNcars.where((n) => IqaPeriod.matches(_range, n.auditDate)).toList();

  bool _matchesService(NonconformingActionReport n) {
    final service = _serviceFilter;
    if (service == null) return true;
    if (service == _noService) return n.services.isEmpty;
    return n.services.contains(service);
  }

  // The period and the Service narrow the list; the tabs split what is left.
  List<NonconformingActionReport> get _inRange =>
      _inPeriod.where(_matchesService).toList();

  /// The Services that have NCARs in the chosen period, with how many each has.
  Map<String, int> get _serviceCounts {
    final counts = <String, int>{};
    for (final n in _inPeriod) {
      for (final s in n.services) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }
    return Map.fromEntries(
      counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  int get _withoutService => _inPeriod.where((n) => n.services.isEmpty).length;

  void _setService(String? service) => setState(() {
    _serviceFilter = service;
    _currentPage = 1;
  });

  bool _matchesTab(NonconformingActionReport n, String tab) {
    switch (tab) {
      case IqaStatus.open:
        return !n.isClosed && n.approvedDate == null;
      case IqaStatus.underMonitoring:
        return !n.isClosed && n.approvedDate != null;
      case IqaStatus.closed:
        return n.isClosed;
      default:
        return true;
    }
  }

  int _countFor(String tab) =>
      _inRange.where((n) => _matchesTab(n, tab)).length;

  // Sorted by office so the page cuts keep an office's NCARs together.
  List<NonconformingActionReport> get _filteredNcars {
    final list = _inRange.where((n) => _matchesTab(n, _selectedFilter)).toList();
    list.sort((a, b) => a.office.compareTo(b.office));
    return list;
  }

  /// The NCARs of the current page.
  List<NonconformingActionReport> _pageOf(List<NonconformingActionReport> all) {
    final start = (_currentPage - 1) * _pageSize;
    if (start >= all.length) return [];
    final end = (start + _pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  void _setRange(DateTimeRange range) => setState(() {
    _range = range;
    _currentPage = 1;
  });

  void _clearFilters() => setState(() {
    _range = IqaPeriod.currentYear();
    _selectedFilter = IqaStatus.all;
    _serviceFilter = null;
    _currentPage = 1;
  });

  /// Opens the NCAR form: the auditor writes the finding and verifies, the
  /// auditee acknowledges and answers, each in their own section.
  Future<void> _openForm(NonconformingActionReport ncar) async {
    final changed = await showNcarForm(context, ncar.id);
    if (changed && mounted) _loadData(silent: true);
  }

  Future<void> _acknowledgeNcar(NonconformingActionReport ncar) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acknowledge NCAR'),
        content: Text('Acknowledge receipt and responsibility for NCAR ${ncar.referenceNumber}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Acknowledge', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      // The server records the signed-in user and today's date.
      await _service.acknowledge(ncar.id);
      _loadData(silent: true);
      if (mounted) MotionToast.success(description: const Text('NCAR acknowledged.')).show(context);
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          description: Text(e.toString().replaceFirst('Exception: ', '')),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final ncars = _filteredNcars;

    // The chosen Service can vanish after a refresh or a change of period;
    // go back to all Services rather than filter by something not listed.
    final serviceCounts = _serviceCounts;
    final withoutService = _withoutService;
    if (_serviceFilter != null &&
        _serviceFilter != _noService &&
        !serviceCounts.containsKey(_serviceFilter)) {
      _serviceFilter = null;
    }
    if (_serviceFilter == _noService && withoutService == 0) _serviceFilter = null;

    // The last page can disappear after a refresh (e.g. an NCAR moved to
    // another tab); fall back to the last one that still exists.
    final lastPage = ncars.isEmpty ? 1 : ((ncars.length - 1) ~/ _pageSize) + 1;
    if (_currentPage > lastPage) _currentPage = lastPage;

    // How many NCARs each office has in the current tab (the group header).
    final officeTotals = <String, int>{};
    for (final n in ncars) {
      officeTotals[n.office] = (officeTotals[n.office] ?? 0) + 1;
    }

    // Grouped per office: an office can hold several NCARs from one audit.
    final byOffice = <String, List<NonconformingActionReport>>{};
    for (final n in _pageOf(ncars)) {
      byOffice.putIfAbsent(n.office, () => []).add(n);
    }
    final items = <Object>[
      for (final office in byOffice.keys) ...[office, ...byOffice[office]!],
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'Nonconforming Action Reports (NCAR)',
              totalCount: _inRange.length,
              itemLabel: 'report',
              icon: Icons.assignment_late_outlined,
              actionButton: ElevatedButton.icon(
                onPressed: () =>
                    openNcarMonitoringPrintPreview(context, period: _range),
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
                icon: const Icon(Icons.print_outlined, color: Colors.white),
                label: const Text(
                  'Monitoring Log',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            IqaPeriodFilter(
              range: _range,
              onChanged: _setRange,
              onClear: _clearFilters,
              hasOtherFilters: _serviceFilter != null,
              trailing: [
                _ServiceFilter(
                  selected: _serviceFilter,
                  counts: serviceCounts,
                  withoutService: withoutService,
                  noServiceValue: _noService,
                  total: _inPeriod.length,
                  onChanged: _setService,
                ),
              ],
            ),
            const SizedBox(height: 6),
            IqaStatusTabs(
              tabs: IqaStatus.ncar,
              selected: _selectedFilter,
              countOf: _countFor,
              onSelected: (tab) => setState(() {
                _selectedFilter = tab;
                _currentPage = 1;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : ncars.isEmpty
                      ? const Center(child: Text('No NCAR records found.'))
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            if (item is String) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                                child: Text(
                                  '${item.isEmpty ? 'No office' : item} • ${officeTotals[item] ?? 0} NCAR(s)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: primaryColor,
                                  ),
                                ),
                              );
                            }
                            final n = item as NonconformingActionReport;
                            final dateStr = DateFormat('MMM d, yyyy').format(n.auditDate);

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.red.shade200),
                                          ),
                                          child: Text(
                                            n.referenceNumber.isNotEmpty ? n.referenceNumber : 'NCAR #${n.id}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          n.office,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          n.statusDisplay,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: n.isClosed
                                                ? Colors.green.shade700
                                                : (n.approvedDate != null
                                                    ? Colors.blue.shade700
                                                    : Colors.orange.shade800),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text('${iqaReference('NCAR', n.auditDate.year)} • Standard: ${n.relevantStandard} • Audit Date: $dateStr${n.services.isEmpty ? '' : ' • Service: ${n.services.join(', ')}'}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                    if (n.auditChecklistId != null) ...[
                                      const SizedBox(height: 6),
                                      Text('Source clause ${n.relevantStandard}: ${n.standardRequirement}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                    ],
                                    const SizedBox(height: 6),
                                    Text('Finding: ${n.auditFindings}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13)),
                                    if (n.verificationDetails != null && n.verificationDetails!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text('Corrective Action: "${n.verificationDetails}"',
                                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade700)),
                                    ],
                                    const SizedBox(height: 12),
                                    Wrap(
                                      alignment: WrapAlignment.end,
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () => showNcarAttachmentsDialog(
                                            context,
                                            service: _service,
                                            ncar: n,
                                            canEdit: _can(AppPermissions.nonconformingActionReportRespond),
                                          ),
                                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                                          label: const Text('Pictures'),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () => openNcarPrintPreview(context, n.id),
                                          icon: const Icon(Icons.print_outlined, size: 16),
                                          label: const Text('Print'),
                                        ),
                                        if (!n.isClosed &&
                                            n.acknowledgedDate == null &&
                                            _can(AppPermissions.nonconformingActionReportAcknowledge))
                                          OutlinedButton.icon(
                                            onPressed: () => _acknowledgeNcar(n),
                                            icon: const Icon(Icons.check, size: 16),
                                            label: const Text('Acknowledge'),
                                          ),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                          onPressed: () => _openForm(n),
                                          icon: const Icon(Icons.edit_note, size: 18, color: Colors.white),
                                          label: const Text('Open Form', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                    totalItems: ncars.length,
                    itemsPerPage: _pageSize,
                  ),
                  PaginationControls(
                    currentPage: _currentPage,
                    totalItems: ncars.length,
                    itemsPerPage: _pageSize,
                    isLoading: _isLoading,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Service" dropdown of the NCAR list, styled like the period filter.
class _ServiceFilter extends StatelessWidget {
  const _ServiceFilter({
    required this.selected,
    required this.counts,
    required this.withoutService,
    required this.noServiceValue,
    required this.total,
    required this.onChanged,
  });

  final String? selected;
  final Map<String, int> counts;
  final int withoutService;
  final String noServiceValue;
  final int total;
  final ValueChanged<String?> onChanged;

  static const String _all = '\u0000all';

  @override
  Widget build(BuildContext context) {
    // value -> label
    final options = <MapEntry<String, String>>[
      MapEntry(_all, 'All Services ($total)'),
      for (final e in counts.entries) MapEntry(e.key, '${e.key} (${e.value})'),
      if (withoutService > 0)
        MapEntry(noServiceValue, 'No service ($withoutService)'),
    ];
    final current = options.any((o) => o.key == (selected ?? _all))
        ? (selected ?? _all)
        : _all;

    Widget label(String text, Color color) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: selected != null ? 0.14 : 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: primaryColor,
          ),
          selectedItemBuilder: (_) => [
            for (final o in options)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.apartment_outlined,
                    size: 16,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  label(o.value, primaryColor),
                ],
              ),
          ],
          items: [
            for (final o in options)
              DropdownMenuItem<String>(
                value: o.key,
                child: label(o.value, kText),
              ),
          ],
          onChanged: (value) =>
              onChanged(value == null || value == _all ? null : value),
        ),
      ),
    );
  }
}
