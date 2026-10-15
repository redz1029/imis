import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_approval_history.dart';
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

/// Modal dialog displaying full approval and rejection history.
class ApprovalHistoryDialog extends StatelessWidget {
  final String title;
  final List<IQAApprovalHistory> history;

  const ApprovalHistoryDialog({
    super.key,
    required this.title,
    required this.history,
  });

  static void show(
    BuildContext context, {
    required String title,
    required List<IQAApprovalHistory> history,
  }) {
    showDialog(
      context: context,
      builder: (_) => ApprovalHistoryDialog(title: title, history: history),
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
            '$title Approval History',
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
                  'No approval history recorded yet.',
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
