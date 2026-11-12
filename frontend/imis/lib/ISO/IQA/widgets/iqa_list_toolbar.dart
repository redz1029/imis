import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:intl/intl.dart';

/// Shared by every IQA list page (Programme, Plan, Schedule, Checklist,
/// Report, NCAR): the same status tabs and the same year / date-range filter
/// the PGS list uses, so the six pages look and behave alike.
class IqaStatus {
  IqaStatus._();

  static const all = 'All';
  static const draft = 'Draft';
  static const forApproval = 'For Approval';
  static const approved = 'Approved';
  static const disapproved = 'Disapproved';

  // NCAR has its own lifecycle (raised, monitored, closed) rather than an
  // approval chain, but uses the same tab style.
  static const open = 'Open';
  static const underMonitoring = 'Under Monitoring';
  static const closed = 'Closed';

  /// Tabs for the pages whose records start as a Draft.
  static const withDraft = [all, draft, forApproval, approved, disapproved];

  /// Tabs for the pages that have no Draft stage (e.g. Audit Schedule).
  static const withoutDraft = [all, forApproval, approved, disapproved];

  // An Audit Schedule has its own states (no Draft). Its tabs use exactly the
  // names its rows show, so a tab always lists the rows labelled like it.
  static const pendingConfirmation = 'Pending Confirmation';
  static const revisionRequired = 'Revision Required';
  static const rejected = 'Rejected';

  /// Tabs for the Audit Schedule list.
  static const schedule = [
    all,
    pendingConfirmation,
    confirmed,
    revisionRequired,
    rejected,
  ];

  // A checklist is generated once its schedule is Confirmed, then Approved.
  static const confirmed = 'Confirmed';

  /// Tabs for the Audit Checklist list.
  static const checklist = [all, confirmed, approved];

  /// Tabs for the NCAR list.
  static const ncar = [all, open, underMonitoring, closed];

  /// Maps a workflow state name onto one of the shared tabs.
  static String tabOf(String? statusName) {
    switch ((statusName ?? '').trim()) {
      case 'Pending':
      case 'Pending Approval': // what the server calls a submitted programme / plan
      case 'Pending Confirmation':
      case 'Resubmitted':
      case 'For Approval':
        return forApproval;
      case 'Approved':
      case 'Confirmed':
        return approved;
      case 'Rejected':
      case 'Disapproved':
      case 'Revision Required':
        return disapproved;
      default:
        return draft;
    }
  }

  static IconData iconOf(String tab) {
    switch (tab) {
      case draft:
        return Icons.edit_note_rounded;
      case forApproval:
        return Icons.pending_actions_rounded;
      case approved:
        return Icons.check_circle_rounded;
      case disapproved:
        return Icons.cancel_rounded;
      case pendingConfirmation:
        return Icons.pending_actions_rounded;
      case revisionRequired:
        return Icons.replay_circle_filled_rounded;
      case rejected:
        return Icons.cancel_rounded;
      case confirmed:
        return Icons.verified_outlined;
      case open:
        return Icons.error_outline_rounded;
      case underMonitoring:
        return Icons.visibility_outlined;
      case closed:
        return Icons.check_circle_rounded;
      default:
        return Icons.list_alt_rounded;
    }
  }

  static Color colorOf(String tab) {
    switch (tab) {
      case draft:
        return Colors.grey.shade600;
      case forApproval:
        return Colors.orange.shade600;
      case approved:
        return kSuccess;
      case disapproved:
        return Colors.red.shade400;
      case pendingConfirmation:
        return Colors.orange.shade600;
      case revisionRequired:
      case rejected:
        return Colors.red.shade400;
      case confirmed:
        return Colors.blue.shade600;
      case open:
        return Colors.orange.shade600;
      case underMonitoring:
        return Colors.blue.shade600;
      case closed:
        return kSuccess;
      default:
        return Colors.grey.shade600;
    }
  }
}

/// The period a list is showing. Defaults to the current year; the user can
/// move it to any other year (or any custom range) to browse older records.
class IqaPeriod {
  IqaPeriod._();

  static DateTimeRange year(int year) =>
      DateTimeRange(start: DateTime(year, 1, 1), end: DateTime(year, 12, 31));

  static DateTimeRange currentYear() => year(DateTime.now().year);

  static bool isCurrentYear(DateTimeRange range) {
    final current = currentYear();
    return range.start == current.start && range.end == current.end;
  }

  /// True when the record's own period [start, end] overlaps [range]. A record
  /// with only one date (or none usable) is placed by that date; a record with
  /// no date at all is never hidden, because it cannot be placed in any year.
  static bool matches(DateTimeRange range, DateTime? start, [DateTime? end]) {
    if (start == null && end == null) return true;
    final s = start ?? end!;
    final e = end ?? start!;
    final from = DateTime(range.start.year, range.start.month, range.start.day);
    final to = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
    );
    return !e.isBefore(from) && !s.isAfter(to);
  }

  /// Year a record belongs to — used in its reference label.
  static int? yearOf(DateTime? start, [DateTime? fallback]) =>
      (start ?? fallback)?.year;
}

/// "Audit Plan – ISO 2026". Falls back to the plain label with no year when
/// the record carries no date at all.
String iqaReference(String recordType, int? year, {String standard = 'ISO'}) {
  final y = (year == null || year <= 0) ? '' : ' $year';
  return '$recordType – $standard$y';
}

/// Date-range picker + "Clear filters", like the PGS filter row.
class IqaPeriodFilter extends StatelessWidget {
  const IqaPeriodFilter({
    super.key,
    required this.range,
    required this.onChanged,
    required this.onClear,
    this.hasOtherFilters = false,
    this.trailing = const [],
  });

  final DateTimeRange range;
  final ValueChanged<DateTimeRange> onChanged;
  final VoidCallback onClear;

  /// True when the page has filters besides the period (so Clear shows up).
  final bool hasOtherFilters;

  /// Extra filter widgets placed before the period (e.g. an office filter).
  final List<Widget> trailing;

  static final DateFormat _fmt = DateFormat('MMMM dd, yyyy');

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) => _PeriodDialog(initial: range),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final active = !IqaPeriod.isCurrentYear(range) || hasOtherFilters;
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...trailing,
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _pick(context),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_fmt.format(range.start)} - ${_fmt.format(range.end)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
        if (active)
          TextButton.icon(
            onPressed: onClear,
            icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
            label: Text(
              'Clear filters',
              style: TextStyle(fontSize: 12, color: Colors.red.shade400),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}

/// PGS-style underlined status tabs with an icon and a coloured count.
class IqaStatusTabs extends StatelessWidget {
  const IqaStatusTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.countOf,
    required this.onSelected,
  });

  final List<String> tabs;
  final String selected;
  final int Function(String tab) countOf;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              tabs.map((tab) {
                final isSelected = tab == selected;
                final color = IqaStatus.colorOf(tab);
                return GestureDetector(
                  onTap: () => onSelected(tab),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IqaStatus.iconOf(tab),
                          size: 14,
                          color: isSelected ? primaryColor : color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tab,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected
                                    ? primaryColor
                                    : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? primaryColor.withValues(alpha: 0.12)
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${countOf(tab)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? primaryColor : color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

/// The "Select period" dialog of the IQA lists: quick choices, a year stepper
/// and plain From / To dates, instead of the full-screen range calendar.
class _PeriodDialog extends StatefulWidget {
  const _PeriodDialog({required this.initial});

  final DateTimeRange initial;

  @override
  State<_PeriodDialog> createState() => _PeriodDialogState();
}

class _PeriodDialogState extends State<_PeriodDialog> {
  static final DateTime _first = DateTime(2000);
  static final DateTime _last = DateTime(DateTime.now().year + 10, 12, 31);
  static final DateFormat _fmt = DateFormat('MMM d, yyyy');
  static final DateFormat _long = DateFormat('MMMM d, yyyy');

  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = _day(widget.initial.start);
    _to = _day(widget.initial.end);
  }

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTimeRange _month(int year, int month) => DateTimeRange(
    start: DateTime(year, month, 1),
    end: DateTime(year, month + 1, 0),
  );

  static DateTimeRange _quarter(int year, int startMonth) => DateTimeRange(
    start: DateTime(year, startMonth, 1),
    end: DateTime(year, startMonth + 3, 0),
  );

  List<MapEntry<String, DateTimeRange>> get _presets {
    final now = DateTime.now();
    final quarterStart = ((now.month - 1) ~/ 3) * 3 + 1;
    return [
      MapEntry('This month', _month(now.year, now.month)),
      MapEntry('Last month', _month(now.year, now.month - 1)),
      MapEntry('This quarter', _quarter(now.year, quarterStart)),
      MapEntry('Last quarter', _quarter(now.year, quarterStart - 3)),
      MapEntry('This year', IqaPeriod.year(now.year)),
      MapEntry('Last year', IqaPeriod.year(now.year - 1)),
      MapEntry('All time', DateTimeRange(start: _first, end: _last)),
    ];
  }

  bool _is(DateTimeRange r) => _from == _day(r.start) && _to == _day(r.end);

  void _set(DateTimeRange r) => setState(() {
    _from = _day(r.start);
    _to = _day(r.end);
  });

  /// The year the stepper shows: that of the chosen start date.
  int get _year => _from.year;

  void _stepYear(int by) {
    final year = _year + by;
    if (year < _first.year || year > _last.year) return;
    _set(IqaPeriod.year(year));
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final current = isFrom ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: _first,
      lastDate: _last,
      helpText: isFrom ? 'Start date' : 'End date',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: primaryColor,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      final d = _day(picked);
      if (isFrom) {
        _from = d;
        if (_to.isBefore(_from)) _to = _from;
      } else {
        _to = d;
        if (_from.isAfter(_to)) _from = _to;
      }
    });
  }

  Widget _dateField(String label, DateTime value, bool isFrom) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _pickDate(isFrom: isFrom),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            _fmt.format(value),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: kText,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.date_range_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select period',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kText,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Year', style: label),
              const SizedBox(height: 6),
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'Previous year',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _year > _first.year ? () => _stepYear(-1) : null,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _set(IqaPeriod.year(_year)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _is(IqaPeriod.year(_year))
                              ? primaryColor.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Whole year $_year',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: 'Next year',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _year < _last.year ? () => _stepYear(1) : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Quick choice', style: label),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in _presets)
                    ChoiceChip(
                      label: Text(p.key),
                      selected: _is(p.value),
                      showCheckmark: false,
                      selectedColor: primaryColor,
                      backgroundColor: primaryColor.withValues(alpha: 0.06),
                      side: BorderSide(
                        color: primaryColor.withValues(alpha: 0.4),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _is(p.value) ? Colors.white : primaryColor,
                      ),
                      onSelected: (_) => _set(p.value),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Or pick the dates', style: label),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateField('From', _from, true),
                  const SizedBox(width: 10),
                  _dateField('To', _to, false),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_long.format(_from)} - ${_long.format(_to)}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(
                      context,
                      DateTimeRange(start: _from, end: _to),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
