import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/ncar/models/ncar_monitoring_log.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_form_page.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';

class NcarMonitoringPage extends StatefulWidget {
  const NcarMonitoringPage({super.key});

  @override
  State<NcarMonitoringPage> createState() => _NcarMonitoringPageState();
}

class _NcarMonitoringPageState extends State<NcarMonitoringPage> {
  final NcarService _service = NcarService(Dio());

  List<NcarMonitoringLog> _logs = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final logs = await _service.getMonitoringLogs();
      if (mounted) {
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MotionToast.error(description: Text('Error loading monitoring logs: $e')).show(context);
      }
    }
  }

  /// Verification and closing are written in the NCAR form itself (the auditor
  /// writes what was observed, the lead auditor validates), so the log opens it.
  Future<void> _openNcar(NcarMonitoringLog log) async {
    final id = log.nonconformingActionReportId;
    if (id == null) return;
    final changed = await showNcarForm(context, id);
    if (changed && mounted) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'NCAR Monitoring Log (QP-03-F-09)',
              totalCount: _logs.length,
              itemLabel: 'log',
              icon: Icons.track_changes_outlined,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : _logs.isEmpty
                      ? const Center(child: Text('No NCAR monitoring logs found.'))
                      : ListView.separated(
                          itemCount: _logs.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final log = _logs[index];
                            final dateIssuedStr = DateFormat('MMM d, yyyy').format(log.dateIssued);
                            final isClosed = log.remarks.toLowerCase() == 'closed' || log.dateValidated != null;

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
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isClosed ? Colors.green.shade50 : Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                                color: isClosed ? Colors.green.shade300 : Colors.blue.shade200),
                                          ),
                                          child: Text(
                                            log.ncarNo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: isClosed ? Colors.green.shade900 : Colors.blue.shade900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          log.deptSectionUnit,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isClosed ? Colors.green.shade100 : Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            isClosed ? 'Closed' : 'Active / Monitoring',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isClosed ? Colors.green.shade800 : Colors.orange.shade900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Auditee: ${log.auditeeName} • Issued By: ${log.issuedByName} • Date: $dateIssuedStr',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Standard Clause: ${log.itemNoRelevantStandard}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (isClosed)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12),
                                            child: Text(
                                              'Closed: ${log.dateValidated != null ? DateFormat('MMM d, yyyy').format(log.dateValidated!) : 'Yes'}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        else if (log.dateVerified != null)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12),
                                            child: Text(
                                              'Verified: ${DateFormat('MMM d, yyyy').format(log.dateVerified!)}',
                                              style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        if (log.nonconformingActionReportId != null)
                                          OutlinedButton.icon(
                                            onPressed: () => _openNcar(log),
                                            icon: const Icon(Icons.edit_note, size: 18),
                                            label: Text(isClosed ? 'View NCAR' : 'Open NCAR (verify / close)'),
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
          ],
        ),
      ),
    );
  }
}
