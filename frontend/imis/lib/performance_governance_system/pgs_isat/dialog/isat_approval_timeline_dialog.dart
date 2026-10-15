// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';

class TimelineStep {
  final String label;
  final String name;
  final DateTime? signedDate;
  final bool isNext;

  const TimelineStep({
    required this.label,
    required this.name,
    this.signedDate,
    this.isNext = false,
  });
}

/// Returns `true` kapag may na-delete na signatories (para makapag-refresh ang caller).
/// Ipasa ang [onDelete] para lumabas ang "Delete Signatory" button.
Future<bool?> showApprovalTimelineDialog(
  BuildContext context, {
  required String subtitle,
  required String status,
  required List<TimelineStep> steps,
  String title = 'Approval Timeline',
  Future<void> Function()? onDelete,
}) {
  final isDraft = status == 'Draft';
  final Color accent =
      status == 'Approved'
          ? kSuccess
          : status == 'Pending'
          ? Colors.orange.shade600
          : Colors.grey.shade600;

  return showDialog<bool>(
    context: context,
    builder:
        (_) => _TimelineDialogBody(
          pageContext: context,
          subtitle: subtitle,
          title: title,
          accent: accent,
          isDraft: isDraft,
          steps: steps,
          nextIndex: steps.indexWhere((s) => s.isNext),
          onDelete: onDelete,
        ),
  );
}

class _TimelineDialogBody extends StatefulWidget {
  final BuildContext pageContext;
  final String subtitle;
  final String title;
  final Color accent;
  final bool isDraft;
  final List<TimelineStep> steps;
  final int nextIndex;
  final Future<void> Function()? onDelete;

  const _TimelineDialogBody({
    required this.pageContext,
    required this.subtitle,
    required this.title,
    required this.accent,
    required this.isDraft,
    required this.steps,
    required this.nextIndex,
    required this.onDelete,
  });

  @override
  State<_TimelineDialogBody> createState() => _TimelineDialogBodyState();
}

class _TimelineDialogBodyState extends State<_TimelineDialogBody> {
  bool _isDeleting = false;

  bool get _canDelete =>
      widget.onDelete != null && !widget.isDraft && widget.steps.isNotEmpty;

  void _toast(String msg, {bool error = false}) {
    if (!widget.pageContext.mounted) return;
    final toast =
        error
            ? MotionToast.error(
              description: Text(msg),
              toastAlignment: Alignment.topCenter,
              toastDuration: const Duration(seconds: 5),
            )
            : MotionToast.success(
              description: Text(msg),
              toastAlignment: Alignment.topCenter,
            );
    toast.show(widget.pageContext);
  }

  Future<bool?> _confirmDialog() {
    return showDialog<bool>(
      context: context,
      builder:
          (confirmCtx) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: kDangerLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: kDanger,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Delete Approval Timeline',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This will remove all signatory records for this ISPAM. This action cannot be undone.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: kMuted,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(confirmCtx, false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: kBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.plusJakartaSans(
                                color: kMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(confirmCtx, true),
                            icon: const Icon(
                              Icons.delete_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Delete',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDanger,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Future<void> _handleDelete() async {
    final onDelete = widget.onDelete;
    if (onDelete == null) {
      _toast('onDelete is not provided by the caller', error: true);
      return;
    }

    final confirm = await _confirmDialog();
    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      await onDelete();
      _toast('Timeline deleted successfully');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      final msg =
          e is DioException
              ? 'Delete failed (${e.response?.statusCode ?? 'no response'}): ${e.response?.data ?? e.message}'
              : 'Delete failed: $e';
      debugPrint(msg);
      if (mounted) setState(() => _isDeleting = false);
      _toast(msg, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.steps;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.route_outlined,
                          color: widget.accent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            _isDeleting ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child:
                    widget.isDraft || steps.isEmpty
                        ? _emptyState(widget.isDraft)
                        : Column(
                          children: List.generate(steps.length, (i) {
                            final isPending = steps[i].isNext;
                            final isDone =
                                widget.nextIndex == -1
                                    ? true
                                    : i < widget.nextIndex;
                            return _TimelineTile(
                              step: steps[i],
                              isDone: isDone,
                              isPending: isPending,
                              isLast: i == steps.length - 1,
                            );
                          }),
                        ),
              ),
            ),
            if (_canDelete)
              PermissionWidget(
                permission: AppPermissions.deleteISATSignatoryTemplate,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isDeleting ? null : _handleDelete,
                      icon:
                          _isDeleting
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.white,
                              ),
                      label: Text(
                        _isDeleting ? 'Deleting...' : 'Delete Signatory',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDanger,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _emptyState(bool isDraft) => Center(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDraft ? Icons.hourglass_empty : Icons.pending_outlined,
          size: 40,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Text(
          isDraft ? 'No timeline available yet' : 'No signatories found',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isDraft) ...[
          const SizedBox(height: 4),
          Text(
            'This document is still in Draft stage.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ],
    ),
  ),
);

class _TimelineTile extends StatelessWidget {
  final TimelineStep step;
  final bool isDone;
  final bool isPending;
  final bool isLast;

  const _TimelineTile({
    required this.step,
    required this.isDone,
    required this.isPending,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final Color dotColor =
        isDone
            ? kSuccess
            : isPending
            ? Colors.orange.shade600
            : Colors.grey.shade300;
    final Color lineColor = isDone ? kSuccess : Colors.grey.shade200;
    final Color textColor =
        isDone
            ? kSuccess
            : isPending
            ? Colors.orange.shade600
            : Colors.grey.shade500;

    final signedDate =
        (isDone && step.signedDate != null)
            ? const LongDateOnlyConverter().toJson(step.signedDate!)
            : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border:
                        isPending
                            ? Border.all(
                              color: Colors.orange.shade600,
                              width: 2,
                            )
                            : null,
                  ),
                  child:
                      isDone
                          ? const Icon(
                            Icons.check,
                            size: 9,
                            color: Colors.white,
                          )
                          : isPending
                          ? Container(
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                          : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1D23),
                    ),
                  ),
                  if (signedDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Signed on $signedDate',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: dotColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isDone
                          ? 'Done'
                          : isPending
                          ? 'Pending'
                          : 'Waiting',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textColor,
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
