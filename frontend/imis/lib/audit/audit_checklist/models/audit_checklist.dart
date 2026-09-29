import 'package:json_annotation/json_annotation.dart';

part 'audit_checklist.g.dart';

// Sentinel so copyWithResponse can tell "not provided" apart from
// "explicitly set to null" (needed to clear the Y/N dropdown).
const Object _unset = Object();

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

  // The Auditee connection — matches AuditChecklistDto.AuditeeId (the real
  // FK, sent back on save) and AuditeeName (read-only display). The backend
  // supports exactly one auditee per checklist row, not a list.
  final int? auditeeId;
  final String? auditeeName;

  // Read-only display fields derived from AuditPlanEntry on the backend —
  // never sent back on save (AuditChecklistDto.ToEntity() ignores them).
  final String? criteria;
  final String? itemsAndQuestions;
  final String? officeProcess;
  final String? auditTeamName;

  const AuditChecklist({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    this.conforming,
    this.findingAndRemarks,
    required this.auditPlanEntryId,
    required this.auditChecklistQNAId,
    this.auditeeId,
    this.auditeeName,
    this.criteria,
    this.itemsAndQuestions,
    this.officeProcess,
    this.auditTeamName,
  });

  factory AuditChecklist.fromJson(Map<String, dynamic> json) =>
      _$AuditChecklistFromJson(json);

  Map<String, dynamic> toJson() => _$AuditChecklistToJson(this);

  /// Copy with an updated response — the only two fields a user ever edits.
  /// Pass `conforming: null` to explicitly clear it (matches the dropdown's
  /// blank option); omit the argument entirely to leave it unchanged.
  AuditChecklist copyWithResponse({
    Object? conforming = _unset,
    String? findingAndRemarks,
  }) {
    return AuditChecklist(
      id: id,
      isDeleted: isDeleted,
      rowVersion: rowVersion,
      conforming: identical(conforming, _unset)
          ? this.conforming
          : conforming as bool?,
      findingAndRemarks: findingAndRemarks ?? this.findingAndRemarks,
      auditPlanEntryId: auditPlanEntryId,
      auditChecklistQNAId: auditChecklistQNAId,
      auditeeId: auditeeId,
      auditeeName: auditeeName,
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions,
      officeProcess: officeProcess,
      auditTeamName: auditTeamName,
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
      auditeeId: auditeeId,
      auditeeName: auditeeName,
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions,
      officeProcess: officeProcess,
      auditTeamName: auditTeamName,
    );
  }
}