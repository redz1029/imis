import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/iso_standard/models/iso_standard.dart';
import 'package:imis/iso_standard/service/iso_standard_service.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/page_list.dart';
import 'package:intl/intl.dart';

import '../common_services/common_service.dart';
import 'time_picker_widget.dart';

class ProcessItem {
  String processName = "";
  bool isTeam = true;
  String? selectedPerson;
  List<bool> selectedClauses = [false, false, false];
  AuditorTeam? selectedTeam;
}

class Batch {
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime> generatedDays = [];
  List<List<ProcessItem>> dayProcesses = [];
}

const _kAccentLight = Color(0xFFEFF6FF);
const _kAccentSoft = Color(0xFFDBEAFE);
const _kSurface = Color(0xFFFFFFFF);
const _kBg = Color(0xFFF8FAFC);
const _kBorder = Color(0xFFE2E8F0);
const _kBorderFocus = Color.fromARGB(255, 202, 126, 145);
const _kTextPrimary = Color(0xFF0F172A);
const _kTextSecondary = Color(0xFF64748B);
const _kTextMuted = Color.fromARGB(255, 175, 108, 125);
const _kDanger = Color(0xFFEF4444);
const _kDangerLight = Color(0xFFFEF2F2);
const _kSuccess = Color(0xFF10B981);
const _kSuccessLight = Color(0xFFECFDF5);
const _kBadgeBg = Color(0xFFF1F5F9);

class _Label extends StatelessWidget {
  final String text;
  final bool required;
  const _Label(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: _kTextSecondary,
          ),
        ),
        if (required)
          const Text(' *', style: TextStyle(color: _kDanger, fontSize: 12)),
      ],
    ),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _kSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _kBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Label(label, required: true),
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: value != null ? _kAccentLight : _kSurface,
            border: Border.all(
              color: value != null ? primaryColor : _kBorder,
              width: value != null ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.calendar,
                size: 16,
                color: value != null ? primaryColor : _kTextMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value == null
                      ? label
                      : DateFormat('MMM d, yyyy').format(value!),
                  style: TextStyle(
                    fontSize: 13,
                    color: value != null ? _kTextPrimary : _kTextMuted,
                    fontWeight: value != null
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (value != null)
                Icon(Icons.check_circle_rounded, size: 14, color: primaryColor),
            ],
          ),
        ),
      ),
    ],
  );
}

InputDecoration _dropdownDecor(String label) => InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  labelText: label,
  labelStyle: const TextStyle(fontSize: 13, color: _kTextMuted),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
  filled: true,
  fillColor: _kSurface,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _kBorder),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _kBorder),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: primaryColor, width: 1.5),
  ),
);

InputDecoration _searchDecor(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(fontSize: 13, color: _kTextMuted),
  prefixIcon: const Icon(Icons.search, size: 18, color: _kTextMuted),
  filled: true,
  fillColor: _kBg,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _kBorder),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: _kBorder),
  ),
);

// ─── Main dialog ──────────────────────────────────────────────────────────────

void showAuditDialog(BuildContext context) {
  final commonService = CommonService(Dio());
  List<User> userList = [];
  List<AuditorTeam> auditorTeamList = [];
  List<Team> teamList = [];
  List<IsoStandard> clauseTitles = [];
  List<Batch> batches = [Batch()];
  bool hasFetchedData = false;
  bool isLoading = false;

  String getTeamName(int teamId) {
    final team = teamList.firstWhere(
      (t) => t.id == teamId,
      orElse: () => Team(0, 'Unknown Team', true, false),
    );
    return team.name;
  }

  String getFullName(String userId) {
    final user = userList.firstWhere(
      (u) => u.id == userId,
      orElse: () => User(id: '', fullName: 'Unknown', position: ''),
    );
    return user.fullName;
  }

  void generateDays(Batch batch) {
    if (batch.startDate != null && batch.endDate != null) {
      batch.generatedDays.clear();
      batch.dayProcesses.clear();
      for (
        int i = 0;
        i <= batch.endDate!.difference(batch.startDate!).inDays;
        i++
      ) {
        batch.generatedDays.add(batch.startDate!.add(Duration(days: i)));
        batch.dayProcesses.add([ProcessItem()]);
      }
    }
  }

  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (!hasFetchedData) {
            isLoading = true;
            Future.wait([
              commonService.fetchUsers(),
              commonService.fetchAuditorTeam(),
              commonService.fetchTeam(),
              commonService.fetchIso(),
            ]).then((values) {
              setState(() {
                userList = values[0] as List<User>;
                auditorTeamList = values[1] as List<AuditorTeam>;
                teamList = values[2] as List<Team>;
                clauseTitles = (values[3] as List)
                    .map((e) => e as IsoStandard)
                    .toList();

                hasFetchedData = true;
                isLoading = false;
              });
            });
          }

          final isWide = MediaQuery.of(context).size.width > 700;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: isWide ? 40 : 12,
              vertical: 24,
            ),
            child: Container(
              width: isWide ? 860 : double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.92,
              ),
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                    decoration: const BoxDecoration(
                      color: _kSurface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      border: Border(bottom: BorderSide(color: _kBorder)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _kAccentLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            size: 18,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Audit Programme",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _kTextPrimary,
                                ),
                              ),
                              Text(
                                "${batches.length} batch${batches.length != 1 ? 'es' : ''} configured",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _kTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: _kTextSecondary,
                          ),
                          splashRadius: 20,
                          tooltip: "Close",
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // ── Body ──────────────────────────────────────────────────
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: primaryColor,
                                  strokeWidth: 2,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Loading data…",
                                  style: TextStyle(
                                    color: _kTextSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Batches
                                ...batches.asMap().entries.map((entry) {
                                  int batchIndex = entry.key;
                                  Batch batch = entry.value;
                                  List<User> selectedUsers = [];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _BatchCard(
                                      batchIndex: batchIndex,
                                      batch: batch,
                                      isWide: isWide,
                                      auditorTeamList: auditorTeamList,
                                      userList: userList,
                                      clauseTitles: clauseTitles,
                                      selectedUsers: selectedUsers,
                                      getTeamName: getTeamName,
                                      getFullName: getFullName,
                                      generateDays: generateDays,
                                      onDelete: batches.length > 1
                                          ? () => setState(
                                              () =>
                                                  batches.removeAt(batchIndex),
                                            )
                                          : null,
                                      onStateChanged: setState,
                                    ),
                                  );
                                }),

                                // Add Batch
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      setState(() => batches.add(Batch())),
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  label: const Text(
                                    "Add Another Batch",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
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
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: _kSurface,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      border: Border(top: BorderSide(color: _kBorder)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: _kTextSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Save logic here
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Save Programme",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ─── Batch card widget ────────────────────────────────────────────────────────

class _BatchCard extends StatefulWidget {
  final int batchIndex;
  final Batch batch;
  final bool isWide;
  final List<AuditorTeam> auditorTeamList;
  final List<User> userList;
  final List<IsoStandard> clauseTitles;
  final List<User> selectedUsers;
  final String Function(int) getTeamName;
  final String Function(String) getFullName;
  final void Function(Batch) generateDays;
  final VoidCallback? onDelete;
  final StateSetter onStateChanged;

  const _BatchCard({
    required this.batchIndex,
    required this.batch,
    required this.isWide,
    required this.auditorTeamList,
    required this.userList,
    required this.clauseTitles,
    required this.selectedUsers,
    required this.getTeamName,
    required this.getFullName,
    required this.generateDays,
    required this.onDelete,
    required this.onStateChanged,
  });

  @override
  State<_BatchCard> createState() => _BatchCardState();
}

class _BatchCardState extends State<_BatchCard> {
  @override
  Widget build(BuildContext context) {
    final batch = widget.batch;
    final bool hasError =
        batch.startDate != null &&
        batch.endDate != null &&
        batch.endDate!.isBefore(batch.startDate!);

    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Batch header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: const Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Batch ${widget.batchIndex + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (batch.generatedDays.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _kSuccessLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 11,
                          color: _kSuccess,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${batch.generatedDays.length} days",
                          style: const TextStyle(
                            color: _kSuccess,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.trash,
                      size: 16,
                      color: _kDanger,
                    ),
                    tooltip: "Remove batch",
                    splashRadius: 18,
                    onPressed: widget.onDelete,
                    style: IconButton.styleFrom(
                      backgroundColor: _kDangerLight,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
              ],
            ),
          ),

          // Date range + generate
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (widget.isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _DateField(
                          label: "Start Date",
                          value: batch.startDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => batch.startDate = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _DateField(
                          label: "End Date",
                          value: batch.endDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: batch.startDate ?? DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => batch.endDate = picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton.icon(
                        onPressed:
                            (batch.startDate != null &&
                                batch.endDate != null &&
                                !hasError)
                            ? () {
                                setState(() => widget.generateDays(batch));
                                widget.onStateChanged(() {});
                              }
                            : null,
                        icon: const Icon(Icons.auto_awesome_rounded, size: 15),
                        label: const Text(
                          "Generate Days",
                          style: TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _kBorder,
                          disabledForegroundColor: _kTextMuted,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _DateField(
                        label: "Start Date",
                        value: batch.startDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => batch.startDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _DateField(
                        label: "End Date",
                        value: batch.endDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: batch.startDate ?? DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => batch.endDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              (batch.startDate != null &&
                                  batch.endDate != null &&
                                  !hasError)
                              ? () {
                                  setState(() => widget.generateDays(batch));
                                  widget.onStateChanged(() {});
                                }
                              : null,
                          icon: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 15,
                          ),
                          label: const Text("Generate Days"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _kBorder,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                if (hasError) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _kDangerLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _kDanger.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, size: 14, color: _kDanger),
                        SizedBox(width: 6),
                        Text(
                          "End date must be after start date",
                          style: TextStyle(fontSize: 12, color: _kDanger),
                        ),
                      ],
                    ),
                  ),
                ],

                // Generated Days
                if (batch.generatedDays.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(color: _kBorder),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: batch.generatedDays.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _DayTile(
                        index: index,
                        date: batch.generatedDays[index],
                        processes: batch.dayProcesses[index],
                        isWide: widget.isWide,
                        auditorTeamList: widget.auditorTeamList,
                        userList: widget.userList,
                        clauseTitles: widget.clauseTitles,
                        getTeamName: widget.getTeamName,
                        getFullName: widget.getFullName,
                        onStateChanged: setState,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day tile ─────────────────────────────────────────────────────────────────

class _DayTile extends StatefulWidget {
  final int index;
  final DateTime date;
  final List<ProcessItem> processes;
  final bool isWide;
  final List<AuditorTeam> auditorTeamList;
  final List<User> userList;
  final List<IsoStandard> clauseTitles;
  final String Function(int) getTeamName;
  final String Function(String) getFullName;
  final StateSetter onStateChanged;

  const _DayTile({
    required this.index,
    required this.date,
    required this.processes,
    required this.isWide,
    required this.auditorTeamList,
    required this.userList,
    required this.clauseTitles,
    required this.getTeamName,
    required this.getFullName,
    required this.onStateChanged,
  });

  @override
  State<_DayTile> createState() => _DayTileState();
}

class _DayTileState extends State<_DayTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE').format(widget.date);
    final dateStr = DateFormat('MMM d, yyyy').format(widget.date);
    final isWeekend =
        widget.date.weekday == DateTime.saturday ||
        widget.date.weekday == DateTime.sunday;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _expanded ? primaryColor.withValues(alpha: 0.4) : _kBorder,
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // Day header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Day number badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isWeekend
                          ? _kBadgeBg
                          : primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.index + 1}",
                      style: TextStyle(
                        color: isWeekend ? _kTextMuted : primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Day ${widget.index + 1}  ·  $dayName",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: _kTextPrimary,
                              ),
                            ),
                            if (isWeekend) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _kBadgeBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Weekend",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _kTextMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$dateStr  ·  ${widget.processes.length} process${widget.processes.length != 1 ? 'es' : ''}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: _kTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more_rounded,
                      color: _kTextSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_expanded) ...[
            const Divider(height: 1, color: _kBorder),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...widget.processes.asMap().entries.map((entry) {
                    int pIdx = entry.key;
                    ProcessItem process = entry.value;
                    List<User> selectedUsers = [];

                    return _ProcessForm(
                      processIndex: pIdx,
                      process: process,
                      isWide: widget.isWide,
                      auditorTeamList: widget.auditorTeamList,
                      userList: widget.userList,
                      clauseTitles: widget.clauseTitles,
                      selectedUsers: selectedUsers,
                      getTeamName: widget.getTeamName,
                      getFullName: widget.getFullName,
                      onDelete: widget.processes.length > 1
                          ? () {
                              setState(() => widget.processes.removeAt(pIdx));
                              widget.onStateChanged(() {});
                            }
                          : null,
                      onStateChanged: setState,
                    );
                  }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() => widget.processes.add(ProcessItem()));
                        widget.onStateChanged(() {});
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 16,
                        color: primaryColor,
                      ),
                      label: const Text(
                        "Add Process",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Process form ─────────────────────────────────────────────────────────────

class _ProcessForm extends StatefulWidget {
  final int processIndex;
  final ProcessItem process;
  final bool isWide;
  final List<AuditorTeam> auditorTeamList;
  final List<User> userList;
  final List<IsoStandard> clauseTitles;
  final List<User> selectedUsers;
  final String Function(int) getTeamName;
  final String Function(String) getFullName;
  final VoidCallback? onDelete;
  final StateSetter onStateChanged;

  const _ProcessForm({
    required this.processIndex,
    required this.process,
    required this.isWide,
    required this.auditorTeamList,
    required this.userList,
    required this.clauseTitles,
    required this.selectedUsers,
    required this.getTeamName,
    required this.getFullName,
    required this.onDelete,
    required this.onStateChanged,
  });

  @override
  State<_ProcessForm> createState() => _ProcessFormState();
}

class _ProcessFormState extends State<_ProcessForm> {
  @override
  Widget build(BuildContext context) {
    final process = widget.process;
    if (process.selectedClauses.length != widget.clauseTitles.length) {
      process.selectedClauses = List.generate(
        widget.clauseTitles.length,
        (_) => false,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Process header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kBadgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Process ${widget.processIndex + 1}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kTextSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.trash,
                    size: 14,
                    color: _kDanger,
                  ),
                  tooltip: "Remove process",
                  splashRadius: 16,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(backgroundColor: _kDangerLight),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Time + process name
          if (widget.isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label("Start Time"),
                      TimePickerField(
                        label: "Select Time",
                        onTimeSelected: (time) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label(
                        "Organizational Unit & Process",
                        required: true,
                      ),
                      TextField(
                        style: const TextStyle(
                          fontSize: 13,
                          color: _kTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: "e.g. HR Department — Recruitment",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: _kTextMuted,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          filled: true,
                          fillColor: _kSurface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (v) => process.processName = v,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Label("Start Time"),
                TimePickerField(
                  label: "Select Time",
                  onTimeSelected: (time) {},
                ),
                const SizedBox(height: 12),
                const _Label("Organizational Unit & Process", required: true),
                TextField(
                  style: const TextStyle(fontSize: 13, color: _kTextPrimary),
                  decoration: InputDecoration(
                    hintText: "e.g. HR Department — Recruitment",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: _kTextMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    filled: true,
                    fillColor: _kSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: _kBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (v) => process.processName = v,
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Responsibility toggle
          const _Label("Responsibility"),
          Container(
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                _ResponsibilityTab(
                  label: "Audit Team",
                  icon: Icons.group_outlined,
                  selected: process.isTeam,
                  onTap: () => setState(() {
                    process.isTeam = true;
                    process.selectedTeam = null;
                    process.selectedPerson = null;
                  }),
                  isFirst: true,
                ),
                _ResponsibilityTab(
                  label: "Responsible Person",
                  icon: Icons.person_outline,
                  selected: !process.isTeam,
                  onTap: () => setState(() {
                    process.isTeam = false;
                    process.selectedTeam = null;
                    process.selectedPerson = null;
                  }),
                  isFirst: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (process.isTeam) ...[
            DropdownSearch<AuditorTeam>(
              items: widget.auditorTeamList,
              selectedItem: process.selectedTeam,
              itemAsString: (t) => widget.getTeamName(t.teamId),
              onChanged: (v) => setState(() => process.selectedTeam = v),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: _searchDecor("Search team…"),
                ),
                itemBuilder: (_, team, __) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.group_outlined,
                    size: 16,
                    color: primaryColor,
                  ),
                  title: Text(
                    widget.getTeamName(team.teamId),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: _dropdownDecor("Select Team"),
              ),
            ),
            if (process.selectedTeam != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: process.selectedTeam!.auditors.map((a) {
                  return _AuditorChip(
                    label: widget.getFullName(a.userId ?? ''),
                    onDeleted: () => setState(
                      () => process.selectedTeam!.auditors.remove(a),
                    ),
                  );
                }).toList(),
              ),
            ],
          ] else ...[
            DropdownSearch<User?>(
              items: widget.userList,
              selectedItem: null,
              itemAsString: (u) => u?.fullName ?? '',
              onChanged: (v) {
                if (v != null && !widget.selectedUsers.contains(v)) {
                  setState(() => widget.selectedUsers.add(v));
                  widget.onStateChanged(() {});
                }
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: _searchDecor("Search person…"),
                ),
                itemBuilder: (_, user, __) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: primaryColor,
                  ),
                  title: Text(
                    user?.fullName ?? '',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: _dropdownDecor("Select Person"),
              ),
            ),
            if (widget.selectedUsers.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.selectedUsers
                    .map(
                      (u) => _AuditorChip(
                        label: u.fullName,
                        onDeleted: () =>
                            setState(() => widget.selectedUsers.remove(u)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],

          const SizedBox(height: 16),

          // _Label("ISO Standard Clauses"),

          // SizedBox(
          //   height: 150,
          //   child: ListView.builder(
          //     itemCount: widget.clauseTitles.length,
          //     itemBuilder: (context, idx) {
          //       final title = widget.clauseTitles[idx];
          //       final selected = process.selectedClauses[idx];

          //       return InkWell(
          //         onTap: () {
          //           setState(() {
          //             process.selectedClauses[idx] = !selected;
          //           });
          //         },
          //         borderRadius: BorderRadius.circular(6),
          //         child: AnimatedContainer(
          //           duration: const Duration(milliseconds: 150),
          //           margin: const EdgeInsets.only(bottom: 6),
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 12,
          //             vertical: 10,
          //           ),
          //           decoration: BoxDecoration(
          //             color: selected ? _kAccentLight : _kSurface,
          //             borderRadius: BorderRadius.circular(6),
          //             border: Border.all(
          //               color: selected
          //                   ? primaryColor.withAlpha(100)
          //                   : _kBorder,
          //               width: selected ? 1.5 : 1,
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               AnimatedContainer(
          //                 duration: const Duration(milliseconds: 150),
          //                 width: 18,
          //                 height: 18,
          //                 decoration: BoxDecoration(
          //                   color: selected ? primaryColor : Colors.transparent,
          //                   borderRadius: BorderRadius.circular(4),
          //                   border: Border.all(
          //                     color: selected ? primaryColor : _kBorder,
          //                     width: 1.5,
          //                   ),
          //                 ),
          //                 child: selected
          //                     ? const Icon(
          //                         Icons.check_rounded,
          //                         size: 12,
          //                         color: Colors.white,
          //                       )
          //                     : null,
          //               ),
          //               const SizedBox(width: 10),
          //               Expanded(
          //                 child: Text(
          //                   title.description ?? '',
          //                   style: TextStyle(
          //                     fontSize: 13,
          //                     color: selected ? _kTextPrimary : _kTextSecondary,
          //                     fontWeight: selected
          //                         ? FontWeight.w500
          //                         : FontWeight.normal,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          _Label("ISO Standard Clauses"),

          // ensure lengths match
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: widget.clauseTitles.length,
              itemBuilder: (context, idx) {
                final title = widget.clauseTitles[idx];
                final selected = process.selectedClauses[idx];

                return InkWell(
                  onTap: () {
                    setState(() {
                      process.selectedClauses[idx] = !selected;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _kAccentLight : _kSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: selected
                            ? primaryColor.withAlpha(100)
                            : _kBorder,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: selected ? primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: selected ? primaryColor : _kBorder,
                              width: 1.5,
                            ),
                          ),
                          child: selected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title.description ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? _kTextPrimary : _kTextSecondary,
                              fontWeight: selected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Selected clause chips
          if (process.selectedClauses.any((s) => s)) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: process.selectedClauses
                  .asMap()
                  .entries
                  .where((e) => e.value)
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _kAccentLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryColor.withAlpha(80)),
                      ),
                      child: Text(
                        '${widget.clauseTitles[e.key].clauseRef} - ${widget.clauseTitles[e.key].description}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResponsibilityTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isFirst;

  const _ResponsibilityTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: isFirst
            ? const BorderRadius.horizontal(left: Radius.circular(7))
            : const BorderRadius.horizontal(right: Radius.circular(7)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.transparent,
            borderRadius: isFirst
                ? const BorderRadius.horizontal(left: Radius.circular(7))
                : const BorderRadius.horizontal(right: Radius.circular(7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : _kTextSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : _kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuditorChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;
  const _AuditorChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: primaryColor.withValues(alpha: 0.15),
            child: Text(
              label.isNotEmpty ? label[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 9,
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: _kTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
