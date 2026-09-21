// // ignore_for_file: use_build_context_synchronously

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:imis/utils/print_preview_util.dart';
// import 'package:intl/intl.dart';
// import 'package:motion_toast/motion_toast.dart';
// import 'package:imis/audit/audit_plan/models/audit_plan.dart';
// import 'package:imis/audit/audit_plan/pages/audit_plan_page.dart';
// import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
// import 'package:imis/constant/constant.dart';
// import 'package:imis/widgets/common/build_page_header.dart';
// import 'package:imis/widgets/common/pagination_controls.dart';

// class AuditPlanListPage extends StatefulWidget {
//   const AuditPlanListPage({super.key});

//   @override
//   State<AuditPlanListPage> createState() => _AuditPlanListPageState();
// }

// class _AuditPlanListPageState extends State<AuditPlanListPage> {
//   static const List<String> _statusTabs = [
//     'All',
//     'Draft',
//     'Pending',
//     'Approved',
//     'Disapproved',
//   ];

//   final _service = AuditPlanService(Dio());

//   List<AuditPlan> _allPlans = [];
//   String _selectedTab = 'All';
//   int _currentPage = 1;
//   final int _pageSize = 15;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchPlans();
//   }

//   Future<void> _fetchPlans() async {
//     setState(() => _isLoading = true);
//     try {
//       final data = await _service.getAllAuditPlans();
//       if (mounted) setState(() => _allPlans = data);
//     } catch (e) {
//       debugPrint(e.toString());
//       if (mounted) {
//         MotionToast.error(
//           description: Text(
//             'Failed to load audit plans: '
//             '${e.toString().replaceFirst('Exception: ', '')}',
//           ),
//         ).show(context);
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // FIX: AuditPlan.planStatus is a dead field the backend no longer
//   // populates (see the comment on AuditPlan itself). Tab counts must be
//   // driven by the real status, which is auditStatusId/statusName, exposed
//   // here via the effectiveStatusName getter (falls back to 'Draft' when
//   // statusName hasn't been resolved).
//   int _countFor(String tab) {
//     if (tab == 'All') return _allPlans.length;
//     return _allPlans.where((p) => p.effectiveStatusName == tab).length;
//   }

//   List<AuditPlan> get _filtered {
//     if (_selectedTab == 'All') return _allPlans;
//     return _allPlans
//         .where((p) => p.effectiveStatusName == _selectedTab)
//         .toList();
//   }

//   List<AuditPlan> get _paged {
//     final filtered = _filtered;
//     final start = (_currentPage - 1) * _pageSize;
//     if (start >= filtered.length) return [];
//     final end = (start + _pageSize).clamp(0, filtered.length);
//     return filtered.sublist(start, end);
//   }

//   void _selectTab(String tab) {
//     setState(() {
//       _selectedTab = tab;
//       _currentPage = 1;
//     });
//   }

//   /// Mirrors AuditProgrammeListPage._openForm exactly — a modal dialog, not
//   /// a pushed route, so the ISO section's navigation style stays consistent.
//   /// AuditPlanPage requires a programmeId to reload its parent Programme's
//   /// context; AuditPlan already carries that via auditProgrammeId. Passing
//   /// null (no plan) opens AuditPlanPage's own Approved-only Programme picker.
//   Future<void> _openForm({AuditPlan? plan}) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AuditPlanPage(
//         programmeId: plan?.auditProgrammeId,
//         auditPlanId: plan?.id,
//       ),
//     );
//     _fetchPlans();
//   }

//   Future<void> _deletePlan(AuditPlan plan) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Audit Plan'),
//         content: Text(
//           'Are you sure you want to delete Audit Plan #${plan.id}? '
//           'This cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//     if (confirmed != true) return;

//     try {
//       await _service.deleteAuditPlan(plan.id); // <-- must match your service
//       if (!mounted) return;
//       MotionToast.success(
//         description: const Text('Audit plan deleted.'),
//       ).show(context);
//       _fetchPlans();
//     } catch (e) {
//       debugPrint(e.toString());
//       if (mounted) {
//         MotionToast.error(
//           description: Text(
//             'Failed to delete audit plan: '
//             '${e.toString().replaceFirst('Exception: ', '')}',
//           ),
//         ).show(context);
//       }
//     }
//   }

//   Widget _buildStatusChip(String status) {
//     final color = getStatusColor(status);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           getStatusIcon(status),
//           const SizedBox(width: 6),
//           Text(
//             status,
//             style: GoogleFonts.plusJakartaSans(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTab(String tab) {
//     final isActive = tab == _selectedTab;
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () => _selectTab(tab),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           decoration: BoxDecoration(
//             color: isActive ? primaryColor.withValues(alpha: 0.1) : null,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isActive ? primaryColor : kBorder,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 tab,
//                 style: GoogleFonts.plusJakartaSans(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: isActive ? primaryColor : kMuted,
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 6,
//                   vertical: 1,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isActive ? primaryColor : kBorder,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   '${_countFor(tab)}',
//                   style: GoogleFonts.plusJakartaSans(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: isActive ? Colors.white : kMuted,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;
//     final paged = _paged;

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildPageHeader(
//               isMobile: isMobile,
//               title: 'Audit Plan',
//               totalCount: _allPlans.length,
//               itemLabel: 'plan',
//               icon: Icons.event_note_outlined,
//               actionButton: ElevatedButton.icon(
//                 onPressed: () => _openForm(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10,
//                     horizontal: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 icon: const Icon(Icons.add, color: Colors.white),
//                 label: const Text(
//                   'Add New',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: _statusTabs.map(_buildTab).toList(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 10,
//                       color: Colors.black.withValues(alpha: .05),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (!isMobile)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 12,
//                         ),
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 40,
//                               child: Text(
//                                 '#',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: kMuted,
//                                 ),
//                               ),
//                             ),
//                             const Expanded(
//                               flex: 2,
//                               child: Text(
//                                 'Plan',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: kMuted,
//                                 ),
//                               ),
//                             ),
//                             const Expanded(
//                               flex: 3,
//                               child: Text(
//                                 'Date Range',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: kMuted,
//                                 ),
//                               ),
//                             ),
//                             const Expanded(
//                               flex: 2,
//                               child: Text(
//                                 'Status',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: kMuted,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 120,
//                               child: Text(
//                                 'Actions',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   color: kMuted,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     if (!isMobile) const Divider(height: 1, color: kBorder),
//                     Expanded(
//                       child: _isLoading
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                                 color: primaryColor,
//                               ),
//                             )
//                           : paged.isEmpty
//                           ? Center(
//                               child: Text(
//                                 'No audit plans found',
//                                 style: GoogleFonts.plusJakartaSans(
//                                   color: kMuted,
//                                 ),
//                               ),
//                             )
//                           : ListView.separated(
//                               itemCount: paged.length,
//                               separatorBuilder: (context, index) => Divider(
//                                 height: 1,
//                                 color: Colors.grey.withValues(alpha: 0.2),
//                               ),
//                               itemBuilder: (context, index) {
//                                 final plan = paged[index];
//                                 final rowNumber =
//                                     (_currentPage - 1) * _pageSize + index + 1;
//                                 final dateRange =
//                                     '${DateFormat('MMM d, yyyy').format(plan.startDate)} – '
//                                     '${DateFormat('MMM d, yyyy').format(plan.endDate)}';

//                                 if (!isMobile) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12,
//                                       horizontal: 12,
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           width: 40,
//                                           child: Text('$rowNumber'),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                             'Audit Plan #${plan.id}',
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 3,
//                                           child: Text(dateRange),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Align(
//                                             alignment: Alignment.centerLeft,
//                                             // FIX: was plan.planStatus (dead
//                                             // field) — now the real status.
//                                             child: _buildStatusChip(
//                                               plan.effectiveStatusName,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 120,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               IconButton(
//                                                 tooltip: 'Edit',
//                                                 padding: EdgeInsets.zero,
//                                                 constraints:
//                                                     const BoxConstraints(
//                                                   minWidth: 36,
//                                                   minHeight: 36,
//                                                 ),
//                                                 icon: const Icon(
//                                                   Icons.edit_outlined,
//                                                   size: 16,
//                                                 ),
//                                                 onPressed: () =>
//                                                     _openForm(plan: plan),
//                                               ),
//                                               IconButton(
//                                                 tooltip: 'PDF Preview',
//                                                 padding: EdgeInsets.zero,
//                                                 constraints:
//                                                     const BoxConstraints(
//                                                   minWidth: 36,
//                                                   minHeight: 36,
//                                                 ),
//                                                 icon: const Icon(
//                                                   Icons.picture_as_pdf_outlined,
//                                                   size: 16,
//                                                 ),
//                                                 onPressed: () =>
//                                                     openAuditPlanReportPreview(
//                                                   plan.id,
//                                                   context: context,
//                                                 ),
//                                               ),
//                                               if (plan.effectiveStatusName ==
//                                                   'Draft')
//                                                 IconButton(
//                                                   tooltip: 'Delete',
//                                                   padding: EdgeInsets.zero,
//                                                   constraints:
//                                                       const BoxConstraints(
//                                                     minWidth: 36,
//                                                     minHeight: 36,
//                                                   ),
//                                                   icon: const Icon(
//                                                     Icons.delete_outline,
//                                                     size: 16,
//                                                     color: Colors.red,
//                                                   ),
//                                                   onPressed: () =>
//                                                       _deletePlan(plan),
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }

//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 4,
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Audit Plan #${plan.id}',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               dateRange,
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey.shade600,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 5),
//                                             // FIX: was plan.planStatus (dead
//                                             // field) — now the real status.
//                                             _buildStatusChip(
//                                               plan.effectiveStatusName,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       PopupMenuButton<String>(
//                                         color: Theme.of(context).cardColor,
//                                         icon: Icon(
//                                           Icons.more_vert,
//                                           color: Colors.grey.shade500,
//                                         ),
//                                         onSelected: (value) {
//                                           if (value == 'edit') {
//                                             _openForm(plan: plan);
//                                           }
//                                           if (value == 'pdf') {
//                                             openAuditPlanReportPreview(
//                                               plan.id,
//                                               context: context,
//                                             );
//                                           }
//                                         },
//                                         itemBuilder: (_) => [
//                                           const PopupMenuItem(
//                                             value: 'edit',
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.edit_outlined,
//                                                   size: 18,
//                                                 ),
//                                                 SizedBox(width: 8),
//                                                 Text('Edit'),
//                                               ],
//                                             ),
//                                           ),
//                                           const PopupMenuItem(
//                                             value: 'pdf',
//                                             child: Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.picture_as_pdf_outlined,
//                                                   size: 18,
//                                                 ),
//                                                 SizedBox(width: 8),
//                                                 Text('PDF'),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       color: Theme.of(context).cardColor,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           PaginationInfo(
//                             currentPage: _currentPage,
//                             totalItems: _filtered.length,
//                             itemsPerPage: _pageSize,
//                           ),
//                           PaginationControls(
//                             currentPage: _currentPage,
//                             totalItems: _filtered.length,
//                             itemsPerPage: _pageSize,
//                             isLoading: _isLoading,
//                             onPageChanged: (page) =>
//                                 setState(() => _currentPage = page),
//                           ),
//                           const SizedBox(width: 60),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: isMobile
//           ? FloatingActionButton(
//               backgroundColor: primaryColor,
//               onPressed: () => _openForm(),
//               child: const Icon(Icons.add, color: Colors.white),
//             )
//           : null,
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/audit/audit_plan/models/audit_plan.dart';
import 'package:imis/audit/audit_plan/pages/audit_plan_page.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

class AuditPlanListPage extends StatefulWidget {
  const AuditPlanListPage({super.key});

  @override
  State<AuditPlanListPage> createState() => _AuditPlanListPageState();
}

class _AuditPlanListPageState extends State<AuditPlanListPage> {
  static const List<String> _statusTabs = [
    'All',
    'Draft',
    'Pending',
    'Approved',
    'Disapproved',
  ];

  final _service = AuditPlanService(Dio());

  List<AuditPlan> _allPlans = [];
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllAuditPlans();
      if (mounted) setState(() => _allPlans = data);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit plans: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // FIX: AuditPlan.planStatus is a dead field the backend no longer
  // populates (see the comment on AuditPlan itself). Tab counts must be
  // driven by the real status, which is auditStatusId/statusName, exposed
  // here via the effectiveStatusName getter (falls back to 'Draft' when
  // statusName hasn't been resolved).
  int _countFor(String tab) {
    if (tab == 'All') return _allPlans.length;
    return _allPlans.where((p) => p.effectiveStatusName == tab).length;
  }

  List<AuditPlan> get _filtered {
    if (_selectedTab == 'All') return _allPlans;
    return _allPlans
        .where((p) => p.effectiveStatusName == _selectedTab)
        .toList();
  }

  List<AuditPlan> get _paged {
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

  /// Mirrors AuditProgrammeListPage._openForm exactly — a modal dialog, not
  /// a pushed route, so the ISO section's navigation style stays consistent.
  /// AuditPlanPage requires a programmeId to reload its parent Programme's
  /// context; AuditPlan already carries that via auditProgrammeId.
  Future<void> _openForm({AuditPlan? plan}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditPlanPage(
        programmeId: plan?.auditProgrammeId,
        auditPlanId: plan?.id,
      ),
    );
    _fetchPlans();
  }

  Future<void> _deletePlan(AuditPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Audit Plan'),
        content: Text(
          'Are you sure you want to delete Audit Plan #${plan.id}? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteAuditPlan(plan.id); // <-- must match your service
      if (!mounted) return;
      MotionToast.success(
        description: const Text('Audit plan deleted.'),
      ).show(context);
      _fetchPlans();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to delete audit plan: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    }
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
              title: 'Audit Plan',
              totalCount: _allPlans.length,
              itemLabel: 'plan',
              icon: Icons.event_note_outlined,
              actionButton: const SizedBox.shrink(),
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
                                'Plan',
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
                                'No audit plans found',
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
                                final plan = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;
                                final dateRange =
                                    '${DateFormat('MMM d, yyyy').format(plan.startDate)} – '
                                    '${DateFormat('MMM d, yyyy').format(plan.endDate)}';

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
                                            'Audit Plan #${plan.id}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                            // FIX: was plan.planStatus (dead
                                            // field) — now the real status.
                                            child: _buildStatusChip(
                                              plan.effectiveStatusName,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'Edit',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    _openForm(plan: plan),
                                              ),
                                              IconButton(
                                                tooltip: 'PDF Preview',
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                icon: const Icon(
                                                  Icons.picture_as_pdf_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    openAuditPlanReportPreview(
                                                  plan.id,
                                                  context: context,
                                                ),
                                              ),
                                              if (plan.effectiveStatusName ==
                                                  'Draft')
                                                IconButton(
                                                  tooltip: 'Delete',
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 36,
                                                    minHeight: 36,
                                                  ),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      _deletePlan(plan),
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
                                              'Audit Plan #${plan.id}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              dateRange,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            // FIX: was plan.planStatus (dead
                                            // field) — now the real status.
                                            _buildStatusChip(
                                              plan.effectiveStatusName,
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
                                            _openForm(plan: plan);
                                          }
                                          if (value == 'pdf') {
                                            openAuditPlanReportPreview(
                                              plan.id,
                                              context: context,
                                            );
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
                                                  Icons.picture_as_pdf_outlined,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 8),
                                                Text('PDF'),
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