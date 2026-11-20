import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';

/// The NCAR same-day rule, written out once so every user reads it the same
/// way. It is shown on the NCAR list and on the NCAR form.
///
///  1. The auditor issues the NCAR on a day.
///  2. The auditee acknowledges it on that same day.
///  3. On that same day the auditee also writes the root cause analysis and
///     the proposed actions.
///  4. On the day those were written, the auditor verifies what was observed.
///
/// It is a deadline, not a lock: a late step is still accepted, but it is
/// marked Overdue / Late. The server works the days out (Philippine time).
class NcarSameDayNotice extends StatefulWidget {
  const NcarSameDayNotice({super.key, this.initiallyExpanded = true});

  /// The list opens it collapsed to a single line; the form opens it in full.
  final bool initiallyExpanded;

  @override
  State<NcarSameDayNotice> createState() => _NcarSameDayNoticeState();
}

class _NcarSameDayNoticeState extends State<NcarSameDayNotice> {
  late bool _expanded = widget.initiallyExpanded;

  static const _steps = <(String, String, String)>[
    (
      'Auditor',
      'Issues the NCAR',
      'The day it is issued is the day the next two steps are due.',
    ),
    (
      'Auditee',
      'Acknowledges it — the same day',
      'The audited office confirms it received the NCAR on the day it was issued.',
    ),
    (
      'Auditee',
      'Writes the root cause analysis and proposed actions — the same day',
      'Also on the day it was issued, then the Department / Section Head approves them.',
    ),
    (
      'Auditor',
      'Verifies what was observed — the same day',
      'On the day the office wrote its response, the auditor checks the actions and writes what was observed.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final amber = Colors.amber.shade900;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.today_outlined, size: 20, color: amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'NCAR same-day rule: acknowledge, respond and verify on the same day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: amber,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: amber,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: amber,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_steps[i].$1}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _steps[i].$2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n${_steps[i].$3}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(fontSize: 12.5, height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    'A late step is still accepted, but it is marked Overdue or Late. '
                    'Days are counted in Philippine time.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// How one step stands against the same-day rule: Due today, Overdue, Done on
/// time or Done late. Nothing is shown while the step is not measurable yet.
class NcarDueChip extends StatelessWidget {
  const NcarDueChip({super.key, required this.state, required this.dueDate});

  final String state;
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final due = dueDate == null ? '' : DateFormat('MMM d, yyyy').format(dueDate!);

    final (String label, Color color, IconData icon) = switch (state) {
      NcarSameDayState.met => ('Done on time', Colors.green.shade700, Icons.check_circle_outline),
      NcarSameDayState.late => (
        due.isEmpty ? 'Done late' : 'Done late · was due $due',
        Colors.orange.shade800,
        Icons.schedule,
      ),
      NcarSameDayState.dueToday => (
        due.isEmpty ? 'Due today' : 'Due today · $due',
        Colors.blue.shade700,
        Icons.today_outlined,
      ),
      NcarSameDayState.overdue => (
        due.isEmpty ? 'Overdue' : 'Overdue · was due $due',
        Colors.red.shade700,
        Icons.warning_amber_rounded,
      ),
      _ => ('', Colors.grey, Icons.circle),
    };
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
