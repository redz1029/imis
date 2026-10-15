import 'package:json_annotation/json_annotation.dart';

part 'audit_checklist.g.dart';

// Sentinel so copyWithResponse can tell "not provided" apart from
// "explicitly set to null" (needed to clear the Y/N dropdown).

@JsonSerializable(explicitToJson: true)
class AuditChecklist {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: false)
  final bool isDeleted;

  final String? rowVersion;

  final bool? conforming;
  final String? findingAndRemarks;

  @JsonKey(defaultValue: 0)
  final int auditPlanEntryId;

  @JsonKey(defaultValue: 0)
  final int auditChecklistQNAId;

  // The UNIQUE schedule identifier — the only reliable key used to load a
  // checklist. Never navigate using the team name.
  @JsonKey(defaultValue: 0)
  final int auditScheduleId;

  // The Auditee connection — matches AuditChecklistDto.AuditeeId (the real
  // FK, sent back on save) and AuditeeName (read-only display). The backend
  // supports exactly one auditee per checklist row, not a list.
  final int? auditeeId;
  final String? auditeeName;

  // Read-only display fields derived from the Audit Schedule on the backend —
  // never sent back on save (AuditChecklistDto.ToEntity() ignores them).
  // The team name is only a display value; auditScheduleId is the identity.
  final String? criteria;
  final String? itemsAndQuestions;
  final String? officeProcess;
  final String? teamName;
  final int? teamId;

  // CRMC form header fields sourced from the Audit Schedule.
  final String? auditorNames;
  final String? auditScope;

  // AUDITEE/S is a STRING on the form — never a list of objects.
  final String? auditees;

  const AuditChecklist({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    this.conforming,
    this.findingAndRemarks,
    required this.auditPlanEntryId,
    required this.auditChecklistQNAId,
    this.auditScheduleId = 0,
    this.auditeeId,
    this.auditeeName,
    this.criteria,
    this.itemsAndQuestions,
    this.officeProcess,
    this.teamName,
    this.teamId,
    this.auditorNames,
    this.auditScope,
    this.auditees,
  });

  factory AuditChecklist.fromJson(Map<String, dynamic> json) =>
      _$AuditChecklistFromJson(json);

  Map<String, dynamic> toJson() => _$AuditChecklistToJson(this);

  /// Copy with an updated response — the only two fields a user ever edits.
  /// Pass `conforming: null` to explicitly clear it (matches the dropdown's
  /// blank option); omit the argument entirely to leave it unchanged.
    /// Copy with an updated response. Pass `clearConforming: true` to explicitly
  /// reset Y/N to blank (a plain `conforming: null` means "leave unchanged").
  AuditChecklist copyWithResponse({
    bool? conforming,
    bool clearConforming = false,
    String? findingAndRemarks,
    String? itemsAndQuestions,
  }) {
    return AuditChecklist(
      id: id,
      isDeleted: isDeleted,
      rowVersion: rowVersion,
      auditPlanEntryId: auditPlanEntryId,
      auditChecklistQNAId: auditChecklistQNAId,
      auditScheduleId: auditScheduleId,
      auditeeId: auditeeId,
      auditeeName: auditeeName,
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions ?? this.itemsAndQuestions,
      officeProcess: officeProcess,
      teamName: teamName,
      teamId: teamId,
      auditorNames: auditorNames,
      auditScope: auditScope,
      auditees: auditees,
      conforming: clearConforming ? null : (conforming ?? this.conforming),
      findingAndRemarks: findingAndRemarks ?? this.findingAndRemarks,
    );
  }

  /// Replaces the free-typed auditee string shown on the CRMC form header.
  AuditChecklist copyWithAuditees(String? value) {
    return AuditChecklist(
      id: id,
      isDeleted: isDeleted,
      rowVersion: rowVersion,
      conforming: conforming,
      findingAndRemarks: findingAndRemarks,
      auditPlanEntryId: auditPlanEntryId,
      auditChecklistQNAId: auditChecklistQNAId,
      auditScheduleId: auditScheduleId,
      auditeeId: auditeeId,
      auditeeName: value,
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions,
      officeProcess: officeProcess,
      teamName: teamName,
      teamId: teamId,
      auditorNames: auditorNames,
      auditScope: auditScope,
      auditees: value,
    );
  }

  /// Replaces the selected auditee (single value, matching the backend's
  /// AuditeeId FK). Pass both null to clear the selection.
  AuditChecklist copyWithAuditee({int? auditeeId, String? auditeeName}) {
    return AuditChecklist(
      id: id,
      isDeleted: isDeleted,
      rowVersion: rowVersion,
      conforming: conforming,
      findingAndRemarks: findingAndRemarks,
      auditPlanEntryId: auditPlanEntryId,
      auditChecklistQNAId: auditChecklistQNAId,
      auditScheduleId: auditScheduleId,
      auditeeId: auditeeId,
      auditeeName: auditeeName,
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions,
      officeProcess: officeProcess,
      teamName: teamName,
      teamId: teamId,
      auditorNames: auditorNames,
      auditScope: auditScope,
      auditees: auditeeName ?? auditees,
    );
  }
}

/// One row of the dynamically-generated Checklist LIST page. Backed by Audit
/// Schedule records in schedule order — the team name is purely a display
/// value, `auditScheduleId` is the identity used to load the checklist.
@JsonSerializable()
class AuditChecklistSummary {
  @JsonKey(defaultValue: 0)
  final int auditScheduleId;

  final int? teamId;
  final String? teamName;
  final String? officeProcess;
  final String? auditScope;
  final String? auditorNames;
  final String? auditees;

  @JsonKey(defaultValue: 0)
  final int clauseCount;

  final String? statusName;

  const AuditChecklistSummary({
    this.auditScheduleId = 0,
    this.teamId,
    this.teamName,
    this.officeProcess,
    this.auditScope,
    this.auditorNames,
    this.auditees,
    this.clauseCount = 0,
    this.statusName,
  });

  factory AuditChecklistSummary.fromJson(Map<String, dynamic> json) =>
      _$AuditChecklistSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AuditChecklistSummaryToJson(this);
}