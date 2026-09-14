import 'package:json_annotation/json_annotation.dart';

part 'audit_plan_approval.g.dart';

@JsonSerializable()
class AuditPlanApproval {
  int? id;

  @JsonKey(name: 'auditPlanId')
  int auditPlanId;

  @JsonKey(name: 'aproverId')
  String approverId;

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

  Map<String, dynamic> toJson() {
    final json = _$AuditPlanApprovalToJson(this);
    json['id'] = id ?? 0;
    return json;
  }
}