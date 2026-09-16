// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/audit_programme/models/audit_programme.dart';
import 'package:imis/audit/audit_programme/pages/audit_programme_page.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/build_page_header.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditProgrammeListPage extends StatefulWidget {
  const AuditProgrammeListPage({super.key});

  @override
  State<AuditProgrammeListPage> createState() =>
      _AuditProgrammeListPageState();
}

class _AuditProgrammeListPageState extends State<AuditProgrammeListPage> {
  static const List<String> _statusTabs = [
    'All',
    'Draft',
    'Pending',
    'Approved',
    'Disapproved',
  ];

  final _service = AuditProgrammeService(Dio());

  List<AuditProgramme> _allProgrammes = [];
  String _selectedTab = 'All';
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProgrammes();
  }

  Future<void> _fetchProgrammes() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllAuditProgrammes();
      if (mounted) setState(() => _allProgrammes = data);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          description: Text(
            'Failed to load audit programmes: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _countFor(String tab) {
    if (tab == 'All') return _allProgrammes.length;
    return _allProgrammes.where((p) => p.effectiveStatusName == tab).length;
  }

  List<AuditProgramme> get _filtered {
    if (_selectedTab == 'All') return _allProgrammes;
    return _allProgrammes
        .where((p) => p.effectiveStatusName == _selectedTab)
        .toList();
  }

  List<AuditProgramme> get _paged {
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

  Future<void> _openForm({int? programmeId}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AuditProgrammePage(programmeId: programmeId),
    );
    _fetchProgrammes();
  }

  void _showDeleteDialog(AuditProgramme programme) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Audit Programme',
        itemName: programme.forUser.isNotEmpty
            ? programme.forUser
            : 'this audit programme',
        onDelete: () async {
          Navigator.pop(ctx);
          try {
            await _service.deleteAuditProgramme(programme.id);
            await _fetchProgrammes();
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
              title: 'Audit Programme',
              totalCount: _allProgrammes.length,
              itemLabel: 'programme',
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
                                'For',
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
                                'No audit programmes found',
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
                                final programme = paged[index];
                                final rowNumber =
                                    (_currentPage - 1) * _pageSize + index + 1;
                                final canDelete =
                                    programme.effectiveStatusName == 'Draft';

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
                                            programme.forUser,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            programme.purpose,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: _buildStatusChip(
                                            programme.effectiveStatusName,
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
                                                onPressed: () => _openForm(
                                                  programmeId: programme.id,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons
                                                      .picture_as_pdf_outlined,
                                                  size: 16,
                                                ),
                                                onPressed: () =>
                                                    openAuditProgrammeReportPreview(
                                                      programme.id,
                                                      programme.forUser,
                                                      context: context,
                                                    ),
                                              ),
                                              if (canDelete)
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    size: 16,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () =>
                                                      _showDeleteDialog(
                                                        programme,
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
                                              programme.forUser,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            _buildStatusChip(
                                              programme.effectiveStatusName,
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
                                            _openForm(
                                              programmeId: programme.id,
                                            );
                                          }
                                          if (value == 'pdf') {
                                            openAuditProgrammeReportPreview(
                                              programme.id,
                                              programme.forUser,
                                              context: context,
                                            );
                                          }
                                          if (value == 'delete') {
                                            _showDeleteDialog(programme);
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
                                          if (canDelete)
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
