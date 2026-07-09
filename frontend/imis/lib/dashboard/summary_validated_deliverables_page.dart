import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/button_filter.dart';

class PendingAuditRecord {
  final int teamId;
  final String teamName;
  final int officeId;
  final String officeName;
  final String auditorName;
  final int totalAuditCount;
  final String auditProgress;
  final String parentOfficeName;
  final String accomplishedBy;

  const PendingAuditRecord({
    required this.teamId,
    required this.teamName,
    required this.officeId,
    required this.officeName,
    required this.auditorName,
    required this.totalAuditCount,
    required this.auditProgress,
    required this.parentOfficeName,
    required this.accomplishedBy,
  });

  factory PendingAuditRecord.fromJson(Map<String, dynamic> json) {
    return PendingAuditRecord(
      teamId: (json['teamId'] as int?) ?? 0,
      teamName: (json['teamName'] as String?) ?? 'Unknown Team',
      officeId: (json['officeId'] as int?) ?? 0,
      officeName: (json['officeName'] as String?) ?? 'Unknown Office',
      auditorName: (json['auditorName'] as String?) ?? 'Unknown Auditor',
      totalAuditCount: (json['totalAuditCount'] as int?) ?? 0,
      auditProgress: (json['auditProgress'] as String?) ?? '0 out of 0',
      parentOfficeName:
          (json['parentOfficeName'] as String?) ?? 'Unknown Service',
      accomplishedBy: (json['accomplishedBy'] as String?) ?? 'Unknown Head',
    );
  }

  int get completedCount {
    try {
      final parts = auditProgress.split(' out of ');
      return int.tryParse(parts.first) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  int get totalCount {
    try {
      final parts = auditProgress.split(' out of ');
      return int.tryParse(parts.last) ?? 1;
    } catch (e) {
      return 1;
    }
  }
}

class OfficeSummary {
  final int id;
  final String name;
  final int totalAuditCount;
  final String auditProgress;
  final int completedCount;
  final int remainingCount;
  final String parentOfficeName;
  final String accomplishedBy; // NEW
  const OfficeSummary({
    required this.id,
    required this.name,
    required this.totalAuditCount,
    required this.auditProgress,
    required this.completedCount,
    required this.remainingCount,
    required this.parentOfficeName,
    required this.accomplishedBy,
  });

  factory OfficeSummary.fromRecord(PendingAuditRecord r) => OfficeSummary(
    id: r.officeId,
    name: r.officeName,
    totalAuditCount: r.totalAuditCount,
    auditProgress: r.auditProgress,
    completedCount: r.completedCount,
    remainingCount: r.totalAuditCount - r.completedCount,
    parentOfficeName: r.parentOfficeName,
    accomplishedBy: r.accomplishedBy,
  );
}

class TeamSummary {
  final int teamId;
  final String teamName;
  final List<OfficeSummary> offices;
  final List<String> auditorNames;

  int get totalDeliverables => offices.fold(0, (s, o) => s + o.totalAuditCount);
  int get totalAudited => offices.fold(0, (s, o) => s + o.completedCount);
  int get totalPending => offices.fold(0, (s, o) => s + o.remainingCount);
  int get auditedDeptCount => offices.where((o) => o.completedCount > 0).length;

  const TeamSummary({
    required this.teamId,
    required this.teamName,
    required this.offices,
    required this.auditorNames,
  });
}

class PendingAuditService {
  final Dio _dio;
  late final CommonService _commonService;

  PendingAuditService(this._dio) {
    _commonService = CommonService(_dio);
  }

  Future<List<PendingAuditRecord>> fetchPendingAudits({
    int? teamId,
    int? month,
    int? year,
    int? parentOfficeId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (teamId != null) queryParams['teamId'] = teamId;
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;
    if (parentOfficeId != null) queryParams['parentOfficeId'] = parentOfficeId;
    try {
      final response = await AuthenticatedRequest.get(
        _dio,
        ApiEndpoint().pendingAudits,
        queryParameters: queryParams,
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => PendingAuditRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Team>> fetchTeams() => _commonService.fetchTeam();
}

List<TeamSummary> groupRecords(List<PendingAuditRecord> records) {
  final teamMap = <int, Map<String, dynamic>>{};

  for (final r in records) {
    teamMap.putIfAbsent(
      r.teamId,
      () => {
        'teamId': r.teamId,
        'teamName': r.teamName,
        'officesMap': <int, PendingAuditRecord>{},
        'auditorNames': <String>{},
      },
    );

    final t = teamMap[r.teamId]!;
    (t['officesMap'] as Map<int, PendingAuditRecord>)[r.officeId] = r;
    if (r.auditorName.isNotEmpty) {
      (t['auditorNames'] as Set<String>).add(r.auditorName);
    }
  }

  return teamMap.values.map((t) {
    final officesMap = t['officesMap'] as Map<int, PendingAuditRecord>;
    return TeamSummary(
      teamId: t['teamId'] as int,
      teamName: t['teamName'] as String,
      offices:
          officesMap.values.map((r) => OfficeSummary.fromRecord(r)).toList(),
      auditorNames: (t['auditorNames'] as Set<String>).toList(),
    );
  }).toList();
}

class SummaryValidatedDeliverablesPage extends StatefulWidget {
  const SummaryValidatedDeliverablesPage({super.key});

  @override
  State<SummaryValidatedDeliverablesPage> createState() =>
      SummaryValidatedDeliverablesPageState();
}

class SummaryValidatedDeliverablesPageState
    extends State<SummaryValidatedDeliverablesPage> {
  final _service = PendingAuditService(Dio());

  List<TeamSummary> _teams = [];
  List<Team> _allTeams = [];

  bool _isLoading = false;
  bool _isLoadingTeams = false;
  bool _isLoadingService = false;
  String? _error;
  List<Office> serviceList = [];
  int? _selectedMonth;
  int? _selectedServiceId;
  final _commonService = CommonService(Dio());

  int _selectedYear = DateTime.now().year;
  int? _selectedTeamId;

  int get _totalOffices => _teams.fold(0, (s, t) => s + t.offices.length);
  int get _auditedDepts => _teams.fold(0, (s, t) => s + t.auditedDeptCount);
  int get _notAuditedDeptCount {
    return _teams.fold(0, (sum, team) {
      return sum + team.offices.where((o) => o.completedCount == 0).length;
    });
  }

  static const List<String> _monthNamesFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const Color _green = Color(0xFF2E7D32);
  static const Color _greenBg = Color(0xFFE8F5E9);
  static const Color _amberBg = Color(0xFFFFF8E1);
  static const Color _redBg = Color(0xFFFFEBEE);
  static const Color _border = Color(0xFFE0E0E0);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF616161);
  static const Color _textMuted = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    _loadTeams();
    _load();
    _loadService();
  }

  Future<void> _loadTeams() async {
    if (_isLoadingTeams) return;
    setState(() => _isLoadingTeams = true);
    try {
      final teams = await _service.fetchTeams();
      if (mounted) setState(() => _allTeams = teams);
    } catch (e) {
      // silent
    } finally {
      if (mounted) setState(() => _isLoadingTeams = false);
    }
  }

  Future<void> _loadService() async {
    if (_isLoadingService) return;
    setState(() => _isLoadingService = true);
    try {
      final service = await _commonService.fetchService();
      if (mounted) setState(() => serviceList = service);
    } catch (e) {
      // silent
    } finally {
      if (mounted) setState(() => _isLoadingService = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.fetchPendingAudits(
        teamId: _selectedTeamId,
        month: _selectedMonth,
        year: _selectedYear,
        parentOfficeId: _selectedServiceId,
      );
      if (mounted) {
        setState(() {
          _teams = groupRecords(data);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _teams = [];
          _error = 'Failed to load audit data. Pull down to retry.';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _progressColor(int completed, int total) {
    if (total == 0) return kDanger;
    final pct = (completed / total) * 100;
    if (pct >= 80) return _green;
    if (pct >= 50) return kOrange;
    return kDanger;
  }

  Color _progressBg(int completed, int total) =>
      _progressColor(completed, total).withOpacity(0.1);
  Map<String, List<OfficeSummary>> _groupByService(
    List<OfficeSummary> offices,
  ) {
    final grouped = <String, List<OfficeSummary>>{};

    for (final office in offices) {
      grouped.putIfAbsent(office.parentOfficeName, () => []);
      grouped[office.parentOfficeName]!.add(office);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    if (_selectedMonth == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFBFC),
        body: Column(
          children: [
            _buildHeader(),
            _buildFilterBar(isMobile),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 56,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please select Month to display reports',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose a month from the filter above.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(isMobile),
          if (_error != null)
            Container(
              width: double.infinity,
              color: _redBg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 18, color: kDanger),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kDanger,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _load,
                    icon: const Icon(Icons.refresh, size: 18, color: kDanger),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                    : _teams.isEmpty && _error == null
                    ? _buildEmpty()
                    : RefreshIndicator(
                      color: primaryColor,
                      onRefresh: _load,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 12 : 20,
                          16,
                          isMobile ? 12 : 20,
                          24,
                        ),
                        children: [
                          _buildStatsRow(isMobile),
                          const SizedBox(height: 24),

                          ..._teams.map((t) => _buildTeamCard(t, isMobile)),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // ── Header (UNCHANGED) ─────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary Validated Deliverables',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      '${_teams.length} team${_teams.length != 1 ? 's' : ''} · $_totalOffices department${_totalOffices != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedMonth != null) ...[
                IconButton(
                  tooltip: 'Print Preview by Service',
                  onPressed: _isLoading ? null : _openPrintPreviewService,
                  icon: Icon(Icons.print, color: primaryColor, size: 20),
                ),
              ],
              if (_selectedMonth != null) ...[
                IconButton(
                  tooltip: 'Print Preview by Team',
                  onPressed: _isLoading ? null : _openPrintPreview,
                  icon: Icon(Icons.print, color: primaryColor, size: 20),
                ),
              ],
              IconButton(
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : _load,
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                        : const Icon(Icons.refresh, color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _openPrintPreview() async {
    await openPendingAuditsReportPreviewbyTeam(
      teamId: _selectedTeamId,
      auditorId: null,
      officeId: null,
      month: _selectedMonth,
      year: _selectedYear,
      context: context,
    );
  }

  Future<void> _openPrintPreviewService() async {
    await openPendingAuditsReportPreviewByService(
      teamId: _selectedTeamId,
      auditorId: null,
      officeId: null,
      month: _selectedMonth,
      year: _selectedYear,
      parentOfficeId: _selectedServiceId,
      context: context,
    );
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedTeamId = null;
      _selectedMonth = null;
    });
    _load();
  }

  bool get _hasActiveFilters =>
      _selectedTeamId != null || _selectedMonth != null;

  Widget _buildMobileFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Filter by",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textSecondary,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  "Clear",
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ),
          ],
        ),
        SizedBox(height: 38, child: _servicesDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _teamDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _monthDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _yearDropdown()),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              "Filter by",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 13, color: Colors.red.shade400),
                label: Text(
                  "Clear filters",
                  style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _servicesDropdown()),
            const SizedBox(width: 10),
            Expanded(child: _teamDropdown()),
            const SizedBox(width: 10),
            Expanded(child: _monthDropdown()),
            const SizedBox(width: 10),
            Expanded(child: _yearDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _servicesDropdown() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: ["All Services", ...serviceList.map((o) => o.name)],
          selectedItem:
              _selectedServiceId == null
                  ? "All Services"
                  : (serviceList
                          .where((o) => o.id.toString() == _selectedServiceId)
                          .firstOrNull
                          ?.name ??
                      "All Services"),
          hintText: "Service",
          searchHint: "Search services...",
          prefixIcon: Icons.miscellaneous_services,
          onChanged: (value) {
            setState(() {
              if (value == "All Services") {
                _selectedServiceId = null;
              } else {
                final service = serviceList.firstWhere(
                  (t) => t.name == value,
                  orElse: () => Office(id: 0, name: 'name'),
                );
                _selectedServiceId = service.id;
              }
              _load();
            });
          },
        ),
      ),
    );
  }

  Widget _teamDropdown() {
    final teamItems = ["All Teams", ..._allTeams.map((t) => t.name)];

    final selectedTeamName =
        _selectedTeamId == null
            ? "All Teams"
            : _allTeams
                    .where((t) => t.id == _selectedTeamId)
                    .map((t) => t.name)
                    .firstOrNull ??
                "All Teams";

    return SearchableDropdown(
      items: teamItems,
      selectedItem: selectedTeamName,
      hintText: "All Teams",
      searchHint: "Search team...",
      prefixIcon: Icons.groups_outlined,
      onChanged: (value) {
        setState(() {
          if (value == "All Teams") {
            _selectedTeamId = null;
          } else {
            final team = _allTeams.firstWhere(
              (t) => t.name == value,
              orElse: () => Team(0, 'name', true, false),
            );
            _selectedTeamId = team.id;
          }
          _load();
        });
      },
    );
  }

  Widget _monthDropdown() {
    return SearchableDropdown(
      items: _monthNamesFull,
      selectedItem:
          _selectedMonth == null
              ? null // Show hint instead
              : _monthNamesFull[_selectedMonth! - 1],
      hintText: "Select Month", // Required field
      searchHint: "Search month...",
      prefixIcon: Icons.calendar_month_outlined,
      onChanged: (value) {
        setState(() {
          _selectedMonth = _monthNamesFull.indexOf(value) + 1;
          _load();
        });
      },
    );
  }

  Widget _yearDropdown() {
    return SearchableDropdown(
      items: List.generate(5, (i) => (_selectedYear - i).toString()),
      selectedItem: _selectedYear.toString(),
      hintText: "Select Year",
      searchHint: "Search year...",
      prefixIcon: Icons.date_range_outlined,
      onChanged: (value) {
        setState(() {
          _selectedYear = int.parse(value);
          _load();
        });
      },
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    final stats = [
      _StatData(
        label: 'Teams',
        value: '${_teams.length}',
        color: primaryColor,
        bg: primaryColor.withValues(alpha: 0.08),
        icon: Icons.groups_outlined,
      ),
      _StatData(
        label: 'Departments Contributing Deliverables',
        value: '$_totalOffices',
        color: const Color(0xFF1976D2),
        bg: const Color(0xFF1976D2).withOpacity(0.08),
        icon: Icons.apartment_outlined,
      ),
      _StatData(
        label: 'Audited Departments',
        value: '$_auditedDepts',
        color: _green,
        bg: _greenBg,
        icon: Icons.verified_outlined,
      ),
      _StatData(
        label: 'Not Audited Departments',
        value: '$_notAuditedDeptCount',
        color: kDanger,
        bg: _redBg,
        icon: Icons.pending_outlined,
      ),
    ];

    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: isMobile ? 1.6 : 2.2,
      children: stats.map((s) => _StatCard(data: s)).toList(),
    );
  }

  Widget _buildTeamCard(TeamSummary team, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              border: Border(
                bottom: BorderSide(color: _border.withOpacity(0.5)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.group_outlined,
                    color: primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (team.auditorNames.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 22,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: team.auditorNames.length,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: primaryColor.withValues(
                                        alpha: 0.15,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    formatAuditorName(team.auditorNames[i]),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: primaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _MetaBadge(
                      label: '${team.offices.length} assigned departments',
                      color: primaryColor,
                      bg: primaryColor.withValues(alpha: 0.08),
                    ),
                    const SizedBox(height: 6),
                    _MetaBadge(
                      label: '${team.auditedDeptCount} audited',
                      color: team.auditedDeptCount > 0 ? _green : _textMuted,
                      bg:
                          team.auditedDeptCount > 0
                              ? _greenBg
                              : const Color(0xFFF5F5F5),
                      icon:
                          team.auditedDeptCount > 0
                              ? Icons.check_circle_outlined
                              : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DEPARTMENTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _textMuted,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 12),
                ..._groupByService(team.offices).entries.map((serviceEntry) {
                  final serviceName = serviceEntry.key;
                  final departments = serviceEntry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          serviceName,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      ...departments.asMap().entries.map((e) {
                        final isLast = e.key == departments.length - 1;
                        final office = e.value;
                        final maxTotal = team.offices.fold(
                          0,
                          (m, o) =>
                              o.totalAuditCount > m ? o.totalAuditCount : m,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 0),
                          child: _DepartmentRow(
                            office: office,
                            officeHead: office.accomplishedBy,
                            progressColor: _progressColor(
                              office.completedCount,
                              office.totalAuditCount,
                            ),
                            progressBg: _progressBg(
                              office.completedCount,
                              office.totalAuditCount,
                            ),
                            maxDeliverables: maxTotal,
                            isLast: isLast,
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatAuditorName(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _amberBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 56,
              color: Colors.amber.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No audit data found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting the team/month/year filter.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────

class _StatData {
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final IconData icon;

  const _StatData({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.icon,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: data.color.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT SIDE (TEXTS)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: data.color,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE (ICON)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, size: 18, color: data.color),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData? icon;

  const _MetaBadge({
    required this.label,
    required this.color,
    required this.bg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentRow extends StatelessWidget {
  final OfficeSummary office;
  final Color progressColor;
  final Color progressBg;
  final int maxDeliverables;
  final bool isLast;
  final String officeHead;

  const _DepartmentRow({
    required this.office,
    required this.progressColor,
    required this.progressBg,
    required this.maxDeliverables,
    required this.isLast,
    required this.officeHead,
  });

  @override
  Widget build(BuildContext context) {
    final pct =
        maxDeliverables == 0
            ? 0.0
            : (office.totalAuditCount / maxDeliverables).clamp(0.0, 1.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      office.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${office.totalAuditCount} deliverables',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    gap6px,
                    Text(
                      'Head by $officeHead',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 65,
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: const Color(0xFFE8E8E8),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor.withOpacity(0.75),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: progressBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: progressColor.withOpacity(0.2)),
                ),
                child: Text(
                  '${office.auditProgress} audited',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 12, color: Color(0xFFF0F0F0).withOpacity(0.7)),
      ],
    );
  }
}
