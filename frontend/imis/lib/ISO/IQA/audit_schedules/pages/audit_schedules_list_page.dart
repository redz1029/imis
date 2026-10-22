// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_schedules/pages/audit_schedules_page.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/ISO/IQA/audit_schedules/models/audit_schedules.dart';
import 'package:imis/ISO/IQA/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

class AuditScheduleListPage extends StatefulWidget {
  const AuditScheduleListPage({super.key});

  @override
  State<AuditScheduleListPage> createState() => _AuditScheduleListPageState();
}

class _AuditScheduleListPageState extends State<AuditScheduleListPage> {
  // An Audit Schedule has no Draft stage — it starts at Pending.
  static const List<String> _statusTabs = [
    'All',
    'Pending Confirmation',
    'Confirmed',
    'Revision Required',
    'Rejected',
  ];

  final _service = AuditSchedulesService(Dio());

  List<AuditSchedules> _allSchedules = [];
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAuditSchedules();
      if (mounted) setState(() => _allSchedules = data);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit schedules: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Schedules are ordered by their audit plan, then by their start date, so
  /// the list reads like the printed schedule.
  List<AuditSchedules> get _sortedSchedules {
    final list = [..._allSchedules];
    list.sort((a, b) {
      final planCompare = a.auditPlanId.compareTo(b.auditPlanId);
      if (planCompare != 0) return planCompare;
      final startCompare = a.startDate.compareTo(b.startDate);
      if (startCompare != 0) return startCompare;
      return (a.officeName ?? '').compareTo(b.officeName ?? '');
    });
    return list;
  }

  int _countFor(String tab) {
    final schedules = _sortedSchedules;
    if (tab == 'All') return schedules.length;
    return schedules.where((s) => s.effectiveStatusName == tab).length;
  }

  List<AuditSchedules> get _filtered {
    final schedules = _sortedSchedules;
    if (_selectedTab == 'All') return schedules;
    return schedules
        .where((s) => s.effectiveStatusName == _selectedTab)
        .toList();
  }

  List<AuditSchedules> get _paged {
    final filtered = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    if (start >= filtered.length) return [];
    final end = (start + _pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  void _selectTab(String tab) {
    setState(() {
      _selectedTab = tab;
      _currentPage = 1;
    });
  }

  /// Opens the read-only schedule viewer for the plan the schedule belongs
  /// to, in a modal dialog — same navigation style as
  /// AuditPlanListPage._openForm.
  Future<void> _openSchedule(AuditSchedules schedule) async {
    if (schedule.auditPlanId <= 0) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditSchedulePage(auditPlanId: schedule.auditPlanId),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          getStatusIcon(status),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isActive = tab == _selectedTab;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _selectTab(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? primaryColor.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? primaryColor : kBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tab,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? primaryColor : kMuted,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : kBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_countFor(tab)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : kMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              title: 'Audit Schedule',
              totalCount: _sortedSchedules.length,
              itemLabel: 'schedule',
              icon: Icons.calendar_month_outlined,
              actionButton: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchSchedules,
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
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusTabs.map(_buildTab).toList(),
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
                                'Office',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Audit Plan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Date Range',
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
                              width: 60,
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
                                'No audit schedules found',
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
                                final schedule = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;
                                final dateRange =
                                    '${DateFormat('MMM d, yyyy').format(schedule.startDate)} – '
                                    '${DateFormat('MMM d, yyyy').format(schedule.endDate)}';
                                final officeName =
                                    schedule.officeName?.trim().isNotEmpty == true
                                    ? schedule.officeName!.trim()
                                    : 'Unspecified Office';

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
                                            officeName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Audit Plan #${schedule.auditPlanId}',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(dateRange),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: _buildStatusChip(
                                              schedule.effectiveStatusName,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'View Schedule',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    _openSchedule(schedule),
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
                                              officeName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Audit Plan #${schedule.auditPlanId}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            Text(
                                              dateRange,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            _buildStatusChip(
                                              schedule.effectiveStatusName,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'View Schedule',
                                        icon: Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.grey.shade500,
                                        ),
                                        onPressed: () => _openSchedule(schedule),
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
                            totalItems: _filtered.length,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _filtered.length,
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
    );
  }
}
