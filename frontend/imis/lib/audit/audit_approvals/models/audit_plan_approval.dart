import 'package:json_annotation/json_annotation.dart';

part 'audit_plan_approval.g.dart';

@JsonSerializable()
class AuditPlanApproval {
  int? id;

  @JsonKey(name: 'auditPlanId')
  int auditPlanId;

  // Backend DTO (AuditPlanApprovalDto) intentionally serializes this as
  // "aproverId" (typo) via [JsonPropertyName("aproverId")] — do not "fix"
  // this to "approverId" without updating the backend DTO first, or
  // deserialization will silently fail and approverId will come back 0.
  @JsonKey(name: 'aproverId')
  int approverId;

  String? action;

  DateTime timestamp;

  String? comments;

  bool isDeleted;

  String? rowVersion;

  AuditPlanApproval({
    this.id,
    required this.auditPlanId,
    required this.approverId,
    this.action,
    DateTime? timestamp,
    this.comments,
    this.isDeleted = false,
    this.rowVersion,
  }) : timestamp = timestamp ?? DateTime.now();

  factory AuditPlanApproval.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanApprovalFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanApprovalToJson(this);
}