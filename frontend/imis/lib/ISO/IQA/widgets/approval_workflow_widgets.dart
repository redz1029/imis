import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/iqa_signatory/model/iqa_approval_history.dart';
import 'package:imis/constant/constant.dart';

/// Modal dialog requiring a comment/reason when rejecting an item.
class RejectionDialog extends StatefulWidget {
  final String title;
  final String? subtitle;

  const RejectionDialog({
    super.key,
    required this.title,
    this.subtitle,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RejectionDialog(title: title, subtitle: subtitle),
    );
  }

  @override
  State<RejectionDialog> createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                Text(
                  widget.subtitle!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'Reason for Rejection *',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Please provide the reason for rejecting this record...',
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a reason for rejection.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              Navigator.pop(context, _commentController.text.trim());
            }
          },
          child: Text(
            'Reject',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Modal dialog for the Lead Auditor to revise an APPROVED Audit Programme /
/// Plan. Asks for the reason and returns it, or null when cancelled.
class RevisionDialog extends StatefulWidget {
  final String title;
  final String subtitle;

  const RevisionDialog({super.key, required this.title, required this.subtitle});

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RevisionDialog(title: title, subtitle: subtitle),
    );
  }

  @override
  State<RevisionDialog> createState() => _RevisionDialogState();
}

class _RevisionDialogState extends State<RevisionDialog> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(Icons.edit_note, color: Colors.orange.shade800, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Reason for Revision *',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'What needs to change?',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange.shade800),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter the reason for the revision.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              Navigator.pop(context, _reasonController.text.trim());
            }
          },
          child: Text(
            'Revise',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Modal dialog displaying full approval and rejection history.
class ApprovalHistoryDialog extends StatelessWidget {
  final String title;
  final List<IQAApprovalHistory> history;

  /// What the dialog is called after the title ("Approval History" by default;
  /// the Checklist and the NCAR have no approval, so they say "History").
  final String heading;

  const ApprovalHistoryDialog({
    super.key,
    required this.title,
    required this.history,
    this.heading = 'Approval History',
  });

  static void show(
    BuildContext context, {
    required String title,
    required List<IQAApprovalHistory> history,
    String heading = 'Approval History',
  }) {
    showDialog(
      context: context,
      builder: (_) => ApprovalHistoryDialog(
        title: title,
        history: history,
        heading: heading,
      ),
    );
  }

  /// Opens the history of a document that is read from the server when the
  /// dialog opens (Audit Checklist, Audit Report, NCAR, ...): a spinner first,
  /// then the list, or the reason it could not be loaded.
  static void showLoaded(
    BuildContext context, {
    required String title,
    required Future<List<IQAApprovalHistory>> Function() load,
    String heading = 'History',
  }) {
    showDialog(
      context: context,
      builder: (_) => _LoadedHistoryDialog(
        title: title,
        load: load,
        heading: heading,
      ),
    );
  }

  Color _actionColor(String action) {
    switch (action.toLowerCase()) {
      case 'approved':
      case 'confirmed':
        return Colors.green.shade700;
      case 'rejected':
      case 'disapproved':
        return Colors.red.shade700;
      case 'noted':
        return Colors.blue.shade700;
      case 'submitted':
      case 'resubmitted':
        return Colors.indigo.shade600;
      case 'revised':
        return Colors.orange.shade800;
      // NCAR
      case 'issued':
        return Colors.indigo.shade600;
      case 'acknowledged':
      case 'responded':
        return Colors.teal.shade700;
      case 'verified':
        return Colors.blue.shade700;
      case 'closed':
        return Colors.green.shade700;
      // Audit Checklist
      case 'clauses assigned':
      case 'question added':
        return Colors.indigo.shade600;
      case 'question removed':
        return Colors.orange.shade800;
      case 'answered':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(Icons.history, color: primaryColor, size: 22),
          const SizedBox(width: 8),
          Text(
            '$title $heading',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 680,
        height: 380,
        child: history.isEmpty
            ? Center(
                child: Text(
                  heading == 'Approval History'
                      ? 'No approval history recorded yet.'
                      : 'No history recorded yet.',
                  style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade500),
                ),
              )
            : Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final actionColor = _actionColor(item.action);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: actionColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: actionColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  item.action,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: actionColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item.effectiveUserName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              if (item.roleOrPosition != null && item.roleOrPosition!.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Text(
                                  '(${item.roleOrPosition})',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Text(
                                item.formattedDate,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          if (item.officeName != null && item.officeName!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Department/Office: ${item.officeName}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                          if (item.comments != null && item.comments!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                '"${item.comments}"',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: GoogleFonts.plusJakartaSans(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Highlight banner displaying rejection information for the preparer.
class RejectionBanner extends StatelessWidget {
  final RejectionDetails rejection;
  final VoidCallback? onViewHistory;

  const RejectionBanner({
    super.key,
    required this.rejection,
    this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                'Revision Required',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.red.shade800,
                ),
              ),
              const Spacer(),
              if (onViewHistory != null)
                TextButton.icon(
                  onPressed: onViewHistory,
                  icon: const Icon(Icons.history, size: 16, color: Colors.redAccent),
                  label: Text(
                    'View History',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (rejection.rejectedBy != null && rejection.rejectedBy!.isNotEmpty)
            Text(
              'Rejected by: ${rejection.rejectedBy}${rejection.roleOrPosition != null ? " (${rejection.roleOrPosition})" : ""}',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          if (rejection.officeName != null && rejection.officeName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Department: ${rejection.officeName}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          if (rejection.rejectedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Date: ${rejection.formattedDate}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason:',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.red.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rejection.rejectionReason ?? 'No reason provided.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.black87,
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

/// Fetches a document's history when it opens and shows it in the same dialog
/// as the approval history.
class _LoadedHistoryDialog extends StatefulWidget {
  const _LoadedHistoryDialog({
    required this.title,
    required this.load,
    required this.heading,
  });

  final String title;
  final Future<List<IQAApprovalHistory>> Function() load;
  final String heading;

  @override
  State<_LoadedHistoryDialog> createState() => _LoadedHistoryDialogState();
}

class _LoadedHistoryDialogState extends State<_LoadedHistoryDialog> {
  // Loaded once: a rebuild must not fetch the history again.
  late final Future<List<IQAApprovalHistory>> _future = widget.load();

  String get title => widget.title;
  String get heading => widget.heading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<IQAApprovalHistory>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const SizedBox(
              width: 280,
              height: 90,
              child: Center(child: CircularProgressIndicator(color: primaryColor)),
            ),
          );
        }

        if (snapshot.hasError) {
          final message = snapshot.error.toString().replaceFirst('Exception: ', '');
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              '$title $heading',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: Text(
              'The history could not be loaded. $message',
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }

        return ApprovalHistoryDialog(
          title: title,
          history: snapshot.data ?? const [],
          heading: heading,
        );
      },
    );
  }
}
