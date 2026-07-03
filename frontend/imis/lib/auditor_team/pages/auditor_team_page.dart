// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/auditor_team/services/auditor_team_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/widgets/common/icon_button_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/section_label_widget.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditorTeamPage extends StatefulWidget {
  const AuditorTeamPage({super.key});

  @override
  AuditorTeamPageState createState() => AuditorTeamPageState();
}

class AuditorTeamPageState extends State<AuditorTeamPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _adutiorTeamService = AuditorTeamService(Dio());
  final _commonService = CommonService(Dio());
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  late AnimationController _fadeCtrl;

  List<dynamic> auditorTeamList = [];
  List<dynamic> filteredList = [];
  List<Team> teamList = [];
  List<Auditor> auditorList = [];

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _searchFocus.addListener(() => setState(() {}));
    fetchAuditorTeam();

    () async {
      final auditors = await _commonService.fetchAuditors();
      final team = await _commonService.fetchTeam();
      if (!mounted) return;
      setState(() {
        auditorList = auditors;
        teamList = team;
      });
    }();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAuditorTeam({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final pageList = await _adutiorTeamService.getAuditorTeam(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorTeamList = pageList.items;
          filteredList = List.from(auditorTeamList);
        });
        _fadeCtrl.forward(from: 0);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String getTeamNameById(int id, List<Team> teamList) {
    final team = teamList.firstWhere(
      (team) => team.id == id,
      orElse: () => Team(id, 'name', true, false),
    );
    return team.name;
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    final uniqueTeams =
        {for (var item in filteredList) item.teamId: item}.values.toList();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeCtrl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildToolbar(isNarrow, uniqueTeams.length),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                        : uniqueTeams.isEmpty
                        ? _empty()
                        : _list(uniqueTeams),
              ),
              const SizedBox(height: 12),
              _buildPagination(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          isNarrow
              ? FloatingActionButton.extended(
                backgroundColor: primaryColor,
                onPressed: () => showAuditorTeamFormDialog(),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  'Add',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              : null,
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    elevation: 0,
    backgroundColor: kSurface,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 0,
    leading: Padding(padding: const EdgeInsets.all(4)),
    title: Text(
      'Auditor Team Information',
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: kText),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: kBorder),
    ),
  );

  Widget _buildToolbar(bool isNarrow, int teamCount) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorder),
    ),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: TextField(
              focusNode: _searchFocus,
              controller: _searchController,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
              decoration: InputDecoration(
                hintText: 'Search by team or auditor…',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: _searchFocus.hasFocus ? primaryColor : kMuted,
                ),
                filled: true,
                fillColor: kBackground,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        if (!isNarrow) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.groups_rounded, size: 14, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  '$teamCount Teams',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => showAuditorTeamFormDialog(),
            icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
            label: Text(
              'Add Team',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildPagination() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorder),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PaginationInfo(
          currentPage: _currentPage,
          totalItems: _totalCount,
          itemsPerPage: _pageSize,
        ),
        PaginationControls(
          currentPage: _currentPage,
          totalItems: _totalCount,
          itemsPerPage: _pageSize,
          isLoading: _isLoading,
          onPageChanged: (p) => fetchAuditorTeam(page: p),
        ),
        const SizedBox(width: 60),
      ],
    ),
  );

  Widget _list(List<dynamic> uniqueTeams) => ListView.separated(
    itemCount: uniqueTeams.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (ctx, i) {
      final auditorTeam = uniqueTeams[i];
      final auditors = List<Auditor>.from(auditorTeam.auditors);
      final isActive = auditorTeam.isActive == true;

      return _TeamCard(
        teamName: getTeamNameById(auditorTeam.teamId, teamList),
        auditors: auditors,
        isActive: isActive,
        onEdit: () => showAuditorTeamFormDialog(id: auditorTeam.id.toString()),
        onDelete: () => showDeleteDialog(auditorTeam.id.toString()),
      );
    },
  );

  Widget _empty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.groups_rounded,
            size: 40,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No Auditor Teams Found',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create an auditor team to get started.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kMuted),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => showAuditorTeamFormDialog(),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Create First Team',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> showAuditorTeamFormDialog({String? id}) async {
    int? initialTeamId;
    List<Auditor> initialAuditors = [];
    bool initialIsActive = true;

    if (id != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) =>
                Center(child: CircularProgressIndicator(color: primaryColor)),
      );

      try {
        final detail = await _adutiorTeamService.getAuditorTeamById(id);
        initialTeamId = detail.teamId;
        initialIsActive = detail.isActive;
        initialAuditors =
            detail.auditors
                .map(
                  (m) => Auditor(
                    id: m.id,
                    name: m.name,
                    userId: m.userId,
                    isActive: m.isActive,
                    isTeamLeader: m.isTeamLeader,
                    isOfficeHead: m.isOfficeHead,
                    isDeleted: m.isDeleted,
                  ),
                )
                .toList();
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) Navigator.pop(context);
        if (mounted) {
          MotionToast.error(
            toastAlignment: Alignment.topCenter,
            description: Text(
              'Failed to load auditor team',
              style: GoogleFonts.plusJakartaSans(),
            ),
          ).show(context);
        }
        return;
      }
    }

    if (!mounted) return;
    _openAuditorTeamFormDialog(
      id: id,
      teamId: initialTeamId,
      auditors: initialAuditors,
      isActive: initialIsActive,
    );
  }

  void _openAuditorTeamFormDialog({
    String? id,
    int? teamId,
    List<Auditor>? auditors,
    bool isActive = true,
  }) {
    int? selectTeam = teamId;
    List<Auditor> selectedAuditors = auditors ?? [];
    final isEdit = id != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Container(
                width: 480,
                constraints: const BoxConstraints(maxHeight: 700),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            gap12px,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEdit
                                        ? 'Edit Auditor Team'
                                        : 'Create Auditor Team',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    isEdit
                                        ? 'Update the existing team'
                                        : 'Add a new auditor team',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                      ),

                      // Body
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionLabel('Team', Icons.workspaces_outline),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                initialValue: selectTeam,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: kMuted,
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: kText,
                                ),
                                validator:
                                    (v) =>
                                        v == null
                                            ? 'Please choose a team'
                                            : null,
                                decoration: InputDecoration(
                                  hintText: 'Select Team',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: kMuted,
                                  ),
                                  filled: true,
                                  fillColor: kBackground,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 13,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kBorder,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kBorder,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: kDanger,
                                    ),
                                  ),
                                ),
                                items:
                                    teamList
                                        .map(
                                          (team) => DropdownMenuItem<int>(
                                            value: team.id,
                                            child: Text(team.name),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) =>
                                        setDialog(() => selectTeam = value),
                              ),

                              const SizedBox(height: 28),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  sectionLabel(
                                    'Auditors',
                                    Icons.people_alt_rounded,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kPrimaryLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${selectedAuditors.length} added',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (selectedAuditors.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: kBorder),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.group_add_rounded,
                                        size: 32,
                                        color: kMuted,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No auditors added yet',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: kMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: selectedAuditors.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (_, i) {
                                    final auditor = selectedAuditors[i];
                                    return _AuditorRow(
                                      auditor: auditor,
                                      onToggleLeader:
                                          (val) => setDialog(
                                            () => auditor.isTeamLeader = val,
                                          ),
                                      onRemove:
                                          () => setDialog(
                                            () => selectedAuditors.remove(
                                              auditor,
                                            ),
                                          ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    _showAvailableAuditorsDialog(
                                      selectedAuditors,
                                      (auditor) {
                                        setDialog(
                                          () => selectedAuditors.add(auditor),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  label: Text(
                                    'Add Auditor',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: kBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kBorder),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Active',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: kText,
                                          ),
                                        ),
                                        Text(
                                          'Team is currently in use',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: kMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: isActive,
                                      onChanged:
                                          (val) =>
                                              setDialog(() => isActive = val),
                                      activeColor: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          border: const Border(top: BorderSide(color: kBorder)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final confirmed = await _confirm(
                                  ctx,
                                  title:
                                      isEdit
                                          ? 'Confirm Update'
                                          : 'Confirm Save',
                                  body:
                                      isEdit
                                          ? 'Are you sure you want to update this auditor team?'
                                          : 'Are you sure you want to save this auditor team?',
                                  confirmLabel: isEdit ? 'Update' : 'Save',
                                );
                                if (confirmed != true) return;

                                final auditorTeam = AuditorTeam(
                                  id != null ? int.tryParse(id) ?? 0 : 0,
                                  selectTeam ?? 0,
                                  selectedAuditors,
                                  true,
                                  rowVersion: '',
                                  isDeleted: isActive,
                                );

                                try {
                                  await _adutiorTeamService
                                      .createOrUpdateAuditorTeam(auditorTeam);
                                  await fetchAuditorTeam();

                                  if (!mounted) return;
                                  Navigator.of(ctx).pop();

                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text(
                                      isEdit
                                          ? 'Auditor team updated successfully!'
                                          : 'Auditor team created successfully!',
                                    ),
                                  ).show(context);
                                } catch (e, stackTrace) {
                                  debugPrintStack(stackTrace: stackTrace);

                                  if (!mounted) return;
                                  MotionToast.error(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Failed to save: $e'),
                                  ).show(context);
                                }
                              },
                              icon: Icon(
                                isEdit ? Icons.save_rounded : Icons.add_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update Team' : 'Save Team',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _confirm(
    BuildContext ctx, {
    required String title,
    required String body,
    required String confirmLabel,
  }) => showDialog<bool>(
    context: ctx,
    builder:
        (_) => _ConfirmDialog(
          title: title,
          body: body,
          confirmLabel: confirmLabel,
        ),
  );

  void _showAvailableAuditorsDialog(
    List<Auditor> selectedAuditors,
    void Function(Auditor) onSelect,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
            height: 440,
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Auditor',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: kBorder, height: 1),
                Expanded(
                  child: ListView(
                    children:
                        auditorList
                            .where(
                              (auditor) =>
                                  !selectedAuditors.any(
                                    (sel) => sel.id == auditor.id,
                                  ),
                            )
                            .map((auditor) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: kPrimaryLight,
                                  child: Text(
                                    (auditor.name ?? 'A')
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: GoogleFonts.plusJakartaSans(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  auditor.name.toString(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: kText,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.person_add,
                                  color: primaryColor,
                                ),
                                onTap: () {
                                  onSelect(
                                    Auditor(
                                      id: auditor.id,
                                      name: auditor.name,
                                      userId: auditor.userId,
                                      isActive: auditor.isActive,
                                      isTeamLeader: false,
                                      isOfficeHead: auditor.isOfficeHead,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            })
                            .toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: GoogleFonts.plusJakartaSans(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Auditor Team',
            itemName: 'auditor team',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _adutiorTeamService.deleteAuditorTeam(id);
                await fetchAuditorTeam();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Auditor team deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete auditor team',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String teamName;
  final List<Auditor> auditors;
  final bool isActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TeamCard({
    required this.teamName,
    required this.auditors,
    required this.isActive,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final leaders = auditors.where((a) => a.isTeamLeader).length;

    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(color: kCardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.groups_rounded,
              size: 20,
              color: primaryColor,
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  teamName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: kText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? kSuccessLight
                          : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isActive ? kSuccess : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${auditors.length} auditor${auditors.length == 1 ? '' : 's'}'
            '${leaders > 0 ? ' · $leaders leader${leaders == 1 ? '' : 's'}' : ''}',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kMuted),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBtn(
                icon: Icons.edit_rounded,
                tooltip: 'Edit',
                color: primaryTextColor,
                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              IconBtn(
                icon: CupertinoIcons.delete_simple,
                tooltip: 'Delete',
                color: kDanger,
                onTap: onDelete,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, color: kMuted, size: 20),
            ],
          ),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorder),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: auditors.length,
                separatorBuilder:
                    (_, __) => const Divider(height: 1, color: kBorder),
                itemBuilder: (ctx, i) {
                  final a = auditors[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                                a.isTeamLeader
                                    ? kPrimaryLight
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            a.isTeamLeader ? Icons.star_rounded : Icons.person,
                            size: 15,
                            color: a.isTeamLeader ? primaryColor : kMuted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            a.name ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight:
                                  a.isTeamLeader
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              color: kText,
                            ),
                          ),
                        ),
                        if (a.isTeamLeader)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Team Leader',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                      ],
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

// ---------------------------------------------------------------------
// FORM ROW / DIALOGS
// ---------------------------------------------------------------------

class _AuditorRow extends StatelessWidget {
  final Auditor auditor;
  final ValueChanged<bool> onToggleLeader;
  final VoidCallback onRemove;

  const _AuditorRow({
    required this.auditor,
    required this.onToggleLeader,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color:
            auditor.isTeamLeader
                ? primaryColor.withValues(alpha: 0.4)
                : kBorder,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor:
              auditor.isTeamLeader ? primaryColor : Colors.grey.shade300,
          child: Icon(
            auditor.isTeamLeader ? Icons.star_rounded : Icons.person,
            size: 15,
            color: auditor.isTeamLeader ? Colors.white : kMuted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auditor.name ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                auditor.isTeamLeader ? 'Team Leader' : 'Member',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kMuted),
              ),
            ],
          ),
        ),
        Switch(
          value: auditor.isTeamLeader,
          activeColor: primaryColor,
          onChanged: onToggleLeader,
        ),
        IconBtn(
          icon: Icons.close,
          tooltip: 'Remove',
          color: kMuted,
          onTap: onRemove,
          size: 15,
        ),
      ],
    ),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String title, body, confirmLabel;
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
  });

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 380,
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: kText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            body,
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
                  onPressed: () => Navigator.pop(context, false),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    confirmLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
