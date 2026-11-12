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
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
      initialDateRange: range,
      helpText: 'Select period',
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
