// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
import 'package:imis/audit/audit_report/pages/audit_report_page.dart';
import 'package:imis/audit/audit_report/service/audit_report_service.dart';
import 'package:imis/constant/constant.dart';
// import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditReportListPage extends StatefulWidget {
  const AuditReportListPage({super.key});

  @override
  State<AuditReportListPage> createState() => _AuditReportListPageState();
}

class _AuditReportListPageState extends State<AuditReportListPage> {
  final _service = AuditReportService(Dio());

  List<AuditReport> _allReports = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllAuditReports();
      if (mounted) setState(() => _allReports = data);
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

  void _showDeleteDialog(AuditReport report) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Audit Report',
        itemName: report.officeAuditedName?.isNotEmpty == true
            ? report.officeAuditedName!
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
    final time = report.auditPlanEntry?.time;
    if (time == null) return '—';
    return '${time.month}/${time.day}/${time.year}';
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
                      child: _isLoading
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
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                              itemBuilder: (context, index) {
                                final report = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;

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
                                            report.officeAuditedName ?? '—',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            report.auditeeName ?? '—',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            report.auditPurpose,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(_formatDate(report)),
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
                                                onPressed: () => _openForm(
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
                                                onPressed: () =>
                                                    _showDeleteDialog(report),
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
                                              report.officeAuditedName ?? '—',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              report.auditeeName ?? '—',
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
                                          // if (value == 'pdf') {
                                          //   openAuditReportPreview(
                                          //     report.id,
                                          //     report.officeAuditedName ?? '',
                                          //     context: context,
                                          //   );
                                          // }
                                          if (value == 'delete') {
                                            _showDeleteDialog(report);
                                          }
                                        },
                                        itemBuilder: (_) => [
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
                                            value: 'pdf',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .picture_as_pdf_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('View PDF'),
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
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => _openForm(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}