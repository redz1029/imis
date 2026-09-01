// lib/audit/audit_schedules/pages/audit_schedule_page.dart

// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/audit/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit/audit_schedules/models/auditable_offices.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/audit/audit_schedules/services/audit_schedule_service.dart';
import 'package:imis/audit/audit_plan/services/AuditPlanService.dart';
import 'package:imis/audit/audit_programme/services/audit_programme_service.dart';
import 'package:imis/auditor_team/services/auditor_team_service.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';

class AuditSchedulePage extends StatefulWidget {
  final int? auditPlanId;
  final int? auditScheduleId;

  const AuditSchedulePage({super.key, this.auditPlanId, this.auditScheduleId});

  @override
  State<AuditSchedulePage> createState() => _AuditSchedulePageState();
}

class _AuditSchedulePageState extends State<AuditSchedulePage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final AuditSchedulesService _auditScheduleService = AuditSchedulesService(Dio());
  final AuditPlanService _auditPlanService = AuditPlanService(Dio());
  final AuditProgrammeService _programmeService = AuditProgrammeService(Dio());

  bool _isLoading = true;
  String? _errorMessage;

  int? _resolvedAuditPlanId;
  List<dynamic> _allAuditPlans = [];

  int _scheduleId = 0;
  dynamic _rowVersion;

  final TextEditingController _purposeController = TextEditingController(text: 'Internal Quality Audit');
  final TextEditingController _auditTitleController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final TextEditingController _officeSearchController = TextEditingController();
  final FocusNode _officeSearchFocusNode = FocusNode();
  final List<AuditableOffices> _auditableOffices = [];

  int? _selectedTeamId;

  List<Office> _offices = [];
  List<Team> _teams = [];
  List<AuditorTeam> _auditorTeams = [];
  Map<String, String> _userNameById = {};

  @override
  void initState() {
    super.initState();
    _resolvedAuditPlanId = widget.auditPlanId;
    if (_resolvedAuditPlanId != null) {
      _load();
    } else {
      _loadAuditPlanList();
    }
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _auditTitleController.dispose();
    _officeSearchController.dispose();
    _officeSearchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadAuditPlanList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // ASSUMPTION: list-all endpoint. Add to AuditPlanService if missing.
      // _allAuditPlans = await _auditPlanService.getAllAuditPlans();
    } catch (e) {
      _errorMessage = 'Failed to load Audit Plans: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.wait([
        _fetchMasterOffices(),
        _fetchMasterTeams(),
        _fetchMasterAuditorTeams(),
      ]);

      // Best-effort: pre-fill the Audit Date range from the parent Audit Plan.
      // try {
      //   // ASSUMPTION: getAuditPlanById exists on AuditPlanService (add if missing).
      //   // final plan = await _auditPlanService.getAuditPlanById(_resolvedAuditPlanId!);
      //   if (plan != null) {
      //     final planJson = plan.toJson();
      //     final start = DateTime.tryParse((planJson['startDate'] ?? planJson['StartDate'] ?? '').toString());
      //     final end = DateTime.tryParse((planJson['endDate'] ?? planJson['EndDate'] ?? '').toString());
      //     if (start != null) _startDate = start;
      //     if (end != null) _endDate = end;
      //   }
      // } catch (e) {
      //   debugPrint('Could not pre-fill dates from Audit Plan: $e');
      // }

      if (widget.auditScheduleId != null) {
        final existing = await _auditScheduleService.getAuditScheduleById(widget.auditScheduleId!);
        if (existing != null) {
          _scheduleId = existing.id;
          _rowVersion = existing.rowVersion;
          _purposeController.text = existing.purpose;
          _auditTitleController.text = existing.auditTitle;
          _startDate = existing.startDate;
          _endDate = existing.endDate;

          // AuditSchedules carries `auditorTeams` (a nested AuditorTeam
          // object), not a bare id — the dropdown selects by team, so read
          // teamId off that nested object.
          _selectedTeamId = existing.auditorTeams?.teamId;

          _auditableOffices.addAll(existing.auditableOffices);
        }
      }
    } catch (e) {
      _errorMessage = 'Error loading Audit Schedule: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMasterOffices() async {
    try {
      final offices = await _programmeService.getOffices();
      final seen = <int>{};
      _offices = offices.where((o) => seen.add(o.id)).toList();
    } catch (e) {
      debugPrint('Failed to load offices: $e');
    }
  }

  Future<void> _fetchMasterTeams() async {
    try {
      final teams = await _programmeService.getTeams();
      final seen = <int>{};
      _teams = teams.where((t) => seen.add(t.id)).toList();
    } catch (e) {
      debugPrint('Failed to load teams: $e');
    }
  }

  Future<void> _fetchMasterAuditorTeams() async {
    try {
      final auditorTeamsService = AuditorTeamService(Dio());
      final commonService = CommonService(Dio());

      final teams = await auditorTeamsService.getAuditorTeams();
      final List<User> users = await commonService.fetchUsers();

      _userNameById = {for (final u in users) u.id: u.fullName};
      _auditorTeams = teams;
    } catch (e) {
      debugPrint('Failed to load auditor teams: $e');
    }
  }

  /// Office display name, resolved from the master list by id — the real
  /// AuditableOffices model carries only officeId, no name.
  String _officeName(int officeId) {
    final match = _offices.where((o) => o.id == officeId);
    return match.isNotEmpty ? match.first.name : 'Office #$officeId';
  }

  /// Auditor display name, resolved via userId — the real Auditor model
  /// carries only userId, no name field of its own.
  String _auditorName(Auditor a) => (a.userId != null ? _userNameById[a.userId] : null) ?? 'Unnamed Auditor';

  /// Active, non-deleted auditors for the currently selected team, read
  /// straight from the loaded AuditorTeam list.
  List<Auditor> get _selectedTeamRoster {
    if (_selectedTeamId == null) return const [];
    final match = _auditorTeams.where((t) => t.teamId == _selectedTeamId && t.isActive);
    if (match.isEmpty) return const [];
    final roster = match.first.auditors.where((a) => !a.isDeleted && a.isActive).toList()
      ..sort((a, b) => _auditorName(a).compareTo(_auditorName(b)));
    return roster;
  }

  /// The full AuditorTeam object for the currently selected team — used
  /// directly at save time.
  AuditorTeam? get _selectedAuditorTeam {
    if (_selectedTeamId == null) return null;
    final match = _auditorTeams.where((t) => t.teamId == _selectedTeamId && t.isActive);
    return match.isNotEmpty ? match.first : null;
  }

  void _addOffice(Office office) {
    if (_auditableOffices.any((o) => o.officeId == office.id)) return;
    setState(() {
      _auditableOffices.add(AuditableOffices(
        id: 0,
        auditScheduleId: _scheduleId,
        officeId: office.id,
        isDeleted: false,
      ));
      _officeSearchController.clear();
    });
  }

  // Free-text office entry is not supported: AuditableOfficesDto requires
  // a real OfficeId with no free-text fallback field, so only offices
  // selected from the autocomplete list can be added.

  void _removeOffice(AuditableOffices item) {
    setState(() => _auditableOffices.remove(item));
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) _endDate = _startDate;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _save() async {
    if (_resolvedAuditPlanId == null) return;

    if (_purposeController.text.trim().isEmpty || _auditTitleController.text.trim().isEmpty) {
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: const Text('Purpose and Audit Title are required.'),
      ).show(context);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_scheduleId == 0 ? 'Confirm Save' : 'Confirm Update'),
        content: Text(_scheduleId == 0 ? 'Save this Audit Schedule?' : 'Update this Audit Schedule?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No', style: TextStyle(color: primaryThemeColor))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes', style: TextStyle(color: primaryThemeColor))),
        ],
      ),
    );
    if (confirm != true) return;

    final schedule = AuditSchedules(
      id: _scheduleId,
      purpose: _purposeController.text.trim(),
      auditTitle: _auditTitleController.text.trim(),
      isActive: true,
      isDeleted: false,
      startDate: _startDate,
      endDate: _endDate,
      auditPlanId: _resolvedAuditPlanId!,
      auditorTeams: _selectedAuditorTeam,
      offices: null,
      auditableOffices: List.of(_auditableOffices),
      auditSchduleDetails: const [],
      rowVersion: _rowVersion,
    );

    try {
      await _auditScheduleService.addAuditSchedule(schedule);
      if (!mounted) return;
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: const Text('Audit Schedule saved'),
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      String message = 'Failed to save: $e';
      if (e is DioException && e.response?.data is Map) {
        final errors = (e.response!.data as Map)['errors'] ?? (e.response!.data as Map)['Errors'];
        if (errors is List && errors.isNotEmpty) message = errors.join('\n');
      }
      MotionToast.error(toastAlignment: Alignment.topCenter, description: Text(message)).show(context);
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryThemeColor, fontSize: 11, fontWeight: FontWeight.w600),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: primaryThemeColor, width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text(widget.auditScheduleId == null ? 'Create Audit Schedule' : 'Edit Audit Schedule'),
        backgroundColor: mainBgColor,
        leading: (_resolvedAuditPlanId != null && widget.auditPlanId == null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to list',
                onPressed: () => setState(() {
                  _resolvedAuditPlanId = null;
                  _errorMessage = null;
                  _auditableOffices.clear();
                }),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryThemeColor))
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : _resolvedAuditPlanId == null
                  ? _buildAuditPlanPicker()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAuditeeAndTeamCard(),
                          const SizedBox(height: 16),
                          _buildDetailsCard(),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryThemeColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: _save,
                              child: const Text('SAVE AUDIT SCHEDULE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildAuditPlanPicker() {
    if (_allAuditPlans.isEmpty) {
      return const Center(child: Text('No Audit Plans found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _allAuditPlans.length,
      itemBuilder: (context, i) {
        final p = _allAuditPlans[i];
        final json = p.toJson();
        final id = (json['id'] ?? json['Id']) as int;
        final start = DateTime.tryParse((json['startDate'] ?? json['StartDate'] ?? '').toString());
        final label = start != null ? DateFormat('MMMM d, yyyy').format(start) : 'Audit Plan #$id';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Audit Plan — $label', style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right, color: primaryThemeColor),
            onTap: () {
              setState(() => _resolvedAuditPlanId = id);
              _load();
            },
          ),
        );
      },
    );
  }

  Widget _buildAuditeeAndTeamCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildAuditeeBox()),
        const SizedBox(width: 16),
        Expanded(child: _buildAuditTeamBox()),
      ],
    );
  }

  Widget _buildAuditeeBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AUDITEE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryThemeColor, letterSpacing: 0.5)),
          const Divider(height: 20),
          RawAutocomplete<Office>(
            textEditingController: _officeSearchController,
            focusNode: _officeSearchFocusNode,
            optionsBuilder: (value) {
              if (value.text.trim().isEmpty) return _offices;
              final query = value.text.trim().toLowerCase();
              return _offices.where((o) => o.name.toLowerCase().contains(query));
            },
            displayStringForOption: (o) => o.name,
            onSelected: _addOffice,
            fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textController,
                focusNode: focusNode,
                style: const TextStyle(fontSize: 12),
                decoration: _decoration('ADD OFFICE / WARD').copyWith(
                  hintText: 'Search and select an office',
                  hintStyle: const TextStyle(fontSize: 11),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200, minWidth: 240),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        final option = options.elementAt(i);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Text(option.name, style: const TextStyle(fontSize: 12)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          if (_auditableOffices.isEmpty)
            Text('No offices added yet', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _auditableOffices.map((o) {
                return Chip(
                  label: Text(_officeName(o.officeId), style: const TextStyle(fontSize: 12)),
                  backgroundColor: primaryThemeColor.withValues(alpha: 0.08),
                  labelStyle: const TextStyle(color: primaryThemeColor),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                  onDeleted: () => _removeOffice(o),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAuditTeamBox() {
    final roster = _selectedTeamRoster;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AUDIT TEAM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryThemeColor, letterSpacing: 0.5)),
          const Divider(height: 20),
          DropdownButtonFormField<int>(
            value: _teams.any((t) => t.id == _selectedTeamId) ? _selectedTeamId : null,
            isExpanded: true,
            hint: const Text('Select Team', style: TextStyle(fontSize: 12)),
            decoration: _decoration('TEAM'),
            items: _teams.isEmpty
                ? [const DropdownMenuItem<int>(value: null, child: Text('No options available', style: TextStyle(fontSize: 12)))]
                : _teams
                    .map((t) => DropdownMenuItem<int>(value: t.id, child: Text(t.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))))
                    .toList(),
            onChanged: _teams.isEmpty ? null : (val) => setState(() => _selectedTeamId = val),
          ),
          const SizedBox(height: 10),
          if (_selectedTeamId == null)
            Text('Select a team to view its members', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
          else if (roster.isEmpty)
            Text('No active members found for this team', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: roster
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('•  ${_auditorName(a)}', style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _purposeController,
            style: const TextStyle(fontSize: 13),
            decoration: _decoration('PURPOSE'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _auditTitleController,
            style: const TextStyle(fontSize: 13),
            decoration: _decoration('AUDIT TITLE').copyWith(hintText: 'e.g. Medicine Ward ISO Internal Audit'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickStartDate,
                  child: InputDecorator(
                    decoration: _decoration('AUDIT DATE (START)'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('MMMM d, yyyy').format(_startDate), style: const TextStyle(fontSize: 12)),
                        const Icon(Icons.calendar_today, size: 14, color: primaryThemeColor),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _pickEndDate,
                  child: InputDecorator(
                    decoration: _decoration('AUDIT DATE (END)'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('MMMM d, yyyy').format(_endDate), style: const TextStyle(fontSize: 12)),
                        const Icon(Icons.calendar_today, size: 14, color: primaryThemeColor),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}