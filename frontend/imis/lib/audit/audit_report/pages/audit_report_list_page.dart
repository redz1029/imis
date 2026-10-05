// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
import 'package:imis/audit/audit_report/pages/audit_report_page.dart';
import 'package:imis/audit/audit_report/service/audit_report_service.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/audit/widgets/approval_workflow_widgets.dart';
import 'package:imis/constant/constant.dart';
// import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditReportListPage extends StatefulWidget {
  const AuditReportListPage({super.key});

  @override
  State<AuditReportListPage> createState() => _AuditReportListPageState();
}

/// Approval state of one report, derived from its IQA signatory chain.
/// The AuditReportDto carries no status field, so the chain is the only
/// source of truth — same derivation AuditPlan uses.
class _ReportApproval {
  const _ReportApproval({
    required this.isDraft,
    required this.signatories,
    required this.isFullyApproved,
  });

  final bool isDraft;
  final List<IQASignatory> signatories;

  /// True only once every signatory in the chain has approved and none has
  /// disapproved.
  final bool isFullyApproved;

  bool get isDisapproved =>
      signatories.any((s) => s.approvalStatus == 'Disapproved');

  String get statusName {
    if (isDraft) return 'Draft';
    if (isDisapproved) return 'Disapproved';
    if (isFullyApproved) return 'Approved';
    return 'Pending';
  }

  Color get statusColor {
    switch (statusName) {
      case 'Approved':
        return Colors.green;
      case 'Disapproved':
        return Colors.redAccent;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _AuditReportListPageState extends State<AuditReportListPage> {
  final _service = AuditReportService(Dio());

  List<AuditReport> _allReports = [];
  final Map<int, _ReportApproval> _approvalByReportId = {};
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;
  bool _isAdmin = false;
  final Set<int> _busyReportIds = {};

  @override
  void initState() {
    super.initState();
    _fetchReports();
    AuthUtil.isCurrentUserAdmin().then((val) {
      if (mounted) setState(() => _isAdmin = val);
    });
  }

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllAuditReports();
      if (mounted) {
        setState(() {
          _allReports = data;
          _isLoading = false;
        });
      }
      _loadApprovals(data);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit reports: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Fetches each report's signatory chain. One failed chain must not hide the
  /// whole list, so errors degrade to "Draft" per report. The lookups run
  /// concurrently — this is one request per report, so doing them in sequence
  /// would make the list load time scale with the record count.
  Future<void> _loadApprovals(List<AuditReport> reports) async {
    final approvals = await Future.wait(
      reports.map((report) async {
        try {
          final signatories = await _service.getSignatories(report.id);
          final active = signatories.where((s) => s.id > 0).toList();
          return MapEntry<int, _ReportApproval>(
            report.id,
            _ReportApproval(
              isDraft: active.isEmpty,
              signatories: active,
              isFullyApproved:
                  active.isNotEmpty &&
                  active.every((s) => s.approvalStatus == 'Approved'),
            ),
          );
        } catch (e) {
          debugPrint('Failed to load signatories for report ${report.id}: $e');
          return MapEntry<int, _ReportApproval>(
            report.id,
            const _ReportApproval(
              isDraft: true,
              signatories: [],
              isFullyApproved: false,
            ),
          );
        }
      }),
    );

    if (!mounted) return;
    setState(() {
      _approvalByReportId
        ..clear()
        ..addEntries(approvals);
    });
  }

  /// Clears the recorded chain and submits again, so a disapproved report can
  /// be reworked and re-enter approval instead of being stuck for good.
  Future<void> _resetAndResubmit(AuditReport report) async {
    final user = await AuthUtil.fetchLoggedUser();
    final userId = user?.id;
    if (userId == null || userId.isEmpty) {
      _toastError('Unable to resolve the current user. Please sign in again.');
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.resetApprovalChain(report.id);
      await _service.submitForApproval(report.id, userId);
      _toastSuccess('Approval chain reset. Submitted for approval.');
    } catch (e) {
      _toastError('Resubmit failed: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _fetchReports();
      }
    }
  }

  _ReportApproval _approvalFor(AuditReport report) =>
      _approvalByReportId[report.id] ??
      const _ReportApproval(
        isDraft: true,
        signatories: [],
        isFullyApproved: false,
      );

  List<AuditReport> get _paged {
    final start = (_currentPage - 1) * _pageSize;
    if (start >= _allReports.length) return [];
    final end = (start + _pageSize).clamp(0, _allReports.length);
    return _allReports.sublist(start, end);
  }

  Future<void> _openForm({int? reportId}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditReportPage(reportId: reportId),
    );
    _fetchReports();
  }

  String _displayOffice(AuditReport report) {
    if (report.officeAuditedName != null &&
        report.officeAuditedName!.trim().isNotEmpty) {
      return report.officeAuditedName!;
    }
    if (report.planOfficeProcess != null &&
        report.planOfficeProcess!.trim().isNotEmpty) {
      return report.planOfficeProcess!;
    }
    return '—';
  }

  String _displayAuditee(AuditReport report) {
    if (report.auditeeName != null && report.auditeeName!.trim().isNotEmpty) {
      return report.auditeeName!;
    }
    if (report.auditScope != null && report.auditScope!.isNotEmpty) {
      final names =
          report.auditScope!
              .map((s) => s.auditee.trim())
              .where((a) => a.isNotEmpty)
              .toList();
      if (names.isNotEmpty) return names.join(', ');
    }
    return '—';
  }

  void _showDeleteDialog(AuditReport report) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Audit Report',
            itemName:
                _displayOffice(report) != '—'
                    ? _displayOffice(report)
                    : 'this audit report',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _service.delete(report.id);
                await _fetchReports();
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'Deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (e) {
                if (mounted) {
                  MotionToast.error(
                    description: Text(
                      e.toString().replaceFirst('Exception: ', ''),
                    ),
                  ).show(context);
                }
              }
            },
          ),
    );
  }

  String _formatDate(AuditReport report) {
    final serverDate = report.auditDate;
    if (serverDate != null) {
      return '${serverDate.month}/${serverDate.day}/${serverDate.year}';
    }
    final time = report.auditPlanEntry?.time;
    if (time == null) return '—';
    return '${time.month}/${time.day}/${time.year}';
  }

  void _toastError(String message) {
    if (!mounted) return;
    MotionToast.error(
      description: Text(message.replaceFirst('Exception: ', '')),
    ).show(context);
  }

  void _toastSuccess(String message) {
    if (!mounted) return;
    MotionToast.success(
      description: Text(message, style: GoogleFonts.plusJakartaSans()),
    ).show(context);
  }

  void _setBusy(int reportId, bool busy) {
    setState(() {
      if (busy) {
        _busyReportIds.add(reportId);
      } else {
        _busyReportIds.remove(reportId);
      }
    });
  }

  /// Submits the report for approval, which creates one Pending signatory row
  /// per active AuditReport signatory template.
  Future<void> _submitForApproval(AuditReport report) async {
    final user = await AuthUtil.fetchLoggedUser();
    final userId = user?.id;
    if (userId == null || userId.isEmpty) {
      _toastError('Unable to resolve the current user. Please sign in again.');
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.submitForApproval(report.id, userId);
      _toastSuccess('Submitted for approval.');
    } catch (e) {
      _toastError('Submit failed: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _fetchReports();
      }
    }
  }

  /// Shows the chain and, when [signatory] is the one whose turn it is, offers
  /// the Approve / Disapprove actions.
  Future<void> _showApprovalDialog(AuditReport report) async {
    final approval = _approvalFor(report);

    await showDialog(
      context: context,
      builder: (ctx) {
        IQASignatory? next;
        for (final s in approval.signatories) {
          if (s.isPending) {
            next = s;
            break;
          }
        }

        return AlertDialog(
          title: const Text('Approval Status'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${approval.statusName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: approval.statusColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (approval.signatories.isEmpty)
                  const Text(
                    'This report has not been submitted for approval yet.',
                  )
                else
                  ...approval.signatories.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text('${s.orderLevel ?? '-'}'),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.signatoryLabel ?? s.signatoryName ?? '—',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  s.signatoryName ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _statusChip(s.approvalStatus),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            if (approval.isDraft)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _submitForApproval(report);
                },
                child: const Text('Submit for Approval'),
              ),
            if (!approval.isDraft &&
                !approval.isFullyApproved &&
                !approval.isDisapproved &&
                (next != null || _isAdmin)) ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _recordAdminDecision(report, next, false);
                },
                child: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                onPressed: () {
                  Navigator.pop(ctx);
                  _recordAdminDecision(report, next, true);
                },
                child: const Text('Approve', style: TextStyle(color: Colors.white)),
              ),
            ],
            if (approval.isDisapproved)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _resetAndResubmit(report);
                },
                child: const Text('Reset & Resubmit'),
              ),
            if (approval.isFullyApproved)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade700),
                icon: const Icon(Icons.assignment_late_outlined, size: 16, color: Colors.white),
                label: const Text('Create NCAR', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.pop(ctx);
                  final user = await AuthUtil.fetchLoggedUser();
                  try {
                    await _service.createNcarFromAuditReport(
                      auditReportId: report.id,
                      issuedByAuditorUserId: user?.id ?? '',
                      acknowledgedByAuditeeUserId: user?.id ?? '',
                    );
                    _toastSuccess('NCAR successfully created from Audit Report #${report.id}.');
                  } catch (e) {
                    _toastError('Failed to create NCAR: $e');
                  }
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> _recordAdminDecision(
    AuditReport report,
    IQASignatory? nextSignatory,
    bool approve,
  ) async {
    final user = await AuthUtil.fetchLoggedUser();
    final signatoryId = nextSignatory?.signatoryId ?? user?.id ?? '';

    if (!approve) {
      final reason = await RejectionDialog.show(
        context,
        title: 'Reject Audit Report',
        subtitle: 'Please provide the reason for rejecting Audit Report #${report.id}.',
      );
      if (reason == null) return;

      _setBusy(report.id, true);
      try {
        await _service.decide(
          reportId: report.id,
          signatoryId: signatoryId,
          approve: false,
          remarks: reason,
        );
        _toastSuccess('Audit Report rejected with reason.');
      } catch (e) {
        _toastError('Failed to reject report: $e');
      } finally {
        if (mounted) {
          _setBusy(report.id, false);
          _fetchReports();
        }
      }
      return;
    }

    _setBusy(report.id, true);
    try {
      await _service.decide(
        reportId: report.id,
        signatoryId: signatoryId,
        approve: true,
      );
      _toastSuccess('Audit Report approved.');
    } catch (e) {
      _toastError('Failed to approve report: $e');
    } finally {
      if (mounted) {
        _setBusy(report.id, false);
        _fetchReports();
      }
    }
  }

  Widget _statusChip(String? approvalStatus) {
    final label = approvalStatus ?? 'Pending';
    final color = switch (label) {
      'Approved' => Colors.green,
      'Disapproved' => Colors.redAccent,
      _ => Colors.orange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  Widget _approvalBadge(AuditReport report) {
    final approval = _approvalFor(report);
    final busy = _busyReportIds.contains(report.id);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: busy ? null : () => _showApprovalDialog(report),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child:
                busy
                    ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      approval.statusName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: approval.statusColor,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final paged = _paged;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'Audit Report',
              totalCount: _allReports.length,
              itemLabel: 'report',
              icon: Icons.fact_check_outlined,
              actionButton: ElevatedButton.icon(
                onPressed: () => _openForm(),
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
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New',
                  style: TextStyle(color: Colors.white),
                ),
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
                    if (!isMobile)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 40,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Office Audited',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Auditee',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Purpose',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Date of Audit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 120,
                              child: Text(
                                'Actions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isMobile) const Divider(height: 1, color: kBorder),
                    Expanded(
                      child:
                          _isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : paged.isEmpty
                              ? Center(
                                child: Text(
                                  'No audit reports found',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: kMuted,
                                  ),
                                ),
                              )
                              : ListView.separated(
                                itemCount: paged.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                itemBuilder: (context, index) {
                                  final report = paged[index];
                                  final rowNumber =
                                      (_currentPage - 1) * _pageSize +
                                      index +
                                      1;

                                  if (!isMobile) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Text('$rowNumber'),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _displayOffice(report),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              _displayAuditee(report),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              report.auditPurpose.isNotEmpty
                                                  ? report.auditPurpose
                                                  : '—',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(_formatDate(report)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: _approvalBadge(report),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 16,
                                                  ),
                                                  onPressed:
                                                      () => _openForm(
                                                        reportId: report.id,
                                                      ),
                                                ),
                                                // IconButton(
                                                //   icon: const Icon(
                                                //     Icons
                                                //         .picture_as_pdf_outlined,
                                                //     size: 16,
                                                //   ),
                                                //   onPressed: () =>
                                                //       openAuditReportPreview(
                                                //         report.id,
                                                //         report.officeAuditedName ??
                                                //             '',
                                                //         context: context,
                                                //       ),
                                                // ),
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    size: 16,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => _showDeleteDialog(
                                                        report,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _displayOffice(report),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _displayAuditee(report),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDate(report),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              _approvalBadge(report),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          color: Theme.of(context).cardColor,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey.shade500,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _openForm(reportId: report.id);
                                            }
                                            if (value == 'delete') {
                                              _showDeleteDialog(report);
                                            }
                                            if (value == 'approval') {
                                              _showApprovalDialog(report);
                                            }
                                          },
                                          itemBuilder:
                                              (_) => [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'approval',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .how_to_reg_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Approval Status'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .delete_simple,
                                                        color: Colors.redAccent,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ],
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
                            totalItems: _allReports.length,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _allReports.length,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged:
                                (page) => setState(() => _currentPage = page),
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
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => _openForm(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}
