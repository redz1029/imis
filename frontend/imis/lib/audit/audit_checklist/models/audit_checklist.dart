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

  // Read-only display fields populated by the backend join — never sent back on save.
  final String? criteria;
  final String? itemsAndQuestions;
  final String? officeProcess;
  final String? auditScope;
  final String? auditTeamName;
  final String? auditees;

  const AuditChecklist({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    this.conforming,
    this.findingAndRemarks,
    required this.auditPlanEntryId,
    required this.auditChecklistQNAId,
    this.criteria,
    this.itemsAndQuestions,
    this.officeProcess,
    this.auditScope,
    this.auditTeamName,
    this.auditees,
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
      criteria: criteria,
      itemsAndQuestions: itemsAndQuestions,
      officeProcess: officeProcess,
      auditScope: auditScope,
      auditTeamName: auditTeamName,
      auditees: auditees,
    );
  }
}