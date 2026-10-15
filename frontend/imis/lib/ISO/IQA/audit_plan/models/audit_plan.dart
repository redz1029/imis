import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_approval_history.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlan {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: false)
  final bool isDeleted;

  final String? rowVersion;

  @JsonKey(defaultValue: 0)
  final int auditProgrammeId;

  // AuditPlanDto.PlanName is `required` on the backend.
  @JsonKey(defaultValue: '')
  final String planName;

  // REMOVED: planStatus / auditStatusId — AuditPlanDto sends neither field
  // anymore. Status is derived server-side from the `signatories` chain
  // below; statusCode/statusName are the only source of truth now.
  final String? statusCode;
  final String? statusName;

  @DateTimeConverter()
  final DateTime startDate;

  @DateTimeConverter()
  final DateTime endDate;

  @JsonKey(fromJson: _entriesFromJson, defaultValue: [])
  final List<AuditPlanEntry> entries;

  // Live approval chain, in signing order. Read-only — never sent back on
  // save (see toJson exclusion below).
  @JsonKey(
    fromJson: _signatoriesFromJson,
    includeToJson: false,
    defaultValue: [],
  )
  final List<IQASignatory> signatories;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final List<IQAApprovalHistory> approvalHistory;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final RejectionDetails? latestRejection;

  const AuditPlan({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    this.auditProgrammeId = 0,
    this.planName = '',
    this.statusCode,
    this.statusName,
    required this.startDate,
    required this.endDate,
    this.entries = const [],
    this.signatories = const [],
    this.approvalHistory = const [],
    this.latestRejection,
  });

  factory AuditPlan.fromJson(Map<String, dynamic> json) {
    final base = _$AuditPlanFromJson(json);
    final history = IQAApprovalHistory.listFromJson(
      json['approvalHistory'] ?? json['ApprovalHistory'],
    );
    RejectionDetails? rej;
    final rejRaw = json['latestRejection'] ?? json['LatestRejection'];
    if (rejRaw is Map<String, dynamic>) {
      rej = RejectionDetails.fromJson(rejRaw);
    } else if (rejRaw is Map) {
      rej = RejectionDetails.fromJson(Map<String, dynamic>.from(rejRaw));
    }

    return AuditPlan(
      id: base.id,
      isDeleted: base.isDeleted,
      rowVersion: base.rowVersion,
      auditProgrammeId: base.auditProgrammeId,
      planName: base.planName,
      statusCode: base.statusCode,
      statusName: base.statusName,
      startDate: base.startDate,
      endDate: base.endDate,
      entries: base.entries,
      signatories: base.signatories,
      approvalHistory: history,
      latestRejection: rej,
    );
  }

  get preparer => null;

  Map<String, dynamic> toJson() => _$AuditPlanToJson(this);

  /// Falls back to "Draft" while a record has no resolved status name.
  String get effectiveStatusName => statusName ?? 'Draft';

  static List<AuditPlanEntry> _entriesFromJson(Object? json) {
    if (json is List) {
      return json.map((e) {
        if (e is AuditPlanEntry) return e;
        if (e is Map<String, dynamic>) return AuditPlanEntry.fromJson(e);
        if (e is Map) return AuditPlanEntry.fromJson(Map<String, dynamic>.from(e));
        return AuditPlanEntry.fromJson(const {});
      }).toList();
    }
    return [];
  }

  static List<IQASignatory> _signatoriesFromJson(Object? json) =>
      IQASignatory.listFromJson(json);
}