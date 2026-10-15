import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/audit/ncar/models/nonconforming_action_report.dart';
import 'package:imis/audit/ncar/services/ncar_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/build_page_header.dart';

class NcarListPage extends StatefulWidget {
  const NcarListPage({super.key});

  @override
  State<NcarListPage> createState() => _NcarListPageState();
}

class _NcarListPageState extends State<NcarListPage> {
  final NcarService _service = NcarService(Dio());

  List<NonconformingActionReport> _allNcars = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  UserRegistration? _currentUser;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _currentUser = await AuthUtil.fetchLoggedUser();
      isAdmin = await AuthUtil.isCurrentUserAdmin();
      final ncars = await _service.getAllNcars();
      if (mounted) {
        setState(() {
          _allNcars = ncars;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MotionToast.error(description: Text('Error loading NCARs: $e')).show(context);
      }
    }
  }

  List<NonconformingActionReport> get _filteredNcars {
    if (_selectedFilter == 'All') return _allNcars;
    if (_selectedFilter == 'Open') return _allNcars.where((n) => !n.isClosed && n.approvedDate == null).toList();
    if (_selectedFilter == 'Under Monitoring') return _allNcars.where((n) => !n.isClosed && n.approvedDate != null).toList();
    if (_selectedFilter == 'Closed') return _allNcars.where((n) => n.isClosed).toList();
    return _allNcars;
  }

  Future<void> _acknowledgeNcar(NonconformingActionReport ncar) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acknowledge NCAR'),
        content: Text('Acknowledge receipt and responsibility for NCAR ${ncar.referenceNumber}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Acknowledge', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final updated = NonconformingActionReport(
        id: ncar.id,
        referenceNumber: ncar.referenceNumber,
        office: ncar.office,
        relevantStandard: ncar.relevantStandard,
        auditDate: ncar.auditDate,
        standardRequirement: ncar.standardRequirement,
        legalOrPolicyReference: ncar.legalOrPolicyReference,
        auditFindings: ncar.auditFindings,
        auditReportId: ncar.auditReportId,
        issuedByAuditorUserId: ncar.issuedByAuditorUserId,
        issuedDate: ncar.issuedDate,
        acknowledgedByAuditeeUserId: _currentUser?.id ?? ncar.acknowledgedByAuditeeUserId,
        acknowledgedDate: DateTime.now(),
        proposedByAuditeeUserId: ncar.proposedByAuditeeUserId,
        proposedDate: ncar.proposedDate,
        approvedByHeadUserId: ncar.approvedByHeadUserId,
        approvedDate: ncar.approvedDate,
        verificationDetails: ncar.verificationDetails,
        verifiedByAuditorUserId: ncar.verifiedByAuditorUserId,
        verifiedDate: ncar.verifiedDate,
        validatedByLeadAuditorUserId: ncar.validatedByLeadAuditorUserId,
        validatedDate: ncar.validatedDate,
        isActive: ncar.isActive,
        isClosed: ncar.isClosed,
      );
      await _service.saveNcar(updated);
      _loadData();
      if (mounted) MotionToast.success(description: const Text('NCAR acknowledged.')).show(context);
    } catch (e) {
      if (mounted) MotionToast.error(description: Text('Failed: $e')).show(context);
    }
  }

  Future<void> _respondNcar(NonconformingActionReport ncar) async {
    final responseController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Office Response - ${ncar.referenceNumber}'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter corrective action plan / proposed response:', style: GoogleFonts.plusJakartaSans(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: responseController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Proposed root cause correction and action plan...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(ctx, responseController.text.trim()),
            child: const Text('Submit Response', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;

    try {
      final updated = NonconformingActionReport(
        id: ncar.id,
        referenceNumber: ncar.referenceNumber,
        office: ncar.office,
        relevantStandard: ncar.relevantStandard,
        auditDate: ncar.auditDate,
        standardRequirement: ncar.standardRequirement,
        legalOrPolicyReference: ncar.legalOrPolicyReference,
        auditFindings: ncar.auditFindings,
        auditReportId: ncar.auditReportId,
        issuedByAuditorUserId: ncar.issuedByAuditorUserId,
        issuedDate: ncar.issuedDate,
        acknowledgedByAuditeeUserId: ncar.acknowledgedByAuditeeUserId,
        acknowledgedDate: ncar.acknowledgedDate ?? DateTime.now(),
        proposedByAuditeeUserId: _currentUser?.id,
        proposedDate: DateTime.now(),
        approvedByHeadUserId: _currentUser?.id,
        approvedDate: DateTime.now(),
        verificationDetails: result,
        verifiedByAuditorUserId: ncar.verifiedByAuditorUserId,
        verifiedDate: ncar.verifiedDate,
        validatedByLeadAuditorUserId: ncar.validatedByLeadAuditorUserId,
        validatedDate: ncar.validatedDate,
        isActive: true,
        isClosed: false,
      );
      await _service.saveNcar(updated);
      await _service.syncFromNcar(
        ncarId: ncar.id,
        deptSectionUnit: ncar.office,
        dateIssued: ncar.issuedDate ?? DateTime.now(),
        issuedByName: ncar.issuedByAuditorName ?? 'Auditor',
        itemNoRelevantStandard: ncar.relevantStandard,
        auditeeName: ncar.acknowledgedByAuditeeName ?? ncar.office,
      );
      _loadData();
      if (mounted) MotionToast.success(description: const Text('Response submitted & synced to monitoring.')).show(context);
    } catch (e) {
      if (mounted) MotionToast.error(description: Text('Failed: $e')).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final ncars = _filteredNcars;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPageHeader(
              isMobile: isMobile,
              title: 'Nonconforming Action Reports (NCAR)',
              totalCount: _allNcars.length,
              itemLabel: 'report',
              icon: Icons.assignment_late_outlined,
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Open', 'Under Monitoring', 'Closed'].map((tab) {
                  final isActive = tab == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isActive,
                      selectedColor: primaryColor.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: isActive ? primaryColor : Colors.grey.shade700,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => setState(() => _selectedFilter = tab),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : ncars.isEmpty
                      ? const Center(child: Text('No NCAR records found.'))
                      : ListView.separated(
                          itemCount: ncars.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final n = ncars[index];
                            final dateStr = DateFormat('MMM d, yyyy').format(n.auditDate);

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
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.red.shade200),
                                          ),
                                          child: Text(
                                            n.referenceNumber.isNotEmpty ? n.referenceNumber : 'NCAR #${n.id}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          n.office,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          n.statusDisplay,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: n.isClosed
                                                ? Colors.green.shade700
                                                : (n.approvedDate != null
                                                    ? Colors.blue.shade700
                                                    : Colors.orange.shade800),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Standard: ${n.relevantStandard} • Audit Date: $dateStr',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                    const SizedBox(height: 6),
                                    Text('Finding: ${n.auditFindings}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13)),
                                    if (n.verificationDetails != null && n.verificationDetails!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text('Corrective Action: "${n.verificationDetails}"',
                                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade700)),
                                    ],
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (n.acknowledgedDate == null)
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                            onPressed: () => _acknowledgeNcar(n),
                                            icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                            label: const Text('Acknowledge', style: TextStyle(color: Colors.white)),
                                          )
                                        else if (!n.isClosed) ...[
                                          OutlinedButton.icon(
                                            onPressed: () => _respondNcar(n),
                                            icon: const Icon(Icons.reply, size: 16),
                                            label: const Text('Respond / Action Plan'),
                                          ),
                                        ],
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
