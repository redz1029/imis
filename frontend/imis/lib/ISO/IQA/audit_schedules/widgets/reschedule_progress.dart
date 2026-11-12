import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/reschedule_request.dart';
import 'package:intl/intl.dart';

enum _StepState { done, current, rejected, waiting, skipped }

/// Where a reschedule request is on its route: Requested, Team Leader review,
/// Lead Auditor review. Each step shows who handled it, when, and any remarks.
class RescheduleProgress extends StatelessWidget {
  const RescheduleProgress({super.key, required this.request});

  final RescheduleRequest request;

  static final DateFormat _fmt = DateFormat('MMM d, yyyy h:mm a');

  @override
  Widget build(BuildContext context) {
    final r = request;

    final _StepState teamLeader;
    final _StepState leadAuditor;
    switch (r.status) {
      case RescheduleRequest.pendingTeamLeader:
        teamLeader = _StepState.current;
        leadAuditor = _StepState.waiting;
      case RescheduleRequest.rejectedByTeamLeader:
        teamLeader = _StepState.rejected;
        leadAuditor = _StepState.skipped;
      case RescheduleRequest.pendingLeadAuditor:
        teamLeader = _StepState.done;
        leadAuditor = _StepState.current;
      case RescheduleRequest.rejectedByLeadAuditor:
        teamLeader = _StepState.done;
        leadAuditor = _StepState.rejected;
      default:
        teamLeader = _StepState.done;
        leadAuditor = _StepState.done;
    }

    final steps = <_Step>[
      _Step(
        title: 'Requested',
        state: _StepState.done,
        detail: _who(r.requestedBy, r.requestedDate),
      ),
      _Step(
        title: 'Auditor Team Leader',
        state: teamLeader,
        detail: _decisionDetail(
          teamLeader,
          r.teamLeaderName,
          r.teamLeaderDecisionDate,
          r.teamLeaderRemarks,
        ),
      ),
      _Step(
        title: 'Lead Auditor',
        state: leadAuditor,
        detail: _decisionDetail(
          leadAuditor,
          r.leadAuditorName,
          r.leadAuditorDecisionDate,
          r.leadAuditorRemarks,
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          _StepRow(step: steps[i], isLast: i == steps.length - 1),
      ],
    );
  }

  String? _who(String? name, DateTime? date) {
    final parts = <String>[
      if (name != null && name.isNotEmpty) name,
      if (date != null) _fmt.format(date.toLocal()),
    ];
    return parts.isEmpty ? null : parts.join(' • ');
  }

  String? _decisionDetail(
    _StepState state,
    String? name,
    DateTime? date,
    String? remarks,
  ) {
    switch (state) {
      case _StepState.current:
        return 'Waiting for their decision';
      case _StepState.waiting:
        return 'Not reached yet';
      case _StepState.skipped:
        return 'Not needed — request was rejected earlier';
      case _StepState.done:
      case _StepState.rejected:
        final who = _who(name, date);
        final note = (remarks ?? '').trim();
        if (who == null && note.isEmpty) return null;
        return [if (who != null) who, if (note.isNotEmpty) 'Remarks: $note']
            .join('\n');
    }
  }
}

class _Step {
  const _Step({required this.title, required this.state, this.detail});

  final String title;
  final _StepState state;
  final String? detail;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  final _Step step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (step.state) {
      _StepState.done => (Icons.check_circle, Colors.green.shade700),
      _StepState.current => (Icons.hourglass_top, Colors.orange.shade700),
      _StepState.rejected => (Icons.cancel, Colors.red.shade600),
      _StepState.waiting => (Icons.radio_button_unchecked, Colors.grey.shade500),
      _StepState.skipped => (Icons.remove_circle_outline, Colors.grey.shade400),
    };
    final muted =
        step.state == _StepState.waiting || step.state == _StepState.skipped;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(icon, size: 18, color: color),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: muted ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                  if (step.detail != null)
                    Text(
                      step.detail!,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: muted ? Colors.grey.shade500 : Colors.grey.shade800,
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
